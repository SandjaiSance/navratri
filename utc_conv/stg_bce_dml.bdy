create or replace package body stg_bce_dml is

  /***********************************************************************************************************************
   Purpose    : dml_package for table stage_borderarea_capacity_types


   Change history
   Date        Author            Version   Description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   08-11-2023  Y. Krop           01.00.00  TRAN-6393 Creation
   06-07-2025  Sandjai Ramasray  01.01.00  TRAN-8243 Correctie foutieve UTC-conversiepatronen.
  ***********************************************************************************************************************/
  cn_package                      constant varchar2(25)   := 'stg_bce_dml';
  cn_versionnumber                constant varchar2(10)   := '01.01.00';
  cn_process_id                   constant  varchar2(30)  := 'PROCESS_ID';

  function get_versionnumber
    return varchar2
  is
    /**********************************************************************************************************************
     Purpose    : return package version
    **********************************************************************************************************************/
  begin
    return cn_versionnumber;

  end get_versionnumber;

  procedure get_row_pk(p_row in out nocopy stage_borderarea_capacity_types%rowtype)
  is
    /*********************************************************************************************************************
     Purpose    : return complete row based on its pk
    **********************************************************************************************************************/
    cn_module  constant varchar2(100)   := cn_package||'.get_row_pk';

    cursor c_get(b_row stage_borderarea_capacity_types%rowtype)
    is
      select *
      from stage_borderarea_capacity_types bce
      where bce.id = b_row.id;

    r_get c_get%rowtype;

  begin
    open c_get(b_row => p_row);
    fetch c_get into r_get;
    close c_get;

    if r_get.id is not null
    then
      p_row                                := r_get;
    else
      raise no_data_found;
    end if;

  exception
    when no_data_found then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'NODATAFOUND'
                                ||CHR(10)||' searching with primary key id: '||p_row.id
                               );
      raise;
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;

  end get_row_pk;

  procedure ins_row(p_row in out nocopy stage_borderarea_capacity_types%rowtype)
  is
    /*********************************************************************************************************************
     Purpose    : Schrijf record weg in stage_borderarea_capacity_types

    **********************************************************************************************************************/
    cn_module            constant varchar2(61)    := cn_package||'.ins_row';

    v_tvalidity_utc_from          timestamp       := sys_extract_utc(systimestamp);
    v_tvalidity_loc_from          timestamp       := sup_date_actions.convertutc2local(p_utc_date => v_tvalidity_utc_from);
    v_lamu_pcs_id                 varchar2(100)   := nvl(sup_globals.get_global_number(p_name => cn_process_id)
                                                        ,sup_constants.cn_negative_infinite_number);

    pragma autonomous_transaction;

  begin
    insert into stage_borderarea_capacity_types(id
                                               ,bde_id
                                               ,capacity_type
                                               ,transmission_rights_type
                                               ,bvalidity_utc_from
                                               ,bvalidity_utc_to
                                               ,tvalidity_utc_from
                                               ,tvalidity_loc_from
                                               ,lamu_pcs_id)
                                        values (p_row.id
                                               ,p_row.bde_id
                                               ,p_row.capacity_type
                                               ,p_row.transmission_rights_type
                                               ,p_row.bvalidity_utc_from
                                               ,p_row.bvalidity_utc_to
                                               ,v_tvalidity_utc_from
                                               ,v_tvalidity_loc_from
                                               ,v_lamu_pcs_id
                                               );

    commit;

  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module
                               );
      raise;

  end ins_row;

end stg_bce_dml;
/
