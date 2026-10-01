create or replace package argus_actions_test is

  cn_test_suite constant varchar2(256) := 'ARGUS_ACTIONS_TEST';
  cn_package    constant varchar2(256) := 'ARGUS_ACTIONS';
  cn_version_nr constant varchar2(256) := '01.03.00';

  --%suite(argus_actions - argus expectations unit tests)
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
     context: determine_statusses decision tree
     ======================================================================================================== */

  --%context(determine_statusses)

  --%test(delivered on time and approved gives timely and complete true)
  procedure test_status_delivered_on_time_and_approved;

  --%test(no delivered and approved before deadline gives timely and complete true)
  procedure test_status_no_delivered_approved_before_deadline;

  --%test(no delivered and approved after deadline gives timely false and complete true)
  procedure test_status_no_delivered_approved_after_deadline;

  --%test(no delivered and no approved after deadline gives timely and complete false)
  procedure test_status_no_delivery_or_approval_after_deadline;

  --%test(delivered on time and rejected gives timely and complete false)
  procedure test_status_delivered_on_time_but_rejected;

  --%test(delivered on time without approved before deadline returns null statuses)
  procedure test_status_delivered_on_time_no_approval_before_deadline;

  --%test(delivered too late and approved gives timely false and complete true)
  procedure test_status_delivered_late_and_approved;

  --%test(delivered too late and not approved gives timely and complete false)
  procedure test_status_delivered_late_and_not_approved;

  --%endcontext

  /* ========================================================================================================
     context: argus publication detection
     ======================================================================================================== */

  --%context(is_argus_publication)

  --%test(non existing publication returns false)
  procedure test_is_argus_publication_non_existing_returns_false;

  --%test(null publication returns false)
  procedure test_is_argus_publication_null_returns_false;

  --%endcontext

end argus_actions_test;
/