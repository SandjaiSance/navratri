create or replace package body rcn_uay_tmn_assets
is
  /***********************************************************************************************************************************
   Purpose    : Verwerken van Unavailabilities van Transmission Assets vanuit AVY
                AVY.DELPHI11#OUTAGE_TRANSMISSION_ASSETS en versturen van de EDP_10 en EDP_11
   Change History
   Date        Author            Version   Description
   ----------  ----------------  -------   -------------------------------------------------------------------------------------------
   03-06-2021  R. Standhaft      01.00.00  Created
   04-06-2021  X. Pikaar         01.00.01  Object_type areas moet CONTROL_AREA zijn i.p.v. BIDDING_ZONE
   08-06-2021  R. Standhaft      01.00.02  aanpassingen na test
   10-06-2021  M. Zuijdendorp    01.00.03  TRAN-4347: Start EDP_10 toegevoegd
   23-06-2021  R. Standhaft      01.00.04  aanpassingen na test
   27-08-2021  X. Pikaar         01.01.00  TRAN-5016: process_id meegeven aan EDP_10 als parent_process_id
   19-11-2021  M. Zuijdendorp    01.01.01  TRAN-4805: Verstuur technische ack terug naar AVY
   28-03-2022  X. Pikaar         01.02.00  TRAN-5205, bepaal of binnenkomende area een control_area of bidding_zone is
   16-06-2022  X. Pikaar         01.03.00  Expliciete close van c_udc toegevoegd i.v.m. ORA-06511
   17-06-2022  R. Brinker        01.04.00  TRAN-5604 UAY Transmission assets: Berekening ptu interval werkt niet
   28-10-2022  X. Pikaar         01.05.00  TRAN-5825: reason-code opslaan
   05-12-2022  X. Pikaar         01.06.00  TRAN-5888: Alle versies van een document moeten bewaard blijven. Daarom document revision_number
                                           doorgeven aan edp_10 zodat de juiste versie gepubliceerd wordt.
   13-12-2023  X. Pikaar         01.07.00  TRAN-6502 EDP_10 compliancy deadline moet bepaald worden o.b.v. de enqueue time
   21-12-2023  Y. Krop           01.07.01  Enqueue-time voor bovengenoemde wijziging is stiekem een UTC-tijd dus omzetten naar LOCAL
   16-05-2025  Mirjam Buuts      01.08.00  TRAN-7447: kolom unavailability_type naast object_type gebruiken in tabel uay_unavailability_docs
   28-05-2025  Mirjam Buuts      01.09.00  TRAN-7437: Als er geen Available_Period aangeleverd wordt in het bericht dan zal op basis van gegevens
                                           uit de tabellen tcy_transfer_capacities en tcy_capacities obv capacity_type 'NET_TRANSFER_CAPACITY_LONG_TERM'
                                           gegevens verzameld worden voor het aanmaken van availibilities.
   03-06-2025  Xander Pikaar     01.09.01  Cursor om de verschillende NTC-waardes met start en einddatum te bepalen aangepast zodat
                                           alle wijzigingen meegaan en ook het verloop van de NTC-waarde goed geselecteerd wordt als
                                           de NTC waarde teruggaat naar een eerdere waarde
   30-05-2025  Mirjam Buuts      01.10.00  TRAN-6961 Alleen publiceren als publicatie actief is.
   04-06-2025  Sandjai Ramasray  01.11.00  TRAN-7434 Delphi - Inkomend - AVY.UNAVAILABILITIES#OUTAGE_OFF_SHORE_GRID_ASSETS - Bouw
   02-07-2025  Xander Pikaar     01.12.00  Met de inbouw van TRAN-7434 is de bugfix van 01.09.01 (deels) verloren gegaan. Uit cursor
                                           c_cpy de vergelijking op bvalidity_utc_to <= (select min(bvalidity_utc_from) weer verwijderd.
   04-07-2025  Nico Klaver       01.13.00  TRAN-7563: Capaciteit offshore uit de meetwaarden halen
   24-07-2025  Xander Pikaar     01.13.01  Bij starten EDP_11 controleren of deze wel actief is
   13-08-2025  Nico Klaver       01.13.02  Logging erbij
   19-08-2025  Nico Klaver       01.13.03  avy bvalidities uit uay_doc halen
   09-09-2025  Xander Pikaar     01.13.04  TRAN-7673: In create_avy_internal werd bij de selectie op mrd_nob_keys geen rekening gehouden 
                                           met de tvalidity
   11-09-2025  Xander Pikaar     01.13.05  TRAN-7691: cursor c_capacity ging nog niet helemaal goed om met de bvalidity en tvalidity
   16-09-2025  Xander Pikaar     01.13.06  TRAN-7691: Cursor c_capacity moet bij het ophalen van de meetwaarden de exacte begin en eindtijd 
                                           van de PTU gebruiken en niet <= / >= de ptu tijden. Daardoor zou je 1 record teveel selecteren
   16-09-2025  Xander Pikaar     01.13.07  TRAN-7696: Bij het bepalen van de invoeding werd een abs van het getal gedaan, waardoor consumptie
                                           ook als generatie behandeld werd. Als er alleen consumptie is 0 uitsturen
   24-04-2026  Sandjai Ramasray  01.14.00  TRAN-7801: Delphi - Inkomend - EQUALITY.UNAVAILABILITY#PLANNED_UNAVAILABILITY_HVDC_INTERCONNECTOR
                                           -verwerking van meerdere points per periode mogelijk gemaakt
   19-05-2026  Sandjai Ramasray  01.14.01  TRAN-7801: in c_avy_points filter toegevoegd om te checken dat datumvelden niet leeg zijn.                                          
   06-07-2025  Sandjai Ramasray  01.15.00  TRAN-8243 Correctie foutieve UTC-conversiepatronen.
  ***********************************************************************************************************************************/
  cn_package                      constant  varchar2(30)     := 'rcn_uay_tmn_assets';
  cn_versionnumber                constant  varchar2(10)     := '01.15.00';

  -- constanten in deze package
  cn_legal_owner                  constant  varchar2(30)      := 'LEGAL_OWNER';
  cn_source_system                constant  varchar2(30)      := 'SOURCE_SYSTEM';
  cn_process_id                   constant  varchar2(30)      := 'PROCESS_ID';
  cn_mrid_prefix                  constant  varchar2(30)      := 'MRID_PREFIX';
  cn_document_type                constant  varchar2(30)      := 'DOCUMENT_TYPE';

  -- document-niveau   -   translations
  cn_docstatus                    constant sup_translations.element_name%type := 'STATUS_TYPE';
  cn_unavailability_type          constant sup_translations.element_name%type := 'UNAVAILABILITY_TYPE';
  cn_reasoncode                   constant sup_translations.element_name%type := 'REASONCODE_TYPE';

  -- Offshore
  cn_capacity_unit                constant uay_availabilities.capacity_unit%type := 'MAW';

  type r_avy_in_type is record
     (id                     uay_availabilities.id%type
     ,uay_id                 uay_availabilities.uay_id%type
     ,org_bvalidity_utc_from uay_availabilities.org_bvalidity_utc_from%type
     ,org_bvalidity_utc_to   uay_availabilities.org_bvalidity_utc_to%type
     ,org_ptu                uay_availabilities.org_ptu%type
     ,org_ptu_resolution     uay_availabilities.org_ptu_resolution%type
     ,bvalidity_utc_from     uay_availabilities.bvalidity_utc_from%type
     ,bvalidity_utc_to       uay_availabilities.bvalidity_utc_to%type
     ,capacity_quantity      uay_availabilities.capacity_quantity%type
     ,capacity_unit          uay_availabilities.capacity_unit%type
     ,code                   uay_unavailabilities.code%type
     ,code_type              uay_unavailabilities.code_type%type
     );

  -- document-niveau   -   domeinnamen voor de checks
  v_md_documenttype                        sup_ojt_ppy.v_value%type;
  v_md_processtype                         sup_ojt_ppy.v_value%type;
  v_md_docstatus                           sup_ojt_ppy.v_value%type;
  v_md_reasons                             sup_ojt_ppy.v_value%type;
  v_md_sender_mpt_mrid                     sup_ojt_ppy.v_value%type;
  v_md_sender_mpt_mrid_cs                  sup_ojt_ppy.v_value%type;
  v_md_sender_mpt_roletype                 sup_ojt_ppy.v_value%type;
  v_md_receiver_mpt_mrid                   sup_ojt_ppy.v_value%type;
  v_md_receiver_mpt_mrid_cs                sup_ojt_ppy.v_value%type;
  v_md_receiver_mpt_roletype               sup_ojt_ppy.v_value%type;

  -- timeseries-niveau   -   translations
  cn_businesstype                 constant sup_translations.element_name%type := 'BUSINESS_TYPE';
  cn_curvetype                    constant sup_translations.element_name%type := 'CURVE_TYPE';
  cn_codingscheme                 constant sup_translations.element_name%type := 'CODINGSCHEME';

  -- timeseries-niveau   -   domeinnamen voor de checks
  v_ts_businesstype                        sup_ojt_ppy.v_value%type;
  v_ts_qty_measure_unit                    sup_ojt_ppy.v_value%type;
  v_ts_curvetype                           sup_ojt_ppy.v_value%type;
  v_ts_resolution                          sup_ojt_ppy.v_value%type;
  v_ts_arr_mrid_cs                         sup_ojt_ppy.v_value%type;
  v_ts_in_ara_mrid_cs                      sup_ojt_ppy.v_value%type;
  v_ts_out_ara_mrid_cs                     sup_ojt_ppy.v_value%type;

  r_rcn                                    pcs_rcn_receptions%rowtype;
  -- document algemeen
  cursor c_udc
      is select distinct gtt.md_procestype
                        ,gtt.md_sender_mpt_mrid
                        ,gtt.md_sender_mpt_mrid_cdgscheme
                        ,gtt.md_sender_mpt_roletype
                        ,gtt.md_receiver_mpt_mrid
                        ,gtt.md_receiver_mpt_mrid_cdgscheme
                        ,gtt.md_receiver_mpt_roletype
                        ,gtt.md_mrid
                        ,gtt.md_revisionnumber
                        ,gtt.md_uay_ti_startdatetime
                        ,gtt.md_uay_ti_enddatetime
                        ,gtt.md_docstatus
                        ,gtt.md_type
           from uay_unavailability_md_gtt gtt;

  -- reason   -   een per document
  cursor c_udc_rsn
      is select distinct gtt.md_rn_code
                        ,gtt.md_rn_text
           from uay_unavailability_md_gtt gtt
          where gtt.md_rn_code is not null;

  -- timeseries
  cursor c_timeseries
      is select distinct tse.ts_mrid
                        ,tse.ts_businesstype
                        ,tse.ts_startdate
                        ,tse.ts_starttime
                        ,tse.ts_enddate
                        ,tse.ts_endtime
                        ,tse.ts_curvetype
                        ,tse.ts_qty_measure_unit_name
                        ,tse.ts_in_domain_mrid
                        ,tse.ts_in_domain_mrid_cs
                        ,tse.ts_out_domain_mrid
                        ,tse.ts_out_domain_mrid_cs
           from uay_unavailability_md_gtt tse
          where tse.ts_mrid is not null;

  -- asset_RegisteredResource   -   een per timeserie
  cursor c_registered_resource (b_timeserie_mrid varchar2)
     is select distinct rre.arr_mrid
                      , rre.arr_mrid_cs
          from uay_unavailability_md_gtt rre
         where rre.ts_mrid  = b_timeserie_mrid
           and rre.arr_mrid is not null;

  -- avalabilitiy   -   meerdere per timeserie
  cursor c_avy_periods (b_timeserie_mrid varchar2)
      is select distinct prd.ap_ti_start_datetime
                       , prd.ap_ti_end_datetime
                       , prd.ap_resolution
                       , prd.ap_point_position
                       , prd.ap_point_quantity
                       , to_number(lead(prd.ap_point_position) over (partition by prd.ts_mrid order by to_number(prd.ap_point_position) asc)) as next_point
           from uay_unavailability_md_gtt prd
          where prd.ts_mrid               = b_timeserie_mrid
            and prd.ap_ti_start_datetime is not null
            and prd.ap_point_position    is not null;

   -- points per period   -   meerdere  per period
  cursor c_avy_points ( b_timeserie_mrid        varchar2
                      , b_ap_ti_start_datetime  timestamp
                      , b_ap_ti_end_datetime    timestamp )
      is select distinct prd.ap_point_position
                       , prd.ap_point_quantity
                       , to_number(lead(prd.ap_point_position) over (partition by prd.ts_mrid order by to_number(prd.ap_point_position) asc)) as next_point
           from uay_unavailability_md_gtt prd
          where prd.ts_mrid               = b_timeserie_mrid
            and prd.ap_ti_start_datetime is not null
            and prd.ap_point_position    is not null
            and sup_date_actions.convert_any_date2timestamp_utc(p_text_date => prd.ap_ti_start_datetime) >= b_ap_ti_start_datetime
            and sup_date_actions.convert_any_date2timestamp_utc(p_text_date => prd.ap_ti_end_datetime)   <= b_ap_ti_end_datetime;	

  function get_versionnumber
  return varchar2
  is
    /**********************************************************************************************************************
     Purpose    : Return package version
     **********************************************************************************************************************/
  begin
    return cn_versionnumber;
  end get_versionnumber;

  function check_document
    return boolean
  is
    /*********************************************************************************************************************
     Purpose    : Semantische controles document
     *********************************************************************************************************************/
    cn_module                     constant  varchar2(61)   := cn_package || '.check_document';

    v_checks_passed                         boolean;

    r_timeseries_previous_row               c_timeseries%rowtype;

  begin
    -- write 'Start' into log-trace
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start');

    v_checks_passed                           := true;

    -- document algemeen
    <<Main_document>>
    for r_udc in c_udc      -- dit is maar 1 record
    loop

       -- processtype ?     - expect 'A26'
       if  not pcs_mge_checks.check_domain_value(p_domain => v_md_processtype
                                                ,p_value  => r_udc.md_procestype)
       then
         v_checks_passed                      := false;
       end if;

       -- sender mRID ?     - expect '49V000000000007J'
       if  not pcs_mge_checks.check_domain_value(p_domain => v_md_sender_mpt_mrid
                                                ,p_value  => r_udc.md_sender_mpt_mrid)
       then
         v_checks_passed                      := false;
       end if;

       -- sender mrid codingscheme ?     - expect 'A01'
       if  not pcs_mge_checks.check_domain_value(p_domain => v_md_sender_mpt_mrid_cs
                                                ,p_value  => r_udc.md_sender_mpt_mrid_cdgscheme)
       then
         v_checks_passed                      := false;
       end if;

       -- sender role ?     - expect 'A39'
       if  not pcs_mge_checks.check_domain_value(p_domain => v_md_sender_mpt_roletype
                                                ,p_value  => r_udc.md_sender_mpt_roletype)
       then
         v_checks_passed                      := false;
       end if;

       -- receiver mRID ?     - expect '49V000000000006L'
       if  not pcs_mge_checks.check_domain_value(p_domain => v_md_receiver_mpt_mrid
                                                ,p_value  => r_udc.md_receiver_mpt_mrid)
       then
         v_checks_passed                      := false;
       end if;

       -- receiver mrid codingscheme ?     - expect 'A01'
       if  not pcs_mge_checks.check_domain_value(p_domain => v_md_receiver_mpt_mrid_cs
                                                ,p_value  => r_udc.md_receiver_mpt_mrid_cdgscheme)
       then
         v_checks_passed                      := false;
       end if;

       -- receiver role ?     - expect 'A33'
       if  not pcs_mge_checks.check_domain_value(p_domain => v_md_receiver_mpt_roletype
                                                ,p_value  => r_udc.md_receiver_mpt_roletype)
       then
         v_checks_passed                      := false;
       end if;

       -- status ?     - expect 'A09' or 'A13' or empty
       if  r_udc.md_docstatus is not null
       and not pcs_mge_checks.check_domain_value(p_domain => v_md_docstatus
                                                ,p_value  => r_udc.md_docstatus) then
          v_checks_passed                     := false;
       end if;

       -- document_type ?     - expect 'A78'
       if  not pcs_mge_checks.check_domain_value(p_domain => v_md_documenttype
                                                ,p_value  => r_udc.md_type) then
          v_checks_passed                     := false;
       end if;

       -- reason
       for r_udc_rsn in c_udc_rsn      -- dit is maar 1 record
       loop
         -- reason_code ?     - expect 'B18' or 'B19'
         if  not pcs_mge_checks.check_domain_value(p_domain => v_md_reasons
                                                  ,p_value  => r_udc_rsn.md_rn_code) then
            v_checks_passed                   := false;
         end if;
       end loop document_reasons;

       -- timeseries
       r_timeseries_previous_row := null;

       <<timeseries>>
       for r_timeseries in c_timeseries
       loop

          -- businesstype ?     - expect 'A53' or 'A54'
          -- Als waarde niet veranderd is t.o.v. vorige rij in GTT dan is check overbodig
          if  nvl(r_timeseries.ts_businesstype, 'xx') <> nvl(r_timeseries_previous_row.ts_businesstype, 'xx')
          and not pcs_mge_checks.check_domain_value(p_domain => v_ts_businesstype
                                                   ,p_value  => r_timeseries.ts_businesstype) then
            v_checks_passed                   := false;
          end if;

          -- quantity measurement unit ?     - expect 'MAW'
          -- Als waarde niet veranderd is t.o.v. vorige rij in GTT dan is check overbodig
          if  nvl(r_timeseries.ts_qty_measure_unit_name, 'xx') <> nvl(r_timeseries_previous_row.ts_qty_measure_unit_name, 'xx')
          and not pcs_mge_checks.check_domain_value(p_domain => v_ts_qty_measure_unit
                                                   ,p_value  => r_timeseries.ts_qty_measure_unit_name) then
            v_checks_passed                   := false;
          end if;

          -- curvetype ?     - expect 'A03'
          -- Als waarde niet veranderd is t.o.v. vorige rij in GTT dan is check overbodig
          if  nvl(r_timeseries.ts_curvetype, 'xx') <> nvl(r_timeseries_previous_row.ts_curvetype, 'xx')
          and not pcs_mge_checks.check_domain_value(p_domain => v_ts_curvetype
                                                   ,p_value  => r_timeseries.ts_curvetype) then
            v_checks_passed                   := false;
          end if;

          -- codingScheme van de in_ara_mrid ?     - expect 'A01'
          -- Als waarde niet veranderd is t.o.v. vorige rij in GTT dan is check overbodig
          if  nvl(r_timeseries.ts_in_domain_mrid_cs, 'xx') <> nvl(r_timeseries_previous_row.ts_in_domain_mrid_cs, 'xx')
          and not pcs_mge_checks.check_domain_value(p_domain => v_ts_in_ara_mrid_cs
                                                   ,p_value  => r_timeseries.ts_in_domain_mrid_cs) then
            v_checks_passed                   := false;
          end if;

          -- codingScheme van de out_ara_mrid ?     - expect 'A01'
          -- Als waarde niet veranderd is t.o.v. vorige rij in GTT dan is check overbodig
          if  nvl(r_timeseries.ts_out_domain_mrid_cs , 'xx') <> nvl(r_timeseries_previous_row.ts_out_domain_mrid_cs, 'xx')
          and not pcs_mge_checks.check_domain_value(p_domain => v_ts_out_ara_mrid_cs
                                                   ,p_value  => r_timeseries.ts_out_domain_mrid_cs) then
            v_checks_passed                   := false;
          end if;

          -- asset_RegisteredResource
          <<registered_resource>>
          for r_registered_resource in c_registered_resource (b_timeserie_mrid => r_timeseries.ts_mrid)
          loop

            -- codingScheme van de asset_RegisteredResource ?     - expect 'A01'
            if not pcs_mge_checks.check_domain_value(p_domain => v_ts_arr_mrid_cs
                                                     ,p_value  => r_registered_resource.arr_mrid_cs) then
              v_checks_passed                 := false;
            end if;

            -- check of de asset_RegisteredResource wel een EIC-code is
            if  not pcs_mge_checks.check_eiccode(p_eiccode => r_registered_resource.arr_mrid) then
              v_checks_passed                 := false;
            end if;

          end loop registered_resource;

          -- availability
          <<availability>>
          for r_avy_periods in c_avy_periods (b_timeserie_mrid => r_timeseries.ts_mrid)
          loop
            -- resolution ?
            if  not pcs_mge_checks.check_domain_value(p_domain => v_ts_resolution
                                                     ,p_value  => r_avy_periods.ap_resolution) then
              v_checks_passed                 := false;
            end if;

          end loop availability;

        r_timeseries_previous_row := null;

      end loop timeseries;

    end loop main_document;

    -- write 'End' into log-trace
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End'
                            || chr(13) || 'result: ' || case
                                                         when v_checks_passed then
                                                           'true'
                                                         else
                                                           'false'
                                                        end
                             );

    return v_checks_passed;

  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      return false;

  end check_document;

  function  get_ara_object_type(p_code                     in varchar2
                               ,p_code_type                in varchar2
                               ,p_bvalidity_utc_timestamp  in timestamp)
    return varchar2
  is
    /**********************************************************************************************************************
     Purpose    : Haal de area object_type op gebaseerd op code en code_type
                  Dit is wel een beetje smerig: we pakket de CONTROL_AREA, tenzij het een BIDDING_ZONE zou zijn.
                  Dat is i.v.m. de publicatie EDP_10: die moet o pCA, behalve voor Duitsland, daar moet op BZ gepubliceerd worden
    **********************************************************************************************************************/
    cn_module  constant varchar2(100) := cn_package || '.get_ara_object_type';
    --
    cursor c_ara (b_code                         varchar2
                 ,b_code_type                    varchar2
                 ,b_bvalidity_utc_timestamp      timestamp)
    is
      select k_object_type
        from mrd_ara_areas_vw
       where k_code                     = b_code
         and k_code_type                = b_code_type
         and b_bvalidity_utc_timestamp >= k_bvalidity_utc_from
         and b_bvalidity_utc_timestamp <  k_bvalidity_utc_to
         and b_bvalidity_utc_timestamp >= a_bvalidity_utc_from
         and b_bvalidity_utc_timestamp <  a_bvalidity_utc_to
         and k_object_type in ('CONTROL_AREA', 'BIDDING_ZONE')
        order by k_object_type asc;

    r_ara c_ara%rowtype;

  begin
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start'
                              ||chr(10)||' p_code               : '||p_code
                              ||chr(10)||' p_code_type          : '||p_code_type
                              ||chr(10)||' p_bvalidity_utc_timestamp: '||to_char(p_bvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                             );

    open c_ara(b_code                     => p_code
              ,b_code_type                => p_code_type
              ,b_bvalidity_utc_timestamp  => p_bvalidity_utc_timestamp);
    fetch c_ara
     into r_ara;

    close c_ara;

    if r_ara.k_object_type is null then
       pcs_log_actions.log_error(p_module => cn_module
                                ,p_text   => 'Could not determine object_type for '
                                          || p_code_type
                                          || ' '
                                          || p_code);
    end if;

    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End'
                              ||chr(10)||' p_code         : '||p_code
                              ||chr(10)||' p_code_type    : '||p_code_type
                              ||chr(10)||' object_type    : '||r_ara.k_object_type
                             );

    return r_ara.k_object_type;

  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Parameters'
                              ||chr(10)||' p_code         : '||p_code
                              ||chr(10)||' p_code_type    : '||p_code_type
                               );
      raise;
  end get_ara_object_type;

  procedure create_avy_internal(p_avy_in in out nocopy r_avy_in_type) is
     /*********************************************************************************************************************
     Purpose    : Maak het availability record aan als de meetgegevens gevonden zijn
     *********************************************************************************************************************/
     cn_module         constant varchar2(100) := cn_package || '.create_avy_internal';

     --
     -- Haal de som van de meetwaarden op voor de aan de outgae gekoppelde generation units (strings)
     -- We willen hier een positief getal
     cursor c_capacity(b_whole_code      in varchar2
                      ,b_whole_code_type in varchar2
                      ,b_bvalidity_utc   in timestamp) is
         with grid as
            (select grid.*
               from table(mrd_grid.get_grid_nodes(p_whole_code      => b_whole_code
                                                 ,p_whole_code_type => b_whole_code_type
                                                 ,p_bvalidity       => b_bvalidity_utc)) grid
              where k_part_object_type = 'GENERATION_UNIT'
            )
         ,nodes as
            (select nobkey.code
                   ,nobkey.code_type
               from grid
               join mrd_nob_keys nobkey on (    nobkey.nob_id    = grid.part_nob_id
                                            and nobkey.code_type = 'EAN18_CODE'
                                           )
              where b_bvalidity_utc               between nobkey.bvalidity_utc_from and nobkey.bvalidity_utc_to
                and sys_extract_utc(systimestamp) between nobkey.tvalidity_utc_from and nobkey.tvalidity_utc_to
            )
         ,emtperf as
            (select case
                       when emtv.energy_unit = cn_capacity_unit then
                        emtv.energy
                       else
                        emtv.energy * 1000
                    end as emtvle_energy
               from delphidba.emt_energy_measurements emt
               join delphidba.emt_values              emtv on emtv.emt_id        = emt.id
               join nodes                                  on (    emt.code      = nodes.code
                                                               and emt.code_type = nodes.code_type
                                                              )
              where emt.emt_type             = 'NET_GENERATION_PROVISIONAL'
                and emtv.bvalidity_utc_from  = b_bvalidity_utc
                and emtv.bvalidity_utc_to    = b_bvalidity_utc  + interval '0 00:05:00' day to second -- Eindtijd van de PTU
            )
         select sum(emtvle_energy)
           from emtperf;

    r_uay_avy                               uay_availabilities%rowtype;
    v_measurement_ptu_start_time            date;
  begin
    -- De meetwaarden die we op gaan halen komen per 5 minuten binnen. We moeten de PTU hebben die eindigt voor de ptu waarin de outage ontstaan is. Zoek daarom eerst de starttijd van de vorige PTU op.
    v_measurement_ptu_start_time           := trunc(p_avy_in.bvalidity_utc_from, 'mi') - numtodsinterval(mod(to_char(p_avy_in.bvalidity_utc_from, 'mi'), 5),'minute') - interval '0 00:05:00' day to second;
    
    -- Eerst kijken of we uberhaupt wel meegegevens hebben is dat niet zo dat doet deze procedure helemaaal niks, kijk 5 minuten terug je wil de ptu voor de outage hebben
    open c_capacity(b_whole_code      => p_avy_in.code
                   ,b_whole_code_type => p_avy_in.code_type
                   ,b_bvalidity_utc   => v_measurement_ptu_start_time);
    fetch c_capacity into p_avy_in.capacity_quantity;
    close c_capacity;

    if p_avy_in.capacity_quantity is not null then
      -- Er zijn meetgegevens
      -- Maak het availability record aan
      r_uay_avy.id                       := null;
      r_uay_avy.uay_id                   := p_avy_in.uay_id;
      r_uay_avy.org_bvalidity_utc_from   := p_avy_in.org_bvalidity_utc_from;
      r_uay_avy.org_bvalidity_utc_to     := p_avy_in.org_bvalidity_utc_to;
      r_uay_avy.org_ptu                  := p_avy_in.org_ptu;
      r_uay_avy.org_ptu_resolution       := p_avy_in.org_ptu_resolution;
      r_uay_avy.bvalidity_utc_from       := p_avy_in.bvalidity_utc_from;
      r_uay_avy.bvalidity_utc_to         := p_avy_in.bvalidity_utc_to;
      if p_avy_in.capacity_quantity < 0 then 
         r_uay_avy.capacity_quantity     := 0;
      else
         r_uay_avy.capacity_quantity     := p_avy_in.capacity_quantity;
      end if;
      r_uay_avy.capacity_unit            := cn_capacity_unit;

      -- write to table "uay_avalabilities"
      uay_avy_dml.dml_row (p_row => r_uay_avy);
    end if;

    p_avy_in.id := r_uay_avy.id;
  exception
     when others then
        pcs_log_actions.log_error(p_module => cn_module
                                 ,p_text   => 'Parameters'                                                               || chr(10)
                                           || 'p_avy_in.id                    :' ||     p_avy_in.id                      || chr(10)
                                           || 'p_avy_in.uay_id                :' ||     p_avy_in.uay_id                  || chr(10)
                                           || 'p_avy_in.org_bvalidity_utc_from:' ||     p_avy_in.org_bvalidity_utc_from  || chr(10)
                                           || 'p_avy_in.org_bvalidity_utc_to  :' ||     p_avy_in.org_bvalidity_utc_to    || chr(10)
                                           || 'p_avy_in.org_ptu               :' ||     p_avy_in.org_ptu                 || chr(10)
                                           || 'p_avy_in.org_ptu_resolution    :' ||     p_avy_in.org_ptu_resolution      || chr(10)
                                           || 'p_avy_in.bvalidity_utc_from    :' ||     p_avy_in.bvalidity_utc_from      || chr(10)
                                           || 'p_avy_in.bvalidity_utc_to      :' ||     p_avy_in.bvalidity_utc_to        || chr(10)
                                           || 'p_avy_in.capacity_quantity     :' ||     p_avy_in.capacity_quantity       || chr(10)
                                           || 'p_avy_in.capacity_unit         :' ||     p_avy_in.capacity_unit           || chr(10)
                                           || 'p_avy_in.code                  :' ||     p_avy_in.code                    || chr(10)
                                           || 'p_avy_in.code_type             :' ||     p_avy_in.code_type               || chr(10)
                                 );
        raise;
  end create_avy_internal;

  procedure create_avy(p_udc_sender_mrid     in varchar2
                      ,p_udc_mrid            in varchar2
                      ,p_udc_revision_number in number
                      ,p_avy_id              in out nocopy number)  is
  /*********************************************************************************************************************
  Purpose    : Maak het availability record aan als de meetgegevens gevonden zijn.
               Roepen we aan vanuit het EDP_11 transmissie package.
  *********************************************************************************************************************/
    cn_module constant varchar2(61) := cn_package || '.create_avy';

    r_avy_in r_avy_in_type;
  begin
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Parameters'                                       || chr(10)
                                       || 'p_udc_sender_mrid    : ' || p_udc_sender_mrid     || chr(10)
                                       || 'p_udc_mrid           : ' || p_udc_mrid            || chr(10)
                                       || 'p_udc_revision_number: ' || p_udc_revision_number
                             );


    select avy.id
          ,uay.id
          ,udc.bvalidity_utc_from
          ,udc.bvalidity_utc_to
          ,null                      -- vullen we later in
          ,null                      -- vullen we later in
          ,uay.bvalidity_utc_from
          ,uay.bvalidity_utc_to
          ,null                      -- vullen we later in
          ,null                      -- vullen we later in
          ,uay.code
          ,uay.code_type
      into r_avy_in
      from uay_unavailability_docs udc
      join uay_unavailabilities    uay on uay.udc_id = udc.id
      left join uay_availabilities avy on avy.uay_id = uay.id
     where udc.sender_mrid     = p_udc_sender_mrid
       and udc.mrid            = p_udc_mrid
       and udc.revision_number = p_udc_revision_number;

     if r_avy_in.id is null
     then
        -- Availablity record bestaat nog niet maak aan
        r_avy_in.org_ptu := 1;
        r_avy_in.org_ptu_resolution := sup_ojtppy_actions.get_domain_value(p_ojt_code => 'AVY.UNAVAILABILITIES#OUTAGE_OFF_SHORE_GRID_ASSETS.TS_RESOLUTION'
                                                                          ,p_ppy_code => 'ALLOWED_VALUE' );
        r_avy_in.capacity_unit      := cn_capacity_unit;
        create_avy_internal(p_avy_in => r_avy_in);
     end if;

     p_avy_id :=  r_avy_in.id;
     pcs_log_actions.log_trace(p_module => cn_module
                              ,p_text   => 'Parameters'                                       || chr(10)
                                        || 'p_avy_id    : ' || p_avy_id
                             );
  exception
    when others then
       pcs_log_actions.log_error(p_module => cn_module
                                ,p_text   => 'Parameters'                                       || chr(10)
                                          || 'p_udc_sender_mrid    : ' || p_udc_sender_mrid     || chr(10)
                                          || 'p_udc_mrid           : ' || p_udc_mrid            || chr(10)
                                          || 'p_udc_revision_number: ' || p_udc_revision_number
                                );
       raise;
  end create_avy;

  procedure process_uay_tmn_assets (p_result         out varchar2
                                   ,p_xml            in  xmltype
                                   ,p_delivery       in  varchar2
                                   ,p_enqueue_time   in  timestamp)
  is
  /*********************************************************************************************************************
   Purpose    : Verwerk een Unavailablity - bericht
                Bericht bestaat in hoofdlijnen uit:
                - Hoofddocument met mrid, versienummer en de reason-code
                - Timeseries met Unavalabilities, Asset_RegisteredResource en Avalabilities
                - Periodes en bijbehorende hoeveelheden (een point met quantity)
   LET OP: de out parameter staat voor de in paremeter. Ja, dat is lelijk, maar dat moet zo omdat Oracle anders de
           parameter niet goed terug geeft.
   *********************************************************************************************************************/
    cn_module                     constant  varchar2(61)   := cn_package || '.process_uay_tmn_assets';
    cn_ns                         constant  varchar2(4000) := 'xmlns:msg="http://www.tennet.org/msg"';

    cursor c_nob (b_code                 varchar2
                 ,b_code_type            varchar2
                 ,b_bvalidity_utc_from   timestamp)
    is
      select k_object_type
        from mrd_nob_netobjects_vw
       where k_code                = b_code
         and k_code_type           = b_code_type
         and k_bvalidity_utc_from <= b_bvalidity_utc_from;

    cursor c_cpy(b_bvalidity_utc_from uay_unavailabilities.bvalidity_utc_from%type
                ,b_bvalidity_utc_to   uay_unavailabilities.bvalidity_utc_to%type
                ,b_tcy_in_ara_code    tcy_transfer_capacities.in_ara_code%type
                ,b_tcy_out_ara_code   tcy_transfer_capacities.out_ara_code%type)
        is with min_bval -- De datum van eerst bekende NTC-waarde voor deze grens
             as (select min(bvalidity_utc_from) bvalidity_utc_from
                   from tcy_transfer_capacities tcy
                   join tcy_capacities          cpy on tcy.id = cpy.tcy_id
                  where tcy.capacity_type     = 'NET_TRANSFER_CAPACITY_LONG_TERM'
                    and tcy.in_ara_code       = b_tcy_in_ara_code
                    and tcy.out_ara_code      = b_tcy_out_ara_code
                )
                ,caps -- De wisselende capaciteiten met ingangsdatum van die capaciteit
                  as (select capacity
                            ,bvalidity_utc_from
                        from (select capacity
                                     ,bvalidity_utc_from
                                     ,lag (capacity) over (order by bvalidity_utc_from) as previous_capacity
                                 from tcy_transfer_capacities tcy
                                 join tcy_capacities          cpy on tcy.id = cpy.tcy_id
                                where tcy.capacity_type     = 'NET_TRANSFER_CAPACITY_LONG_TERM'
                                  and tcy.in_ara_code       = b_tcy_in_ara_code
                                  and tcy.out_ara_code      = b_tcy_out_ara_code
                             )
                       where capacity != previous_capacity
                       union all
                        -- Haal de eerst bekende NTC-waarde op
                        select capacity
                              ,cpy.bvalidity_utc_from
                          from tcy_transfer_capacities tcy
                          join tcy_capacities          cpy on tcy.id                 = cpy.tcy_id
                          join min_bval                    on cpy.bvalidity_utc_from = min_bval.bvalidity_utc_from
                         where tcy.capacity_type     = 'NET_TRANSFER_CAPACITY_LONG_TERM'
                           and tcy.in_ara_code       = b_tcy_in_ara_code
                           and tcy.out_ara_code      = b_tcy_out_ara_code
                      order by bvalidity_utc_from
                     )
                ,caps_with_dates -- Bepaal de van en tot-datum van de NTC-waardes
                   as (select capacity
                             ,bvalidity_utc_from
                             ,lead(bvalidity_utc_from) over (order by bvalidity_utc_from) as bvalidity_utc_to
                         from caps
                      )
                select capacity -- Bepaal nu alle verschillende NTC waardes binnen het outage-window.
                      ,greatest(b_bvalidity_utc_from, caps_with_dates.bvalidity_utc_from) as bvalidity_utc_from
                      ,least(b_bvalidity_utc_to     , caps_with_dates.bvalidity_utc_to)   as bvalidity_utc_to
                  from caps_with_dates
                 where  bvalidity_utc_from >= (select max(bvalidity_utc_from)
                                                 from caps_with_dates
                                                where bvalidity_utc_from <= b_bvalidity_utc_from)
                 order by bvalidity_utc_from;

    type tt_cpy                 is table of c_cpy%rowtype index by pls_integer;
    t_cpy                                   tt_cpy;

    v_rcn_id                                pcs_rcn_receptions.id%type;
    v_pcs_id                                pcs_processes.id%type;
    v_cre_source                            sup_ojt_ppy.v_value%type;
    v_legal_owner                           sup_ojt_ppy.v_value%type;
    v_content_xml                           xmltype;
    v_ptu_interval                          sup_date_actions.rt_interval;
    v_interval_in_minutes                   number(15,5);
    v_start_datetime                        timestamp;
    v_end_datetime                          timestamp;
    v_statement                             varchar2(2000);
    v_object_type                           varchar2(100);
    v_control_area_nl                       varchar2(100);
    v_ara_object_type                       varchar2(100);
    v_avy_periods_notfound                  boolean default true;

    r_dly                                   sup_deliveries%rowtype;
    r_udc                                   c_udc%rowtype;
    r_uay_doc                               uay_unavailability_docs%rowtype;
    r_uay_rsn                               uay_reasons%rowtype;
    r_uay_uay                               uay_unavailabilities%rowtype;
    r_uay_avy                               uay_availabilities%rowtype;

    e_no_ntc_values_found                   exception;
  begin

    -- write 'Start' into log-trace
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start');

    -- Domeinnamen voor de checks op document-niveau
    v_md_documenttype                        := p_delivery || '.MD_DOCUMENTTYPE';
    v_md_processtype                         := p_delivery || '.MD_PROCESSTYPE';
    v_md_docstatus                           := p_delivery || '.MD_DOCSTATUS';
    v_md_reasons                             := p_delivery || '.MD_REASONCODE';
    v_md_sender_mpt_mrid                     := p_delivery || '.MD_SENDER_MRID';
    v_md_sender_mpt_mrid_cs                  := p_delivery || '.MD_SENDER_MRID_CS';
    v_md_sender_mpt_roletype                 := p_delivery || '.MD_SENDER_MRID_ROLETYPE';
    v_md_receiver_mpt_mrid                   := p_delivery || '.MD_RECEIVER_MRID';
    v_md_receiver_mpt_mrid_cs                := p_delivery || '.MD_RECEIVER_MRID_CS';
    v_md_receiver_mpt_roletype               := p_delivery || '.MD_RECEIVER_MRID_ROLETYPE';

    -- Domeinnamen voor de checks op timeseries-niveau
    v_ts_businesstype                        := p_delivery || '.TS_BUSINESSTYPE';
    v_ts_qty_measure_unit                    := p_delivery || '.TS_QTY_MEASURE_UNIT';
    v_ts_curvetype                           := p_delivery || '.TS_CURVETYPE';
    v_ts_resolution                          := p_delivery || '.TS_RESOLUTION';
    v_ts_arr_mrid_cs                         := p_delivery || '.TS_ARR_MRID_CS';
    v_ts_in_ara_mrid_cs                      := p_delivery || '.TS_IN_ARA_MRID_CS';
    v_ts_out_ara_mrid_cs                     := p_delivery || '.TS_OUT_ARA_MRID_CS';

    /*********************************************************************************************************************
     Initieer de nieuwe reception door een pcs_rcn_reception-record aan te maken en de eerste status te schrijven
     Het zou logisch klinken om dat in de xml-handler te doen, maar we willen registratie van data-receptions scheiden
     van acknowledgements.
     *********************************************************************************************************************/
    v_rcn_id                                     := pcs_rcn_actions.initiate_new_reception (p_xml          => p_xml
                                                                                           ,p_delivery     => p_delivery
                                                                                           ,p_enqueue_time => p_enqueue_time
                                                                                           ,p_start_time   => SYS_EXTRACT_UTC(SYSTIMESTAMP));

    v_control_area_nl                            := mrd_caa_actions.get_area_code_nl(p_code_type   => 'EIC_CODE'
                                                                                    ,p_object_type => 'CONTROL_AREA');

    -- Bepaal ahv de reception het source_system en de legal_owner
    pcs_rcn_actions.get_delivery(p_rcn_id  => v_rcn_id
                                ,p_dly_row => r_dly);

    v_legal_owner                                := r_dly.legal_owner;
    v_cre_source                                 := r_dly.source;

    -- Zet de globals met info die we inmiddels hebben
    sup_globals.set_global(p_name                => cn_legal_owner
                          ,p_value               => v_legal_owner);

    sup_globals.set_global(p_name                => cn_source_system
                          ,p_value               => v_cre_source);

    -- Vul pcs_pcs_processes aan met extra info
    pcs_pcs_actions.update_process(p_cre_source  => v_cre_source
                                  ,p_legal_owner => v_legal_owner);

    -- Doe algemene document-controle
    if sup_mge_checks.check_valid_document(p_xml  => p_xml)
    then
      v_content_xml         := p_xml.extract('//msg:message/msg:content/*', cn_ns);

      if v_content_xml is null
      then
        v_content_xml := p_xml;
      end if;
      -- Parse de xml-nodes naar de global temporary table uay_unavailability_md_gtt
      rcn_parse_unavailability_md.parse_document(p_xml => v_content_xml);

      -- Voer de controles uit en ga het document verwerken als alle controles akkoord zijn
      if check_document
      then
        open c_udc;

        fetch c_udc
         into r_udc;

        if c_udc%found
        then
          pcs_rcn_actions.set_bvalidity(p_rcn_id             => v_rcn_id
                                       ,p_bvalidity_utc_from => sup_date_actions.convert_any_date2timestamp_utc(p_text_date => r_udc.md_uay_ti_startdatetime)
                                       ,p_bvalidity_utc_to   => sup_date_actions.convert_any_date2timestamp_utc(p_text_date => r_udc.md_uay_ti_enddatetime)
                                       );

          -- Voeg info toe aan reception-record
          r_rcn.id                               := v_rcn_id;
          r_rcn.document_mrid                    := r_udc.md_mrid;
          r_rcn.document_version                 := r_udc.md_revisionnumber;
          r_rcn.document_sender_mrid             := r_udc.md_sender_mpt_mrid;
          r_rcn.document_type                    := sup_tln_actions.get_translation(p_tln_elm   => cn_document_type
                                                                                   ,p_tln_code  => r_udc.md_type);
          r_rcn.bvalidity_utc_from               := sup_date_actions.convert_any_date2timestamp_utc(p_text_date => r_udc.md_uay_ti_startdatetime);
          r_rcn.bvalidity_utc_to                 := sup_date_actions.convert_any_date2timestamp_utc(p_text_date => r_udc.md_uay_ti_enddatetime);
          pcs_rcn_actions.add_info_to_reception(p_rcn_row => r_rcn);

          -- verwijder 'DPI_11_' van het document_mRID (uitgaand wordt hier dan 'EDP_10_' voor gezet)
          r_uay_doc.mrid                         := replace(r_udc.md_mrid,sup_ojtppy_actions.get_domain_value(p_ojt_code => p_delivery
                                                                                                             ,p_ppy_code => cn_mrid_prefix)
                                                           ,'');
          r_uay_doc.sender_mrid                  := r_udc.md_sender_mpt_mrid;
          r_uay_doc.revision_number              := r_udc.md_revisionnumber;
          r_uay_doc.bvalidity_utc_from           := sup_date_actions.convert_any_date2timestamp_utc (r_udc.md_uay_ti_startdatetime);
          r_uay_doc.bvalidity_utc_to             := sup_date_actions.convert_any_date2timestamp_utc(r_udc.md_uay_ti_enddatetime);
          r_uay_doc.status                       := sup_tln_actions.get_translation(p_tln_elm  => cn_docstatus
                                                                                   ,p_tln_code => r_udc.md_docstatus);
          r_uay_doc.object_type                  := sup_tln_actions.get_translation(p_tln_elm  => cn_document_type
                                                                                   ,p_tln_code => r_udc.md_type);
          r_uay_doc.unavailability_type          := sup_tln_actions.get_translation(p_tln_elm  => cn_unavailability_type
                                                                                   ,p_tln_code => r_udc.md_type);

          -- write to table "uay_unavalability_docs"
          uay_udc_dml.dml_row (p_row => r_uay_doc);

          -- Reasons
          for r_udc_rsn in c_udc_rsn
          loop
            r_uay_rsn.id                         := null;
            r_uay_rsn.uay_id                     := null;
            r_uay_rsn.udc_id                     := r_uay_doc.id;
            r_uay_rsn.code                       := sup_tln_actions.get_translation(p_tln_elm  => cn_reasoncode
                                                                                   ,p_tln_code => r_udc_rsn.md_rn_code);
            r_uay_rsn.text                       := r_udc_rsn.md_rn_text;

            -- write to table "uay_reasons"
            uay_rsn_dml.dml_row (p_row => r_uay_rsn);
          end loop;

          -- Timeseries
          <<timeseries>>
          for r_timeseries in c_timeseries
          loop

            r_uay_uay.id                         := null;
            r_uay_uay.udc_id                     := r_uay_doc.id;
            r_uay_uay.bvalidity_utc_from         := sup_date_actions.convert_any_date2timestamp_utc (r_timeseries.ts_startdate|| 'T'||r_timeseries.ts_starttime);
            r_uay_uay.bvalidity_utc_to           := sup_date_actions.convert_any_date2timestamp_utc (r_timeseries.ts_enddate|| 'T'||r_timeseries.ts_endtime);

            -- asset_RegisteredResource
            <<registered_resource>>
            for r_registered_resource in c_registered_resource (b_timeserie_mrid => r_timeseries.ts_mrid)
            loop
              r_uay_uay.code                     := r_registered_resource.arr_mrid;
              r_uay_uay.code_type                := sup_tln_actions.get_translation(p_tln_elm  => cn_codingscheme
                                                                                   ,p_tln_code => r_registered_resource.arr_mrid_cs);

              -- MRD -> check of het object bekend is (code, code_type) en gebruik de bijbehorende object_type
              open c_nob(b_code                 => r_uay_uay.code
                        ,b_code_type            => r_uay_uay.code_type
                        ,b_bvalidity_utc_from   => r_uay_uay.bvalidity_utc_from);
              fetch c_nob into v_object_type;
              close c_nob;

              -- als het netobject niet is gevonden, log een warning en zet object_type op 'UNKNOWN'
              if v_object_type is null
              then
                pcs_log_actions.log_warning(p_module => cn_module
                                           ,p_text   => 'Code ' || r_uay_uay.code ||
                                                        ' met code_type ' || r_uay_uay.code_type ||
                                                        ' staat niet in het MRD.' );

                r_uay_uay.object_type            := 'UNKNOWN';
              else
                r_uay_uay.object_type            := v_object_type;
              end if;

            end loop registered_resource;

            r_uay_uay.planning_type              := sup_tln_actions.get_translation(p_tln_elm  => cn_businesstype
                                                                                   ,p_tln_code => r_timeseries.ts_businesstype);
            r_uay_uay.curve_type                 := sup_tln_actions.get_translation(p_tln_elm  => cn_curvetype
                                                                                   ,p_tln_code => r_timeseries.ts_curvetype);
            r_uay_uay.timeseries_mrid            := r_timeseries.ts_mrid;

            -- Bepaal de area_code_type. Als de niet_Nederlandse kant een CONTROL_AREA is, moet de NL-kant dan ook zijn en anders beiden eenm BIDDING_ZONE
            -- Bepaal de area_object_type van de niet NL-kant
            if r_timeseries.ts_in_domain_mrid = v_control_area_nl then
               v_ara_object_type                 := get_ara_object_type(p_code                    => r_timeseries.ts_out_domain_mrid
                                                                       ,p_code_type               => sup_tln_actions.get_translation(p_tln_elm  => cn_codingscheme
                                                                                                                                    ,p_tln_code => r_timeseries.ts_out_domain_mrid_cs)
                                                                       ,p_bvalidity_utc_timestamp => r_uay_uay.bvalidity_utc_from);
            else
               v_ara_object_type                 := get_ara_object_type(p_code                    => r_timeseries.ts_in_domain_mrid
                                                                       ,p_code_type               => sup_tln_actions.get_translation(p_tln_elm  => cn_codingscheme
                                                                                                                                    ,p_tln_code => r_timeseries.ts_in_domain_mrid_cs)
                                                                       ,p_bvalidity_utc_timestamp => r_uay_uay.bvalidity_utc_from);
            end if;

            r_uay_uay.in_ara_code                := r_timeseries.ts_in_domain_mrid;
            r_uay_uay.in_ara_object_type         := v_ara_object_type;
            r_uay_uay.in_ara_code_type           := sup_tln_actions.get_translation(p_tln_elm  => cn_codingscheme
                                                                                   ,p_tln_code => r_timeseries.ts_in_domain_mrid_cs);
            r_uay_uay.out_ara_code               := r_timeseries.ts_out_domain_mrid;
            r_uay_uay.out_ara_object_type        := v_ara_object_type;
            r_uay_uay.out_ara_code_type          := sup_tln_actions.get_translation(p_tln_elm  => cn_codingscheme
                                                                                   ,p_tln_code => r_timeseries.ts_out_domain_mrid_cs);
            -- write to table "uay_unavalabilities"
            uay_uay_dml.dml_row (p_row => r_uay_uay);

            -- Avalabilities
            <<avy_periods>>
            for r_avy_periods in c_avy_periods (b_timeserie_mrid => r_timeseries.ts_mrid)
            loop
              v_avy_periods_notfound             := false;

              r_uay_avy.id                       := null;
              r_uay_avy.uay_id                   := r_uay_uay.id;
              v_start_datetime                   := sup_date_actions.convert_any_date2timestamp_utc (r_avy_periods.ap_ti_start_datetime);
              v_end_datetime                     := sup_date_actions.convert_any_date2timestamp_utc (r_avy_periods.ap_ti_end_datetime);
              r_uay_avy.org_bvalidity_utc_from   := v_start_datetime;
              r_uay_avy.org_bvalidity_utc_to     := v_end_datetime;
              r_uay_avy.org_ptu_resolution       := r_avy_periods.ap_resolution;
              v_interval_in_minutes              := sup_date_actions.translate_resolution_2_minutes(r_avy_periods.ap_resolution);

              <<avy_points>>
              for r_avy_points in c_avy_points ( b_timeserie_mrid        => r_timeseries.ts_mrid
                                               , b_ap_ti_start_datetime  => v_start_datetime
                                               , b_ap_ti_end_datetime    => v_end_datetime )
              loop
                r_uay_avy.org_ptu                := r_avy_points.ap_point_position;
                if r_avy_points.ap_point_position = nvl(r_avy_points.next_point,r_avy_points.ap_point_position)
                then
                  --als de next_point leeg of gelijk aan de org_ptu is, dan is de endtime gelijk aan de ap_ti_end_datetime
                  v_ptu_interval.starttime           := sup_date_actions.get_utc_startmoment_by_ptu(p_utc_datetime        => v_start_datetime
                                                                                                   ,p_interval_in_minutes => v_interval_in_minutes
                                                                                                   ,p_ptu                 => r_uay_avy.org_ptu);
                  v_ptu_interval.endtime             := v_end_datetime;
                else
                  v_ptu_interval                     := sup_date_actions.get_utc_timeinterval_by_ptu(p_utc_datetime        => v_start_datetime
                                                                                                    ,p_interval_in_minutes => v_interval_in_minutes
                                                                                                    ,p_ptu_start           => r_uay_avy.org_ptu
                                                                                                    ,p_ptu_eind            => r_avy_points.next_point
                                                                                                    );
                end if;
                r_uay_avy.bvalidity_utc_from       := v_ptu_interval.starttime;
                r_uay_avy.bvalidity_utc_to         := v_ptu_interval.endtime;
                r_uay_avy.capacity_quantity        := r_avy_points.ap_point_quantity;
                r_uay_avy.capacity_unit            := r_timeseries.ts_qty_measure_unit_name;
  
                -- write to table "uay_avalabilities"
                uay_avy_dml.dml_row (p_row => r_uay_avy);

              end loop avy_points;
      
            end loop avy_periods;

            if v_avy_periods_notfound then
              -- bij afwezigheid van Available_Period maken we availability records aan met de long term NTC waarde
              -- Let op: dit doen we met een bulk collect in een pl/sql table. Het zijn niet veel records, maar zo kunnen we
              -- bepalen of het het laatst gevonden record is. Stel dat de laatste NTC-waarde een einddatum heeft die voor de einddatum van de outage
              -- ligt, dan gebruiken we die waarde tot aan het einde
              open c_cpy(b_bvalidity_utc_from => r_uay_uay.bvalidity_utc_from
                        ,b_bvalidity_utc_to   => r_uay_uay.bvalidity_utc_to
                        ,b_tcy_in_ara_code    => r_uay_uay.in_ara_code
                        ,b_tcy_out_ara_code   => r_uay_uay.out_ara_code
                        );
              fetch c_cpy
               bulk collect
               into t_cpy;

              close c_cpy;

              if t_cpy.count > 0 then
                 for indx in t_cpy.first .. t_cpy.last loop
                   -- Als we een NTC waarde hebben die ingaat na de outage periode zijn we klaar
                   exit when t_cpy(indx).bvalidity_utc_from > r_uay_uay.bvalidity_utc_to;

                   r_uay_avy.id                       := null;
                   r_uay_avy.uay_id                   := r_uay_uay.id;
                   r_uay_avy.org_bvalidity_utc_from   := t_cpy(indx).bvalidity_utc_from;
                   r_uay_avy.bvalidity_utc_from       := t_cpy(indx).bvalidity_utc_from;

                   -- Bij de laatste NTC waarde de eind-datum van de outage meenemen als die na de einddatum uit de cursor blijkt te liggen
                   -- (we hebben dan geen NTC-waarde tot het eind)
                   if indx                            = t_cpy.count
                   and (   t_cpy(indx).bvalidity_utc_to is null                      -- Bij de laatst bekende NTC-waarde is de to-datum leeg vanuit de cursor.
                        or r_uay_uay.bvalidity_utc_to > t_cpy(indx).bvalidity_utc_to -- dit komt waarschijnlijk niet voor, maar voor de zekerheid....
                       )
                   then
                      r_uay_avy.org_bvalidity_utc_to  := r_uay_uay.bvalidity_utc_to;
                      r_uay_avy.bvalidity_utc_to      := r_uay_uay.bvalidity_utc_to;
                   else
                      r_uay_avy.org_bvalidity_utc_to  := t_cpy(indx).bvalidity_utc_to;
                      r_uay_avy.bvalidity_utc_to      := t_cpy(indx).bvalidity_utc_to;
                   end if;

                   r_uay_avy.org_ptu                  := '1';
                   r_uay_avy.org_ptu_resolution       := sup_ojtppy_actions.get_domain_value(p_ojt_code => p_delivery
                                                                                            ,p_ppy_code => 'PTU_RESOLUTION');
                   r_uay_avy.capacity_quantity        := t_cpy(indx).capacity;
                   r_uay_avy.capacity_unit            := sup_constants.cn_measure_unit_maw;

                   -- write to table "uay_avalabilities"
                   uay_avy_dml.dml_row (p_row => r_uay_avy);
                 end loop;
              else
                raise e_no_ntc_values_found;
              end if;
            end if;

          end loop timeseries;

          if sup_psh_actions.is_pbn_active('EDP_10') then
            -- start de EDP_10
            v_statement                := ' begin'
                                       || '   tmn_edp_10.start_publication (p_udc_sender_mrid     => ''' || r_uay_doc.sender_mrid ||''''
                                       || '                                ,p_udc_mrid            => ''' || r_uay_doc.mrid ||''''
                                       || '                                ,p_udc_revision_number => ''' || r_uay_doc.revision_number ||''''
                                       || '                                ,p_runtime_utc         => cast(systimestamp at time zone ''UTC'' as timestamp)'
                                       || '                                ,p_parent_pcs_id       => ' || sup_globals.get_global_number(p_name => cn_process_id)
                                       || '                                 );'
                                       || ' end;';

            dbms_scheduler.create_job (job_name    => substr('PUBLISH_EDP_10' || to_char(current_timestamp, 'yyyymmddhh24missff'),1,30)
                                      ,job_type    => 'PLSQL_BLOCK'
                                      ,job_action  => v_statement
                                      ,start_date  => to_timestamp_tz(to_char(current_timestamp + interval '0 00:01:00' day to second
                                                                             ,'DD-MM-YYYY HH24:MI:SS ') || 'EUROPE/AMSTERDAM'
                                                                             ,'DD-MM-YYYY HH24:MI:SS TZR')
                                      ,enabled     => true
                                     );
          end if;

          -- Maak hier het dqf_results record aan. Dan kunnen we namelijk ook zien dat een EDP_10 niet verstuurd is als de job niet start.
          -- Hierdoor is het wel mogelijk dat er een 2e record aangemaakt wordt voor dezelfde transmissie als er 2 berichten heel kort na elkaar komen.
          -- Als dat problemen geeft moeten we daar nog maar eens naar kijken
          -- N.B. p_enqueue_time LIJKT een LOCAL tijd maar IS stiekem een UTC-tijd, vandaar de convertutc2local_ts.
          v_pcs_id                     := sup_globals.get_global_number(cn_process_id);
          sup_globals.save_process_globals;
          dqf_rst_actions.fill_expectation_data(p_process              => 'EDP_10'
                                               ,p_bvalidity_utc_from   => r_rcn.bvalidity_utc_from
                                               ,p_bvalidity_utc_to     => r_rcn.bvalidity_utc_to
                                               ,p_mrid                 => 'EDP_10_' || r_uay_doc.mrid
                                               ,p_check_name           => 'EDP_10'
                                               ,p_check_time           => systimestamp at time zone sup_constants.cn_loc_timezone
                                               ,p_deadline_input       => sup_date_actions.convertutc2local_ts(p_enqueue_time) -- De deadline is 1 uur na het aanleveren van het bericht
                                               ,p_processing_time_utc  => systimestamp at time zone sup_constants.cn_utc_timezone
                                               );
          sup_globals.restore_process_globals(p_pcs_id => v_pcs_id);

          pcs_rse_actions.set_rcn_state(p_rcn_id => v_rcn_id
                                       ,p_state  => sup_constants.cn_rcn_state_tmn_started);

        end if;          -- EINDE van "if c_udc%found"

        close c_udc;

        -- Klaar, zet de receptionstatus op 'SAVED'. Ook dat hier doen en niet in de xmlhandler om de data-receptions te scheiden van de acknowledgements
        pcs_rse_actions.set_rcn_state(p_rcn_id      => v_rcn_id
                                     ,p_state       => sup_constants.cn_rcn_state_saved);

        -- Whoepie! Alles is goed gegaan, dus zet de result-status op 'OK'
        p_result                                    := sup_constants.cn_processed_ok;

      else

        pcs_log_actions.log_error(p_module => cn_module
                                 ,p_text   => 'Document not processed, checks failed. See table pcs_mge_check_results (pcs_id = '
                                           || sup_globals.get_global_number(p_name => cn_process_id)
                                           || ') for more information'
                                 );

        p_result                                 := sup_constants.cn_processed_nok;

      end if;         -- EINDE van "check_document"

    else

      -- Algemene document-controle is gefaald, zet status op FAILED
      pcs_rse_actions.set_rcn_state(p_rcn_id     => v_rcn_id
                                   ,p_state      => sup_constants.cn_rcn_state_invalid);

      pcs_log_actions.log_error(p_module         => cn_module
                               ,p_text           => 'Document not processed, invalid document!');

      p_result                                   := sup_constants.cn_processed_nok;

    end if;         -- EINDE van "check_valid_document"

    -- Start nu de AVY_TACK transmissie
    v_statement := ' begin'
                || ' tmn_acknowledgements.send_acknowledgement(p_rcn_id => ' || v_rcn_id
                || '                                          ,p_pcs_id => ' || sup_globals.get_global_number(p_name => cn_process_id)
                || '                                          );'
                || ' end;';

    pcs_log_actions.log_debug(p_module => cn_module
                             ,p_text   => 'Start'
                                       ||chr(10)||' een Transmission met'
                                       ||chr(10)||' v_statement: '||v_statement
                             );

    dbms_scheduler.create_job ( job_name        => 'AVY_TACK_'||to_char(systimestamp,'sssssff2')
                              , job_type        => 'PLSQL_BLOCK'
                              , job_action      => v_statement
                              , start_date      => to_timestamp_tz(to_char(current_timestamp + interval '0 00:01:00' day to second,'DD-MM-YYYY HH24:MI:SS ')||'EUROPE/AMSTERDAM','DD-MM-YYYY HH24:MI:SS TZR')
                              , enabled         => true
                              );

    -- write 'End' into log-trace
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End'
                             ||chr(10)||'  p_result: '|| p_result
                             );

  exception
    when e_no_ntc_values_found then
      pcs_log_actions.log_error(p_module       => cn_module
                               ,p_text         => 'No NTC values found for border ' || r_uay_uay.in_ara_code ||'(IN) to '|| r_uay_uay.out_ara_code || '(OUT)' );
      p_result                                   := sup_constants.cn_processed_nok;
      if c_udc%isopen then
         close c_udc;
      end if;
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      p_result                                   := sup_constants.cn_processed_nok;
      if c_udc%isopen then
         close c_udc;
      end if;

  end process_uay_tmn_assets;
  --
  procedure process_uay_off_shore_tmn_assets (p_result         out varchar2
                                             ,p_xml            in  xmltype
                                             ,p_delivery       in  varchar2
                                             ,p_enqueue_time   in  timestamp)
  is
  /*********************************************************************************************************************
   Purpose    : Verwerk een Unplanned Unavailablity Offshore- bericht
                Bericht bestaat in hoofdlijnen uit:
                - Hoofddocument met mrid, versienummer en de reason-code
                - Timeseries met Unavalabilities, Asset_RegisteredResource en Availabilities
                - Periodes en bijbehorende hoeveelheden (een point met quantity)
   LET OP: de out parameter staat voor de in paremeter. Ja, dat is lelijk, maar dat moet zo omdat Oracle anders de
           parameter niet goed terug geeft.
   *********************************************************************************************************************/
    cn_module                     constant  varchar2(61)   := cn_package || '.process_uay_off_shore_tmn_assets';
    cn_ns                         constant  varchar2(4000) := 'xmlns:msg="http://www.tennet.org/msg"';

    cursor c_nob (b_code                 varchar2
                 ,b_code_type            varchar2
                 ,b_bvalidity_utc_from   timestamp)
    is
      select k_object_type
        from mrd_nob_netobjects_vw
       where k_code                = b_code
         and k_code_type           = b_code_type
         and k_bvalidity_utc_from <= b_bvalidity_utc_from;

    v_rcn_id                                pcs_rcn_receptions.id%type;
    v_pcs_id                                pcs_processes.id%type;
    v_cre_source                            sup_ojt_ppy.v_value%type;
    v_legal_owner                           sup_ojt_ppy.v_value%type;
    v_content_xml                           xmltype;
    v_object_type                           varchar2(100);

    r_dly                                   sup_deliveries%rowtype;
    r_udc                                   c_udc%rowtype;
    r_uay_doc                               uay_unavailability_docs%rowtype;
    r_uay_rsn                               uay_reasons%rowtype;
    r_uay_uay                               uay_unavailabilities%rowtype;
    r_avy_in                                r_avy_in_type;
  begin

    -- write 'Start' into log-trace
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start');

    -- Domeinnamen voor de checks op document-niveau
    v_md_documenttype                        := p_delivery || '.MD_DOCUMENTTYPE';
    v_md_processtype                         := p_delivery || '.MD_PROCESSTYPE';
    v_md_docstatus                           := p_delivery || '.MD_DOCSTATUS';
    v_md_reasons                             := p_delivery || '.MD_REASONCODE';
    v_md_sender_mpt_mrid                     := p_delivery || '.MD_SENDER_MRID';
    v_md_sender_mpt_mrid_cs                  := p_delivery || '.MD_SENDER_MRID_CS';
    v_md_sender_mpt_roletype                 := p_delivery || '.MD_SENDER_MRID_ROLETYPE';
    v_md_receiver_mpt_mrid                   := p_delivery || '.MD_RECEIVER_MRID';
    v_md_receiver_mpt_mrid_cs                := p_delivery || '.MD_RECEIVER_MRID_CS';
    v_md_receiver_mpt_roletype               := p_delivery || '.MD_RECEIVER_MRID_ROLETYPE';

    -- Domeinnamen voor de checks op timeseries-niveau
    v_ts_businesstype                        := p_delivery || '.TS_BUSINESSTYPE';
    v_ts_qty_measure_unit                    := p_delivery || '.TS_QTY_MEASURE_UNIT';
    v_ts_curvetype                           := p_delivery || '.TS_CURVETYPE';
    v_ts_resolution                          := p_delivery || '.TS_RESOLUTION';
    v_ts_arr_mrid_cs                         := p_delivery || '.TS_ARR_MRID_CS';
    v_ts_in_ara_mrid_cs                      := p_delivery || '.TS_IN_ARA_MRID_CS';
    v_ts_out_ara_mrid_cs                     := p_delivery || '.TS_OUT_ARA_MRID_CS';

    /*********************************************************************************************************************
     Initieer de nieuwe reception door een pcs_rcn_reception-record aan te maken en de eerste status te schrijven
     Het zou logisch klinken om dat in de xml-handler te doen, maar we willen registratie van data-receptions scheiden
     van acknowledgements.
     *********************************************************************************************************************/
    v_rcn_id                                     := pcs_rcn_actions.initiate_new_reception (p_xml          => p_xml
                                                                                           ,p_delivery     => p_delivery
                                                                                           ,p_enqueue_time => p_enqueue_time
                                                                                           ,p_start_time   => SYS_EXTRACT_UTC(SYSTIMESTAMP));

    -- Bepaal ahv de reception het source_system en de legal_owner
    pcs_rcn_actions.get_delivery(p_rcn_id  => v_rcn_id
                                ,p_dly_row => r_dly);

    v_legal_owner                                := r_dly.legal_owner;
    v_cre_source                                 := r_dly.source;

    -- Zet de globals met info die we inmiddels hebben
    sup_globals.set_global(p_name                => cn_legal_owner
                          ,p_value               => v_legal_owner);

    sup_globals.set_global(p_name                => cn_source_system
                          ,p_value               => v_cre_source);

    -- Vul pcs_pcs_processes aan met extra info
    pcs_pcs_actions.update_process(p_cre_source  => v_cre_source
                                  ,p_legal_owner => v_legal_owner);

    -- Doe algemene document-controle
    if sup_mge_checks.check_valid_document(p_xml  => p_xml)
    then
      v_content_xml         := p_xml.extract('//msg:message/msg:content/*', cn_ns);

      -- Parse de xml-nodes naar de global temporary table uay_unavailability_md_gtt
      rcn_parse_unavailability_md.parse_document(p_xml => v_content_xml);

      -- Voer de controles uit en ga het document verwerken als alle controles akkoord zijn
      if check_document
      then
        open c_udc;

        fetch c_udc
         into r_udc;

        if c_udc%found
        then
          pcs_rcn_actions.set_bvalidity(p_rcn_id             => v_rcn_id
                                       ,p_bvalidity_utc_from => sup_date_actions.convert_any_date2timestamp_utc(p_text_date => r_udc.md_uay_ti_startdatetime)
                                       ,p_bvalidity_utc_to   => sup_date_actions.convert_any_date2timestamp_utc(p_text_date => r_udc.md_uay_ti_enddatetime)
                                       );

          -- Voeg info toe aan reception-record
          r_rcn.id                               := v_rcn_id;
          r_rcn.document_mrid                    := r_udc.md_mrid;
          r_rcn.document_version                 := r_udc.md_revisionnumber;
          r_rcn.document_sender_mrid             := r_udc.md_sender_mpt_mrid;
          r_rcn.document_type                    := sup_tln_actions.get_translation(p_tln_elm   => cn_document_type
                                                                                   ,p_tln_code  => r_udc.md_type);
          r_rcn.bvalidity_utc_from               := sup_date_actions.convert_any_date2timestamp_utc(p_text_date => r_udc.md_uay_ti_startdatetime);
          r_rcn.bvalidity_utc_to                 := sup_date_actions.convert_any_date2timestamp_utc(p_text_date => r_udc.md_uay_ti_enddatetime);
          pcs_rcn_actions.add_info_to_reception(p_rcn_row => r_rcn);

          -- verwijder 'DPI_12_' van het document_mRID (uitgaand wordt hier dan 'EDP_11_' voor gezet)
          r_uay_doc.mrid                         := replace(r_udc.md_mrid,sup_ojtppy_actions.get_domain_value(p_ojt_code => p_delivery
                                                                                                             ,p_ppy_code => cn_mrid_prefix)
                                                           ,'');
          r_uay_doc.sender_mrid                  := r_udc.md_sender_mpt_mrid;
          r_uay_doc.revision_number              := r_udc.md_revisionnumber;
          r_uay_doc.bvalidity_utc_from           := sup_date_actions.convert_any_date2timestamp_utc(r_udc.md_uay_ti_startdatetime);
          r_uay_doc.bvalidity_utc_to             := sup_date_actions.convert_any_date2timestamp_utc(r_udc.md_uay_ti_enddatetime);
          r_uay_doc.status                       := sup_tln_actions.get_translation(p_tln_elm  => cn_docstatus
                                                                                   ,p_tln_code => r_udc.md_docstatus);
          r_uay_doc.object_type                  := sup_tln_actions.get_translation(p_tln_elm  => cn_document_type
                                                                                   ,p_tln_code => r_udc.md_type);
          r_uay_doc.unavailability_type          := sup_tln_actions.get_translation(p_tln_elm  => cn_unavailability_type
                                                                                   ,p_tln_code => r_udc.md_type);

          -- write to table "uay_unavalability_docs"
          uay_udc_dml.dml_row (p_row => r_uay_doc);

          -- Reasons
          for r_udc_rsn in c_udc_rsn
          loop
            r_uay_rsn.id                         := null;
            r_uay_rsn.uay_id                     := null;
            r_uay_rsn.udc_id                     := r_uay_doc.id;
            r_uay_rsn.code                       := sup_tln_actions.get_translation(p_tln_elm  => cn_reasoncode
                                                                                   ,p_tln_code => r_udc_rsn.md_rn_code);
            r_uay_rsn.text                       := r_udc_rsn.md_rn_text;

            -- write to table "uay_reasons"
            uay_rsn_dml.dml_row (p_row => r_uay_rsn);
          end loop;

          -- Timeseries
          <<timeseries>>
          for r_timeseries in c_timeseries
          loop
            r_uay_uay.id                         := null;
            r_uay_uay.udc_id                     := r_uay_doc.id;
            r_uay_uay.bvalidity_utc_from         := sup_date_actions.convert_any_date2timestamp_utc (r_timeseries.ts_startdate|| 'T'||r_timeseries.ts_starttime);
            r_uay_uay.bvalidity_utc_to           := sup_date_actions.convert_any_date2timestamp_utc (r_timeseries.ts_enddate|| 'T'||r_timeseries.ts_endtime);

            -- asset_RegisteredResource
            <<registered_resource>>
            for r_registered_resource in c_registered_resource (b_timeserie_mrid => r_timeseries.ts_mrid)
            loop
              r_uay_uay.code                     := r_registered_resource.arr_mrid;
              r_uay_uay.code_type                := sup_tln_actions.get_translation(p_tln_elm  => cn_codingscheme
                                                                                   ,p_tln_code => r_registered_resource.arr_mrid_cs);

              -- MRD -> check of het object bekend is (code, code_type) en gebruik de bijbehorende object_type
              open c_nob(b_code                 => r_uay_uay.code
                        ,b_code_type            => r_uay_uay.code_type
                        ,b_bvalidity_utc_from   => r_uay_uay.bvalidity_utc_from);
              fetch c_nob into v_object_type;
              close c_nob;

              -- Als het net-object niet bestaat moet er een fout (severity = E) gelogd worden en moet de verwerking van het bericht stoppen.
              if v_object_type is null
              then
                pcs_log_actions.log_error(p_module => cn_module
                                         ,p_text   => 'Code ' || r_uay_uay.code ||' met code_type ' || r_uay_uay.code_type ||' staat niet in het MRD.'
                                         );
                raise_application_error(-20001, 'Code and code_type Not found in MRD!');
              else
                r_uay_uay.object_type            := v_object_type;
              end if;

            end loop registered_resource;

            r_uay_uay.planning_type              := sup_tln_actions.get_translation(p_tln_elm  => cn_businesstype
                                                                                   ,p_tln_code => r_timeseries.ts_businesstype);
            r_uay_uay.curve_type                 := sup_tln_actions.get_translation(p_tln_elm  => cn_curvetype
                                                                                   ,p_tln_code => r_timeseries.ts_curvetype);
            r_uay_uay.timeseries_mrid            := r_timeseries.ts_mrid;

            -- write to table "uay_unavalabilities"
            uay_uay_dml.dml_row (p_row => r_uay_uay);

            r_avy_in.uay_id                 := r_uay_uay.id;
            r_avy_in.org_bvalidity_utc_from := r_uay_doc.bvalidity_utc_from;
            r_avy_in.org_bvalidity_utc_to   := r_uay_doc.bvalidity_utc_to;
            r_avy_in.org_ptu                := 1;
            r_avy_in.org_ptu_resolution     := sup_ojtppy_actions.get_domain_value(p_ojt_code => 'AVY.UNAVAILABILITIES#OUTAGE_OFF_SHORE_GRID_ASSETS.TS_RESOLUTION'
                                                                                  ,p_ppy_code => 'ALLOWED_VALUE' );

            r_avy_in.bvalidity_utc_from     := r_uay_doc.bvalidity_utc_from;
            r_avy_in.bvalidity_utc_to       := r_uay_doc.bvalidity_utc_to;
            r_avy_in.code                   := r_uay_uay.code;
            r_avy_in.code_type              := r_uay_uay.code_type;

            create_avy_internal(p_avy_in => r_avy_in);
          end loop timeseries;

          v_pcs_id                          := sup_globals.get_global_number(cn_process_id);

          -- start de EDP_11
          if sup_psh_actions.is_pbn_active('EDP_11') then
             commit; -- Stom dat dit nodig is waarom dan? Maar ja het werkt
             sup_globals.save_process_globals;

             tmn_edp_11.start_publication (p_udc_sender_mrid     => r_uay_doc.sender_mrid
                                          ,p_udc_mrid            => r_uay_doc.mrid
                                          ,p_udc_revision_number => r_uay_doc.revision_number
                                          ,p_runtime_utc         => sys_extract_utc(systimestamp)
                                          ,p_parent_pcs_id       => v_pcs_id
                                          );

             sup_globals.restore_process_globals(p_pcs_id => v_pcs_id);

             -- Maak hier het dqf_results record aan. Dan kunnen we namelijk ook zien dat een EDP_11 niet verstuurd is als de job niet start.
             -- Hierdoor is het wel mogelijk dat er een 2e record aangemaakt wordt voor dezelfde transmissie als er 2 berichten heel kort na elkaar komen.
             -- Als dat problemen geeft moeten we daar nog maar eens naar kijken
             -- N.B. p_enqueue_time LIJKT een LOCAL tijd maar IS stiekem een UTC-tijd, vandaar de convertutc2local_ts.
             v_pcs_id                          := sup_globals.get_global_number(cn_process_id);
             sup_globals.save_process_globals;
             dqf_rst_actions.fill_expectation_data(p_process              => 'EDP_11'
                                                  ,p_bvalidity_utc_from   => r_rcn.bvalidity_utc_from
                                                  ,p_bvalidity_utc_to     => r_rcn.bvalidity_utc_to
                                                  ,p_mrid                 => 'EDP_11_' || r_uay_doc.mrid
                                                  ,p_check_name           => 'EDP_11'
                                                  ,p_check_time           => systimestamp at time zone sup_constants.cn_loc_timezone
                                                  ,p_deadline_input       => sup_date_actions.convertutc2local_ts(p_enqueue_time) -- De deadline is 1 uur na het aanleveren van het bericht
                                                  ,p_processing_time_utc  => systimestamp at time zone sup_constants.cn_utc_timezone
                                                  );
             sup_globals.restore_process_globals(p_pcs_id => v_pcs_id);

             pcs_rse_actions.set_rcn_state(p_rcn_id => v_rcn_id
                                          ,p_state  => sup_constants.cn_rcn_state_tmn_started);
          end if;
        end if;          -- EINDE van "if c_udc%found"

        close c_udc;

        -- Klaar, zet de receptionstatus op 'SAVED'. Ook dat hier doen en niet in de xmlhandler om de data-receptions te scheiden van de acknowledgements
        pcs_rse_actions.set_rcn_state(p_rcn_id      => v_rcn_id
                                     ,p_state       => sup_constants.cn_rcn_state_saved);

        -- Whoepie! Alles is goed gegaan, dus zet de result-status op 'OK'
        p_result                                    := sup_constants.cn_processed_ok;

      else
        pcs_log_actions.log_error(p_module => cn_module
                                 ,p_text   => 'Document not processed, checks failed. See table pcs_mge_check_results (pcs_id = '
                                           || sup_globals.get_global_number(p_name => cn_process_id)
                                           || ') for more information'
                                 );

        p_result                                 := sup_constants.cn_processed_nok;

      end if;         -- EINDE van "check_document"
    else
      -- Algemene document-controle is gefaald, zet status op FAILED
      pcs_rse_actions.set_rcn_state(p_rcn_id     => v_rcn_id
                                   ,p_state      => sup_constants.cn_rcn_state_invalid);

      pcs_log_actions.log_error(p_module         => cn_module
                               ,p_text           => 'Document not processed, invalid document!');

      p_result                                   := sup_constants.cn_processed_nok;
    end if;         -- EINDE van "check_valid_document"

    v_pcs_id                                     := sup_globals.get_global_number(cn_process_id);
    sup_globals.save_process_globals;

    -- Start nu de AVY_TACK transmissie
    tmn_acknowledgements.send_acknowledgement(p_rcn_id => v_rcn_id
                                             ,p_pcs_id => v_pcs_id
                                             );


    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End'
                             ||chr(10)||'  p_result: '|| p_result
                             );

  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      p_result       := sup_constants.cn_processed_nok;

      if c_udc%isopen then
         close c_udc;
      end if;
  end process_uay_off_shore_tmn_assets;
end rcn_uay_tmn_assets;
/
