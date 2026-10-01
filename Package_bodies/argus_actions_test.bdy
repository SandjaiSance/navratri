create or replace package body argus_actions_test is

  /*********************************************************************************************************************
   purpose    : unit tests for argus_actions package

   this test package validates:
   - version number retrieval
   - determine_statusses decision logic
   - basic is_argus_publication behavior

   change history

   date        author            version   description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   11-05-2026  GitHub Copilot    01.00.00  initial creation

  *********************************************************************************************************************/

  procedure setup is
  begin
    delphidba.xxut_processes.create_test_process(p_test_suite_name => cn_test_suite);
    commit;
  end setup;

  procedure cleanup is
  begin
    delphidba.xxut_processes.delete_test_process();
    commit;
  end cleanup;

  /* ========================================================================================================
     context: version number management
     ======================================================================================================== */

  procedure check_versionnumber_equals_latest is
    l_ver varchar2(4000);
  begin
    l_ver := delphidba.argus_actions.get_versionnumber;
    ut.expect(l_ver).to_equal(cn_version_nr);
  end check_versionnumber_equals_latest;

  /* ========================================================================================================
     context: determine_statusses decision tree
     ======================================================================================================== */

  procedure test_status_delivered_on_time_and_approved is
    l_now_utc  date := cast(systimestamp at time zone 'UTC' as date);
    l_timely   varchar2(5);
    l_complete varchar2(5);
  begin
    delphidba.argus_actions.determine_statusses(
      p_delivered_utc => l_now_utc - (1 / 24),
      p_approved_utc  => l_now_utc,
      p_rejected_utc  => null,
      p_deadline_utc  => l_now_utc + (1 / 24),
      p_timely        => l_timely,
      p_complete      => l_complete
    );

    ut.expect(l_timely).to_equal('TRUE');
    ut.expect(l_complete).to_equal('TRUE');
  end test_status_delivered_on_time_and_approved;

  procedure test_status_no_delivered_approved_before_deadline is
    l_now_utc  date := cast(systimestamp at time zone 'UTC' as date);
    l_timely   varchar2(5);
    l_complete varchar2(5);
  begin
    delphidba.argus_actions.determine_statusses(
      p_delivered_utc => null,
      p_approved_utc  => l_now_utc,
      p_rejected_utc  => null,
      p_deadline_utc  => l_now_utc + (1 / 24),
      p_timely        => l_timely,
      p_complete      => l_complete
    );

    ut.expect(l_timely).to_equal('TRUE');
    ut.expect(l_complete).to_equal('TRUE');
  end test_status_no_delivered_approved_before_deadline;

  procedure test_status_no_delivered_approved_after_deadline is
    l_now_utc  date := cast(systimestamp at time zone 'UTC' as date);
    l_timely   varchar2(5);
    l_complete varchar2(5);
  begin
    delphidba.argus_actions.determine_statusses(
      p_delivered_utc => null,
      p_approved_utc  => l_now_utc,
      p_rejected_utc  => null,
      p_deadline_utc  => l_now_utc - (1 / 24),
      p_timely        => l_timely,
      p_complete      => l_complete
    );

    ut.expect(l_timely).to_equal('FALSE');
    ut.expect(l_complete).to_equal('TRUE');
  end test_status_no_delivered_approved_after_deadline;

  procedure test_status_no_delivery_or_approval_after_deadline is
    l_now_utc  date := cast(systimestamp at time zone 'UTC' as date);
    l_timely   varchar2(5);
    l_complete varchar2(5);
  begin
    delphidba.argus_actions.determine_statusses(
      p_delivered_utc => null,
      p_approved_utc  => null,
      p_rejected_utc  => null,
      p_deadline_utc  => l_now_utc - (1 / 24),
      p_timely        => l_timely,
      p_complete      => l_complete
    );

    ut.expect(l_timely).to_equal('FALSE');
    ut.expect(l_complete).to_equal('FALSE');
  end test_status_no_delivery_or_approval_after_deadline;

  procedure test_status_delivered_on_time_but_rejected is
    l_now_utc  date := cast(systimestamp at time zone 'UTC' as date);
    l_timely   varchar2(5);
    l_complete varchar2(5);
  begin
    delphidba.argus_actions.determine_statusses(
      p_delivered_utc => l_now_utc,
      p_approved_utc  => null,
      p_rejected_utc  => l_now_utc,
      p_deadline_utc  => l_now_utc + (1 / 24),
      p_timely        => l_timely,
      p_complete      => l_complete
    );

    ut.expect(l_timely).to_equal('FALSE');
    ut.expect(l_complete).to_equal('FALSE');
  end test_status_delivered_on_time_but_rejected;

  procedure test_status_delivered_on_time_no_approval_before_deadline is
    l_deadline_utc date := cast(sys_extract_utc(systimestamp) as date) + 7;
    l_delivered_utc date := (cast(sys_extract_utc(systimestamp) as date) + 7) - (1 / 24);
    l_timely   varchar2(5);
    l_complete varchar2(5);
  begin
    delphidba.argus_actions.determine_statusses(
      p_delivered_utc => l_delivered_utc,
      p_approved_utc  => null,
      p_rejected_utc  => null,
      p_deadline_utc  => l_deadline_utc,
      p_timely        => l_timely,
      p_complete      => l_complete
    );

    ut.expect(l_timely).to_be_null;
    ut.expect(l_complete).to_be_null;
  end test_status_delivered_on_time_no_approval_before_deadline;

  procedure test_status_delivered_late_and_approved is
    l_now_utc  date := cast(systimestamp at time zone 'UTC' as date);
    l_timely   varchar2(5);
    l_complete varchar2(5);
  begin
    delphidba.argus_actions.determine_statusses(
      p_delivered_utc => l_now_utc,
      p_approved_utc  => l_now_utc,
      p_rejected_utc  => null,
      p_deadline_utc  => l_now_utc - (1 / 24),
      p_timely        => l_timely,
      p_complete      => l_complete
    );

    ut.expect(l_timely).to_equal('FALSE');
    ut.expect(l_complete).to_equal('TRUE');
  end test_status_delivered_late_and_approved;

  procedure test_status_delivered_late_and_not_approved is
    l_now_utc  date := cast(systimestamp at time zone 'UTC' as date);
    l_timely   varchar2(5);
    l_complete varchar2(5);
  begin
    delphidba.argus_actions.determine_statusses(
      p_delivered_utc => l_now_utc,
      p_approved_utc  => null,
      p_rejected_utc  => null,
      p_deadline_utc  => l_now_utc - (1 / 24),
      p_timely        => l_timely,
      p_complete      => l_complete
    );

    ut.expect(l_timely).to_equal('FALSE');
    ut.expect(l_complete).to_equal('FALSE');
  end test_status_delivered_late_and_not_approved;

  /* ========================================================================================================
     context: argus publication detection
     ======================================================================================================== */

  procedure test_is_argus_publication_non_existing_returns_false is
    l_result boolean;
  begin
    l_result := delphidba.argus_actions.is_argus_publication('ZZZ_NON_EXISTING_PUBLICATION');

    ut.expect(case when l_result then 'TRUE' else 'FALSE' end).to_equal('FALSE');
  end test_is_argus_publication_non_existing_returns_false;

  procedure test_is_argus_publication_null_returns_false is
    l_result boolean;
  begin
    l_result := delphidba.argus_actions.is_argus_publication(null);

    ut.expect(case when l_result then 'TRUE' else 'FALSE' end).to_equal('FALSE');
  end test_is_argus_publication_null_returns_false;

end argus_actions_test;
/