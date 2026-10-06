create or replace trigger bln_bls_compound
for insert or update or delete
on bln_balance_delta_high_res 
compound trigger
  /************************************************************************************************************************************************
   Purpose    : Compound trigger for table bln_balance_delta_high_res

   Change history
   Date        Author            Version   Description
   ----------  ----------------  --------  --------------------------------------------------------------------------------------------------------
   29-01-2026  Sandjai Ramasray  01.00.00  TRAN-7421 Created
   06-07-2025  Sandjai Ramasray  01.01.00  TRAN-8243 Correctie foutieve UTC-conversiepatronen.
***************************************************************************************************************************************************/
  cn_package   constant varchar2(100)             := 'bln_bls_compound';
  v_module              varchar2(100);

  v_idx                 simple_integer            := 0;

  v_lamu_user           varchar2(100)             := nvl(sys_context('USERENV','OS_USER'),user);
  v_tvalidity_utc_from  timestamp                 := sys_extract_utc(systimestamp);
  v_tvalidity_loc_from  timestamp                 := sup_date_actions.convertutc2local(p_utc_date => v_tvalidity_utc_from);
  v_lamu_source         varchar2(100)             := nvl(sup_globals.get_global_varchar(p_name => 'SOURCE_SYSTEM'), 'UNKNOWN');
  v_lamu_pcs_id         varchar2(100)             := nvl(sup_globals.get_global_number(p_name => 'PROCESS_ID'),sup_constants.cn_negative_infinite_number);

  e_nontransfer         exception;

  -- BEFORE EACH ROW Section:
  before each row is
  begin
    case
     when inserting then
       v_module                 := cn_package ||'.bir';
       :new.id                  := nvl(:new.id                  ,bln_bls_seq.nextval);
       :new.lamu_user           := nvl(:new.lamu_user           ,v_lamu_user    );

       :new.tvalidity_utc_from  := nvl(:new.tvalidity_utc_from  ,v_tvalidity_utc_from);
       :new.tvalidity_loc_from  := nvl(:new.tvalidity_loc_from  ,v_tvalidity_loc_from);
       :new.lamu_pcs_id         := nvl(:new.lamu_pcs_id         ,v_lamu_pcs_id  );
       :new.lamu_source         := nvl(:new.lamu_source         ,v_lamu_source  );

     when updating  then
       v_module := cn_package ||'.bur';
       if (:new.id <> :old.id) then
         pcs_log_actions.log_error(p_module => v_module);
         raise e_nontransfer;
       end if;
       -- User en source kunnen gebruikt worden voor commentaar
       :new.lamu_user          := nvl(:new.lamu_user           ,v_lamu_user);
       :new.lamu_source        := nvl(:new.lamu_source         ,v_lamu_source);
       :new.tvalidity_loc_from := v_tvalidity_loc_from;
       :new.tvalidity_utc_from := v_tvalidity_utc_from;

       -- lamu_pcs_id behouden als update niet vanuit het reguliere proces gedaan wordt
       if lower(v_lamu_user) = 'oracle' then
          :new.lamu_pcs_id     := v_lamu_pcs_id;
       else
          :new.lamu_pcs_id     := :old.lamu_pcs_id;
       end if;

     when deleting  then
       v_module := cn_package ||'.bdr';
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

end bln_bls_compound;
/
