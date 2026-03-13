create or replace package pcs_log_actions_test is

  cn_test_suite constant varchar2(256) := 'PCS_LOG_ACTIONS_TEST';
  cn_version_nr CONSTANT varchar2(256) := '01.05.00';

  --%suite(pcs_log_actions)
  --%rollback(manual)

  --%beforeall
  procedure setup;

  --%afterall
  procedure cleanup;

  /* ========================================================================================================
     context: version number management
     ======================================================================================================== */

  --%context(version)

    --%test(Verify version equals latest package version)
    procedure test_get_versionnumber_equals_latest;

  --%endcontext

  /* ========================================================================================================
     context: log trace operations
     ======================================================================================================== */

  --%context(write_log_trace_operations)

    --%test(Test write_log_trace procedure)
    procedure test_write_log_trace;

  --%endcontext

  /* ========================================================================================================
     context: log debug operations
     ======================================================================================================== */

  --%context(logging_debug)

    --%test(Test log_debug with text parameter)
    procedure test_log_debug_with_text;

    --%test(Test log_debug with substitution parameters)
    procedure test_log_debug_with_subst;

    --%test(Test log_debug with multiple substitution parameters)
    procedure test_log_debug_with_multiple_subst;

  --%endcontext

  /* ========================================================================================================
     context: log trace level
     ======================================================================================================== */

  --%context(logging_trace)

    --%test(Test log_trace with text parameter)
    procedure test_log_trace_with_text;

    --%test(Test log_trace with substitution parameters)
    procedure test_log_trace_with_subst;

    --%test(Test log_trace with multiple substitution parameters)
    procedure test_log_trace_with_multiple_subst;

  --%endcontext

  --%context(logging_info)

    --%test(Test log_info with text parameter)
    procedure test_log_info_with_text;

    --%test(Test log_info with substitution parameters)
    procedure test_log_info_with_subst;

    --%test(Test log_info with multiple substitution parameters)
    procedure test_log_info_with_multiple_subst;

  --%endcontext

  /* ========================================================================================================
     context: log global level
     ======================================================================================================== */

  --%context(logging_global)

    --%test(Test log_global procedure)
    procedure test_log_global;

  --%endcontext

  --%context(logging_warning)

    --%test(Test log_warning with text parameter)
    procedure test_log_warning_with_text;

    --%test(Test log_warning with substitution parameters)
    procedure test_log_warning_with_subst;

    --%test(Test log_warning with multiple substitution parameters)
    procedure test_log_warning_with_multiple_subst;

  --%endcontext

  --%context(logging_error)

    --%test(Test log_error with text parameter)
    procedure test_log_error_with_text;

    --%test(Test log_error with substitution parameters)
    procedure test_log_error_with_subst;

    --%test(Test log_error with multiple substitution parameters)
    procedure test_log_error_with_multiple_subst;

  --%endcontext

  --%context(logging_fatal)

    --%test(Test log_fatal with text parameter)
    procedure test_log_fatal_with_text;

    --%test(Test log_fatal with substitution parameters)
    procedure test_log_fatal_with_subst;

    --%test(Test log_fatal with multiple substitution parameters)
    procedure test_log_fatal_with_multiple_subst;

  --%endcontext

end pcs_log_actions_test;
/
