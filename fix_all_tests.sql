-- Template voor alle test procedures:
-- Patroon dat werkt (van test_log_debug_with_text):

  --%test
  procedure test_log_XXX is
    l_count_before number;
    l_count_after number;
    l_severity varchar2(10);
    l_pcs_id number;
  begin
    -- Get current process ID
    l_pcs_id := sup_globals.get_number('PROCESS_ID');
    
    -- Count before
    select count(*)
      into l_count_before
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id;
    
    -- Log XXX message
    delphidba.pcs_log_actions.log_XXX(...);
    
    -- Count after
    select count(*)
      into l_count_after
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id;
    
    -- Check severity of last entry
    select severity
      into l_severity
      from pcs_technical_log_lines
     where pcs_id = l_pcs_id
       and id = (select max(id) from pcs_technical_log_lines where pcs_id = l_pcs_id);
    
    -- Verify one entry was added with correct severity
    ut.expect(l_count_after).to_be_greater_than(l_count_before);
    ut.expect(l_severity).to_equal('X');
  end test_log_XXX;
