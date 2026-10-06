create or replace trigger bln_ofd_compound
for insert or update or delete
on bln_offered_capacity_bids
compound trigger
  /***********************************************************************************************************************
   purpose    : compound trigger for table bln_offered_capacity_bids

   change history
   date        author            version   description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   12-04-2024  R. Brinker        01.00.00  created (TRAN-6667)
   21-06-2024  Nico Klaver       01.01.00  TRAN-6810: kolom document_mrid toegevoegd
   29-07-2024  R. Brinker        01.02.00  TRAN-6749: Hernoemen fout gespelde veldnamen in bln_offered_capacity_bids
   29-01-2025  Xander Pikaar     01.03.00  TRAN-7232: kolom document_mrid hernoemd naar rcn_document_mrid, kolom tmn_document_mrid_sequence toegevoegd
   06-07-2025  Sandjai Ramasray  01.04.00  TRAN-8243 Correctie foutieve UTC-conversiepatronen.
                                           Tevens rcn_document_mrid niet meer wijzigbaar via upd_row (want dan kan je de
                                           connectie tussen rcn_document_mrid en tmn_document_mrid_sequence verliezen)
***********************************************************************************************************************/

  cn_package  constant varchar2(100)             := 'bln_ofd_compound';
  v_module             varchar2(100);
  v_idx                simple_integer            := 0;
  v_lamu_user          varchar2(100)             := nvl(sys_context('USERENV','OS_USER'),USER);
  v_tvalidity_utc_from timestamp                 := sys_extract_utc(systimestamp);
  v_tvalidity_loc_from timestamp                 := sup_date_actions.convertutc2local(p_utc_date => v_tvalidity_utc_from);
  v_lamu_source        varchar2(100)             := nvl(sup_globals.get_global_varchar(p_name => 'SOURCE_SYSTEM'), sup_constants.cn_unknown);
  v_lamu_pcs_id        varchar2(100)             := nvl(sup_globals.get_global_number(p_name => 'PROCESS_ID'), sup_constants.cn_negative_infinite_number);
  e_nontransfer        exception;

  -- BEFORE STATEMENT Section:
  before statement is
  begin
    v_module := cn_package ||'.bst';
    -- Begin Initializations
    -- Clear the plsql-table, because within one session intdba can handle more than one xml-message.
    -- When previous went wrong there is still old data in the table
    bln_ofd_actions.clear_plsql_table;
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
    bln_ofd_actions.journal_rows;
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
       :new.id                 := nvl(:new.id, bln_ofd_seq.nextval);
       :new.lamu_user          := nvl(:new.lamu_user, v_lamu_user);
       :new.tvalidity_loc_from := nvl(:new.tvalidity_loc_from, v_tvalidity_loc_from);
       :new.tvalidity_utc_from := nvl(:new.tvalidity_utc_from, v_tvalidity_utc_from);
       :new.lamu_source        := nvl(:new.lamu_source, v_lamu_source);
       :new.lamu_pcs_id        := nvl(:new.lamu_pcs_id, v_lamu_pcs_id);

     when updating  then
       v_module := cn_package ||'.bur';
       if :new.id                         != :old.id
       or :new.rcn_document_mrid          != :old.rcn_document_mrid
       or :new.tmn_document_mrid_sequence != :old.tmn_document_mrid_sequence
       then
         pcs_log_actions.log_error(p_module => v_module);
         raise e_nontransfer;
       end if;

       -- User en source kunnen gebruikt worden voor commentaar
       :new.lamu_user          := nvl(:new.lamu_user, v_lamu_user);
       :new.lamu_source        := nvl(:new.lamu_source, v_lamu_source);
       :new.tvalidity_loc_from := v_tvalidity_loc_from;
       :new.tvalidity_utc_from := v_tvalidity_utc_from;

       -- lamu_pcs_id behouden als update niet vanuit het reguliere proces gedaan wordt
       if lower(v_lamu_user) = 'oracle' then
          :new.lamu_pcs_id := v_lamu_pcs_id;
       else
          :new.lamu_pcs_id := :old.lamu_pcs_id;
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
    v_idx := nvl(bln_ofd_actions.t_ofd_tab.count,0) + 1;
    bln_ofd_actions.t_ofd_tab(v_idx).jn_cre_user        := v_lamu_user;
    bln_ofd_actions.t_ofd_tab(v_idx).tvalidity_utc_from := v_tvalidity_utc_from;
    bln_ofd_actions.t_ofd_tab(v_idx).tvalidity_loc_from := v_tvalidity_loc_from;
    bln_ofd_actions.t_ofd_tab(v_idx).jn_cre_source      := v_lamu_source;
    bln_ofd_actions.t_ofd_tab(v_idx).jn_cre_pcs_id      := v_lamu_pcs_id;

   case
     when inserting then
       v_module   := cn_package ||'.air';
       bln_ofd_actions.t_ofd_tab(v_idx).jn_action                 := 'INS';
       bln_ofd_actions.t_ofd_tab(v_idx).id                        := :new.id;
       bln_ofd_actions.t_ofd_tab(v_idx).bid_id                    := :new.bid_id;
       bln_ofd_actions.t_ofd_tab(v_idx).rcn_document_mrid         := :new.rcn_document_mrid;
       bln_ofd_actions.t_ofd_tab(v_idx).tmn_document_mrid_sequence         := :new.tmn_document_mrid_sequence;
       bln_ofd_actions.t_ofd_tab(v_idx).capacity_type             := :new.capacity_type;
       bln_ofd_actions.t_ofd_tab(v_idx).market_agreement_type     := :new.market_agreement_type;
       bln_ofd_actions.t_ofd_tab(v_idx).product_type              := :new.product_type;
       bln_ofd_actions.t_ofd_tab(v_idx).acquiring_ara_code        := :new.acquiring_ara_code;
       bln_ofd_actions.t_ofd_tab(v_idx).acquiring_ara_code_type   := :new.acquiring_ara_code_type;
       bln_ofd_actions.t_ofd_tab(v_idx).acquiring_ara_object_type := :new.acquiring_ara_object_type;
       bln_ofd_actions.t_ofd_tab(v_idx).bvalidity_utc_from        := :new.bvalidity_utc_from;
       bln_ofd_actions.t_ofd_tab(v_idx).bvalidity_utc_to          := :new.bvalidity_utc_to;
       bln_ofd_actions.t_ofd_tab(v_idx).direction                 := :new.direction;
       bln_ofd_actions.t_ofd_tab(v_idx).value_meaning             := :new.value_meaning;
       bln_ofd_actions.t_ofd_tab(v_idx).resolution                := :new.resolution;
       bln_ofd_actions.t_ofd_tab(v_idx).capacity                  := :new.capacity;
       bln_ofd_actions.t_ofd_tab(v_idx).capacity_unit             := :new.capacity_unit;
       bln_ofd_actions.t_ofd_tab(v_idx).isp_price                 := :new.isp_price;
       bln_ofd_actions.t_ofd_tab(v_idx).currency_unit             := :new.currency_unit;
       bln_ofd_actions.t_ofd_tab(v_idx).price_measurement_unit    := :new.price_measurement_unit;
       bln_ofd_actions.t_ofd_tab(v_idx).tvalidity_utc_from        := :new.tvalidity_utc_from;
       bln_ofd_actions.t_ofd_tab(v_idx).tvalidity_loc_from        := :new.tvalidity_loc_from;
       bln_ofd_actions.t_ofd_tab(v_idx).lamu_user                 := :new.lamu_user;
       bln_ofd_actions.t_ofd_tab(v_idx).lamu_source               := :new.lamu_source;
       bln_ofd_actions.t_ofd_tab(v_idx).lamu_pcs_id               := :new.lamu_pcs_id;

     when updating  then
       v_module   := cn_package ||'.aur';
       bln_ofd_actions.t_ofd_tab(v_idx).jn_action                 := 'UPD';
       bln_ofd_actions.t_ofd_tab(v_idx).id                        := :old.id;
       bln_ofd_actions.t_ofd_tab(v_idx).bid_id                    := :old.bid_id;
       bln_ofd_actions.t_ofd_tab(v_idx).rcn_document_mrid         := :old.rcn_document_mrid;
       bln_ofd_actions.t_ofd_tab(v_idx).tmn_document_mrid_sequence         := :old.tmn_document_mrid_sequence;
       bln_ofd_actions.t_ofd_tab(v_idx).capacity_type             := :old.capacity_type;
       bln_ofd_actions.t_ofd_tab(v_idx).market_agreement_type     := :old.market_agreement_type;
       bln_ofd_actions.t_ofd_tab(v_idx).product_type              := :old.product_type;
       bln_ofd_actions.t_ofd_tab(v_idx).acquiring_ara_code        := :old.acquiring_ara_code;
       bln_ofd_actions.t_ofd_tab(v_idx).acquiring_ara_code_type   := :old.acquiring_ara_code_type;
       bln_ofd_actions.t_ofd_tab(v_idx).acquiring_ara_object_type := :old.acquiring_ara_object_type;
       bln_ofd_actions.t_ofd_tab(v_idx).bvalidity_utc_from        := :old.bvalidity_utc_from;
       bln_ofd_actions.t_ofd_tab(v_idx).bvalidity_utc_to          := :old.bvalidity_utc_to;
       bln_ofd_actions.t_ofd_tab(v_idx).direction                 := :old.direction;
       bln_ofd_actions.t_ofd_tab(v_idx).value_meaning             := :old.value_meaning;
       bln_ofd_actions.t_ofd_tab(v_idx).resolution                := :old.resolution;
       bln_ofd_actions.t_ofd_tab(v_idx).capacity                  := :old.capacity;
       bln_ofd_actions.t_ofd_tab(v_idx).capacity_unit             := :old.capacity_unit;
       bln_ofd_actions.t_ofd_tab(v_idx).isp_price                 := :old.isp_price;
       bln_ofd_actions.t_ofd_tab(v_idx).currency_unit             := :old.currency_unit;
       bln_ofd_actions.t_ofd_tab(v_idx).price_measurement_unit    := :old.price_measurement_unit;
       bln_ofd_actions.t_ofd_tab(v_idx).tvalidity_utc_from        := :old.tvalidity_utc_from;
       bln_ofd_actions.t_ofd_tab(v_idx).tvalidity_loc_from        := :old.tvalidity_loc_from;
       bln_ofd_actions.t_ofd_tab(v_idx).lamu_user                 := :old.lamu_user;
       bln_ofd_actions.t_ofd_tab(v_idx).lamu_source               := :old.lamu_source;
       bln_ofd_actions.t_ofd_tab(v_idx).lamu_pcs_id               := :old.lamu_pcs_id;

     when deleting  then
       v_module   := cn_package ||'.adr';
       bln_ofd_actions.t_ofd_tab(v_idx).jn_action                 := 'DEL';
       bln_ofd_actions.t_ofd_tab(v_idx).id                        := :old.id;
       bln_ofd_actions.t_ofd_tab(v_idx).bid_id                    := :old.bid_id;
       bln_ofd_actions.t_ofd_tab(v_idx).rcn_document_mrid         := :old.rcn_document_mrid;
       bln_ofd_actions.t_ofd_tab(v_idx).tmn_document_mrid_sequence         := :old.tmn_document_mrid_sequence;
       bln_ofd_actions.t_ofd_tab(v_idx).capacity_type             := :old.capacity_type;
       bln_ofd_actions.t_ofd_tab(v_idx).market_agreement_type     := :old.market_agreement_type;
       bln_ofd_actions.t_ofd_tab(v_idx).product_type              := :old.product_type;
       bln_ofd_actions.t_ofd_tab(v_idx).acquiring_ara_code        := :old.acquiring_ara_code;
       bln_ofd_actions.t_ofd_tab(v_idx).acquiring_ara_code_type   := :old.acquiring_ara_code_type;
       bln_ofd_actions.t_ofd_tab(v_idx).acquiring_ara_object_type := :old.acquiring_ara_object_type;
       bln_ofd_actions.t_ofd_tab(v_idx).bvalidity_utc_from        := :old.bvalidity_utc_from;
       bln_ofd_actions.t_ofd_tab(v_idx).bvalidity_utc_to          := :old.bvalidity_utc_to;
       bln_ofd_actions.t_ofd_tab(v_idx).direction                 := :old.direction;
       bln_ofd_actions.t_ofd_tab(v_idx).value_meaning             := :old.value_meaning;
       bln_ofd_actions.t_ofd_tab(v_idx).resolution                := :old.resolution;
       bln_ofd_actions.t_ofd_tab(v_idx).capacity                  := :old.capacity;
       bln_ofd_actions.t_ofd_tab(v_idx).capacity_unit             := :old.capacity_unit;
       bln_ofd_actions.t_ofd_tab(v_idx).isp_price                 := :old.isp_price;
       bln_ofd_actions.t_ofd_tab(v_idx).currency_unit             := :old.currency_unit;
       bln_ofd_actions.t_ofd_tab(v_idx).price_measurement_unit    := :old.price_measurement_unit;
       bln_ofd_actions.t_ofd_tab(v_idx).tvalidity_utc_from        := :old.tvalidity_utc_from;
       bln_ofd_actions.t_ofd_tab(v_idx).tvalidity_loc_from        := :old.tvalidity_loc_from;
       bln_ofd_actions.t_ofd_tab(v_idx).lamu_user                 := :old.lamu_user;
       bln_ofd_actions.t_ofd_tab(v_idx).lamu_source               := :old.lamu_source;
       bln_ofd_actions.t_ofd_tab(v_idx).lamu_pcs_id               := :old.lamu_pcs_id;
    end case;

  exception
    when others then
      pcs_log_actions.log_error(p_module => v_module);
      raise;

  end after each row;

end bln_ofd_compound;
/
