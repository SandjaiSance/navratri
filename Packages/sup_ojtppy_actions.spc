create or replace package sup_ojtppy_actions is
  function get_versionnumber return varchar2;
  
  function check_value_in_domain(p_ojt_code                  in sup_ojt_ppy.ojt_code%type
                                ,p_v_value                   in sup_ojt_ppy.v_value%type
                                ,p_tvalidity_utc_timestamp   in timestamp                 default null
                                ,p_bvalidity_utc_timestamp   in timestamp                 default null
                                ,p_silent_mode               in varchar2                  default 'N'
                                )
     return boolean
     result_cache;

  function get_domain_value(p_ojt_code                       in sup_ojt_ppy.ojt_code%type
                           ,p_ppy_code                       in sup_ojt_ppy.ppy_code%type
                           ,p_tvalidity_utc_timestamp        in timestamp                 default null
                           ,p_bvalidity_utc_timestamp        in timestamp                 default null
                           ,p_silent_mode                    in varchar2                  default 'N' 
                           )
     return varchar2
     result_cache;

  function get_domain_values(p_ojt_code                 in sup_ojt_ppy.ojt_code%type
                            ,p_ppy_code                 in sup_ojt_ppy.ppy_code%type
                            ,p_tvalidity_utc_timestamp  in timestamp                 default null
                            ,p_bvalidity_utc_timestamp  in timestamp                 default null
                            ,p_silent_mode              in varchar2                  default 'N' 
                            ) 
  return apex_t_varchar2
  result_cache;

  function get_domain_property_by_value(p_ojt_code                 in sup_ojt_ppy.ojt_code%type
                                       ,p_value                    in sup_ojt_ppy.v_value%type
                                       ,p_tvalidity_utc_timestamp  in timestamp                 default null
                                       ,p_bvalidity_utc_timestamp  in timestamp                 default null
                                       ,p_silent_mode              in varchar2                  default 'N'
                                       )
    return varchar2
    result_cache;

  function get_domain_value_n(p_ojt_code                       in sup_ojt_ppy.ojt_code%type
                             ,p_ppy_code                       in sup_ojt_ppy.ppy_code%type
                             ,p_tvalidity_utc_timestamp        in timestamp                 default null
                             ,p_bvalidity_utc_timestamp        in timestamp                 default null
                             ,p_silent_mode                    in varchar2                  default 'N'
                             )
     return number
     result_cache;

  function get_domain_value_d(p_ojt_code                       in sup_ojt_ppy.ojt_code%type
                             ,p_ppy_code                       in sup_ojt_ppy.ppy_code%type
                             ,p_tvalidity_utc_timestamp        in timestamp                 default null
                             ,p_bvalidity_utc_timestamp        in timestamp                 default null
                             ,p_silent_mode                    in varchar2                  default 'N' 
                             )
     return date
     result_cache;

  function get_domain_value_t(p_ojt_code                       in sup_ojt_ppy.ojt_code%type
                             ,p_ppy_code                       in sup_ojt_ppy.ppy_code%type
                             ,p_tvalidity_utc_timestamp        in timestamp                 default null
                             ,p_bvalidity_utc_timestamp        in timestamp                 default null
                             ,p_silent_mode                    in varchar2                  default 'N'
                             )
     return timestamp
     result_cache;

end sup_ojtppy_actions;
/
