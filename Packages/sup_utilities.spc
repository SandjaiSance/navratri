create or replace package sup_utilities is
  function get_versionnumber return varchar2;

  function get_session_id return number;

  function get_session_user
    return varchar2;

  function get_system_environment
    return varchar2;

  procedure keep_session_nls;

  procedure reset_session_nls;

  procedure set_session_dutch;

  procedure set_session_english;

  procedure keep_nls_timestamp_tz_format;

  procedure reset_nls_timestamp_tz_format;

  procedure set_nls_timestamp_tz_format;
  
  procedure keep_session_timezone;

  procedure reset_session_timezone;

  procedure set_session_timezone (p_timezone  in varchar2);  

  function get_uuid return varchar2;
  
  function is_numeric (p_value in varchar2) 
     return boolean;

  function xml_getclobval(p_xml         xmltype)
     return clob;
     
  function xml_getstringval(p_xml         xmltype)
     return varchar2;

  function clob2blob(p_clob in clob)
    return blob;

  procedure truncate_table(p_table in varchar2);
  
  function convert_unit(p_value_to_convert       in number
                       ,p_unit_from              in varchar2
                       ,p_unit_to                in varchar2
                       ,p_resolution_to          in varchar2)
    return number;


    function convert_unit(p_value_to_convert       in number
                       ,p_unit_from              in varchar2
                       ,p_unit_to                in varchar2)
    return number; 

end sup_utilities;
/
