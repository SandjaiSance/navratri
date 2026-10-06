create or replace trigger bln_ate_compound
for insert or update or delete
on bln_activated_reserves
compound trigger
  /***********************************************************************************************************************
   purpose    : compound trigger for table bln_activated_reserves

   change history
   date        author            version   description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   17-01-2019  N.Wenting         01.00.00  created
   31-05-2019  Y. Krop           01.00.01  Sonar-melding m.b.t. trailing spaces opgelost.
   01-04-2020  X. Pikaar         01.01.00  contract_id toegevoegd
   26-05-2020  T. Bakker         01.01.01  TRAN-4036: timestamp vervangen door timestamp with time zone vanwege Z/W tijd
   14-09-2020  T. Bakker         01.01.02  TRAN-4201: Toevoegen kolommen voor marketparticipant
   30-11-2020  R. Koomen         01.01.03  TRAN_3088: Toevoegen tvalidity_xxx_to kolommen aan de journal table.
   16-02-2021  X. Pikaar         01.01.04  contract_id werd niet goed gejournald
   24-02-2021  X. Pikaar         01.02.00  TRAN-4704 Toevoegen in/out-area aan bln_activated_reserves
   16-12-2022  X. Pikaar         01.03.00  TRAN-5965: lamu_pcs_id behouden als wijziging niet vanuit het normale proces komt 
   06-07-2025  Sandjai Ramasray  01.04.00  TRAN-8243 Correctie foutieve UTC-conversiepatronen.
                                           (osuser is dan oracle)
  ***********************************************************************************************************************/

  cn_package            constant     varchar2(100)             := 'bln_ate_compound';
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
    bln_ate_actions.clear_plsql_table;
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
    bln_ate_actions.journal_rows;
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
       :new.id                  := nvl(:new.id                  ,bln_ate_seq.nextval);
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
    v_idx := nvl(bln_ate_actions.t_ate_tab.count,0) + 1;
    bln_ate_actions.t_ate_tab(v_idx).jn_cre_user         := v_lamu_user    ;
    bln_ate_actions.t_ate_tab(v_idx).tvalidity_loc_to    := v_tvalidity_loc_from;
    bln_ate_actions.t_ate_tab(v_idx).tvalidity_utc_to    := v_tvalidity_utc_from;
    bln_ate_actions.t_ate_tab(v_idx).jn_cre_source       := v_lamu_source  ;
    bln_ate_actions.t_ate_tab(v_idx).jn_cre_pcs_id       := v_lamu_pcs_id  ;

    case
      when inserting then
        v_module := cn_package||'.air';
        bln_ate_actions.t_ate_tab(v_idx).jn_action                := 'INS'                         ;
        bln_ate_actions.t_ate_tab(v_idx).id                       := :new.id                       ;
        bln_ate_actions.t_ate_tab(v_idx).legal_owner              := :new.legal_owner              ;
        bln_ate_actions.t_ate_tab(v_idx).energy_type              := :new.energy_type              ;
        bln_ate_actions.t_ate_tab(v_idx).contract_id              := :new.contract_id              ;
        bln_ate_actions.t_ate_tab(v_idx).mpt_code                 := :new.mpt_code                 ;
        bln_ate_actions.t_ate_tab(v_idx).mpt_code_type            := :new.mpt_code_type            ;
        bln_ate_actions.t_ate_tab(v_idx).mpt_object_type          := :new.mpt_object_type          ;
        bln_ate_actions.t_ate_tab(v_idx).in_ara_code              := :new.in_ara_code              ;
        bln_ate_actions.t_ate_tab(v_idx).in_ara_code_type         := :new.in_ara_code_type         ;
        bln_ate_actions.t_ate_tab(v_idx).in_ara_object_type       := :new.in_ara_object_type       ;
        bln_ate_actions.t_ate_tab(v_idx).out_ara_code             := :new.out_ara_code             ;
        bln_ate_actions.t_ate_tab(v_idx).out_ara_code_type        := :new.out_ara_code_type        ;
        bln_ate_actions.t_ate_tab(v_idx).out_ara_object_type      := :new.out_ara_object_type      ;
        bln_ate_actions.t_ate_tab(v_idx).tvalidity_loc_from       := :new.tvalidity_loc_from       ;
        bln_ate_actions.t_ate_tab(v_idx).tvalidity_utc_from       := :new.tvalidity_utc_from       ;
        bln_ate_actions.t_ate_tab(v_idx).lamu_user                := :new.lamu_user                ;
        bln_ate_actions.t_ate_tab(v_idx).lamu_source              := :new.lamu_source              ;
        bln_ate_actions.t_ate_tab(v_idx).lamu_pcs_id              := :new.lamu_pcs_id              ;

      when updating  then
        v_module  := cn_package||'.aur';
        bln_ate_actions.t_ate_tab(v_idx).jn_action                := 'UPD'                         ;
        bln_ate_actions.t_ate_tab(v_idx).id                       := :old.id                       ;
        bln_ate_actions.t_ate_tab(v_idx).legal_owner              := :old.legal_owner              ;
        bln_ate_actions.t_ate_tab(v_idx).energy_type              := :old.energy_type              ;
        bln_ate_actions.t_ate_tab(v_idx).contract_id              := :old.contract_id              ;
        bln_ate_actions.t_ate_tab(v_idx).mpt_code                 := :old.mpt_code                 ;
        bln_ate_actions.t_ate_tab(v_idx).mpt_code_type            := :old.mpt_code_type            ;
        bln_ate_actions.t_ate_tab(v_idx).mpt_object_type          := :old.mpt_object_type          ;
        bln_ate_actions.t_ate_tab(v_idx).in_ara_code              := :old.in_ara_code              ;
        bln_ate_actions.t_ate_tab(v_idx).in_ara_code_type         := :old.in_ara_code_type         ;
        bln_ate_actions.t_ate_tab(v_idx).in_ara_object_type       := :old.in_ara_object_type       ;
        bln_ate_actions.t_ate_tab(v_idx).out_ara_code             := :old.out_ara_code             ;
        bln_ate_actions.t_ate_tab(v_idx).out_ara_code_type        := :old.out_ara_code_type        ;
        bln_ate_actions.t_ate_tab(v_idx).out_ara_object_type      := :old.out_ara_object_type      ;
        bln_ate_actions.t_ate_tab(v_idx).tvalidity_loc_from       := :old.tvalidity_loc_from       ;
        bln_ate_actions.t_ate_tab(v_idx).tvalidity_utc_from       := :old.tvalidity_utc_from       ;
        bln_ate_actions.t_ate_tab(v_idx).lamu_user                := :old.lamu_user                ;
        bln_ate_actions.t_ate_tab(v_idx).lamu_source              := :old.lamu_source              ;
        bln_ate_actions.t_ate_tab(v_idx).lamu_pcs_id              := :old.lamu_pcs_id              ;

      when deleting  then
        v_module  := cn_package||'.adr';
        bln_ate_actions.t_ate_tab(v_idx).jn_action                := 'DEL'                         ;
        bln_ate_actions.t_ate_tab(v_idx).id                       := :old.id                       ;
        bln_ate_actions.t_ate_tab(v_idx).legal_owner              := :old.legal_owner              ;
        bln_ate_actions.t_ate_tab(v_idx).energy_type              := :old.energy_type              ;
        bln_ate_actions.t_ate_tab(v_idx).contract_id              := :old.contract_id              ;
        bln_ate_actions.t_ate_tab(v_idx).mpt_code                 := :old.mpt_code                 ;
        bln_ate_actions.t_ate_tab(v_idx).mpt_code_type            := :old.mpt_code_type            ;
        bln_ate_actions.t_ate_tab(v_idx).mpt_object_type          := :old.mpt_object_type          ;
        bln_ate_actions.t_ate_tab(v_idx).in_ara_code              := :old.in_ara_code              ;
        bln_ate_actions.t_ate_tab(v_idx).in_ara_code_type         := :old.in_ara_code_type         ;
        bln_ate_actions.t_ate_tab(v_idx).in_ara_object_type       := :old.in_ara_object_type       ;
        bln_ate_actions.t_ate_tab(v_idx).out_ara_code             := :old.out_ara_code             ;
        bln_ate_actions.t_ate_tab(v_idx).out_ara_code_type        := :old.out_ara_code_type        ;
        bln_ate_actions.t_ate_tab(v_idx).out_ara_object_type      := :old.out_ara_object_type      ;
        bln_ate_actions.t_ate_tab(v_idx).tvalidity_loc_from       := :old.tvalidity_loc_from       ;
        bln_ate_actions.t_ate_tab(v_idx).tvalidity_utc_from       := :old.tvalidity_utc_from       ;
        bln_ate_actions.t_ate_tab(v_idx).lamu_user                := :old.lamu_user                ;
        bln_ate_actions.t_ate_tab(v_idx).lamu_source              := :old.lamu_source              ;
        bln_ate_actions.t_ate_tab(v_idx).lamu_pcs_id              := :old.lamu_pcs_id              ;

    end case;
  exception
    when others then
      pcs_log_actions.log_error(p_module => v_module);
      raise;
  end after each row;

end bln_ate_compound;
/
