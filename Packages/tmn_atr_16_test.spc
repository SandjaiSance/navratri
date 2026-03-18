create or replace package tmn_atr_16_test is

  cn_test_suite constant varchar2(256) := 'TMN_ATR_16_TEST';
  cn_package    constant varchar2(256) := 'TMN_ATR_16';
  cn_version_nr constant varchar2(256) := '01.01.00';

  --%suite(tmn_atr_16 - atr_16 publication unit tests)
  --%rollback(manual)

  --%beforeall
  procedure setup;

  --%afterall
  procedure cleanup;

  /* ========================================================================================================
     context: start publication
     ======================================================================================================== */

  --%context(start publication)

  --%test(start_publication creates a transmission record for the given message_id)
  procedure start_publication_creates_transmission;

  --%endcontext

  /* ========================================================================================================
     context: version number management
     ======================================================================================================== */

  --%context(version number)

  --%test(Verify version equals latest package version)
  procedure check_versionnumber_equals_latest;

  --%endcontext

  /* ========================================================================================================
     context: expectation creation
     ======================================================================================================== */

  --%context(fill expectations)

  --%test(fill_expectations creates an expectation record for the given mrid)
  procedure fill_expectations_creates_expectation;

  --%endcontext

  /* ========================================================================================================
     context: argus checks
     ======================================================================================================== */

  --%context(argus checks)

  --%test(check_expectations fills timely and complete on the expectation record)
  procedure check_expectations_fills_timely_and_complete;

  --%test(check_expectation_after_ack executes without unhandled error)
  procedure check_expectation_after_ack_runs_without_error;

  --%endcontext

end tmn_atr_16_test;
/
