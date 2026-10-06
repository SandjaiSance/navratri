set define off
set sqlblanklines on
set serveroutput on size unlimited
set echo off
set feedback off
set verify off
set heading off
set pagesize 0
set trimspool on
set termout on
whenever sqlerror continue
prompt START trigger deployment
prompt === AGS_DFN_COMPOUND ===
@@ags_dfn_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'AGS_DFN_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   AGS_DFN_COMPOUND');
  else
    dbms_output.put_line('FAIL AGS_DFN_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'AGS_DFN_COMPOUND' order by sequence;
prompt === AGS_EPN_COMPOUND ===
@@ags_epn_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'AGS_EPN_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   AGS_EPN_COMPOUND');
  else
    dbms_output.put_line('FAIL AGS_EPN_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'AGS_EPN_COMPOUND' order by sequence;
prompt === ATN_ATS_COMPOUND ===
@@atn_ats_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'ATN_ATS_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   ATN_ATS_COMPOUND');
  else
    dbms_output.put_line('FAIL ATN_ATS_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'ATN_ATS_COMPOUND' order by sequence;
prompt === ATN_CPY_COMPOUND ===
@@atn_cpy_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'ATN_CPY_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   ATN_CPY_COMPOUND');
  else
    dbms_output.put_line('FAIL ATN_CPY_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'ATN_CPY_COMPOUND' order by sequence;
prompt === ATN_RCC_COMPOUND ===
@@atn_rcc_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'ATN_RCC_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   ATN_RCC_COMPOUND');
  else
    dbms_output.put_line('FAIL ATN_RCC_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'ATN_RCC_COMPOUND' order by sequence;
prompt === BLN_ARE_COMPOUND ===
@@bln_are_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'BLN_ARE_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   BLN_ARE_COMPOUND');
  else
    dbms_output.put_line('FAIL BLN_ARE_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'BLN_ARE_COMPOUND' order by sequence;
prompt === BLN_ATE_COMPOUND ===
@@bln_ate_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'BLN_ATE_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   BLN_ATE_COMPOUND');
  else
    dbms_output.put_line('FAIL BLN_ATE_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'BLN_ATE_COMPOUND' order by sequence;
prompt === BLN_BLA_COMPOUND ===
@@bln_bla_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'BLN_BLA_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   BLN_BLA_COMPOUND');
  else
    dbms_output.put_line('FAIL BLN_BLA_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'BLN_BLA_COMPOUND' order by sequence;
prompt === BLN_BLA_VLE_COMPOUND ===
@@bln_bla_vle_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'BLN_BLA_VLE_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   BLN_BLA_VLE_COMPOUND');
  else
    dbms_output.put_line('FAIL BLN_BLA_VLE_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'BLN_BLA_VLE_COMPOUND' order by sequence;
prompt === BLN_BLS_COMPOUND ===
@@bln_bls_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'BLN_BLS_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   BLN_BLS_COMPOUND');
  else
    dbms_output.put_line('FAIL BLN_BLS_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'BLN_BLS_COMPOUND' order by sequence;
prompt === BLN_BLS_VLE_COMPOUND ===
@@bln_bls_vle_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'BLN_BLS_VLE_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   BLN_BLS_VLE_COMPOUND');
  else
    dbms_output.put_line('FAIL BLN_BLS_VLE_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'BLN_BLS_VLE_COMPOUND' order by sequence;
prompt === BLN_CTE_COMPOUND ===
@@bln_cte_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'BLN_CTE_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   BLN_CTE_COMPOUND');
  else
    dbms_output.put_line('FAIL BLN_CTE_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'BLN_CTE_COMPOUND' order by sequence;
prompt === BLN_CTP_COMPOUND ===
@@bln_ctp_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'BLN_CTP_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   BLN_CTP_COMPOUND');
  else
    dbms_output.put_line('FAIL BLN_CTP_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'BLN_CTP_COMPOUND' order by sequence;
prompt === BLN_CTY_COMPOUND ===
@@bln_cty_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'BLN_CTY_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   BLN_CTY_COMPOUND');
  else
    dbms_output.put_line('FAIL BLN_CTY_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'BLN_CTY_COMPOUND' order by sequence;
prompt === BLN_LBD_COMPOUND ===
@@bln_lbd_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'BLN_LBD_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   BLN_LBD_COMPOUND');
  else
    dbms_output.put_line('FAIL BLN_LBD_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'BLN_LBD_COMPOUND' order by sequence;
prompt === BLN_LCT_COMPOUND ===
@@bln_lct_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'BLN_LCT_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   BLN_LCT_COMPOUND');
  else
    dbms_output.put_line('FAIL BLN_LCT_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'BLN_LCT_COMPOUND' order by sequence;
prompt === BLN_OFD_COMPOUND ===
@@bln_ofd_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'BLN_OFD_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   BLN_OFD_COMPOUND');
  else
    dbms_output.put_line('FAIL BLN_OFD_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'BLN_OFD_COMPOUND' order by sequence;
prompt === BLN_PAN_COMPOUND ===
@@bln_pan_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'BLN_PAN_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   BLN_PAN_COMPOUND');
  else
    dbms_output.put_line('FAIL BLN_PAN_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'BLN_PAN_COMPOUND' order by sequence;
prompt === BLN_PAN_VLE_COMPOUND ===
@@bln_pan_vle_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'BLN_PAN_VLE_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   BLN_PAN_VLE_COMPOUND');
  else
    dbms_output.put_line('FAIL BLN_PAN_VLE_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'BLN_PAN_VLE_COMPOUND' order by sequence;
prompt === BLN_RCD_COMPOUND ===
@@bln_rcd_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'BLN_RCD_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   BLN_RCD_COMPOUND');
  else
    dbms_output.put_line('FAIL BLN_RCD_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'BLN_RCD_COMPOUND' order by sequence;
prompt === BLN_RCE_COMPOUND ===
@@bln_rce_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'BLN_RCE_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   BLN_RCE_COMPOUND');
  else
    dbms_output.put_line('FAIL BLN_RCE_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'BLN_RCE_COMPOUND' order by sequence;
prompt === BLN_RCL_COMPOUND ===
@@bln_rcl_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'BLN_RCL_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   BLN_RCL_COMPOUND');
  else
    dbms_output.put_line('FAIL BLN_RCL_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'BLN_RCL_COMPOUND' order by sequence;
prompt === BLN_SPE_COMPOUND ===
@@bln_spe_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'BLN_SPE_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   BLN_SPE_COMPOUND');
  else
    dbms_output.put_line('FAIL BLN_SPE_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'BLN_SPE_COMPOUND' order by sequence;
prompt === BLN_SPV_COMPOUND ===
@@bln_spv_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'BLN_SPV_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   BLN_SPV_COMPOUND');
  else
    dbms_output.put_line('FAIL BLN_SPV_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'BLN_SPV_COMPOUND' order by sequence;
prompt === DQF_DFN_COMPOUND ===
@@dqf_dfn_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'DQF_DFN_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   DQF_DFN_COMPOUND');
  else
    dbms_output.put_line('FAIL DQF_DFN_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'DQF_DFN_COMPOUND' order by sequence;
prompt === DQF_RST_COMPOUND ===
@@dqf_rst_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'DQF_RST_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   DQF_RST_COMPOUND');
  else
    dbms_output.put_line('FAIL DQF_RST_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'DQF_RST_COMPOUND' order by sequence;
prompt === EFT_EFT_COMPOUND ===
@@eft_eft_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'EFT_EFT_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   EFT_EFT_COMPOUND');
  else
    dbms_output.put_line('FAIL EFT_EFT_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'EFT_EFT_COMPOUND' order by sequence;
prompt === EFT_ENY_COMPOUND ===
@@eft_eny_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'EFT_ENY_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   EFT_ENY_COMPOUND');
  else
    dbms_output.put_line('FAIL EFT_ENY_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'EFT_ENY_COMPOUND' order by sequence;
prompt === EMT_SET_COMPOUND ===
@@emt_set_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'EMT_SET_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   EMT_SET_COMPOUND');
  else
    dbms_output.put_line('FAIL EMT_SET_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'EMT_SET_COMPOUND' order by sequence;
prompt === GNN_GCY_COMPOUND ===
@@gnn_gcy_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'GNN_GCY_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   GNN_GCY_COMPOUND');
  else
    dbms_output.put_line('FAIL GNN_GCY_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'GNN_GCY_COMPOUND' order by sequence;
prompt === GNN_GNNCPY_COMPOUND ===
@@gnn_gnncpy_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'GNN_GNNCPY_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   GNN_GNNCPY_COMPOUND');
  else
    dbms_output.put_line('FAIL GNN_GNNCPY_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'GNN_GNNCPY_COMPOUND' order by sequence;
prompt === MSE_OPE_COMPOUND ===
@@mse_ope_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'MSE_OPE_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   MSE_OPE_COMPOUND');
  else
    dbms_output.put_line('FAIL MSE_OPE_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'MSE_OPE_COMPOUND' order by sequence;
prompt === PCS_ADE_COMPOUND ===
@@pcs_ade_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'PCS_ADE_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   PCS_ADE_COMPOUND');
  else
    dbms_output.put_line('FAIL PCS_ADE_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'PCS_ADE_COMPOUND' order by sequence;
prompt === PCS_DLE_COMPOUND ===
@@pcs_dle_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'PCS_DLE_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   PCS_DLE_COMPOUND');
  else
    dbms_output.put_line('FAIL PCS_DLE_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'PCS_DLE_COMPOUND' order by sequence;
prompt === PCS_JSR_COMPOUND ===
@@pcs_jsr_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'PCS_JSR_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   PCS_JSR_COMPOUND');
  else
    dbms_output.put_line('FAIL PCS_JSR_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'PCS_JSR_COMPOUND' order by sequence;
prompt === PCS_THE_COMPOUND ===
@@pcs_the_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'PCS_THE_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   PCS_THE_COMPOUND');
  else
    dbms_output.put_line('FAIL PCS_THE_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'PCS_THE_COMPOUND' order by sequence;
prompt === PCS_TLV_COMPOUND ===
@@pcs_tlv_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'PCS_TLV_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   PCS_TLV_COMPOUND');
  else
    dbms_output.put_line('FAIL PCS_TLV_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'PCS_TLV_COMPOUND' order by sequence;
prompt === PCS_TRY_COMPOUND ===
@@pcs_try_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'PCS_TRY_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   PCS_TRY_COMPOUND');
  else
    dbms_output.put_line('FAIL PCS_TRY_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'PCS_TRY_COMPOUND' order by sequence;
prompt === STAGE_MIT_COMPOUND ===
@@stage_mit_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'STAGE_MIT_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   STAGE_MIT_COMPOUND');
  else
    dbms_output.put_line('FAIL STAGE_MIT_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'STAGE_MIT_COMPOUND' order by sequence;
prompt === STT_CGT_COMPOUND ===
@@stt_cgt_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'STT_CGT_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   STT_CGT_COMPOUND');
  else
    dbms_output.put_line('FAIL STT_CGT_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'STT_CGT_COMPOUND' order by sequence;
prompt === STT_RCE_COMPOUND ===
@@stt_rce_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'STT_RCE_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   STT_RCE_COMPOUND');
  else
    dbms_output.put_line('FAIL STT_RCE_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'STT_RCE_COMPOUND' order by sequence;
prompt === STT_RCEVLE_COMPOUND ===
@@stt_rcevle_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'STT_RCEVLE_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   STT_RCEVLE_COMPOUND');
  else
    dbms_output.put_line('FAIL STT_RCEVLE_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'STT_RCEVLE_COMPOUND' order by sequence;
prompt === STT_RVE_COMPOUND ===
@@stt_rve_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'STT_RVE_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   STT_RVE_COMPOUND');
  else
    dbms_output.put_line('FAIL STT_RVE_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'STT_RVE_COMPOUND' order by sequence;
prompt === STT_RVEVLE_COMPOUND ===
@@stt_rvevle_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'STT_RVEVLE_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   STT_RVEVLE_COMPOUND');
  else
    dbms_output.put_line('FAIL STT_RVEVLE_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'STT_RVEVLE_COMPOUND' order by sequence;
prompt === SUP_NEE_COMPOUND ===
@@sup_nee_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'SUP_NEE_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   SUP_NEE_COMPOUND');
  else
    dbms_output.put_line('FAIL SUP_NEE_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'SUP_NEE_COMPOUND' order by sequence;
prompt === SUP_WSS_COMPOUND ===
@@sup_wss_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'SUP_WSS_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   SUP_WSS_COMPOUND');
  else
    dbms_output.put_line('FAIL SUP_WSS_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'SUP_WSS_COMPOUND' order by sequence;
prompt === TCY_CCY_COMPOUND ===
@@tcy_ccy_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'TCY_CCY_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   TCY_CCY_COMPOUND');
  else
    dbms_output.put_line('FAIL TCY_CCY_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'TCY_CCY_COMPOUND' order by sequence;
prompt === TCY_CPY_COMPOUND ===
@@tcy_cpy_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'TCY_CPY_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   TCY_CPY_COMPOUND');
  else
    dbms_output.put_line('FAIL TCY_CPY_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'TCY_CPY_COMPOUND' order by sequence;
prompt === TCY_ECY_COMPOUND ===
@@tcy_ecy_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'TCY_ECY_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   TCY_ECY_COMPOUND');
  else
    dbms_output.put_line('FAIL TCY_ECY_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'TCY_ECY_COMPOUND' order by sequence;
prompt === TCY_NPC_COMPOUND ===
@@tcy_npc_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'TCY_NPC_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   TCY_NPC_COMPOUND');
  else
    dbms_output.put_line('FAIL TCY_NPC_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'TCY_NPC_COMPOUND' order by sequence;
prompt === TCY_NPN_COMPOUND ===
@@tcy_npn_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'TCY_NPN_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   TCY_NPN_COMPOUND');
  else
    dbms_output.put_line('FAIL TCY_NPN_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'TCY_NPN_COMPOUND' order by sequence;
prompt === TCY_SEE_COMPOUND ===
@@tcy_see_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'TCY_SEE_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   TCY_SEE_COMPOUND');
  else
    dbms_output.put_line('FAIL TCY_SEE_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'TCY_SEE_COMPOUND' order by sequence;
prompt === TCY_TCY_COMPOUND ===
@@tcy_tcy_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'TCY_TCY_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   TCY_TCY_COMPOUND');
  else
    dbms_output.put_line('FAIL TCY_TCY_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'TCY_TCY_COMPOUND' order by sequence;
prompt === TDE_PCE_COMPOUND ===
@@tde_pce_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'TDE_PCE_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   TDE_PCE_COMPOUND');
  else
    dbms_output.put_line('FAIL TDE_PCE_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'TDE_PCE_COMPOUND' order by sequence;
prompt === TPT_RDE_COMPOUND ===
@@tpt_rde_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'TPT_RDE_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   TPT_RDE_COMPOUND');
  else
    dbms_output.put_line('FAIL TPT_RDE_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'TPT_RDE_COMPOUND' order by sequence;
prompt === TPT_RDEVL_COMPOUND ===
@@tpt_rdevl_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'TPT_RDEVL_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   TPT_RDEVL_COMPOUND');
  else
    dbms_output.put_line('FAIL TPT_RDEVL_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'TPT_RDEVL_COMPOUND' order by sequence;
prompt === TPT_RDT_COMPOUND ===
@@tpt_rdt_compound.trg
declare
  l_cnt number;
begin
  select count(*) into l_cnt from user_errors where type = 'TRIGGER' and name = 'TPT_RDT_COMPOUND';
  if l_cnt = 0 then
    dbms_output.put_line('OK   TPT_RDT_COMPOUND');
  else
    dbms_output.put_line('FAIL TPT_RDT_COMPOUND');
  end if;
end;
/
select '  line ' || line || ':' || position || ' ' || text from user_errors where type = 'TRIGGER' and name = 'TPT_RDT_COMPOUND' order by sequence;
prompt DONE trigger deployment
