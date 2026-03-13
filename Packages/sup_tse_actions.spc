create or replace package sup_tse_actions
is
  function get_versionnumber return varchar2;

  procedure check_missing_transmissions(p_publication    in varchar2
                                       ,p_current_bvalidity_utc in timestamp
                                       ,p_runtime_utc           in timestamp
                                       );

end sup_tse_actions;
/
