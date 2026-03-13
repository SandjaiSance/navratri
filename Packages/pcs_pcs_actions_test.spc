create or replace package pcs_pcs_actions_test is

  --%suite(pcs_pcs_actions)

  --%context(start_process)
  --%displayname(start_process)

  --%test(starts a new process with minimal parameters)
  --%aftertest(pcs_pcs_actions_test.cleanup_processes)
  procedure start_process_minimal;

  --%test(starts a process with all parameters)
  --%aftertest(pcs_pcs_actions_test.cleanup_processes)
  procedure start_process_with_all_params;

  --%test(starts a process with parent_pcs_id)
  --%aftertest(pcs_pcs_actions_test.cleanup_processes)
  procedure start_process_with_parent_id;

  --%endcontext

  --%context(update_process)
  --%displayname(update_process)

  --%test(updates process with new description)
  --%beforetest(pcs_pcs_actions_test.setup_process)
  --%aftertest(pcs_pcs_actions_test.cleanup_processes)
  procedure update_process_description;

  --%test(updates process with all parameters)
  --%beforetest(pcs_pcs_actions_test.setup_process)
  --%aftertest(pcs_pcs_actions_test.cleanup_processes)
  procedure update_process_all_params;

  --%endcontext

  --%context(end_process)
  --%displayname(end_process)

  --%test(ends active process successfully)
  --%beforetest(pcs_pcs_actions_test.setup_process)
  --%aftertest(pcs_pcs_actions_test.cleanup_processes)
  procedure end_process_completes;

  --%test(ends active process successfully and save globals in pcs_technical_log_lines)
  --%beforetest(pcs_pcs_actions_test.setup_process)
  --%aftertest(pcs_pcs_actions_test.cleanup_processes)
  procedure save_globals_in_log_lines;

  --%endcontext

  --%context(set_max_severities)
  --%displayname(end_process)

  --%test(set max_severity E)
  --%beforetest(pcs_pcs_actions_test.setup_process)
  --%aftertest(pcs_pcs_actions_test.cleanup_processes)
  procedure set_max_severity_e;

  --%test(set max_severity W)
  --%beforetest(pcs_pcs_actions_test.setup_process)
  --%aftertest(pcs_pcs_actions_test.cleanup_processes)
  procedure set_max_severity_w;

  --%test(set max_severity I)
  --%beforetest(pcs_pcs_actions_test.setup_process)
  --%aftertest(pcs_pcs_actions_test.cleanup_processes)
  procedure set_max_severity_i;

  --%endcontext

  procedure setup;
  procedure setup_process;
  procedure cleanup_processes;

end pcs_pcs_actions_test;
/