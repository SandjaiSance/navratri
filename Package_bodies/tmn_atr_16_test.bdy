create or replace package body tmn_atr_16_test is

  /*********************************************************************************************************************
   purpose    : unit tests for tmn_atr_16 package

    copilot instructions (for creating this unittest package):
    - use utplsql with annotations in the test specification only
    - keep package body free of --%test annotations; use context comments instead
    - include setup/cleanup using delphidba.xxut_processes
    - add at least a versionnumber test with exact value assertion
    - add procedure tests for public entry points and assert no unhandled errors
    - use clear test procedure names and stable test constants
    - keep schema prefix delphidba. for package calls

   this test package validates:
   - version number retrieval
   - fill_expectations execution path
   - argus expectation check entry points

   change history

   date        author            version   description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   17-03-2026  Sandjai Ramasray  01.00.00  initial creation with GitHub Copilot 

  *********************************************************************************************************************/

  gc_test_mrid         constant varchar2(100) := 'UT_TMN_ATR_16_MRID';
  gc_test_message_id   constant varchar2(100) := 'OPC0000018578';
  gc_test_tmn_mrid     constant varchar2(100) := 'ATR_16_' || 'OPC0000018578';
  gd_test_runtime_utc  constant date          := to_date('17-03-2026 12:00:00', 'DD-MM-YYYY HH24:MI:SS');

  procedure setup is
  begin
    delphidba.xxut_processes.create_test_process(p_test_suite_name => cn_test_suite);
  end setup;

  procedure cleanup is
  begin
    delphidba.xxut_processes.delete_test_process();
  end cleanup;

  /* ========================================================================================================
     context: start publication
     ======================================================================================================== */

  procedure start_publication_creates_transmission is
    l_tmn_count number := 0;
  begin
    delphidba.tmn_atr_16.start_publication
      ( p_message_id     => gc_test_message_id
      , p_runtime_utc    => cast(gd_test_runtime_utc as timestamp) at time zone 'UTC'
      , p_start_time_utc => cast(gd_test_runtime_utc as timestamp) at time zone 'UTC'
      );

    select count(*)
      into l_tmn_count
      from pcs_tmn_transmissions tmn
      join sup_publications       pbn on pbn.id = tmn.pbn_id
     where pbn.name = 'ATR_16'
       and tmn.mrid = gc_test_tmn_mrid;

    ut.expect(l_tmn_count).to_be_greater_than(0);
  end start_publication_creates_transmission;

  /* ========================================================================================================
     context: version number management
     ======================================================================================================== */

  procedure check_versionnumber_equals_latest is
    l_ver varchar2(4000);
  begin
    l_ver := delphidba.tmn_atr_16.get_versionnumber;
    ut.expect(l_ver).to_equal(cn_version_nr);
  end check_versionnumber_equals_latest;

  /* ========================================================================================================
     context: expectation creation
     ======================================================================================================== */

  procedure fill_expectations_creates_expectation is
    l_epn_count number := 0;
  begin
    delphidba.tmn_atr_16.fill_expectations(p_mrid        => gc_test_tmn_mrid
                                          ,p_runtime_utc => gd_test_runtime_utc);

    select count(*)
      into l_epn_count
      from ags_pbn_expectations ex
     where ex.check_name = 'ATR_16'
       and ex.mrid       = gc_test_tmn_mrid;

    ut.expect(l_epn_count).to_be_greater_than(0);
  end fill_expectations_creates_expectation;

  /* ========================================================================================================
     context: argus checks
     ======================================================================================================== */

  procedure check_expectations_fills_timely_and_complete is
    l_timely   ags_pbn_expectations.timely%type;
    l_complete ags_pbn_expectations.complete%type;
  begin
    -- first create the expectation record so check_expectations has something to evaluate
    delphidba.tmn_atr_16.fill_expectations(p_mrid        => gc_test_tmn_mrid
                                          ,p_runtime_utc => gd_test_runtime_utc);

    delphidba.tmn_atr_16.check_expectations;

    select ex.timely
          ,ex.complete
      into l_timely
          ,l_complete
      from ags_pbn_expectations ex
     where ex.check_name = 'ATR_16'
       and ex.mrid       = gc_test_tmn_mrid
     order by ex.runtime_utc desc
     fetch first 1 rows only;

    ut.expect(l_timely).not_to_be_null();
    ut.expect(l_complete).not_to_be_null();
  end check_expectations_fills_timely_and_complete;

  procedure check_expectation_after_ack_runs_without_error is
    l_failed boolean := false;
  begin
    begin
      delphidba.tmn_atr_16.check_expectation_after_ack(p_mrid => gc_test_mrid);
    exception
      when others then
        l_failed := true;
    end;

    ut.expect(case when l_failed then 'TRUE' else 'FALSE' end).to_equal('FALSE');
  end check_expectation_after_ack_runs_without_error;

end tmn_atr_16_test;
/
