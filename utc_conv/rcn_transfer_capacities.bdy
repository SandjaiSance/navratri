create or replace package body rcn_transfer_capacities
is
  --
  /***********************************************************************************************************************************
   Purpose    : Net Transfer Capacity for each border and direction (import/ export) per market time unit (MTU) day ahead and intraday.
                BritNed not included.
   Change History
   Date        Author            Version   Description
   ----------  ----------------  -------   -------------------------------------------------------------------------------------------
   02-05-2018  M. Zuijdendorp    01.00.00  Creation
   28-05-2018  M. Zuijdendorp    01.00.01  Toegevoegd: Aanroep parser en opslag data in TCY tabellen
   31-05-2018  X. Pikaar         01.00.02  Expliciet "asc" toegevoegd aan order by
   01-06-2018  M. Zuijdendorp    01.00.03  Functie check_document aangepast voor rijen uit GTT met alleen Reasons en zonder TimeSeries
   31-08-2018  M. Zuijdendorp    01.00.04  TRAN-1951: In Check_document alleen checken als waarde is veranderd t.o.v. vorige rij in de GTT
   14-09-2018  X. Pikaar         01.00.05  Enclosing-if's vervangen in check-functie n.a.v. Sonar melding
   08-01-2019  N. Wenting        01.00.06  TRAN-2467 Verwerking CurveType A03 en controlle toegevoegd
   18-01-2019  X. Pikaar         01.01.00  Algemene document controle toegevoegd. specifieke A03-controle verwijderd, dat zit in deze
                                           controle
   28-01-2019  M. Zuijdendorp    01.01.01  In aanroep van sup_date_actions.convert_any_date2timestamp_utc de naam van de parameter aangepast
   25-09-2019  M. Slobbe         01.01.02  TRAN-2211 aanpassing van packagenaam rcn_parse_cpy_marketdocument
   14-10-2019  M. Zuijdendorp    01.01.03  TRAN-3366 In geval van curvetype A03 werd ptu over alle dagen heen doorgeteld
   01-11-2019  X. Pikaar         01.01.04  TRAN-3493: Loop add_ptu_between stond op de verkeerde plaats waardoor nog niet alle gegevens
                                           van het tcy-record gevuld waren zodat de records niet opgeslagen konden worden
   04-02-2020  R. Standhaft      01.01.05  TRAN-3493: berekening van de cut_offtime voor bepalen INTRADAY of DAY_AHEAD (bij NTC_FINAL)
   04-02-2020  R. Standhaft      01.01.06  TRAN-3493: ophalen van process_id uit globals
   05-02-2020  R. Standhaft      01.01.07  TRAN-3319: gereed maken voor BE/DE (NTC en NTC_FALLBACK, opslaan van in_Domain en out_Domain als BIDDING_ZONE)
   05-02-2020  R. Standhaft      01.01.08  TRAN-3361: vertaling naar diverse capacity-types; checks; overige zodat alle NTC's worden ontvangen en verwerkt
   10-02-2020  X. Pikaar         01.01.09  n.a.v. Sonar de subquery uit cursor c_get_domain verwijderd en vervangen door gewone join
   18-02-2020  X. Pikaar         01.01.10  Bepaling intraday/day-ahead wads niet helemaal goed met de data
   20-02-2020  T. Bakker en      01.01.11  TRAN-3732: publicatie uitsturen na een update DAY_AHEAD
               R. Standhaft
   24-02-2020  R. Standhaft      01.01.12  TRAN-3732 is gewijzigd: publicatie uitsturen bij een DAY_AHEAD
   26-02-2020  R. Standhaft      01.01.13  TRAN-3732: het datum voor de EDP_16_publicatie stond niet goed
   16-03-2020  R. Standhaft      01.01.14  TRAN-3775: verwerking verbeterd (meerdere cursors, apart loopen door document, timeseries en points)
   27-03-2020  M. Walraven       01.01.15  Bugfix op NTC voor control block areas. Hardcoded opgelost, wordt structureel opgepakt in TRAN-3934.
   30-03-2020  T. Bakker         01.01.16  TRAN-3739 Capacity type bepalen uit process_type-parameter van event bericht, wanneer afkomstig uit BE, DE, DK of NO
   31-03-2020  X. Pikaar         01.01.17  TRAN-3739 Capacity_type o.b.v. event-parameter halen, ongeacht de area (zijn we wat flexibeler)
   28-04-2020  X. Pikaar         01.02.00  TRAN-4051 check_document: Controle document-mrid/versie uitgebreid met delivery.
   20-07-2020  M. Walraven       01.02.01  TRAN-4265 Vertaling voor NTC CWE control block codes 10YCB-NL-------V
   22-09-2020  X. Pikaar         01.03.00  TRAN-4286: Diverse info, o.a.doc-mrid/versie toegevoegd aan reception-record
   09-02-2021  R. Koomen         01.04.00  TRAN-4591: LONGTERM_NTC bestanden betreffende de huidige periode resulteren in een publicatie
   25-03-2021  X. Pikaar         01.05.00  Process_id bewaren voor aanroep tmn-packages
   04-06-2021  M. Zuijdendorp    01.05.01  TRAN-4934: EDP_13 en EDP_14 alleen datadriven versturen als NTC reception als process_type 'LONG_TERM' heeft,
                                           zodat er deze niet opgestart wordt als er DAY_AHEAD of INTRADAY berichten binnenkomen.
                                           (hierdoor wordt er niet onnodig vaak gepubliceerd en loopt het versie nummer niet te snel op)
   07-07-2021  M. Zuijdendorp    01.05.02  Vervolg op versie 01.05.01 (Die was niet volledig)
                                           TRAN-5019: EDP_13, EDP_14 en EDP_15 herpubliceren alleen bij LONG_TERM NTC en alleen als er al eerder een publicatie is geweest
   27-08-2021  X. Pikaar         01.06.00  TRAN-5017: process-id bij iedere publucatie opnieuw onthouden en terugzetten omdat iedere
                                           publicatie in zijn eigen proces draait en door het terugzetten het parent_pcs_id ook steeds
                                           weer goed gezet wordt
   10-01-2022  X. Pikaar         01.07.00  Als onderdeel van TRAN-5189: bewaar process_globals en zet ze weer terug na aanroep publicatie
   27-01-2022  X. Pikaar         01.08.00  TRAN-5290: berekening 'ontbrekende' PTU's bij A03 ging fout, waardoor met PTU 1 begonnen werd (terwijl
                                           dat b.v. 7 had moeten zijn). Het is nu ook mogelijk om in een period meerdere points te hebben
   09-02-2022  X. Pikaar         01.08.01  Bepaling ptu's bij A03 curvetype ging niet goed bij PT60M resolutie en periods langer dan 1 dag
   10-02-2022  X. Pikaar         01.08.02  ptu_date_loc werd niet bepaald in de A03-loop
   06-04-2022  X. Pikaar         01.09.00  TRAN-5319: starten EDP_17 toegevoegd. Het starten van alle publicaties verplaatst naar een
                                           aparte procedure om om de code van process_ntc wat compacter te maken
   07-04-2022  X. Pikaar         01.09.01  EDP-16 ook alleen starten als er iets van de te publiceren area(s) binnengekomen is.
   11-05-2022  X. Pikaar         01.10.00  TRAN-5477: Gebruik van constante cn_now vervangen door systimestamp at time zone 'UTC'
   01-06-2022  Y. Krop           01.10.01  TRAN-5261 Verwijzing van pcs_rcn_check_results naar pcs_mge_check_results omgezet.
   30-05-2025  M. Buuts          01.11.00  TRAN-6961: Alleen publiceren als publicatie actief is
   08-05-2026  X. Pikaar         01.12.00  TRAN-8183: process_atc toegevoegd
   01-06-2026  M.Buuts           01.12.01  TRAN-8183: cursor c_timeseries uitgebreid met ts_mrid is not null zodat deze niets opleverd 
                                                      als er geen timeseries aanwezig zijn
   01-07-2026  Nico Klaver       01.13.00  TRAN-8269: Gebruik de global PROCESS_TYPE alleen voor niet NTC_FINAL berichten. 
   06-07-2025  Sandjai Ramasray  01.14.00  TRAN-8243 Correctie foutieve UTC-conversiepatronen.
   ***********************************************************************************************************************************/
  cn_package                     constant  varchar2(30) := 'rcn_transfer_capacities';
  cn_versionnumber               constant  varchar2(10) := '01.14.00';

  -- constanten in deze package
  cn_process_id                  constant  varchar2(30)   := 'PROCESS_ID'   ;
  cn_source_system               constant  varchar2(30)   := 'SOURCE_SYSTEM';
  cn_legal_owner                 constant  varchar2(30)   := 'LEGAL_OWNER'  ;
  cn_ns                          constant  varchar2(4000) := 'xmlns:msg="http://www.tennet.org/msg"';
  cn_process_type                constant  varchar2(20)   := 'PROCESS_TYPE';
  cn_area                        constant  varchar2(20)   := 'AREA';
  cn_document_type               constant  varchar2(30)   := 'DOCUMENT_TYPE';
  cn_codingscheme                constant  varchar2(20)   := 'CODINGSCHEME';
  cn_business_type               constant  varchar2(20)   := 'BUSINESS_TYPE';

  -- Domeinnamen voor de checks
  v_md_sender_mpt_mrid_cs                  sup_ojt_ppy.v_value%type;
  v_md_receiver_mpt_mrid_cs                sup_ojt_ppy.v_value%type;

  -- Cursoren om de data in de global tempory table te benaderen
  cursor c_md_elements
      is select distinct md_mrid
                        ,md_revision_number
                        ,md_type
                        ,md_processtype
                        ,md_sender_mpt_mrid
                        ,md_sender_mpt_mrid_cs
                        ,md_sender_mpt_roletype
                        ,md_receiver_mpt_mrid
                        ,md_receiver_mpt_mrid_cs
                        ,md_receiver_mpt_roletype
                        ,md_created_datetime
                        ,md_time_itl_start
                        ,md_time_itl_end
                        ,md_domain_mrid
                        ,md_domain_mrid_cs
                   from capacity_md_gtt
                  order by md_mrid asc;

  cursor c_timeseries
      is select distinct ts_mrid
                        ,ts_businesstype
                        ,ts_product
                        ,ts_in_domain_mrid
                        ,ts_in_domain_mrid_cs
                        ,ts_out_domain_mrid
                        ,ts_out_domain_mrid_cs
                        ,ts_measure_unit_name
                        ,ts_curvetype
                   from capacity_md_gtt
                  where ts_mrid is not null
                  order by ts_mrid asc;

  cursor c_periods (b_ts_mrid            in varchar2,
                    b_ts_in_domain_mrid  in varchar2)
      is select pd_time_itl_start
               ,pd_time_itl_end
               ,pd_resolution
               ,pt_position
               ,pt_quantity
               ,lead(pt_position) over (order by to_number(pt_position) asc)                   as next_pt_position
           from capacity_md_gtt
          where ts_mrid           = b_ts_mrid
            and ts_in_domain_mrid = b_ts_in_domain_mrid
          order by to_number(pt_position) asc;

  --
  function get_versionnumber
  return varchar2
  is
    /**********************************************************************************************************************
     Purpose    : return package version
    **********************************************************************************************************************/
  begin
    return cn_versionnumber;
  end get_versionnumber;

  --
  function check_document (p_dly_id   in sup_deliveries.id%type)
    return boolean is
     /*********************************************************************************************************************
     Purpose    : Semantische controles document
     *********************************************************************************************************************/
     cn_module                       constant varchar2(61)      := cn_package || '.check_document';
     v_checks_passed                 boolean;
     r_md_elements_previous_row      c_md_elements%rowtype;
     r_timeseries_previous_row       c_timeseries%rowtype;

  begin

    -- write 'Start' into log-trace
     pcs_log_actions.log_trace(p_module => cn_module
                              ,p_text   => 'Start');

     -- Initialiseer
     v_checks_passed                 := true;
     r_md_elements_previous_row      := null;
     r_timeseries_previous_row       := null;

     <<capacitiesdocument>>
     for r_md_elements in c_md_elements
     loop

       -- Check if the received version is newer than the last (if any)
       -- Als waarde niet veranderd is t.o.v. vorige rij in GTT dan is check overbodig
       if (   nvl(r_md_elements.md_mrid,'xx')            <> nvl(r_md_elements_previous_row.md_mrid,'xx')
           or nvl(r_md_elements.md_revision_number,'xx') <> nvl(r_md_elements_previous_row.md_revision_number,'xx')
           or nvl(r_md_elements.md_sender_mpt_mrid,'xx') <> nvl(r_md_elements_previous_row.md_sender_mpt_mrid,'xx')
           )
       and not pcs_mge_checks.check_mrid_version( p_document_mrid    => r_md_elements.md_mrid
                                                , p_document_version => r_md_elements.md_revision_number
                                                , p_sender_mrid      => r_md_elements.md_sender_mpt_mrid
                                                , p_dly_id           => p_dly_id
                                                )
       then
         v_checks_passed := false;
       end if;

       -- Check if sender mRID is a valid EIC-code
       -- Als waarde niet veranderd is t.o.v. vorige rij in GTT dan is check overbodig
       if  nvl(r_md_elements.md_sender_mpt_mrid,'xx') <> nvl(r_md_elements_previous_row.md_sender_mpt_mrid,'xx')
       and not pcs_mge_checks.check_eiccode( p_eiccode  => r_md_elements.md_sender_mpt_mrid)
       then
         v_checks_passed := false;
       end if;

       -- Check domain value for sender mrid codingscheme
       -- Als waarde niet veranderd is t.o.v. vorige rij in GTT dan is check overbodig
       if  nvl(r_md_elements.md_sender_mpt_mrid_cs,'xx') <> nvl(r_md_elements_previous_row.md_sender_mpt_mrid_cs,'xx')
       and not pcs_mge_checks.check_domain_value( p_domain => v_md_sender_mpt_mrid_cs
                                                , p_value  => r_md_elements.md_sender_mpt_mrid_cs)
       then
         v_checks_passed := false;
       end if;

       -- Check if receiver mRID is a valid EIC-code
       -- Als waarde niet veranderd is t.o.v. vorige rij in GTT dan is check overbodig
       if  nvl(r_md_elements.md_receiver_mpt_mrid,'xx') <> nvl(r_md_elements_previous_row.md_receiver_mpt_mrid,'xx')
       and not pcs_mge_checks.check_eiccode( p_eiccode  => r_md_elements.md_receiver_mpt_mrid)
       then
         v_checks_passed := false;
       end if;

       -- Check domain value for receiver mrid codingscheme
       -- Als waarde niet veranderd is t.o.v. vorige rij in GTT dan is check overbodig
       if  nvl(r_md_elements.md_receiver_mpt_mrid_cs,'xx') <> nvl(r_md_elements_previous_row.md_receiver_mpt_mrid_cs,'xx')
       and not pcs_mge_checks.check_domain_value( p_domain => v_md_receiver_mpt_mrid_cs
                                                 , p_value  => r_md_elements.md_receiver_mpt_mrid_cs)
       then
         v_checks_passed := false;
       end if;

       -- Check if MarketDocument domain mRID is a valid EIC-code
       -- Als waarde niet veranderd is t.o.v. vorige rij in GTT dan is check overbodig
       if  nvl(r_md_elements.md_domain_mrid,'xx') <> nvl(r_md_elements_previous_row.md_domain_mrid,'xx')
       and not pcs_mge_checks.check_eiccode( p_eiccode  => r_md_elements.md_domain_mrid)
       then
         v_checks_passed := false;
       end if;

       r_md_elements_previous_row := r_md_elements;

     end loop capacitiesdocument;

     -- Check TimeSeries
     <<timeseries>>
     for r_timeseries in c_timeseries
     loop

       -- Check if TimeSeries in_domain mRID is a valid EIC-code
       -- Als waarde niet veranderd is t.o.v. vorige rij in GTT dan is check overbodig
       if  nvl(r_timeseries.ts_in_domain_mrid,'xx') <> nvl(r_timeseries_previous_row.ts_in_domain_mrid,'xx')
       and not pcs_mge_checks.check_eiccode( p_eiccode  => r_timeseries.ts_in_domain_mrid)
       then
         v_checks_passed := false;
       end if;

       -- Check if TimeSeries out_domain mRID is a valid EIC-code
       -- Als waarde niet veranderd is t.o.v. vorige rij in GTT dan is check overbodig
       if  nvl(r_timeseries.ts_out_domain_mrid,'xx') <> nvl(r_timeseries_previous_row.ts_out_domain_mrid,'xx')
       and not pcs_mge_checks.check_eiccode( p_eiccode  => r_timeseries.ts_out_domain_mrid)
       then
         v_checks_passed := false;
       end if;

       r_timeseries_previous_row := r_timeseries;

     end loop timeseries;

    -- write 'End' into log-trace
     pcs_log_actions.log_trace(p_module => cn_module
                              ,p_text   => 'End' || chr(13) || 'result: ' || case
                                              when v_checks_passed then
                                               'true'
                                              else
                                               'false'
                                           end);
     return v_checks_passed;

  exception
     when others then
        pcs_log_actions.log_error(p_module => cn_module);
        return false;

  end check_document;

  procedure start_publications(p_period_timeinterval    in date
                              ,p_capacity_type          in varchar2
                              ,p_delivery_code          in varchar2
                              ,p_bvalidity_utc_from     in pcs_rcn_receptions.bvalidity_utc_from%type
                              ,p_bvalidity_utc_to       in pcs_rcn_receptions.bvalidity_utc_to%type
                              ,p_publish_edp_16         in boolean
                              ,p_publish_edp_17         in boolean
                              )
  is
    cn_module                constant varchar2(61) := cn_package || '.start_publications';

    v_pbn_date_utc_from                     date;
    v_pbn_date_utc_to                       date;
    v_tmn_mrid                              pcs_tmn_transmissions.mrid%type;
    v_tmn_version                           pcs_tmn_transmissions.version%type;
    v_pcs_id                                pcs_processes.id%type;

  begin
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start'
                             || chr(13)|| 'p_period_timeinterval: ' || to_char(p_period_timeinterval,'dd-mm-yyyy hh24:mi:ss'));


    -- Bewaar de process-globals voor de publicaties
    v_pcs_id                   := sup_globals.get_global_number(p_name => cn_process_id);
    sup_globals.save_process_globals;

    -- aanroepen van de publicatie EDP_16 en EDP_17 - alleen bij capacity_type = DAY_AHEAD
    if p_capacity_type = 'NET_TRANSFER_CAPACITY_DAY_AHEAD'
    then
      if  p_publish_edp_16
      and sup_psh_actions.is_pbn_active(p_pbn_name     => 'EDP_16'
                                       ,p_pbn_date_utc => p_period_timeinterval) then
         tmn_edp_16.start_publication(p_pbn_date_utc   => p_period_timeinterval);
      end if;

      if  p_publish_edp_17
      and sup_psh_actions.is_pbn_active(p_pbn_name     => 'EDP_17'
                                       ,p_pbn_date_utc => p_period_timeinterval) then
         tmn_edp_17.start_publication(p_pbn_date_utc   => p_period_timeinterval);
      end if;

      -- Zet alleen het pcs_id terug zodat volgende publicaties met het juiste parent_pcs_id gestart worden
      sup_globals.set_global(p_name  => cn_process_id
                            ,p_value => v_pcs_id);
    end if;

    --TRAN-4591: LONGTERM_NTC bestanden betreffende de huidige periode resulteren in een publicatie
    --TRAN-4934: delivery_code like '%NTC%' en process_type = 'LONG_TERM'
    if  p_bvalidity_utc_to   >= sup_date_actions.convert_localtimestamp2utcdate(trunc(sysdate+1))
    and p_bvalidity_utc_from <= sup_date_actions.convert_localtimestamp2utcdate(add_months(trunc(sysdate,'YEAR'),12))
    and p_delivery_code like '%NTC%'
    and p_capacity_type like '%LONG_TERM'
    then
      -- Alleen herpubliceren als er al een transmission bestaat met berekende mrid
      tmn_utilities.get_period_to_publish(p_publication       => 'EDP_13'
                                         ,p_pbn_date_utc      => p_period_timeinterval
                                         ,p_pbn_date_utc_from => v_pbn_date_utc_from
                                         ,p_pbn_date_utc_to   => v_pbn_date_utc_to
                                         );
      tmn_utilities.get_mrid(p_publication      => 'EDP_13'
                            ,p_pbn_date_utc     => v_pbn_date_utc_from
                            ,p_tmn_mrid         => v_tmn_mrid
                            ,p_tmn_next_version => v_tmn_version
                            );
     if v_tmn_version > 1
        and sup_psh_actions.is_pbn_active(p_pbn_name     => 'EDP_13'
                                         ,p_pbn_date_utc => p_period_timeinterval)
     then
        tmn_edp_13.start_publication(p_pbn_date_utc => p_period_timeinterval);

        -- Zet alleen het pcs_id terug zodat volgende publicaties met het juiste parent_pcs_id gestart worden
        sup_globals.set_global(p_name  => cn_process_id
                              ,p_value => v_pcs_id);
      end if;
    end if;

    if  p_bvalidity_utc_to   >= sup_date_actions.convert_localtimestamp2utcdate(trunc(sysdate+1))
    and p_bvalidity_utc_from <= sup_date_actions.convert_localtimestamp2utcdate(add_months(trunc(sysdate,'MONTH'),1))
    and p_delivery_code like '%NTC%'
    and p_capacity_type like '%LONG_TERM'
    then
      -- Alleen herpubliceren als er al een transmission bestaat met berekende mrid
      tmn_utilities.get_period_to_publish(p_publication       => 'EDP_14'
                                         ,p_pbn_date_utc      => p_period_timeinterval
                                         ,p_pbn_date_utc_from => v_pbn_date_utc_from
                                         ,p_pbn_date_utc_to   => v_pbn_date_utc_to
                                         );
      tmn_utilities.get_mrid(p_publication      => 'EDP_14'
                            ,p_pbn_date_utc     => v_pbn_date_utc_from
                            ,p_tmn_mrid         => v_tmn_mrid
                            ,p_tmn_next_version => v_tmn_version
                            );
     if v_tmn_version > 1
        and sup_psh_actions.is_pbn_active(p_pbn_name     => 'EDP_14'
                                         ,p_pbn_date_utc => p_period_timeinterval)
      then
        tmn_edp_14.start_publication(p_pbn_date_utc => p_period_timeinterval);

        -- Zet alleen het pcs_id terug zodat volgende publicaties met het juiste parent_pcs_id gestart worden
        sup_globals.set_global(p_name  => cn_process_id
                              ,p_value => v_pcs_id);
      end if;
    end if;

    if  p_bvalidity_utc_to   >= sup_date_actions.convert_localtimestamp2utcdate(trunc(sysdate+1))
    and p_bvalidity_utc_from <= sup_date_actions.convert_localtimestamp2utcdate(trunc(sysdate,'IW')+7)
    and p_delivery_code like '%NTC%'
    and p_capacity_type like '%LONG_TERM'
    then
      -- Alleen herpubliceren als er al een transmission bestaat met berekende mrid
      tmn_utilities.get_period_to_publish(p_publication       => 'EDP_15'
                                         ,p_pbn_date_utc      => p_period_timeinterval
                                         ,p_pbn_date_utc_from => v_pbn_date_utc_from
                                         ,p_pbn_date_utc_to   => v_pbn_date_utc_to
                                         );
      tmn_utilities.get_mrid(p_publication      => 'EDP_15'
                            ,p_pbn_date_utc     => v_pbn_date_utc_from
                            ,p_tmn_mrid         => v_tmn_mrid
                            ,p_tmn_next_version => v_tmn_version
                            );
      if v_tmn_version > 1
         and sup_psh_actions.is_pbn_active(p_pbn_name     => 'EDP_15'
                                          ,p_pbn_date_utc => p_period_timeinterval)
      then
        tmn_edp_15.start_publication(p_pbn_date_utc => p_period_timeinterval);

      end if;
    end if;

    -- zet alle globals weer terug
    sup_globals.restore_process_globals(p_pcs_id => v_pcs_id);

    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End');
  exception
     when others then
        pcs_log_actions.log_error(p_module => cn_module);
        raise;
  end start_publications;

  procedure process_ntc(p_result         out varchar2
                       ,p_xml            in  xmltype
                       ,p_delivery       in  varchar2
                       ,p_enqueue_time   in  timestamp
                       )
  is
  /*********************************************************************************************************************
   Purpose    : Verwerk een Net Transfer Capacities bericht
                Bericht bestaat in hoofdlijnen uit:
                - Hoofddocument
                  - 0..n Timeseries met          mRID of the measurement-point.
   Verwerking:
   *********************************************************************************************************************/
    cn_module                     constant  varchar2(61)   := cn_package || '.process_ntc';
    cn_viewpoint_area             constant  varchar2(25)   := 'VIEWPOINT_AREA';
    cn_capacity_type              constant  varchar2(25)   := 'CAPACITY_TYPE';

    -- verwerking
    v_rcn_id                                pcs_rcn_receptions.id%type;
    v_legal_owner                           sup_deliveries.legal_owner%type;
    v_cre_source                            sup_deliveries.source%type;
    v_content_xml                           xmltype;

    -- row types
    r_dly                                   sup_deliveries%rowtype;
    r_tcy                                   tcy_transfer_capacities%rowtype;
    r_cpy                                   tcy_capacities%rowtype;
    r_rcn                                   pcs_rcn_receptions%rowtype;

    -- variabelen
    v_ptu_interval                          sup_date_actions.rt_interval;
    v_ptu_interval_loop                     sup_date_actions.rt_interval;
    v_interval_in_minutes                   number(10);
    v_ptu                                   number(5);
    v_loop_position                         number(5);
    v_amount_ptus_to_add                    number(10);
    v_capacity_type                         varchar2(50);
    v_value_meaning                         varchar2(10);
    v_end_time                              timestamp;
    v_publish_edp_16                        boolean;
    v_publish_edp_17                        boolean;

    -- parameters
    v_param_process_type                    varchar2(50);
    v_param_area                            varchar2(10);

    -- voor berekening van de cut-offtime
    v_created_date_time                     timestamp;
    v_period_timeinterval                   timestamp;
    v_created_date                          date;
    v_period_date                           date;

    -- haal "tvalidity_utc_from" ( = event_created_date_time) uit tabel "pcs_rcn_states"
    --                (gezet door een voorafgaand event-bericht met hetzelfde process_id)
    cursor c_event_date (b_pcs_id number) is
      select distinct first_value(st.tvalidity_utc_from) over (order by st.tvalidity_utc_from asc)
        from pcs_rcn_states st
       where st.state   = 'SUPPLIED'
         and st.pcs_id  = b_pcs_id;

    -- haal voor een domein_mRID de bijbehorende BIDDING_ZONE op
    cursor c_get_domain (b_domain_mrid varchar2) is
     select distinct k_code
       from (select ara.k_code      as k_code  -- misschien is b_domain_mrid een BIDDING_ZONE -> gebruik deze
               from mrd_ara_areas_vw ara
              where ara.k_code        = decode(b_domain_mrid
                                             , '10YCB-NL-------V', '10YNL----------L'
                                             , '10YCB-BE-------T', '10YBE----------2'
                                             , b_domain_mrid)
                and ara.k_object_type = 'BIDDING_ZONE')
      union
            (select caa1.k_two_code as k_code -- misschien is b_domain_mrid een CONTROL_BLOCK -> haal de BIDDING_ZONE op
               from mrd_caa_crossareas_vw caa1
                           join mrd_caa_crossareas_vw caa2 on caa1.k_code = caa2.k_code
              where caa1.k_two_object_type  = 'BIDDING_ZONE'
                and caa2.k_two_code         = b_domain_mrid
                and caa2.k_two_object_type  = 'CONTROL_BLOCK');

  begin

    -- write 'Start' into log-trace
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start');

    -- domeinnamen voor de checks
    v_md_sender_mpt_mrid_cs                := p_delivery||'.MD_SENDER_MPT_MRID_CS';
    v_md_receiver_mpt_mrid_cs              := p_delivery||'.MD_RECEIVER_MPT_MRID_CS';

    v_publish_edp_16                       := false;
    v_publish_edp_17                       := false;

    /*********************************************************************************************************************
     Initieer de nieuwe reception door een pcs_rcn_reception-record aan te maken en de eerste status te schrijven
     Het zou logisch klinken om dat in de xml-handler te doen, maar we willen registratie van data-receptions scheiden
     van acknowledgements.
     *********************************************************************************************************************/
    v_rcn_id := pcs_rcn_actions.initiate_new_pct_reception (p_xml          => p_xml
                                                           ,p_delivery     => p_delivery
                                                           ,p_enqueue_time => p_enqueue_time
                                                           ,p_start_time   => SYS_EXTRACT_UTC(SYSTIMESTAMP));

    -- == BEGIN Zet de hele context in Delphi
    -- Bepaal ahv de reception het source_system en de legal_owner
    pcs_rcn_actions.get_delivery(p_rcn_id  => v_rcn_id
                                ,p_dly_row => r_dly
                                );

    v_legal_owner := r_dly.legal_owner;
    v_cre_source  := r_dly.source;

    -- Zet de globals met info die we inmiddels ook hebben
    sup_globals.set_global(p_name  => cn_source_system
                          ,p_value => v_cre_source);
    sup_globals.set_global(p_name  => cn_legal_owner
                          ,p_value => v_legal_owner);

    -- Vul pcs_pcs_processes aan met extra info
    pcs_pcs_actions.update_process(p_cre_source  => v_cre_source
                                  ,p_legal_owner => v_legal_owner);
    -- == EINDE Zet de hele context in Delphi

    -- Doe algemene document-controle
    if sup_mge_checks.check_valid_document(p_xml  => p_xml)
    then
       -- == BEGIN Parse het document; Het NTC bericht heeft geen TenneT-any header.
       v_content_xml           := p_xml.extract('//msg:message/msg:content/*',cn_ns);

       if v_content_xml is null
       then
         -- Dit is het geval bij een bericht zonder TenneT-any header
         v_content_xml         := p_xml;
       end if;

       -- Parse de xml-nodes naar de global temporary table resourcemapping_md_gtt
       rcn_parse_transfer_capacity_md.parse_document(p_xml => v_content_xml);
       -- == EINDE Parse het document


       --begin de loop verwerking als de checks in orde zijn.
       if check_document (p_dly_id   => r_dly.id)
       then

         <<market_document>>
         for r_md_elements in c_md_elements
         loop
            --1: Voeg info toe aan reception-record
           r_rcn.id                                   := v_rcn_id;
           r_rcn.document_mrid                        := r_md_elements.md_mrid;
           r_rcn.document_version                     := r_md_elements.md_revision_number;
           r_rcn.document_sender_mrid                 := r_md_elements.md_sender_mpt_mrid;
           r_rcn.document_type                        := sup_tln_actions.get_translation(p_tln_elm   => cn_document_type
                                                                                        ,p_tln_code  => r_md_elements.md_type);
           r_rcn.bvalidity_utc_from                   := sup_date_actions.convert_any_date2timestamp_utc(p_text_date => r_md_elements.md_time_itl_start);
           r_rcn.bvalidity_utc_to                     := sup_date_actions.convert_any_date2timestamp_utc(p_text_date => r_md_elements.md_time_itl_end);
           pcs_rcn_actions.add_info_to_reception(p_rcn_row => r_rcn);

           -- period.Timeinterval
           v_period_timeinterval         := sup_date_actions.convert_any_date2timestamp_utc(p_text_date => r_md_elements.md_time_itl_start);

           r_tcy                         := null;

           r_tcy.legal_owner             := v_legal_owner;

           -- Parameters uit event bericht
           v_param_area                  := sup_globals.get_global_varchar (p_name => cn_area);
           v_param_process_type          := sup_globals.get_global_varchar (p_name => cn_process_type);

           -- Capacity type als deze is aangeleverd nemen we deze over, anders bepalen o.b.v. "cut-offtime" of uit object_property halen.
           -- Alleen bij oude event-berichten is de capacity_type niet aangeleverd
           if     v_param_process_type is not null 
              and instr(p_delivery, 'NTC_FINAL')  = 0 -- Niet bij NTC_FINAL berichten
           then
              -- dan moet die waarde gebruikt worden als capacity type
               r_tcy.capacity_type    := 'NET_TRANSFER_CAPACITY_' || v_param_process_type;
           -- Wanneer proces type NIET in het event bericht voorkomt (of niet vanuit bovenstaande locaties), dan capacity type op oude manier bepalen
           else
               -- Bij NTC_FINAL moeten we a.d.h.v. de creating-date van het event-bericht bepalen of het intraday of day-ahead is
               if instr(p_delivery, 'NTC_FINAL') > 0
               then

                 -- haal event_created_date_time   (event-bericht en ntc-bericht hebben hetzelfde process_id)
                 open c_event_date(b_pcs_id => sup_globals.get_global_number(p_name => cn_process_id));

                 fetch c_event_date
                  into v_created_date_time;

                 close c_event_date;

                 -- Voor de vergelijking hebben we alleen de dag nodig. Zet om naar lokaal om niet op de verkeerde dag te komen (23:00 creation vs. 02:00 bval)
                 v_created_date                  := trunc(sup_date_actions.convertutc2local(p_utc_date => v_created_date_time));
                 v_period_date                   := trunc(sup_date_actions.convertutc2local(p_utc_date => v_period_timeinterval));

                 -- als period.timeInterval ingaat op dezelfde dag als created-date-time
                 --     of als period.timeInterval een dag later ligt en created-date-time is na 12.00 uur => INTRADAY
                 if v_created_date      = v_period_date
                 or (    v_created_date = v_period_date - 1
                     and extract(hour from sup_date_actions.convertutc2local_ts(p_ts_tz => v_created_date_time)) >= 12 )
                 then
                   r_tcy.capacity_type         := 'NET_TRANSFER_CAPACITY_INTRADAY';
                 else
                   r_tcy.capacity_type         := 'NET_TRANSFER_CAPACITY_DAY_AHEAD';
                 end if;

               else
                 r_tcy.capacity_type           := sup_ojtppy_actions.get_domain_value(p_ojt_code                => p_delivery
                                                                                     ,p_ppy_code                => cn_capacity_type
                                                                                     ,p_tvalidity_utc_timestamp => sup_date_actions.convert_any_date2timestamp_utc(p_text_date => r_md_elements.md_time_itl_start)
                                                                                     ,p_bvalidity_utc_timestamp => sup_date_actions.convert_any_date2timestamp_utc(p_text_date => r_md_elements.md_time_itl_end)
                                                                                     );
                 end if;
           end if;

           v_capacity_type                     := r_tcy.capacity_type;

           <<timeseries>>
           for r_timeseries in c_timeseries
           loop

             -- "in_ara_code" wordt opgeslagen als BIDDING_ZONE
             open c_get_domain(b_domain_mrid => r_timeseries.ts_in_domain_mrid);

             fetch c_get_domain
              into r_tcy.in_ara_code;

             close c_get_domain;

             r_tcy.in_ara_code_type    := sup_constants.cn_eic_code;
             r_tcy.in_ara_object_type  := sup_constants.cn_bidding_zone;

             -- "out_ara_code" wordt opgeslagen als BIDDING_ZONE
             open c_get_domain(b_domain_mrid => r_timeseries.ts_out_domain_mrid);

             fetch c_get_domain
              into r_tcy.out_ara_code;

             close c_get_domain;

             r_tcy.out_ara_code_type   := sup_constants.cn_eic_code;
             r_tcy.out_ara_object_type := sup_constants.cn_bidding_zone;

             -- schrijf de regel in tabel "tcy_transfer_capacities"
             tcy_tcy_dml.dml_row(p_row => r_tcy);

             -- if inDomain = '10YNL----------L' (TenneT Nederland) -> dan IMPORT
             if r_tcy.in_ara_code = sup_ojtppy_actions.get_domain_value(p_ojt_code                => p_delivery
                                                                       ,p_ppy_code                => cn_viewpoint_area
                                                                       ,p_tvalidity_utc_timestamp => sup_date_actions.convert_any_date2timestamp_utc(p_text_date => r_md_elements.md_time_itl_start)
                                                                       ,p_bvalidity_utc_timestamp => sup_date_actions.convert_any_date2timestamp_utc(p_text_date => r_md_elements.md_time_itl_end)
                                                                       )
             then
               v_value_meaning         := 'IMPORT';
             else
               v_value_meaning         := 'EXPORT';
             end if;

             v_ptu_interval            := null;

             if sup_ojtppy_actions.get_domain_value(p_ojt_code => 'EDP_16'
                                                   ,p_ppy_code => 'PUBLISH_' || r_timeseries.ts_in_domain_mrid) = 'Y'
             or sup_ojtppy_actions.get_domain_value(p_ojt_code => 'EDP_16'
                                                   ,p_ppy_code => 'PUBLISH_' || r_timeseries.ts_out_domain_mrid) = 'Y' then
                v_publish_edp_16        := true;
             end if;

             if sup_ojtppy_actions.get_domain_value(p_ojt_code => 'EDP_17'
                                                   ,p_ppy_code => 'PUBLISH_' || r_timeseries.ts_in_domain_mrid) = 'Y'
             or sup_ojtppy_actions.get_domain_value(p_ojt_code => 'EDP_17'
                                                   ,p_ppy_code => 'PUBLISH_' || r_timeseries.ts_out_domain_mrid) = 'Y' then
                v_publish_edp_17        := true;
             end if;

             -- loop over de points per timeserie
             <<points>>
             for r_periods in c_periods(b_ts_mrid           => r_timeseries.ts_mrid,
                                        b_ts_in_domain_mrid => r_timeseries.ts_in_domain_mrid)
             loop
               r_cpy                     := null;
               r_cpy.tcy_id              := r_tcy.id;
               r_cpy.value_meaning       := v_value_meaning;

               --2: Bepaal de start en eind-tijd a.h.v. de binnengekomen interval.start_tijd en de position.
               --   Die hebben we nodig om de PTU te bepalen
               v_interval_in_minutes         := sup_date_actions.translate_resolution_2_minutes(r_periods.pd_resolution);
               --3: Bepaal de interval.
               v_ptu_interval                := sup_date_actions.get_utc_timeinterval_by_ptu(p_utc_datetime        => sup_date_actions.convert_any_date2timestamp_utc(r_periods.pd_time_itl_start)
                                                                                            ,p_interval_in_minutes => v_interval_in_minutes
                                                                                            ,p_ptu                 => r_periods.pt_position);

               --4: Bepaal nu de PTU (van die dag) a.d.h.v. de starttijd van de Period en de position
               v_ptu                         := sup_date_actions.get_ptu_from_utc_date(p_utc_time                  => v_ptu_interval.starttime
                                                                                      ,p_ptu_length                => v_interval_in_minutes);
               --5: Bepaal de maximale ptu door met de bvalidity from en end om later te bepalen of er ptu regels aangevuld moeten worden.
               if r_periods.next_pt_position is null then
                  v_amount_ptus_to_add   := sup_date_actions.get_ptus_between_two_dates(p_date_utc_from         => v_ptu_interval.starttime
                                                                                       ,p_date_utc_to           => sup_date_actions.convert_any_date2timestamp_utc(r_periods.pd_time_itl_end)
                                                                                       ,p_ptu_length_in_minutes => v_interval_in_minutes) -1; -- 1 eraf halen, anders nemen we de de TOT-tijd ook mee
               else
                  -- Dit is niet niet de end-time van de totale period, maar het moment tot de volgende point (vanaf het begin van de period-interval rekenen!)
                  v_end_time             := sup_date_actions.get_utc_startmoment_by_ptu(p_utc_datetime          => sup_date_actions.convert_any_date2timestamp_utc(r_periods.pd_time_itl_start)
                                                                                       ,p_interval_in_minutes   => v_interval_in_minutes
                                                                                       ,p_ptu                   => r_periods.next_pt_position);

                  v_amount_ptus_to_add   := sup_date_actions.get_ptus_between_two_dates(p_date_utc_from         => v_ptu_interval.starttime
                                                                                       ,p_date_utc_to           => v_end_time
                                                                                       ,p_ptu_length_in_minutes => v_interval_in_minutes)  -1; -- 1 eraf halen, anders nemen we de de TOT-tijd ook mee
               end if;

               r_cpy.bvalidity_utc_from  := v_ptu_interval.starttime;
               r_cpy.bvalidity_utc_to    := v_ptu_interval.endtime;
               r_cpy.ptu_resolution      := r_periods.pd_resolution;
               -- ptu_date_loc is de lokale uitvoeringsdag
               r_cpy.ptu_date_loc        := trunc(sup_date_actions.convertutc2local(v_ptu_interval.starttime));
               r_cpy.ptu                 := v_ptu;
               r_cpy.capacity            := r_periods.pt_quantity;
               r_cpy.capacity_unit       := r_timeseries.ts_measure_unit_name;

               -- Record vastleggen
               tcy_cpy_dml.dml_row(p_row => r_cpy);

               -- == BEGIN specifiek voor curvetype A03
               if r_timeseries.ts_curvetype = 'A03'
               then
                 -- de start ptu hebben we al gezet, dus gaan we naar de volgende
                 v_ptu                        := v_ptu + 1;
                 -- Vul bij een curvetype A03 de ontbrekende Ptu regels aan tussen de ptu's.
                 if v_amount_ptus_to_add > 0
                 then
                   -- Deze wordt gebruikt om vanaf de r_periods.pt_position de ptu's te bereken. Ook hier 1 overslaan, want die hebben we al geschreven
                   v_loop_position            := r_periods.pt_position + 1;
                   <<add_ptu_between>>
                   for ptu_idx in 1 .. v_amount_ptus_to_add
                   loop
                     -- PK leeg maken, die wordt in de dml-row gevuld, dat zou ervoor kunnen zorgen dat er steeds en update van hetzelfde record gedaan wordt.
                     r_cpy.id                   := null;
                     v_ptu_interval_loop        := sup_date_actions.get_utc_timeinterval_by_ptu(p_utc_datetime        => sup_date_actions.convert_any_date2timestamp_utc(r_periods.pd_time_itl_start)
                                                                                               ,p_interval_in_minutes => v_interval_in_minutes
                                                                                               ,p_ptu                 => v_loop_position);
                     --Records bijwerken, andere waardes worden overgenomen van de vorige ptu.
                     r_cpy.bvalidity_utc_from   := v_ptu_interval_loop.starttime;
                     r_cpy.bvalidity_utc_to     := v_ptu_interval_loop.endtime;
                     r_cpy.ptu_date_loc         := trunc(sup_date_actions.convertutc2local(v_ptu_interval_loop.starttime));
                     r_cpy.ptu                  := sup_date_actions.get_ptu_from_utc_date(p_utc_time   => v_ptu_interval_loop.starttime
                                                                                         ,p_ptu_length => v_interval_in_minutes);

                     -- Record vastleggen
                     tcy_cpy_dml.dml_row(p_row => r_cpy);

                     --Naar de volgende position
                     v_loop_position            := v_loop_position + 1;

                   end loop add_ptu_between;
                 end if;
               end if;
               -- == EINDE specifiek voor curvetype A03

             end loop points;
           end loop timeseries;
         end loop market_document; -- capacitydocument

         -- Klaar, zet de receptionstatus op 'SAVED'.
         -- Ook dat hier doen en niet in de xmlhandler om de data-receptions te scheiden van de acknowledgements
         pcs_rse_actions.set_rcn_state(p_rcn_id   => v_rcn_id
                                      ,p_state    => sup_constants.cn_rcn_state_saved);

         start_publications(p_period_timeinterval => cast(v_period_timeinterval as date)
                           ,p_capacity_type       => v_capacity_type
                           ,p_delivery_code       => r_dly.delivery_code
                           ,p_bvalidity_utc_from  => r_rcn.bvalidity_utc_from
                           ,p_bvalidity_utc_to    => r_rcn.bvalidity_utc_to
                           ,p_publish_edp_16      => v_publish_edp_16
                           ,p_publish_edp_17      => v_publish_edp_17
                           );

         p_result                             := sup_constants.cn_processed_ok;

       else
         pcs_log_actions.log_error(p_module => cn_module
                                  ,p_text   => 'Document not processed, checks failed. See table pcs_mge_check_results (pcs_id = '
                                            || sup_globals.get_global_number(p_name => cn_process_id)
                                            || ')for more information'
                                  );

         p_result                             := sup_constants.cn_processed_nok;

       end if;      -- check_document

    else
       -- Algemene document-controle is gefaald, zet status op FAILED
       pcs_rse_actions.set_rcn_state(p_rcn_id      => v_rcn_id
                                    ,p_state       => sup_constants.cn_rcn_state_invalid);

       pcs_log_actions.log_error(p_module          => cn_module
                                ,p_text            => 'Document not processed, invalid document!'
                                );

       p_result                                    := sup_constants.cn_processed_nok;

    end if;

    -- write 'End' into log-trace
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End'
                             ||chr(10)||'  p_result: '|| p_result
                             );

  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      p_result       := sup_constants.cn_processed_nok;

  end process_ntc;

  procedure process_atc(p_result         out varchar2
                       ,p_xml            in  xmltype
                       ,p_delivery       in  varchar2
                       ,p_enqueue_time   in  timestamp
                       )
  is
  /*********************************************************************************************************************
   Purpose    : Verwerk een Net Transfer Capacities bericht
                Bericht bestaat in hoofdlijnen uit:
                - Hoofddocument
                  - 0..n Timeseries met          mRID of the measurement-point.
   Verwerking:
   *********************************************************************************************************************/
    cn_module                     constant  varchar2(100)  := cn_package || '.process_atc';

    -- verwerking
    v_rcn_id                                pcs_rcn_receptions.id%type;
    v_legal_owner                           sup_deliveries.legal_owner%type;
    v_cre_source                            sup_deliveries.source%type;
    v_content_xml                           xmltype;

    -- row types
    r_dly                                   sup_deliveries%rowtype;
    r_tcy                                   tcy_transfer_capacities%rowtype;
    r_cpy                                   tcy_capacities%rowtype;
    r_rcn                                   pcs_rcn_receptions%rowtype;

    -- variabelen
    v_ptu_interval                          sup_date_actions.rt_interval;
    v_interval_in_minutes                   number(10);
    v_ptu                                   number(5);
    v_value_meaning                         varchar2(10);
    v_timeseries_found                      boolean;

  begin
    v_rcn_id := pcs_rcn_actions.initiate_new_pct_reception (p_xml          => p_xml
                                                           ,p_delivery     => p_delivery
                                                           ,p_enqueue_time => p_enqueue_time
                                                           ,p_start_time   => SYS_EXTRACT_UTC(SYSTIMESTAMP));

    -- Bepaal ahv de reception het source_system en de legal_owner
    pcs_rcn_actions.get_delivery(p_rcn_id  => v_rcn_id
                                ,p_dly_row => r_dly
                                );

    v_legal_owner                      := r_dly.legal_owner;
    v_cre_source                       := r_dly.source;
    v_timeseries_found                 := false;

    -- domeinnamen voor de checks
    v_md_sender_mpt_mrid_cs            := p_delivery||'.MD_SENDER_MPT_MRID_CS';
    v_md_receiver_mpt_mrid_cs          := p_delivery||'.MD_RECEIVER_MPT_MRID_CS';

    -- Zet de globals met info die we inmiddels ook hebben
    sup_globals.set_global(p_name  => cn_source_system
                          ,p_value => v_cre_source);
    sup_globals.set_global(p_name  => cn_legal_owner
                          ,p_value => v_legal_owner);

    -- Vul pcs_pcs_processes aan met extra info
    pcs_pcs_actions.update_process(p_cre_source  => v_cre_source
                                  ,p_legal_owner => v_legal_owner);


    -- Doe algemene document-controle
    if sup_mge_checks.check_valid_document(p_xml  => p_xml)
    then
       v_content_xml           := p_xml.extract('//msg:message/msg:content/*',cn_ns);

       if v_content_xml is null
       then
          -- Dit is het geval bij een bericht zonder TenneT-any header
          v_content_xml        := p_xml;
       end if;

       rcn_parse_transfer_capacity_md.parse_document(p_xml => v_content_xml);

       --begin de loop verwerking als de checks in orde zijn.
       if check_document (p_dly_id   => r_dly.id)
       then
         <<market_document>>
         for r_md_elements in c_md_elements
         loop
              --1: Voeg info toe aan reception-record
             r_rcn.id                            := v_rcn_id;
             r_rcn.document_mrid                 := r_md_elements.md_mrid;
             r_rcn.document_version              := r_md_elements.md_revision_number;
             r_rcn.document_sender_mrid          := r_md_elements.md_sender_mpt_mrid;
             r_rcn.document_type                 := sup_tln_actions.get_translation(p_tln_elm   => cn_document_type
                                                                                   ,p_tln_code  => r_md_elements.md_type);
             r_rcn.bvalidity_utc_from            := sup_date_actions.convert_any_date2timestamp_utc(p_text_date => r_md_elements.md_time_itl_start);
             r_rcn.bvalidity_utc_to              := sup_date_actions.convert_any_date2timestamp_utc(p_text_date => r_md_elements.md_time_itl_end);
             pcs_rcn_actions.add_info_to_reception(p_rcn_row => r_rcn);

             <<timeseries>>
             for r_timeseries in c_timeseries
             loop
                 v_timeseries_found              := true;
                 r_tcy                           := null;
                 r_tcy.legal_owner               := sup_constants.cn_legal_owner_ttn;
                 r_tcy.capacity_type             := sup_tln_actions.get_translation(p_tln_elm   => cn_business_type
                                                                                   ,p_tln_code  => r_timeseries.ts_businesstype);
                 r_tcy.in_ara_code               := r_timeseries.ts_in_domain_mrid;
                 r_tcy.in_ara_code_type          := sup_tln_actions.get_translation(p_tln_elm   => cn_codingscheme
                                                                                   ,p_tln_code  => r_timeseries.ts_in_domain_mrid_cs);
                 r_tcy.in_ara_object_type        := sup_constants.cn_bidding_zone;

                 r_tcy.out_ara_code              := r_timeseries.ts_out_domain_mrid;
                 r_tcy.out_ara_code_type         := sup_tln_actions.get_translation(p_tln_elm   => cn_codingscheme
                                                                                   ,p_tln_code  => r_timeseries.ts_out_domain_mrid_cs);
                 r_tcy.out_ara_object_type       := sup_constants.cn_bidding_zone;

                 -- schrijf de regel in tabel "tcy_transfer_capacities"
                 tcy_tcy_dml.dml_row(p_row => r_tcy);

                 -- if inDomain = '10YNL----------L' (TenneT Nederland) -> dan IMPORT
                 if r_tcy.in_ara_code = sup_ojtppy_actions.get_domain_value(p_ojt_code                => 'TTN'
                                                                           ,p_ppy_code                => sup_constants.cn_bidding_zone
                                                                           ,p_tvalidity_utc_timestamp => sup_date_actions.convert_any_date2timestamp_utc(p_text_date => r_md_elements.md_time_itl_start)
                                                                           ,p_bvalidity_utc_timestamp => sup_date_actions.convert_any_date2timestamp_utc(p_text_date => r_md_elements.md_time_itl_end)
                                                                           )
                 then
                    v_value_meaning              := 'IMPORT';
                 else
                    v_value_meaning              := 'EXPORT';
                 end if;

                 -- loop over de points per timeserie
                 <<points>>
                 for r_periods in c_periods(b_ts_mrid           => r_timeseries.ts_mrid,
                                            b_ts_in_domain_mrid => r_timeseries.ts_in_domain_mrid)
                 loop
                     v_interval_in_minutes       := sup_date_actions.translate_resolution_2_minutes(r_periods.pd_resolution);
                     v_ptu_interval              := sup_date_actions.get_utc_timeinterval_by_ptu(p_utc_datetime        => sup_date_actions.convert_any_date2timestamp_utc(r_periods.pd_time_itl_start)
                                                                                                ,p_interval_in_minutes => v_interval_in_minutes
                                                                                                ,p_ptu                 => r_periods.pt_position);

                     v_ptu                       := sup_date_actions.get_ptu_from_utc_date(p_utc_time                  => v_ptu_interval.starttime
                                                                                          ,p_ptu_length                => v_interval_in_minutes);

                     r_cpy                       := null;
                     r_cpy.tcy_id                := r_tcy.id;
                     r_cpy.bvalidity_utc_from    := v_ptu_interval.starttime;
                     r_cpy.bvalidity_utc_to      := v_ptu_interval.endtime;
                     r_cpy.ptu_resolution        := r_periods.pd_resolution;
                     r_cpy.ptu_date_loc          := trunc(sup_date_actions.convertutc2local(v_ptu_interval.starttime));
                     r_cpy.ptu                   := v_ptu;
                     r_cpy.capacity              := r_periods.pt_quantity;
                     r_cpy.capacity_unit         := r_timeseries.ts_measure_unit_name;
                     r_cpy.value_meaning         := v_value_meaning;
                     tcy_cpy_dml.dml_row(p_row => r_cpy);
                 end loop points;
             end loop timeseries;
         end loop market_document; -- capacitydocument

         if v_timeseries_found then
            -- Klaar, zet de receptionstatus op 'SAVED'.
            -- Ook dat hier doen en niet in de xmlhandler om de data-receptions te scheiden van de acknowledgements
            pcs_rse_actions.set_rcn_state(p_rcn_id   => v_rcn_id
                                         ,p_state    => sup_constants.cn_rcn_state_saved);
            -- Start ATR_20
            if sup_psh_actions.is_pbn_active(p_pbn_name     => 'ATR_20'
                                            ,p_pbn_date_utc => r_rcn.bvalidity_utc_from) then
               tmn_atr_20.start_publication(p_pbn_date_utc  => r_rcn.bvalidity_utc_from);
            end if;

            p_result                        := sup_constants.cn_processed_ok;
         else
            pcs_log_actions.log_error(p_module => cn_module
                                     ,p_text   => 'Empty document, no TimeSeries found'
                                     );

           pcs_rse_actions.set_rcn_state(p_rcn_id   => v_rcn_id
                                        ,p_state    => sup_constants.cn_rcn_state_invalid);
            p_result                        := sup_constants.cn_processed_nok;
         end if;
       else
         pcs_log_actions.log_error(p_module => cn_module
                                  ,p_text   => 'Document not processed, checks failed. See table pcs_mge_check_results (pcs_id = '
                                            || sup_globals.get_global_number(p_name => cn_process_id)
                                            || ')for more information'
                                  );

         p_result                             := sup_constants.cn_processed_nok;
       end if;      -- check_document
    else
       -- Algemene document-controle is gefaald, zet status op FAILED
       pcs_rse_actions.set_rcn_state(p_rcn_id      => v_rcn_id
                                    ,p_state       => sup_constants.cn_rcn_state_invalid);

       pcs_log_actions.log_error(p_module          => cn_module
                                ,p_text            => 'Document not processed, invalid document!'
                                );

       p_result                                    := sup_constants.cn_processed_nok;
    end if;

    -- write 'End' into log-trace
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End'
                             ||chr(10)||'  p_result: '|| p_result
                             );

  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      p_result       := sup_constants.cn_processed_nok;

  end process_atc;

end rcn_transfer_capacities;
/
