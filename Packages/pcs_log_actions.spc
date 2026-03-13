create or replace package pcs_log_actions is
  function get_versionnumber return varchar2;

  procedure write_log_trace;

  procedure log_debug(p_module          in varchar2
                     ,p_message_code    in varchar2 default sup_constants.cn_msg_code_debug
                     ,p_text            in varchar2 default null
                     );

  procedure log_trace(p_module          in varchar2
                     ,p_message_code    in varchar2 default sup_constants.cn_msg_code_trace
                     ,p_text            in varchar2 default null
                     );

  procedure log_info(p_module           in varchar2
                    ,p_message_code     in varchar2 default sup_constants.cn_msg_code_info
                    ,p_text             in varchar2 default null
                    );

  procedure log_warning(p_module        in varchar2
                       ,p_message_code  in varchar2 default sup_constants.cn_msg_code_warning
                       ,p_text          in varchar2 default null
                       );

  procedure log_error(p_module          in varchar2
                     ,p_message_code    in varchar2 default sup_constants.cn_msg_code_error
                     ,p_text            in varchar2 default null
                     );

  procedure log_fatal(p_module          in varchar2
                     ,p_message_code    in varchar2 default sup_constants.cn_msg_code_fatal
                     ,p_text            in varchar2 default null
                     );

  procedure log_global (p_module       in varchar2
                       ,p_text         in varchar2 default null
                       );

-- OVERLOADED
--
  procedure log_debug(p_module          in varchar2
                     ,p_message_code    in varchar2
                     ,p_subst1          in varchar2 default null
                     ,p_subst2          in varchar2 default null
                     ,p_subst3          in varchar2 default null
                     ,p_subst4          in varchar2 default null
                     ,p_subst5          in varchar2 default null
                     ,p_subst6          in varchar2 default null
                     ,p_subst7          in varchar2 default null
                     ,p_subst8          in varchar2 default null
                     ,p_subst9          in varchar2 default null
                     );

  procedure log_trace(p_module          in varchar2
                     ,p_message_code    in varchar2
                     ,p_subst1          in varchar2 default null
                     ,p_subst2          in varchar2 default null
                     ,p_subst3          in varchar2 default null
                     ,p_subst4          in varchar2 default null
                     ,p_subst5          in varchar2 default null
                     ,p_subst6          in varchar2 default null
                     ,p_subst7          in varchar2 default null
                     ,p_subst8          in varchar2 default null
                     ,p_subst9          in varchar2 default null
                     );

  procedure log_info (p_module          in varchar2
                     ,p_message_code    in varchar2
                     ,p_subst1          in varchar2 default null
                     ,p_subst2          in varchar2 default null
                     ,p_subst3          in varchar2 default null
                     ,p_subst4          in varchar2 default null
                     ,p_subst5          in varchar2 default null
                     ,p_subst6          in varchar2 default null
                     ,p_subst7          in varchar2 default null
                     ,p_subst8          in varchar2 default null
                     ,p_subst9          in varchar2 default null
                     );

  procedure log_warning(p_module        in varchar2
                       ,p_message_code  in varchar2
                       ,p_subst1        in varchar2 default null
                       ,p_subst2        in varchar2 default null
                       ,p_subst3        in varchar2 default null
                       ,p_subst4        in varchar2 default null
                       ,p_subst5        in varchar2 default null
                       ,p_subst6        in varchar2 default null
                       ,p_subst7        in varchar2 default null
                       ,p_subst8        in varchar2 default null
                       ,p_subst9        in varchar2 default null
                       );

  procedure log_error  (p_module        in varchar2
                       ,p_message_code  in varchar2
                       ,p_subst1        in varchar2 default null
                       ,p_subst2        in varchar2 default null
                       ,p_subst3        in varchar2 default null
                       ,p_subst4        in varchar2 default null
                       ,p_subst5        in varchar2 default null
                       ,p_subst6        in varchar2 default null
                       ,p_subst7        in varchar2 default null
                       ,p_subst8        in varchar2 default null
                       ,p_subst9        in varchar2 default null
                     );

  procedure log_fatal  (p_module        in varchar2
                       ,p_message_code  in varchar2
                       ,p_subst1        in varchar2 default null
                       ,p_subst2        in varchar2 default null
                       ,p_subst3        in varchar2 default null
                       ,p_subst4        in varchar2 default null
                       ,p_subst5        in varchar2 default null
                       ,p_subst6        in varchar2 default null
                       ,p_subst7        in varchar2 default null
                       ,p_subst8        in varchar2 default null
                       ,p_subst9        in varchar2 default null
                     );

end pcs_log_actions;
/
