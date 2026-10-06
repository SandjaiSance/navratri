create or replace trigger pcs_tlv_compound
  for insert or update or delete
   on pcs_tmn_last_published_values
compound trigger
  /***********************************************************************************************************************
   Purpose    : Compound trigger for table pcs_tmn_last_published_values

   Change history
   Date        Author            Version   Description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   05-07-2018  Y. Krop           01.00.00  Created
   26-05-2020  T. Bakker         01.00.01  TRAN-4036: timestamp vervangen door timestamp with time zone vanwege Z/W tijd   
   16-12-2022  X. Pikaar         01.01.00  TRAN-5965: lamu_pcs_id behouden als wijziging niet vanuit het normale proces komt 
   06-07-2025  Sandjai Ramasray  01.02.00  TRAN-8243 Correctie foutieve UTC-conversiepatronen.
                                           (osuser is dan oracle)
  ***********************************************************************************************************************/
  cn_package   constant varchar2(100)             := 'pcs_tlv_compound';
  v_module              varchar2(100);

  v_lamu_user           varchar2(100)             := nvl(sys_context('USERENV', 'OS_USER'), USER);
  v_lamu_pcs_id         varchar2(100)             := nvl(sup_globals.get_global_number(p_name => 'PROCESS_ID'),sup_constants.cn_negative_infinite_number);
  v_tvalidity_utc_from  timestamp                 := sys_extract_utc(systimestamp);
  v_tvalidity_loc_from  timestamp                 := sup_date_actions.convertutc2local(p_utc_date => v_tvalidity_utc_from);
  e_nontransfer         exception;

  -- BEFORE STATEMENT Section:
  before statement is
  begin
    v_module := cn_package||'.bst';
    -- Begin Initializations
    -- Clear the plsql-table, because within one session intdba can handle more than one xml-message.
    -- When previous went wrong there is still old data in the table
    --!!!tmn_actions.clear_plsql_table;
    -- End Initializations
  exception
    when others then
      pcs_log_actions.log_error(p_module => v_module);
      raise;
  end before statement;

  -- AFTER STATEMENT Section:
  after statement is
  begin
    v_module := cn_package||'.ast';
    -- Begin Finalization
    -- End Finalization
  exception
    when others then
      pcs_log_actions.log_error(p_module => v_module);
      raise;
  end after statement;

  -- BEFORE EACH ROW Section:
  before each row is
  begin
    case
     when inserting then
       v_module := cn_package||'.bir';
       :new.id                 := nvl(:new.id                , pcs_tlv_seq.nextval);
       :new.lamu_user          := nvl(:new.lamu_user         , v_lamu_user);
       :new.tvalidity_loc_from := nvl(:new.tvalidity_loc_from, v_tvalidity_loc_from);
       :new.tvalidity_utc_from := nvl(:new.tvalidity_utc_from, v_tvalidity_utc_from);
       :new.lamu_pcs_id        := nvl(:new.lamu_pcs_id       , v_lamu_pcs_id);

     when updating  then
       v_module := cn_package||'.bur';
       if (:new.id <> :old.id) then
         pcs_log_actions.log_error(p_module => v_module);
         raise e_nontransfer;
       end if;

       -- lamu_pcs_id behouden als update niet vanuit het reguliere proces gedaan wordt
       if lower(v_lamu_user) = 'oracle' then
          :new.lamu_pcs_id     := v_lamu_pcs_id;
       else
          :new.lamu_pcs_id     := :old.lamu_pcs_id;
       end if;          

     when deleting  then
       v_module := cn_package||'.bdr';
    end case;
  exception
    when e_nontransfer then
      pcs_log_actions.log_error(p_module => v_module);
      raise;
    when others then
      pcs_log_actions.log_error(p_module => v_module);
      raise;
  end before each row;

  -- AFTER EACH ROW Section:
  after each row is
  begin
    null;
  exception
    when others then
      pcs_log_actions.log_error(p_module => v_module);
      raise;
  end after each row;

end pcs_tlv_compound;
/
