create or replace trigger bln_are_compound
for insert or update or delete
on bln_activated_reserve_values
compound trigger
  /***********************************************************************************************************************
   purpose    : compound trigger for table bln_activated_reserve_values

   change history
   date        author            version   description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   17-01-2019  N.Wenting         01.00.00  created
   06-11-2019  X. Pikaar         01.01.00  kolom id verwijderd (pk bevat geen id i.v.m. partitionering op bvalidity_utc_from)
                                           journaling van kolom bid_id toegevoegd
   26-05-2020  T. Bakker         01.01.01  TRAN-4036: timestamp vervangen door timestamp with time zone vanwege Z/W tijd
   06-07-2020  X. Pikaar         01.02.00  Auciton_id toegevoegd
   30-11-2020  R. Koomen         01.03.00  TRAN_3088: aan de journal tabel de kolommen tvalidity_xxx_to toegevoegd
   10-12-2020  T. Bakker         01.04.00  TRAN-4402: kolommen power, power_unit en ind_dummy_energy toegevoegd
   21-01-2021  M. Zuijdendorp    01.04.01  TRAN-4518: kolommen nob_code, nob_code_type, nob_object_type toegevoegd
   30-12-2021  Y. Krop           01.04.02  TRAN-5246 Afhandeling reason_code en reason_text toegevoegd
   04-10-2022  X. Pikaar         01.05.00  TRAN-4797: kolommen nob_code, nob_code_type en nob_object_type hernoemd naar
                                           nde_code, nde_code_type en nde_object_type
   16-12-2022  X. Pikaar         01.06.00  TRAN-5965: lamu_pcs_id behouden als wijziging niet vanuit het normale proces komt 
   06-07-2025  Sandjai Ramasray  01.07.00  TRAN-8243 Correctie foutieve UTC-conversiepatronen.
                                           (osuser is dan oracle)
  ***********************************************************************************************************************/

  cn_package            constant     varchar2(100)             := 'bln_are_compound';
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
    bln_are_actions.clear_plsql_table;
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
    bln_are_actions.journal_rows;
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
       -- Bid_id vullen met N/A als deze niet aangeleverd wordt. Het is onderdeel van de PK, maar niet iedere stroom levert een bid_id aan
       :new.bid_id              := nvl(:new.bid_id              ,'N/A'                  );
       :new.lamu_user           := nvl(:new.lamu_user           ,v_lamu_user            );
       :new.tvalidity_loc_from  := nvl(:new.tvalidity_loc_from  ,v_tvalidity_loc_from   );
       :new.tvalidity_utc_from  := nvl(:new.tvalidity_utc_from  ,v_tvalidity_utc_from   );
       :new.lamu_source         := nvl(:new.lamu_source         ,v_lamu_source          );
       :new.lamu_pcs_id         := nvl(:new.lamu_pcs_id         ,v_lamu_pcs_id          );

     when updating  then
       v_module := cn_package ||'.bur';
       if (:new.bvalidity_utc_from <> :old.bvalidity_utc_from) then
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
    v_idx := nvl(bln_are_actions.t_are_tab.count,0) + 1;
    bln_are_actions.t_are_tab(v_idx).jn_cre_user         := v_lamu_user    ;
    bln_are_actions.t_are_tab(v_idx).tvalidity_loc_to    := v_tvalidity_loc_from;
    bln_are_actions.t_are_tab(v_idx).tvalidity_utc_to    := v_tvalidity_utc_from;
    bln_are_actions.t_are_tab(v_idx).jn_cre_source       := v_lamu_source  ;
    bln_are_actions.t_are_tab(v_idx).jn_cre_pcs_id       := v_lamu_pcs_id  ;

    case
      when inserting then
        v_module := cn_package||'.air';
        bln_are_actions.t_are_tab(v_idx).jn_action          := 'INS'                   ;
        bln_are_actions.t_are_tab(v_idx).bvalidity_utc_from := :new.bvalidity_utc_from ;
        bln_are_actions.t_are_tab(v_idx).bvalidity_utc_to   := :new.bvalidity_utc_to   ;
        bln_are_actions.t_are_tab(v_idx).ate_id             := :new.ate_id             ;
        bln_are_actions.t_are_tab(v_idx).direction          := :new.direction          ;
        bln_are_actions.t_are_tab(v_idx).bid_id             := :new.bid_id             ;
        bln_are_actions.t_are_tab(v_idx).auction_id         := :new.auction_id         ;
        bln_are_actions.t_are_tab(v_idx).ptu_resolution     := :new.ptu_resolution     ;
        bln_are_actions.t_are_tab(v_idx).ptu_date_loc       := :new.ptu_date_loc       ;
        bln_are_actions.t_are_tab(v_idx).ptu                := :new.ptu                ;
        bln_are_actions.t_are_tab(v_idx).energy             := :new.energy             ;
        bln_are_actions.t_are_tab(v_idx).energy_unit        := :new.energy_unit        ;
        bln_are_actions.t_are_tab(v_idx).price              := :new.price              ;
        bln_are_actions.t_are_tab(v_idx).currency_unit      := :new.currency_unit      ;
        bln_are_actions.t_are_tab(v_idx).power              := :new.power              ;
        bln_are_actions.t_are_tab(v_idx).power_unit         := :new.power_unit         ;
        bln_are_actions.t_are_tab(v_idx).ind_dummy_energy   := :new.ind_dummy_energy   ;
        bln_are_actions.t_are_tab(v_idx).tvalidity_loc_from := :new.tvalidity_loc_from ;
        bln_are_actions.t_are_tab(v_idx).tvalidity_utc_from := :new.tvalidity_utc_from ;
        bln_are_actions.t_are_tab(v_idx).lamu_user          := :new.lamu_user          ;
        bln_are_actions.t_are_tab(v_idx).lamu_source        := :new.lamu_source        ;
        bln_are_actions.t_are_tab(v_idx).lamu_pcs_id        := :new.lamu_pcs_id        ;
        bln_are_actions.t_are_tab(v_idx).nde_code           := :new.nde_code           ;
        bln_are_actions.t_are_tab(v_idx).nde_code_type      := :new.nde_code_type      ;
        bln_are_actions.t_are_tab(v_idx).nde_object_type    := :new.nde_object_type    ;
        bln_are_actions.t_are_tab(v_idx).reason_code        := :new.reason_code        ;
        bln_are_actions.t_are_tab(v_idx).reason_text        := :new.reason_text        ;

      when updating  then
        v_module  := cn_package||'.aur';
        bln_are_actions.t_are_tab(v_idx).jn_action          := 'UPD'                   ;
        bln_are_actions.t_are_tab(v_idx).bvalidity_utc_from := :old.bvalidity_utc_from ;
        bln_are_actions.t_are_tab(v_idx).bvalidity_utc_to   := :old.bvalidity_utc_to   ;
        bln_are_actions.t_are_tab(v_idx).ate_id             := :old.ate_id             ;
        bln_are_actions.t_are_tab(v_idx).direction          := :old.direction          ;
        bln_are_actions.t_are_tab(v_idx).bid_id             := :old.bid_id             ;
        bln_are_actions.t_are_tab(v_idx).auction_id         := :old.auction_id         ;
        bln_are_actions.t_are_tab(v_idx).ptu_resolution     := :old.ptu_resolution     ;
        bln_are_actions.t_are_tab(v_idx).ptu_date_loc       := :old.ptu_date_loc       ;
        bln_are_actions.t_are_tab(v_idx).ptu                := :old.ptu                ;
        bln_are_actions.t_are_tab(v_idx).energy             := :old.energy             ;
        bln_are_actions.t_are_tab(v_idx).energy_unit        := :old.energy_unit        ;
        bln_are_actions.t_are_tab(v_idx).price              := :old.price              ;
        bln_are_actions.t_are_tab(v_idx).currency_unit      := :old.currency_unit      ;
        bln_are_actions.t_are_tab(v_idx).power              := :old.power              ;
        bln_are_actions.t_are_tab(v_idx).power_unit         := :old.power_unit         ;
        bln_are_actions.t_are_tab(v_idx).ind_dummy_energy   := :old.ind_dummy_energy   ;
        bln_are_actions.t_are_tab(v_idx).tvalidity_loc_from := :old.tvalidity_loc_from ;
        bln_are_actions.t_are_tab(v_idx).tvalidity_utc_from := :old.tvalidity_utc_from ;
        bln_are_actions.t_are_tab(v_idx).lamu_user          := :old.lamu_user          ;
        bln_are_actions.t_are_tab(v_idx).lamu_source        := :old.lamu_source        ;
        bln_are_actions.t_are_tab(v_idx).lamu_pcs_id        := :old.lamu_pcs_id        ;
        bln_are_actions.t_are_tab(v_idx).nde_code           := :old.nde_code           ;
        bln_are_actions.t_are_tab(v_idx).nde_code_type      := :old.nde_code_type      ;
        bln_are_actions.t_are_tab(v_idx).nde_object_type    := :old.nde_object_type    ;
        bln_are_actions.t_are_tab(v_idx).reason_code        := :old.reason_code        ;
        bln_are_actions.t_are_tab(v_idx).reason_text        := :old.reason_text        ;

      when deleting  then
        v_module  := cn_package||'.adr';
        bln_are_actions.t_are_tab(v_idx).jn_action          := 'DEL'                   ;
        bln_are_actions.t_are_tab(v_idx).bvalidity_utc_from := :old.bvalidity_utc_from ;
        bln_are_actions.t_are_tab(v_idx).bvalidity_utc_to   := :old.bvalidity_utc_to   ;
        bln_are_actions.t_are_tab(v_idx).ate_id             := :old.ate_id             ;
        bln_are_actions.t_are_tab(v_idx).direction          := :old.direction          ;
        bln_are_actions.t_are_tab(v_idx).bid_id             := :old.bid_id             ;
        bln_are_actions.t_are_tab(v_idx).auction_id         := :old.auction_id         ;
        bln_are_actions.t_are_tab(v_idx).ptu_resolution     := :old.ptu_resolution     ;
        bln_are_actions.t_are_tab(v_idx).ptu_date_loc       := :old.ptu_date_loc       ;
        bln_are_actions.t_are_tab(v_idx).ptu                := :old.ptu                ;
        bln_are_actions.t_are_tab(v_idx).energy             := :old.energy             ;
        bln_are_actions.t_are_tab(v_idx).energy_unit        := :old.energy_unit        ;
        bln_are_actions.t_are_tab(v_idx).price              := :old.price              ;
        bln_are_actions.t_are_tab(v_idx).currency_unit      := :old.currency_unit      ;
        bln_are_actions.t_are_tab(v_idx).power              := :old.power              ;
        bln_are_actions.t_are_tab(v_idx).power_unit         := :old.power_unit         ;
        bln_are_actions.t_are_tab(v_idx).ind_dummy_energy   := :old.ind_dummy_energy   ;
        bln_are_actions.t_are_tab(v_idx).tvalidity_loc_from := :old.tvalidity_loc_from ;
        bln_are_actions.t_are_tab(v_idx).tvalidity_utc_from := :old.tvalidity_utc_from ;
        bln_are_actions.t_are_tab(v_idx).lamu_user          := :old.lamu_user          ;
        bln_are_actions.t_are_tab(v_idx).lamu_source        := :old.lamu_source        ;
        bln_are_actions.t_are_tab(v_idx).lamu_pcs_id        := :old.lamu_pcs_id        ;
        bln_are_actions.t_are_tab(v_idx).nde_code           := :old.nde_code           ;
        bln_are_actions.t_are_tab(v_idx).nde_code_type      := :old.nde_code_type      ;
        bln_are_actions.t_are_tab(v_idx).nde_object_type    := :old.nde_object_type    ;
        bln_are_actions.t_are_tab(v_idx).reason_code        := :old.reason_code        ;
        bln_are_actions.t_are_tab(v_idx).reason_text        := :old.reason_text        ;

    end case;
  exception
    when others then
      pcs_log_actions.log_error(p_module => v_module);
      raise;
  end after each row;

end bln_are_compound;
/
