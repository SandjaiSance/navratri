create or replace package body stg_gnt_dml is

  /***********************************************************************************************************************
   Purpose    : dml_package for table stage_generation_and_load_units


   Change history
   Date        Author            Version   Description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   07-12-2023  Y. Krop           01.00.00  TRAN-6405 Creation
   06-07-2025  Sandjai Ramasray  01.01.00  TRAN-8243 Correctie foutieve UTC-conversiepatronen.
  ***********************************************************************************************************************/
  cn_package                      constant varchar2(25) := 'stg_gnt_dml';
  cn_versionnumber                constant varchar2(10) := '01.01.00';
  cn_process_id                   constant varchar2(30) := 'PROCESS_ID';

  function get_versionnumber
    return varchar2
  is
    /**********************************************************************************************************************
     Purpose    : return package version
    **********************************************************************************************************************/
  begin
    return cn_versionnumber;

  end get_versionnumber;

  procedure get_row_pk(p_row in out nocopy stage_generation_and_load_units%rowtype)
  is
    /*********************************************************************************************************************
     Purpose    : return complete row based on its pk
    **********************************************************************************************************************/
    cn_module  constant varchar2(100)   := cn_package||'.get_row_pk';

    cursor c_get(b_row stage_generation_and_load_units%rowtype)
    is
      select *
        from stage_generation_and_load_units gnt
       where gnt.id = b_row.id;

    r_get c_get%rowtype;

  begin
    open c_get(b_row => p_row);
    fetch c_get into r_get;
    close c_get;

    if r_get.id is not null
    then
      p_row := r_get;
    else
      raise no_data_found;
    end if;

  exception
    when no_data_found then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'NODATAFOUND'
                                ||chr(10)||' searching with primary key id: '||p_row.id
                               );
      raise;
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;

  end get_row_pk;

  procedure ins_row(p_row in out nocopy stage_generation_and_load_units%rowtype)
  is
    /*********************************************************************************************************************
     Purpose    : Schrijf record weg in stage_generation_and_load_units

    **********************************************************************************************************************/
    cn_module            constant varchar2(61)    := cn_package||'.ins_row';

    v_tvalidity_utc_from          timestamp       := sys_extract_utc(systimestamp);
    v_tvalidity_loc_from          timestamp       := sup_date_actions.convertutc2local(p_utc_date => v_tvalidity_utc_from);
    v_lamu_pcs_id                 varchar2(100)   := nvl(sup_globals.get_global_number(p_name => cn_process_id)
                                                        ,sup_constants.cn_negative_infinite_number);

    pragma autonomous_transaction;

  begin
    insert into stage_generation_and_load_units
                   (id
                   ,stn_id
                   ,fte_id
                   ,ean_code
                   ,eic_code
                   ,ucte_code
                   ,field_code
                   ,name
                   ,parent_gnt_id
                   ,minimum_bandwidth
                   ,maximum_bandwidth
                   ,maximum_ramp_rate
                   ,object_type
                   ,ato_business_type
                   ,must_run
                   ,marginal_cost
                   ,bvalidity_utc_from
                   ,bvalidity_utc_to
                   ,tvalidity_utc_from
                   ,tvalidity_loc_from
                   ,lamu_pcs_id
                   )
            values (p_row.id
                   ,p_row.stn_id
                   ,p_row.fte_id
                   ,p_row.ean_code
                   ,p_row.eic_code
                   ,p_row.ucte_code
                   ,p_row.field_code
                   ,p_row.name
                   ,p_row.parent_gnt_id
                   ,p_row.minimum_bandwidth
                   ,p_row.maximum_bandwidth
                   ,p_row.maximum_ramp_rate
                   ,p_row.object_type
                   ,p_row.ato_business_type
                   ,p_row.must_run
                   ,p_row.marginal_cost
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

end stg_gnt_dml;
/
