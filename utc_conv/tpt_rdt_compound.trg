create or replace trigger tpt_rdt_compound
  for insert or update or delete
  on tpt_redispatch_affected_assets
  compound trigger
  /***********************************************************************************************************************
   Purpose    : Compound trigger for table tpt_redispatch_affected_assets

   Change history
   Date        Author            Version   Description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   16-02-2023  Y. Krop           01.00.00  TRAN-6007 Created
   06-07-2025  Sandjai Ramasray  01.01.00  TRAN-8243 Correctie foutieve UTC-conversiepatronen.
  ***********************************************************************************************************************/
  cn_package            constant     varchar2(100)             := 'tpt_rdt_compound';
  v_module                           varchar2(100);

  v_idx                              simple_integer            := 0;

  v_lamu_user                        varchar2(100)             := nvl(sys_context('USERENV','OS_USER'),USER);
  v_tvalidity_utc_from               timestamp                 := sys_extract_utc(systimestamp);
  v_tvalidity_loc_from               timestamp                 := sup_date_actions.convertutc2local(p_utc_date => v_tvalidity_utc_from);
  v_lamu_source                      varchar2(100)             := nvl(sup_globals.get_global_varchar  (p_name  => 'SOURCE_SYSTEM'     ), sup_constants.cn_unknown);
  v_lamu_pcs_id                      varchar2(100)             := nvl(sup_globals.get_global_number   (p_name  => 'PROCESS_ID'        ), sup_constants.cn_negative_infinite_number);

  e_nontransfer                      exception;

  -- BEFORE STATEMENT Section:
  before statement is
  begin
    v_module := cn_package ||'.bst';
    -- Begin Initializations
    -- Clear the plsql-table, because within one session intdba can handle more than one xml-message.
    -- When previous went wrong there is still old data in the table
    tpt_rdt_actions.clear_plsql_table;
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
    tpt_rdt_actions.journal_rows;
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
       :new.id                  := nvl(:new.id                  ,tpt_rdt_seq.nextval    );
       :new.lamu_user           := nvl(:new.lamu_user           ,v_lamu_user            );
       :new.tvalidity_loc_from  := nvl(:new.tvalidity_loc_from  ,v_tvalidity_loc_from   );
       :new.tvalidity_utc_from  := nvl(:new.tvalidity_utc_from  ,v_tvalidity_utc_from   );
       :new.lamu_source         := nvl(:new.lamu_source         ,v_lamu_source          );
       :new.lamu_pcs_id         := nvl(:new.lamu_pcs_id         ,v_lamu_pcs_id          );

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

  -- AFTER EACH ROW Section:
  after each row is
  begin
    v_module := cn_package ||'.ar';
    v_idx := nvl(tpt_rdt_actions.t_rdt_tab.count, 0) + 1;
    tpt_rdt_actions.t_rdt_tab(v_idx).jn_cre_user             := v_lamu_user             ;
    tpt_rdt_actions.t_rdt_tab(v_idx).tvalidity_loc_to        := v_tvalidity_loc_from    ;
    tpt_rdt_actions.t_rdt_tab(v_idx).tvalidity_utc_to        := v_tvalidity_utc_from    ;
    tpt_rdt_actions.t_rdt_tab(v_idx).jn_cre_source           := v_lamu_source           ;
    tpt_rdt_actions.t_rdt_tab(v_idx).jn_cre_pcs_id           := v_lamu_pcs_id           ;

    case
      when inserting then
        v_module := cn_package||'.air';
        tpt_rdt_actions.t_rdt_tab(v_idx).jn_action           := 'INS'                   ;
        tpt_rdt_actions.t_rdt_tab(v_idx).id                  := :new.id                 ;
        tpt_rdt_actions.t_rdt_tab(v_idx).rde_id              := :new.rde_id             ;
        tpt_rdt_actions.t_rdt_tab(v_idx).nob_code            := :new.nob_code           ;
        tpt_rdt_actions.t_rdt_tab(v_idx).nob_code_type       := :new.nob_code_type      ;
        tpt_rdt_actions.t_rdt_tab(v_idx).nob_object_type     := :new.nob_object_type    ;
        tpt_rdt_actions.t_rdt_tab(v_idx).problem_description := :new.problem_description;
        tpt_rdt_actions.t_rdt_tab(v_idx).bvalidity_utc_from  := :new.bvalidity_utc_from ;
        tpt_rdt_actions.t_rdt_tab(v_idx).bvalidity_utc_to    := :new.bvalidity_utc_to   ;
        tpt_rdt_actions.t_rdt_tab(v_idx).tvalidity_utc_from  := :new.tvalidity_utc_from ;
        tpt_rdt_actions.t_rdt_tab(v_idx).tvalidity_loc_from  := :new.tvalidity_loc_from ;
        tpt_rdt_actions.t_rdt_tab(v_idx).lamu_user           := :new.lamu_user          ;
        tpt_rdt_actions.t_rdt_tab(v_idx).lamu_source         := :new.lamu_source        ;
        tpt_rdt_actions.t_rdt_tab(v_idx).lamu_pcs_id         := :new.lamu_pcs_id        ;

      when updating  then
        v_module  := cn_package||'.aur';
        tpt_rdt_actions.t_rdt_tab(v_idx).jn_action           := 'UPD'                   ;
        tpt_rdt_actions.t_rdt_tab(v_idx).id                  := :old.id                 ;
        tpt_rdt_actions.t_rdt_tab(v_idx).rde_id              := :old.rde_id             ;
        tpt_rdt_actions.t_rdt_tab(v_idx).nob_code            := :old.nob_code           ;
        tpt_rdt_actions.t_rdt_tab(v_idx).nob_code_type       := :old.nob_code_type      ;
        tpt_rdt_actions.t_rdt_tab(v_idx).nob_object_type     := :old.nob_object_type    ;
        tpt_rdt_actions.t_rdt_tab(v_idx).problem_description := :old.problem_description;
        tpt_rdt_actions.t_rdt_tab(v_idx).bvalidity_utc_from  := :old.bvalidity_utc_from ;
        tpt_rdt_actions.t_rdt_tab(v_idx).bvalidity_utc_to    := :old.bvalidity_utc_to   ;
        tpt_rdt_actions.t_rdt_tab(v_idx).tvalidity_utc_from  := :old.tvalidity_utc_from ;
        tpt_rdt_actions.t_rdt_tab(v_idx).tvalidity_loc_from  := :old.tvalidity_loc_from ;
        tpt_rdt_actions.t_rdt_tab(v_idx).lamu_user           := :old.lamu_user          ;
        tpt_rdt_actions.t_rdt_tab(v_idx).lamu_source         := :old.lamu_source        ;
        tpt_rdt_actions.t_rdt_tab(v_idx).lamu_pcs_id         := :old.lamu_pcs_id        ;

      when deleting  then
        v_module  := cn_package||'.adr';
        tpt_rdt_actions.t_rdt_tab(v_idx).jn_action           := 'DEL'                   ;
        tpt_rdt_actions.t_rdt_tab(v_idx).id                  := :old.id                 ;
        tpt_rdt_actions.t_rdt_tab(v_idx).rde_id              := :old.rde_id             ;
        tpt_rdt_actions.t_rdt_tab(v_idx).nob_code            := :old.nob_code           ;
        tpt_rdt_actions.t_rdt_tab(v_idx).nob_code_type       := :old.nob_code_type      ;
        tpt_rdt_actions.t_rdt_tab(v_idx).nob_object_type     := :old.nob_object_type    ;
        tpt_rdt_actions.t_rdt_tab(v_idx).problem_description := :old.problem_description;
        tpt_rdt_actions.t_rdt_tab(v_idx).bvalidity_utc_from  := :old.bvalidity_utc_from ;
        tpt_rdt_actions.t_rdt_tab(v_idx).bvalidity_utc_to    := :old.bvalidity_utc_to   ;
        tpt_rdt_actions.t_rdt_tab(v_idx).tvalidity_utc_from  := :old.tvalidity_utc_from ;
        tpt_rdt_actions.t_rdt_tab(v_idx).tvalidity_loc_from  := :old.tvalidity_loc_from ;
        tpt_rdt_actions.t_rdt_tab(v_idx).lamu_user           := :old.lamu_user          ;
        tpt_rdt_actions.t_rdt_tab(v_idx).lamu_source         := :old.lamu_source        ;
        tpt_rdt_actions.t_rdt_tab(v_idx).lamu_pcs_id         := :old.lamu_pcs_id        ;

    end case;
  exception
    when others then
      pcs_log_actions.log_error(p_module => v_module);
      raise;
  end after each row;

end tpt_rdt_compound;
/
