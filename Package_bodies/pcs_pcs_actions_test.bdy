create or replace package body pcs_pcs_actions_test is
/***********************************************************************************************************************************
   Purpose    : unit test for package pcs_pcs_actions (gemaakt met utplsql framework)

   Change History
   Date        Author         Version   Description
   ----------  -------------  --------  ----------------------------------------------------------------------------------------------------------
   10-12-2025  Copilot        01.00.00  Create

  ************************************************************************************************************************************/

  procedure setup is
  begin
    null;
  end setup;

  procedure cleanup_processes is
  begin
    delete from pcs_technical_log_lines
     where pcs_id in (select id from pcs_processes
                       where initiating_procedure like 'pcs_pcs_actions_test.%'
                         and tvalidity_loc_from > trunc(sysdate - 1/24)
                       );

    delete from pcs_globals
     where pcs_id in (select id from pcs_processes
                       where initiating_procedure like 'pcs_pcs_actions_test.%'
                         and tvalidity_loc_from > trunc(sysdate - 1/24)
                      );

    delete from pcs_processes
     where initiating_procedure like 'pcs_pcs_actions_test.%'
       and tvalidity_loc_from > trunc(sysdate - 1/24);

    sup_globals.remove_all_globals;

    commit;
  end cleanup_processes;

  procedure setup_process is
  begin
    pcs_pcs_actions.start_process(p_initiating_procedure => 'pcs_pcs_actions_test.setup_process',
                                   p_description => 'Test process setup');

  end setup_process;

  procedure start_process_minimal is
    v_pcs_id number;
    v_count  number;
  begin
    pcs_pcs_actions.start_process(p_initiating_procedure => 'pcs_pcs_actions_test.start_process_minimal');

    v_pcs_id                    := sup_globals.get_global_number(p_name => 'PROCESS_ID');

    select count(*)
      into v_count
      from pcs_processes
     where id = v_pcs_id;

    ut.expect(v_count = 1).to_equal(true);
  end start_process_minimal;

  procedure start_process_with_all_params is
    v_pcs_id number;
    v_count  number;
  begin
    pcs_pcs_actions.start_process(
      p_initiating_procedure => 'pcs_pcs_actions_test.start_process_with_all_params',
      p_description => 'Test process with all params',
      p_legal_owner => 'TEST_OWNER',
      p_parent_pcs_id => null,
      p_cre_source => 'UNIT_TEST'
    );

    v_pcs_id                    := sup_globals.get_global_number(p_name => 'PROCESS_ID');

    select count(*)
      into v_count
      from pcs_processes
     where initiating_procedure = 'pcs_pcs_actions_test.start_process_with_all_params'
       and description = 'Test process with all params'
       and legal_owner = 'TEST_OWNER'
       and id = v_pcs_id;

    ut.expect(v_count = 1).to_equal(true);
  end start_process_with_all_params;

  procedure start_process_with_parent_id is
    v_parent_pcs_id number;
    v_child_pcs_id  number;
    v_count         number;
  begin
    -- Start parent process
    pcs_pcs_actions.start_process(
      p_initiating_procedure => 'pcs_pcs_actions_test.start_process_with_parent_id',
      p_description => 'Parent process'
    );

    v_parent_pcs_id := sup_globals.get_global_number(p_name => 'PROCESS_ID');

    -- Start child process with parent_pcs_id set
    sup_globals.remove_all_globals;

    pcs_pcs_actions.start_process(
      p_initiating_procedure => 'pcs_pcs_actions_test.start_process_with_parent_id',
      p_description => 'Child process',
      p_parent_pcs_id => v_parent_pcs_id
    );

    v_child_pcs_id := sup_globals.get_global_number(p_name => 'PROCESS_ID');

    -- Verify child process has correct parent_pcs_id
    select count(*)
      into v_count
      from pcs_processes
     where id = v_child_pcs_id
       and parent_pcs_id = v_parent_pcs_id
       and initiating_procedure = 'pcs_pcs_actions_test.start_process_with_parent_id';

    ut.expect(v_count = 1).to_equal(true);
  end start_process_with_parent_id;

  procedure update_process_description is
    v_new_desc varchar2(100) := 'Updated description for testing';
    v_count    number;
    v_pcs_id   number;
  begin
    pcs_pcs_actions.start_process(p_initiating_procedure => 'pcs_pcs_actions_test.update_process_description',
                                   p_description => 'Original description');

    v_pcs_id                    := sup_globals.get_global_number(p_name => 'PROCESS_ID');

    pcs_pcs_actions.update_process(p_description => v_new_desc);

    select count(*)
      into v_count
      from pcs_processes
     where id = v_pcs_id
       and description = v_new_desc;

    ut.expect(v_count = 1).to_equal(true);
  end update_process_description;

  procedure update_process_all_params is
    v_count    number;
    v_pcs_id   number;
  begin
    pcs_pcs_actions.start_process(p_initiating_procedure => 'pcs_pcs_actions_test.update_process_all_params',
                                   p_description => 'Original');

    v_pcs_id                    := sup_globals.get_global_number(p_name => 'PROCESS_ID');

    pcs_pcs_actions.update_process(
      p_description => 'Updated description',
      p_legal_owner => 'UPDATED_OWNER',
      p_cre_source => 'UNIT_TEST'
    );

    select count(*)
      into v_count
      from pcs_processes
     where id = v_pcs_id
       and description = 'Updated description'
       and legal_owner = 'UPDATED_OWNER'
       and tvalidity_loc_from > trunc(sysdate - 1/24);

    ut.expect(v_count = 1).to_equal(true);
  end update_process_all_params;

  procedure end_process_completes is
    v_count    number;
    v_pcs_id   number;
  begin
    pcs_pcs_actions.start_process(p_initiating_procedure => 'pcs_pcs_actions_test.end_process_completes');

    v_pcs_id                    := sup_globals.get_global_number(p_name => 'PROCESS_ID');

    pcs_pcs_actions.end_process;

    select count(*)
      into v_count
      from pcs_processes pcs
     where id = v_pcs_id
       and pcs.pcs_end_utc is not null;

    ut.expect(v_count = 1).to_equal(true);

  end end_process_completes;

  procedure save_globals_in_log_lines is
    -- deze hoort misschien in een test-package voor pcs_log_actions
    v_count    number;
    v_pcs_id   number;
  begin
    pcs_pcs_actions.start_process(p_initiating_procedure => 'pcs_pcs_actions_test.save_globals_in_log_lines');

    v_pcs_id                    := sup_globals.get_global_number(p_name => 'PROCESS_ID');

    for indx in 1 .. 10 loop
      sup_globals.set_global(p_name  => 'TEST_GLOBAL_' || indx
                            ,p_value => indx);
    end loop;

    pcs_pcs_actions.end_process;

    select count(*)
      into v_count
      from pcs_technical_log_lines
     where pcs_id = v_pcs_id
       and severity = 'G';

    -- Alle globals hierboven gezet en in ieder geval PROCESS_ID en MAX_SEVERITY, dus minimaal 12
    ut.expect(v_count >= 12).to_equal(true);
  end save_globals_in_log_lines;

  procedure set_max_severity_e is
    v_count    number;
    v_pcs_id   number;
  begin
    pcs_pcs_actions.start_process(p_initiating_procedure => 'pcs_pcs_actions_test.set_max_severity_e');

    v_pcs_id                    := sup_globals.get_global_number(p_name => 'PROCESS_ID');

    for indx in 1 .. 10 loop
      pcs_log_actions.log_info(p_module  => 'pcs_pcs_actions_test.set_max_severity_e'
                              ,p_text    => 'Tekst ' || indx);
    end loop;

    pcs_log_actions.log_warning(p_module => 'pcs_pcs_actions_test.set_max_severity_e'
                               ,p_text   => 'Dit is een Warning');

    pcs_log_actions.log_error(p_module   => 'pcs_pcs_actions_test.set_max_severity_e'
                             ,p_text     => 'Dit is een Error');

    pcs_pcs_actions.end_process;

    select count(*)
      into v_count
      from pcs_processes
     where id = v_pcs_id
       and max_severity = 'E';

    ut.expect(v_count = 1).to_equal(true);
  end set_max_severity_e;

  procedure set_max_severity_w is
    v_count    number;
    v_pcs_id   number;
  begin
    pcs_pcs_actions.start_process(p_initiating_procedure => 'pcs_pcs_actions_test.set_max_severity_w');

    v_pcs_id                    := sup_globals.get_global_number(p_name => 'PROCESS_ID');

    for indx in 1 .. 10 loop
      pcs_log_actions.log_info(p_module  => 'pcs_pcs_actions_test.set_max_severity_w'
                              ,p_text    => 'Tekst ' || indx);
    end loop;

    pcs_log_actions.log_warning(p_module => 'pcs_pcs_actions_test.set_max_severity_w'
                               ,p_text   => 'Dit is een Warning');

    pcs_pcs_actions.end_process;

    select count(*)
      into v_count
      from pcs_processes
     where id = v_pcs_id
       and max_severity = 'W';

    ut.expect(v_count = 1).to_equal(true);
  end set_max_severity_w;

  procedure set_max_severity_i is
    v_count    number;
    v_pcs_id   number;
  begin
    pcs_pcs_actions.start_process(p_initiating_procedure => 'pcs_pcs_actions_test.set_max_severity_i');

    v_pcs_id                    := sup_globals.get_global_number(p_name => 'PROCESS_ID');

    for indx in 1 .. 10 loop
      pcs_log_actions.log_info(p_module  => 'pcs_pcs_actions_test.set_max_severity_i'
                              ,p_text    => 'Tekst ' || indx);
    end loop;

    pcs_pcs_actions.end_process;

    select count(*)
      into v_count
      from pcs_processes
     where id = v_pcs_id
       and max_severity = 'I';

    ut.expect(v_count = 1).to_equal(true);
  end set_max_severity_i;

end pcs_pcs_actions_test;
/