create or replace trigger pcs_ade_compound
for insert or update or delete
on pcs_acer_data_exchange
compound trigger

  /***********************************************************************************************************************
   purpose    : compound trigger for table pcs_acer_data_exchange

   change history
   date        author            version   description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   13-04-2021  R. Standhaft      01.00.00   created
   06-07-2025  Sandjai Ramasray  01.01.00   TRAN-8243 Correctie foutieve UTC-conversiepatronen.
  ***********************************************************************************************************************/

  cn_package   constant varchar2(100)             := 'pcs_ade_compound';
  v_module              varchar2(100);

  v_idx                 simple_integer            := 0;

  v_lamu_user           varchar2(100)             := nvl(sys_context('USERENV', 'OS_USER'), USER);
  v_tvalidity_utc_from	timestamp                  := sys_extract_utc(systimestamp);
  v_tvalidity_loc_from	timestamp                  := sup_date_actions.convertutc2local(p_utc_date => v_tvalidity_utc_from);

  e_nontransfer  	exception;

  -- BEFORE STATEMENT Section:
  before statement is
  begin
    v_module := cn_package || '.bst';
    -- Begin Initializations
    -- End Initializations
  exception
    when others then
      pcs_log_actions.log_error(p_module => v_module);
      raise;
  end before statement;

  -- AFTER STATEMENT Section:
  after statement is
  begin
    v_module := cn_package || '.ast';
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
       v_module                 	:= cn_package || '.bir';
       :new.id                  	:= nvl(:new.id                  , pcs_acer_seq.nextval	);
       :new.lamu_user           	:= nvl(:new.lamu_user           , v_lamu_user          	);
       :new.tvalidity_loc_from		:= nvl(:new.tvalidity_loc_from	, v_tvalidity_loc_from  );
       :new.tvalidity_utc_from		:= nvl(:new.tvalidity_utc_from	, v_tvalidity_utc_from  );

     when updating  then
       v_module := cn_package || '.bur';
       if (:new.id <> :old.id) then
         pcs_log_actions.log_error(p_module => v_module);
         raise e_nontransfer;
       end if;
       -- User en source kunnen gebruikt worden voor commentaar
       :new.lamu_user			:= nvl(:new.lamu_user           , v_lamu_user         	);
       :new.tvalidity_loc_from       	:= nvl(:new.tvalidity_loc_from	, systimestamp          );
       :new.tvalidity_utc_from        := nvl(:new.tvalidity_utc_from  , sys_extract_utc(systimestamp) );

     when deleting  then
       v_module := cn_package || '.bdr';

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
    v_module := cn_package || '.ar';
    null;

  exception
    when others then
      pcs_log_actions.log_error(p_module => v_module);
      raise;
  end after each row;

end pcs_ade_compound;
/
