create or replace trigger tcy_tcy_compound
for insert or update or delete
on tcy_transfer_capacities
compound trigger
  /***********************************************************************************************************************
   purpose    : compound trigger for table tcy_transfer_capacity

   change history
   date        author            version   description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   25-05-2018  M.Zuijdendorp     01.00.00   created
   17-01-2020  X. Pikaar         01.00.02  tvalidity-to verlden werden niet gevuld
   26-05-2020  T. Bakker         01.00.03  TRAN-4036: timestamp vervangen door timestamp with time zone vanwege Z/W tijd    
   16-12-2022  X. Pikaar         01.01.00  TRAN-5965: lamu_pcs_id behouden als wijziging niet vanuit het normale proces komt 
   06-07-2025  Sandjai Ramasray  01.02.00  TRAN-8243 Correctie foutieve UTC-conversiepatronen.
                                           (osuser is dan oracle)
  ***********************************************************************************************************************/

  cn_package   constant varchar2(100)            := 'tcy_tcy_compund';
  v_module              varchar2(100);
  v_idx                 simple_integer           := 0;

  v_lamu_user           varchar2(100)            := nvl(sys_context('USERENV','OS_USER'),USER);
  v_tvalidity_utc_from  timestamp                := sys_extract_utc(systimestamp);
  v_tvalidity_loc_from  timestamp                := sup_date_actions.convertutc2local(p_utc_date => v_tvalidity_utc_from);
  v_lamu_source         varchar2(100)            := nvl(sup_globals.get_global_varchar(p_name => 'SOURCE_SYSTEM'), sup_constants.cn_unknown);
  v_lamu_pcs_id         varchar2(100)            := nvl(sup_globals.get_global_number(p_name => 'PROCESS_ID'), sup_constants.cn_negative_infinite_number);

  e_nontransfer         exception;

  -- BEFORE STATEMENT Section:
  before statement is
  begin
    v_module := cn_package ||'.bst';
    -- Begin Initializations
    -- Clear the plsql-table, because within one session intdba can handle more than one xml-message.
    -- When previous went wrong there is still old data in the table
    tcy_tcy_actions.clear_plsql_table;
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
    tcy_tcy_actions.journal_rows;
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
       :new.id                  := nvl(:new.id                  ,tcy_tcy_seq.nextval );
       :new.tvalidity_loc_from  := nvl(:new.tvalidity_loc_from  ,v_tvalidity_loc_from);
       :new.tvalidity_utc_from  := nvl(:new.tvalidity_utc_from  ,v_tvalidity_utc_from);
       :new.lamu_user           := nvl(:new.lamu_user           ,v_lamu_user         );
       :new.lamu_source         := nvl(:new.lamu_source         ,v_lamu_source       );
       :new.lamu_pcs_id         := nvl(:new.lamu_pcs_id         ,v_lamu_pcs_id       );

     when updating  then
       v_module := cn_package ||'.bur';
       if (:new.id <> :old.id) then
         pcs_log_actions.log_error(p_module => v_module);
         raise e_nontransfer;
       end if;
       -- User en source kunnen gebruikt worden voor commentaar
       :new.lamu_user          := nvl(:new.lamu_user   ,v_lamu_user);
       :new.lamu_source        := nvl(:new.lamu_source ,v_lamu_source);
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
    v_idx := nvl(tcy_tcy_actions.t_tcy_tab.count,0) + 1;
    tcy_tcy_actions.t_tcy_tab(v_idx).jn_cre_user         := v_lamu_user    ;
    tcy_tcy_actions.t_tcy_tab(v_idx).tvalidity_loc_to    := v_tvalidity_loc_from;
    tcy_tcy_actions.t_tcy_tab(v_idx).tvalidity_utc_to    := v_tvalidity_utc_from;
    tcy_tcy_actions.t_tcy_tab(v_idx).jn_cre_source       := v_lamu_source  ;
    tcy_tcy_actions.t_tcy_tab(v_idx).jn_cre_pcs_id       := v_lamu_pcs_id  ;

    case
      when inserting then
        v_module := cn_package||'.air';
        tcy_tcy_actions.t_tcy_tab(v_idx).jn_action                      := 'INS'                               ;
        tcy_tcy_actions.t_tcy_tab(v_idx).id                             := :new.id                             ;
        tcy_tcy_actions.t_tcy_tab(v_idx).legal_owner                    := :new.legal_owner                    ;
        tcy_tcy_actions.t_tcy_tab(v_idx).capacity_type                  := :new.capacity_type                  ;
        tcy_tcy_actions.t_tcy_tab(v_idx).in_ara_code                    := :new.in_ara_code                    ;
        tcy_tcy_actions.t_tcy_tab(v_idx).in_ara_code_type               := :new.in_ara_code_type               ;
        tcy_tcy_actions.t_tcy_tab(v_idx).in_ara_object_type             := :new.in_ara_object_type             ;
        tcy_tcy_actions.t_tcy_tab(v_idx).out_ara_code                   := :new.out_ara_code                   ;
        tcy_tcy_actions.t_tcy_tab(v_idx).out_ara_code_type              := :new.out_ara_code_type              ;
        tcy_tcy_actions.t_tcy_tab(v_idx).out_ara_object_type            := :new.out_ara_object_type            ;
        tcy_tcy_actions.t_tcy_tab(v_idx).tvalidity_loc_from             := :new.tvalidity_loc_from             ;
        tcy_tcy_actions.t_tcy_tab(v_idx).tvalidity_utc_from             := :new.tvalidity_utc_from             ;
        tcy_tcy_actions.t_tcy_tab(v_idx).lamu_user                      := :new.lamu_user                      ;
        tcy_tcy_actions.t_tcy_tab(v_idx).lamu_source                    := :new.lamu_source                    ;
        tcy_tcy_actions.t_tcy_tab(v_idx).lamu_pcs_id                    := :new.lamu_pcs_id                    ;

      when updating  then
        v_module  := cn_package||'.aur';
        tcy_tcy_actions.t_tcy_tab(v_idx).jn_action                      := 'UPD'                               ;
        tcy_tcy_actions.t_tcy_tab(v_idx).id                             := :old.id                             ;
        tcy_tcy_actions.t_tcy_tab(v_idx).legal_owner                    := :old.legal_owner                    ;
        tcy_tcy_actions.t_tcy_tab(v_idx).capacity_type                  := :old.capacity_type                  ;
        tcy_tcy_actions.t_tcy_tab(v_idx).in_ara_code                    := :old.in_ara_code                    ;
        tcy_tcy_actions.t_tcy_tab(v_idx).in_ara_code_type               := :old.in_ara_code_type               ;
        tcy_tcy_actions.t_tcy_tab(v_idx).in_ara_object_type             := :old.in_ara_object_type             ;
        tcy_tcy_actions.t_tcy_tab(v_idx).out_ara_code                   := :old.out_ara_code                   ;
        tcy_tcy_actions.t_tcy_tab(v_idx).out_ara_code_type              := :old.out_ara_code_type              ;
        tcy_tcy_actions.t_tcy_tab(v_idx).out_ara_object_type            := :old.out_ara_object_type            ;
        tcy_tcy_actions.t_tcy_tab(v_idx).tvalidity_loc_from             := :old.tvalidity_loc_from             ;
        tcy_tcy_actions.t_tcy_tab(v_idx).tvalidity_utc_from             := :old.tvalidity_utc_from             ;
        tcy_tcy_actions.t_tcy_tab(v_idx).lamu_user                      := :old.lamu_user                      ;
        tcy_tcy_actions.t_tcy_tab(v_idx).lamu_source                    := :old.lamu_source                    ;
        tcy_tcy_actions.t_tcy_tab(v_idx).lamu_pcs_id                    := :old.lamu_pcs_id                    ;

      when deleting  then
        v_module  := cn_package||'.adr';
        tcy_tcy_actions.t_tcy_tab(v_idx).jn_action                      := 'DEL'                               ;
        tcy_tcy_actions.t_tcy_tab(v_idx).id                             := :old.id                             ;
        tcy_tcy_actions.t_tcy_tab(v_idx).legal_owner                    := :old.legal_owner                    ;
        tcy_tcy_actions.t_tcy_tab(v_idx).capacity_type                  := :old.capacity_type                  ;
        tcy_tcy_actions.t_tcy_tab(v_idx).in_ara_code                    := :old.in_ara_code                    ;
        tcy_tcy_actions.t_tcy_tab(v_idx).in_ara_code_type               := :old.in_ara_code_type               ;
        tcy_tcy_actions.t_tcy_tab(v_idx).in_ara_object_type             := :old.in_ara_object_type             ;
        tcy_tcy_actions.t_tcy_tab(v_idx).out_ara_code                   := :old.out_ara_code                   ;
        tcy_tcy_actions.t_tcy_tab(v_idx).out_ara_code_type              := :old.out_ara_code_type              ;
        tcy_tcy_actions.t_tcy_tab(v_idx).out_ara_object_type            := :old.out_ara_object_type            ;
        tcy_tcy_actions.t_tcy_tab(v_idx).tvalidity_loc_from             := :old.tvalidity_loc_from             ;
        tcy_tcy_actions.t_tcy_tab(v_idx).tvalidity_utc_from             := :old.tvalidity_utc_from             ;
        tcy_tcy_actions.t_tcy_tab(v_idx).lamu_user                      := :old.lamu_user                      ;
        tcy_tcy_actions.t_tcy_tab(v_idx).lamu_source                    := :old.lamu_source                    ;
        tcy_tcy_actions.t_tcy_tab(v_idx).lamu_pcs_id                    := :old.lamu_pcs_id                    ;
    end case;

  exception
    when others then
      pcs_log_actions.log_error(p_module => v_module);
      raise;
  end after each row;

end tcy_tcy_compound;
/
