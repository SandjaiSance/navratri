create or replace trigger bln_rcl_compound
for insert or update or delete
on bln_reserve_cpy_bid_details
compound trigger
  /***********************************************************************************************************************************
   purpose    : compound trigger for table bln_reserve_cpy_bid_details

   change history
   date        author            version   description
   ----------  ----------------  --------  -------------------------------------------------------------------------------------------
   18-09-2018  M.Zuijdendorp     01.00.00  created
   24-09-2018  X. Pikaar         01.00.01  Bij de UPD en DEL in de before each row werd de jn_action van de verkeerde package gebruikt
   17-01-2020  X. Pikaar         01.01.00  tvalidity_loc_to en tvalidity_utc_to vullen voor journal-record
   26-05-2020  T. Bakker         01.01.01  TRAN-4036: timestamp vervangen door timestamp with time zone vanwege Z/W tijd   
   16-12-2022  X. Pikaar         01.02.00  TRAN-5965: lamu_pcs_id behouden als wijziging niet vanuit het normale proces komt 
                                           (osuser is dan oracle)
   02-10-2025  Sandjai Ramasray  01.03.00  TRAN-6838: Delphi - Ontvangst - EQUALITY.RESERVES#ENERGY_BID_AFRR - Bouw   
   06-07-2025  Sandjai Ramasray  01.04.00  TRAN-8243 Correctie foutieve UTC-conversiepatronen.
                                           -Journaling verwijderd                                         
  ************************************************************************************************************************************/

  cn_package            constant     varchar2(100)             := 'bln_rcl_compound';
  v_module                           varchar2(100);            

  v_idx                              simple_integer            := 0;

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
       :new.id                  := nvl(:new.id                  ,bln_rcl_seq.nextval);
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

end bln_rcl_compound;
/
