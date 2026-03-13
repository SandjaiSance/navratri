create or replace package body sup_ojtppy_actions_test is

  /*********************************************************************************************************************
   purpose    : unit tests for sup_ojtppy_actions package
   
   the sup_ojtppy_actions package provides object property management functionality. this test package validates:
   - version number retrieval
   - domain value validation (check if value exists in domain)
   - domain value retrieval (varchar2, number, date, timestamp)
   - domain values retrieval (array of varchar2)
   - reverse lookup (get property code by value)
   - cache behavior and consistency
   - error handling for invalid inputs

   change history
   
   date        author            version   description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   11-12-2024  Mirjam Buuts      01.00.00  initial creation

  *********************************************************************************************************************/

  -- test data constants
  gc_test_ojt_code_1    constant varchar2(100) := 'TEST_OJT_CODE_1';
  gc_test_ojt_code_2    constant varchar2(100) := 'TEST_OJT_CODE_2';
  gc_test_ojt_code_3    constant varchar2(100) := 'TEST_OJT_CODE_3';
  gc_test_ppy_code_1    constant varchar2(100) := 'TEST_PPY_1';
  gc_test_ppy_code_2    constant varchar2(100) := 'TEST_PPY_2';
  gc_test_ppy_code_3    constant varchar2(100) := 'TEST_PPY_3';
  gc_test_value_1       constant varchar2(100) := 'TEST_VALUE_1';
  gc_test_value_2       constant varchar2(100) := 'TEST_VALUE_2';
  gc_test_value_3       constant varchar2(100) := 'TEST_VALUE_3';
  gc_test_number        constant number        := 12345;
  gc_test_date          constant date          := to_date('01-01-2024', 'DD-MM-YYYY');

  gd_test_timestamp     timestamp := to_timestamp('01-01-2024 12:00:00', 'DD-MM-YYYY HH24:MI:SS');
  gd_validity_from      timestamp := to_timestamp('01-01-2000', 'DD-MM-YYYY');
  gd_validity_to        timestamp := to_timestamp('31-12-2099', 'DD-MM-YYYY');

  procedure setup is
  begin
    -- setup test data once for all tests
    -- clear any existing test data
    delete from delphidba.sup_ojt_ppy
    where ojt_code in (gc_test_ojt_code_1, gc_test_ojt_code_2, gc_test_ojt_code_3);

    -- insert test data for varchar2 value tests
    insert into delphidba.sup_ojt_ppy 
      (ojt_code, ppy_code, v_value, bvalidity_utc_from, bvalidity_utc_to, tvalidity_utc_from, tvalidity_utc_to)
    values 
      (gc_test_ojt_code_1, gc_test_ppy_code_1, gc_test_value_1, gd_validity_from, gd_validity_to, gd_validity_from, gd_validity_to);

    insert into delphidba.sup_ojt_ppy 
      (ojt_code, ppy_code, v_value, bvalidity_utc_from, bvalidity_utc_to, tvalidity_utc_from, tvalidity_utc_to)
    values 
      (gc_test_ojt_code_1, gc_test_ppy_code_2, gc_test_value_2, gd_validity_from, gd_validity_to, gd_validity_from, gd_validity_to);

    -- insert test data for multiple values (same ojt_code and ppy_code)
    insert into delphidba.sup_ojt_ppy 
      (ojt_code, ppy_code, v_value, bvalidity_utc_from, bvalidity_utc_to, tvalidity_utc_from, tvalidity_utc_to)
    values 
      (gc_test_ojt_code_2, gc_test_ppy_code_1, gc_test_value_1, gd_validity_from, gd_validity_to, gd_validity_from, gd_validity_to);

    insert into delphidba.sup_ojt_ppy 
      (ojt_code, ppy_code, v_value, bvalidity_utc_from, bvalidity_utc_to, tvalidity_utc_from, tvalidity_utc_to)
    values 
      (gc_test_ojt_code_2, gc_test_ppy_code_1, gc_test_value_2, gd_validity_from, gd_validity_to, gd_validity_from, gd_validity_to);

    insert into delphidba.sup_ojt_ppy 
      (ojt_code, ppy_code, v_value, bvalidity_utc_from, bvalidity_utc_to, tvalidity_utc_from, tvalidity_utc_to)
    values 
      (gc_test_ojt_code_2, gc_test_ppy_code_1, gc_test_value_3, gd_validity_from, gd_validity_to, gd_validity_from, gd_validity_to);

    -- insert test data for number value tests
    insert into delphidba.sup_ojt_ppy 
      (ojt_code, ppy_code, n_value, bvalidity_utc_from, bvalidity_utc_to, tvalidity_utc_from, tvalidity_utc_to)
    values 
      (gc_test_ojt_code_1, gc_test_ppy_code_3, gc_test_number, gd_validity_from, gd_validity_to, gd_validity_from, gd_validity_to);

    -- insert test data for date value tests
    insert into delphidba.sup_ojt_ppy 
      (ojt_code, ppy_code, d_value, bvalidity_utc_from, bvalidity_utc_to, tvalidity_utc_from, tvalidity_utc_to)
    values 
      (gc_test_ojt_code_2, gc_test_ppy_code_2, gc_test_date, gd_validity_from, gd_validity_to, gd_validity_from, gd_validity_to);

    -- insert test data for timestamp value tests
    insert into delphidba.sup_ojt_ppy 
      (ojt_code, ppy_code, t_value, bvalidity_utc_from, bvalidity_utc_to, tvalidity_utc_from, tvalidity_utc_to)
    values 
      (gc_test_ojt_code_2, gc_test_ppy_code_3, gd_test_timestamp, gd_validity_from, gd_validity_to, gd_validity_from, gd_validity_to);

    -- insert test data for gc_test_ojt_code_3 with all v_values filled (for null value test)
    insert into delphidba.sup_ojt_ppy 
      (ojt_code, ppy_code, v_value, bvalidity_utc_from, bvalidity_utc_to, tvalidity_utc_from, tvalidity_utc_to)
    values 
      (gc_test_ojt_code_3, gc_test_ppy_code_1, 'FILLED_VALUE_1', gd_validity_from, gd_validity_to, gd_validity_from, gd_validity_to);

    insert into delphidba.sup_ojt_ppy 
      (ojt_code, ppy_code, v_value, bvalidity_utc_from, bvalidity_utc_to, tvalidity_utc_from, tvalidity_utc_to)
    values 
      (gc_test_ojt_code_3, gc_test_ppy_code_2, 'FILLED_VALUE_2', gd_validity_from, gd_validity_to, gd_validity_from, gd_validity_to);
   
    delphidba.xxut_processes.create_test_process(p_test_suite_name => cn_test_suite);  
    commit;
  end setup;

  procedure cleanup is
  begin
    -- cleanup test data after all tests
    delete from delphidba.sup_ojt_ppy
    where ojt_code in (gc_test_ojt_code_1, gc_test_ojt_code_2, gc_test_ojt_code_3);
    
    delphidba.xxut_processes.delete_test_process();
    commit;
  end cleanup;

  /* ========================================================================================================
     context: version number management
     ======================================================================================================== */

  procedure check_versionnumber_equals_latest is
    l_ver varchar2(4000);
  begin
    l_ver := delphidba.sup_utilities.get_versionnumber;
    -- exact version asserted
    ut.expect(l_ver).to_equal(cn_version_nr);
  end check_versionnumber_equals_latest;

  /* ========================================================================================================
     context: domain value validation
     ======================================================================================================== */

  procedure check_value_valid is
    l_result boolean;
  begin
    l_result := delphidba.sup_ojtppy_actions.check_value_in_domain(
      p_ojt_code               => gc_test_ojt_code_1,
      p_v_value                => gc_test_value_1,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'Y'
    );
    ut.expect(case when l_result then 'TRUE' else 'FALSE' end).to_equal('TRUE');
  end check_value_valid;

  procedure check_value_invalid is
    l_result boolean;
  begin
    l_result := delphidba.sup_ojtppy_actions.check_value_in_domain(
      p_ojt_code               => gc_test_ojt_code_1,
      p_v_value                => 'NONEXISTENT_VALUE',
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'N'
    );
    ut.expect(case when l_result then 'TRUE' else 'FALSE' end).to_equal('FALSE');
  end check_value_invalid;

  procedure check_value_null_ojt_code is
    l_result boolean;
  begin
    l_result := delphidba.sup_ojtppy_actions.check_value_in_domain(
      p_ojt_code               => null,
      p_v_value                => gc_test_value_1,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'Y'
    );
    ut.expect(case when l_result then 'TRUE' else 'FALSE' end).to_equal('FALSE');
  end check_value_null_ojt_code;

  procedure check_value_bvalidity_within is
    l_result boolean;
    l_timestamp timestamp;
  begin
    -- use a timestamp within validity range (2024 is between 2000 and 2099)
    l_timestamp := to_timestamp('01-01-2024 12:00:00', 'DD-MM-YYYY HH24:MI:SS');

    l_result := delphidba.sup_ojtppy_actions.check_value_in_domain(
      p_ojt_code               => gc_test_ojt_code_1,
      p_v_value                => gc_test_value_1,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => l_timestamp,
      p_silent_mode            => 'N'
    );
    ut.expect(case when l_result then 'TRUE' else 'FALSE' end).to_equal('TRUE');
  end check_value_bvalidity_within;

  procedure check_value_bvalidity_outside is
    l_result boolean;
    l_timestamp timestamp;
  begin
    -- use a timestamp outside validity range (1999 is before 2000)
    l_timestamp := to_timestamp('01-01-1999 12:00:00', 'DD-MM-YYYY HH24:MI:SS');

    l_result := delphidba.sup_ojtppy_actions.check_value_in_domain(
      p_ojt_code               => gc_test_ojt_code_1,
      p_v_value                => gc_test_value_1,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => l_timestamp,
      p_silent_mode            => 'Y'
    );
    ut.expect(case when l_result then 'TRUE' else 'FALSE' end).to_equal('FALSE');
  end check_value_bvalidity_outside;

  /* ========================================================================================================
     context: get domain value (varchar2)
     ======================================================================================================== */

  procedure get_domain_value_basic is
    l_value varchar2(4000);
  begin
    l_value := delphidba.sup_ojtppy_actions.get_domain_value(
      p_ojt_code               => gc_test_ojt_code_1,
      p_ppy_code               => gc_test_ppy_code_1,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'N'
    );
    ut.expect(l_value).to_equal(gc_test_value_1);
  end get_domain_value_basic;

  procedure get_domain_value_non_existent_ojt is
    l_value varchar2(4000);
  begin
    l_value := delphidba.sup_ojtppy_actions.get_domain_value(
      p_ojt_code               => 'NONEXISTENT_OJT',
      p_ppy_code               => gc_test_ppy_code_1,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'Y'
    );
    ut.expect(l_value).to_be_null;
  end get_domain_value_non_existent_ojt;

  procedure get_domain_value_non_existent_ppy is
    l_value varchar2(4000);
  begin
    l_value := delphidba.sup_ojtppy_actions.get_domain_value(
      p_ojt_code               => gc_test_ojt_code_1,
      p_ppy_code               => 'NONEXISTENT_PPY',
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'N'
    );
    ut.expect(l_value).to_be_null;
  end get_domain_value_non_existent_ppy;

  procedure get_domain_value_null_ppy is
    l_value varchar2(4000);
  begin
    l_value := delphidba.sup_ojtppy_actions.get_domain_value(
      p_ojt_code               => gc_test_ojt_code_1,
      p_ppy_code               => null,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'Y'
    );
    ut.expect(l_value).to_be_null;
  end get_domain_value_null_ppy;

  procedure get_domain_value_bvalidity_within is
    l_value varchar2(4000);
    l_timestamp timestamp;
  begin
    -- use a timestamp within validity range
    l_timestamp := to_timestamp('01-01-2024 12:00:00', 'DD-MM-YYYY HH24:MI:SS');

    l_value := delphidba.sup_ojtppy_actions.get_domain_value(
      p_ojt_code               => gc_test_ojt_code_1,
      p_ppy_code               => gc_test_ppy_code_1,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => l_timestamp,
      p_silent_mode            => 'N'
    );
    ut.expect(l_value).to_equal(gc_test_value_1);
  end get_domain_value_bvalidity_within;

  procedure get_domain_value_bvalidity_outside is
    l_value varchar2(4000);
    l_timestamp timestamp;
  begin
    -- use a timestamp outside validity range
    l_timestamp := to_timestamp('01-01-1999 12:00:00', 'DD-MM-YYYY HH24:MI:SS');

    l_value := delphidba.sup_ojtppy_actions.get_domain_value(
      p_ojt_code               => gc_test_ojt_code_1,
      p_ppy_code               => gc_test_ppy_code_1,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => l_timestamp,
      p_silent_mode            => 'Y'
    );
    ut.expect(l_value).to_be_null;
  end get_domain_value_bvalidity_outside;

  /* ========================================================================================================
     context: get domain values (array - apex_t_varchar2)
     ======================================================================================================== */

  procedure get_domain_values_multiple is
    l_values apex_t_varchar2;
  begin
    l_values := delphidba.sup_ojtppy_actions.get_domain_values(
      p_ojt_code               => gc_test_ojt_code_2,
      p_ppy_code               => gc_test_ppy_code_1,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'N'
    );
    ut.expect(l_values.count).to_equal(3);
  end get_domain_values_multiple;

  procedure get_domain_values_empty is
    l_values apex_t_varchar2;
  begin
    l_values := delphidba.sup_ojtppy_actions.get_domain_values(
      p_ojt_code               => 'NONEXISTENT_OJT',
      p_ppy_code               => gc_test_ppy_code_1,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'Y'
    );
    ut.expect(l_values.count).to_equal(0);
  end get_domain_values_empty;

  procedure get_domain_values_single is
    l_values apex_t_varchar2;
  begin
    l_values := delphidba.sup_ojtppy_actions.get_domain_values(
      p_ojt_code               => gc_test_ojt_code_1,
      p_ppy_code               => gc_test_ppy_code_1,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'Y'
    );
    ut.expect(l_values.count).to_equal(1);
    ut.expect(l_values(1)).to_equal(gc_test_value_1);
  end get_domain_values_single;

  procedure get_domain_values_bvalidity_within is
    l_values apex_t_varchar2;
    l_timestamp timestamp;
  begin
    -- use a timestamp within validity range
    l_timestamp := to_timestamp('01-01-2024 12:00:00', 'DD-MM-YYYY HH24:MI:SS');

    l_values := delphidba.sup_ojtppy_actions.get_domain_values(
      p_ojt_code               => gc_test_ojt_code_2,
      p_ppy_code               => gc_test_ppy_code_1,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => l_timestamp,
      p_silent_mode            => 'N'
    );
    ut.expect(l_values.count).to_equal(3);
  end get_domain_values_bvalidity_within;

  procedure get_domain_values_bvalidity_outside is
    l_values apex_t_varchar2;
    l_timestamp timestamp;
  begin
    -- use a timestamp outside validity range
    l_timestamp := to_timestamp('01-01-1999 12:00:00', 'DD-MM-YYYY HH24:MI:SS');

    l_values := delphidba.sup_ojtppy_actions.get_domain_values(
      p_ojt_code               => gc_test_ojt_code_2,
      p_ppy_code               => gc_test_ppy_code_1,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => l_timestamp,
      p_silent_mode            => 'Y'
    );
    ut.expect(l_values.count).to_equal(0);
  end get_domain_values_bvalidity_outside;

  /* ========================================================================================================
     context: get domain value (number)
     ======================================================================================================== */

  procedure get_domain_value_n_basic is
    l_value number;
  begin
    l_value := delphidba.sup_ojtppy_actions.get_domain_value_n(
      p_ojt_code               => gc_test_ojt_code_1,
      p_ppy_code               => gc_test_ppy_code_3,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'Y'
    );
    ut.expect(l_value).to_equal(gc_test_number);
  end get_domain_value_n_basic;

  procedure get_domain_value_n_non_existent is
    l_value number;
  begin
    l_value := delphidba.sup_ojtppy_actions.get_domain_value_n(
      p_ojt_code               => 'NONEXISTENT_OJT',
      p_ppy_code               => gc_test_ppy_code_3,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'Y'
    );
    ut.expect(l_value).to_be_null;
  end get_domain_value_n_non_existent;

  procedure get_domain_value_n_bvalidity_within is
    l_value number;
    l_timestamp timestamp;
  begin
    -- use a timestamp within validity range
    l_timestamp := to_timestamp('01-01-2024 12:00:00', 'DD-MM-YYYY HH24:MI:SS');

    l_value := delphidba.sup_ojtppy_actions.get_domain_value_n(
      p_ojt_code               => gc_test_ojt_code_1,
      p_ppy_code               => gc_test_ppy_code_3,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => l_timestamp,
      p_silent_mode            => 'Y'
    );
    ut.expect(l_value).to_equal(gc_test_number);
  end get_domain_value_n_bvalidity_within;

  procedure get_domain_value_n_bvalidity_outside is
    l_value number;
    l_timestamp timestamp;
  begin
    -- use a timestamp outside validity range
    l_timestamp := to_timestamp('01-01-1999 12:00:00', 'DD-MM-YYYY HH24:MI:SS');

    l_value := delphidba.sup_ojtppy_actions.get_domain_value_n(
      p_ojt_code               => gc_test_ojt_code_1,
      p_ppy_code               => gc_test_ppy_code_3,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => l_timestamp,
      p_silent_mode            => 'N'
    );
    ut.expect(l_value).to_be_null;
  end get_domain_value_n_bvalidity_outside;

  /* ========================================================================================================
     context: get domain value (date)
     ======================================================================================================== */

  procedure get_domain_value_d_basic is
    l_value date;
  begin
    l_value := delphidba.sup_ojtppy_actions.get_domain_value_d(
      p_ojt_code               => gc_test_ojt_code_2,
      p_ppy_code               => gc_test_ppy_code_2,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'Y'
    );
    ut.expect(l_value).to_equal(gc_test_date);
  end get_domain_value_d_basic;

  procedure get_domain_value_d_non_existent is
    l_value date;
  begin
    l_value := delphidba.sup_ojtppy_actions.get_domain_value_d(
      p_ojt_code               => 'NONEXISTENT_OJT',
      p_ppy_code               => gc_test_ppy_code_2,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'Y'
    );
    ut.expect(l_value).to_be_null;
  end get_domain_value_d_non_existent;

  procedure get_domain_value_d_bvalidity_within is
    l_value date;
    l_timestamp timestamp;
  begin
    -- use a timestamp within validity range
    l_timestamp := to_timestamp('01-01-2024 12:00:00', 'DD-MM-YYYY HH24:MI:SS');

    l_value := delphidba.sup_ojtppy_actions.get_domain_value_d(
      p_ojt_code               => gc_test_ojt_code_2,
      p_ppy_code               => gc_test_ppy_code_2,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => l_timestamp,
      p_silent_mode            => 'Y'
    );
    ut.expect(l_value).to_equal(gc_test_date);
  end get_domain_value_d_bvalidity_within;

  procedure get_domain_value_d_bvalidity_outside is
    l_value date;
    l_timestamp timestamp;
  begin
    -- use a timestamp outside validity range
    l_timestamp := to_timestamp('01-01-1999 12:00:00', 'DD-MM-YYYY HH24:MI:SS');

    l_value := delphidba.sup_ojtppy_actions.get_domain_value_d(
      p_ojt_code               => gc_test_ojt_code_2,
      p_ppy_code               => gc_test_ppy_code_2,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => l_timestamp,
      p_silent_mode            => 'N'
    );
    ut.expect(l_value).to_be_null;
  end get_domain_value_d_bvalidity_outside;

  /* ========================================================================================================
     context: get domain value (timestamp)
     ======================================================================================================== */

  procedure get_domain_value_t_basic is
    l_value timestamp;
  begin
    l_value := delphidba.sup_ojtppy_actions.get_domain_value_t(
      p_ojt_code               => gc_test_ojt_code_2,
      p_ppy_code               => gc_test_ppy_code_3,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'Y'
    );
    ut.expect(l_value).to_equal(gd_test_timestamp);
  end get_domain_value_t_basic;

  procedure get_domain_value_t_non_existent is
    l_value timestamp;
  begin
    l_value := delphidba.sup_ojtppy_actions.get_domain_value_t(
      p_ojt_code               => 'NONEXISTENT_OJT',
      p_ppy_code               => gc_test_ppy_code_3,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'Y'
    );
    ut.expect(l_value).to_be_null;
  end get_domain_value_t_non_existent;

  procedure get_domain_value_t_bvalidity_within is
    l_value timestamp;
    l_timestamp timestamp;
  begin
    -- use a timestamp within validity range
    l_timestamp := to_timestamp('01-01-2024 12:00:00', 'DD-MM-YYYY HH24:MI:SS');

    l_value := delphidba.sup_ojtppy_actions.get_domain_value_t(
      p_ojt_code               => gc_test_ojt_code_2,
      p_ppy_code               => gc_test_ppy_code_3,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => l_timestamp,
      p_silent_mode            => 'Y'
    );
    ut.expect(l_value).to_equal(gd_test_timestamp);
  end get_domain_value_t_bvalidity_within;

  procedure get_domain_value_t_bvalidity_outside is
    l_value timestamp;
    l_timestamp timestamp;
  begin
    -- use a timestamp outside validity range
    l_timestamp := to_timestamp('01-01-1999 12:00:00', 'DD-MM-YYYY HH24:MI:SS');

    l_value := delphidba.sup_ojtppy_actions.get_domain_value_t(
      p_ojt_code               => gc_test_ojt_code_2,
      p_ppy_code               => gc_test_ppy_code_3,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => l_timestamp,
      p_silent_mode            => 'N'
    );
    ut.expect(l_value).to_be_null;
  end get_domain_value_t_bvalidity_outside;

  /* ========================================================================================================
     context: get domain property by value (reverse lookup)
     ======================================================================================================== */

  procedure get_property_by_value_basic is
    l_property varchar2(4000);
  begin
    l_property := delphidba.sup_ojtppy_actions.get_domain_property_by_value(
      p_ojt_code               => gc_test_ojt_code_1,
      p_value                  => gc_test_value_1,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'Y'
    );
    ut.expect(l_property).to_equal(gc_test_ppy_code_1);
  end get_property_by_value_basic;

  procedure get_property_by_value_non_existent is
    l_property varchar2(4000);
  begin
    l_property := delphidba.sup_ojtppy_actions.get_domain_property_by_value(
      p_ojt_code               => gc_test_ojt_code_1,
      p_value                  => 'NONEXISTENT_VALUE',
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'Y'
    );
    ut.expect(l_property).to_be_null;
  end get_property_by_value_non_existent;

  procedure get_property_by_value_null is
    l_property varchar2(4000);
  begin
    -- use gc_test_ojt_code_3: all v_values are filled, so null value should return null
    l_property := delphidba.sup_ojtppy_actions.get_domain_property_by_value(
      p_ojt_code               => gc_test_ojt_code_3,
      p_value                  => null,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'Y'
    );
    ut.expect(l_property).to_be_null;
  end get_property_by_value_null;

  procedure get_property_by_value_bvalidity_within is
    l_property varchar2(4000);
    l_timestamp timestamp;
  begin
    -- use a timestamp within validity range
    l_timestamp := to_timestamp('01-01-2024 12:00:00', 'DD-MM-YYYY HH24:MI:SS');

    l_property := delphidba.sup_ojtppy_actions.get_domain_property_by_value(
      p_ojt_code               => gc_test_ojt_code_1,
      p_value                  => gc_test_value_1,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => l_timestamp,
      p_silent_mode            => 'Y'
    );
    ut.expect(l_property).to_equal(gc_test_ppy_code_1);
  end get_property_by_value_bvalidity_within;

  procedure get_property_by_value_bvalidity_outside is
    l_property varchar2(4000);
    l_timestamp timestamp;
  begin
    -- use a timestamp outside validity range
    l_timestamp := to_timestamp('01-01-1999 12:00:00', 'DD-MM-YYYY HH24:MI:SS');

    l_property := delphidba.sup_ojtppy_actions.get_domain_property_by_value(
      p_ojt_code               => gc_test_ojt_code_1,
      p_value                  => gc_test_value_1,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => l_timestamp,
      p_silent_mode            => 'N'
    );
    ut.expect(l_property).to_be_null;
  end get_property_by_value_bvalidity_outside;

  /* ========================================================================================================
     context: result cache behavior
     ======================================================================================================== */

  procedure get_domain_value_cache_consistency is
    l_value_1 varchar2(4000);
    l_value_2 varchar2(4000);
  begin
    -- first call
    l_value_1 := delphidba.sup_ojtppy_actions.get_domain_value(
      p_ojt_code               => gc_test_ojt_code_1,
      p_ppy_code               => gc_test_ppy_code_1,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'Y'
    );

    -- second call - should use cache
    l_value_2 := delphidba.sup_ojtppy_actions.get_domain_value(
      p_ojt_code               => gc_test_ojt_code_1,
      p_ppy_code               => gc_test_ppy_code_1,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'Y'
    );

    ut.expect(l_value_1).to_equal(l_value_2);
    ut.expect(l_value_1).to_equal(gc_test_value_1);
  end get_domain_value_cache_consistency;

  procedure get_domain_value_consistency is
    l_value_1 varchar2(4000);
    l_value_2 varchar2(4000);
    l_value_3 varchar2(4000);
  begin
    -- verify multiple different values are consistent
    l_value_1 := delphidba.sup_ojtppy_actions.get_domain_value(
      p_ojt_code               => gc_test_ojt_code_1,
      p_ppy_code               => gc_test_ppy_code_1,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'Y'
    );

    l_value_2 := delphidba.sup_ojtppy_actions.get_domain_value(
      p_ojt_code               => gc_test_ojt_code_1,
      p_ppy_code               => gc_test_ppy_code_2,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'Y'
    );

    l_value_3 := delphidba.sup_ojtppy_actions.get_domain_value(
      p_ojt_code               => gc_test_ojt_code_1,
      p_ppy_code               => gc_test_ppy_code_1,
      p_tvalidity_utc_timestamp => null,
      p_bvalidity_utc_timestamp => null,
      p_silent_mode            => 'N'
    );

    -- first and third calls should match (same parameters)
    ut.expect(l_value_1).to_equal(l_value_3);

    -- second call should be different
    ut.expect(l_value_2).not_to_equal(l_value_1);
  end get_domain_value_consistency;

end sup_ojtppy_actions_test;
/