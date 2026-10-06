create or replace trigger bln_pan_vle_compound
for insert or update or delete
on bln_pan_values
compound trigger
  /***********************************************************************************************************************
   purpose    : compound trigger for table bln_pan_values

    Change History
    Date        Author            Version   Description
    ----------  ----------------  -------   ------------------------------------------------------------------------------
    14-04-2026  Mirjam Buuts      01.00.00  TRAN-7122: created
    21-05-2026  Xander Pikaar     01.01.00  TRAN=8249: order_marketdocument_mrid toegevoegd als kolom die niet gewijzigd mag worden
    06-07-2025  Sandjai Ramasray  01.02.00  TRAN-8243 Correctie foutieve UTC-conversiepatronen.
  ***********************************************************************************************************************/

  cn_package            constant     varchar2(100)             := 'bln_pan_vle_compound';
  v_module                           varchar2(100);

  v_lamu_user                        varchar2(100)             := nvl(sys_context('USERENV','OS_USER'),USER);
  v_tvalidity_utc_from               timestamp                 := sys_extract_utc(systimestamp);
  v_tvalidity_loc_from               timestamp                 := sup_date_actions.convertutc2local(p_utc_date => v_tvalidity_utc_from);
  v_lamu_source                      varchar2(100)             := nvl(sup_globals.get_global_varchar(p_name => 'SOURCE_SYSTEM'), sup_constants.cn_unknown);
  v_lamu_pcs_id                      varchar2(100)             := nvl(sup_globals.get_global_number(p_name => 'PROCESS_ID'), sup_constants.cn_negative_infinite_number);

  e_nontransfer                      exception;

  -- BEFORE EACH ROW Section:
  before each row is
  begin
    case
     when inserting then
       v_module := cn_package ||'.bir';
       :new.lamu_user           := nvl(:new.lamu_user           ,v_lamu_user          );
       :new.tvalidity_loc_from  := nvl(:new.tvalidity_loc_from  ,v_tvalidity_loc_from );
       :new.tvalidity_utc_from  := nvl(:new.tvalidity_utc_from  ,v_tvalidity_utc_from );
       :new.lamu_source         := nvl(:new.lamu_source         ,v_lamu_source        );
       :new.lamu_pcs_id         := nvl(:new.lamu_pcs_id         ,v_lamu_pcs_id        );

     when updating  then
       v_module := cn_package ||'.bur';
       if (   :new.bvalidity_utc_from        != :old.bvalidity_utc_from
           or :new.pan_id                    != :old.pan_id
           or :new.bid_id                    != :old.bid_id
           or :new.order_marketdocument_mrid != :old.order_marketdocument_mrid
           or :new.direction                 != :old.direction) then
         pcs_log_actions.log_error(p_module => v_module);
         raise e_nontransfer;
       end if;
       -- User en source kunnen gebruikt worden voor commentaar
       :new.lamu_user          := nvl(:new.lamu_user  ,v_lamu_user  );
       :new.lamu_source        := nvl(:new.lamu_source,v_lamu_source);
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

end bln_pan_vle_compound;
/
