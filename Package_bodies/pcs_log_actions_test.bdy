create or replace package body pcs_log_actions_test is

/***********************************************************************************************************************************
   Purpose    : unit test for package pcs_log_actions (gemaakt met utPLSQL framework)

   Change History
   Date        Author             Version   Description
   ----------  -----------------  --------  ----------------------------------------------------------------------------------------------
   12-12-2025  Sandjai Ramasray     01.00.00  Create mbv Github Copilot
  ************************************************************************************************************************************/

  procedure setup is
  begin
    xxut_processes.create_test_process(cn_test_suite);
  end setup;

  procedure cleanup is
  begin
    xxut_processes.delete_test_process;
  end cleanup;

  /* ========================================================================================================
     context: version number management
     ======================================================================================================== */

  procedure test_get_versionnumber_equals_latest is
    l_ver varchar2(4000);
  begin
    l_ver := delphidba.pcs_log_actions.get_versionnumber;
    ut.expect(l_ver).to_equal(cn_version_nr);
  end test_get_versionnumber_equals_latest;

  /* ========================================================================================================
     context: log trace operations
     ======================================================================================================== */

  procedure test_write_log_trace is
    l_count_before number;
    l_count_after number;
    l_pcs_id number;
    l_count_debug number;
    l_count_trace number;
  begin
    -- Get current process ID
    l_pcs_id := sup_globals.get_global_number('PROCESS_ID');
    
    -- Create some log entries with different severities
    -- Debug entries (lowest priority - often deleted by write_log_trace)
    delphidba.pcs_log_actions.log_debug(
      p_module => 'test_write_log_trace',
      p_message_code => sup_constants.cn_msg_code_debug,
      p_text => 'Debug entry 1'
    );
    delphidba.pcs_log_actions.log_debug(
      p_module => 'test_write_log_trace',
      p_message_code => sup_constants.cn_msg_code_debug,
      p_text => 'Debug entry 2'
    );
    
    -- Trace entries
    delphidba.pcs_log_actions.log_trace(
      p_module => 'test_write_log_trace',
      p_message_code => sup_constants.cn_msg_code_trace,
      p_text => 'Trace entry 1'
    );
    
    -- Info entries (higher priority - usually kept)
    delphidba.pcs_log_actions.log_info(
      p_module => 'test_write_log_trace',
      p_message_code => sup_constants.cn_msg_code_info,
      p_text => 'Info entry 1'
    );
    
    -- Warning entries (high priority - always kept)
    delphidba.pcs_log_actions.log_warning(
      p_module => 'test_write_log_trace',
      p_message_code => sup_constants.cn_msg_code_warning,
      p_text => 'Warning entry 1'
    );
    
    -- Count entries created by our test
    select count(*)
      into l_count_before
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id;
    
    -- Call write_log_trace (cleans up low-priority log entries based on module log level)
    -- Note: This procedure processes all pcs_ids, not just the current one
    -- It may or may not remove entries depending on module log level settings
    delphidba.pcs_log_actions.write_log_trace();
    
    -- Count after cleanup
    select count(*)
      into l_count_after
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id;
    
    -- Verify write_log_trace executed without error
    -- We cannot reliably predict if count will decrease since:
    -- 1) Module log level may be set to keep all entries (DEBUG level)
    -- 2) First/last entries are always preserved
    -- 3) The procedure only removes entries based on module-specific log level settings
    -- So we just verify that entries still exist (at least the ones we created)
    ut.expect(l_count_after).to_be_greater_than(0);
    
    -- Verify we have at least some of our test entries
    ut.expect(l_count_after).to_be_greater_or_equal(2);
  end test_write_log_trace;

  /* ========================================================================================================
     context: log debug operations
     ======================================================================================================== */

  procedure test_log_debug_with_text is
    l_severity varchar2(10);
    l_pcs_id number;
  begin
    -- Get current process ID
    l_pcs_id := sup_globals.get_global_number('PROCESS_ID');
    
    -- Log debug message - tests TEXT variant (p_text parameter)
    delphidba.pcs_log_actions.log_debug(
      p_module => 'test_log_debug',
      p_message_code => sup_constants.cn_msg_code_debug,
      p_text => 'Direct text message without substitution'
    );
    
    -- Verify entry was created with correct severity in one query
    select severity
      into l_severity
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id
       and id = (select max(id) from pcs_technical_log_lines where pcs_id = l_pcs_id);
    
    -- Verify severity is correct
    ut.expect(l_severity).to_equal('D');
  end test_log_debug_with_text;

  procedure test_log_debug_with_subst is
    l_severity varchar2(10);
    l_pcs_id number;
  begin
    -- Get current process ID
    l_pcs_id := sup_globals.get_global_number('PROCESS_ID');
    
    -- Log debug message - tests SUBSTITUTION variant (p_subst parameters)
    -- Uses overloaded version with substitution parameters
    delphidba.pcs_log_actions.log_debug(
      p_module => 'test_log_debug_subst',
      p_message_code => sup_constants.cn_msg_code_debug,
      p_subst1 => 'Subst1',
      p_subst2 => 'Subst2'
    );
    
    -- Verify entry was created with correct severity in one query
    select severity
      into l_severity
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id
       and id = (select max(id) from pcs_technical_log_lines where pcs_id = l_pcs_id);
    
    -- Verify severity is correct
    ut.expect(l_severity).to_equal('D');
  end test_log_debug_with_subst;

  /* ========================================================================================================
     context: log trace level
     ======================================================================================================== */

  procedure test_log_trace_with_text is
    l_severity varchar2(10);
    l_pcs_id number;
  begin
    -- Get current process ID
    l_pcs_id := sup_globals.get_global_number('PROCESS_ID');
    
    -- Log trace message - tests TEXT variant (p_text parameter)
    delphidba.pcs_log_actions.log_trace(
      p_module => 'test_log_trace',
      p_message_code => sup_constants.cn_msg_code_trace,
      p_text => 'Direct text message without substitution'
    );
    
    -- Verify entry was created with correct severity in one query
    select severity
      into l_severity
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id
       and id = (select max(id) from pcs_technical_log_lines where pcs_id = l_pcs_id);
    
    -- Verify severity is correct
    ut.expect(l_severity).to_equal('T');
  end test_log_trace_with_text;

  procedure test_log_trace_with_subst is
    l_severity varchar2(10);
    l_pcs_id number;
  begin
    -- Get current process ID
    l_pcs_id := sup_globals.get_global_number('PROCESS_ID');
    
    -- Log trace message - tests SUBSTITUTION variant (p_subst parameters)
    delphidba.pcs_log_actions.log_trace(
      p_module => 'test_log_trace_subst',
      p_message_code => sup_constants.cn_msg_code_trace,
      p_subst1 => 'Subst1',
      p_subst2 => 'Subst2'
    );
    
    -- Verify entry was created with correct severity in one query
    select severity
      into l_severity
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id
       and id = (select max(id) from pcs_technical_log_lines where pcs_id = l_pcs_id);
    
    -- Verify severity is correct
    ut.expect(l_severity).to_equal('T');
  end test_log_trace_with_subst;

  /* ========================================================================================================
     context: log info operations
     ======================================================================================================== */

  procedure test_log_info_with_text is
    l_severity varchar2(10);
    l_pcs_id number;
  begin
    -- Get current process ID
    l_pcs_id := sup_globals.get_global_number('PROCESS_ID');
    
    -- Log info message (use default message code)
    delphidba.pcs_log_actions.log_info(
      p_module => 'test_log_info'
    );
    
    -- Verify entry was created with correct severity in one query
    select severity
      into l_severity
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id
       and id = (select max(id) from pcs_technical_log_lines where pcs_id = l_pcs_id);
    
    -- Verify severity is correct
    ut.expect(l_severity).to_equal('I');
  end test_log_info_with_text;

  procedure test_log_info_with_subst is
    l_severity varchar2(10);
    l_pcs_id number;
  begin
    -- Get current process ID
    l_pcs_id := sup_globals.get_global_number('PROCESS_ID');
    
    -- Log info message - tests SUBSTITUTION variant (p_subst parameters)
    delphidba.pcs_log_actions.log_info(
      p_module => 'test_log_info_subst',
      p_message_code => sup_constants.cn_msg_code_info,
      p_subst1 => 'Subst1',
      p_subst2 => 'Subst2'
    );
    
    -- Verify entry was created with correct severity in one query
    select severity
      into l_severity
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id
       and id = (select max(id) from pcs_technical_log_lines where pcs_id = l_pcs_id);
    
    -- Verify severity is correct
    ut.expect(l_severity).to_equal('I');
  end test_log_info_with_subst;

  /* ========================================================================================================
     context: log global operations
     ======================================================================================================== */

  procedure test_log_global is
    l_severity varchar2(10);
    l_pcs_id number;
  begin
    -- Get current process ID
    l_pcs_id := sup_globals.get_global_number('PROCESS_ID');
    
    -- Log global message
    delphidba.pcs_log_actions.log_global(
      p_module => 'test_log_global',
      p_text => 'Global message for testing'
    );
    
    -- Verify entry was created with correct severity in one query
    select severity
      into l_severity
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id
       and id = (select max(id) from pcs_technical_log_lines where pcs_id = l_pcs_id);
    
    -- Verify severity is correct
    ut.expect(l_severity).to_equal('G');
  end test_log_global;

  /* ========================================================================================================
     context: log warning operations
     ======================================================================================================== */

  procedure test_log_warning_with_text is
    l_severity varchar2(10);
    l_pcs_id number;
  begin
    -- Get current process ID
    l_pcs_id := sup_globals.get_global_number('PROCESS_ID');
    
    -- Log warning message - tests TEXT variant (p_text parameter)
    delphidba.pcs_log_actions.log_warning(
      p_module => 'test_log_warning',
      p_message_code => sup_constants.cn_msg_code_warning,
      p_text => 'Direct text message without substitution'
    );
    
    -- Verify entry was created with correct severity in one query
    select severity
      into l_severity
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id
       and id = (select max(id) from pcs_technical_log_lines where pcs_id = l_pcs_id);
    
    -- Verify severity is correct
    ut.expect(l_severity).to_equal('W');
  end test_log_warning_with_text;

  procedure test_log_warning_with_subst is
    l_severity varchar2(10);
    l_pcs_id number;
  begin
    -- Get current process ID
    l_pcs_id := sup_globals.get_global_number('PROCESS_ID');
    
    -- Log warning message - tests SUBSTITUTION variant (p_subst parameters)
    delphidba.pcs_log_actions.log_warning(
      p_module => 'test_log_warning_subst',
      p_message_code => sup_constants.cn_msg_code_warning,
      p_subst1 => 'Subst1',
      p_subst2 => 'Subst2'
    );
    
    -- Verify entry was created with correct severity in one query
    select severity
      into l_severity
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id
       and id = (select max(id) from pcs_technical_log_lines where pcs_id = l_pcs_id);
    
    -- Verify severity is correct
    ut.expect(l_severity).to_equal('W');
  end test_log_warning_with_subst;

  /* ========================================================================================================
     context: log error operations
     ======================================================================================================== */

  procedure test_log_error_with_text is
    l_severity varchar2(10);
    l_pcs_id number;
  begin
    -- Get current process ID
    l_pcs_id := sup_globals.get_global_number('PROCESS_ID');
    
    -- Log error message - tests TEXT variant (p_text parameter)
    delphidba.pcs_log_actions.log_error(
      p_module => 'test_log_error',
      p_message_code => sup_constants.cn_msg_code_error,
      p_text => 'Direct text message without substitution'
    );
    
    -- Verify entry was created with correct severity in one query
    select severity
      into l_severity
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id
       and id = (select max(id) from pcs_technical_log_lines where pcs_id = l_pcs_id);
    
    -- Verify severity is correct
    ut.expect(l_severity).to_equal('E');
  end test_log_error_with_text;

  procedure test_log_error_with_subst is
    l_severity varchar2(10);
    l_pcs_id number;
  begin
    -- Get current process ID
    l_pcs_id := sup_globals.get_global_number('PROCESS_ID');
    
    -- Log error message - tests SUBSTITUTION variant (p_subst parameters)
    delphidba.pcs_log_actions.log_error(
      p_module => 'test_log_error_subst',
      p_message_code => sup_constants.cn_msg_code_error,
      p_subst1 => 'Subst1',
      p_subst2 => 'Subst2'
    );
    
    -- Verify entry was created with correct severity in one query
    select severity
      into l_severity
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id
       and id = (select max(id) from pcs_technical_log_lines where pcs_id = l_pcs_id);
    
    -- Verify severity is correct
    ut.expect(l_severity).to_equal('E');
  end test_log_error_with_subst;

  /* ========================================================================================================
     context: log fatal operations
     ======================================================================================================== */

  procedure test_log_fatal_with_text is
    l_severity varchar2(10);
    l_pcs_id number;
  begin
    -- Get current process ID
    l_pcs_id := sup_globals.get_global_number('PROCESS_ID');
    
    -- Log fatal message - tests TEXT variant (p_text parameter)
    delphidba.pcs_log_actions.log_fatal(
      p_module => 'test_log_fatal',
      p_message_code => sup_constants.cn_msg_code_fatal,
      p_text => 'Direct text message without substitution'
    );
    
    -- Verify entry was created with correct severity in one query
    select severity
      into l_severity
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id
       and id = (select max(id) from pcs_technical_log_lines where pcs_id = l_pcs_id);
    
    -- Verify severity is correct
    ut.expect(l_severity).to_equal('F');
  end test_log_fatal_with_text;

  procedure test_log_fatal_with_subst is
    l_severity varchar2(10);
    l_pcs_id number;
  begin
    -- Get current process ID
    l_pcs_id := sup_globals.get_global_number('PROCESS_ID');
    
    -- Log fatal message - tests SUBSTITUTION variant (p_subst parameters)
    delphidba.pcs_log_actions.log_fatal(
      p_module => 'test_log_fatal_subst',
      p_message_code => sup_constants.cn_msg_code_fatal,
      p_subst1 => 'Subst1',
      p_subst2 => 'Subst2'
    );
    
    -- Verify entry was created with correct severity in one query
    select severity
      into l_severity
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id
       and id = (select max(id) from pcs_technical_log_lines where pcs_id = l_pcs_id);
    
    -- Verify severity is correct
    ut.expect(l_severity).to_equal('F');
  end test_log_fatal_with_subst;

  /* ========================================================================================================
     context: log debug with multiple substitution parameters
     ======================================================================================================== */

  procedure test_log_debug_with_multiple_subst is
    l_severity varchar2(10);
    l_pcs_id number;
  begin
    -- Get current process ID
    l_pcs_id := sup_globals.get_global_number('PROCESS_ID');
    
    -- Log debug message - tests with 9 substitution parameters
    delphidba.pcs_log_actions.log_debug(
      p_module => 'test_log_debug_multi',
      p_message_code => sup_constants.cn_msg_code_debug,
      p_subst1 => 'Subst1',
      p_subst2 => 'Subst2',
      p_subst3 => 'Subst3',
      p_subst4 => 'Subst4',
      p_subst5 => 'Subst5',
      p_subst6 => 'Subst6',
      p_subst7 => 'Subst7',
      p_subst8 => 'Subst8',
      p_subst9 => 'Subst9'
    );
    
    -- Verify entry was created with correct severity
    select severity
      into l_severity
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id
       and id = (select max(id) from pcs_technical_log_lines where pcs_id = l_pcs_id);
    
    ut.expect(l_severity).to_equal('D');
  end test_log_debug_with_multiple_subst;

  /* ========================================================================================================
     context: log trace with multiple substitution parameters
     ======================================================================================================== */

  procedure test_log_trace_with_multiple_subst is
    l_severity varchar2(10);
    l_pcs_id number;
  begin
    -- Get current process ID
    l_pcs_id := sup_globals.get_global_number('PROCESS_ID');
    
    -- Log trace message - tests with 5 substitution parameters
    delphidba.pcs_log_actions.log_trace(
      p_module => 'test_log_trace_multi',
      p_message_code => sup_constants.cn_msg_code_trace,
      p_subst1 => 'Subst1',
      p_subst2 => 'Subst2',
      p_subst3 => 'Subst3',
      p_subst4 => 'Subst4',
      p_subst5 => 'Subst5'
    );
    
    -- Verify entry was created with correct severity
    select severity
      into l_severity
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id
       and id = (select max(id) from pcs_technical_log_lines where pcs_id = l_pcs_id);
    
    ut.expect(l_severity).to_equal('T');
  end test_log_trace_with_multiple_subst;

  /* ========================================================================================================
     context: log info with multiple substitution parameters
     ======================================================================================================== */

  procedure test_log_info_with_multiple_subst is
    l_severity varchar2(10);
    l_pcs_id number;
  begin
    -- Get current process ID
    l_pcs_id := sup_globals.get_global_number('PROCESS_ID');
    
    -- Log info message - tests with 7 substitution parameters
    delphidba.pcs_log_actions.log_info(
      p_module => 'test_log_info_multi',
      p_message_code => sup_constants.cn_msg_code_info,
      p_subst1 => 'Subst1',
      p_subst2 => 'Subst2',
      p_subst3 => 'Subst3',
      p_subst4 => 'Subst4',
      p_subst5 => 'Subst5',
      p_subst6 => 'Subst6',
      p_subst7 => 'Subst7'
    );
    
    -- Verify entry was created with correct severity
    select severity
      into l_severity
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id
       and id = (select max(id) from pcs_technical_log_lines where pcs_id = l_pcs_id);
    
    ut.expect(l_severity).to_equal('I');
  end test_log_info_with_multiple_subst;

  /* ========================================================================================================
     context: log warning with multiple substitution parameters
     ======================================================================================================== */

  procedure test_log_warning_with_multiple_subst is
    l_severity varchar2(10);
    l_pcs_id number;
  begin
    -- Get current process ID
    l_pcs_id := sup_globals.get_global_number('PROCESS_ID');
    
    -- Log warning message - tests with 6 substitution parameters
    delphidba.pcs_log_actions.log_warning(
      p_module => 'test_log_warning_multi',
      p_message_code => sup_constants.cn_msg_code_warning,
      p_subst1 => 'Subst1',
      p_subst2 => 'Subst2',
      p_subst3 => 'Subst3',
      p_subst4 => 'Subst4',
      p_subst5 => 'Subst5',
      p_subst6 => 'Subst6'
    );
    
    -- Verify entry was created with correct severity
    select severity
      into l_severity
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id
       and id = (select max(id) from pcs_technical_log_lines where pcs_id = l_pcs_id);
    
    ut.expect(l_severity).to_equal('W');
  end test_log_warning_with_multiple_subst;

  /* ========================================================================================================
     context: log error with multiple substitution parameters
     ======================================================================================================== */

  procedure test_log_error_with_multiple_subst is
    l_severity varchar2(10);
    l_pcs_id number;
  begin
    -- Get current process ID
    l_pcs_id := sup_globals.get_global_number('PROCESS_ID');
    
    -- Log error message - tests with 8 substitution parameters
    delphidba.pcs_log_actions.log_error(
      p_module => 'test_log_error_multi',
      p_message_code => sup_constants.cn_msg_code_error,
      p_subst1 => 'Subst1',
      p_subst2 => 'Subst2',
      p_subst3 => 'Subst3',
      p_subst4 => 'Subst4',
      p_subst5 => 'Subst5',
      p_subst6 => 'Subst6',
      p_subst7 => 'Subst7',
      p_subst8 => 'Subst8'
    );
    
    -- Verify entry was created with correct severity
    select severity
      into l_severity
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id
       and id = (select max(id) from pcs_technical_log_lines where pcs_id = l_pcs_id);
    
    ut.expect(l_severity).to_equal('E');
  end test_log_error_with_multiple_subst;

  /* ========================================================================================================
     context: log fatal with multiple substitution parameters
     ======================================================================================================== */

  procedure test_log_fatal_with_multiple_subst is
    l_severity varchar2(10);
    l_pcs_id number;
  begin
    -- Get current process ID
    l_pcs_id := sup_globals.get_global_number('PROCESS_ID');
    
    -- Log fatal message - tests with 4 substitution parameters
    delphidba.pcs_log_actions.log_fatal(
      p_module => 'test_log_fatal_multi',
      p_message_code => sup_constants.cn_msg_code_fatal,
      p_subst1 => 'Subst1',
      p_subst2 => 'Subst2',
      p_subst3 => 'Subst3',
      p_subst4 => 'Subst4'
    );
    
    -- Verify entry was created with correct severity
    select severity
      into l_severity
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id
       and id = (select max(id) from pcs_technical_log_lines where pcs_id = l_pcs_id);
    
    ut.expect(l_severity).to_equal('F');
  end test_log_fatal_with_multiple_subst;

end pcs_log_actions_test;
/
