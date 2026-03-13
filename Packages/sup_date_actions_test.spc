create or replace package sup_date_actions_test as
  --%suite

  --%beforeall
  procedure setup;
  
  --%afterall
  procedure cleanup;

  -- format tests
  --%context(test convert_any_date2timestamp_utc)
  
  --%test
  procedure test_format_1_yyyy_mm_dd_hh24_mi_z;
  --%test
  procedure test_format_2_yyyy_mm_dd_hh24_mi_ss_z;
  --%test
  procedure test_format_3_yyyy_mm_dd_hh24_mi_ss_ff_z;
  --%test
  procedure test_format_4_yyyy_mm_dd_hh24_mi;
  --%test
  procedure test_format_5_yyyy_mm_dd_hh24_mi_ss;
  --%test
  procedure test_format_6_yyyy_mm_dd_hh24_mi_sstzh_tzm;
  --%test
  procedure test_format_7_yyyy_mm_dd_hh24_mi_ss_ff_tzh_tzm;
  --%test
  procedure test_format_8_yyyy_mm_dd_hh24_mi_ss_ff;
  --%test
  procedure test_format_9_yyyy_mm_dd_thh24_mi_z;
  --%test
  procedure test_format_10_yyyy_mm_dd_thh24_mi_ss_z;
  --%test
  procedure test_format_11_yyyy_mm_dd_thh24_mi_ss_ff_z;
  --%test
  procedure test_format_12_yyyy_mm_dd_thh24_mi;
  --%test
  procedure test_format_13_yyyy_mm_dd_thh24_mi_ss;
  --%test
  procedure test_format_14_yyyy_mm_dd_thh24_mi_sstzh_tzm;
  --%test
  procedure test_format_15_yyyy_mm_dd_thh24_mi_ss_ff_tzh_tzm;
  --%test
  procedure test_format_16_yyyy_mm_dd_thh24_mi_ss_ff;
  --%test
  procedure test_format_17_dd_mm_yyyy;
  --%test
  procedure test_format_18_dd_mm_yyyy_dot;
  --%test
  procedure test_convert_any_date2timestamp_utc_zw_overgang;
  --%test
  procedure test_convert_any_date2timestamp_utc_na_zw_overgang;
  --%test
  procedure test_convert_any_date2timestamp_utc_voor_wz_overgang;
  --%test
  procedure test_convert_any_date2timestamp_utc_wz_overgang;  

      
  --%endcontext

  --%context(conversion tests)
  
  --%test
  procedure test_convertlocal2utc_examples;
  --%test
  procedure test_convertlocal2utc_ts_examples;
  --%test
  procedure test_convertutc2local_examples;
  --%test
  procedure test_convertutc2local_ts_examples;

  --%endcontext

  --%context(dst tests)
  
  --%test
  procedure test_dst_forward_transition;
  --%test
  procedure test_dst_backward_transition;

  --%endcontext


  --%context(refined functional tests for PTU/UTC & interval/conversion helpers)

  --%test
  procedure test_get_ptu_roundtrip;
  --%test
  procedure test_get_utc_start_end_by_ptu;
  --%test
  procedure test_get_utc_timeinterval_by_ptu_behavior;
  --%test
  procedure test_hours2dsinterval_behavior;
  --%test
  procedure test_add_interval_to_timestamp_tz_behavior;
  --%test
  procedure test_trunc_tz_behavior;
  --%test
  procedure test_round_tz_behavior;
  
  --%endcontext
  


end sup_date_actions_test;
/