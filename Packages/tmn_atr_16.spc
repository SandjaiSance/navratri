create or replace package tmn_atr_16 is

  function get_versionnumber return varchar2;

  procedure start_publication ( p_message_id               in varchar2
                              , p_runtime_utc              in timestamp default systimestamp at time zone 'UTC' 
                              , p_start_time_utc           in timestamp with time zone default systimestamp at time zone 'UTC'
                              );
 
  procedure fill_expectations ( p_mrid                     in varchar2
                              , p_runtime_utc              in date
                              );

  procedure check_expectations;

  procedure check_expectation_after_ack ( p_mrid           in pcs_tmn_transmissions.mrid%type);

end tmn_atr_16;
/
