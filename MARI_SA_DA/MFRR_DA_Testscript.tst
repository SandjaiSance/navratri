PL/SQL Developer Test script 3.0
14
declare
  p_xml xmltype;
begin
  sup_utilities.set_session_english;
  pcs_pcs_actions.start_process(p_initiating_procedure => 'TestMFRR_DA');  
  
  p_xml := xmltype(:p_xmlt); 
  -- Call the procedure
  rcn_power_activations.process_activation_mfrr_da(p_result => :p_result,
                                                   p_xml => p_xml,
                                                   p_delivery => :p_delivery,
                                                   p_enqueue_time => :p_enqueue_time);
   pcs_pcs_actions.end_process;                                               
end;
4
p_result
1
OK
5
p_delivery
1
EQUALITY.RESERVES#ACTIVATION_MFRR_DA
5
p_enqueue_time
1
05-08-2026
12
p_xmlt
1
<CLOB>
4208
0
