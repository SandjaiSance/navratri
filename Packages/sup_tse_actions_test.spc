create or replace package sup_tse_actions_test is
  
  cn_test_suite constant varchar2(256) := 'SUP_TSE_ACTIONS_TEST';
  cn_package    constant varchar2(256) := 'SUP_TSE_ACTIONS';
  cn_version_nr constant varchar2(256) := '01.04.00';
  
  --%suite(sup_tse_actions - transmission error handling unit tests)
  --%rollback(manual)
  
  --%beforeall
  procedure setup;

  --%afterall
  procedure cleanup;

  /* ========================================================================================================
     context: version number management
     ======================================================================================================== */

  --%context(version number)

  --%test(Verify version equals latest package version)
  procedure check_versionnumber_equals_latest;

  --%endcontext

  /* ========================================================================================================
     context: missing transmissions check
     ======================================================================================================== */

  --%context(missing transmissions)

  --%test(check_missing_transmissions detects missing transmission)
  procedure test_detect_missing_transmission;

  --%test(check_missing_transmissions handles no missing transmissions)
  procedure test_no_missing_transmissions;

  --%test(check_missing_transmissions handles null publication)
  procedure test_null_publication;

  --%test(check_missing_transmissions handles null bvalidity)
  procedure test_null_bvalidity;

  --%test(check_missing_transmissions handles future runtime)
  procedure test_future_runtime;

  --%test(check_missing_transmissions with catch-up disabled)
  procedure test_catchup_disabled;

  --%test(check_missing_transmissions with multiple missing hourly transmissions)
  procedure test_multiple_missing_hourly;

  --%test(check_missing_transmissions with missing daily transmission)
  procedure test_missing_daily_transmission;

  --%test(check_missing_transmissions with already enqueued transmission)
  procedure test_already_enqueued_transmission;

  --%endcontext

end sup_tse_actions_test;
/
