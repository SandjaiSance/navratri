create or replace PACKAGE           xxut_processes is

  /*********************************************************************************************************************
   Purpose    : Utility package for managing test processes for utPLSQL test suites
   
   Change History
   
   Date        Author            Version   Description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   09-12-2024  Test Suite        01.00.00  Initial creation

  *********************************************************************************************************************/

  function get_versionnumber return varchar2;

  procedure create_test_process(
    p_test_suite_name in varchar2
  );

  procedure delete_test_process;

end xxut_processes;
