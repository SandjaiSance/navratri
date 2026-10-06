create or replace trigger tpt_rdevl_compound
  for insert or update or delete
  on tpt_redispatch_values
  compound trigger
  /***********************************************************************************************************************
   purpose    : compound trigger for table tpt_redispatch_values

   change history
   date        author            version   description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   28-09-2022  Nico Klaver       01.00.00  TRAN-5766 Created.
   16-12-2022  X. Pikaar         01.01.00  TRAN-5965: lamu_pcs_id behouden als wijziging niet vanuit het normale proces komt 
   06-07-2025  Sandjai Ramasray  01.02.00  TRAN-8243 Correctie foutieve UTC-conversiepatronen.
                                           (osuser is dan oracle)
  ***********************************************************************************************************************/
  cn_package            constant     varchar2(100)             := 'tpt_rdevl_compound';
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
    tpt_rdevl_actions.clear_plsql_table;
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
    tpt_rdevl_actions.journal_rows;
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
       :new.lamu_user           := nvl(:new.lamu_user           ,v_lamu_user            );
       :new.tvalidity_loc_from  := nvl(:new.tvalidity_loc_from  ,v_tvalidity_loc_from   );
       :new.tvalidity_utc_from  := nvl(:new.tvalidity_utc_from  ,v_tvalidity_utc_from   );
       :new.lamu_source         := nvl(:new.lamu_source         ,v_lamu_source          );
       :new.lamu_pcs_id         := nvl(:new.lamu_pcs_id         ,v_lamu_pcs_id          );

     when updating  then
       v_module := cn_package ||'.bur';
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
    v_idx := nvl(tpt_rdevl_actions.t_rdevl_tab.count, 0) + 1;
    tpt_rdevl_actions.t_rdevl_tab(v_idx).jn_cre_user               := v_lamu_user                              ;
    tpt_rdevl_actions.t_rdevl_tab(v_idx).tvalidity_loc_to          := v_tvalidity_loc_from                     ;
    tpt_rdevl_actions.t_rdevl_tab(v_idx).tvalidity_utc_to          := v_tvalidity_utc_from                     ;
    tpt_rdevl_actions.t_rdevl_tab(v_idx).jn_cre_source             := v_lamu_source                            ;
    tpt_rdevl_actions.t_rdevl_tab(v_idx).jn_cre_pcs_id             := v_lamu_pcs_id                            ;

    case
      when inserting then
        v_module := cn_package||'.air';
        tpt_rdevl_actions.t_rdevl_tab(v_idx).jn_action                      := 'INS'                           ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).bvalidity_utc_from             := :new.bvalidity_utc_from         ; 
        tpt_rdevl_actions.t_rdevl_tab(v_idx).bvalidity_utc_to               := :new.bvalidity_utc_to           ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).rde_id                         := :new.rde_id                     ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).order_id                       := :new.order_id                   ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).nde_code                       := :new.nde_code                   ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).nde_code_type                  := :new.nde_code_type              ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).nde_object_type                := :new.nde_object_type            ;   
        tpt_rdevl_actions.t_rdevl_tab(v_idx).trading_company_name           := :new.trading_company_name       ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).value_meaning                  := :new.value_meaning              ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).ptu_resolution                 := :new.ptu_resolution             ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).ptu_date_loc                   := :new.ptu_date_loc               ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).ptu                            := :new.ptu                        ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).capacity                       := :new.capacity                   ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).capacity_unit_name             := :new.capacity_unit_name         ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).price                          := :new.price                      ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).price_unit_name                := :new.price_unit_name            ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).price_measurement_unit_name    := :new.price_measurement_unit_name; 
        tpt_rdevl_actions.t_rdevl_tab(v_idx).tvalidity_utc_from             := :new.tvalidity_utc_from         ;    
        tpt_rdevl_actions.t_rdevl_tab(v_idx).tvalidity_loc_from             := :new.tvalidity_loc_from         ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).lamu_user                      := :new.lamu_user                  ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).lamu_source                    := :new.lamu_source                ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).lamu_pcs_id                    := :new.lamu_pcs_id                ;

      when updating  then
        v_module  := cn_package||'.aur';
        tpt_rdevl_actions.t_rdevl_tab(v_idx).jn_action                      := 'UPD'                           ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).bvalidity_utc_from             := :old.bvalidity_utc_from         ; 
        tpt_rdevl_actions.t_rdevl_tab(v_idx).bvalidity_utc_to               := :old.bvalidity_utc_to           ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).rde_id                         := :old.rde_id                     ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).order_id                       := :old.order_id                   ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).nde_code                       := :old.nde_code                   ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).nde_code_type                  := :old.nde_code_type              ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).nde_object_type                := :old.nde_object_type            ;   
        tpt_rdevl_actions.t_rdevl_tab(v_idx).trading_company_name           := :old.trading_company_name       ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).value_meaning                  := :old.value_meaning              ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).ptu_resolution                 := :old.ptu_resolution             ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).ptu_date_loc                   := :old.ptu_date_loc               ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).ptu                            := :old.ptu                        ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).capacity                       := :old.capacity                   ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).capacity_unit_name             := :old.capacity_unit_name         ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).price                          := :old.price                      ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).price_unit_name                := :old.price_unit_name            ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).price_measurement_unit_name    := :old.price_measurement_unit_name; 
        tpt_rdevl_actions.t_rdevl_tab(v_idx).tvalidity_utc_from             := :old.tvalidity_utc_from         ;    
        tpt_rdevl_actions.t_rdevl_tab(v_idx).tvalidity_loc_from             := :old.tvalidity_loc_from         ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).lamu_user                      := :old.lamu_user                  ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).lamu_source                    := :old.lamu_source                ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).lamu_pcs_id                    := :old.lamu_pcs_id                ;


      when deleting  then
        v_module  := cn_package||'.adr';
        tpt_rdevl_actions.t_rdevl_tab(v_idx).jn_action                      := 'DEL'                           ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).bvalidity_utc_from             := :old.bvalidity_utc_from         ; 
        tpt_rdevl_actions.t_rdevl_tab(v_idx).bvalidity_utc_to               := :old.bvalidity_utc_to           ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).rde_id                         := :old.rde_id                     ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).order_id                       := :old.order_id                   ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).nde_code                       := :old.nde_code                   ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).nde_code_type                  := :old.nde_code_type              ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).nde_object_type                := :old.nde_object_type            ;   
        tpt_rdevl_actions.t_rdevl_tab(v_idx).trading_company_name           := :old.trading_company_name       ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).value_meaning                  := :old.value_meaning              ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).ptu_resolution                 := :old.ptu_resolution             ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).ptu_date_loc                   := :old.ptu_date_loc               ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).ptu                            := :old.ptu                        ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).capacity                       := :old.capacity                   ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).capacity_unit_name             := :old.capacity_unit_name         ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).price                          := :old.price                      ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).price_unit_name                := :old.price_unit_name            ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).price_measurement_unit_name    := :old.price_measurement_unit_name; 
        tpt_rdevl_actions.t_rdevl_tab(v_idx).tvalidity_utc_from             := :old.tvalidity_utc_from         ;    
        tpt_rdevl_actions.t_rdevl_tab(v_idx).tvalidity_loc_from             := :old.tvalidity_loc_from         ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).lamu_user                      := :old.lamu_user                  ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).lamu_source                    := :old.lamu_source                ;
        tpt_rdevl_actions.t_rdevl_tab(v_idx).lamu_pcs_id                    := :old.lamu_pcs_id                ;

    end case;
  exception
    when others then
      pcs_log_actions.log_error(p_module => v_module);
      raise;
  end after each row;

end tpt_rdevl_compound;
/
