create or replace trigger bln_cte_compound
for insert or update or delete
on bln_contracted_reserves
compound trigger
  /***********************************************************************************************************************
   purpose    : compound trigger for table bln_contracted_reserves

   change history
   date        author            version   description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   11-01-2018  M.Zuijdendorp     01.00.00  created
   06-02-2018  X. Pikaar         01.00.01  Hernoemd naar bln_cte_compound
                                           v_tvalidity_loc_from o.b.v. v_tvalidity_utc_from om een miniem verschul in lokale
                                           en UTC-tijd te voorkomen
   17-01-2020  X. Pikaar         01.00.02  tvalidity-to verlden werden niet gevuld
   26-05-2020  T. Bakker         01.00.03  TRAN-4036: timestamp vervangen door timestamp with time zone vanwege Z/W tijd
   06-07-2020  X. Pikaar         01.01.00  Auction_id toegevoegd
   27-08-2020  R. Koomen         01.02.00  TRAN-4045: nieuwe kolommen "ptu_date_loc" en "ptu toegevoegd"
   16-12-2022  X. Pikaar         01.03.00  TRAN-5965: lamu_pcs_id behouden als wijziging niet vanuit het normale proces komt 
                                           (osuser is dan oracle)
   11-04-2024  X. Pikaar         01.04.00  TRAN-6702"kolom product_type toegevoegd
   03-09-2024  Nico Klaver       01.05.00  TRAN-6953 kolom procurement_timestamp_utc toegevoegd
   14-10-2024  S. Ramasray       01.06.00  TRAN-6843 Verwijderen kolommen ptu_date_loc en ptu uit tabel bln_contracted_reserves
   06-07-2025  Sandjai Ramasray  01.07.00  TRAN-8243 Correctie foutieve UTC-conversiepatronen.
  ***********************************************************************************************************************/

  cn_package            constant     varchar2(100)             := 'bln_cte_compound';
  v_module                           varchar2(100);

  v_idx                              simple_integer            := 0;

  v_lamu_user                        varchar2(100)             := nvl(sys_context('USERENV','OS_USER'),USER);
  v_tvalidity_utc_from               timestamp                 := sys_extract_utc(systimestamp);
  v_tvalidity_loc_from               timestamp                 := sup_date_actions.convertutc2local(p_utc_date => v_tvalidity_utc_from);
  v_lamu_source                      varchar2(100)             := nvl(sup_globals.get_global_varchar(p_name => 'SOURCE_SYSTEM'), sup_constants.cn_unknown);
  v_lamu_pcs_id                      varchar2(100)             := nvl(sup_globals.get_global_number(p_name => 'PROCESS_ID'), sup_constants.cn_negative_infinite_number);

  e_nontransfer                      exception;

  -- BEFORE STATEMENT Section:
  before statement is
  begin
    v_module := cn_package ||'.bst';
    -- Begin Initializations
    -- Clear the plsql-table, because within one session intdba can handle more than one xml-message.
    -- When previous went wrong there is still old data in the table
    bln_cte_actions.clear_plsql_table;
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
    bln_cte_actions.journal_rows;
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
       :new.id                  := nvl(:new.id                  ,bln_cte_seq.nextval);
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
    v_idx := nvl(bln_cte_actions.t_cte_tab.count,0) + 1;
    bln_cte_actions.t_cte_tab(v_idx).jn_cre_user         := v_lamu_user    ;
    bln_cte_actions.t_cte_tab(v_idx).tvalidity_loc_to    := v_tvalidity_loc_from;
    bln_cte_actions.t_cte_tab(v_idx).tvalidity_utc_to    := v_tvalidity_utc_from;
    bln_cte_actions.t_cte_tab(v_idx).jn_cre_source       := v_lamu_source  ;
    bln_cte_actions.t_cte_tab(v_idx).jn_cre_pcs_id       := v_lamu_pcs_id  ;

    case
      when inserting then
        v_module := cn_package||'.air';
        bln_cte_actions.t_cte_tab(v_idx).jn_action                      := 'INS'                               ;
        bln_cte_actions.t_cte_tab(v_idx).id                             := :new.id                             ;
        bln_cte_actions.t_cte_tab(v_idx).legal_owner                    := :new.legal_owner                    ;
        bln_cte_actions.t_cte_tab(v_idx).auction_id                     := :new.auction_id                     ;
        bln_cte_actions.t_cte_tab(v_idx).code                           := :new.code                           ;
        bln_cte_actions.t_cte_tab(v_idx).code_type                      := :new.code_type                      ;
        bln_cte_actions.t_cte_tab(v_idx).object_type                    := :new.object_type                    ;
        bln_cte_actions.t_cte_tab(v_idx).contract_id                    := :new.contract_id                    ;
        bln_cte_actions.t_cte_tab(v_idx).contract_type                  := :new.contract_type                  ;
        bln_cte_actions.t_cte_tab(v_idx).product_type                   := :new.product_type                   ;
        bln_cte_actions.t_cte_tab(v_idx).procurement_timeperiod_type    := :new.procurement_timeperiod_type    ;
        bln_cte_actions.t_cte_tab(v_idx).procurement_timestamp_utc      := :new.procurement_timestamp_utc      ;
        bln_cte_actions.t_cte_tab(v_idx).resource_type                  := :new.resource_type                  ;
        bln_cte_actions.t_cte_tab(v_idx).resolution                     := :new.resolution                     ;
        bln_cte_actions.t_cte_tab(v_idx).bvalidity_utc_from             := :new.bvalidity_utc_from             ;
        bln_cte_actions.t_cte_tab(v_idx).bvalidity_utc_to               := :new.bvalidity_utc_to               ;
        bln_cte_actions.t_cte_tab(v_idx).tvalidity_loc_from             := :new.tvalidity_loc_from             ;
        bln_cte_actions.t_cte_tab(v_idx).tvalidity_utc_from             := :new.tvalidity_utc_from             ;
        bln_cte_actions.t_cte_tab(v_idx).lamu_user                      := :new.lamu_user                      ;
        bln_cte_actions.t_cte_tab(v_idx).lamu_source                    := :new.lamu_source                    ;
        bln_cte_actions.t_cte_tab(v_idx).lamu_pcs_id                    := :new.lamu_pcs_id                    ;

      when updating  then
        v_module  := cn_package||'.aur';
        bln_cte_actions.t_cte_tab(v_idx).jn_action                      := 'UPD'                               ;
        bln_cte_actions.t_cte_tab(v_idx).id                             := :old.id                             ;
        bln_cte_actions.t_cte_tab(v_idx).legal_owner                    := :old.legal_owner                    ;
        bln_cte_actions.t_cte_tab(v_idx).auction_id                     := :old.auction_id                     ;
        bln_cte_actions.t_cte_tab(v_idx).code                           := :old.code                           ;
        bln_cte_actions.t_cte_tab(v_idx).code_type                      := :old.code_type                      ;
        bln_cte_actions.t_cte_tab(v_idx).object_type                    := :old.object_type                    ;
        bln_cte_actions.t_cte_tab(v_idx).contract_id                    := :old.contract_id                    ;
        bln_cte_actions.t_cte_tab(v_idx).contract_type                  := :old.contract_type                  ;
        bln_cte_actions.t_cte_tab(v_idx).product_type                   := :old.product_type                   ;
        bln_cte_actions.t_cte_tab(v_idx).procurement_timeperiod_type    := :old.procurement_timeperiod_type    ;
        bln_cte_actions.t_cte_tab(v_idx).procurement_timestamp_utc      := :old.procurement_timestamp_utc      ;
        bln_cte_actions.t_cte_tab(v_idx).resource_type                  := :old.resource_type                  ;
        bln_cte_actions.t_cte_tab(v_idx).resolution                     := :old.resolution                     ;
        bln_cte_actions.t_cte_tab(v_idx).bvalidity_utc_from             := :old.bvalidity_utc_from             ;
        bln_cte_actions.t_cte_tab(v_idx).bvalidity_utc_to               := :old.bvalidity_utc_to               ;
        bln_cte_actions.t_cte_tab(v_idx).tvalidity_loc_from             := :old.tvalidity_loc_from             ;
        bln_cte_actions.t_cte_tab(v_idx).tvalidity_utc_from             := :old.tvalidity_utc_from             ;
        bln_cte_actions.t_cte_tab(v_idx).lamu_user                      := :old.lamu_user                      ;
        bln_cte_actions.t_cte_tab(v_idx).lamu_source                    := :old.lamu_source                    ;
        bln_cte_actions.t_cte_tab(v_idx).lamu_pcs_id                    := :old.lamu_pcs_id                    ;

      when deleting  then
        v_module  := cn_package||'.adr';
        bln_cte_actions.t_cte_tab(v_idx).jn_action                      := 'DEL'                               ;
        bln_cte_actions.t_cte_tab(v_idx).id                             := :old.id                             ;
        bln_cte_actions.t_cte_tab(v_idx).legal_owner                    := :old.legal_owner                    ;
        bln_cte_actions.t_cte_tab(v_idx).auction_id                     := :old.auction_id                     ;
        bln_cte_actions.t_cte_tab(v_idx).code                           := :old.code                           ;
        bln_cte_actions.t_cte_tab(v_idx).code_type                      := :old.code_type                      ;
        bln_cte_actions.t_cte_tab(v_idx).object_type                    := :old.object_type                    ;
        bln_cte_actions.t_cte_tab(v_idx).contract_id                    := :old.contract_id                    ;
        bln_cte_actions.t_cte_tab(v_idx).contract_type                  := :old.contract_type                  ;
        bln_cte_actions.t_cte_tab(v_idx).product_type                   := :old.product_type                   ;
        bln_cte_actions.t_cte_tab(v_idx).procurement_timeperiod_type    := :old.procurement_timeperiod_type    ;
        bln_cte_actions.t_cte_tab(v_idx).procurement_timeperiod_type    := :old.procurement_timeperiod_type    ;
        bln_cte_actions.t_cte_tab(v_idx).resource_type                  := :old.resource_type                  ;
        bln_cte_actions.t_cte_tab(v_idx).resolution                     := :old.resolution                     ;
        bln_cte_actions.t_cte_tab(v_idx).bvalidity_utc_from             := :old.bvalidity_utc_from             ;
        bln_cte_actions.t_cte_tab(v_idx).bvalidity_utc_to               := :old.bvalidity_utc_to               ;
        bln_cte_actions.t_cte_tab(v_idx).tvalidity_loc_from             := :old.tvalidity_loc_from             ;
        bln_cte_actions.t_cte_tab(v_idx).tvalidity_utc_from             := :old.tvalidity_utc_from             ;
        bln_cte_actions.t_cte_tab(v_idx).lamu_user                      := :old.lamu_user                      ;
        bln_cte_actions.t_cte_tab(v_idx).lamu_source                    := :old.lamu_source                    ;
        bln_cte_actions.t_cte_tab(v_idx).lamu_pcs_id                    := :old.lamu_pcs_id                    ;

    end case;
  exception
    when others then
      pcs_log_actions.log_error(p_module => v_module);
      raise;
  end after each row;

end bln_cte_compound;
/
