create or replace package body test_sup_date_actions is
  --%suite

  /*%beforeeach*/
  procedure before_each is
  begin
    null;
  end before_each;

  --%test
  procedure test_get_versionnumber_not_null is
    l_ver varchar2(4000);
  begin
    l_ver := delphidba.sup_date_actions.get_versionnumber;
    ut.expect(l_ver).to_be_not_null;
  end test_get_versionnumber_not_null;

  --%test
  procedure test_convertutc2local_basic is
    l_input timestamp := to_timestamp('2024-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss');
    l_output timestamp;
  begin
    l_output := delphidba.sup_date_actions.convertutc2local(l_input);
    ut.expect(l_output).to_be_not_null;
  end test_convertutc2local_basic;

  --%test
  procedure test_convertutc2local_ts_basic is
    l_input timestamp with time zone := to_timestamp_tz('2024-01-01 00:00:00 +00:00', 'yyyy-mm-dd hh24:mi:ss tzh:tzm');
    l_output timestamp with time zone;
  begin
    l_output := delphidba.sup_date_actions.convertutc2local_ts(l_input);
    ut.expect(l_output).to_be_not_null;
  end test_convertutc2local_ts_basic;

  --%test
  procedure test_get_current_utc_timestamp_not_null is
    l_now timestamp;
  begin
    l_now := delphidba.sup_date_actions.get_current_utc_timestamp;
    ut.expect(l_now).to_be_not_null;
  end test_get_current_utc_timestamp_not_null;

  --%test
  procedure test_get_ptu_from_utc_date_positive is
    l_ptu number;
    l_date date := to_date('2024-01-01', 'yyyy-mm-dd');
  begin
    l_ptu := delphidba.sup_date_actions.get_ptu_from_utc_date(l_date, 60);
    ut.expect(l_ptu).to_be_greater_than(0);
  end test_get_ptu_from_utc_date_positive;

  --%test
  procedure test_roundtrip_convert_local_utc_around_dst is
    l_local timestamp;
    l_utc timestamp;
    l_back timestamp;
    l_norm timestamp;
  begin
    -- winter: cet = utc+1
    l_local := to_timestamp('2024-01-15 12:00:00', 'yyyy-mm-dd hh24:mi:ss');
    l_utc   := delphidba.sup_date_actions.convertlocal2utc(l_local);
    ut.expect(to_char(l_utc, 'yyyy-mm-dd hh24:mi:ss')).to_equal('2024-01-15 11:00:00');
    l_back  := delphidba.sup_date_actions.convertutc2local(l_utc);
    ut.expect(to_char(l_back, 'yyyy-mm-dd hh24:mi:ss')).to_equal('2024-01-15 12:00:00');

    -- summer: cest = utc+2
    l_local := to_timestamp('2024-07-15 12:00:00', 'yyyy-mm-dd hh24:mi:ss');
    l_utc   := delphidba.sup_date_actions.convertlocal2utc(l_local);
    ut.expect(to_char(l_utc, 'yyyy-mm-dd hh24:mi:ss')).to_equal('2024-07-15 10:00:00');
    l_back  := delphidba.sup_date_actions.convertutc2local(l_utc);
    ut.expect(to_char(l_back, 'yyyy-mm-dd hh24:mi:ss')).to_equal('2024-07-15 12:00:00');

    -- dst forward (spring)
    l_local := to_timestamp('2024-03-31 01:30:00', 'yyyy-mm-dd hh24:mi:ss');
    l_utc   := delphidba.sup_date_actions.convertlocal2utc(l_local);
    ut.expect(to_char(l_utc, 'yyyy-mm-dd hh24:mi:ss')).to_equal('2024-03-31 00:30:00');

    l_local := to_timestamp('2024-03-31 03:30:00', 'yyyy-mm-dd hh24:mi:ss');
    l_utc   := delphidba.sup_date_actions.convertlocal2utc(l_local);
    ut.expect(to_char(l_utc, 'yyyy-mm-dd hh24:mi:ss')).to_equal('2024-03-31 01:30:00');

    l_utc  := to_timestamp('2024-03-31 00:30:00', 'yyyy-mm-dd hh24:mi:ss');
    l_back := delphidba.sup_date_actions.convertutc2local(l_utc);
    ut.expect(to_char(l_back, 'yyyy-mm-dd hh24:mi:ss')).to_equal('2024-03-31 01:30:00');

    l_utc  := to_timestamp('2024-03-31 01:30:00', 'yyyy-mm-dd hh24:mi:ss');
    l_back := delphidba.sup_date_actions.convertutc2local(l_utc);
    ut.expect(to_char(l_back, 'yyyy-mm-dd hh24:mi:ss')).to_equal('2024-03-31 03:30:00');

    -- dst backward (fall) - ambiguous times: check idempotence and canonicalization
    l_local := to_timestamp('2024-10-27 01:30:00', 'yyyy-mm-dd hh24:mi:ss');
    l_utc   := delphidba.sup_date_actions.convertlocal2utc(l_local);
    l_norm  := delphidba.sup_date_actions.convertutc2local(l_utc);
    ut.expect(to_char(delphidba.sup_date_actions.convertlocal2utc(l_norm), 'yyyy-mm-dd hh24:mi:ss')).to_equal(to_char(l_utc, 'yyyy-mm-dd hh24:mi:ss'));

    l_local := to_timestamp('2024-10-27 03:30:00', 'yyyy-mm-dd hh24:mi:ss');
    l_utc   := delphidba.sup_date_actions.convertlocal2utc(l_local);
    l_norm  := delphidba.sup_date_actions.convertutc2local(l_utc);
    ut.expect(to_char(delphidba.sup_date_actions.convertlocal2utc(l_norm), 'yyyy-mm-dd hh24:mi:ss')).to_equal(to_char(l_utc, 'yyyy-mm-dd hh24:mi:ss'));

    l_utc  := to_timestamp('2024-10-27 00:30:00', 'yyyy-mm-dd hh24:mi:ss');
    l_back := delphidba.sup_date_actions.convertutc2local(l_utc);
    ut.expect(to_char(delphidba.sup_date_actions.convertlocal2utc(l_back), 'yyyy-mm-dd hh24:mi:ss')).to_equal(to_char(l_utc, 'yyyy-mm-dd hh24:mi:ss'));

    l_utc  := to_timestamp('2024-10-27 02:30:00', 'yyyy-mm-dd hh24:mi:ss');
    l_back := delphidba.sup_date_actions.convertutc2local(l_utc);
    ut.expect(to_char(delphidba.sup_date_actions.convertlocal2utc(l_back), 'yyyy-mm-dd hh24:mi:ss')).to_equal(to_char(l_utc, 'yyyy-mm-dd hh24:mi:ss'));

  exception
    when others then
      ut.fail('exception in test_roundtrip_convert_local_utc_around_dst: ' || sqlerrm);
  end test_roundtrip_convert_local_utc_around_dst;

  --%test
  procedure test_summer_winter_change_functions is
    d1 date;
    d2 date;
    expected1 varchar2(10) := '2024-03-31';
    expected2 varchar2(10) := '2024-10-27';
    e1_2025 varchar2(10) := '2025-03-30';
    e2_2025 varchar2(10) := '2025-10-26';
    a varchar2(10);
    b varchar2(10);
  begin
    d1 := delphidba.sup_date_actions.date_summerwinterchange(2024);
    d2 := delphidba.sup_date_actions.date_wintersummerchange(2024);
    a  := to_char(d1, 'yyyy-mm-dd');
    b  := to_char(d2, 'yyyy-mm-dd');
    ut.expect(a in (expected1, expected2)).to_be_true;
    ut.expect(b in (expected1, expected2)).to_be_true;
    ut.expect(a <> b).to_be_true;

    d1 := delphidba.sup_date_actions.date_summerwinterchange(2025);
    d2 := delphidba.sup_date_actions.date_wintersummerchange(2025);
    a  := to_char(d1, 'yyyy-mm-dd');
    b  := to_char(d2, 'yyyy-mm-dd');
    ut.expect(a in (e1_2025, e2_2025)).to_be_true;
    ut.expect(b in (e1_2025, e2_2025)).to_be_true;
    ut.expect(a <> b).to_be_true;

  exception
    when others then
      ut.fail('exception in test_summer_winter_change_functions: ' || sqlerrm);
  end test_summer_winter_change_functions;

  --%test
  procedure test_get_utc_timeinterval_by_ptu_boundary is
    r sup_date_actions.rt_interval;
    l_date date := to_date('2024-03-31 00:00:00', 'yyyy-mm-dd hh24:mi:ss');
  begin
    r := delphidba.sup_date_actions.get_utc_timeinterval_by_ptu(l_date, 60, 1);
    ut.expect(r.starttime).to_be_not_null;
    ut.expect(r.endtime).to_be_not_null;

    r := delphidba.sup_date_actions.get_utc_timeinterval_by_ptu(l_date, 60, 1, 2);
    ut.expect(r.starttime).to_be_not_null;
    ut.expect(r.endtime).to_be_not_null;
  end test_get_utc_timeinterval_by_ptu_boundary;

end test_sup_date_actions;
/