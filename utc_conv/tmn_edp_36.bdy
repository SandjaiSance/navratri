create or replace package body tmn_edp_36
is
 /*********************************************************************************************************************
   Purpose    : EDP_36 publication (Redispatching)

   Change History
   Date        Author            Version   Description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   09-03-2021  R. Standhaft      01.00.00  TRAN-3253 Creation
   12-03-2021  T. Bakker         01.00.01  TRAN-3669 Bouw prio publicaties
   16-10-2021  T. Bakker         01.00.02  TRAN-5144: Automatisch bijdraaien ontbrekende transmissies teogevoegd    
   07-11-2022  X. Pikaar         01.01.00  TRAN-5767: DQF_results-record aanmaken
   18-01-2023  X. Pikaar         01.01.01  DQF-tijden werden niet in UTC berekend
   21-02-2024  X. Pikaar         01.01.02  Fout loggen als er geen dqf_definitions-record gevonden is
   06-07-2025  Sandjai Ramasray  01.02.00  TRAN-8243 Correctie foutieve UTC-conversiepatronen.
  **********************************************************************************************************************/
  cn_package       constant varchar2(20) := 'tmn_edp_36';
  cn_versionnumber constant varchar2(10) := '01.02.00';

  --
  function get_versionnumber
    return varchar2
  is
  begin
    return cn_versionnumber;

  end get_versionnumber;

  --
  procedure start_publication( p_pbn_date_utc            in date
                             , p_runtime_utc             in timestamp default sys_extract_utc(systimestamp)
                             , p_catch_up_transmission   in varchar2  default 'N'                               
                             )
  /***********************************************************************************************************************************
   Doel : Publiceren van EDP_36
          - De parameter p_pbn_date_utc bepaalt voor welke datum de uurwaardes opgehaald worden.
          - De parameter p_runtime_utc wordt nu meegegven voor mogelijk toekomstig gebruik (tijdreizen).
  ************************************************************************************************************************************/
  is
    cn_module           constant varchar2(100) := cn_package || '.start_publication';
    cn_publication      constant varchar2(10)  := 'EDP_36';

    v_delay_allowed              boolean := false;
    v_mrid                       varchar2(100);
    v_pbn_date_utc_from          date;
    v_pbn_date_utc_to            date;
    v_priority                   number(1);
    v_first_checktime_loc        timestamp;

    r_dfn                        dqf_definitions%rowtype;
    r_rst                        dqf_results%rowtype;

    cursor c_dfn(b_process in varchar2)
        is select *
             from dqf_definitions
            where process = b_process;


    pragma autonomous_transaction;

  begin
    -- Bij bijdraaien geen nieuw proces aanmaken, die is er al
    if upper(p_catch_up_transmission) = 'N' then
      pcs_pcs_actions.start_process(p_initiating_procedure => cn_module
                                   ,p_description          => cn_publication
                                   ,p_legal_owner          => sup_constants.cn_legal_owner_ttn
                                   );
    end if;                                   

    -- write 'Start' into log-trace
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start'
                              ||chr(10)||' p_pbn_date_utc    : '||to_char(p_pbn_date_utc   ,sup_constants.cn_utc_date_format)
                              ||chr(10)||' p_runtime_utc     : '||to_char(p_runtime_utc    ,sup_constants.cn_utc_date_format)
                             );

    -- bepaal de publicatie periode
    tmn_utilities.get_period_to_publish(p_publication       => cn_publication
                                       ,p_pbn_date_utc      => p_pbn_date_utc
                                       ,p_pbn_date_utc_from => v_pbn_date_utc_from
                                       ,p_pbn_date_utc_to   => v_pbn_date_utc_to
                                       );

    -- Kijk eerst of we bij moeten draaien, alleen als we niet vanuit het bijdraaien gestart zijn
    if upper(p_catch_up_transmission) = 'N' then
       sup_tse_actions.check_missing_transmissions(p_publication            => cn_publication
                                                  ,p_current_bvalidity_utc  => v_pbn_date_utc_from
                                                  ,p_runtime_utc            => p_runtime_utc);
    end if;
    
    -- Als er moet worden bijgedraad, wordt de priority hier bepaald, zo niet dan in jsr_scheduler_actions
    if upper(p_catch_up_transmission) = 'Y' then
      v_priority := sup_ojtppy_actions.get_domain_value_n(p_ojt_code                => cn_publication
                                                         ,p_ppy_code                => 'PRIORITY_CATCH_UP_TRANSMISSION'
                                                         ,p_tvalidity_utc_timestamp => p_runtime_utc
                                                         ,p_bvalidity_utc_timestamp => p_runtime_utc
                                                         );
    end if;

    -- get Mrid
    tmn_utilities.get_mrid(p_publication  => cn_publication
                          ,p_pbn_date_utc => v_pbn_date_utc_from
                          ,p_tmn_mrid     => v_mrid
                          );
                          
    -- DQF expectations toevoegen
    open c_dfn(b_process => cn_publication);
    
    fetch c_dfn 
     into r_dfn;
     
    if c_dfn%found then
       r_rst.process                 := cn_publication;
       r_rst.check_name              := cn_publication;
       r_rst.bvalidity_utc_from      := v_pbn_date_utc_from;
       r_rst.bvalidity_utc_to        := v_pbn_date_utc_to;
       r_rst.processing_time_utc     := SYS_EXTRACT_UTC(SYSTIMESTAMP);
       r_rst.compliancy_deadline_utc := sup_date_actions.add_interval_to_timestamp_tz(p_ts_tz       => to_timestamp_tz(to_char(v_pbn_date_utc_from, 'yyyymmddhh24miss') || ' UTC', 'yyyymmddhh24miss TZR')
                                                                                     ,p_interval_ym => interval '0' month
                                                                                     ,p_interval_ds =>to_dsinterval(r_dfn.deadline_after_bval_from)
                                                                                     );
                                                                                     
       -- sup_date_actions.add_interval_to_timestamp_tz geeft vreemd genoeg timezone +00:00 terug i.p.v. UTC. Misschien overbodig, 
       -- maar maak er voor de zekerheid keihard UTC van.
       r_rst.compliancy_deadline_utc := to_timestamp_tz(to_char(r_rst.compliancy_deadline_utc, 'ddmmyyyyhh24missxff') || 'UTC'
                                                       ,'ddmmyyyyhh24missxff TZR');
                                                                                     
       dbms_scheduler.evaluate_calendar_string(calendar_string    => r_dfn.first_check_schedule
                                              ,start_date         => sup_date_actions.convertutc2local(p_utc_date => to_timestamp_tz(to_char(v_pbn_date_utc_from, 'yyyymmddhh24miss') || ' UTC', 'yyyymmddhh24miss TZR'))
                                              ,return_date_after  => sup_date_actions.convertutc2local(p_utc_date => to_timestamp_tz(to_char(v_pbn_date_utc_from, 'yyyymmddhh24miss') || ' UTC', 'yyyymmddhh24miss TZR'))
                                              ,next_run_date      => v_first_checktime_loc
                                              );
                                              
       r_rst.first_checktime_utc    := sup_date_actions.convertlocal2utc_ts(p_ts_tz => v_first_checktime_loc);                                           
       dqf_rst_dml.dml_row(p_row => r_rst);
    else
       pcs_log_actions.log_error(p_module => cn_module
                                ,p_text   => 'No dqf_definitions record found for ' || cn_publication); 
    end if;     
    
    close c_dfn;

    -- Indien een delay periode is gedefinieerd, dan is een vertraagde start dus toegestaan
    v_delay_allowed := (sup_ojtppy_actions.get_domain_value(p_ojt_code                => cn_publication
                                                           ,p_ppy_code                => 'START_TRANSMISSION_DELAY'
                                                           ,p_tvalidity_utc_timestamp => p_runtime_utc
                                                           ,p_bvalidity_utc_timestamp => p_runtime_utc
                                                           )
                        is not null);

    -- schedule job
    pcs_jsr_actions.schedule_job(p_pbn_name           => cn_publication
                                ,p_mrid               => v_mrid
                                ,p_priority           => v_priority
                                ,p_bvalidity_utc_from => v_pbn_date_utc_from
                                ,p_bvalidity_utc_to   => v_pbn_date_utc_to
                                ,p_delay_allowed      => v_delay_allowed
                                ,p_runtime_utc        => p_runtime_utc
                                );

    -- write 'End' into log-trace
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End'
                              ||chr(10)||' p_pbn_date_utc    : '||to_char(p_pbn_date_utc   ,sup_constants.cn_utc_date_format)
                              ||chr(10)||' p_runtime_utc     : '||to_char(p_runtime_utc    ,sup_constants.cn_utc_date_format)
                             );

    -- Commit en het proces alleen beeindigen als we niet aan het bijdraaien zijn
    commit;

    if upper(p_catch_up_transmission) = 'N' then
       pcs_pcs_actions.end_process;
    end if;

  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Parameters'
                                ||chr(10)||' p_pbn_date_utc    : '||        p_pbn_date_utc
                                ||chr(10)||' p_runtime_utc     : '||to_char(p_runtime_utc    ,sup_constants.cn_utc_date_format)
                               );
      -- beeindig het proces
      pcs_pcs_actions.end_process;

  end start_publication;

end tmn_edp_36;
/

