create or replace package sup_date_actions
is
  type rt_interval is record (starttime timestamp
                             ,endtime   timestamp);


  type tt_interval is table of rt_interval index by pls_integer;

  function get_versionnumber
    return varchar2;

  function translate_resolution_2_minutes(p_resolution           in varchar2
                                         )
    return number;

  function translate_hours_to_resolution (p_hours  in number)
     return varchar2;    

  function convert_any_date2timestamp_utc(p_text_date in varchar2)
    return timestamp;

  function convertlocal2utc(p_loc_date in timestamp)
    return timestamp;

  function convertutc2local(p_utc_date in timestamp)
     return timestamp;

  function convertutc2local_ts(p_ts_tz in timestamp with time zone )
     return timestamp with time zone;

  function convertlocal2utc_ts(p_ts_tz in timestamp with time zone )
    return timestamp with time zone;

  function date_summerwinterchange(p_year in number)
    return date deterministic;

  function date_wintersummerchange(p_year in number)
    return date deterministic;

  function get_utc_timeinterval_by_ptu(p_utc_datetime        in date       -- For curvetype A01
                                      ,p_interval_in_minutes in number
                                      ,p_ptu                 in number
                                      )
    return rt_interval;

  function get_utc_timeinterval_by_ptu(p_utc_datetime        in date       -- For curvetype A03
                                      ,p_interval_in_minutes in number
                                      ,p_ptu_start           in number
                                      ,p_ptu_eind            in number
                                      )
    return rt_interval;

  function get_utc_startmoment_by_ptu(p_utc_datetime        in date
                                     ,p_interval_in_minutes in number
                                     ,p_ptu                 in number
                                     )
    return timestamp;

  function get_utc_endmoment_by_ptu(p_utc_datetime        in date
                                   ,p_interval_in_minutes in number
                                   ,p_ptu                 in number
                                   )
    return timestamp;

  function get_current_utc_timestamp
    return timestamp;

--  function calculate_winter_summer_date(p_year in number)
--    return date;

--  function calculate_summer_winter_date(p_year in number)
--    return date;

  function get_ptu_from_utc_date(p_utc_time    in date
                                ,p_ptu_length  in number)
    return number;


  function convert_localtimestamp2utcdate(p_timestamp in timestamp)
    return date;

  function convert_utctimestamp2localdate(p_timestamp in timestamp)
    return date;

  function get_position_for_point(p_utc_timestamp_start         timestamp
                                 ,p_utc_position_timestamp_end  timestamp
                                 ,p_resolution                  in varchar2
                                 )
    return number;

  function get_max_position      (p_utc_timestamp_start timestamp
                                 ,p_utc_timestamp_end   timestamp
                                 ,p_resolution          in varchar2
                                 )
    return number;

  function get_first_date_of_week (p_year        in number
                                  ,p_week        in number)
     return date;

  function transform_resolution (p_bvalidity_utc_from in timestamp
                                ,p_resolution_in      in varchar2
                                ,p_resolution_out     in varchar2 default 'PT15M'
                                )
     return tt_interval;

  function get_utc_ptus_between_two_dates (p_date_utc_from    in date
                                          ,p_date_utc_to      in date
                                          ,p_ptu_length_in_minutes in number)
       return tt_utc_timestamps;

  function add_interval_to_timestamp_tz( p_ts_tz        in timestamp with time zone
                                       , p_interval_ym  in interval year to month
                                       , p_interval_ds  in interval day to second
                                       ) 
    return timestamp with time zone;
	
   function get_ptus_between_two_dates (p_date_utc_from         in date
                                       ,p_date_utc_to           in date
                                       ,p_ptu_length_in_minutes in number)
       return number;
  
  function get_hours_between_2_dates (p_date_one_loc    in date
                                     ,p_date_two_loc    in date)
    return number;									 

  function hours2dsinterval( p_hours in number ) 
    return interval day to second;

  function trunc_local
    ( p_date in date
    , p_fmt  in varchar2 default null
    ) 
    return date;

  function trunc_tz
      ( p_date in date
      , p_fmt  in varchar2 default null
      )
      return timestamp with time zone;

  function round_tz
    ( p_date in date
    )
    return timestamp with time zone;

  function day_number(p_date in date) 
    return pls_integer;

  function saturday (p_date in date)
    return date;

  function imbalance_week (p_date in date)    
    return pls_integer;
    
  function imbalance_year (p_date in date)    
    return varchar2;    

  function get_month (p_ts in timestamp) 
    return varchar2 deterministic;

  function get_day_type(p_date in date)
      return varchar2;
      
  function get_previous_workday (p_date in date default sysdate)
      return date;

  function trunc_local_new (p_utc_date in date
                           ,p_fmt      in varchar2 default null)
     return date;
  
  function exec_expression(p_expr in varchar2, p_utc_date_in in date) 
     return date ;    

  procedure correct_period(p_bvalidity_utc_from in out nocopy date, p_bvalidity_utc_to in out nocopy date);

end sup_date_actions;
/
