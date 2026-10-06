create or replace trigger stage_mit_compound
for insert or update or delete
on stage_mrd_imports
compound trigger
  /*********************************************************************************************************************
   Purpose    : Trigger for table stage_mrd_imports

   Change History
   Date        Author            Version   Description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   30-10-2023  Y. Krop           01.00.00  Creation
   06-07-2025  Sandjai Ramasray  01.01.00  TRAN-8243 Correctie foutieve UTC-conversiepatronen.
  **********************************************************************************************************************/

  cn_package constant  varchar2(100)             := 'stage_mit_compound';

  v_lamu_pcs_id        varchar2(100)             := nvl(sup_globals.get_global_number(p_name => 'PROCESS_ID'), sup_constants.cn_negative_infinite_number);
  v_lamu_user          varchar2(100)             := nvl(sys_context('USERENV','OS_USER'),USER);
  v_module             varchar2(100);
  v_tvalidity_utc_from timestamp                 := sys_extract_utc(systimestamp);
  v_tvalidity_loc_from timestamp                 := sup_date_actions.convertutc2local(p_utc_date => v_tvalidity_utc_from);

  e_nontransfer  exception;

  -- BEFORE STATEMENT Section:
  before statement is
  begin
    v_module := cn_package ||'.bst';
    -- Begin Initializations
    null;
    -- End Initializations
  exception
    when others then
      pcs_log_actions.log_error(p_module => v_module);
      raise;
  end before statement;

  -- AFTER STATEMENT Section:
  after statement is
  begin
    v_module := cn_package ||'.ast';
    -- Begin Finalization
    null;
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
       v_module := cn_package ||'.bir';
       -- set values for auditing columns nvl for if client-side indented values are given
       :new.id                  := stage_mit_seq.nextval;
       :new.tvalidity_utc_from  := nvl(:new.tvalidity_utc_from  ,v_tvalidity_utc_from   );
       :new.tvalidity_loc_from  := nvl(:new.tvalidity_loc_from  ,v_tvalidity_loc_from   );
       :new.lamu_pcs_id         := nvl(:new.lamu_pcs_id         ,v_lamu_pcs_id  );

     when updating  then
       v_module := cn_package ||'.bur';
       -- set values for auditing columns nvl for if client-side indented values are given

       if (:new.id <> :old.id) then
         pcs_log_actions.log_error(p_module => v_module);
         raise e_nontransfer;
       end if;

--       :new.tvalidity_loc_from := v_tvalidity_loc_from;
       :new.tvalidity_utc_from := v_tvalidity_utc_from;

       -- lamu_pcs_id behouden als update niet vanuit het reguliere proces gedaan wordt
       if lower(v_lamu_user) = 'oracle' then
          :new.lamu_pcs_id     := v_lamu_pcs_id;
       else
          :new.lamu_pcs_id     := :old.lamu_pcs_id;
       end if;

     when deleting  then
       v_module := cn_package ||'.bdr';
       -- set NO values for auditing columns
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

end stage_mit_compound;
/

