create or replace trigger sup_wss_compound
for insert or update or delete
on sup_webservice_addresses
compound trigger
  /***********************************************************************************************************************
   Purpose    : Compound trigger for table sup_webservice_addresses

   Change history
   Date        Author            Version   Description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   17-02-2022  Nico Klaver       01.00.00  TRAN-5153 Creatie
   06-07-2025  Sandjai Ramasray  01.01.00  TRAN-8243 Correctie foutieve UTC-conversiepatronen.
  ***********************************************************************************************************************/
  cn_package   constant varchar2(100)             := 'sup_wss_compound';
  v_module              varchar2(100);

  v_lamu_user           varchar2(100)             := nvl(sys_context('USERENV','OS_USER'),USER);
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
       :new.id                 := sup_wss_seq.nextval;
       :new.tvalidity_loc_from := nvl(:new.tvalidity_loc_from  ,v_tvalidity_loc_from);
       :new.tvalidity_utc_from := nvl(:new.tvalidity_utc_from  ,v_tvalidity_utc_from);
       :new.lamu_user          := nvl(:new.lamu_user           ,v_lamu_user         );

     when updating  then
       v_module := cn_package||'.bur';
       if :new.id                    != :old.id
       or :new.delphi_database_name  != :old.delphi_database_name
       or :new.target_system         != :old.target_system then
         pcs_log_actions.log_error(p_module => v_module);
         raise e_nontransfer;
       end if;

       -- User en source kunnen gebruikt worden voor commentaar
       :new.tvalidity_loc_from := v_tvalidity_loc_from;
       :new.tvalidity_utc_from := v_tvalidity_utc_from;
       :new.lamu_user          := nvl(:new.lamu_user  , v_lamu_user  );

     when deleting  then
       v_module := cn_package||'.bdr';
       null;

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

end sup_wss_compound;
/
