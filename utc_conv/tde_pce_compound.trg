create or replace trigger tde_pce_compound
  for insert or update or delete
  on tde_procured_energy_losses
  compound trigger
  /***********************************************************************************************************************
   purpose    : compound trigger for table tde_procured_energy_losses

   change history
   date        author            version   description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   09-04-2021  X. Pikaar         01.00.00  TRAN-4800 - Created.
   07-09-2021  X. Pikaar         01.01.00  contract_date_loc_loc toegevoegd
   08-10-2021  X. Pikaar         01.02.00  transmission_statustoegevoegd
   11-01-2022  P. Schriek        01.02.01  TRAN-5090 - Kolom tde_procured_energy_losses.transaction_date_utc hernoemen naar transaction_date_loc
   25-02-2022  X. Pikaar         01.03.00  TRAN-5340: kolom contract_id toegevoegd
   07-12-2022  X. Pikaar         01.06.00  TRAN-5984: kolom duration toegevoegd
   16-12-2022  X. Pikaar         01.07.00  TRAN-5965: lamu_pcs_id behouden als wijziging niet vanuit het normale proces komt 
   06-07-2025  Sandjai Ramasray  01.08.00  TRAN-8243 Correctie foutieve UTC-conversiepatronen.
                                           (osuser is dan oracle)
  ***********************************************************************************************************************/
  cn_package            constant     varchar2(100)            := 'tde_pce_compound';
  v_module                           varchar2(100);

  v_idx                              simple_integer           := 0;

  v_lamu_user                        varchar2(100)            := nvl(sys_context('USERENV','OS_USER'),USER);
  v_tvalidity_utc_from               timestamp                := sys_extract_utc(systimestamp);
  v_tvalidity_loc_from               timestamp                := sup_date_actions.convertutc2local(p_utc_date => v_tvalidity_utc_from);
  v_lamu_source                      varchar2(100)            := nvl(sup_globals.get_global_varchar(p_name => 'SOURCE_SYSTEM'), sup_constants.cn_unknown);
  v_lamu_pcs_id                      varchar2(100)            := nvl(sup_globals.get_global_number(p_name => 'PROCESS_ID'), sup_constants.cn_negative_infinite_number);

  e_nontransfer                      exception;

  -- BEFORE STATEMENT Section:
  before statement is
  begin
    v_module := cn_package ||'.bst';
    -- Begin Initializations
    -- Clear the plsql-table, because within one session intdba can handle more than one xml-message.
    -- When previous went wrong there is still old data in the table
    tde_pce_actions.clear_plsql_table;
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
    tde_pce_actions.journal_rows;
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
       :new.id                  := nvl(:new.id                  ,tde_pce_seq.nextval    );
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
    v_idx := nvl(tde_pce_actions.t_pce_tab.count, 0) + 1;
    tde_pce_actions.t_pce_tab(v_idx).jn_cre_user         := v_lamu_user         ;
    tde_pce_actions.t_pce_tab(v_idx).tvalidity_loc_from  := v_tvalidity_loc_from;
    tde_pce_actions.t_pce_tab(v_idx).tvalidity_utc_from  := v_tvalidity_utc_from;
    tde_pce_actions.t_pce_tab(v_idx).jn_cre_source       := v_lamu_source       ;
    tde_pce_actions.t_pce_tab(v_idx).jn_cre_pcs_id       := v_lamu_pcs_id       ;

    case
      when inserting then
        v_module := cn_package||'.air';
        tde_pce_actions.t_pce_tab(v_idx).jn_action                      := 'INS'                              ;
        tde_pce_actions.t_pce_tab(v_idx).id                             := :new.id                            ;
        tde_pce_actions.t_pce_tab(v_idx).legal_owner                    := :new.legal_owner                   ;
        tde_pce_actions.t_pce_tab(v_idx).transaction_id                 := :new.transaction_id                ;
        tde_pce_actions.t_pce_tab(v_idx).contract_id                    := :new.contract_id                   ;
        tde_pce_actions.t_pce_tab(v_idx).contract_type                  := :new.contract_type                 ;
        tde_pce_actions.t_pce_tab(v_idx).contract_date_loc              := :new.contract_date_loc             ;
        tde_pce_actions.t_pce_tab(v_idx).tso_code                       := :new.tso_code                      ;
        tde_pce_actions.t_pce_tab(v_idx).tso_code_type                  := :new.tso_code_type                 ;
        tde_pce_actions.t_pce_tab(v_idx).trader_code                    := :new.trader_code                   ;
        tde_pce_actions.t_pce_tab(v_idx).trader_code_type               := :new.trader_code_type              ;
        tde_pce_actions.t_pce_tab(v_idx).supplier_code                  := :new.supplier_code                 ;
        tde_pce_actions.t_pce_tab(v_idx).supplier_code_type             := :new.supplier_code_type            ;
        tde_pce_actions.t_pce_tab(v_idx).supplier_name                  := :new.supplier_name                 ;
        tde_pce_actions.t_pce_tab(v_idx).transaction_date_loc           := :new.transaction_date_loc          ;
        tde_pce_actions.t_pce_tab(v_idx).settlement_method              := :new.settlement_method             ;
        tde_pce_actions.t_pce_tab(v_idx).ara_code                       := :new.ara_code                      ;
        tde_pce_actions.t_pce_tab(v_idx).ara_code_type                  := :new.ara_code_type                 ;
        tde_pce_actions.t_pce_tab(v_idx).ara_object_type                := :new.ara_object_type               ;
        tde_pce_actions.t_pce_tab(v_idx).trading_hour_loc_from          := :new.trading_hour_loc_from         ;
        tde_pce_actions.t_pce_tab(v_idx).trading_hour_loc_to            := :new.trading_hour_loc_to           ;
        tde_pce_actions.t_pce_tab(v_idx).delivery_date_loc_from         := :new.delivery_date_loc_from        ;
        tde_pce_actions.t_pce_tab(v_idx).delivery_date_loc_to           := :new.delivery_date_loc_to          ;
        tde_pce_actions.t_pce_tab(v_idx).commodity                      := :new.commodity                     ;
        tde_pce_actions.t_pce_tab(v_idx).load_type                      := :new.load_type                     ;
        tde_pce_actions.t_pce_tab(v_idx).load_delivery_date_loc_from    := :new.load_delivery_date_loc_from   ;
        tde_pce_actions.t_pce_tab(v_idx).load_delivery_date_loc_to      := :new.load_delivery_date_loc_to     ;
        tde_pce_actions.t_pce_tab(v_idx).load_delivery_time_loc_from    := :new.load_delivery_time_loc_from   ;
        tde_pce_actions.t_pce_tab(v_idx).load_delivery_time_loc_to      := :new.load_delivery_time_loc_to     ;
        tde_pce_actions.t_pce_tab(v_idx).ind_buy_sell                   := :new.ind_buy_sell                  ;
        tde_pce_actions.t_pce_tab(v_idx).price                          := :new.price                         ;
        tde_pce_actions.t_pce_tab(v_idx).currency_unit                  := :new.currency_unit                 ;
        tde_pce_actions.t_pce_tab(v_idx).notional_price                 := :new.notional_price                ;
        tde_pce_actions.t_pce_tab(v_idx).notional_currency_unit         := :new.notional_currency_unit        ;
        tde_pce_actions.t_pce_tab(v_idx).energy                         := :new.energy                        ;
        tde_pce_actions.t_pce_tab(v_idx).energy_measurement_unit        := :new.energy_measurement_unit       ;
        tde_pce_actions.t_pce_tab(v_idx).total_notional_energy          := :new.total_notional_energy         ;
        tde_pce_actions.t_pce_tab(v_idx).total_notional_energy_mst_unit := :new.total_notional_energy_mst_unit;
        tde_pce_actions.t_pce_tab(v_idx).price_formula                  := :new.price_formula                 ;
        tde_pce_actions.t_pce_tab(v_idx).duration                       := :new.duration                      ;
        tde_pce_actions.t_pce_tab(v_idx).transaction_status             := :new.transaction_status            ;
        tde_pce_actions.t_pce_tab(v_idx).transmission_status            := :new.transmission_status           ;
        tde_pce_actions.t_pce_tab(v_idx).tvalidity_utc_from             := :new.tvalidity_utc_from            ;
        tde_pce_actions.t_pce_tab(v_idx).tvalidity_loc_from             := :new.tvalidity_loc_from            ;
        tde_pce_actions.t_pce_tab(v_idx).lamu_user                      := :new.lamu_user                     ;
        tde_pce_actions.t_pce_tab(v_idx).lamu_source                    := :new.lamu_source                   ;
        tde_pce_actions.t_pce_tab(v_idx).lamu_pcs_id                    := :new.lamu_pcs_id                   ;
      when updating  then
        v_module  := cn_package||'.aur';
        tde_pce_actions.t_pce_tab(v_idx).jn_action                      := 'UPD'                         ;
        tde_pce_actions.t_pce_tab(v_idx).id                             := :old.id                            ;
        tde_pce_actions.t_pce_tab(v_idx).legal_owner                    := :old.legal_owner                   ;
        tde_pce_actions.t_pce_tab(v_idx).transaction_id                 := :old.transaction_id                ;
        tde_pce_actions.t_pce_tab(v_idx).contract_id                    := :old.contract_id                   ;
        tde_pce_actions.t_pce_tab(v_idx).contract_type                  := :old.contract_type                 ;
        tde_pce_actions.t_pce_tab(v_idx).contract_date_loc              := :old.contract_date_loc             ;
        tde_pce_actions.t_pce_tab(v_idx).tso_code                       := :old.tso_code                      ;
        tde_pce_actions.t_pce_tab(v_idx).tso_code_type                  := :old.tso_code_type                 ;
        tde_pce_actions.t_pce_tab(v_idx).trader_code                    := :old.trader_code                   ;
        tde_pce_actions.t_pce_tab(v_idx).trader_code_type               := :old.trader_code_type              ;
        tde_pce_actions.t_pce_tab(v_idx).supplier_code                  := :old.supplier_code                 ;
        tde_pce_actions.t_pce_tab(v_idx).supplier_code_type             := :old.supplier_code_type            ;
        tde_pce_actions.t_pce_tab(v_idx).supplier_name                  := :old.supplier_name                 ;
        tde_pce_actions.t_pce_tab(v_idx).transaction_date_loc           := :old.transaction_date_loc          ;
        tde_pce_actions.t_pce_tab(v_idx).settlement_method              := :old.settlement_method             ;
        tde_pce_actions.t_pce_tab(v_idx).ara_code                       := :old.ara_code                      ;
        tde_pce_actions.t_pce_tab(v_idx).ara_code_type                  := :old.ara_code_type                 ;
        tde_pce_actions.t_pce_tab(v_idx).ara_object_type                := :old.ara_object_type               ;
        tde_pce_actions.t_pce_tab(v_idx).trading_hour_loc_from          := :old.trading_hour_loc_from         ;
        tde_pce_actions.t_pce_tab(v_idx).trading_hour_loc_to            := :old.trading_hour_loc_to           ;
        tde_pce_actions.t_pce_tab(v_idx).delivery_date_loc_from         := :old.delivery_date_loc_from        ;
        tde_pce_actions.t_pce_tab(v_idx).delivery_date_loc_to           := :old.delivery_date_loc_to          ;
        tde_pce_actions.t_pce_tab(v_idx).commodity                      := :old.commodity                     ;
        tde_pce_actions.t_pce_tab(v_idx).load_type                      := :old.load_type                     ;
        tde_pce_actions.t_pce_tab(v_idx).load_delivery_date_loc_from    := :old.load_delivery_date_loc_from   ;
        tde_pce_actions.t_pce_tab(v_idx).load_delivery_date_loc_to      := :old.load_delivery_date_loc_to     ;
        tde_pce_actions.t_pce_tab(v_idx).load_delivery_time_loc_from    := :old.load_delivery_time_loc_from   ;
        tde_pce_actions.t_pce_tab(v_idx).load_delivery_time_loc_to      := :old.load_delivery_time_loc_to     ;
        tde_pce_actions.t_pce_tab(v_idx).ind_buy_sell                   := :old.ind_buy_sell                  ;
        tde_pce_actions.t_pce_tab(v_idx).price                          := :old.price                         ;
        tde_pce_actions.t_pce_tab(v_idx).currency_unit                  := :old.currency_unit                 ;
        tde_pce_actions.t_pce_tab(v_idx).notional_price                 := :old.notional_price                ;
        tde_pce_actions.t_pce_tab(v_idx).notional_currency_unit         := :old.notional_currency_unit        ;
        tde_pce_actions.t_pce_tab(v_idx).energy                         := :old.energy                        ;
        tde_pce_actions.t_pce_tab(v_idx).energy_measurement_unit        := :old.energy_measurement_unit       ;
        tde_pce_actions.t_pce_tab(v_idx).total_notional_energy          := :old.total_notional_energy         ;
        tde_pce_actions.t_pce_tab(v_idx).total_notional_energy_mst_unit := :old.total_notional_energy_mst_unit;
        tde_pce_actions.t_pce_tab(v_idx).price_formula                  := :old.price_formula                 ;
        tde_pce_actions.t_pce_tab(v_idx).duration                       := :old.duration                      ;
        tde_pce_actions.t_pce_tab(v_idx).transaction_status             := :old.transaction_status            ;
        tde_pce_actions.t_pce_tab(v_idx).transmission_status            := :old.transmission_status           ;
        tde_pce_actions.t_pce_tab(v_idx).tvalidity_utc_from             := :old.tvalidity_utc_from            ;
        tde_pce_actions.t_pce_tab(v_idx).tvalidity_loc_from             := :old.tvalidity_loc_from            ;
        tde_pce_actions.t_pce_tab(v_idx).lamu_user                      := :old.lamu_user                     ;
        tde_pce_actions.t_pce_tab(v_idx).lamu_source                    := :old.lamu_source                   ;
        tde_pce_actions.t_pce_tab(v_idx).lamu_pcs_id                    := :old.lamu_pcs_id                   ;

      when deleting  then
        v_module  := cn_package||'.adr';
        tde_pce_actions.t_pce_tab(v_idx).jn_action                      := 'DEL'                              ;
        tde_pce_actions.t_pce_tab(v_idx).id                             := :old.id                            ;
        tde_pce_actions.t_pce_tab(v_idx).legal_owner                    := :old.legal_owner                   ;
        tde_pce_actions.t_pce_tab(v_idx).transaction_id                 := :old.transaction_id                ;
        tde_pce_actions.t_pce_tab(v_idx).contract_id                    := :old.contract_id                   ;
        tde_pce_actions.t_pce_tab(v_idx).contract_type                  := :old.contract_type                 ;
        tde_pce_actions.t_pce_tab(v_idx).contract_date_loc              := :old.contract_date_loc             ;
        tde_pce_actions.t_pce_tab(v_idx).tso_code                       := :old.tso_code                      ;
        tde_pce_actions.t_pce_tab(v_idx).tso_code_type                  := :old.tso_code_type                 ;
        tde_pce_actions.t_pce_tab(v_idx).trader_code                    := :old.trader_code                   ;
        tde_pce_actions.t_pce_tab(v_idx).trader_code_type               := :old.trader_code_type              ;
        tde_pce_actions.t_pce_tab(v_idx).supplier_code                  := :old.supplier_code                 ;
        tde_pce_actions.t_pce_tab(v_idx).supplier_code_type             := :old.supplier_code_type            ;
        tde_pce_actions.t_pce_tab(v_idx).supplier_name                  := :old.supplier_name                 ;
        tde_pce_actions.t_pce_tab(v_idx).transaction_date_loc           := :old.transaction_date_loc          ;
        tde_pce_actions.t_pce_tab(v_idx).settlement_method              := :old.settlement_method             ;
        tde_pce_actions.t_pce_tab(v_idx).ara_code                       := :old.ara_code                      ;
        tde_pce_actions.t_pce_tab(v_idx).ara_code_type                  := :old.ara_code_type                 ;
        tde_pce_actions.t_pce_tab(v_idx).ara_object_type                := :old.ara_object_type               ;
        tde_pce_actions.t_pce_tab(v_idx).trading_hour_loc_from          := :old.trading_hour_loc_from         ;
        tde_pce_actions.t_pce_tab(v_idx).trading_hour_loc_to            := :old.trading_hour_loc_to           ;
        tde_pce_actions.t_pce_tab(v_idx).delivery_date_loc_from         := :old.delivery_date_loc_from        ;
        tde_pce_actions.t_pce_tab(v_idx).delivery_date_loc_to           := :old.delivery_date_loc_to          ;
        tde_pce_actions.t_pce_tab(v_idx).commodity                      := :old.commodity                     ;
        tde_pce_actions.t_pce_tab(v_idx).load_type                      := :old.load_type                     ;
        tde_pce_actions.t_pce_tab(v_idx).load_delivery_date_loc_from    := :old.load_delivery_date_loc_from   ;
        tde_pce_actions.t_pce_tab(v_idx).load_delivery_date_loc_to      := :old.load_delivery_date_loc_to     ;
        tde_pce_actions.t_pce_tab(v_idx).load_delivery_time_loc_from    := :old.load_delivery_time_loc_from   ;
        tde_pce_actions.t_pce_tab(v_idx).load_delivery_time_loc_to      := :old.load_delivery_time_loc_to     ;
        tde_pce_actions.t_pce_tab(v_idx).ind_buy_sell                   := :old.ind_buy_sell                  ;
        tde_pce_actions.t_pce_tab(v_idx).price                          := :old.price                         ;
        tde_pce_actions.t_pce_tab(v_idx).currency_unit                  := :old.currency_unit                 ;
        tde_pce_actions.t_pce_tab(v_idx).notional_price                 := :old.notional_price                ;
        tde_pce_actions.t_pce_tab(v_idx).notional_currency_unit         := :old.notional_currency_unit        ;
        tde_pce_actions.t_pce_tab(v_idx).energy                         := :old.energy                        ;
        tde_pce_actions.t_pce_tab(v_idx).energy_measurement_unit        := :old.energy_measurement_unit       ;
        tde_pce_actions.t_pce_tab(v_idx).total_notional_energy          := :old.total_notional_energy         ;
        tde_pce_actions.t_pce_tab(v_idx).total_notional_energy_mst_unit := :old.total_notional_energy_mst_unit;
        tde_pce_actions.t_pce_tab(v_idx).price_formula                  := :old.price_formula                 ;
        tde_pce_actions.t_pce_tab(v_idx).duration                       := :old.duration                      ;
        tde_pce_actions.t_pce_tab(v_idx).transaction_status             := :old.transaction_status            ;
        tde_pce_actions.t_pce_tab(v_idx).transmission_status            := :old.transmission_status           ;
        tde_pce_actions.t_pce_tab(v_idx).tvalidity_utc_from             := :old.tvalidity_utc_from            ;
        tde_pce_actions.t_pce_tab(v_idx).tvalidity_loc_from             := :old.tvalidity_loc_from            ;
        tde_pce_actions.t_pce_tab(v_idx).lamu_user                      := :old.lamu_user                     ;
        tde_pce_actions.t_pce_tab(v_idx).lamu_source                    := :old.lamu_source                   ;
        tde_pce_actions.t_pce_tab(v_idx).lamu_pcs_id                    := :old.lamu_pcs_id                   ;

    end case;
  exception
    when others then
      pcs_log_actions.log_error(p_module => v_module);
      raise;
  end after each row;

end tde_pce_compound;
/
