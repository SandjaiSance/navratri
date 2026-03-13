create or replace package body pcs_rcn_actions
is
  --
  /****************************************************************************************************************************************
   Purpose    : handle a row towards the underlying tables or
                compose a row from the underlying tables

   Change History
   Date        Author            Version   Description
   ----------  ----------------  -------   ------------------------------------------------------------------------------------------------
   29-05-2017  A el Azzouzi      01.00.00  created
   22-06-2017  X. Pikaar         01.00.01  create_new_rcn_row gewijzigd in functie create_new_rcn_row. Functie
                                           initiate_new_reception toegevoegd
   23-06-2017  X. Pikaar         01.00.02  Status STARTED wegschrijven bij de reception-status
   21-07-2017  X. Pikaar         01.00.03  Status SUPPLIED wegschrijven bij de reception-status
   24-07-2017  A Kluck           01.00.04  Alleen SUPPLIED wegschrijven als de datumtijd ook gevuld is
                                           reception_id uitgebreid met het tijdstip, zodat we de uk-violation omzeilen en
                                           eenzelfde bericht meerdere malen kunnen inlezen
   14-08-2017  X. Pikaar         01.00.05  b2b:send_time via sup_date_actions.convert_any_date2timestamp_utc vertalen naar
                                           een timestamp zodat we (bijna) ieder datumformaat kunnen verwerken.
   18-08-2017  A Kluck           01.00.06  Toegevoegd set_bvalidity
   05-10-2017  X. Pikaar         01.00.07  Fractionele secondes meenemen in reception_id om UK-fouten te voorkomen bij het
                                           te snel verwerken van berichten
   13-10-2017  A Kluck           01.00.08  Toegevoegd: get_delivery
   02-11-2017  N Wenting         01.00.09  TRAN-542: reception variable en parameter omzetten naar delivery.
   22-02-2018  X. Pikaar         01.00.10  Spaties in delivery_code vervangen door underscores
   01-05-2018  M. Zuijdendorp    01.00.11  Toegevoegd: initiate_new_pct_reception toegevoegd tbv. process-event van Libra2
   01-05-2018  M. Zuijdendorp    01.00.12  Bugje opgelost in initiate_new_pct_reception met formaat van b2b_send_time
   21-06-2018  Y. Krop           01.00.13  TRAN-1900 EQUALITY.PROCESS_EVENT#NTC gewijzigd naar EQUALITY.PROCESS-EVENT#NTC
   13-08-2018  M. Zuijdendorp    01.00.14  EQUALITY.PROCESS-EVENT#BEC toegevoegd voor verwerking van de binnenkomende
                                           process-event-berichten van de BEC
   15-08-2018 X. Pikaar          01.00.15  initiate_new_pct_reception algemener gemaakt, zodat we alle process_event-berichten
                                           aankunnen
   14-12-2018  X. Pikaar         01.01.00  initiate_new_reception heeft nu optionele parameters p_delivery. Als de delivery niet
                                           uit message_type/subtype te halen is kunnen we dit uit p_delivery halen. Dit is nodig
                                           voor de GL_MarketDocument-berichten die Delphi na vertaling van de MeasurementSnapshots
                                           aan de XML_handler aanbiedt
   17-12-2018  Y. Krop           01.01.01  Bepalen v_message_metadata.subtype aangepast.
   19-12-2018  Y. Krop           01.01.02  Bepalen reception_id in create_new_rcn_row aangepast.
   04-01-2019  Y. Krop           01.01.03  TRAN-2517 Bepalen message_metadata aangepast op event i.p.v. process_event.
   01-11-2019  M. Zuijdendorp    01.01.04  Global variable RECEPTION_ID (pcs_rcn_receptions.id) toegevoegd in create_new_rcn_row
   05-11-2019  X. Pikaar         01.01.05  dbms_outputs verwijderd
   08-11-2019  X. Pikaar         01.02.00  Vullen metadata geschikt gemakt voor alle EVENT-berichten en de inhoudelijke berichten
                                           van IRIS, EQUALITY en APFAS
   14-11-2019  M. Slobbe         01.02.01  TRAN-3481 Ook APFAS op de IRIS-manier verwerken, met payload dus
   18-11-2019  M. Slobbe         01.02.02  TRAN-3481 Idem met kleine aanpassing analoog aan afvraging 'EVENT.%'
   09-12-2019  R. Standhaft      01.02.03  TRAN-3564 registreer de status SUPPLIED voor IRIS.RESERVES-berichten met dezelfde timestamp
                                           als de timestamp van het bijbehorend IRIS.EVENT-bericht
   10-12-2019  X. Pikaar         01.02.04  TRAN-3564: Status SUPPLIED bij alle payload berichten, niet alleen voor IRIS-EVENT-berichten
                                           Sowieso mag het berichttype niet hardcoded staan
   11-12-2019  R. Standhaft      01.02.05  TRAN-3564: initiate_new_pct_reception gewijzigd (schrijft de SUPPLIED-time)
   29-06-2020  X. Pikaar         01.02.06  TRAN-4106: Bij APFEAS-berichten de supplied-tijd gelijk aan de created-date-time
                                           van het event-bericht gemaakt
   28-08-2020  X. Pikaar         01.03.00  b2b/filename opslaan in global FILENAME
   03-09-2020  X. Pikaar         01.04.00  sender_mrid werd niet opgeslagen bij de event-berichten
   10-09-2020  X. Pikaar         01.04.01  Bij verwerken van het APFAS-payload bericht kan de b2b-sender niet meer uit het
                                           event-bericht gehaald worden, maar moet deze hardcoded gevuld worden
   11-09-2020  X. Pikaar         01.04.02  IRIS.EVENT: ophalen creator en created_date_time via extractvalue omdat de andere
                                           extract op ene of andere manier niet werkt
   24-12-2020  T. Bakker         01.04.03  Aanpassing voor TRAN-4404: opslaan afrr-final
   31-08-2021  X. Pikaar         01.05.00  simulate_rcn_doc_version toegevoegd om een versie te simuleren bij b.v. fpm-bestanden
                                           die geen document-versie hebben
   06-12-2021  X. Pikaar         01.05.01  add_info_to_reception sloeg hash_value niet op
   20-05-2022  X. Pikaar         01.06.00  Equality-events waren beperkt tot namespace prefix ns3, nu worden alle prefixen
                                           geaccepteerd
   20-07-2022  X. Pikaar         01.06.01  Dummy-Wijziging van 01.06.00, om een of andere reden was deze niet in de release gekomen
   05-08-2022  Nico Klaver       01.07.00  TRAN-5627: v_message_metadata.b2b_send_time niet zetten voor inhoudelijke EQUALITY berichten
                                           deze datum staat al in de global SUPPLIED_TIME.
   28-09-2022  X. Pikaar         01.08.00  TRAN-5764: initiate_new_reception en create_new_rcn_row voor JSON toegevoegd
   30-09-2022  X. Pikaar         01.09.00  TRAN-5761: identificerende gegevens (mrid, version en bvalidity) van de payload bij de reception
                                           opslaan voordat deze daadwerkelijk verwerkt gaat worden, zodat deze gegevens ook beschikbaar zijn
                                           als het bericht niet te verwerken is.
   05-10-2022 X. Pikaar          01.09.01  v_message_payload_info.bvaldity_utc_from en v_message_payload_info.bvaldity_utc_to kunnen leeg zijn,
                                           sup_date_actions.convert_any_date2timestamp_utc alleen aanroepen als ze gevuld zijn
   18-10-2022 X. Pikaar          01.09.02  Status SUPPLIED werd wel bepaald maar niet weggeschreven bij de receptionstatussen van het
                                           JSON payload bericht
   05-12-2022 X. Pikaar          01.10.00  TRAN-5562: bij meerdere URL's in een event 'multiple files' in pcs_rcn_receptions.filename zetten,
                                           omdat de filename (pcs_rcn_receptions.filenam) anders te lang kan worden.
   04-01-2023 X. Pikaar          01.10.01  Bij downloadlinks: Ophalen metadata van event moet o.b.v. reception_id van dat event. Deze wordt gezet in
                                           rcn_event.process_downloaded_messages
   15-08-2023 J. Pasterkamp      01.11.00  Ophalen legal_owner in create_new_rcn_row (JSON) (anders krijg je continu "Error unknown delivery_code"
   23-08-2023 Nico Klaver        01.11.01  Bij Payload in het eventbericht de filenaam op null zetten
   28-08-2023 X. Pikaar          01.11.02  intiate_new_reception(XML): document_type vullen vanuti metadata
   18-09-2023 J. Pasterkamp      01.12.00  TRAN-6356 pcs_rcn_actions.initiate_new_pct_reception generieker maken
   20-09-2023 Nico KLaver        01.12.01  Nog wat extra trace info
   14-03-2024 X. Pikaar          01.13.00  Creator toegvoegd aan add_info_to_reception
   02-05-2024 Y. Krop            01.14.00  TRAN-6666 Vulling process_type aan add_info_to_reception toegevoegd
   23-10-2025  Mirjam Buuts      01.15.00  TRAN-7766: in procedure initiate_new_reception(xml) voor EQUALITY.RESERVES#ENERGY_BID_AFRR
                                           , EQUALITY.RESERVES#ENERGY_BID_IR en EQUALITY.RESERVES#ENERGY_BID_MARI mrid anders samengesteld 
                                           In procedure add_info_to_reception parameter p_rcn_row van in naar in out gezet.                             

  *****************************************************************************************************************************************/
  cn_package                  constant varchar2(100) := 'pcs_rcn_actions';
  cn_versionnumber            constant varchar2(100) := '01.15.00';
  cn_process_id               constant varchar2(25)  := 'PROCESS_ID';
  cn_reception_id             constant  varchar2(20) := 'RECEPTION_ID';


  function get_versionnumber
  return varchar2
  is
    /**********************************************************************************************************************
     Purpose    : return package version
    **********************************************************************************************************************/
  begin
    return cn_versionnumber;
  end get_versionnumber;

  function create_new_rcn_row(p_message_metadata in pcs_xml_actions.rt_message_metadata)
     return pcs_rcn_receptions.id%type
  is
    /*********************************************************************************************************************
     Purpose    : Insert new row in pcs_rcn_receptions tabel na een binnengekomen XML bericht
    **********************************************************************************************************************/
    cn_module               constant varchar2(100) := cn_package || '.create_new_rcn_row (XML)';
    --
    cn_process_id           constant varchar2(25)  := 'PROCESS_ID';
    --
    r_rcn                   pcs_rcn_receptions%rowtype;
    v_dly_row               sup_deliveries%rowtype;
    v_delivery              varchar2(32767);
    --
    e_unknown_delivery_code exception;
    --
    pragma autonomous_transaction;
  begin
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start'
                              ||chr(10)||' id  : '          || p_message_metadata.id
                              ||chr(10)||' message_type  : '|| p_message_metadata.message_type
                              ||chr(10)||' subtype  : '     || p_message_metadata.subtype
                              ||chr(10)||' filename  : '    || p_message_metadata.b2b_filename
                             );
    --
    -- Ophalen delivery_id
    v_delivery := replace(upper(p_message_metadata.message_type) || '#' || upper(p_message_metadata.subtype),' ','_');

    v_dly_row.delivery_code := v_delivery;
    v_dly_row.legal_owner   :=  sup_ojtppy_actions.get_domain_value(p_ojt_code => v_delivery
                                                                   ,p_ppy_code => sup_constants.cn_opy_legal_owner);

    sup_dly_dml.get_row_bk(p_sup_dly_row => v_dly_row);
    if v_dly_row.id is null
    then
      raise e_unknown_delivery_code;
    end if;

    r_rcn.dly_id       := v_dly_row.id;
    r_rcn.pcs_id       := sup_globals.get_global_number(p_name => cn_process_id);

    if v_delivery != nvl(p_message_metadata.id
                        ,v_delivery)
    then
      r_rcn.reception_id := v_delivery||'#'||p_message_metadata.id||'#'||to_char(systimestamp at time zone 'UTC','yyyymmddhh24missxff');

    else
      r_rcn.reception_id := v_delivery||'#'||to_char(systimestamp at time zone 'UTC','yyyymmddhh24missxff');

    end if;

    r_rcn.filename               := p_message_metadata.b2b_filename ;
    r_rcn.document_sender_mrid   := p_message_metadata.b2b_sender;

    pcs_rcn_dml.ins_row(p_pcs_rcn_row => r_rcn);
    --
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End'
                            || chr(10) ||'reception_id: ' || r_rcn.id
                             );

    -- LET OP!!! De commit moet nadat we de log-trace hebben gedaan omdat de trace-log in de GTT schrijft. Als we na de commit
    -- iets in de gtt gaan schrijven, krijgen we een ORA-06519: active autonomous transaction detected and rolled back
    commit;

    sup_globals.set_global(p_name  => 'RECEPTION_ID'
                          ,p_value => r_rcn.id);
    return r_rcn.id;

  exception
    when e_unknown_delivery_code then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Unknown delivery code ' || v_dly_row.delivery_code );
      raise;
   when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;
  end create_new_rcn_row;

  function create_new_rcn_row(p_message_metadata in pcs_json_actions.rt_message_metadata)
     return pcs_rcn_receptions.id%type
  is
    /*********************************************************************************************************************
     Purpose    : Insert new row in pcs_rcn_receptions tabel na een binnengekomen JSON bericht. Dit bericht moet metadata bevatten
    **********************************************************************************************************************/
    cn_module               constant varchar2(100) := cn_package || '.create_new_rcn_row (JSON)';
    --
    cn_process_id           constant varchar2(25)  := 'PROCESS_ID';
    --
    r_rcn                   pcs_rcn_receptions%rowtype;
    v_dly_row               sup_deliveries%rowtype;
    v_delivery              varchar2(32767);
    --
    e_unknown_delivery_code exception;
    --
    pragma autonomous_transaction;
  begin
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start'
                              ||chr(10)||' mrid             : ' || p_message_metadata.mrid
                              ||chr(10)||' version          : ' || p_message_metadata.version
                              ||chr(10)||' message_type     : ' || p_message_metadata.message_type
                              ||chr(10)||' message_subtype  : ' || p_message_metadata.message_subtype
                             );
    --
    -- Ophalen delivery_id
    v_delivery              := replace(upper(p_message_metadata.message_type) || '#' || upper(p_message_metadata.message_subtype),' ','_');

    v_dly_row.delivery_code := v_delivery;
    v_dly_row.legal_owner   :=  sup_ojtppy_actions.get_domain_value(p_ojt_code => v_delivery
                                                                   ,p_ppy_code => sup_constants.cn_opy_legal_owner);

    sup_dly_dml.get_row_bk(p_sup_dly_row => v_dly_row);
    if v_dly_row.id is null
    then
      raise e_unknown_delivery_code;
    end if;

    r_rcn.dly_id               := v_dly_row.id;
    r_rcn.pcs_id               := sup_globals.get_global_number(p_name => cn_process_id);

    r_rcn.reception_id         := v_delivery||'#'||to_char(systimestamp at time zone 'UTC','yyyymmddhh24missxff');
    r_rcn.document_mrid        := p_message_metadata.mrid;
    r_rcn.document_version     := p_message_metadata.version;
    r_rcn.document_type        := p_message_metadata.message_type;
    r_rcn.document_sender_mrid := p_message_metadata.message_sender;
    r_rcn.receiver             := p_message_metadata.message_receiver;

    pcs_rcn_dml.ins_row(p_pcs_rcn_row => r_rcn);
    --
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End'
                            || chr(10) ||'reception_id: ' || r_rcn.id
                             );

    -- LET OP!!! De commit moet nadat we de log-trace hebben gedaan omdat de trace-log in de logging schrijft. Als we na de commit
    -- iets in de logging gaan schrijven, krijgen we een ORA-06519: active autonomous transaction detected and rolled back
    commit;

    sup_globals.set_global(p_name => 'RECEPTION_ID', p_value => r_rcn.id);
    return r_rcn.id;

  exception
    when e_unknown_delivery_code then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Unknown delivery code ' || v_dly_row.delivery_code );
      raise;
   when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;
  end create_new_rcn_row;

  function create_new_rcn_row(p_rcn_row   in pcs_rcn_receptions%rowtype
                             ,p_delivery  in varchar2)
     return pcs_rcn_receptions.id%type
  is
    /*********************************************************************************************************************
     Purpose    : Insert new row in pcs_rcn_receptions tabel, waarbij een deel van de info overgenomen wordt uit het event-bericht
                  Dit is vooral voor de payload JSON berichten zonder metadata
    **********************************************************************************************************************/
    cn_module               constant varchar2(100) := cn_package || '.create_new_rcn_row (payload from event)';

    r_rcn                   pcs_rcn_receptions%rowtype;
    v_dly_row               sup_deliveries%rowtype;

    e_unknown_delivery_code exception;

    pragma autonomous_transaction;
  begin
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start'
                              ||chr(10)||' document_mrid    : ' || p_rcn_row.document_mrid
                              ||chr(10)||' document_version : ' || p_rcn_row.document_version);

    -- Ophalen delivery_id
    v_dly_row.delivery_code := p_delivery;
    v_dly_row.legal_owner   := sup_ojtppy_actions.get_domain_value(p_ojt_code => p_delivery
                                                                  ,p_ppy_code => sup_constants.cn_opy_legal_owner);

    sup_dly_dml.get_row_bk(p_sup_dly_row => v_dly_row);
    if v_dly_row.id is null
    then
      raise e_unknown_delivery_code;
    end if;

    -- Let op: de rest van de velden nemen we over uit de reception van het event bericht
    r_rcn.dly_id               := v_dly_row.id;
    r_rcn.pcs_id               := sup_globals.get_global_number(p_name => cn_process_id);
    r_rcn.reception_id         := p_delivery||'#'||to_char(systimestamp at time zone 'UTC','yyyymmddhh24missxff');

    pcs_rcn_dml.ins_row(p_pcs_rcn_row => r_rcn);

    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End'
                            || chr(10) ||'reception_id: ' || r_rcn.id
                             );

    -- LET OP!!! De commit moet nadat we de log-trace hebben gedaan omdat de trace-log in de GTT schrijft. Als we na de commit
    -- iets in de gtt gaan schrijven, krijgen we een ORA-06519: active autonomous transaction detected and rolled back
    commit;

    sup_globals.set_global(p_name => 'RECEPTION_ID', p_value => r_rcn.id);
    return r_rcn.id;

  exception
    when e_unknown_delivery_code then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Unknown delivery code ' || v_dly_row.delivery_code );
      raise;
   when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;
  end create_new_rcn_row;


  function initiate_new_reception (p_xml          in xmltype
                                  ,p_delivery     in varchar2
                                  ,p_enqueue_time in timestamp
                                  ,p_start_time   in timestamp
                                  ,p_message_supplied_utc  in timestamp default null
                                  )
     return pcs_rcn_receptions.id%type
  is
    /*********************************************************************************************************************
     Purpose    : Initieer een nieuwe reception van een XML bericht
    **********************************************************************************************************************/
      cn_module              constant varchar2(100) := cn_package || '.intiate_new_reception (XML)';
      cn_dly_energy_bid_afrr constant varchar2(100) := 'EQUALITY.RESERVES#ENERGY_BID_AFRR';
      cn_dly_energy_bid_ir   constant varchar2(100) := 'EQUALITY.RESERVES#ENERGY_BID_IR';
      cn_dly_energy_bid_mari constant varchar2(100) := 'EQUALITY.RESERVES#ENERGY_BID_MARI';

      v_message_metadata                      pcs_xml_actions.rt_message_metadata;
      v_message_payload_info                  pcs_xml_actions.rt_message_payload_info;
      v_rcn_id                                pcs_rcn_receptions.id%type;
      v_supplied_date                         timestamp;
      e_no_delivery                           exception;

      r_rcn                                   pcs_rcn_receptions%rowtype;

  begin
    pcs_log_actions.log_trace(p_module                 => cn_module
                             ,p_text                   => 'Start'
                                                       || 'p_delivery: ' || p_delivery);

    -- Metadata uit het bericht halen
    pcs_xml_actions.get_message_metadata(p_xml              => p_xml
                                        ,p_message_metadata => v_message_metadata);
    if v_message_metadata.message_type is null then
      if p_delivery is null then
         raise e_no_delivery;
       else
         v_message_metadata.message_type   := substr(p_delivery, 1, instr(p_delivery, '#') - 1);
         v_message_metadata.subtype        := substr(p_delivery, instr(p_delivery, '#') + 1, length(p_delivery) - instr(p_delivery, '#'));
       end if;
    end if;

    -- Registeren van reception, mogelijk zijn niet alle kolommen beschikbaar
    v_rcn_id                               := create_new_rcn_row (p_message_metadata => v_message_metadata);

    pcs_xml_actions.get_message_payload_info(p_xml                  => p_xml
                                            ,p_message_payload_info => v_message_payload_info);

    r_rcn.id                               := v_rcn_id;
	
    if p_delivery in (cn_dly_energy_bid_afrr, cn_dly_energy_bid_ir, cn_dly_energy_bid_mari)
       or v_message_metadata.message_type||'#'||v_message_metadata.subtype in (cn_dly_energy_bid_afrr, cn_dly_energy_bid_ir, cn_dly_energy_bid_mari) then 
      r_rcn.document_mrid  := v_message_payload_info.mrid||'_'||v_message_payload_info.sender_marketparticipant_mrid||'_'||to_char(sup_date_actions.convert_any_date2timestamp_utc(p_text_date => v_message_payload_info.bvaldity_utc_from),'yyyymmddhh24mi');
    else
      r_rcn.document_mrid  := v_message_payload_info.mrid;
    end if;
	
    r_rcn.document_version                 := v_message_payload_info.revision_number;
    r_rcn.document_type                    := v_message_payload_info.document_type;
    if v_message_payload_info.bvaldity_utc_from is not null then
       r_rcn.bvalidity_utc_from            := sup_date_actions.convert_any_date2timestamp_utc(p_text_date => v_message_payload_info.bvaldity_utc_from);
    end if;

    if v_message_payload_info.bvaldity_utc_to is not null then
       r_rcn.bvalidity_utc_to              := sup_date_actions.convert_any_date2timestamp_utc(p_text_date => v_message_payload_info.bvaldity_utc_to);
    end if;

    pcs_rcn_actions.add_info_to_reception(p_rcn_row => r_rcn);

    -- Reception is aangemaakt, ga nu de starttijd opslaan bij de reception-status 'STARTED'
    pcs_rse_actions.set_rcn_state(p_rcn_id                => v_rcn_id
                                 ,p_state                 => sup_constants.cn_rcn_state_started
                                 ,p_tvalidity_utc_from    => p_start_time);

    if sup_globals.get_global_timestamp(p_name => 'SUPPLIED_TIME') is not null then
       pcs_rse_actions.set_rcn_state(p_rcn_id             => v_rcn_id
                                    ,p_state              => sup_constants.cn_rcn_state_supplied
                                    ,p_tvalidity_utc_from => p_message_supplied_utc
                                    );
    elsif p_message_supplied_utc is not null then
       -- In dit geval hebben we te maken met een download-bericht (payload) uit een event-bericht. Nu wordt de supplied-tijd van het event-bericht bij de reception van de payload gezet
       sup_globals.set_global(p_name   => 'SUPPLIED_TIME'
                             ,p_value  => p_message_supplied_utc);
       pcs_rse_actions.set_rcn_state(p_rcn_id             => v_rcn_id
                                    ,p_state              => sup_constants.cn_rcn_state_supplied
                                    ,p_tvalidity_utc_from => p_message_supplied_utc
                                    );
    elsif (v_message_metadata.b2b_send_time is not null) then
       -- registreer de status SUPPLIED, met de b2b:send-time van het bericht
       v_supplied_date                      := sup_date_actions.convert_any_date2timestamp_utc(v_message_metadata.b2b_send_time);
       pcs_rse_actions.set_rcn_state(p_rcn_id             => v_rcn_id
                                    ,p_state              => sup_constants.cn_rcn_state_supplied
                                    ,p_tvalidity_utc_from => v_supplied_date
                                    );
       -- Zet de SUPPLIED_TIME in een global. Dit is nodig bij events, dan kunnen we bij de verwerking van de payload deze tijd weer gebruiken vanuit de global
       sup_globals.set_global(p_name                      => 'SUPPLIED_TIME'
                             ,p_value                     => v_supplied_date);
    elsif sup_globals.get_global_timestamp(p_name         =>  'SUPPLIED_TIME') is not null  then
       pcs_rse_actions.set_rcn_state(p_rcn_id             => v_rcn_id
                                    ,p_state              => sup_constants.cn_rcn_state_supplied
                                    ,p_tvalidity_utc_from => sup_globals.get_global_timestamp(p_name =>  'SUPPLIED_TIME')
                                    );
    end if;

    if (v_message_metadata.b2b_filename is not null) then
       sup_globals.set_global(p_name  => 'FILENAME'
                             ,p_value => v_message_metadata.b2b_filename);
    end if;

    -- registreer de status RECEIVED, met de enqueue-time van de message-queue
    pcs_rse_actions.set_rcn_state(p_rcn_id                => v_rcn_id
                                 ,p_state                 => sup_constants.cn_rcn_state_received
                                 ,p_tvalidity_utc_from    => p_enqueue_time);

    pcs_log_actions.log_trace(p_module                    => cn_module
                             ,p_text                      => 'End'
                             );

    return v_rcn_id;
  exception
   when e_no_delivery then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'No message_type/subtype determined and no delivery_code available!');
      raise;
   when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;
  end initiate_new_reception;


  function initiate_new_reception (p_json                   in clob
                                  ,p_delivery               in varchar2
                                  ,p_enqueue_time           in timestamp
                                  ,p_start_time             in timestamp
                                  ,p_message_supplied_utc  in timestamp default null
                                  )
     return pcs_rcn_receptions.id%type
  is
    /*********************************************************************************************************************
     Purpose    : Initieer een nieuwe reception van een JSON bericht
    **********************************************************************************************************************/
      cn_module  constant varchar2(100) := cn_package || '.intiate_new_reception (JSON)';

      v_message_metadata                      pcs_json_actions.rt_message_metadata;
      v_rcn_id                                pcs_rcn_receptions.id%type;
      e_no_delivery                           exception;
      v_msg_creation_time                     timestamp;

      r_rcn                                   pcs_rcn_receptions%rowtype;
      r_rse                                   pcs_rcn_states%rowtype;

  begin
    pcs_log_actions.log_trace(p_module                 => cn_module
                             ,p_text                   => 'Start'
                                                       || 'p_delivery: ' || p_delivery);

    -- Metadata uit het bericht halen, alleen als p_delivery niet al aangeleverd is
    -- (in dat geval komt het uit de XML van het event-bericht en hebben we verder geen metadata)
    if p_delivery is null then
       pcs_json_actions.get_message_metadata(p_json             => p_json
                                            ,p_message_metadata => v_message_metadata);

       pcs_log_actions.log_trace(p_module                 => cn_module
                                ,p_text                   => 'v_message_metadata : ' || v_message_metadata.creation_time);

       if v_message_metadata.message_type is null then
         if p_delivery is null then
            raise e_no_delivery;
         else
            v_message_metadata.message_type   := p_delivery;
         end if;
       end if;

       -- Registeren van reception
       v_rcn_id                               := create_new_rcn_row (p_message_metadata => v_message_metadata);

       pcs_log_actions.log_trace(p_module                 => cn_module
                                ,p_text                   => 'v_message_metadata2 : ' || v_message_metadata.creation_time);

       -- Bewaar de creation-time van het event in een global, daarmee kunnen we de creation_time van de payload zetten.
       -- dat moet hier via een timestamp-variabele, anders komt het in het verkeerde type global
       v_msg_creation_time                    := sup_date_actions.convert_any_date2timestamp_utc(p_text_date => v_message_metadata.creation_time);

--       v_msg_creation_time                    := to_timestamp(v_message_metadata.creation_time, 'dd-mm-yyyy hh24:mi:ss');
       sup_globals.set_global(p_name  => 'SUPPLIED_TIME'
                             ,p_value => v_msg_creation_time);
    else
       -- Er is een delivery aangeleverd, dan zal er (hopelijk) ook een event zijn. Die kunnen we vinden o.b.v. in rcn_event.process_downloaded_messages
       -- gezette reception_id
       -- De gegevens van dat record gebruiken we voor het aanmaken van een nieuwe reception.
        r_rcn.id                              := sup_globals.get_global_number(p_name => cn_reception_id);
        -- Haal het "parent" pcs_rcn_receptions record op. Deze bevat metadata die we anders niet kunnen vullen. Ophalen moet
        -- o.b.v. reception_id
        pcs_rcn_dml.get_row(p_pcs_rcn_row => r_rcn);

        -- Haal het record in pcs_rcn_states op met de status SUPPLIED. De datum daatvan gebruiken we ook voor de JSON-payload
        r_rse                                 := null;
        r_rse.rcn_id                          := r_rcn.id;
        r_rse.state                           := sup_constants.cn_rcn_state_supplied;
        pcs_rse_dml.get_row_bk(p_rse_row => r_rse);
        sup_globals.set_global(p_name    => 'SUPPLIED_TIME'
                              ,p_value   => r_rse.tvalidity_utc_from);

        r_rcn.id                              := null;
        r_rcn.dly_id                          := null; -- wordt straks gezet
        r_rcn.cre_date_loc                    := null;
        r_rcn.cre_date_utc                    := null;
        r_rcn.pcs_id                          := sup_globals.get_global_number(p_name => cn_process_id);
        v_rcn_id                              := create_new_rcn_row (p_rcn_row  => r_rcn
                                                                    ,p_delivery => p_delivery);
    end if;

    -- Let op: in tegenstelling tot de XML-versie gaan we hier (nog) geen payload-info toevoegen aan de reception. Voor het enige JSON-bestand dat we
    -- hebben (GOPACS) kan dat nog niet. In de toekomst eventueel doen.
    -- Hier staat de code hoe hat toe te voegen als we ooit een pcs_json_actions.get_message_payload_info kunnen maken
/*
    pcs_json_actions.get_message_payload_info(p_xml                  => p_xml
                                             ,p_message_payload_info => v_message_payload_info);

    r_rcn.document_mrid                    := v_message_payload_info.mrid;
    r_rcn.document_version                 := v_message_payload_info.revision_number;
    r_rcn.bvalidity_utc_from               := v_message_payload_info.bvaldity_utc_from;
    r_rcn.bvalidity_utc_to                 := v_message_payload_info.bvaldity_utc_to;
    pcs_rcn_actions.add_info_to_reception(p_rcn_row => r_rcn);
*/

    -- Registreer de status SUPPLIED
    if p_message_supplied_utc is not null then
       -- In dit geval hebben we te maken met een download-bericht (payload) uit een event-bericht. Nu wordt de supplied-tijd van het event-bericht bij de reception van de payload gezet
       sup_globals.set_global(p_name   => 'SUPPLIED_TIME'
                             ,p_value  => p_message_supplied_utc);
       pcs_rse_actions.set_rcn_state(p_rcn_id             => v_rcn_id
                                    ,p_state              => sup_constants.cn_rcn_state_supplied
                                    ,p_tvalidity_utc_from => p_message_supplied_utc
                                    );
    else
       pcs_rse_actions.set_rcn_state(p_rcn_id             => v_rcn_id
                                    ,p_state              => sup_constants.cn_rcn_state_supplied
                                    ,p_tvalidity_utc_from => sup_globals.get_global_timestamp(p_name  => 'SUPPLIED_TIME')
                                    );
    end if;

    -- registreer de status RECEIVED, met de enqueue-time van de message-queue van het event-bericht (nauwkeuriger kunnen we niet)
    pcs_rse_actions.set_rcn_state(p_rcn_id             => v_rcn_id
                                 ,p_state              => sup_constants.cn_rcn_state_received
                                 ,p_tvalidity_utc_from => p_enqueue_time);

    -- Reception is aangemaakt, ga nu de starttijd opslaan bij de reception-status 'STARTED'
    pcs_rse_actions.set_rcn_state(p_rcn_id             => v_rcn_id
                                 ,p_state              => sup_constants.cn_rcn_state_started
                                 ,p_tvalidity_utc_from => p_start_time);

    pcs_log_actions.log_trace(p_module                 => cn_module
                             ,p_text                   => 'End'
                             );

    return v_rcn_id;
  exception
   when e_no_delivery then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'No message_type/subtype determined and no delivery_code available!');
      raise;
   when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;
  end initiate_new_reception;

  function initiate_new_pct_reception (p_xml          in xmltype
                                      ,p_delivery     in varchar2
                                      ,p_enqueue_time in timestamp
                                      ,p_start_time   in timestamp)
     return pcs_rcn_receptions.id%type
  is
    /*********************************************************************************************************************
     Purpose    : Initieer een nieuwe reception van Event messages
    **********************************************************************************************************************/
      cn_module  constant varchar2(100) := cn_package || '.initiate_new_pct_reception';

      v_message_metadata                      pcs_xml_actions.rt_message_metadata;
      v_rcn_id                                pcs_rcn_receptions.id%type;
      v_supplied_date                         timestamp;
      v_statement                             varchar2(200);
      v_amount_urls                           number(10);

  begin
    pcs_log_actions.log_trace(p_module                 => cn_module
                             ,p_text                   => 'Start'
                                                       || 'p_delivery: ' || p_delivery);

    --Bepaal of we een inline payload of downloadlinks ontvangen hebben
    v_statement                        := 'select xmlcast(xmlquery(''count(//*:event/*:links/*:link/*:url)'' passing :p_xml returning content) as number) from dual';

    execute immediate v_statement
       into v_amount_urls
      using p_xml;

    if v_amount_urls >= 1 then
      --  ** Downloadlink(s)**

      if v_amount_urls > 1 then
        v_message_metadata.b2b_filename := 'Multiple files';
      else
        v_message_metadata.b2b_filename := p_xml.extract('//*:event/*:links/*:link/*:url/text()'
                                                        ,'xmlns="http://www.tennet.eu/schema/events/1.0"'
                                                         ).getstringval();
      end if;

    else
      --  ** Inline Payload **
      v_message_metadata.b2b_filename := null;

    end if;

    -- Algemene metadata vullen
    begin
      v_message_metadata.id := p_xml.extract('//*:event/*:event-correlation-id/text()',
                                             'xmlns="http://www.tennet.eu/schema/events/1.0"'
                                            ).getstringval();
    exception
      when others then
       v_message_metadata.id := p_delivery;
    end;

    v_message_metadata.message_type    := substr(p_delivery, 1, instr(p_delivery, '#') - 1);
    v_message_metadata.subtype         := substr(p_delivery, instr(p_delivery, '#') + 1, length(p_delivery));

    select extractvalue(p_xml,'//*:event/*:created-date-time') into v_message_metadata.b2b_send_time from dual;
    select nvl(extractvalue(p_xml,'//*:event/*:creator'), substr(p_delivery, 0, instr(p_delivery, '.')-1)) into v_message_metadata.b2b_sender from dual;


    if v_message_metadata.id is null
      and v_message_metadata.message_type is null
      and v_message_metadata.subtype is null
      then
        pcs_log_actions.log_trace(p_module                 => cn_module
                                 ,p_text                   => 'No metadata found for delivery code '||p_delivery);
    end if;


    -- Registeren van reception
    v_rcn_id                             := create_new_rcn_row (p_message_metadata => v_message_metadata);

    -- Reception is aangemaakt, ga nu de starttijd opslaan bij de reception-status 'STARTED'
    pcs_rse_actions.set_rcn_state(p_rcn_id             => v_rcn_id
                                 ,p_state              => sup_constants.cn_rcn_state_started
                                 ,p_tvalidity_utc_from => p_start_time);


    if (v_message_metadata.b2b_send_time is not null)
    then
      -- registreer de status SUPPLIED, met de b2b:send-time van het bericht
      v_supplied_date                      := sup_date_actions.convert_any_date2timestamp_utc(v_message_metadata.b2b_send_time);
      pcs_rse_actions.set_rcn_state(p_rcn_id             => v_rcn_id
                                   ,p_state              => sup_constants.cn_rcn_state_supplied
                                   ,p_tvalidity_utc_from => v_supplied_date
                                   );
      -- Zet de SUPPLIED_TIME in een global. Dit is nodig bij events, dan kunnen we bij de verwerking van de payload deze tijd weer gebruiken vanuit de global
      sup_globals.set_global(p_name  => 'SUPPLIED_TIME'
                            ,p_value => v_supplied_date);
    else
      if sup_globals.get_global_timestamp(p_name =>  'SUPPLIED_TIME') is not null then
        pcs_rse_actions.set_rcn_state(p_rcn_id             => v_rcn_id
                                     ,p_state              => sup_constants.cn_rcn_state_supplied
                                     ,p_tvalidity_utc_from => sup_globals.get_global_timestamp(p_name =>  'SUPPLIED_TIME')
                                     );
      end if;
    end if;

    -- registreer de status RECEIVED, met de enqueue-time van de message-queue
    pcs_rse_actions.set_rcn_state(p_rcn_id             => v_rcn_id
                                 ,p_state              => sup_constants.cn_rcn_state_received
                                 ,p_tvalidity_utc_from => p_enqueue_time);

    pcs_log_actions.log_trace(p_module                 => cn_module
                             ,p_text                   => 'End'
                             );

    return v_rcn_id;
  exception
   when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;
  end initiate_new_pct_reception;

  procedure set_bvalidity (p_rcn_id             in pcs_rcn_receptions.id%type
                          ,p_bvalidity_utc_from in pcs_rcn_receptions.bvalidity_utc_from%type default null
                          ,p_bvalidity_utc_to   in pcs_rcn_receptions.bvalidity_utc_to%type   default null
                          )
  is
    /*********************************************************************************************************************
     Purpose    : (re)Set the business validity of a specific row
    **********************************************************************************************************************/
    cn_module  constant varchar2(100) := cn_package || '.set_bvalidity';
    r_rcn pcs_rcn_receptions%rowtype;
  begin
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start'
                              ||chr(10)||' p_rcn_id             : '||p_rcn_id
                              ||chr(10)||' p_bvalidity_utc_from : '||to_char(p_bvalidity_utc_from,sup_constants.cn_utc_date_format)
                              ||chr(10)||' p_bvalidity_utc_to   : '||to_char(p_bvalidity_utc_to  ,sup_constants.cn_utc_date_format)
                             );

    r_rcn.id := p_rcn_id;
    -- check of de row bestaat (no_data_found) en haal in volledigheid op
    pcs_rcn_dml.get_row(p_pcs_rcn_row => r_rcn);

    -- wijzig wat je wilt wijzigen
    r_rcn.bvalidity_utc_from := p_bvalidity_utc_from;
    r_rcn.bvalidity_utc_to   := p_bvalidity_utc_to  ;
    pcs_rcn_dml.upd_row(p_pcs_rcn_row => r_rcn);

    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End'
                              ||chr(10)||' p_rcn_id             : '||p_rcn_id
                              ||chr(10)||' p_bvalidity_utc_from : '||to_char(p_bvalidity_utc_from,sup_constants.cn_utc_date_format)
                              ||chr(10)||' p_bvalidity_utc_to   : '||to_char(p_bvalidity_utc_to  ,sup_constants.cn_utc_date_format)
                             );
  exception
   when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;
  end set_bvalidity;


  --
  procedure add_info_to_reception (p_rcn_row        in out pcs_rcn_receptions%rowtype)
  is
    /*********************************************************************************************************************
     Purpose    : (re)Set the business validity of a specific row
    **********************************************************************************************************************/
    cn_module  constant varchar2(100) := cn_package || '.add_info_to_reception';
    r_rcn               pcs_rcn_receptions%rowtype;

    pragma autonomous_transaction;
  begin
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start'
                              ||chr(10)||' p_rcn_row.id          : '||p_rcn_row.id
                             );

    r_rcn.id                 := p_rcn_row.id;
    -- check of de row bestaat (no_data_found) en haal in volledigheid op
    pcs_rcn_dml.get_row(p_pcs_rcn_row => r_rcn);

    -- wijzig wat je wilt wijzigen
    r_rcn.reception_id         := nvl(p_rcn_row.reception_id        , r_rcn.reception_id);
    r_rcn.filename             := nvl(p_rcn_row.filename            , r_rcn.filename);
    r_rcn.document_mrid        := nvl(p_rcn_row.document_mrid       , r_rcn.document_mrid);
    r_rcn.document_version     := nvl(p_rcn_row.document_version    , r_rcn.document_version);
    r_rcn.document_sender_mrid := nvl(p_rcn_row.document_sender_mrid, r_rcn.document_sender_mrid);
    r_rcn.correlation_id       := nvl(p_rcn_row.correlation_id      , r_rcn.correlation_id);
    r_rcn.document_type        := nvl(p_rcn_row.document_type       , r_rcn.document_type);
    r_rcn.bvalidity_utc_from   := nvl(p_rcn_row.bvalidity_utc_from  , r_rcn.bvalidity_utc_from);
    r_rcn.bvalidity_utc_to     := nvl(p_rcn_row.bvalidity_utc_to    , r_rcn.bvalidity_utc_to);
    r_rcn.delivery_day         := nvl(p_rcn_row.delivery_day        , r_rcn.delivery_day);
    r_rcn.hash_value           := nvl(p_rcn_row.hash_value          , r_rcn.hash_value);
    r_rcn.hash_time_taken_ms   := nvl(p_rcn_row.hash_time_taken_ms  , r_rcn.hash_time_taken_ms);
    r_rcn.process_type         := nvl(p_rcn_row.process_type        , r_rcn.process_type);
    r_rcn.creator              := nvl(p_rcn_row.creator             , r_rcn.creator);
    pcs_rcn_dml.upd_row(p_pcs_rcn_row => r_rcn);

    commit;

    p_rcn_row := r_rcn;
	
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End'
                              ||chr(10)||' p_rcn_row.id             : '||p_rcn_row.id
                             );
  exception
   when others then
      pcs_log_actions.log_error(p_module => cn_module);

      rollback;
      raise;
  end add_info_to_reception;


  --
  procedure get_delivery(p_rcn_id   in pcs_rcn_receptions.id%type
                        ,p_dly_row out sup_deliveries%rowtype
                        )
  is
    /*********************************************************************************************************************
     Purpose    : Get all column values from the delivery parent, using the pcs_rcn_receptions.id
    **********************************************************************************************************************/
    cn_module  constant varchar2(100) := cn_package || '.get_delivery_columns';
    r_rcn pcs_rcn_receptions%rowtype;
    r_dly sup_deliveries%rowtype;
  begin
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start'
                              ||chr(10)||' p_rcn_id     : '||p_rcn_id
                              ||chr(10)||' p_dly_row.id : '||p_dly_row.id
                             );

    -- haal child op
    r_rcn.id := p_rcn_id;
    pcs_rcn_dml.get_row(p_pcs_rcn_row => r_rcn);

    -- haal parent op
    r_dly.id := r_rcn.dly_id;
    sup_dly_dml.get_row(p_sup_dly_row => r_dly);
    p_dly_row := r_dly;

    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End'
                              ||chr(10)||' p_rcn_id     : '||p_rcn_id
                              ||chr(10)||' p_dly_row.id : '||p_dly_row.id
                             );
  exception
   when others then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Parameters'
                                ||chr(10)||' p_rcn_id     : '||p_rcn_id
                                ||chr(10)||' p_dly_row.id : '||p_dly_row.id
                               );
      raise;
  end get_delivery;

  function simulate_rcn_doc_version (p_document_mrid   in varchar2)
    return number
  is
    /*********************************************************************************************************************
     Purpose    : Voor receptions die geen document-versie hebben maken we er zelf een om ze uit elkaar te kunnen houden
    **********************************************************************************************************************/
    cn_module  constant varchar2(100) := cn_package || '.simulate_rcn_doc_version';

    v_version           number(3);

    cursor c_rcn (b_document_mrid    in varchar2)
        is select nvl(max(document_version), 0)  + 1 as doc_version
             from pcs_rcn_receptions
            where document_mrid  = b_document_mrid;
  begin
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start'
                              ||chr(10)||' p_document_mrid: '||p_document_mrid
                             );

    open c_rcn(b_document_mrid => p_document_mrid);

    fetch c_rcn
     into v_version;

    close c_rcn;

    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End'
                              ||chr(10)||' Version: ' || v_version
                             );

    return v_version;
  exception
   when others then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Parameters'
                                ||chr(10)||' p_document_mrid     : '||p_document_mrid
                               );
      raise;
  end simulate_rcn_doc_version;
  --
end pcs_rcn_actions;
/
