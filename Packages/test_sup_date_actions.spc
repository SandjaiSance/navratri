create or replace package test_sup_date_actions is
  --%suite(test sup_date_actions)

  /*%beforeEach*/
  procedure before_each;

  --%test
  procedure test_get_versionnumber_not_null;

  --%test
  procedure test_convertutc2local_basic;

  --%test
  procedure test_convertutc2local_ts_basic;

  --%test
  procedure test_get_current_utc_timestamp_not_null;

  --%test
  procedure test_get_ptu_from_utc_date_positive;

  --%test
  procedure test_roundtrip_convert_local_utc_around_dst;

  --%test
  procedure test_summer_winter_change_functions;

  --%test
  procedure test_get_utc_timeinterval_by_ptu_boundary;

end test_sup_date_actions;
/