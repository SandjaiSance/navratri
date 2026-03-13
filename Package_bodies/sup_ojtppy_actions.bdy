create or replace package body sup_ojtppy_actions is

  /*********************************************************************************************************************
   Purpose    : do all the things for this table

   Change History
   Date        Author            Version   Description
   ----------  ----------------  -------   ------------------------------------------------------------------------------
   06-03-2017  A Kluck           01.00.00  created
   30-05-2017  A Kluck           01.00.01  hernoeming oct_pty -> ojt_ppy
   07-06-2017  X. Pikaar         01.00.02  mode aangegeven bij IN-parameters
                                           "relies on"-clause verwijderd, sinds Oracle 11.2 vervallen omdat dit
                                           automatisch door Oracle geregeld wordt
   16-06-2017  X. Pikaar         01.00.03  variabel v_nu hernoemd naar v_now
   06-10-2017  X. Pikaar         01.01.00  get_domain_property_by_value toegevoegd
   12-01-2018  N. wenting        01.02.00  get_domain_value_n, get_domain_value_d, get_domain_value_t toegevoegd
   07-06-2019  X. Pikaar         01.03.00  Mogelijkheid ingebouwd om in silent_mode te draaien om logging te verminderen
   19-06-2025  Nico Klaver       01.04.00  TRAN-7514: get_domain_values (APEX_T_VARCHAR2) meerdere waarden voor een
                                                      OJT_CODE em PPY_CODE combi   
  **********************************************************************************************************************/
  cn_package            constant varchar2(100) := 'sup_ojtppy_actions';
  cn_versionnumber      constant varchar2(100) := '01.04.00';
  --
  function get_versionnumber
  return varchar2
  is
    -- return versionnumber
  begin
    return cn_versionnumber;
  end get_versionnumber;

  function check_value_in_domain(p_ojt_code                  in sup_ojt_ppy.ojt_code%type
                                ,p_v_value                   in sup_ojt_ppy.v_value%type
                                ,p_tvalidity_utc_timestamp   in timestamp                 default null
                                ,p_bvalidity_utc_timestamp   in timestamp                 default null
                                ,p_silent_mode               in varchar2                  default 'N' 
                                )
   return boolean
   result_cache
  is
    /**********************************************************************************************************************
     Purpose: controleer of een bepaalde objectcode een waarde heeft op een moment in de tijd
     **********************************************************************************************************************/
    cn_module  constant varchar2(100) := cn_package || '.check_value_in_domain';
    --
    cursor c_ojtppy(b_ojt_code                sup_ojt_ppy.ojt_code%type
                   ,b_v_value                 sup_ojt_ppy.v_value%type
                   ,b_tvalidity_utc_timestamp timestamp
                   ,b_bvalidity_utc_timestamp timestamp
                   )
    is
      select 1
      from sup_ojt_ppy ojtppy
      where ojtppy.ojt_code            = b_ojt_code
        and ojtppy.v_value             = b_v_value
        and b_bvalidity_utc_timestamp >= ojtppy.bvalidity_utc_from  -- valid at the time
        and b_bvalidity_utc_timestamp <  ojtppy.bvalidity_utc_to
        and b_tvalidity_utc_timestamp >= ojtppy.tvalidity_utc_from  -- known at the time
        and b_tvalidity_utc_timestamp <  ojtppy.tvalidity_utc_to
    ;
    r_ojtppy                       c_ojtppy%rowtype;
    v_notfound                     boolean;

    v_ojt_code                     sup_ojt_ppy.ojt_code%type;
    v_v_value                      sup_ojt_ppy.v_value%type ;
    v_tvalidity_utc_timestamp      timestamp                ;
    v_bvalidity_utc_timestamp      timestamp                ;

    v_now                          timestamp := systimestamp at time zone 'UTC';
    v_result                       boolean;
  begin
    if upper(p_silent_mode) = 'N' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'Start'
                                 ||chr(10)||' p_ojt_code               : '||        p_ojt_code
                                 ||chr(10)||' p_v_value                : '||        p_v_value
                                 ||chr(10)||' p_tvalidity_utc_timestamp: '||to_char(p_tvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                                 ||chr(10)||' p_bvalidity_utc_timestamp: '||to_char(p_bvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                                 );
    end if;

    v_ojt_code                := p_ojt_code                         ;
    v_v_value                 := p_v_value                          ;
    v_tvalidity_utc_timestamp := nvl(p_tvalidity_utc_timestamp,v_now);
    v_bvalidity_utc_timestamp := nvl(p_bvalidity_utc_timestamp,v_now);

    open c_ojtppy(b_ojt_code                => v_ojt_code
                 ,b_v_value                 => v_v_value
                 ,b_tvalidity_utc_timestamp => v_tvalidity_utc_timestamp
                 ,b_bvalidity_utc_timestamp => v_bvalidity_utc_timestamp
                 );
    fetch c_ojtppy into r_ojtppy;
    v_notfound := c_ojtppy%notfound;
    close c_ojtppy;

    if (v_notfound)
    then
      v_result := FALSE;
    else
      v_result := TRUE;
    end if;

    if upper(p_silent_mode) = 'N' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'End'
                                ||chr(10)||   case when v_result then 'true' else 'false' end
                                );
    end if; 
    return v_result;
  exception
    when others then
      -- als we in een exception knallen gaan we zeker wel loggen. Dan een proces aanmaken als we die nog niet hebben
      if upper(p_silent_mode) = 'Y'
      and sup_globals.get_global_number(p_name => 'PROCESS_ID') is null then
          pcs_pcs_actions.start_process(p_initiating_procedure => cn_module
                                       ,p_legal_owner          => sup_constants.cn_legal_owner_ttn
                                       );
      end if;

      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Parameters'
                                ||chr(10)||' p_ojt_code               : '||        p_ojt_code
                                ||chr(10)||' p_v_value                : '||        p_v_value
                                ||chr(10)||' p_tvalidity_utc_timestamp: '||to_char(p_tvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                                ||chr(10)||' p_bvalidity_utc_timestamp: '||to_char(p_bvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                               );
      raise;
  end check_value_in_domain;
  --
  -- get_domain_value return varchar
  function get_domain_value(p_ojt_code                 in sup_ojt_ppy.ojt_code%type
                           ,p_ppy_code                 in sup_ojt_ppy.ppy_code%type
                           ,p_tvalidity_utc_timestamp  in timestamp                 default null
                           ,p_bvalidity_utc_timestamp  in timestamp                 default null
                           ,p_silent_mode              in varchar2                  default 'N' 
                           )
  return varchar2
  result_cache
  is
    /**********************************************************************************************************************
     Purpose: haal een domainwaarde (object-property) op
     **********************************************************************************************************************/
    cn_module  constant varchar2(100) := cn_package || '.get_domain_value';
    --
    cursor c_ojtppy(b_ojt_code                sup_ojt_ppy.ojt_code%type
                   ,b_ppy_code                sup_ojt_ppy.ppy_code%type
                   ,b_tvalidity_utc_timestamp timestamp
                   ,b_bvalidity_utc_timestamp timestamp
                   )
    is
      select v_value
      from sup_ojt_ppy ojtppy
      where ojtppy.ojt_code            = b_ojt_code
        and ojtppy.ppy_code            = b_ppy_code
        and b_bvalidity_utc_timestamp >= ojtppy.bvalidity_utc_from  -- valid at the time
        and b_bvalidity_utc_timestamp <  ojtppy.bvalidity_utc_to
        and b_tvalidity_utc_timestamp >= ojtppy.tvalidity_utc_from  -- known at the time
        and b_tvalidity_utc_timestamp <  ojtppy.tvalidity_utc_to
    ;
    r_ojtppy                  c_ojtppy%rowtype;

    v_ojt_code                sup_ojt_ppy.ojt_code%type;
    v_ppy_code                sup_ojt_ppy.ppy_code%type;
    v_tvalidity_utc_timestamp timestamp                ;
    v_bvalidity_utc_timestamp timestamp                ;

    v_now                     timestamp                := systimestamp at time zone 'UTC';
    v_result                  sup_ojt_ppy.v_value%type;
  begin
    if upper(p_silent_mode) = 'N' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'Start'
                                ||chr(10)||' p_ojt_code               : '||        p_ojt_code
                                ||chr(10)||' p_ppy_code               : '||        p_ppy_code
                                ||chr(10)||' p_tvalidity_utc_timestamp: '||to_char(p_tvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                                ||chr(10)||' p_bvalidity_utc_timestamp: '||to_char(p_bvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                                );
    end if;

    v_ojt_code                := upper(p_ojt_code)                  ;
    v_ppy_code                := upper(p_ppy_code)                  ;
    v_tvalidity_utc_timestamp := nvl(p_tvalidity_utc_timestamp,v_now);
    v_bvalidity_utc_timestamp := nvl(p_bvalidity_utc_timestamp,v_now);

    open c_ojtppy(b_ojt_code                => v_ojt_code
                 ,b_ppy_code                => v_ppy_code
                 ,b_tvalidity_utc_timestamp => v_tvalidity_utc_timestamp
                 ,b_bvalidity_utc_timestamp => v_bvalidity_utc_timestamp
                 );
    fetch c_ojtppy into r_ojtppy;
    close c_ojtppy;

    v_result := r_ojtppy.v_value;

    if upper(p_silent_mode) = 'N' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'End'
                                ||chr(10)||'  v_result: '||v_result
                                );
    end if; 
    
    return v_result;
  exception
    when others then
      -- als we in een exception knallen gaan we zeker wel loggen. Dan een proces aanmaken als we die nog niet hebben
      if upper(p_silent_mode) = 'Y'
      and sup_globals.get_global_number(p_name => 'PROCESS_ID') is null then
          pcs_pcs_actions.start_process(p_initiating_procedure => cn_module
                                       ,p_legal_owner          => sup_constants.cn_legal_owner_ttn
                                       );
      end if;

      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Parameters'
                                ||chr(10)||' p_ojt_code               : '||        p_ojt_code
                                ||chr(10)||' p_ppy_code               : '||        p_ppy_code
                                ||chr(10)||' p_tvalidity_utc_timestamp: '||to_char(p_tvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                                ||chr(10)||' p_bvalidity_utc_timestamp: '||to_char(p_bvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                               );
      raise;
  end get_domain_value;
  --
  -- get_domain_value return apex_t_varchar2
  function get_domain_values(p_ojt_code                 in sup_ojt_ppy.ojt_code%type
                            ,p_ppy_code                 in sup_ojt_ppy.ppy_code%type
                            ,p_tvalidity_utc_timestamp  in timestamp                 default null
                            ,p_bvalidity_utc_timestamp  in timestamp                 default null
                            ,p_silent_mode              in varchar2                  default 'N' 
                            ) 
  return apex_t_varchar2
  result_cache
  is
    /**********************************************************************************************************************
     Purpose: haal een array domainwaarde (object-property) op
     **********************************************************************************************************************/
    cn_module  constant varchar2(100) := cn_package || '.get_domain_value';
    --
    cursor c_ojtppy(b_ojt_code                sup_ojt_ppy.ojt_code%type
                   ,b_ppy_code                sup_ojt_ppy.ppy_code%type
                   ,b_tvalidity_utc_timestamp timestamp
                   ,b_bvalidity_utc_timestamp timestamp
                   )
    is
      select v_value
      from sup_ojt_ppy ojtppy
      where ojtppy.ojt_code            = b_ojt_code
        and ojtppy.ppy_code            = b_ppy_code
        and b_bvalidity_utc_timestamp >= ojtppy.bvalidity_utc_from  -- valid at the time
        and b_bvalidity_utc_timestamp <  ojtppy.bvalidity_utc_to
        and b_tvalidity_utc_timestamp >= ojtppy.tvalidity_utc_from  -- known at the time
        and b_tvalidity_utc_timestamp <  ojtppy.tvalidity_utc_to
    ;

    v_ojt_code                sup_ojt_ppy.ojt_code%type;
    v_ppy_code                sup_ojt_ppy.ppy_code%type;
    v_tvalidity_utc_timestamp timestamp                ;
    v_bvalidity_utc_timestamp timestamp                ;

    v_now                     timestamp                := systimestamp at time zone 'UTC';
    v_result                  apex_t_varchar2;
  begin
    if upper(p_silent_mode) = 'N' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'Start'
                                ||chr(10)||' p_ojt_code               : '||        p_ojt_code
                                ||chr(10)||' p_ppy_code               : '||        p_ppy_code
                                ||chr(10)||' p_tvalidity_utc_timestamp: '||to_char(p_tvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                                ||chr(10)||' p_bvalidity_utc_timestamp: '||to_char(p_bvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                                );
    end if;

    v_result                  := null;
    v_ojt_code                := upper(p_ojt_code)                  ;
    v_ppy_code                := upper(p_ppy_code)                  ;
    v_tvalidity_utc_timestamp := nvl(p_tvalidity_utc_timestamp,v_now);
    v_bvalidity_utc_timestamp := nvl(p_bvalidity_utc_timestamp,v_now);

    open c_ojtppy(b_ojt_code                => v_ojt_code
                 ,b_ppy_code                => v_ppy_code
                 ,b_tvalidity_utc_timestamp => v_tvalidity_utc_timestamp
                 ,b_bvalidity_utc_timestamp => v_bvalidity_utc_timestamp
                 );
    fetch c_ojtppy bulk collect into v_result;
    close c_ojtppy;

    if upper(p_silent_mode) = 'N' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'End'
                                ||chr(10)||'  v_result: '||substr(apex_string.join(v_result, ':'), 1, 4000)
                                );
    end if; 
    
    return v_result;
  exception
    when others then
      -- als we in een exception knallen gaan we zeker wel loggen. Dan een proces aanmaken als we die nog niet hebben
      if upper(p_silent_mode) = 'Y'
      and sup_globals.get_global_number(p_name => 'PROCESS_ID') is null then
          pcs_pcs_actions.start_process(p_initiating_procedure => cn_module
                                       );
      end if;

      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Parameters'
                                ||chr(10)||' p_ojt_code               : '||        p_ojt_code
                                ||chr(10)||' p_ppy_code               : '||        p_ppy_code
                                ||chr(10)||' p_tvalidity_utc_timestamp: '||to_char(p_tvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                                ||chr(10)||' p_bvalidity_utc_timestamp: '||to_char(p_bvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                               );
      raise;
  end get_domain_values;
  --
  -- get_domain_value return number
  function get_domain_value_n(p_ojt_code                 in sup_ojt_ppy.ojt_code%type
                             ,p_ppy_code                 in sup_ojt_ppy.ppy_code%type
                             ,p_tvalidity_utc_timestamp  in timestamp default null
                             ,p_bvalidity_utc_timestamp  in timestamp default null
                             ,p_silent_mode              in varchar2                  default 'N' 
                             )
  return number
  result_cache
  is
    /**********************************************************************************************************************
     Purpose: haal een domainwaarde (object-property) op
     **********************************************************************************************************************/
    cn_module  constant varchar2(100) := cn_package || '.get_domain_value_n';
    --
    cursor c_ojtppy(b_ojt_code                sup_ojt_ppy.ojt_code%type
                   ,b_ppy_code                sup_ojt_ppy.ppy_code%type
                   ,b_tvalidity_utc_timestamp timestamp
                   ,b_bvalidity_utc_timestamp timestamp
                   )
    is
      select n_value
      from sup_ojt_ppy ojtppy
      where ojtppy.ojt_code            = b_ojt_code
        and ojtppy.ppy_code            = b_ppy_code
        and b_bvalidity_utc_timestamp >= ojtppy.bvalidity_utc_from  -- valid at the time
        and b_bvalidity_utc_timestamp <  ojtppy.bvalidity_utc_to
        and b_tvalidity_utc_timestamp >= ojtppy.tvalidity_utc_from  -- known at the time
        and b_tvalidity_utc_timestamp <  ojtppy.tvalidity_utc_to
    ;
    r_ojtppy                  c_ojtppy%rowtype;

    v_ojt_code                sup_ojt_ppy.ojt_code%type;
    v_ppy_code                sup_ojt_ppy.ppy_code%type;
    v_tvalidity_utc_timestamp timestamp                ;
    v_bvalidity_utc_timestamp timestamp                ;

    v_now                     timestamp                := systimestamp at time zone 'UTC';
    v_result                  sup_ojt_ppy.n_value%type;
  begin
    if upper(p_silent_mode) = 'N' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'Start'
                                 ||chr(10)||' p_ojt_code               : '||        p_ojt_code
                                 ||chr(10)||' p_ppy_code               : '||        p_ppy_code
                                 ||chr(10)||' p_tvalidity_utc_timestamp: '||to_char(p_tvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                                 ||chr(10)||' p_bvalidity_utc_timestamp: '||to_char(p_bvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                                );
    end if;

    v_ojt_code                := upper(p_ojt_code)                  ;
    v_ppy_code                := upper(p_ppy_code)                  ;
    v_tvalidity_utc_timestamp := nvl(p_tvalidity_utc_timestamp,v_now);
    v_bvalidity_utc_timestamp := nvl(p_bvalidity_utc_timestamp,v_now);

    open c_ojtppy(b_ojt_code                => v_ojt_code
                 ,b_ppy_code                => v_ppy_code
                 ,b_tvalidity_utc_timestamp => v_tvalidity_utc_timestamp
                 ,b_bvalidity_utc_timestamp => v_bvalidity_utc_timestamp
                 );
    fetch c_ojtppy into r_ojtppy;
    close c_ojtppy;

    v_result := r_ojtppy.n_value;

    if upper(p_silent_mode) = 'N' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'End'
                                ||chr(10)||'  v_result: '||v_result
                                );
    end if;
    
    return v_result;
  exception
    when others then
      -- als we in een exception knallen gaan we zeker wel loggen. Dan een proces aanmaken als we die nog niet hebben
      if upper(p_silent_mode) = 'Y'
      and sup_globals.get_global_number(p_name => 'PROCESS_ID') is null then
          pcs_pcs_actions.start_process(p_initiating_procedure => cn_module
                                       ,p_legal_owner          => sup_constants.cn_legal_owner_ttn
                                       );
      end if;

      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Parameters'
                                ||chr(10)||' p_ojt_code               : '||        p_ojt_code
                                ||chr(10)||' p_ppy_code               : '||        p_ppy_code
                                ||chr(10)||' p_tvalidity_utc_timestamp: '||to_char(p_tvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                                ||chr(10)||' p_bvalidity_utc_timestamp: '||to_char(p_bvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                               );
      raise;
  end get_domain_value_n;
  --
  -- get_domain_value return date
  function get_domain_value_d(p_ojt_code                 in sup_ojt_ppy.ojt_code%type
                             ,p_ppy_code                 in sup_ojt_ppy.ppy_code%type
                             ,p_tvalidity_utc_timestamp  in timestamp default null
                             ,p_bvalidity_utc_timestamp  in timestamp default null
                             ,p_silent_mode              in varchar2  default 'N' 
                             )
  return date
  result_cache
  is
    /**********************************************************************************************************************
     Purpose: haal een domainwaarde (object-property) op
     **********************************************************************************************************************/
    cn_module  constant varchar2(100) := cn_package || '.get_domain_value_d';
    --
    cursor c_ojtppy(b_ojt_code                sup_ojt_ppy.ojt_code%type
                   ,b_ppy_code                sup_ojt_ppy.ppy_code%type
                   ,b_tvalidity_utc_timestamp timestamp
                   ,b_bvalidity_utc_timestamp timestamp
                   )
    is
      select d_value
      from sup_ojt_ppy ojtppy
      where ojtppy.ojt_code            = b_ojt_code
        and ojtppy.ppy_code            = b_ppy_code
        and b_bvalidity_utc_timestamp >= ojtppy.bvalidity_utc_from  -- valid at the time
        and b_bvalidity_utc_timestamp <  ojtppy.bvalidity_utc_to
        and b_tvalidity_utc_timestamp >= ojtppy.tvalidity_utc_from  -- known at the time
        and b_tvalidity_utc_timestamp <  ojtppy.tvalidity_utc_to
    ;
    r_ojtppy                  c_ojtppy%rowtype;

    v_ojt_code                sup_ojt_ppy.ojt_code%type;
    v_ppy_code                sup_ojt_ppy.ppy_code%type;
    v_tvalidity_utc_timestamp timestamp                ;
    v_bvalidity_utc_timestamp timestamp                ;

    v_now                     timestamp                := systimestamp at time zone 'UTC';
    v_result                  sup_ojt_ppy.d_value%type;
  begin
    if upper(p_silent_mode) = 'N' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'Start'
                                 ||chr(10)||' p_ojt_code               : '||        p_ojt_code
                                 ||chr(10)||' p_ppy_code               : '||        p_ppy_code
                                 ||chr(10)||' p_tvalidity_utc_timestamp: '||to_char(p_tvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                                 ||chr(10)||' p_bvalidity_utc_timestamp: '||to_char(p_bvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                                );
    end if;

    v_ojt_code                := upper(p_ojt_code)                  ;
    v_ppy_code                := upper(p_ppy_code)                  ;
    v_tvalidity_utc_timestamp := nvl(p_tvalidity_utc_timestamp,v_now);
    v_bvalidity_utc_timestamp := nvl(p_bvalidity_utc_timestamp,v_now);

    open c_ojtppy(b_ojt_code                => v_ojt_code
                 ,b_ppy_code                => v_ppy_code
                 ,b_tvalidity_utc_timestamp => v_tvalidity_utc_timestamp
                 ,b_bvalidity_utc_timestamp => v_bvalidity_utc_timestamp
                 );
    fetch c_ojtppy into r_ojtppy;
    close c_ojtppy;

    v_result := r_ojtppy.d_value;

    if upper(p_silent_mode) = 'N' then 
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'End'
                                ||chr(10)||'  v_result: '||v_result
                                );
    end if;
    
    return v_result;
  exception
    when others then
      -- als we in een exception knallen gaan we zeker wel loggen. Dan een proces aanmaken als we die nog niet hebben
      if upper(p_silent_mode) = 'Y'
      and sup_globals.get_global_number(p_name => 'PROCESS_ID') is null then
          pcs_pcs_actions.start_process(p_initiating_procedure => cn_module
                                       ,p_legal_owner          => sup_constants.cn_legal_owner_ttn
                                       );
      end if;

      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Parameters'
                                ||chr(10)||' p_ojt_code               : '||        p_ojt_code
                                ||chr(10)||' p_ppy_code               : '||        p_ppy_code
                                ||chr(10)||' p_tvalidity_utc_timestamp: '||to_char(p_tvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                                ||chr(10)||' p_bvalidity_utc_timestamp: '||to_char(p_bvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                               );
      raise;
  end get_domain_value_d;
  --
  -- get_domain_value return timestamp
  function get_domain_value_t(p_ojt_code                 in sup_ojt_ppy.ojt_code%type
                             ,p_ppy_code                 in sup_ojt_ppy.ppy_code%type
                             ,p_tvalidity_utc_timestamp  in timestamp default null
                             ,p_bvalidity_utc_timestamp  in timestamp default null
                             ,p_silent_mode              in varchar2  default 'N' 
                             )
  return timestamp
  result_cache
  is
    /**********************************************************************************************************************
     Purpose: haal een domainwaarde (object-property) op
     **********************************************************************************************************************/
    cn_module  constant varchar2(100) := cn_package || '.get_domain_value_t';
    --
    cursor c_ojtppy(b_ojt_code                sup_ojt_ppy.ojt_code%type
                   ,b_ppy_code                sup_ojt_ppy.ppy_code%type
                   ,b_tvalidity_utc_timestamp timestamp
                   ,b_bvalidity_utc_timestamp timestamp
                   )
    is
      select t_value
      from sup_ojt_ppy ojtppy
      where ojtppy.ojt_code            = b_ojt_code
        and ojtppy.ppy_code            = b_ppy_code
        and b_bvalidity_utc_timestamp >= ojtppy.bvalidity_utc_from  -- valid at the time
        and b_bvalidity_utc_timestamp <  ojtppy.bvalidity_utc_to
        and b_tvalidity_utc_timestamp >= ojtppy.tvalidity_utc_from  -- known at the time
        and b_tvalidity_utc_timestamp <  ojtppy.tvalidity_utc_to
    ;
    r_ojtppy                  c_ojtppy%rowtype;

    v_ojt_code                sup_ojt_ppy.ojt_code%type;
    v_ppy_code                sup_ojt_ppy.ppy_code%type;
    v_tvalidity_utc_timestamp timestamp                ;
    v_bvalidity_utc_timestamp timestamp                ;

    v_now                     timestamp                := systimestamp at time zone 'UTC';
    v_result                  sup_ojt_ppy.t_value%type;
  begin
    if upper(p_silent_mode) = 'N' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'Start'
                                ||chr(10)||' p_ojt_code               : '||        p_ojt_code
                                ||chr(10)||' p_ppy_code               : '||        p_ppy_code
                                ||chr(10)||' p_tvalidity_utc_timestamp: '||to_char(p_tvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                                ||chr(10)||' p_bvalidity_utc_timestamp: '||to_char(p_bvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                                );
    end if;

    v_ojt_code                := upper(p_ojt_code)                  ;
    v_ppy_code                := upper(p_ppy_code)                  ;
    v_tvalidity_utc_timestamp := nvl(p_tvalidity_utc_timestamp,v_now);
    v_bvalidity_utc_timestamp := nvl(p_bvalidity_utc_timestamp,v_now);

    open c_ojtppy(b_ojt_code                => v_ojt_code
                 ,b_ppy_code                => v_ppy_code
                 ,b_tvalidity_utc_timestamp => v_tvalidity_utc_timestamp
                 ,b_bvalidity_utc_timestamp => v_bvalidity_utc_timestamp
                 );
    fetch c_ojtppy into r_ojtppy;
    close c_ojtppy;

    v_result := r_ojtppy.t_value;

    if upper(p_silent_mode) = 'N' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'End'
                                ||chr(10)||'  v_result: '||v_result
                                );
    end if;
    
    return v_result;
  exception
    when others then
      -- als we in een exception knallen gaan we zeker wel loggen. Dan een proces aanmaken als we die nog niet hebben
      if upper(p_silent_mode) = 'Y'
      and sup_globals.get_global_number(p_name => 'PROCESS_ID') is null then
          pcs_pcs_actions.start_process(p_initiating_procedure => cn_module
                                       ,p_legal_owner          => sup_constants.cn_legal_owner_ttn
                                       );
      end if;

      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Parameters'
                                ||chr(10)||' p_ojt_code               : '||        p_ojt_code
                                ||chr(10)||' p_ppy_code               : '||        p_ppy_code
                                ||chr(10)||' p_tvalidity_utc_timestamp: '||to_char(p_tvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                                ||chr(10)||' p_bvalidity_utc_timestamp: '||to_char(p_bvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                               );
      raise;
  end get_domain_value_t;
  --
  function get_domain_property_by_value(p_ojt_code                 in sup_ojt_ppy.ojt_code%type
                                       ,p_value                    in sup_ojt_ppy.v_value%type
                                       ,p_tvalidity_utc_timestamp  in timestamp                 default null
                                       ,p_bvalidity_utc_timestamp  in timestamp                 default null
                                       ,p_silent_mode              in varchar2                  default 'N' 
                                       )
  return varchar2
  result_cache
  is
    /**********************************************************************************************************************
     Purpose: haal een object_property op die bij een bepaalde waarde hoort. Hierdoor kunnen we een "terugvertaling" doen
              naar de property
     **********************************************************************************************************************/
    cn_module  constant varchar2(100) := cn_package || '.get_domain_property_by_value';
    --
    cursor c_ojtppy(b_ojt_code                sup_ojt_ppy.ojt_code%type
                   ,b_value                   sup_ojt_ppy.v_value%type
                   ,b_tvalidity_utc_timestamp timestamp
                   ,b_bvalidity_utc_timestamp timestamp
                   )
    is
      select ojtppy.ppy_code
      from sup_ojt_ppy ojtppy
      where ojtppy.ojt_code                 = b_ojt_code
        and upper(nvl(ojtppy.v_value,'##')) = nvl(b_value,'##')
        and b_bvalidity_utc_timestamp >= ojtppy.bvalidity_utc_from  -- valid at the time
        and b_bvalidity_utc_timestamp <  ojtppy.bvalidity_utc_to
        and b_tvalidity_utc_timestamp >= ojtppy.tvalidity_utc_from  -- known at the time
        and b_tvalidity_utc_timestamp <  ojtppy.tvalidity_utc_to
    ;
    r_ojtppy                  c_ojtppy%rowtype;

    v_now                     timestamp                := systimestamp at time zone 'UTC';
    v_result                  sup_ojt_ppy.ppy_code%type;
  begin
    if upper(p_silent_mode) = 'N' then 
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'Start'
                                ||chr(10)||' p_ojt_code               : '||        p_ojt_code
                                ||chr(10)||' p_value                  : '||        p_value
                                ||chr(10)||' p_tvalidity_utc_timestamp: '||to_char(p_tvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                                ||chr(10)||' p_bvalidity_utc_timestamp: '||to_char(p_bvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                                );
    end if;

    open c_ojtppy(b_ojt_code                => upper(p_ojt_code)
                 ,b_value                   => upper(p_value)
                 ,b_tvalidity_utc_timestamp => nvl(p_tvalidity_utc_timestamp,v_now)
                 ,b_bvalidity_utc_timestamp => nvl(p_bvalidity_utc_timestamp,v_now)
                 );
    fetch c_ojtppy into r_ojtppy;
    close c_ojtppy;

    v_result := r_ojtppy.ppy_code;

    if upper(p_silent_mode) = 'N' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'End'
                                ||chr(10)||'  v_result: '||v_result
                                );
    end if;
    
    return v_result;
  exception
    when others then
      -- als we in een exception knallen gaan we zeker wel loggen. Dan een proces aanmaken als we die nog niet hebben
      if upper(p_silent_mode) = 'Y'
      and sup_globals.get_global_number(p_name => 'PROCESS_ID') is null then
          pcs_pcs_actions.start_process(p_initiating_procedure => cn_module
                                       ,p_legal_owner          => sup_constants.cn_legal_owner_ttn
                                       );
      end if;

      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Parameters'
                                ||chr(10)||' p_ojt_code               : '||        p_ojt_code
                                ||chr(10)||' p_value                  : '||        p_value
                                ||chr(10)||' p_tvalidity_utc_timestamp: '||to_char(p_tvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                                ||chr(10)||' p_bvalidity_utc_timestamp: '||to_char(p_bvalidity_utc_timestamp,sup_constants.cn_utc_date_format)
                               );
      raise;
  end get_domain_property_by_value;
  --
end sup_ojtppy_actions;
/
