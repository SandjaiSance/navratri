create or replace package body tmn_utilities
is
  /***********************************************************************************************************************************
   Purpose    : Algemene procedures voor het draaien van transmissies

   Change History
   Date        Author            Version   Description
   ----------  ----------------  -------   -------------------------------------------------------------------------------------------
   07-04-2017  A. el Azzouzi     01.00.00  creatie
   21-07-2017  A. el Azzouzi     01.00.01  Bepaling MRID aangepast in procedure get_mrid
   24-07-2017  A Kluck           01.00.02  Toegevoegd get_period_to_publish
                                           Aangepast p_pbn_date -> p_pbn_date_utc
                                                     p_tmn_mrd_id -> p_tmn_mrid
                                                     tracing aangevuld met parameter-waarden
   24-08-2017  X. Pikaar         01.00.03  Gebruik lokale variabelen i.p.v. parameters in get_period_to_publish
   22-09-2017  X. Pikaar         01.00.04  xml-loggen in exception-handler van get_xml
   29-09-2017  A Kluck           01.00.05  procedure get_mrid overloaded tbv EDP_43
   13-10-2017  A Kluck           01.00.06  Gewijzigd mrid voor EDP_43, samenstellen zonder sender
   01-11-2018  X. Pikaar         01.01.00  Error loggen i.p.v. trace als er geen XML-view of data aanwezig is.
   28-01-2019  M. Zuijdendorp    01.01.01  In aanroep van sup_date_actions.convertlocal2utc de naam van de parameter aangepast
   31-01-2019  X. Pikaar         01.01.02  p_publication loggen in get_xml
   25-10-2019  M. Zuijdendorp    01.01.03  Function get_xml toegevoegd
   26-03-2020  X. Pikaar         01.01.04  get_hash, van xml naar clob direct met .getclobval i.p.v. extract ertussen omdat
                                           de extract blijkbaar niet goed overweg kan met lege nodes met alleen attributen
   20-03-2020  M.Walraven        01.01.05  get_mrid procedures aangepast met nieuwe out parameter p_tmn_next_version
   21-04-2020  X. Pikaar         01.01.06  TRAN-4037: tot-publicatie datum corrigeren als deze gelijk aan of voor de
                                           vanaf-datum valt op de Z/W of W/Z overgang. Dit kan ontstaan door de local2utc
                                           conversies zonder een timezone.
   06-07-2020  X. Pikaar         01.02.00  get_mrid met auction_id toegevoegd
   31-08-2020  X. Pikaar         01.02.01  Bij het bepalen van de period_to_publish kon het gebeuren dat de from-date in
                                           de zomertijd zit en de to_date in de wintertijd. Daardoor komt de to-date een uur te laat uit
   02-09-2020  X. Pikaar         01.02.02  Period to publish deed het niet bij een interval groter dan 1 jaar omdat het verschil in een
                                           interval day to second gezet werd. Dat geeft een "ORA-01873: the leading precision of the interval is too small"
                                           Bij publicaties die over meer dan 1 dag gaan mogen we geen correctie op de wintertijd doen
   30-10-2020  M. Walraven       01.03.00  TRAN-4368: Winter-/Zomertijdprobleem oplossen in sup_date_actions.convertlocal2utc_ts
   13-11-2020  X. Pikaar         01.04.00  i.v.m. TRAN-2258: controle ingebouw of herpublicatie wel toegestaan is.
   19-11-2020  X. Pikaar         01.04.01  Wijziging TRAN-4368 hier terugedraaid, wordt in sup_date_actions opgelost
   11-12-2020  X. Pikaar         01.04.02  Case in is_republication_allowed verbeterd n.a.v. Sonar
   04-02-2021  X. Pikaar         01.05.00  TRAN-4461 Zomer-/wintertijd probleem in period_to_publish: als we in de wintertijd zitten
                                           en een datum in de zomertijd berekenen kwam de datum een uur te laat uit.
   02-03-2021  T. Bakker         01.05.01  Bug TRAN-4754: TDW_07 republication not allowed.
   30-08-2021  X. Pikaar         01.06.00  TRAN-3264: get_mrid o.b.v. transaction_id (voor ADP_06-publicaties) toegevoegd
   07-09-2021  X. Pikaar         01.06.01  underscore toegevoegd tussen publicatienaam en transaction_id (voor de ADP_06)
   23-09-2021  Y. Krop           01.07.00  TRAN-4742 get_mrid o.b.v. ara_code en pbn_date_loc toegevoegd t.b.v. ADP_09_TTG.
   02-11-2021  X. Pikaar         01.08.00  Bug in bepalen period to publish in zomer/winterrovergang door verkeerde sessiontimezone
   10-01-2022  X. Pikaar         01.09.00  TRAN-5189: functie get_hash verplaatst naar pcs_xml_actions omdat die voor zowel inkomende als
                                           uitgaande berichten gebruikt wordt
   15-02-2022  Nico Klaver       01.10.00  TRAN-5285 get_json toegevoegd
   08-03-2022  Nico Klaver       01.11.00  TRAN-5378 parameter p_get_version toegevoegd aan get_mrid
   02-05-2022  Nico Klaver       01.12.00  TRAN-5482 DQF versie get_mrid toegevoegd
   23-05-2022  Nico Klaver       01.13.00  TRAN-5137 DQF versie get_mrid aangepast p_mrid_suffix toegevoegd
   25-05-2022  X. Pikaar         01.13.01  Underscores verwijderd bij concatenation van de mrid, sommige mrid's hebben namelijk niet die
                                           underscore omdat de mrid dan te lang wordt
   20-07-2022  X. Pikaar         01.14.00  TRAN-5675, berekening period to publish ging niet goed bij berekening van een minuutwaarde in de
                                           wintertijd, terwijl het nog zomertijd is. Probleem was dat we onderweg de timezone kwijt raken
                                           waardoor conversies niet meer weten of het zomer of wintertijd is.
   16-09-2022  X. Pikaar         01.15.00  Log statement bij een fout in get_xml/get_json
   01-11-2022  Y. Krop           01.15.01  Hotfix op get_period_to_publish n.a.v. zomer-/wintertijdovergang 2022
   09-11-2022  X. Pikaar         01.16.00  TRAN-5882: mrid-bepaling met mrid_suffix flexibel gemaakt qua plaatsing suffix
   29-03-2023  Nico Klaver       01.17.00  W/Z overgang execute_expression toegevoegd
   05-04-2023  Nico Klaver       01.18.00  round_ts meegenomen in create statement. Zorgen dat altijd EUROPE/AMSTERDAM wordt
                                           teruggegeven bij execute_expression
   17-04-2023  X. Pikaar         01.18.01  In get_period_to_publish werd execute_expression aangeroepen met utc-data, terwijl dat lokaal
                                           moet zijn
                                           Ophalen PERIOD_TO_PUBLISH_START en PERIOD_TO_PUBLISH_END via sup_ojtppy_actions i.p.v. een
                                           directe select into, omdat die bij een onduidelijke "ORA-06533: Subscript beyond count" gaf
                                           als er geen records gevonden werden
   30-08-2023  X. Pikaar         01.19.00  TRAN-6358: get_mrid o.b.v. document_id toegevoegd
   22-02-2024  R. Brinker        01.20.00  TRAN-6648 - ORA-01857: not a valid time zone in tmn_utilities.get_period_to_publish
   02-04-2024  R. Brinker        01.21.00  TRAN-6219 - ATR_01 Winter naar Zomertijd maakt verkeerde jobnaam aan
   08-07-2024  R. Brinker        01.22.00  TRAN-6866 - EDP_50aFRR: bepaling mRID toegevoegd
   15-07-2024  R. Brinker        01.23.00  TRAN-6874 - EDP_50FCR: bepaling mRID toegevoegd
   06-08-2025  X. Pikaar         01.24.00  TRAN-6871 - bepaling mIRD EDP_50mFRRda toegeveoegd
   15-08-2024  X. Pikaar         01.25.00  TRAN-6959: bepaling mRID met silent_log_mode om enorme bak logging te voorkomen.
   10-09-2024  Nico Klaver       01.26.00  TRAN-6953: mrid bepaling (auction_id) vereenvoudigd alleen voor de EDP_5xFCR publicaties
   19-09-2024  Y. Krop           01.27.00  TRAN-6861 Bepaling mRID EDP_75FCR toegevoegd
   10-02-2025  Sandjai Ramasray  01.28.00  TRAN-6758 Delphi - Uitgaand- ATR_18_TMT_SMA Allocation and Reconciliation Volumes
   04-07-2025  Xander Pikaar     01.29.00  TRAN-7351: Prefix van de document mRID van EDP_50mFRRda afgekort naar EDP_50mFRR i.v.m de
                                           gewijzigde (langere) contract_id's. Tevens alle mRID beperkt op 35 posities i.p.v. 60. want
                                           een document mRID is maximaal 35 lang.
   24-10-2025  Nico KLaver       01.30.00  TRAN-6729: Nieuwe versie van get_period_to_publish: get_period_to_publish_new   
                                                      De oude blijft staan. De nieuiwe wordt voralsnog niet aangeroepen                                      
  **************************************************************************************************************************************/

  cn_package                      constant  varchar2(100)            := 'tmn_utilities';
  cn_versionnumber                constant  varchar2(100)            := '01.30.00';
  cn_process_id                   constant  varchar2(15)             := 'PROCESS_ID';
  cn_republication_allowed        constant  varchar2(30)             := 'REPUBLICATION_ALLOWED';
  cn_enabled                      constant sup_ojt_ppy.ppy_code%type := 'ENABLED';

  e_republication_not_allowed     exception;

  function get_versionnumber
  return varchar2
  is
    -- return versionnumber
  begin
    return cn_versionnumber;
  end get_versionnumber;


  function create_statement
  ( p_bvalidity_expr in varchar2
  )
  return varchar2 deterministic
  is
    /************************************************************************************************************************************
     Purpose:  Creeer het statement voor het bepalen van de bvalidity
    ************************************************************************************************************************************/
    cn_module                 constant varchar2(100) := cn_package || '.create_statement';

    v_stmt                             varchar2(4000);
    v_occurences                       number(10);
  begin
    v_stmt                        := p_bvalidity_expr;

    v_occurences                  := regexp_count(v_stmt, 'p_');

    -- Maak van parameter p_xxxxx een bind variable
    -- Hier wordt de parameter p_xxxx vervangen door :p_xxxx, b.v. p_checktime wordt in het statement :p_check_time

    if v_occurences > 0 then
      for occurence in 1 .. v_occurences loop
         v_stmt := replace(v_stmt
                          ,substr(v_stmt
                                 ,instr(v_stmt, 'p_', 1, occurence)                                                  -- De positie van p_
                                 ,replace(instr(v_stmt, ' ', instr(v_stmt, 'p_', 1, occurence)),0, length(v_stmt))   -- de spatie na p_. Als er geen spatie is, dan tot het eind van de string pakken
                                 )
                          ,':' ||substr(v_stmt
                                       ,instr(v_stmt, 'p_', 1, occurence)
                                       ,replace(instr(v_stmt, ' ', instr(v_stmt, 'p_', 1, occurence)),0, length(v_stmt))
                                       )
                          );
      end loop;
    else
       pcs_log_actions.log_error('Statement does not contain a parameter starting with p_');
    end if;
    -- Maak er een anoniem block van
    v_stmt := 'begin :out := ' || v_stmt || '; end;';

    return v_stmt;
  exception
    when others then
      pcs_log_actions.log_error( p_module => cn_module
                               );
      raise;
  end create_statement;
  --
  function execute_expression (p_time in date
                              ,p_expr in varchar2)
    return timestamp with time zone is
    --************************************************************************************************************************************
    -- Purpose:  Bepaal de bvalidity op basis van de opgevoerde locale datum en de opgegeven expressie
    --************************************************************************************************************************************
    cn_module                 constant varchar2(100) := cn_package || '.execute_expression';

    v_calculated_date date;
  begin
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start' || chr(10)
                                       || 'p_time          : ' || to_char(p_time, 'dd-mm-yyyy hh24:mi:ss') || chr(10)
                                       || 'p_expr          : ' || p_expr                                   || chr(10));

    -- Voer de expressie uit, het resultaat is een lokale datum
    execute immediate create_statement(p_expr)
      using out v_calculated_date
               ,p_time;

    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End' || chr(10)
                                       || 'v_calculated_date: ' || to_char(v_calculated_date, 'dd-mm-yyyy hh24:mi:ss') || chr(10));

    -- Zorg dat we niet in het niet bestaande uur van ze W/Z overgang komen
    if trunc(v_calculated_date) = sup_date_actions.date_wintersummerchange(p_year => to_char(v_calculated_date, 'yyyy'))
       and to_char(v_calculated_date, 'hh24') = '02'
    then
      v_calculated_date := v_calculated_date + 1/24;
    end if;

    --geef terug als een timestamp met locale timezone
    return from_tz(v_calculated_date, sup_constants.cn_loc_timezone);

  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;
  end execute_expression;
  --
  function is_republication_allowed (p_publication   in varchar2)
    return boolean
  is
    cn_module           constant varchar2(100) := cn_package || '.is_republication_allowed';

  begin
    return case nvl(sup_ojtppy_actions.get_domain_value(p_ojt_code => p_publication
                                                       ,p_ppy_code => cn_republication_allowed)
                   ,'Y')
             when 'Y'  then true
             when 'N'  then false
             else           true -- default is een herpublicatie toegestaan
           end;
     exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);

   end is_republication_allowed;

  procedure get_mrid(p_publication   in varchar2
                    ,p_pbn_date_utc  in date
                    ,p_tmn_mrid     out varchar2
                    )
  /**********************************************************************************************************************************
    Purpose    : Bepaal MRid op basis van publicatie en benodigde parameters
   **********************************************************************************************************************************/
  is
    v_next_version number(8);  -- Doen we niks mee
  begin
    tmn_utilities.get_mrid(p_publication      => p_publication
                          ,p_pbn_date_utc     => p_pbn_date_utc
                          ,p_tmn_mrid         => p_tmn_mrid
                          ,p_tmn_next_version => v_next_version
                          ,p_get_version      => false);
  end get_mrid;

  procedure get_mrid(p_publication       in varchar2
                    ,p_pbn_date_utc      in date
                    ,p_tmn_mrid         out varchar2
                    ,p_tmn_next_version out number
                    ,p_get_version       in boolean default true
                    )
   /**********************************************************************************************************************************
    Purpose    : Bepaal MRid op basis van pulicatie
   **********************************************************************************************************************************/
  is
    cn_module           constant varchar2(100) := cn_package || '.get_mrid';
    v_mrid_prefix                varchar2(25);

  begin
    if nvl(sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode), 'TRUE') = 'FALSE' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'Start'
                                 ||chr(10)||' p_publication      : '||p_publication
                                 ||chr(10)||' p_pbn_date_utc     : '||to_char(p_pbn_date_utc,sup_constants.cn_utc_date_format)
                                 ||chr(10)||' p_tmn_mrid         : '||p_tmn_mrid
                                 ||chr(10)||' p_tmn_next_version : '||p_tmn_next_version
                                 ||chr(10)||' p_get_version      : '||case when p_get_version then 'TRUE' else 'FALSE' end
                                );
    end if;

    -- Bepaal MRID
    p_tmn_mrid           := p_publication||'_'||to_char(p_pbn_date_utc,'yyyymmddhh24mi');

    -- Vervang het MRID prefix als dat moeten
    v_mrid_prefix        := sup_ojtppy_actions.get_domain_value(p_ojt_code                  => p_publication
                                                               ,p_ppy_code                  => 'MRID_PREFIX');
    if v_mrid_prefix is not null
    then
      p_tmn_mrid         := replace(p_tmn_mrid,'TDW',v_mrid_prefix);
    end if;

    -- Haal laatste versie op en bepaal nieuwe versienummer
    if p_get_version then
      p_tmn_next_version := pcs_tmn_actions.get_next_version(p_tmn_mrid => p_tmn_mrid);

      if  p_tmn_next_version > 1
      and not is_republication_allowed(p_publication => p_publication) then
        pcs_log_actions.log_error(p_module => cn_module
                                 ,p_text   => 'Republication not allowed for publication '
                                           || p_publication
                                           || ' MRID '
                                           || p_tmn_mrid
                                           || ' already published');
        raise e_republication_not_allowed;
      end if;
    end if;

    if nvl(sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode), 'TRUE') = 'FALSE' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'End'
                                 ||chr(10)||' p_publication      : '||p_publication
                                 ||chr(10)||' p_pbn_date_utc     : '||to_char(p_pbn_date_utc,sup_constants.cn_utc_date_format)
                                 ||chr(10)||' p_tmn_mrid         : '||p_tmn_mrid
                                 ||chr(10)||' p_tmn_next_version : '||p_tmn_next_version
                                 ||chr(10)||' p_get_version      : '||case when p_get_version then 'TRUE' else 'FALSE' end
                                );
    end if;
   exception
    when e_republication_not_allowed then
      raise_application_error(-20100, 'Republication not allowed for publication ' || p_publication);

    when others then
      pcs_log_actions.log_error(p_module => cn_module);

   end get_mrid;

  procedure get_mrid(p_publication      in varchar2
                    ,p_udc_sender_mrid  in varchar2
                    ,p_udc_mrid         in varchar2
                    ,p_tmn_mrid        out varchar2
                    )
   /**********************************************************************************************************************************
    Purpose    : Bepaal MRid op basis van publicatie en benodigde parameters
   **********************************************************************************************************************************/
  is
    v_next_version number(8);
  begin
    tmn_utilities.get_mrid(p_publication      => p_publication
                          ,p_udc_sender_mrid  => p_udc_sender_mrid
                          ,p_udc_mrid         => p_udc_mrid
                          ,p_tmn_mrid         => p_tmn_mrid
                          ,p_tmn_next_version => v_next_version);
  end get_mrid;

  procedure get_mrid(p_publication       in varchar2
                    ,p_udc_sender_mrid   in varchar2
                    ,p_udc_mrid          in varchar2
                    ,p_tmn_mrid         out varchar2
                    ,p_tmn_next_version out number
                    )
   /**********************************************************************************************************************************
    Purpose    : Bepaal MRid op basis van publicatie en benodigde parameters
   **********************************************************************************************************************************/
  is
    cn_module           constant varchar2(100) := cn_package || '.get_mrid';
  begin
    if nvl(sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode), 'TRUE') = 'FALSE' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'Start'
                                 ||chr(10)||' p_publication      : '||p_publication
                                 ||chr(10)||' p_udc_sender_mrid  : '||p_udc_sender_mrid
                                 ||chr(10)||' p_udc_mrid         : '||p_udc_mrid
                                 ||chr(10)||' p_tmn_mrid         : '||p_tmn_mrid
                                 ||chr(10)||' p_tmn_next_version : '||p_tmn_next_version
                                );
    end if;

    -- Bepaal MRID
    --p_tmn_mrid := p_publication||'_'||p_udc_sender_mrid||'_'||p_udc_mrid;
    p_tmn_mrid := p_publication||'_'||p_udc_mrid;

    -- Haal laatste versie op en bepaal nieuwe versienummer
    p_tmn_next_version := pcs_tmn_actions.get_next_version(p_tmn_mrid => p_tmn_mrid);

    if  p_tmn_next_version > 1
    and not is_republication_allowed(p_publication => p_publication) then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Republication not allowed for publication '
                                         || p_publication
                                         || ' MRID '
                                         || p_tmn_mrid
                                         || ' already published');
      raise e_republication_not_allowed;
    end if;

    if nvl(sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode), 'TRUE') = 'FALSE' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'End'
                                 ||chr(10)||' p_publication      : '||p_publication
                                 ||chr(10)||' p_udc_sender_mrid  : '||p_udc_sender_mrid
                                 ||chr(10)||' p_udc_mrid         : '||p_udc_mrid
                                 ||chr(10)||' p_tmn_mrid         : '||p_tmn_mrid
                                 ||chr(10)||' p_tmn_next_version : '||p_tmn_next_version
                                );
    end if;

   exception
    when e_republication_not_allowed then
      raise_application_error(-20100, 'Republication not allowed for publication ' || p_publication);

    when others then
      pcs_log_actions.log_error(p_module => cn_module);

   end get_mrid;

  procedure get_mrid(p_publication       in varchar2
                    ,p_contract_id       in varchar2
                    ,p_tmn_mrid         out varchar2
                    ,p_tmn_next_version out number
                    )
   /**********************************************************************************************************************************
    Purpose    : Bepaal MRid op basis van publicatie en benodigde parameters
   **********************************************************************************************************************************/
  is
    cn_module           constant varchar2(100) := cn_package || '.get_mrid';
  begin
    if nvl(sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode), 'TRUE') = 'FALSE' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'Start'
                                 ||chr(10)||' p_publication      : '||p_publication
                                 ||chr(10)||' p_contract_id      : '||p_contract_id
                                 ||chr(10)||' p_tmn_mrid         : '||p_tmn_mrid
                                 ||chr(10)||' p_tmn_next_version : '||p_tmn_next_version
                                );
    end if;

    -- Bepaal MRID
    if p_publication = 'EDP_50AFRR' then
      p_tmn_mrid := substr('EDP_50aFRR_' || p_contract_id, 1 ,35);
    elsif p_publication = 'EDP_50FCR' then
      p_tmn_mrid := substr('EDP_50FCR_'  || p_contract_id, 1 ,35);
    elsif p_publication = 'EDP_50MFRRDA' then
      p_tmn_mrid := substr('EDP_50mFRR_' || p_contract_id, 1 ,35); -- TRAN-7351: i.v.m. de maximale lengte van de mRID geen 'da' meer in de prefix
    elsif p_publication = 'EDP_52FRR' then
      p_tmn_mrid := substr('EDP_52R_' || replace(replace(replace(p_contract_id, ' ', ''), '-', ''), '_' ,''), 1 ,35);
    elsif p_publication = 'EDP_51FRR' then
      p_tmn_mrid := substr('EDP_51R_' || replace(replace(replace(p_contract_id, ' ', ''), '-', ''), '_', ''), 1, 35);
    end if;

    -- Haal laatste versie op en bepaal nieuwe versienummer
    p_tmn_next_version := pcs_tmn_actions.get_next_version(p_tmn_mrid => p_tmn_mrid);

    if  p_tmn_next_version > 1
    and not is_republication_allowed(p_publication => p_publication) then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Republication not allowed for publication '
                                         || p_publication
                                         || ' MRID '
                                         || p_tmn_mrid
                                         || ' already published');
      raise e_republication_not_allowed;
    end if;

    if nvl(sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode), 'TRUE') = 'FALSE' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'End'
                                 ||chr(10)||' p_publication      : '||p_publication
                                 ||chr(10)||' p_contract_id      : '||p_contract_id
                                 ||chr(10)||' p_tmn_mrid         : '||p_tmn_mrid
                                 ||chr(10)||' p_tmn_next_version : '||p_tmn_next_version
                                );
    end if;

   exception
    when e_republication_not_allowed then
      raise_application_error(-20100, 'Republication not allowed for publication ' || p_publication);

    when others then
      pcs_log_actions.log_error(p_module => cn_module);

   end get_mrid;

  procedure get_mrid(p_publication      in varchar2
                    ,p_auction_id       in varchar2
                    ,p_tmn_mrid         out varchar2
                    ,p_tmn_next_version out number
                    )
   /**********************************************************************************************************************************
    Purpose    : Bepaal MRid op basis van publicatie en benodigde parameters
   **********************************************************************************************************************************/
  is
    cn_module             constant varchar2(100) := cn_package || '.get_mrid';

    e_invalid_publication exception;
  begin
    if nvl(sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode), 'TRUE') = 'FALSE' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'Start'
                                 ||chr(10)||' p_publication      : '||p_publication
                                 ||chr(10)||' p_auction_id       : '||p_auction_id
                                 ||chr(10)||' p_tmn_mrid         : '||p_tmn_mrid
                                 ||chr(10)||' p_tmn_next_version : '||p_tmn_next_version
                                );
    end if;

    -- Bepaal MRID
    if p_publication  in ('EDP_52FCR', 'EDP_51FCR', 'EDP_50FCR') then
       p_tmn_mrid := substr(p_publication || '_' || replace(replace(replace(p_auction_id, ' ', ''), '-', ''), '_' ,''), 1 ,35);
    elsif p_publication = 'EDP_75FCR' then
       p_tmn_mrid := p_publication || '_' || replace(p_auction_id, 'FCR_','');
    else
       raise e_invalid_publication;
    end if;

    -- Haal laatste versie op en bepaal nieuwe versienummer
    p_tmn_next_version := pcs_tmn_actions.get_next_version(p_tmn_mrid => p_tmn_mrid);

    if  p_tmn_next_version > 1
    and not is_republication_allowed(p_publication => p_publication) then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Republication not allowed for publication '
                                         || p_publication
                                         || ' MRID '
                                         || p_tmn_mrid
                                         || ' already published');
      raise e_republication_not_allowed;
    end if;

    if nvl(sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode), 'TRUE') = 'FALSE' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'End'
                                 ||chr(10)||' p_publication      : '||p_publication
                                 ||chr(10)||' p_auction_id       : '||p_auction_id
                                 ||chr(10)||' p_tmn_mrid         : '||p_tmn_mrid
                                 ||chr(10)||' p_tmn_next_version : '||p_tmn_next_version
                                );
    end if;

   exception
    when e_invalid_publication then
      raise_application_error(-20101, 'Invalid publication ' || p_publication);

    when e_republication_not_allowed then
      raise_application_error(-20100, 'Republication not allowed for publication ' || p_publication);

    when others then
      pcs_log_actions.log_error(p_module => cn_module);

  end get_mrid;

  procedure get_mrid(p_mrid_prefix        in         varchar2
                    ,p_mrid_suffix_format in         varchar2
                    ,p_pbn_date           in         date
                    ,p_mrid_suffix        in         varchar2 default null
                    ,p_tmn_mrid           out nocopy varchar2
                    )
   /**********************************************************************************************************************************
    Purpose    : Bepaal MRid op basis van mrid_prefix en benodigde parameters (DQF)
   **********************************************************************************************************************************/
  is
    cn_module           constant varchar2(100) := cn_package || '.get_mrid';
  begin
    if nvl(sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode), 'TRUE') = 'FALSE' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'Start'
                                 ||chr(10)||' p_mrid_prefix       : '||p_mrid_prefix
                                 ||chr(10)||' p_mrid_suffix_format: '||p_mrid_suffix_format
                                 ||chr(10)||' p_mrid_suffix       : '||p_mrid_suffix
                                 ||chr(10)||' p_pbn_date          : '||to_char(p_pbn_date, sup_constants.cn_utc_date_format)
                                );
    end if;

    -- Bepaal MRID
    if p_mrid_suffix is null then
      if instr(p_mrid_suffix_format, '<mrid_suffix>') > 0 then
         -- voor de zekerheid, anders krijg je een lege mrid als de mrid_suffix niet gevuld is
         p_tmn_mrid := p_mrid_prefix  || to_char(p_pbn_date, replace(p_mrid_suffix_format, '<mrid_suffix>', ''));
      else
         p_tmn_mrid := p_mrid_prefix || to_char(p_pbn_date, p_mrid_suffix_format);
      end if;
    else
      if instr(p_mrid_suffix_format, '<mrid_suffix>') > 0 then
         -- Het mrid_suffix_format geeft aan waar de mrid_suffix moet komen
         p_tmn_mrid := p_mrid_prefix  || to_char(p_pbn_date, replace(p_mrid_suffix_format, '<mrid_suffix>', '"'||p_mrid_suffix||'"'));
      else
         -- Nu is de suffix een echte suffix en komt hij achteraan
         p_tmn_mrid := p_mrid_prefix  || to_char(p_pbn_date, p_mrid_suffix_format) || p_mrid_suffix;
      end if;
    end if;

    if nvl(sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode), 'TRUE') = 'FALSE' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'End'
                                 ||chr(10)||' p_tmn_mrid: '||p_tmn_mrid
                                );
    end if;
   exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module
                               );

  end get_mrid;


  procedure get_mrid(p_publication      in varchar2
                    ,p_transaction_id   in varchar2
                    ,p_tmn_mrid         out varchar2
                    ,p_tmn_next_version out number
                    )
   /**********************************************************************************************************************************
    Purpose    : Bepaal MRid op basis van publicatie en benodigde parameters
   **********************************************************************************************************************************/
  is
    cn_module           constant varchar2(100) := cn_package || '.get_mrid';
  begin
    if nvl(sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode), 'TRUE') = 'FALSE' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'Start'
                                 ||chr(10)|| ' p_publication      : ' || p_publication
                                 ||chr(10)|| ' p_transaction_id   : ' || p_transaction_id
                                 ||chr(10)|| ' p_tmn_mrid         : ' || p_tmn_mrid
                                 ||chr(10)|| ' p_tmn_next_version : ' || p_tmn_next_version
                                );
    end if;

    -- Bepaal MRID
    p_tmn_mrid   := p_publication || '_' || p_transaction_id;

    -- Haal laatste versie op en bepaal nieuwe versienummer
    p_tmn_next_version := pcs_tmn_actions.get_next_version(p_tmn_mrid => p_tmn_mrid);

    if  p_tmn_next_version > 1
    and not is_republication_allowed(p_publication => p_publication) then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Republication not allowed for publication '
                                         || p_publication
                                         || ' MRID '
                                         || p_tmn_mrid
                                         || ' already published');
      raise e_republication_not_allowed;
    end if;

    if nvl(sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode), 'TRUE') = 'FALSE' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'End'
                                 ||chr(10)|| ' p_publication      : ' || p_publication
                                 ||chr(10)|| ' p_transaction_id   : ' || p_transaction_id
                                 ||chr(10)|| ' p_tmn_mrid         : ' || p_tmn_mrid
                                 ||chr(10)|| ' p_tmn_next_version : ' || p_tmn_next_version
                                );
    end if;

   exception
    when e_republication_not_allowed then
      raise_application_error(-20100, 'Republication not allowed for publication ' || p_publication);

    when others then
      pcs_log_actions.log_error(p_module => cn_module);

   end get_mrid;

  procedure get_mrid(p_publication      in varchar2
                    ,p_border_ara_code  in varchar2
                    ,p_pbn_date_loc     in varchar2
                    ,p_tmn_mrid         out varchar2
                    ,p_tmn_next_version out number
                    )
  /**********************************************************************************************************************************
   Purpose    : Bepaal MRid op basis van publicatie, border_ara_code en pbn_date_loc.
  **********************************************************************************************************************************/
  is
    cn_module           constant varchar2(100) := cn_package || '.get_mrid';
  begin
    if nvl(sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode), 'TRUE') = 'FALSE' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'Start'
                                 ||chr(10)|| ' p_publication      : ' || p_publication
                                 ||chr(10)|| ' p_border_ara_code  : ' || p_border_ara_code
                                 ||chr(10)|| ' p_pbn_date_loc     : ' || p_pbn_date_loc
                                 ||chr(10)|| ' p_tmn_mrid         : ' || p_tmn_mrid
                                 ||chr(10)|| ' p_tmn_next_version : ' || p_tmn_next_version
                                );
    end if;
    -- Bepaal MRID
    p_tmn_mrid := p_publication || '_' || p_border_ara_code || '_' || p_pbn_date_loc;

    -- Haal laatste versie op en bepaal nieuwe versienummer
    p_tmn_next_version := pcs_tmn_actions.get_next_version(p_tmn_mrid => p_tmn_mrid);

    if  p_tmn_next_version > 1
    and not is_republication_allowed(p_publication => p_publication) then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Republication not allowed for publication '
                                         || p_publication
                                         || ' MRID '
                                         || p_tmn_mrid
                                         || ' already published');
      raise e_republication_not_allowed;
    end if;

    if nvl(sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode), 'TRUE') = 'FALSE' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'End'
                                ||chr(10)|| ' p_publication      : ' || p_publication
                                ||chr(10)|| ' p_border_ara_code  : ' || p_border_ara_code
                                ||chr(10)|| ' p_pbn_date_loc     : ' || p_pbn_date_loc
                                ||chr(10)|| ' p_tmn_mrid         : ' || p_tmn_mrid
                                ||chr(10)|| ' p_tmn_next_version : ' || p_tmn_next_version
                                );
    end if;
  exception
   when e_republication_not_allowed then
     raise_application_error(-20100, 'Republication not allowed for publication ' || p_publication);

   when others then
     pcs_log_actions.log_error(p_module => cn_module);

  end get_mrid;

  procedure get_mrid(p_publication      in varchar2
                    ,p_message_id       in varchar2
                    ,p_tmn_mrid         out varchar2
                    )
  /**********************************************************************************************************************************
   Purpose    : Bepaal MRid op basis van publicatie, border_ara_code en pbn_date_loc.
  **********************************************************************************************************************************/
  is
    cn_module           constant varchar2(100) := cn_package || '.get_mrid';
    v_tmn_next_version           number(10);
  begin
    if nvl(sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode), 'TRUE') = 'FALSE' then
       pcs_log_actions.log_trace(p_module   => cn_module
                                ,p_text     => 'Start'
                                   ||chr(10)|| ' p_publication      : ' || p_publication
                                   ||chr(10)|| ' p_message_id       : ' || p_message_id
                                   ||chr(10)|| ' p_tmn_mrid         : ' || p_tmn_mrid
                                );
    end if;

    -- Bepaal MRID
    p_tmn_mrid                          := p_publication || '_' || p_message_id;

    -- Haal laatste versie op en bepaal nieuwe versienummer
    v_tmn_next_version                  := pcs_tmn_actions.get_next_version(p_tmn_mrid => p_tmn_mrid);

    if  v_tmn_next_version > 1
    and not is_republication_allowed(p_publication => p_publication) then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Republication not allowed for publication '
                                         || p_publication
                                         || ' MRID '
                                         || p_tmn_mrid
                                         || ' already published');
      raise e_republication_not_allowed;
    end if;

    if nvl(sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode), 'TRUE') = 'FALSE' then
       pcs_log_actions.log_trace(p_module   => cn_module
                                ,p_text     => 'End'
                                   ||chr(10)|| ' p_publication      : ' || p_publication
                                   ||chr(10)|| ' p_message_id       : ' || p_message_id
                                   ||chr(10)|| ' p_tmn_mrid         : ' || p_tmn_mrid
                                 );
    end if;

   exception
    when e_republication_not_allowed then
      raise_application_error(-20100, 'Republication not allowed for publication ' || p_publication);

    when others then
      pcs_log_actions.log_error(p_module => cn_module);

  end get_mrid;

  procedure get_mrid(p_publication                      in varchar2
                    ,p_reconciliation_date              in timestamp
                    ,p_tmn_mrid                        out nocopy varchar2
                    )
  /**********************************************************************************************************************************
   Purpose    : Bepaal MRid op basis van publicatie en reconciliation_date.
  **********************************************************************************************************************************/
  is
    cn_module           constant varchar2(100) := cn_package || '.get_mrid';
    v_tmn_next_version           number(10);
  begin
    if nvl(sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode), 'TRUE') = 'FALSE' then
       pcs_log_actions.log_trace(p_module   => cn_module
                                ,p_text     => 'Start'
                                   ||chr(10)|| ' p_publication        : ' || p_publication
                                   ||chr(10)|| ' p_reconciliation_date: ' || to_char(p_reconciliation_date,'dd-mm-yyyy hh24:mi')
                                   ||chr(10)|| ' p_tmn_mrid           : ' || p_tmn_mrid
                                );
    end if;

    -- Bepaal MRID als p_publication + '_' + reconciliation_date (time in UTC)
    p_tmn_mrid                          := p_publication|| '_' || to_char(p_reconciliation_date,'yyyymmddhh24mi');

    -- Haal laatste versie op en bepaal nieuwe versienummer
    v_tmn_next_version                  := pcs_tmn_actions.get_next_version(p_tmn_mrid => p_tmn_mrid);

    if  v_tmn_next_version > 1
    and not is_republication_allowed(p_publication => p_publication) then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Republication not allowed for publication '
                                         || p_publication
                                         || ' MRID '
                                         || p_tmn_mrid
                                         || ' already published');
      raise e_republication_not_allowed;
    end if;

    if nvl(sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode), 'TRUE') = 'FALSE' then
       pcs_log_actions.log_trace(p_module   => cn_module
                                ,p_text     => 'End'
                                   ||chr(10)|| ' p_publication        : ' || p_publication
                                   ||chr(10)|| ' p_reconciliation_date: ' || to_char(p_reconciliation_date,'dd-mm-yyyy hh24:mi')
                                   ||chr(10)|| ' p_tmn_mrid           : ' || p_tmn_mrid
                                 );
    end if;

   exception
    when e_republication_not_allowed then
      raise_application_error(-20100, 'Republication not allowed for publication ' || p_publication);

    when others then
      pcs_log_actions.log_error(p_module => cn_module);
  end get_mrid;

  procedure get_xml (p_publication     in varchar2
                    ,p_tmn_xml_result  out xmltype
                    )
   /**********************************************************************************************************************************
     Purpose    : draai een xml view behorend bij publicatie p_publication
    **********************************************************************************************************************************/
  is
    cn_module           constant varchar2(100) := cn_package || '.get_xml';
    v_statement         varchar2(5000);
    v_publication_view  varchar2(100);
    c_xml               sys_refcursor;
    v_xml_result        xmltype;

   e_no_publication_view   exception;
   e_no_publication_data   exception;

  begin

    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start'
                                       ||chr(10)|| ' p_publication : '||p_publication
                             );
    -- Ophalen xml view
    v_publication_view := sup_ojtppy_actions.get_domain_value(p_ojt_code => p_publication
                                                             ,p_ppy_code => 'PUBLICATION_VIEW'
                                                             );

    if v_publication_view is null then
       raise e_no_publication_view;
    end if;

    v_statement           := 'select xml_document'
                           || ' from ' || v_publication_view;
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start'
                                       ||chr(10)|| ' v_statement : '||v_statement
                             );

    open c_xml for v_statement;
    fetch c_xml
        into v_xml_result;
    close c_xml;

    if v_xml_result is null then
      raise e_no_publication_data;
    end if;

    p_tmn_xml_result := v_xml_result;

    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End'
                             );
  exception
    when e_no_publication_view then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   =>  p_publication || ': Geen XML view aanwezig'
                               );
    when e_no_publication_data then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   =>  p_publication || ': Geen XML data aanwezig'
                               );
    when others then
      -- Log het xml-bericht als deze gevuld is (geen idee wanneer dit voor zou moeten komen)
      if v_xml_result is not null then
        pcs_message_actions.store_message(p_message => v_xml_result
                                         ,p_pcs_id  => sup_globals.get_global_number(p_name => cn_process_id));
      end if;

      pcs_log_actions.log_error(p_module => cn_module);

      -- Log v_statement, mocht daar iets raars zitten
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Statement: ' || v_statement);
  end get_xml;
  --
  procedure get_json (p_publication     in varchar2
                     ,p_tmn_json_result out clob
                     )
   /**********************************************************************************************************************************
     Purpose    : draai een xml view behorend bij publicatie p_publication
    **********************************************************************************************************************************/
  is
    cn_module           constant varchar2(100) := cn_package || '.get_json';
    v_statement         varchar2(5000);
    v_publication_view  varchar2(100);
    c_json              sys_refcursor;
    v_json_result       clob := empty_clob;

   e_no_publication_view   exception;
   e_no_publication_data   exception;

  begin

    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start'
                                       ||chr(10)|| ' p_publication : '||p_publication
                             );

    -- Ophalen xml view
    v_publication_view := sup_ojtppy_actions.get_domain_value(p_ojt_code => p_publication
                                                             ,p_ppy_code => 'PUBLICATION_VIEW'
                                                             );

    if v_publication_view is null then
       raise e_no_publication_view;
    end if;

    v_statement           := 'select json_document'
                             || ' from ' || v_publication_view;
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start'
                                       ||chr(10)|| ' v_statement : '||v_statement
                             );

    open c_json for v_statement;
    fetch c_json
        into v_json_result;
    close c_json;

    if v_json_result is null then
      raise e_no_publication_data;
    end if;

    -- Gek genoeg kan dat niet met een dmbs_lob.copy en 2 aparte clobs
    p_tmn_json_result         := v_json_result;

    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End'
                             );
  exception
    when e_no_publication_view then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   =>  p_publication || ': Geen JSON view aanwezig'
                               );
    when e_no_publication_data then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   =>  p_publication || ': Geen JSON data aanwezig'
                               );
    when others then
      -- Log het json-bericht als deze gevuld is (geen idee wanneer dit voor zou moeten komen)
      if v_json_result is not null then
        pcs_message_actions.store_message(p_message => v_json_result
                                         ,p_pcs_id  => sup_globals.get_global_number(p_name => cn_process_id));
      end if;

      pcs_log_actions.log_error(p_module => cn_module);

      -- Log v_statement, mocht daar iets raars zitten
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Statement: ' || v_statement);
  end get_json;

  procedure get_period_to_publish(p_publication        in sup_publications.name%type
                                 ,p_pbn_date_utc       in date
                                 ,p_pbn_date_utc_from out date
                                 ,p_pbn_date_utc_to   out date
                                 )
   /**********************************************************************************************************************************
    Purpose    : Bepaal de periode waarover transmissies moeten worden aangemaakt
   **********************************************************************************************************************************/
  is
    cn_module constant varchar2(100) := cn_package||'.get_period_to_publish';

    v_pbn_date_utc          timestamp with time zone;
    v_pbn_date_loc          timestamp with time zone;
    v_pbn_date_loc_from_tz  timestamp with time zone;
    v_pbn_date_loc_to_tz    timestamp with time zone;
    v_pbn_date_loc_from     timestamp;
    v_pbn_date_loc_to       timestamp;
    v_period_length_loc     number(20,10);
    v_period_length_utc     number(20,10);
    v_session_timezone      varchar2(100);
    v_expr_period_from      varchar2(4000);
    v_expr_period_to        varchar2(4000);

    e_no_period_to_publish exception;

  begin
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start'
                              ||chr(10)||' p_publication      : '||p_publication
                              ||chr(10)||' p_pbn_date_utc     : '||to_char(p_pbn_date_utc     ,sup_constants.cn_utc_date_format)
                              ||chr(10)||' p_pbn_date_utc_from: '||to_char(p_pbn_date_utc_from,sup_constants.cn_utc_date_format)
                              ||chr(10)||' p_pbn_date_utc_to  : '||to_char(p_pbn_date_utc_to  ,sup_constants.cn_utc_date_format)
                             );

    -- Bepaal of de sessie in zomer of wintertijd zit
    select to_char(systimestamp, 'tzh:tzm')
      into v_session_timezone
      from dual;

    -- Zet tijd bewust in UTC timezone
    v_pbn_date_utc                      := to_timestamp_tz(to_char(p_pbn_date_utc,'dd-mm-yyyy hh24:mi:ss') || ' UTC', 'dd-mm-yyyy hh24:mi:ss tzr');

    -- Reken om naar lokaal. We rekenen nu verder met lokale tijden om het zomer/wintertijd probleem op te lossen
    v_pbn_date_loc                      := sup_date_actions.convertutc2local_ts(p_ts_tz => v_pbn_date_utc);

    -- Bepaal start en end van period_to_publish
     v_expr_period_from                 := sup_ojtppy_actions.get_domain_value(p_ojt_code => p_publication
                                                                              ,p_ppy_code => 'PERIOD_TO_PUBLISH_START');

     v_expr_period_to                   := sup_ojtppy_actions.get_domain_value(p_ojt_code => p_publication
                                                                              ,p_ppy_code => 'PERIOD_TO_PUBLISH_END');
    if v_expr_period_from is null
    or v_expr_period_to   is null then
       raise e_no_period_to_publish;
    end if;

    v_pbn_date_loc_from                 := execute_expression(p_time => v_pbn_date_loc, p_expr => v_expr_period_from);
    v_pbn_date_loc_to                   := execute_expression(p_time => v_pbn_date_loc, p_expr => v_expr_period_to);

    -- Zet de zojuist berekende datum (v_pbn_date_loc_from) om naar een timestamp with time_zone en hou daarbij rekening met de zomer- en wintertijd
    -- In de zomertijd
    if trunc(v_pbn_date_loc_from) between sup_date_actions.date_wintersummerchange(extract (year from v_pbn_date_loc_from))
                                      and sup_date_actions.date_summerwinterchange(extract (year from v_pbn_date_loc_from)) then
     -- Te bereken datum valt tussen de w/z en z/w overgang
       if  trunc(v_pbn_date_loc_from) = sup_date_actions.date_summerwinterchange(extract (year from v_pbn_date_loc_from))
       and to_char(v_pbn_date_loc_from, 'hh24') = '02' then
           if to_number(to_char(p_pbn_date_utc, 'hh24')) = 0 then -- UTC > 0, dat is vanaf de 2e keer 03:00
              -- We zitten in het dubbele uur van de W/Z overgang en nu nog in zomertijd, dan blijven we in zomertijd
              v_pbn_date_loc_from_tz    := to_timestamp_tz(to_char(v_pbn_date_loc_from, 'dd-mm-yyyy hh24:mi:ss') || ' ' ||sup_constants.cn_loc_timezone|| ' CEST', 'dd-mm-yyyy hh24:mi:ss TZR TZD');
           else
              -- We zitten in het dubbele uur van de W/Z overgang en nu in wintertijd, dan blijven we in wintertijd
              v_pbn_date_loc_from_tz    := to_timestamp_tz(to_char(v_pbn_date_loc_from, 'dd-mm-yyyy hh24:mi:ss') || ' ' ||sup_constants.cn_loc_timezone|| ' CET' , 'dd-mm-yyyy hh24:mi:ss TZR TZD');
           end if;
       elsif trunc(v_pbn_date_loc_from) = sup_date_actions.date_summerwinterchange(extract (year from v_pbn_date_loc_from))
         and to_char(v_pbn_date_loc_from, 'hh24') > '02' then
            -- We zitten na het dubbele uur op de Z/W overgang, dan is het wintertijd
            v_pbn_date_loc_from_tz    := to_timestamp_tz(to_char(v_pbn_date_loc_from, 'dd-mm-yyyy hh24:mi:ss') || ' ' ||sup_constants.cn_loc_timezone|| ' CET' , 'dd-mm-yyyy hh24:mi:ss TZR TZD');
       elsif trunc(v_pbn_date_loc_from) = sup_date_actions.date_wintersummerchange(extract (year from v_pbn_date_loc_from))
         and to_char(v_pbn_date_loc_from, 'hh24') < '02' then
            -- We zitten op de W/Z overgang, voor 2 uur, dan is het nog wintertijd
            v_pbn_date_loc_from_tz    := to_timestamp_tz(to_char(v_pbn_date_loc_from, 'dd-mm-yyyy hh24:mi:ss') || ' ' ||sup_constants.cn_loc_timezone|| ' CET' , 'dd-mm-yyyy hh24:mi:ss TZR TZD');
       else
            -- Alle andere gevallen is het zomertijd
            v_pbn_date_loc_from_tz    := to_timestamp_tz(to_char(v_pbn_date_loc_from, 'dd-mm-yyyy hh24:mi:ss') || ' ' ||sup_constants.cn_loc_timezone, 'dd-mm-yyyy hh24:mi:ss TZR');
        end if;

    else
      -- De te berekenen datum valt in de wintertijd
      v_pbn_date_loc_from_tz            := to_timestamp_tz(to_char(v_pbn_date_loc_from, 'dd-mm-yyyy hh24:mi:ss') || ' ' ||sup_constants.cn_loc_timezone|| ' CET' , 'dd-mm-yyyy hh24:mi:ss TZR TZD');
    end if;

    -- En nu ook v_pbn_date_loc_to in de juiste tijdzone zetten
    if trunc(v_pbn_date_loc_to) between sup_date_actions.date_wintersummerchange(extract (year from v_pbn_date_loc_to))
                                    and sup_date_actions.date_summerwinterchange(extract (year from v_pbn_date_loc_to)) then
     -- Te bereken datum valt tussen de w/z en z/w overgang
       if  trunc(v_pbn_date_loc_to) = sup_date_actions.date_summerwinterchange(extract (year from v_pbn_date_loc_to))
       and to_char(v_pbn_date_loc_to, 'hh24') = '02' then
           if to_number(to_char(p_pbn_date_utc, 'hh24')) = 0 then -- UTC > 0, dat is vanaf de 2e keer 03:00
              -- We zitten in het dubbele uur van de W/Z overgang en nu nog in zomertijd, dan blijven we in zomertijd
              v_pbn_date_loc_to_tz      := to_timestamp_tz(to_char(v_pbn_date_loc_to  , 'dd-mm-yyyy hh24:mi:ss') || ' ' ||sup_constants.cn_loc_timezone|| ' CEST', 'dd-mm-yyyy hh24:mi:ss TZR TZD');
           else
              -- We zitten in het dubbele uur van de W/Z overgang en nu in wintertijd, dan blijven we in wintertijd
              v_pbn_date_loc_to_tz      := to_timestamp_tz(to_char(v_pbn_date_loc_to  , 'dd-mm-yyyy hh24:mi:ss') || ' ' ||sup_constants.cn_loc_timezone|| ' CET' , 'dd-mm-yyyy hh24:mi:ss TZR TZD');
           end if;
       elsif trunc(v_pbn_date_loc_to) = sup_date_actions.date_summerwinterchange(extract (year from v_pbn_date_loc_to))
         and to_char(v_pbn_date_loc_to, 'hh24') > '02' then
            -- We zitten na het dubbele uur op de Z/W overgang, dan is het wintertijd
            v_pbn_date_loc_to_tz      := to_timestamp_tz(to_char(v_pbn_date_loc_to  , 'dd-mm-yyyy hh24:mi:ss') || ' ' ||sup_constants.cn_loc_timezone|| ' CET' , 'dd-mm-yyyy hh24:mi:ss TZR TZD');
       elsif trunc(v_pbn_date_loc_to) = sup_date_actions.date_wintersummerchange(extract (year from v_pbn_date_loc_to))
         and to_char(v_pbn_date_loc_to, 'hh24') < '02' then
            -- We zitten op de W/Z overgang, voor 2 uur, dan is het nog wintertijd
            v_pbn_date_loc_to_tz      := to_timestamp_tz(to_char(v_pbn_date_loc_to  , 'dd-mm-yyyy hh24:mi:ss') || ' ' ||sup_constants.cn_loc_timezone|| ' CET' , 'dd-mm-yyyy hh24:mi:ss TZR TZD');
       else
            -- Alle andere gevallen is het zomertijd
            v_pbn_date_loc_to_tz      := to_timestamp_tz(to_char(v_pbn_date_loc_to  , 'dd-mm-yyyy hh24:mi:ss') || ' ' ||sup_constants.cn_loc_timezone, 'dd-mm-yyyy hh24:mi:ss TZR');
        end if;
    else
      -- De te berekenen datum valt in de wintertijd
      v_pbn_date_loc_to_tz              := to_timestamp_tz(to_char(v_pbn_date_loc_to  , 'dd-mm-yyyy hh24:mi:ss') || ' ' ||sup_constants.cn_loc_timezone|| ' CET' , 'dd-mm-yyyy hh24:mi:ss TZR TZD');
    end if;

    -- Bereken de lengte van de periode voor de conversie naar UTC. Dit hebben we nodig vanwege de zomer-/wintertijdovergang. Doordat b.v. de from-date
    -- in de zomertijd zit en de to_date in de wintertijd kan de lengte van de periode fout gaan
    v_period_length_loc                := cast(v_pbn_date_loc_to as date) - cast(v_pbn_date_loc_from as date);
    -- En nu weer terug naar UTC
    p_pbn_date_utc_from                := sup_date_actions.convertlocal2utc_ts(p_ts_tz => v_pbn_date_loc_from_tz);
    p_pbn_date_utc_to                  := sup_date_actions.convertlocal2utc_ts(p_ts_tz => v_pbn_date_loc_to_tz);

    -- Als we op dit moment in de wintertijd zitten en de LOKALE datum die we berekenen valt in het zomer-/wintertijd-uur en de offset van de berekende LOKALE datum
      -- zit op het zomertijd uur zal de UTC-tijd een uur te laat berekend zijn en moeten we de UTC-tijd een uur corrigeren om op de juiste UTC-tijd van de lokale wintertijd uit te komen.
    if  trunc(v_pbn_date_loc) = sup_date_actions.date_summerwinterchange(extract (year from v_pbn_date_loc))
    and to_char(v_pbn_date_loc, 'hh24 tzh:tzm') = '02 +02:00'
    and v_session_timezone                      = '+01:00'  then
        p_pbn_date_utc_from := p_pbn_date_utc_from - interval '0 01:00:00' day to second;
    end if;

    v_period_length_utc                := p_pbn_date_utc_to - p_pbn_date_utc_from;

    -- Doordat we geen timestamp hebben kan het nu in de vertaling van lokaal naar UTC voorkomen dat de tot-datum voor de vanaf-datum komt
    -- of er gelijk aan wordt. Dan controleren of we op de winter/zomer- of zomer/winterrovergang zitten. In dat geval simpelwel een uur bij
    -- de tot-datum optellen.
    if p_pbn_date_utc_to <= p_pbn_date_utc_from then
       -- Bij de bepaling of we op een overgangsdag zitten uitgaan van de lokale tijd die we al hadden
       if trunc(v_pbn_date_loc_from) = sup_date_actions.date_summerwinterchange(extract (year from v_pbn_date_loc))
       or trunc(v_pbn_date_loc_from) = sup_date_actions.date_wintersummerchange(extract (year from v_pbn_date_loc)) then
          p_pbn_date_utc_to            := p_pbn_date_utc_to + interval '0 01:00:00' day to second;
       else
          pcs_log_actions.log_error(p_module => cn_module
                                   ,p_text   => 'Calculated pbn_date_utc_to ('
                                             || to_char(p_pbn_date_utc_to,'dd-mm-yyyy hh24:mi:ss')
                                             || ') lies before calculated pbn_date_utc_from ('
                                             || to_char(p_pbn_date_utc_from,'dd-mm-yyyy hh24:mi:ss')
                                             || ').');
       end if;
    else
       -- Als we op de zomer-/wintertijd overgang zitten en de from date zit in de zomertijd, dan kan het dat de to_date in de wintertijd uitkomt.
       -- Publicaties kleiner dan een dag moeten dan echter ook nog uitgaan van de zomertijd, dus moeten we een uur van de to-date aftrekken.
       -- Om dat te signaleren kijken we of het verschil tussen de berekende lokale van/tot datum afwijkt van het verschil tussen beide UTC-data.
       -- Dit moeten we bij publicaties die meer dan een dag betrekken niet doen: die moeten dan van 22:00 tot 23:00 lopen.
       if  trunc(v_pbn_date_loc_from) = sup_date_actions.date_summerwinterchange(extract (year from v_pbn_date_loc))
       and v_period_length_utc != v_period_length_loc
       and v_period_length_utc  < 1 -- 1 dag
       then
           p_pbn_date_utc_to                :=  p_pbn_date_utc_to - interval '0 01:00:00' day to second;
       end if;
    end if;

    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End'
                              ||chr(10)||' p_publication      : '||p_publication
                              ||chr(10)||' p_pbn_date_utc     : '||to_char(p_pbn_date_utc     ,sup_constants.cn_utc_date_format)
                              ||chr(10)||' p_pbn_date_utc_from: '||to_char(p_pbn_date_utc_from,sup_constants.cn_utc_date_format)
                              ||chr(10)||' p_pbn_date_utc_to  : '||to_char(p_pbn_date_utc_to  ,sup_constants.cn_utc_date_format)
                             );
   exception
    when e_no_period_to_publish then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'No period to publish parameters found for publication: '||p_publication);
      raise;

    when others then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Parameters'
                                ||chr(10)||' p_publication      : '||p_publication
                                ||chr(10)||' p_pbn_date_utc     : '||to_char(p_pbn_date_utc     ,sup_constants.cn_utc_date_format)
                                ||chr(10)||' p_pbn_date_utc_from: '||to_char(p_pbn_date_utc_from,sup_constants.cn_utc_date_format)
                                ||chr(10)||' p_pbn_date_utc_to  : '||to_char(p_pbn_date_utc_to  ,sup_constants.cn_utc_date_format)
                               );

  end get_period_to_publish;

  procedure get_period_to_publish_new(p_publication        in sup_publications.name%type
                                     ,p_pbn_date_utc       in date
                                     ,p_pbn_date_utc_from out date
                                     ,p_pbn_date_utc_to   out date
                                     )
   /**********************************************************************************************************************************
    Purpose    : Bepaal de periode waarover transmissies moeten worden aangemaakt
   **********************************************************************************************************************************/
  is
    cn_module constant varchar2(100) := cn_package||'.get_period_to_publish_new';

    v_pbn_date_utc          timestamp with time zone;
    v_pbn_date_loc          timestamp with time zone;
    v_pbn_date_loc_from_tz  timestamp with time zone;
    v_pbn_date_loc_to_tz    timestamp with time zone;
    v_pbn_date_utc_from     timestamp;
    v_pbn_date_utc_to       timestamp;
    v_period_length_loc     number(20,10);
    v_period_length_utc     number(20,10);
    v_session_timezone      varchar2(100);
    v_expr_period_from      varchar2(4000);
    v_expr_period_to        varchar2(4000);

    e_no_period_to_publish exception;

  begin
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start'
                              ||chr(10)||' p_publication      : '||p_publication
                              ||chr(10)||' p_pbn_date_utc     : '||to_char(p_pbn_date_utc     ,sup_constants.cn_utc_date_format)
                             );


    -- Bepaal start en end van period_to_publish
     v_expr_period_from                 := sup_ojtppy_actions.get_domain_value(p_ojt_code => p_publication
                                                                              ,p_ppy_code => 'PERIOD_TO_PUBLISH_START');
     v_expr_period_to                   := sup_ojtppy_actions.get_domain_value(p_ojt_code => p_publication
                                                                              ,p_ppy_code => 'PERIOD_TO_PUBLISH_END');
    if v_expr_period_from is null
    or v_expr_period_to   is null then
       raise e_no_period_to_publish;
    end if;

    p_pbn_date_utc_from                 := sup_date_actions.exec_expression(p_utc_date_in => p_pbn_date_utc, p_expr => v_expr_period_from);
    p_pbn_date_utc_to                   := sup_date_actions.exec_expression(p_utc_date_in => p_pbn_date_utc, p_expr => v_expr_period_to);
    
    sup_date_actions.correct_period(p_bvalidity_utc_from => v_pbn_date_utc_from, p_bvalidity_utc_to => v_pbn_date_utc_to);


    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End'
                                       ||chr(10)||' p_publication      : '||p_publication
                                       ||chr(10)||' p_pbn_date_utc     : '||to_char(p_pbn_date_utc     ,sup_constants.cn_utc_date_format)
                                       ||chr(10)||' p_pbn_date_utc_from: '||to_char(p_pbn_date_utc_from,sup_constants.cn_utc_date_format)
                                       ||chr(10)||' p_pbn_date_utc_to  : '||to_char(p_pbn_date_utc_to  ,sup_constants.cn_utc_date_format)
                             );
   exception
    when e_no_period_to_publish then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'No period to publish parameters found for publication: '||p_publication);
      raise;

    when others then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Parameters'
                                ||chr(10)||' p_publication      : '||p_publication
                                ||chr(10)||' p_pbn_date_utc     : '||to_char(p_pbn_date_utc     ,sup_constants.cn_utc_date_format)
                               );

  end get_period_to_publish_new;


end tmn_utilities;
/
