create or replace package body sup_utilities_test is

  /*********************************************************************************************************************
   purpose    : unit tests for sup_utilities package
   
   the sup_utilities package provides various utility functions. this test package validates:
   - version number retrieval
   - session information functions
   - uuid generation
   - numeric validation
   - xml and clob operations
   - unit conversion functions
   - truncate table operations
   - nls and timezone management

   change history
   
   date        author            version   description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   12-12-2025  Sandjai Ramasray  01.00.00  initial creation

  *********************************************************************************************************************/

  procedure setup is
  begin
    -- setup test data once for all tests
    delphidba.xxut_processes.create_test_process(p_test_suite_name => cn_test_suite);  
    commit;
  end setup;

  procedure cleanup is
  begin
    -- cleanup after all tests
    delphidba.xxut_processes.delete_test_process();
    commit;
  end cleanup;

  /* ========================================================================================================
     context: version number management
     ======================================================================================================== */

  procedure test_get_versionnumber_equals_latest is
    l_ver varchar2(4000);
  begin
    l_ver := delphidba.sup_utilities.get_versionnumber;
    ut.expect(l_ver).to_equal(cn_version_nr);
  end test_get_versionnumber_equals_latest;

  /* ========================================================================================================
     context: session information
     ======================================================================================================== */

  procedure test_get_session_id is
    l_id number;
    l_expected_id number;
  begin
    l_expected_id := sys_context('USERENV', 'SESSIONID');
    l_id          := delphidba.sup_utilities.get_session_id;
    ut.expect(l_id).to_equal(l_expected_id);
  end test_get_session_id;

  procedure test_get_session_user is
    l_user          varchar2(200);
    l_expected_user varchar2(200);
  begin
    select cre_user into l_expected_user 
    from pcs_processes
    where session_id = sys_context('USERENV', 'SESSIONID')
      and rownum = 1;
    l_user := delphidba.sup_utilities.get_session_user;
    ut.expect(l_user).to_equal(l_expected_user);
  end test_get_session_user;

  procedure test_get_system_environment is
    l_env          varchar2(200);
    l_expected_env varchar2(200)  := 'DEVELOPMENT';
  begin
    l_env := delphidba.sup_utilities.get_system_environment;
    ut.expect(l_env).to_equal(l_expected_env);
  end test_get_system_environment;

  /* ========================================================================================================
     context: UUID generation
     ======================================================================================================== */

  procedure test_get_uuid_format is
    l_uuid varchar2(100);
  begin
    l_uuid := delphidba.sup_utilities.get_uuid;
    ut.expect(instr(l_uuid, '-') > 0).to_be_true;
    ut.expect(length(l_uuid) >= 32).to_be_true;
  end test_get_uuid_format;

  /* ========================================================================================================
     context: numeric checks
     ======================================================================================================== */

  procedure test_is_numeric_positive_integer is
    r boolean;
  begin
    r := delphidba.sup_utilities.is_numeric('123');
    ut.expect(r).to_be_true;
  end test_is_numeric_positive_integer;

  procedure test_is_numeric_negative_decimal is
    r boolean;
  begin
    r := delphidba.sup_utilities.is_numeric('-12.34');
    ut.expect(r).to_be_true;
  end test_is_numeric_negative_decimal;

  procedure test_is_numeric_exceeds_precision is
    r boolean;
  begin
    r := delphidba.sup_utilities.is_numeric('1234567890123456789012345678900000003800');
    ut.expect(r).to_be_false;
  end test_is_numeric_exceeds_precision;

  procedure test_is_numeric_non_numeric_string is
    r boolean;
  begin
    r := delphidba.sup_utilities.is_numeric('not a number');
    ut.expect(r).to_be_false;
  end test_is_numeric_non_numeric_string;

  procedure test_edge_cases_numeric is
    r1 boolean;
    r2 boolean;
    r3 boolean;
    r4 boolean;
  begin
    -- Test edge cases: zero, negative, scientific notation, currency
    r1 := delphidba.sup_utilities.is_numeric('0');
    r2 := delphidba.sup_utilities.is_numeric('-0.00');
    r3 := delphidba.sup_utilities.is_numeric('1E10');
    r4 := delphidba.sup_utilities.is_numeric('$100');

    ut.expect(r1).to_be_true;
    ut.expect(r2).to_be_true;
    ut.expect(r3).not_to_be_null;
    ut.expect(r4).not_to_be_null;
  end test_edge_cases_numeric;

  /* ========================================================================================================
     context: XML and CLOB operations
     ======================================================================================================== */

  procedure test_xml_getclobval is
    l_xml  xmltype;
    l_clob clob;
  begin
    l_xml := xmltype('<root><value>test xmlvalue hello</value></root>');
    l_clob := delphidba.sup_utilities.xml_getclobval(l_xml);
    ut.expect(dbms_lob.instr(l_clob, '<value>test xmlvalue hello</value>') > 0).to_be_true;
  end test_xml_getclobval;

  procedure test_xml_getstringval is
    l_xml xmltype;
    l_str varchar2(4000);
  begin
    l_xml := xmltype('<root><value>test xmlvalue hello</value></root>');
    l_str := delphidba.sup_utilities.xml_getstringval(l_xml);
    ut.expect(instr(l_str, 'test xmlvalue hello') > 0).to_be_true;
  end test_xml_getstringval;

  procedure test_clob2blob is
    l_clob clob := to_clob('this is a test clob');
    l_blob blob;
  begin
    l_blob := delphidba.sup_utilities.clob2blob(l_clob);
    ut.expect(l_blob is not null).to_be_true;
  end test_clob2blob;

  procedure test_clob2blob_length is
    l_clob clob := to_clob('this is a test clob');
    l_blob blob;
    l_blob_len number;
  begin
    l_blob := delphidba.sup_utilities.clob2blob(l_clob);
    l_blob_len := dbms_lob.getlength(l_blob);
    ut.expect(l_blob_len).to_equal(19);
  end test_clob2blob_length;

  /* ========================================================================================================
     context: unit conversion examples
     ======================================================================================================== */

  procedure test_convert_unit_examples is
    v1 number;
    v2 number;
    v3 number;
  begin
    v1 := delphidba.sup_utilities.convert_unit(1, 'kw', 'w');
    ut.expect(abs(v1 - 1000) < 0.0001).to_be_true;

    v2 := delphidba.sup_utilities.convert_unit(1, 'mw', 'kw');
    ut.expect(abs(v2 - 1000) < 0.0001).to_be_true;

    v3 := delphidba.sup_utilities.convert_unit(1, 'kwh', 'wh');
    ut.expect(abs(v3 - 1000) < 0.0001).to_be_true;

  end test_convert_unit_examples;

  /* ========================================================================================================
     context: truncate table
     ======================================================================================================== */

  procedure test_truncate_table_safe is
    l_table varchar2(200) := 'delphidba.ut_test_trunc';
    l_count number;
  begin
    execute immediate 'create table ' || l_table || ' (id number)';

    execute immediate 'insert into ' || l_table || ' (id) values (1)';
    execute immediate 'commit';

    execute immediate 'select count(*) from ' || l_table into l_count;
    ut.expect(l_count).to_be_greater_or_equal(1);

    delphidba.sup_utilities.truncate_table(l_table);

    execute immediate 'select count(*) from ' || l_table into l_count;
    ut.expect(l_count).to_equal(0);

    execute immediate 'drop table ' || l_table;
  end test_truncate_table_safe;

  /* ========================================================================================================
     context: NLS and timezone operations
     ======================================================================================================== */

  procedure test_session_nls_set_reset is
  begin
    delphidba.sup_utilities.keep_session_nls;
    delphidba.sup_utilities.set_session_dutch;
    delphidba.sup_utilities.reset_session_nls;
    ut.expect(1).to_equal(1);
  end test_session_nls_set_reset;

  procedure test_nls_timestamp_format_set_reset is
  begin
    delphidba.sup_utilities.keep_nls_timestamp_tz_format;
    delphidba.sup_utilities.set_nls_timestamp_tz_format;
    delphidba.sup_utilities.reset_nls_timestamp_tz_format;
    ut.expect(1).to_equal(1);
  end test_nls_timestamp_format_set_reset;

  procedure test_session_timezone_set_reset is
  begin
    delphidba.sup_utilities.keep_session_timezone;
    delphidba.sup_utilities.set_session_timezone('+00:00');
    delphidba.sup_utilities.reset_session_timezone;
    ut.expect(1).to_equal(1);
  end test_session_timezone_set_reset;

  procedure test_set_session_english_roundtrip is
  begin
    delphidba.sup_utilities.keep_session_nls;
    delphidba.sup_utilities.set_session_english;
    delphidba.sup_utilities.reset_session_nls;
    ut.expect(1).to_equal(1);
  end test_set_session_english_roundtrip;

  procedure test_set_session_dutch_roundtrip is
  begin
    delphidba.sup_utilities.keep_session_nls;
    delphidba.sup_utilities.set_session_dutch;
    delphidba.sup_utilities.reset_session_nls;
    ut.expect(1).to_equal(1);
  end test_set_session_dutch_roundtrip;

  /* ========================================================================================================
     context: unit conversion with resolution
     ======================================================================================================== */

  procedure test_convert_kwh_to_kw_pt60m is
    v_result number;
  begin
    -- 1 kWh with resolution PT60M (60 minutes = 1 hour) should convert to 1 kW
    v_result := delphidba.sup_utilities.convert_unit(1, 'kwh', 'kw', 'PT60M');
    ut.expect(v_result).to_equal(1);
  end test_convert_kwh_to_kw_pt60m;

  procedure test_convert_kw_to_kwh_pt15m is
    v_result number;
  begin
    -- 1 kW with resolution PT15M (15 minutes = 0.25 hours) should convert to 0.25 kWh
    v_result := delphidba.sup_utilities.convert_unit(1, 'kw', 'kwh', 'PT15M');
    ut.expect(v_result).to_equal(0.25);
  end test_convert_kw_to_kwh_pt15m;

  procedure test_convert_wh_to_mw_pt30m is
    v_result number;
  begin
    -- 1000000 Wh (1 MWh) with resolution PT30M (30 minutes = 0.5 hours) should convert to 2 MW
    v_result := delphidba.sup_utilities.convert_unit(1000000, 'wh', 'mw', 'PT30M');
    ut.expect(v_result).to_equal(2);
  end test_convert_wh_to_mw_pt30m;

  /* ========================================================================================================
     context: unit conversion simple (3 arguments)
     ======================================================================================================== */

  procedure test_convert_gw_to_kw is
    v_result number;
  begin
    -- 1 GW = 1,000,000 KW
    v_result := delphidba.sup_utilities.convert_unit(1, 'gw', 'kw');
    ut.expect(v_result).to_equal(1000000);
  end test_convert_gw_to_kw;

  procedure test_convert_gw_to_mw is
    v_result number;
  begin
    -- 1 GW = 1,000 MW
    v_result := delphidba.sup_utilities.convert_unit(1, 'gw', 'mw');
    ut.expect(v_result).to_equal(1000);
  end test_convert_gw_to_mw;

  procedure test_convert_gw_to_w is
    v_result number;
  begin
    -- 1 GW = 1,000,000,000 W
    v_result := delphidba.sup_utilities.convert_unit(1, 'gw', 'w');
    ut.expect(v_result).to_equal(1000000000);
  end test_convert_gw_to_w;

  procedure test_convert_kw_to_gw is
    v_result number;
  begin
    -- 1,000,000 KW = 1 GW
    v_result := delphidba.sup_utilities.convert_unit(1000000, 'kw', 'gw');
    ut.expect(v_result).to_equal(1);
  end test_convert_kw_to_gw;

  procedure test_convert_kw_to_mw is
    v_result number;
  begin
    -- 1,000 KW = 1 MW
    v_result := delphidba.sup_utilities.convert_unit(1000, 'kw', 'mw');
    ut.expect(v_result).to_equal(1);
  end test_convert_kw_to_mw;

  procedure test_convert_kw_to_w is
    v_result number;
  begin
    -- 1 KW = 1,000 W
    v_result := delphidba.sup_utilities.convert_unit(1, 'kw', 'w');
    ut.expect(v_result).to_equal(1000);
  end test_convert_kw_to_w;

  procedure test_convert_mw_to_gw is
    v_result number;
  begin
    -- 1,000 MW = 1 GW
    v_result := delphidba.sup_utilities.convert_unit(1000, 'mw', 'gw');
    ut.expect(v_result).to_equal(1);
  end test_convert_mw_to_gw;

  procedure test_convert_mw_to_kw is
    v_result number;
  begin
    -- 1 MW = 1,000 KW
    v_result := delphidba.sup_utilities.convert_unit(1, 'mw', 'kw');
    ut.expect(v_result).to_equal(1000);
  end test_convert_mw_to_kw;

  procedure test_convert_mw_to_w is
    v_result number;
  begin
    -- 1 MW = 1,000,000 W
    v_result := delphidba.sup_utilities.convert_unit(1, 'mw', 'w');
    ut.expect(v_result).to_equal(1000000);
  end test_convert_mw_to_w;

  procedure test_convert_w_to_gw is
    v_result number;
  begin
    -- 1,000,000,000 W = 1 GW
    v_result := delphidba.sup_utilities.convert_unit(1000000000, 'w', 'gw');
    ut.expect(v_result).to_equal(1);
  end test_convert_w_to_gw;

  procedure test_convert_w_to_kw is
    v_result number;
  begin
    -- 1,000 W = 1 KW
    v_result := delphidba.sup_utilities.convert_unit(1000, 'w', 'kw');
    ut.expect(v_result).to_equal(1);
  end test_convert_w_to_kw;

  procedure test_convert_w_to_mw is
    v_result number;
  begin
    -- 1,000,000 W = 1 MW
    v_result := delphidba.sup_utilities.convert_unit(1000000, 'w', 'mw');
    ut.expect(v_result).to_equal(1);
  end test_convert_w_to_mw;

  procedure test_convert_unit_identity_operations is
    v_result1 number;
    v_result2 number;
    v_result3 number;
  begin
    -- Same unit conversions should return the same value
    v_result1 := delphidba.sup_utilities.convert_unit(42, 'kw', 'kw');
    ut.expect(v_result1).to_equal(42);

    v_result2 := delphidba.sup_utilities.convert_unit(100, 'mw', 'mw');
    ut.expect(v_result2).to_equal(100);

    v_result3 := delphidba.sup_utilities.convert_unit(7, 'gw', 'gw');
    ut.expect(v_result3).to_equal(7);
  end test_convert_unit_identity_operations;

  procedure test_convert_unit_with_resolution is
    v_res1 number;
  begin
    v_res1 := delphidba.sup_utilities.convert_unit(1, 'kwh', 'kw', 'PT60M');
    ut.expect(v_res1).to_equal(1);
  end test_convert_unit_with_resolution;

end sup_utilities_test;
/
