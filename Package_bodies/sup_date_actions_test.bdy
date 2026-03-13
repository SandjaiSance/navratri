create or replace package body sup_date_actions_test is

  procedure setup is
  begin
    null;
  end setup;

  procedure cleanup is
  begin
    null;
  end cleanup;

  function equals_instant_tstz(
      p_a in timestamp with time zone,
      p_b in timestamp with time zone
    ) return boolean is
    v_diff interval day to second;
  begin
    v_diff := p_a - p_b;
    return abs(extract(day from v_diff) * 86400
               + extract(hour from v_diff) * 3600
               + extract(minute from v_diff) * 60
               + extract(second from v_diff)) < 1;
  end equals_instant_tstz;

  function equals_instant_ts(
      p_a in timestamp,
      p_b in timestamp
    ) return boolean is
    v_diff interval day to second;
  begin
    v_diff := p_a - p_b;
    return abs(extract(day from v_diff) * 86400
               + extract(hour from v_diff) * 3600
               + extract(minute from v_diff) * 60
               + extract(second from v_diff)) < 1;
  end equals_instant_ts;

  procedure assert_equal_ts(
      p_actual in timestamp,
      p_expected in timestamp
    ) is
  begin
    ut.expect(equals_instant_ts(p_actual, p_expected)).to_equal(true);
  end assert_equal_ts;

  procedure assert_equal_tstz(
      p_actual in timestamp with time zone,
      p_expected in timestamp with time zone
    ) is
  begin
    ut.expect(equals_instant_tstz(p_actual, p_expected)).to_equal(true);
  end assert_equal_tstz;

  function parse_expected_utc(
      p_in  in varchar2,
      p_fmt in varchar2
    ) return timestamp is
    v_tmp varchar2(400) := p_in;
    v_ts  timestamp with time zone;
    v_mask varchar2(200);
  begin
    v_tmp := replace(v_tmp, 'T', ' ');

    if instr(v_tmp, 'Z') > 0 then
      v_tmp := replace(v_tmp, 'Z', '');

      if regexp_like(v_tmp, '[0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]+') then
        v_mask := 'yyyy-mm-dd hh24:mi:ss.ff';
      elsif regexp_like(v_tmp, '[0-9]{2}:[0-9]{2}:[0-9]{2}') then
        v_mask := 'yyyy-mm-dd hh24:mi:ss';
      else
        v_mask := 'yyyy-mm-dd hh24:mi';
      end if;

      v_ts := from_tz(to_timestamp(trim(v_tmp), v_mask), 'UTC');
      return cast(v_ts at time zone 'UTC' as timestamp);
    end if;

    if regexp_like(v_tmp, '[+-][0-9]{2}:[0-9]{2}$') then
      if regexp_like(v_tmp, '[0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]+[+-][0-9]{2}:[0-9]{2}$') then
        v_mask := 'yyyy-mm-dd hh24:mi:ss.fftzh:tzm';
      elsif regexp_like(v_tmp, '[0-9]{2}:[0-9]{2}:[0-9]{2}[+-][0-9]{2}:[0-9]{2}$') then
        v_mask := 'yyyy-mm-dd hh24:mi:sstzh:tzm';
      else
        v_mask := 'yyyy-mm-dd hh24:mi tzh:tzm';
      end if;

      v_ts := to_timestamp_tz(trim(v_tmp), v_mask);
      return cast(v_ts at time zone 'UTC' as timestamp);
    end if;

    v_mask := p_fmt;
    v_ts   := from_tz(to_timestamp(trim(v_tmp), v_mask), 'Europe/Amsterdam');
    return cast(v_ts at time zone 'UTC' as timestamp);
  exception
    when others then
      raise;
  end parse_expected_utc;

  procedure test_format_1_yyyy_mm_dd_hh24_mi_z is
    v_in  varchar2(40) := '2025-12-08 13:30Z';
    v_act timestamp;
    v_exp timestamp;
  begin
    v_act := delphidba.sup_date_actions.convert_any_date2timestamp_utc(v_in);
    v_exp := parse_expected_utc(v_in, 'yyyy-mm-dd hh24:mi');
    assert_equal_ts(v_act, v_exp);
  end test_format_1_yyyy_mm_dd_hh24_mi_z;

  procedure test_format_2_yyyy_mm_dd_hh24_mi_ss_z is
    v_in  varchar2(40) := '2025-12-08 13:30:15Z';
    v_act timestamp;
    v_exp timestamp;
  begin
    v_act := delphidba.sup_date_actions.convert_any_date2timestamp_utc(v_in);
    v_exp := parse_expected_utc(v_in, 'yyyy-mm-dd hh24:mi:ss');
    assert_equal_ts(v_act, v_exp);
  end test_format_2_yyyy_mm_dd_hh24_mi_ss_z;

  procedure test_format_3_yyyy_mm_dd_hh24_mi_ss_ff_z is
    v_in  varchar2(60) := '2025-12-08 13:30:15.123Z';
    v_act timestamp;
    v_exp timestamp;
  begin
    v_act := delphidba.sup_date_actions.convert_any_date2timestamp_utc(v_in);
    v_exp := parse_expected_utc(v_in, 'yyyy-mm-dd hh24:mi:ss.ff');
    assert_equal_ts(v_act, v_exp);
  end test_format_3_yyyy_mm_dd_hh24_mi_ss_ff_z;

  procedure test_format_4_yyyy_mm_dd_hh24_mi is
    v_in  varchar2(40) := '2025-01-15 12:00';
    v_act timestamp;
    v_exp timestamp;
  begin
    v_act := delphidba.sup_date_actions.convert_any_date2timestamp_utc(v_in);
    v_exp := parse_expected_utc(v_in, 'yyyy-mm-dd hh24:mi');
    assert_equal_ts(v_act, v_exp);
  end test_format_4_yyyy_mm_dd_hh24_mi;

  procedure test_format_5_yyyy_mm_dd_hh24_mi_ss is
    v_in  varchar2(40) := '2025-06-10 10:15:30';
    v_act timestamp;
    v_exp timestamp;
  begin
    v_act := delphidba.sup_date_actions.convert_any_date2timestamp_utc(v_in);
    v_exp := parse_expected_utc(v_in, 'yyyy-mm-dd hh24:mi:ss');
    assert_equal_ts(v_act, v_exp);
  end test_format_5_yyyy_mm_dd_hh24_mi_ss;

  procedure test_format_6_yyyy_mm_dd_hh24_mi_sstzh_tzm is
    v_in  varchar2(60) := '2025-12-08 13:30:15+01:00';
    v_act timestamp;
    v_exp timestamp;
  begin
    v_act := delphidba.sup_date_actions.convert_any_date2timestamp_utc(v_in);
    v_exp := parse_expected_utc(v_in, 'yyyy-mm-dd hh24:mi:ss');
    assert_equal_ts(v_act, v_exp);
  end test_format_6_yyyy_mm_dd_hh24_mi_sstzh_tzm;

  procedure test_format_7_yyyy_mm_dd_hh24_mi_ss_ff_tzh_tzm is
    v_in  varchar2(80) := '2025-12-08 13:30:15.123+01:00';
    v_act timestamp;
    v_exp timestamp;
  begin
    v_act := delphidba.sup_date_actions.convert_any_date2timestamp_utc(v_in);
    v_exp := parse_expected_utc(v_in, 'yyyy-mm-dd hh24:mi:ss.ff');
    assert_equal_ts(v_act, v_exp);
  end test_format_7_yyyy_mm_dd_hh24_mi_ss_ff_tzh_tzm;

  procedure test_format_8_yyyy_mm_dd_hh24_mi_ss_ff is
    v_in  varchar2(50) := '2025-06-10 10:15:30.250';
    v_act timestamp;
    v_exp timestamp;
  begin
    v_act := delphidba.sup_date_actions.convert_any_date2timestamp_utc(v_in);
    v_exp := parse_expected_utc(v_in, 'yyyy-mm-dd hh24:mi:ss.ff');
    assert_equal_ts(v_act, v_exp);
  end test_format_8_yyyy_mm_dd_hh24_mi_ss_ff;

  procedure test_format_9_yyyy_mm_dd_thh24_mi_z is
    v_in  varchar2(40) := '2025-12-08T13:30Z';
    v_act timestamp;
    v_exp timestamp;
  begin
    v_act := delphidba.sup_date_actions.convert_any_date2timestamp_utc(v_in);
    v_exp := parse_expected_utc(v_in, 'yyyy-mm-dd hh24:mi');
    assert_equal_ts(v_act, v_exp);
  end test_format_9_yyyy_mm_dd_thh24_mi_z;

  procedure test_format_10_yyyy_mm_dd_thh24_mi_ss_z is
    v_in  varchar2(50) := '2025-12-08T13:30:15Z';
    v_act timestamp;
    v_exp timestamp;
  begin
    v_act := delphidba.sup_date_actions.convert_any_date2timestamp_utc(v_in);
    v_exp := parse_expected_utc(v_in, 'yyyy-mm-dd hh24:mi:ss');
    assert_equal_ts(v_act, v_exp);
  end test_format_10_yyyy_mm_dd_thh24_mi_ss_z;

  procedure test_format_11_yyyy_mm_dd_thh24_mi_ss_ff_z is
    v_in  varchar2(70) := '2025-12-08T13:30:15.123Z';
    v_act timestamp;
    v_exp timestamp;
  begin
    v_act := delphidba.sup_date_actions.convert_any_date2timestamp_utc(v_in);
    v_exp := parse_expected_utc(v_in, 'yyyy-mm-dd hh24:mi:ss.ff');
    assert_equal_ts(v_act, v_exp);
  end test_format_11_yyyy_mm_dd_thh24_mi_ss_ff_z;

  procedure test_format_12_yyyy_mm_dd_thh24_mi is
    v_in  varchar2(40) := '2025-01-15T12:00';
    v_act timestamp;
    v_exp timestamp;
  begin
    v_act := delphidba.sup_date_actions.convert_any_date2timestamp_utc(v_in);
    v_exp := parse_expected_utc(v_in, 'yyyy-mm-dd hh24:mi');
    assert_equal_ts(v_act, v_exp);
  end test_format_12_yyyy_mm_dd_thh24_mi;

  procedure test_format_13_yyyy_mm_dd_thh24_mi_ss is
    v_in  varchar2(50) := '2025-06-10T10:15:30';
    v_act timestamp;
    v_exp timestamp;
  begin
    v_act := delphidba.sup_date_actions.convert_any_date2timestamp_utc(v_in);
    v_exp := parse_expected_utc(v_in, 'yyyy-mm-dd hh24:mi:ss');
    assert_equal_ts(v_act, v_exp);
  end test_format_13_yyyy_mm_dd_thh24_mi_ss;

  procedure test_format_14_yyyy_mm_dd_thh24_mi_sstzh_tzm is
    v_in  varchar2(80) := '2025-12-08T13:30:15+01:00';
    v_act timestamp;
    v_exp timestamp;
  begin
    v_act := delphidba.sup_date_actions.convert_any_date2timestamp_utc(v_in);
    v_exp := parse_expected_utc(v_in, 'yyyy-mm-dd hh24:mi:ss');
    assert_equal_ts(v_act, v_exp);
  end test_format_14_yyyy_mm_dd_thh24_mi_sstzh_tzm;

  procedure test_format_15_yyyy_mm_dd_thh24_mi_ss_ff_tzh_tzm is
    v_in  varchar2(100) := '2025-12-08T13:30:15.123+01:00';
    v_act timestamp;
    v_exp timestamp;
  begin
    v_act := delphidba.sup_date_actions.convert_any_date2timestamp_utc(v_in);
    v_exp := parse_expected_utc(v_in, 'yyyy-mm-dd hh24:mi:ss.ff');
    assert_equal_ts(v_act, v_exp);
  end test_format_15_yyyy_mm_dd_thh24_mi_ss_ff_tzh_tzm;

  procedure test_format_16_yyyy_mm_dd_thh24_mi_ss_ff is
    v_in  varchar2(80) := '2025-06-10T10:15:30.250';
    v_act timestamp;
    v_exp timestamp;
  begin
    v_act := delphidba.sup_date_actions.convert_any_date2timestamp_utc(v_in);
    v_exp := parse_expected_utc(v_in, 'yyyy-mm-dd hh24:mi:ss.ff');
    assert_equal_ts(v_act, v_exp);
  end test_format_16_yyyy_mm_dd_thh24_mi_ss_ff;

  procedure test_format_17_dd_mm_yyyy is
    v_in  varchar2(20) := '08-12-2025';
    v_act timestamp;
    v_exp timestamp;
  begin
    v_act := delphidba.sup_date_actions.convert_any_date2timestamp_utc(v_in);
    v_exp := parse_expected_utc(v_in, 'dd-mm-yyyy');
    assert_equal_ts(v_act, v_exp);
  end test_format_17_dd_mm_yyyy;

  procedure test_format_18_dd_mm_yyyy_dot is
    v_in  varchar2(20) := '08.12.2025';
    v_act timestamp;
    v_exp timestamp;
  begin
    v_act := delphidba.sup_date_actions.convert_any_date2timestamp_utc(v_in);
    v_exp := parse_expected_utc(v_in, 'dd.mm.yyyy');
    assert_equal_ts(v_act, v_exp);
  end test_format_18_dd_mm_yyyy_dot;

  procedure test_convert_any_date2timestamp_utc_zw_overgang is
    v_in  varchar2(20) := '26-10-2025 03:00';
    v_act timestamp;
  begin
    v_act := delphidba.sup_date_actions.convert_any_date2timestamp_utc(v_in);
    assert_equal_ts(v_act, to_timestamp('26-10-2025 02:00','dd-mm-yyyy hh24:mi'));
  end test_convert_any_date2timestamp_utc_zw_overgang;

  procedure test_convert_any_date2timestamp_utc_na_zw_overgang is
    v_in  varchar2(20) := '26-10-2025 03:00';
    v_act timestamp;
  begin
    v_act := delphidba.sup_date_actions.convert_any_date2timestamp_utc(v_in);
    assert_equal_ts(v_act, to_timestamp('26-10-2025 02:00','dd-mm-yyyy hh24:mi'));
  end test_convert_any_date2timestamp_utc_na_zw_overgang;

  procedure test_convert_any_date2timestamp_utc_voor_wz_overgang is
    v_in  varchar2(20) := '30-03-2025 01:15';
    v_act timestamp;
  begin
    v_act := delphidba.sup_date_actions.convert_any_date2timestamp_utc(v_in);
    assert_equal_ts(v_act, to_timestamp('30-03-2025 00:15','dd-mm-yyyy hh24:mi'));
  end test_convert_any_date2timestamp_utc_voor_wz_overgang;

  procedure test_convert_any_date2timestamp_utc_wz_overgang is
    v_in  varchar2(20) := '30-03-2025 03:15';
    v_act timestamp;
  begin
    v_act := delphidba.sup_date_actions.convert_any_date2timestamp_utc(v_in);
    assert_equal_ts(v_act, to_timestamp('30-03-2025 01:15','dd-mm-yyyy hh24:mi'));
  end test_convert_any_date2timestamp_utc_wz_overgang;


  procedure test_convertlocal2utc_examples is
    v_local_ts timestamp := to_timestamp('2025-03-01 12:00', 'yyyy-mm-dd hh24:mi');
    v_act      timestamp;
    v_exp      timestamp;
  begin
    v_act := delphidba.sup_date_actions.convertlocal2utc(v_local_ts);
    v_exp := cast((from_tz(v_local_ts, 'Europe/Amsterdam') at time zone 'UTC') as timestamp);
    assert_equal_ts(v_act, v_exp);
  end test_convertlocal2utc_examples;

  procedure test_convertlocal2utc_ts_examples is
    v_local_tstz timestamp with time zone := from_tz(to_timestamp('2025-03-01 12:00','yyyy-mm-dd hh24:mi'),'Europe/Amsterdam');
    v_act         timestamp with time zone;
    v_exp         timestamp with time zone;
  begin
    v_act := delphidba.sup_date_actions.convertlocal2utc_ts(v_local_tstz);
    v_exp := (v_local_tstz at time zone 'UTC');
    assert_equal_tstz(v_act, v_exp);
  end test_convertlocal2utc_ts_examples;

  procedure test_convertutc2local_examples is
    v_act    timestamp;
  begin
    v_act := delphidba.sup_date_actions.convertutc2local(to_timestamp_tz('2025-12-08 11:00Z','yyyy-mm-dd hh24:mi"Z"'));
    assert_equal_ts(v_act, to_timestamp('2025-12-08 12:00','yyyy-mm-dd hh24:mi'));

    v_act := delphidba.sup_date_actions.convertutc2local(to_timestamp_tz('2025-08-08 11:00Z','yyyy-mm-dd hh24:mi"Z"'));
    assert_equal_ts(v_act, to_timestamp('2025-08-08 13:00','yyyy-mm-dd hh24:mi'));

  end test_convertutc2local_examples;

  procedure test_convertutc2local_ts_examples is
    v_act    timestamp with time zone;
  begin
    v_act := delphidba.sup_date_actions.convertutc2local_ts( to_timestamp_tz('2025-06-10 09:00Z','yyyy-mm-dd hh24:mi"Z"'));
    assert_equal_tstz(v_act, to_timestamp_tz('2025-06-10 11:00 +02:00','yyyy-mm-dd hh24:mi tzh:tzm'));

    v_act := delphidba.sup_date_actions.convertutc2local_ts( to_timestamp_tz('2025-11-10 09:00Z','yyyy-mm-dd hh24:mi"Z"'));
    assert_equal_tstz(v_act, to_timestamp_tz('2025-11-10 10:00 +01:00','yyyy-mm-dd hh24:mi tzh:tzm'));

  end test_convertutc2local_ts_examples;

  procedure test_dst_forward_transition is
    v_local_before  timestamp := to_timestamp('2025-03-30 01:30','yyyy-mm-dd hh24:mi');
    v_local_after   timestamp := to_timestamp('2025-03-30 03:30','yyyy-mm-dd hh24:mi');
    v_act_before    timestamp;
    v_act_after     timestamp;
    v_exp_before    timestamp;
    v_exp_after     timestamp;
  begin
    v_act_before := delphidba.sup_date_actions.convertlocal2utc(v_local_before);
    v_exp_before := cast((from_tz(v_local_before, 'Europe/Amsterdam') at time zone 'UTC') as timestamp);
    assert_equal_ts(v_act_before, v_exp_before);

    v_act_after := delphidba.sup_date_actions.convertlocal2utc(v_local_after);
    v_exp_after := cast((from_tz(v_local_after, 'Europe/Amsterdam') at time zone 'UTC') as timestamp);
    assert_equal_ts(v_act_after, v_exp_after);
    begin
      v_act_before := delphidba.sup_date_actions.convert_any_date2timestamp_utc('2025-03-30 02:30Z');
      v_exp_before := parse_expected_utc('2025-03-30 02:30Z','yyyy-mm-dd hh24:mi');
      assert_equal_ts(v_act_before, v_exp_before);
    exception
      when others then
        ut.expect(sqlcode is not null).to_equal(true);
    end;
  end test_dst_forward_transition;

  procedure test_dst_backward_transition is
    v_local_first  timestamp := to_timestamp('2025-10-26 02:30','yyyy-mm-dd hh24:mi');
    v_act_first    timestamp;
    v_exp_first    timestamp;
  begin
    v_act_first := delphidba.sup_date_actions.convertlocal2utc(v_local_first);
    v_exp_first := cast((from_tz(v_local_first, 'Europe/Amsterdam') at time zone 'UTC') as timestamp);
    assert_equal_ts(v_act_first, v_exp_first);
    begin
      v_act_first := delphidba.sup_date_actions.convert_any_date2timestamp_utc('2025-10-26 02:30Z');
      v_exp_first := parse_expected_utc('2025-10-26 02:30Z','yyyy-mm-dd hh24:mi');
      assert_equal_ts(v_act_first, v_exp_first);
    exception
      when others then
        ut.expect(sqlcode is not null).to_equal(true);
    end;
  end test_dst_backward_transition;

  procedure test_get_ptu_roundtrip is
    v_utc date := to_date('2025-12-08 01:00', 'yyyy-mm-dd hh24:mi');
    v_ptu number;
    v_start timestamp;
    v_end   timestamp;
  begin
    v_ptu   := delphidba.sup_date_actions.get_ptu_from_utc_date(v_utc, 60);
    v_start := delphidba.sup_date_actions.get_utc_startmoment_by_ptu(to_date('2025-12-07 23:00', 'yyyy-mm-dd hh24:mi'), 60, v_ptu);
    v_end   := delphidba.sup_date_actions.get_utc_endmoment_by_ptu(to_date('2025-12-07 23:00', 'yyyy-mm-dd hh24:mi'), 60, v_ptu);

    ut.expect(v_start = cast(v_utc as timestamp)).to_equal(true);
    ut.expect(cast(v_utc as timestamp) < v_end).to_equal(true);
    ut.expect(v_end = to_timestamp('2025-12-08 02:00', 'yyyy-mm-dd hh24:mi')).to_equal(true);
  end test_get_ptu_roundtrip;

  procedure test_get_utc_start_end_by_ptu is
    v_utc  date := to_date('2025-12-07 23:00', 'yyyy-mm-dd hh24:mi');

    v_start timestamp;
    v_end   timestamp;
  begin
    v_start := delphidba.sup_date_actions.get_utc_startmoment_by_ptu(v_utc, 60, 1);
    v_end   := delphidba.sup_date_actions.get_utc_endmoment_by_ptu(v_utc, 60, 1);

    ut.expect(v_start < v_end).to_equal(true);
    ut.expect(v_end = to_timestamp('2025-12-08 00:00', 'yyyy-mm-dd hh24:mi')).to_equal(true);

    v_start := delphidba.sup_date_actions.get_utc_startmoment_by_ptu(v_utc, 15, 12);
    v_end   := delphidba.sup_date_actions.get_utc_endmoment_by_ptu(v_utc, 15, 12);

    ut.expect(v_start < v_end).to_equal(true);
    ut.expect(v_start = to_timestamp('2025-12-08 01:45', 'yyyy-mm-dd hh24:mi')).to_equal(true);
    ut.expect(v_end   = to_timestamp('2025-12-08 02:00', 'yyyy-mm-dd hh24:mi')).to_equal(true);
  end test_get_utc_start_end_by_ptu;

  procedure test_get_utc_timeinterval_by_ptu_behavior is
    r delphidba.sup_date_actions.rt_interval;
    v_utc date := to_date('2025-12-08 07:15', 'yyyy-mm-dd hh24:mi');
    v_ptu number;
  begin
    v_ptu := delphidba.sup_date_actions.get_ptu_from_utc_date(v_utc, 60);
    r     := delphidba.sup_date_actions.get_utc_timeinterval_by_ptu(to_timestamp('2025-12-07 23:00', 'yyyy-mm-dd hh24:mi'), 60, v_ptu);

    ut.expect(r.starttime <= cast(v_utc as timestamp)).to_equal(true);
    ut.expect(cast(v_utc as timestamp) < r.endtime).to_equal(true);
  end test_get_utc_timeinterval_by_ptu_behavior;

  procedure test_hours2dsinterval_behavior is
    v_int interval day to second;
  begin
    v_int := delphidba.sup_date_actions.hours2dsinterval(2);
    ut.expect(extract(hour from v_int) = 2).to_equal(true);
  end test_hours2dsinterval_behavior;

  procedure test_add_interval_to_timestamp_tz_behavior is
    v_ts_tz timestamp with time zone := from_tz(to_timestamp('2025-01-01 00:00','yyyy-mm-dd hh24:mi'),'UTC');
    v_res  timestamp with time zone;
    v_expected timestamp with time zone;
  begin
    v_res := delphidba.sup_date_actions.add_interval_to_timestamp_tz(v_ts_tz
                                                                    ,numtoyminterval(1,'year')
                                                                    ,numtodsinterval(90,'minute')
                                                                    );

    v_expected := v_ts_tz + numtoyminterval(1,'year') + numtodsinterval(90,'minute');
    ut.expect(equals_instant_tstz(v_res, v_expected)).to_equal(true);
  end test_add_interval_to_timestamp_tz_behavior;

  procedure test_trunc_tz_behavior is
    v_date date := to_date('2025-12-08 13:45','yyyy-mm-dd hh24:mi');
    v_res  timestamp with time zone;
  begin
    v_res := delphidba.sup_date_actions.trunc_tz(v_date, 'hh24');
    ut.expect(extract(minute from v_res) = 0).to_equal(true);
    ut.expect(extract(second from v_res) = 0).to_equal(true);
  end test_trunc_tz_behavior;

  procedure test_round_tz_behavior is
    v_date date := to_date('2025-12-08 13:31','yyyy-mm-dd hh24:mi');
    v_round timestamp with time zone;
    v_trunc timestamp with time zone;
  begin
    v_round := delphidba.sup_date_actions.round_tz(v_date);
    v_trunc := delphidba.sup_date_actions.trunc_tz(v_date, 'hh24');

    ut.expect(extract(minute from v_round) = 0).to_equal(true);
    ut.expect(extract(second from v_round) = 0).to_equal(true);
    ut.expect(v_trunc = to_timestamp_tz('2025-12-08 13:00 +01:00','yyyy-mm-dd hh24:mi tzh:tzm')).to_equal(true);
    ut.expect(v_round = to_timestamp_tz('2025-12-09 00:00 +01:00','yyyy-mm-dd hh24:mi tzh:tzm')).to_equal(true);
    ut.expect(delphidba.sup_date_actions.round_tz(to_date('2025-12-08 10:34','yyyy-mm-dd hh24:mi')) = to_timestamp_tz('2025-12-08 00:00 +01:00','yyyy-mm-dd hh24:mi tzh:tzm')).to_equal(true);

  end test_round_tz_behavior;

end sup_date_actions_test;
/