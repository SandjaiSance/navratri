create or replace package body sup_utilities is

  /***********************************************************************************************************************************
   Purpose    : Diverse hele algemene ondersteunende functies

   Change History
   Date        Author         Version   Description
   ----------  -------------  --------  ----------------------------------------------------------------------------------------------
   07-04-2017  X. Pikaar      01.00.00  Creatie
   30-05-2017  A Kluck        01.00.01  Added keep_session_nls
                                              reset_session_nls
                                              set_session_dutch
   14-06-2017  X. Pikaar      01.00.02  Lengte toegevoegd bij numerieke variabelen (n.a.v. Sonar-scan)
   30-06-2017  X. Pikaar      01.00.03  Bewaren en (re-)setten formaat timestamp_tz toegevoegd
   15-08-2017  X. Pikaar      01.00.04  Trace-log voor het (re)setten van nls-zaken verwijderd omdat dit anders heel erg veel dezelfde
                                        logging op kan leveren
   16-01-2018  X. Pikaar      01.01.00  Procedures voor het zetten van de timezone toegevoegd
   25-01-2019  X. Pikaar      01.02.00  Session-timezone keihard op Europe/Amsterdam zetten. In specifieke gevallen kunnen we die
                                        vanuit de programmatuur op UTC zetten
   13-02-2019  X. Pikaar      01.02.01  Session-timezone toch niet keihard op Europe/Amsterdam zetten. Omdat we UTC-tijden weg willen schrijven
                                        in date/timestamp kolommen zonder timezone, willen we b.v. 02:45 op de W/Z overgang wegschrijven
                                        Dat kan niet met de Amsterdam-timezone
   27-05-2019  M. Zuijdendorp 01.02.02  Functie toegevoegd die een UUID in het juiste formaat geeft
   06-06-2019  X. Pikaar      01.02.03  Trace- log verwijderd uit get_session_id, omdat deze gebruikt wordt bij het wegschrijven van de
                                        tijdelijke logging waardoor we in een oneindige loop zouden komen
   08-01-2021  X. Pikaar      01.03.00  Functie is_numeric toegevoegd
   14-02-2022  X. Pikaar      01.04.00  TRAN-5334, functies xml_getclobval en xml_getstringval toegevoegd ter vervangiong van deprecated
                                        xmtype functies getclobval en getstringval
   21-06-2022  Nico KLaver    01.05.00  TRAN-5599 - clob2blob erbij
   18-10-2022  X. Pikaar      01.06.00  get_system_environment toegevoegd
   02-04-2025  Nico KLaver    01.07.00  truncate_table erbij
   16-06-2025  Xander Pikaar  01.08.00  TRAN-7297: functie convert_unit toegevoegd.
   06-08-2025  Nico Klaver    01.09.00  Uitgeklede (geen resolutie) versie van convert_unit toegevoegd. 
   24-10-2025  Xander Pikaar  01.10.00  TRAN-7590: verbeterde functie convert_unit met resolutie. De uitgeklede versie ook behouden omdat
                                        die vanuit EDP_11 en via de REST-service vanuit AVY aangeroepen wordt
  ************************************************************************************************************************************/
  cn_package                 constant varchar2(100) := 'sup_utilities';
  cn_versionnumber           constant varchar2(100) := '01.10.00';

  -- global variables, used to temporary hold (re-)set values
  g_nls_language           varchar2(100);
  g_nls_territory          varchar2(100);
  g_nls_iso_currency       varchar2(100);
  g_nls_numeric_characters varchar2(100);
  g_nls_date_format        varchar2(100);
  g_nls_date_language      varchar2(100);
  g_nls_sort               varchar2(100);
  g_nls_timestamp_tz       varchar2(100);
  g_session_timezone       varchar2(100);

  --

  function get_versionnumber
    return varchar2
  is
    -- return versionnumber
  begin
    return cn_versionnumber;
  end get_versionnumber;

  function get_session_id
    return number
  is
   /**********************************************************************************************************************************
     Purpose    : Haal het Oracle session-id op en zet het in de global SESSION_ID
    **********************************************************************************************************************************/
    cn_module                constant varchar2(100) := cn_package || '.get_session_id';

    v_session_id                      number(10);
  begin
    v_session_id                       := sys_context('USERENV','SESSIONID');

    sup_globals.set_global(p_name         => 'SESSION_ID'
                          ,p_value        => v_session_id);

    return v_session_id;
  exception
    when others then
      raise;
  end get_session_id;

  function get_session_user
    return varchar2
  is
   /**********************************************************************************************************************************
     Purpose    : Haal de os-user op en zet het in de global SESSION_USER. Als geen OS-user gevonden wordt, wordt de database-user
                  gebruikt
    **********************************************************************************************************************************/
    cn_module                constant varchar2(100) := cn_package || '.get_session_user';

    v_session_user                    varchar2(100);
  begin
    v_session_user                     := nvl(sys_context('USERENV','OS_USER'), user);

    sup_globals.set_global(p_name         => 'OS_USER'
                          ,p_value        => v_session_user);

    return v_session_user;
  exception
    when others then
      raise;
  end get_session_user;

  function get_system_environment
    return varchar2
  is
    cn_module                constant varchar2(100) := cn_package || '.get_system_environment';

    v_system_environment              varchar2(100);
    v_database_name                   varchar2(100);
  begin
      select upper(sys_context('userenv','instance_name') || '.' || sys_context('userenv','server_host'))
        into v_database_name
        from dual;

      v_system_environment            := sup_tln_actions.get_translation(p_tln_elm  => 'SYSTEM_ENVIRONMENT'
                                                                        ,p_tln_code => v_database_name);

      return v_system_environment;

  exception

    when others then
      raise;
  end get_system_environment;

  procedure keep_session_nls is
   /**********************************************************************************************************************************
    Purpose    : Procedure for temporarily saving the settings of the current session
                 Use this together with: set_session_dutch and reset_session_nls
   **********************************************************************************************************************************/
    cn_module                constant varchar2(100) := cn_package || '.keep_session_nls';

  begin

    select value into g_nls_language           from v$nls_parameters where parameter = 'NLS_LANGUAGE'          ;
    select value into g_nls_territory          from v$nls_parameters where parameter = 'NLS_TERRITORY'         ;
    select value into g_nls_iso_currency       from v$nls_parameters where parameter = 'NLS_ISO_CURRENCY'      ;
    select value into g_nls_numeric_characters from v$nls_parameters where parameter = 'NLS_NUMERIC_CHARACTERS';
    select value into g_nls_date_format        from v$nls_parameters where parameter = 'NLS_DATE_FORMAT'       ;
    select value into g_nls_date_language      from v$nls_parameters where parameter = 'NLS_DATE_LANGUAGE'     ;
    select value into g_nls_sort               from v$nls_parameters where parameter = 'NLS_SORT'              ;
    keep_session_timezone;

  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;
  end keep_session_nls;
  --
  --
  procedure reset_session_nls is
   /**********************************************************************************************************************************
    Purpose    : Procedure for resetting the temporarily saved settings of the current session
                 Use this together with: keep_session_nls and set_session_dutch
   **********************************************************************************************************************************/
    cn_module                constant varchar2(100) := cn_package || '.reset_session_nls';

    v_stmt clob;
  begin

    -- alleen maar een reset doen als er voorheen ook daadwerkelijk een waarde is bewaard,
    -- anders verval je ongewild naar een default op een hoger niveau
    if (g_nls_language is not null)
    then
      v_stmt := 'alter session set nls_language = ''' || g_nls_language ||''' ';
      execute immediate v_stmt;
    end if;
    if (g_nls_territory is not null)
    then
      v_stmt := 'alter session set nls_territory = ''' || g_nls_territory ||''' ';
      execute immediate v_stmt;
    end if;
    if (g_nls_iso_currency is not null)
    then
      v_stmt := 'alter session set nls_iso_currency = ''' || g_nls_iso_currency || ''' ';
      execute immediate v_stmt;
    end if;
    if (g_nls_numeric_characters is not null)
    then
      v_stmt := 'alter session set nls_numeric_characters = ''' || g_nls_numeric_characters || ''' ';
      execute immediate v_stmt;
    end if;
    if (g_nls_date_format is not null)
    then
      v_stmt := 'alter session set nls_date_format = ''' || g_nls_date_format || ''' ';
      execute immediate v_stmt;
    end if;
    if (g_nls_date_language is not null)
    then
      v_stmt := 'alter session set nls_date_language = ''' || g_nls_date_language || ''' ';
      execute immediate v_stmt;
    end if;
    if (g_nls_sort is not null)
    then
      v_stmt := 'alter session set nls_sort = ''' || g_nls_sort || ''' ';
      execute immediate v_stmt;
    end if;

    reset_session_timezone;

  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;
  end reset_session_nls;
  --
  --
  procedure set_session_dutch is
   /**********************************************************************************************************************************
    Purpose    : Procedure for (temporarily) setting the current session to DUTCH
                 Use this together with: keep_session_nls and reset_session_nls
   **********************************************************************************************************************************/
    cn_module                constant varchar2(100) := cn_package || '.set_session_dutch';

  begin

    execute immediate 'alter session set NLS_LANGUAGE=''DUTCH'' ';
    execute immediate 'alter session set NLS_TERRITORY=''THE NETHERLANDS'' ';
    execute immediate 'alter session set NLS_ISO_CURRENCY=''THE NETHERLANDS'' ';
    execute immediate 'alter session set NLS_NUMERIC_CHARACTERS='',.'' ';
    execute immediate 'alter session set NLS_DATE_FORMAT=''DD-MM-YYYY'' ';
    execute immediate 'alter session set NLS_DATE_LANGUAGE=''DUTCH'' ';
    execute immediate 'alter session set NLS_SORT=''DUTCH'' ';

  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;
  end set_session_dutch;
  --
  procedure set_session_english is
   /**********************************************************************************************************************************
    Purpose    : Procedure for (temporarily) setting the current session to ENGLISH, maar eignelijk een mengelmoesje
                 Use this together with: keep_session_nls and reset_session_nls
   **********************************************************************************************************************************/
    cn_module                constant varchar2(100) := cn_package || '.set_session_english';

  begin
    execute immediate 'alter session set NLS_LANGUAGE=''AMERICAN'' ';
    execute immediate 'alter session set NLS_TERRITORY=''AMERICA'' ';
    execute immediate 'alter session set NLS_ISO_CURRENCY=''THE NETHERLANDS'' ';
    execute immediate 'alter session set NLS_NUMERIC_CHARACTERS=''.,'' ';
    execute immediate 'alter session set NLS_DATE_FORMAT=''DD-MM-YYYY'' ';
    execute immediate 'alter session set NLS_DATE_LANGUAGE=''AMERICAN'' ';
    execute immediate 'alter session set NLS_SORT=''DUTCH'' ';

  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;
  end set_session_english;
  --
  procedure keep_nls_timestamp_tz_format is
   /**********************************************************************************************************************************
    Purpose    : Procedure for temporarily saving the setting of nls_timestamp_tz_format of the current session
                 Use this together with: set_nls_timestamp_tz_formath and reset_nls_timestamp_tz_format
   **********************************************************************************************************************************/
    cn_module                constant varchar2(100) := cn_package || '.keep_nls_timestamp_tz_format';

  begin
    select value into g_nls_timestamp_tz           from v$nls_parameters where parameter = 'NLS_TIMESTAMP_TZ_FORMAT';

  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;
  end keep_nls_timestamp_tz_format;
  --
  --
  procedure reset_nls_timestamp_tz_format is
   /**********************************************************************************************************************************
    Purpose    : Procedure for resetting the temporarily saved settings of nls_timestamp_tz_format of the current session
                 Use this together with: set_nls_timestamp_tz_formath and reset_nls_timestamp_tz_format
   **********************************************************************************************************************************/
    cn_module                constant varchar2(100) := cn_package || '.reset_nls_timestamp_tz_format';

    v_stmt clob;
  begin
    -- alleen maar een reset doen als er voorheen ook daadwerkelijk een waarde is bewaard,
    -- anders verval je ongewild naar een default op een hoger niveau
    if (g_nls_language is not null)
    then
      v_stmt := 'alter session set nls_timestamp_tz_format = ''' || g_nls_timestamp_tz ||''' ';
      execute immediate v_stmt;
    end if;

  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;
  end reset_nls_timestamp_tz_format;
  --
  --
  procedure set_nls_timestamp_tz_format is
   /**********************************************************************************************************************************
    Purpose    : Procedure for (temporarily) setting  of nls_timestamp_tz_format of the current session to "yyyy-mm-dd hh24:mi:ss.fftzh:tzm"
                 Use this together with: keep_nls_timestamp_tz_format and reset_nls_timestamp_tz_format
   **********************************************************************************************************************************/
    cn_module                constant varchar2(100) := cn_package || '.set_nls_timestamp_tz_format';

  begin
    execute immediate 'alter session set nls_timestamp_tz_format = "yyyy-mm-dd hh24:mi:ss.fftzh:tzm"';

  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;
  end set_nls_timestamp_tz_format;

  procedure keep_session_timezone is
   /**********************************************************************************************************************************
    Purpose    : Procedure for temporarily saving the timezone of the current session
                 Use this together with: set_session_timezone and reset_session_timezone
   **********************************************************************************************************************************/
    cn_module                constant varchar2(100) := cn_package || '.keep_session_timezone';

  begin
    select sessiontimezone
      into g_session_timezone
      from dual;

  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;
  end keep_session_timezone;
  --
  --
  procedure reset_session_timezone is
   /**********************************************************************************************************************************
    Purpose    : Procedure for resetting the temporarily saved settings of session timezone of the current session
                 Use this together with: set_session_timezone and reset_session_timezone
   **********************************************************************************************************************************/
    cn_module                constant varchar2(100) := cn_package || '.reset_session_timezone';

    v_stmt clob;
  begin
    -- alleen maar een reset doen als er voorheen ook daadwerkelijk een waarde is bewaard,
    -- anders verval je ongewild naar een default op een hoger niveau
    if (g_session_timezone is not null)
    then
      v_stmt := 'alter session set time_zone = ''' || g_session_timezone ||''' ';
      execute immediate v_stmt;
    end if;

  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;
  end reset_session_timezone;
  --
  --
  procedure set_session_timezone (p_timezone  in varchar2) is
   /**********************************************************************************************************************************
    Purpose    : Procedure for (temporarily) setting  of timezone of the current session
                 Use this together with: keep_session_timezone and reset_session_timezone
   **********************************************************************************************************************************/
    cn_module                constant varchar2(100) := cn_package || '.set_session_timezone';

    v_stmt clob;
  begin
      v_stmt := 'alter session set time_zone = ''' || p_timezone ||''' ';
      execute immediate v_stmt;

  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;
  end set_session_timezone;
  --
  --
  function get_uuid
    return varchar2
  is
  /**********************************************************************************************************************************
   Purpose    : Function to create a universal unique identifier (UUID)
                Format 2dfb13e8-ec58-4aef-905d-e941905e8cfb
  **********************************************************************************************************************************/
    cn_module     constant varchar2(100) := cn_package || '.get_uuid';
    --
    v_guid                 varchar2(100);
  begin
    v_guid := lower(sys_guid());
    return    substr(v_guid,1,8) || '-'
           || substr(v_guid,9,4) || '-'
           || substr(v_guid,13,4) || '-'
           || rpad(substr(v_guid,17,4),4,'0') || '-'
           || rpad(substr(v_guid,21,12),12,'0');
  end get_uuid;

  function is_numeric (p_value       in varchar2)
    return boolean
  is
  /**********************************************************************************************************************************
   Purpose    : Controleer of een waarde numeriek is
  **********************************************************************************************************************************/
    cn_module     constant varchar2(100) := cn_package || '.is_numeric';

    v_number               number(38);
    v_is_numeric           boolean;
  begin
    if length(p_value) > 38 then
      -- langer dan 38, dan kan het geen nummer meer zijn
      v_is_numeric       := false;
    else
      v_number           := p_value;

      -- Als dit gelukt is, is het een nummer
      v_is_numeric       := true;
    end if;

    return v_is_numeric;

  exception
    when value_error then
      v_is_numeric       := false;
      return v_is_numeric;
  end is_numeric;

  function xml_getclobval(p_xml         xmltype)
     return clob
  is
  /**********************************************************************************************************************************
   Purpose    : Zet xmltype om naar clob ter vervanging van de deprecated (want handig, dus gooien we hem weg...) functie xmltype.getClobVal()
  **********************************************************************************************************************************/
    cn_module     constant varchar2(100) := cn_package || '.xml_getclobval';

    v_clob                 clob := empty_clob;
  begin
    if p_xml is null then
       v_clob                   := null;
    else
      select xmlserialize(document p_xml as clob)
        into v_clob
        from dual;
    end if;

    return v_clob;
  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      return null;
  end xml_getclobval;

  function xml_getstringval(p_xml         xmltype)
     return varchar2
  is
  /**********************************************************************************************************************************
   Purpose    : Zet xmltype om naar varcghar2 ter vervanging van de deprecated (want handig, dus gooien we hem weg...) functie xmltype.getStringVal()
                Let op: string mag maximaal 4000 karakters lang zijn!
  **********************************************************************************************************************************/
    cn_module     constant varchar2(100) := cn_package || '.xml_getstringval';

    v_string    varchar2(4000);
  begin
    if p_xml is null then
       v_string                    := null;
    else
      select xmlserialize(document p_xml as varchar2(4000))
        into v_string
        from dual;
    end if;

    return v_string;
  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      return null;
  end xml_getstringval;

  function clob2blob(p_clob in clob)
    return blob
  is
    v_blob blob;
    v_dest_offset pls_integer := 1;
    v_src_offset  pls_integer := 1;
    v_lang_context pls_integer := dbms_lob.default_lang_ctx;
    v_warning      pls_integer := dbms_lob.warn_inconvertible_char;
  begin
    dbms_lob.createtemporary(lob_loc     => v_blob
                            ,cache       => true);

    dbms_lob.converttoblob (dest_lob     => v_blob
                           ,src_clob     => p_clob
                           ,amount       => dbms_lob.lobmaxsize
                           ,dest_offset  => v_dest_offset
                           ,src_offset   => v_src_offset
                           ,blob_csid    => dbms_lob.default_csid
                           ,lang_context => v_lang_context
                           ,warning      => v_warning);
    return v_blob;
  end clob2blob;

  procedure truncate_table(p_table in varchar2)
  is
     v_stmt varchar2(4000);

     pragma autonomous_transaction; -- ff apart houden truncate is een ddl statement (impliciete commit)
  begin
     v_stmt := apex_string.format(p_message => 'truncate table %0', p0 => p_table);
     execute immediate v_stmt;
  exception
     when others then
        rollback;
        raise;
  end truncate_table;

  function convert_unit(p_value_to_convert       in number
                       ,p_unit_from              in varchar2
                       ,p_unit_to                in varchar2
                       ,p_resolution_to          in varchar2
                       )
    return number
  /**********************************************************************************************************************************
   Purpose    : reken vermogen om naar energy en omgekeerd rekening houdend met de tijdsduur (resolutie).
                Dus b.v. kwh met een resolutie PT15M naar MAW
  **********************************************************************************************************************************/
  is
    cn_module     constant varchar2(100) :=  cn_package || '.convert_unit';

    v_return_value             number(30,10);
    v_minutes_from             number(10);
    v_minutes_to               number(10);
    v_computation_unit_from    number(10);
    v_computation_unit_to      number(10);

  begin
    v_minutes_to                  := sup_date_actions.translate_resolution_2_minutes(p_resolution => p_resolution_to  );

    if  upper(substr(p_unit_from, -2)) = 'WH'
    and upper(substr(p_unit_to  , -1)) = 'W' then
        -- Van energie naar vermogen (*WattUur naar *Watt, b.v.MWH naar MAW, maar ook WH naar W)
        -- energy = vermogen gedeeld door de tijd
           v_return_value         := (p_value_to_convert * (60 / v_minutes_to));
    elsif upper(substr(p_unit_from, -1)) = 'W'
    and   upper(substr(p_unit_to  , -2)) = 'WH' then
        -- Van vermogen naar energie, *Watt naar *WattUUr (b.v.MAW naar MWH) is altijd vermogen * tijd (in delen van 1 uur, vandaar altijd delen door 60)
        v_return_value            := (p_value_to_convert * (v_minutes_to  / 60));
    else
        -- Vermogen blijft hetzelfde hetzelfde ongeacht de resolutie
        v_return_value            := p_value_to_convert;
    end if;

    -- Nog een eventuele omrekening van een grotere eenheid naar een kleinere en omgekeerd
    v_computation_unit_from       := case substr(upper(p_unit_from), 1, 1)
                                        when 'G' then 1000000000
                                        when 'M' then 1000000
                                        when 'K' then 1000
                                        else          1
                                     end;

    v_computation_unit_to         := case substr(upper(p_unit_to)  , 1, 1)
                                        when 'G' then 1000000000
                                        when 'M' then 1000000
                                        when 'K' then 1000
                                        else          1
                                     end;

    -- Het delen en vermenigvuldigen zorgt voor de juiste omrekening
    v_return_value                := v_return_value * (v_computation_unit_from / v_computation_unit_to);

    return v_return_value;

  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;
      return null;
  end convert_unit;

  function convert_unit(p_value_to_convert       in number
                       ,p_unit_from              in varchar2
                       ,p_unit_to                in varchar2)
    return number
  /**********************************************************************************************************************************
   Purpose    : Omrekenen van vermogen (G|M|K)W naar (G|M|K)W 
  **********************************************************************************************************************************/
  is
    cn_module     constant varchar2(100) := cn_package || '.convert_unit';

    v_return_value             number(30,10);
    v_computation_unit_from    number(10);
    v_computation_unit_to      number(10);

  begin

    -- Nog een eventuele omrekening van een grotere eenheid naar een kleinere en omgekeerd
    v_computation_unit_from       := case substr(upper(p_unit_from), 1, 1)
                                        when 'G' then 1000000000
                                        when 'M' then 1000000
                                        when 'K' then 1000
                                        when 'W' then 1   
                                     end;

    v_computation_unit_to         := case substr(upper(p_unit_to)  , 1, 1)
                                        when 'G' then 1000000000
                                        when 'M' then 1000000
                                        when 'K' then 1000
                                        when 'W' then 1   
                                     end;

    -- Het delen en vermenigvuldigen zorgt voor de juiste omrekening
    v_return_value                := p_value_to_convert * (v_computation_unit_from / v_computation_unit_to);

    return v_return_value;

  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;
  end convert_unit;

end sup_utilities;
/
