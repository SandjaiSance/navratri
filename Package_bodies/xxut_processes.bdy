create or replace PACKAGE BODY           xxut_processes is

  /*********************************************************************************************************************
   Purpose    : Utility package for managing test processes for utPLSQL test suites
   
   Change History
   
   Date        Author            Version   Description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   09-12-2024  Test Suite        01.00.00  Initial creation

  *********************************************************************************************************************/

  cn_package          constant varchar2(100) := 'XXUT_PROCESSES';
  cn_versionnumber    constant varchar2(100) := '01.00.00';

  function get_versionnumber return varchar2 is
  begin
    return cn_versionnumber;
  end get_versionnumber;

  procedure create_test_process(
    p_test_suite_name in varchar2
  ) is
  begin
    -- Create a new process entry using pcs_pcs_actions
    -- This also sets the PROCESS_ID global
    pcs_pcs_actions.start_process(
      p_initiating_procedure => 'ut.' || p_test_suite_name
    );
  end create_test_process;

  procedure delete_process_recursive(
    p_process_id in number
  ) is
    l_child_process_id number;
    cursor c_child_processes is
      select id from pcs_processes where parent_pcs_id = p_process_id;
  begin
    -- Recursively delete all child processes first
    for r_child in c_child_processes loop
      delete_process_recursive(r_child.id);
    end loop;

    -- Delete dependent records for this process
    delete from pcs_globals where pcs_id = p_process_id;
    delete from pcs_mge_check_results where pcs_id = p_process_id;
    delete from pcs_rcn_states where pcs_id = p_process_id;
    delete from pcs_rcn_receptions where pcs_id = p_process_id;
    delete from pcs_technical_log_lines where pcs_id = p_process_id;
    delete from pcs_tmn_states where pcs_id = p_process_id;
    delete from pcs_tmn_transmissions where pcs_id = p_process_id;
    delete from pcs_xml_messages where pcs_id = p_process_id;
    delete from pcs_akt_acknowledgements where pcs_id = p_process_id;

    -- Delete the process entry
    delete from pcs_processes where id = p_process_id;
  end delete_process_recursive;

  procedure delete_test_process is
    l_process_id number;
  begin
    -- Retrieve process ID from global PROCESS_ID
    l_process_id := sup_globals.get_global_number('PROCESS_ID');

    -- Recursively delete the process and all its children
    delete_process_recursive(l_process_id);

    commit;
  end delete_test_process;

end xxut_processes;