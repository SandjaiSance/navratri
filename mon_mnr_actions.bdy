create or replace package body mon_mnr_actions is
   /*********************************************************************************************************************
    Purpose    : Package om monitoring gegevens naar Elastic te sturen d.m.v. pipelined fucntions

    Change History
    Date        Author            Version   Description
    ----------  ----------------  -------   ------------------------------------------------------------------------------
    10-04-2026  Xander Pikaar     01.00.00  TRAN-8198: created
    18-06-2026  Sandjai Ramasray  01.01.00  TRAN-8214: check_missing_ptu_high_res toegevoegd
                                  01.01.01  TRAN-8214:  -exception handler eruit gehaald 
    25-06-2026  Sandjai Ramasray  01.01.02  TRAN-8481: check_technical_errors toegevoegd    
    20-07-2026  Sandjai Ramasray  01.01.03  TRAN-8212: check_message_jobs toegevoegd                
    05-08-2026  Sandjai Ramasray  01.02.00  TRAN-8524: Aether Dashboard: Real-time verwerkingstijd HiRes      
    25-08-2026  Sandjai Ramasray  01.02.01             HiRes geeft nu missing ptu's per product door aan Elastic ipv ptu's.         
    17-09-2026  Sandjai Ramasray  01.03.00  TRAN-8082  Wijziging implementatie get_api_performance
   **********************************************************************************************************************/
   cn_versionnumber        constant varchar2(100) := '01.03.00';
   cn_api_call_performance constant varchar2(20)  := 'API_CALL_PERFORMANCE';
   cn_hi_res               constant varchar2(100) := 'BALANCE_DELTA_HIGH_RES';
   cn_delivery_high_res    constant varchar2(100) := 'EQUALITY.EVENT#BALANCING_INFORMATION_HI_RES';
   cn_technical_error      constant varchar2(100) := 'CHECK_TECHNICAL_ERROR';
   cn_message_jobs         constant varchar2(100) := 'CHECK_MESSAGE_JOBS';
   cn_last_pcs_id          constant varchar2(20)  := 'LAST_PCS_ID';

   function get_versionnumber return varchar2 is
      /**********************************************************************************************************************
       Purpose    : return package version
      **********************************************************************************************************************/
   begin
      return cn_versionnumber;
   end get_versionnumber;

   procedure upd_last_pcs_id (p_pcs_id           in pcs_processes.id%type)
   is
      pragma autonomous_transaction;

      v_last_pcs_id                  pcs_processes.id%type;
   begin
      v_last_pcs_id                   := sup_ojtppy_actions.get_domain_value_n(p_ojt_code  => cn_api_call_performance
                                                                               ,p_ppy_code  => cn_last_pcs_id
                                                                               ,p_silent_mode => 'Y');

      if v_last_pcs_id is null then
         insert into sup_ojt_ppy
                    (ojt_code
                    ,ppy_code
                    ,n_value
                    ,bvalidity_utc_from
                    ,bvalidity_utc_to
                    ,tvalidity_utc_from
                    ,tvalidity_utc_to)
             values (cn_api_call_performance
                    ,cn_last_pcs_id
                    ,p_pcs_id
                    ,systimestamp at time zone 'UTC'
                    ,to_date('31-12-9999','dd-mm-yyyy')
                    ,systimestamp at time zone 'UTC'
                    ,to_date('31-12-9999','dd-mm-yyyy')
                    );
      else
         update sup_ojt_ppy
            set n_value = p_pcs_id
          where ojt_code = cn_api_call_performance
            and ppy_code = cn_last_pcs_id;
      end if;

      commit;
   end upd_last_pcs_id;

   procedure upd_breach_status ( p_information_type    in varchar2
                                ,p_validity_period     in varchar2
                                ,p_call_source         in varchar2
                                ,p_api_call_time       in number
                                ,p_p90_api_call_time   in number
                                ,p_breach_threshold_min in number
                                ,p_breach_start_utc    out timestamp)
   is
      pragma autonomous_transaction;
      
      v_is_breach varchar2(6);
      v_ts        timestamp;
   begin
      v_is_breach := case when p_api_call_time > (p_p90_api_call_time + p_breach_threshold_min) then 'TRUE' else 'FALSE' end;
      
      -- Bepalen breach_start_utc: als breach TRUE dan systimestamp, anders NULL
      if v_is_breach = 'TRUE' then
         v_ts := systimestamp;
      else
         v_ts := null;
      end if;
      
      p_breach_start_utc := v_ts;
      
      merge into mon_api_call_breach_status bs
      using dual on (bs.information_type  = p_information_type 
                 and bs.request_frequency = p_validity_period
                 and bs.call_source       = p_call_source)
      when matched then
          update set bs.in_breach               = v_is_breach,
                     bs.last_breach_checked_utc = systimestamp,
                     bs.breach_start_utc        = case when v_is_breach = 'TRUE' and bs.in_breach = 'FALSE' then 
                                                      v_ts
                                                  when v_is_breach = 'FALSE' then 
                                                      NULL
                                                  else 
                                                      bs.breach_start_utc
                                                  end
      when not matched then
          insert (information_type, request_frequency, call_source, in_breach, breach_start_utc, last_breach_checked_utc)
          values (p_information_type, p_validity_period, p_call_source, v_is_breach, v_ts, systimestamp);
      
      commit;
   end upd_breach_status;

  function get_api_performance (p_save_acl_id            varchar2 default 'TRUE')
     return rt_pcs_api_call_information pipelined
  /*********************************************************************************************************************
     Purpose    : Haal voor iedere API-call de verwerkingstijden op zodat dit door Elastic gebruikt kan worden.
                  In sup_ojt_ppy wordt het laatste acl.id bewaard, zodat de volgende keer vanaf dit id opgevraagd kan worden
   *********************************************************************************************************************/
     
   is
      cursor c_acl_perf (b_last_pcs_id in pcs_processes.id%type)
          is with acl 
             as (select acl.id               as api_call_id
                       ,acl.pcs_id
                       ,acl.information_type  
                       ,case when months_between(acl.bvalidity_utc_to, acl.bvalidity_utc_from) >= 12 then
                          'YEAR'
                        when months_between(acl.bvalidity_utc_to, acl.bvalidity_utc_from) >= 1 then
                          'MONTH'
                        when (acl.bvalidity_utc_to - acl.bvalidity_utc_from) >= 1 then
                          'DAY'
                        when (acl.bvalidity_utc_to - acl.bvalidity_utc_from) * 24 >= 1 then
                          'HOUR'
                        else 
                          'LATEST'
                        end                                                                             as validity_period
                       ,(extract(day from(acl.rest_call_utc_end - acl.rest_call_utc_start)) * 86400 +
                        extract(hour from(acl.rest_call_utc_end - acl.rest_call_utc_start)) * 3600 +
                        extract(minute from(acl.rest_call_utc_end - acl.rest_call_utc_start)) * 60 +
                        extract(second from(acl.rest_call_utc_end - acl.rest_call_utc_start))) * 1000   as rest_call_time    
                       ,acl.response_format
                       ,acl.response_cache_used
                 from aether.pcs_api_calls acl
                 ),
             pcs_calc
             as (select acl.api_call_id
                       ,acl.pcs_id
                       ,acl.information_type
                       ,acl.validity_period
                       ,acl.response_format
                       ,acl.response_cache_used
                       ,pcs.tvalidity_utc_from
                       ,case when rlg_inner.start_timestamp is null then
                           'DOWNLOAD'
                        else
                           'API_CALL'
                        end                      as call_source
                       ,(extract(day from(pcs.pcs_end_utc - pcs.tvalidity_utc_from)) * 86400 +
                         extract(hour from(pcs.pcs_end_utc - pcs.tvalidity_utc_from)) * 3600 +
                         extract(minute from(pcs.pcs_end_utc - pcs.tvalidity_utc_from)) * 60 +
                         extract(second from(pcs.pcs_end_utc - pcs.tvalidity_utc_from))) * 1000                                                 as api_call_time
                       ,nvl(((extract(day from(rlg_inner.end_timestamp - rlg_inner.start_timestamp)) * 86400 +
                         extract(hour from(rlg_inner.end_timestamp - rlg_inner.start_timestamp)) * 3600 +
                         extract(minute from(rlg_inner.end_timestamp - rlg_inner.start_timestamp)) * 60 +
                         extract(second from(rlg_inner.end_timestamp - rlg_inner.start_timestamp))) * 1000) ,acl.rest_call_time)                as rest_call_total_time
                       ,to_char(greatest(nvl(rlg_inner.end_timestamp,pcs.tvalidity_utc_from),pcs.tvalidity_utc_from),'dd-mm-yyyy hh24:mi:ss')   as last_update
                  from acl
                  join aether.pcs_processes pcs on pcs.id = acl.pcs_id
                  left join aether.pcs_rest_logging rlg_inner on rlg_inner.pcs_id = acl.pcs_id
                  left join aether.sup_api_preparation_periods app_inner on app_inner.information_type = acl.information_type
                                                                         and (app_inner.period_in_document = acl.validity_period or
                                                                              acl.validity_period = 'LATEST')
                 )
             select distinct pcs_calc.api_call_id
                   ,mmg.publication_code
                   ,pcs_calc.information_type
                   ,pcs_calc.validity_period
                   ,pcs_calc.api_call_time
                   ,pcs_calc.rest_call_total_time
                   ,pcs_calc.last_update
                   ,pcs_calc.call_source
                   ,pcs_calc.response_format
                   ,pcs_calc.response_cache_used
                   ,mmg.measurement_type
                   ,mmg.warning_threshold_ms
                   ,mmg.breach_threshold_min
                   ,percentile_cont(0.9) within group (order by pcs_calc.api_call_time) over (partition by pcs_calc.information_type, pcs_calc.validity_period, pcs_calc.call_source) as p90_api_call_time
                   ,bs.breach_start_utc
                   ,pcs_calc.pcs_id
               from pcs_calc
             left join mon_monitor_config mmg on mmg.information_type = pcs_calc.information_type
                                             and mmg.call_type         = pcs_calc.call_source
                                             and mmg.request_frequency = pcs_calc.validity_period
                                             and mmg.enabled           = 'TRUE'
             left join mon_api_call_breach_status bs on bs.information_type = pcs_calc.information_type
                                                    and bs.request_frequency = pcs_calc.validity_period
                                                    and bs.call_source = pcs_calc.call_source
              where pcs_calc.pcs_id > b_last_pcs_id
              order by pcs_calc.api_call_id;

      v_last_pcs_id                  pcs_processes.id%type;
      v_breach_start_utc             timestamp;
      v_status                       number;
   begin
      v_last_pcs_id                    := sup_ojtppy_actions.get_domain_value_n(p_ojt_code    => cn_api_call_performance
                                                                               ,p_ppy_code    => cn_last_pcs_id
                                                                               ,p_silent_mode => 'Y');

      if v_last_pcs_id is null then
         select nvl(min(id), 0) as pcs_id
           into v_last_pcs_id
           from aether.pcs_processes pcs
          where pcs.tvalidity_utc_from > cast(systimestamp at time zone 'UTC' - interval '0 01:00:00' day to second as date);

         if v_last_pcs_id = 0 then
            select nvl(max(id), 0) 
              into v_last_pcs_id
              from aether.pcs_processes;
         end if;
      end if;


      for r_acl_perf in c_acl_perf(b_last_pcs_id => v_last_pcs_id) loop
          
          -- Update breach status in separate transaction
          upd_breach_status(p_information_type     => r_acl_perf.information_type
                           ,p_validity_period     => r_acl_perf.validity_period
                           ,p_call_source         => r_acl_perf.call_source
                           ,p_api_call_time       => r_acl_perf.api_call_time
                           ,p_p90_api_call_time   => r_acl_perf.p90_api_call_time
                           ,p_breach_threshold_min => r_acl_perf.breach_threshold_min
                           ,p_breach_start_utc    => v_breach_start_utc);

          if r_acl_perf.warning_threshold_ms is null then
             v_status := 0;
          elsif v_breach_start_utc is not null then
             v_status := 5; -- Red
          elsif nvl(r_acl_perf.api_call_time,0)        > nvl(r_acl_perf.warning_threshold_ms,0) or
                nvl(r_acl_perf.rest_call_total_time,0) > nvl(r_acl_perf.warning_threshold_ms,0) then
             v_status := 3; -- Orange
          else
             v_status := 1; -- Green
         end if;

          pipe row (tt_pcs_api_call_information(r_acl_perf.api_call_id
                                               ,r_acl_perf.publication_code
                                               ,r_acl_perf.information_type
                                               ,r_acl_perf.validity_period
                                               ,r_acl_perf.api_call_time
                                               ,r_acl_perf.rest_call_total_time
                                               ,r_acl_perf.last_update
                                               ,r_acl_perf.call_source
                                               ,r_acl_perf.response_format
                                               ,r_acl_perf.response_cache_used
                                               ,r_acl_perf.measurement_type
                                               ,r_acl_perf.warning_threshold_ms
                                               ,r_acl_perf.breach_threshold_min
                                               ,v_status
                                               ,v_breach_start_utc));

         v_last_pcs_id                 := r_acl_perf.pcs_id;
      end loop;

      if p_save_acl_id = 'TRUE' then
         upd_last_pcs_id (p_pcs_id => v_last_pcs_id);
      end if;
   end get_api_performance;

  function check_missing_ptu_high_res
     return rt_missing_hi_res_ptu pipelined 
  is
  /*********************************************************************************************************************
     Purpose    : Bepaal voor iedere minuut, over een periode van x minuten terug, of er voor die periode gegevens ontbreken.
                  Voor de High Resolution data (balancing_information_hi_res) zijn dat 5 PTU's per minuut.
                  We geven de aantallen per product per minuut door aan Elastic. 
                  In Elastic wordt vervolgens bepaald of we PTU's missen en kan er een alert gegenereerd worden.
    *********************************************************************************************************************/
    -- Constanten voor de verwerking
    cn_delay_seconds   constant number         := sup_ojtppy_actions.get_domain_value_n(p_ojt_code => cn_hi_res
                                                                                       ,p_ppy_code => 'MISSING_PTU_DELAY_SECONDS'
                                                                                       );
    --
    cursor c_bls
        is select bls.id
                , bls.product
             from aether_balancedelta.web_balance_delta_high_res bls
            where trunc(sys_extract_utc(bls.tvalidity_loc_from)) < trunc(sys_extract_utc(systimestamp))
           order by bls.product;

    r_bls c_bls%rowtype;

    v_count_ptu  number;
    v_eval_time  date;
    v_start_time date;

  begin
     -- Er wordt gekeken of er PTUS zijn in de laatste minuut van de huidige tijd.
     v_start_time := trunc(sys_extract_utc(systimestamp), 'mi') ;
     -- We krijgen elk minuut data van afgelopen 5 minuten en de laatste minuut mogen we missen.
     v_eval_time := v_start_time -INTERVAL '1' MINUTE;
     -- met instelbare delay in seconden wordt de evaluatie datumtijd verder in het verleden gezet.
     v_eval_time := v_eval_time - numToDSInterval(cn_delay_seconds, 'second');

     for r_bls in c_bls loop
       select count(*) as aantal_ptu
         into v_count_ptu
         from aether_balancedelta.web_bls_values ble
        where ble.bls_id                              = r_bls.id
          and trunc(ble.timeinterval_start_utc, 'mi') = v_eval_time;
       
       pipe row(tt_missing_hi_res_ptu(r_bls.product
                                    , to_timestamp_tz(to_char(sys_extract_utc(systimestamp), 'dd-mm-yyyy hh24:mi:ss "UTC"'), 'dd-mm-yyyy hh24:mi:ss TZR')
                                    , 5 - v_count_ptu
                                    ));

     end loop; --c_bls
  end check_missing_ptu_high_res;

  function check_technical_errors
     return rt_technical_error pipelined
   is
  /*********************************************************************************************************************
     Purpose    : Bepaal elk half uur, over een periode van 1 uur terug, of er Erros zijn gemeld in de technische logs.
                  De proces, module, message en creation date worden vastgelegd en doorgegeven aan Elastic.
                  In Elastic kan vervolgens bepaald worden of er technische fouten zijn opgetreden en kan er een alert gegenereerd worden.
    *********************************************************************************************************************/
    -- Constanten voor de verwerking
    -- Lijst van zoektermen in message_text voor uitsluiting van logregels uit de analyse
    cn_errors_to_skip  constant  varchar2(4000) := sup_ojtppy_actions.get_domain_value(p_ojt_code => cn_technical_error
                                                                                      ,p_ppy_code => 'ERRORS_TO_SKIP');
    -- Aantal dagen waarover wordt teruggekeken in de technical logs voor het detecteren van errors.
    cn_days_to_check   constant  number         := sup_ojtppy_actions.get_domain_value_n(p_ojt_code => cn_technical_error
                                                                                        ,p_ppy_code => 'DAYS_TO_CHECK');
    v_pattern                    varchar2(4000);
    v_previous_workday           date; 
 
    cursor c_tle (b_previous_workday in date)
    is 
    with zoek_aether as
     (select /*+ MATERIALIZE */
             min(id) id_min
        from aether.pcs_processes pcs
       where pcs.tvalidity_loc_from >= b_previous_workday
     ),
    zoek_balancedelta as
     (select /*+ MATERIALIZE */
             min(id) id_min
        from aether_balancedelta.pcs_processes pcs
       where pcs.tvalidity_loc_from >= b_previous_workday
     )
    select 'aether' schema_name
         , tle.id
         , tle.pcs_id
         , tle.severity
         , tle.message_code
         , tle.message_text
         , tle.module
         , tle.cre_date_utc
      from aether.pcs_technical_log_lines tle
      join zoek_aether zoek on (tle.pcs_id >= zoek.id_min)
     where severity in ('E','F')
       and not regexp_like(tle.message_text, v_pattern, 'i')
    union all
    select 'aether_balancedelta' schema_name
         , tle.id
         , tle.pcs_id
         , tle.severity
         , tle.message_code
         , tle.message_text
         , tle.module
         , tle.cre_date_utc
      from aether_balancedelta.pcs_technical_log_lines tle
      join zoek_balancedelta zoek on (tle.pcs_id >= zoek.id_min)
     where severity in ('E','F')
       and not regexp_like(tle.message_text, v_pattern, 'i')
   ;

    r_tle c_tle%rowtype;

  begin

    v_pattern          := replace(cn_errors_to_skip, ',', '|');
    v_previous_workday := aether.sup_date_actions.get_previous_workday( p_date => sysdate - cn_days_to_check + 1 );

    for r_tle in c_tle (v_previous_workday)  loop

       pipe row(tt_technical_error( r_tle.pcs_id
                                  , r_tle.schema_name
                                  , r_tle.severity
                                  , r_tle.message_code
                                  , r_tle.message_text
                                  , r_tle.module
                                  , to_timestamp_tz(to_char(r_tle.cre_date_utc, 'dd-mm-yyyy hh24:mi:ss "UTC"'), 'dd-mm-yyyy hh24:mi:ss TZR')
                                  ));

    end loop; --c_tle

  end check_technical_errors;

  function check_message_jobs
     return rt_message_jobs pipelined
  is
    /*********************************************************************************************************************
     Purpose    : Bepaal elk minuut de status van message jobs ongelijk aan status 'PROCESSED' en de aantallen.
                  De delivery-code, -omschrijving, period_ts, status en aantallen per worden vastgelegd en doorgegeven aan Elastic.
    *********************************************************************************************************************/
    -- Constanten voor de verwerking
    -- Aantal dagen waarover wordt teruggekeken in de message jobs voor het ophalen van de statussen.
    cn_days_to_check   constant  number         := sup_ojtppy_actions.get_domain_value_n(p_ojt_code => cn_message_jobs
                                                                                        ,p_ppy_code => 'DAYS_TO_CHECK');
    v_previous_workday           date; 
 
    cursor c_message_jobs (b_previous_workday in date)
    is
    select substr(mjb.delivery_code,1 , instr(mjb.delivery_code,'#',1,1)-1) as dlv_code
         , substr(mjb.delivery_code,    instr(mjb.delivery_code,'#',1,1)+1) as dlv_desc                           
         , to_char(to_timestamp(substr(mjb.message_mrid, -12), 'YYYYMMDDHH24MI'), 'DD-MM-YYYY HH24:MI') as period_ts
         , mjb.state                                                        as job_state 
         , count(*)                                                         as job_counts
      from pcs_message_jobs mjb
     where mjb.bvalidity_utc_from >= b_previous_workday
       and mjb.state              <> 'PROCESSED'
   group by mjb.delivery_code
          , mjb.message_mrid
          , mjb.bvalidity_utc_from
          , mjb.state
   order by mjb.bvalidity_utc_from desc;

  begin
    v_previous_workday := aether.sup_date_actions.get_previous_workday( p_date => sysdate - (nvl(cn_days_to_check, 0) + 1) );

    for r_mjb in c_message_jobs (v_previous_workday)  loop
       pipe row(ot_message_job( r_mjb.dlv_code
                              , r_mjb.dlv_desc
                              , r_mjb.period_ts
                              , r_mjb.job_state
                              , r_mjb.job_counts
                              ));

    end loop; --c_message_jobs

  end check_message_jobs;
  --
  function check_bls_processing_time
    return rt_bls_processing_time pipelined
  is
    /*********************************************************************************************************************
     Purpose   : Bepaal elk minuut de verwerkingstijden van de minuut bericht per 12 seconden van de high Res.
                 Direct zichtbaar maken of de actuele verwerkingstijd nog binnen de afgesproken grenswaarden valt.
    *********************************************************************************************************************/

    cursor c_bls_processing
    is
    with latest 
    as (select trunc(max(timeinterval_start_utc),'mi') latest_start_min
          from aether_balancedelta.web_bls_values
       )
    select blu.timeinterval_start_utc
          ,to_char(blu.timeinterval_start_utc,'dd-mm-yyyy hh24:mi:ss') timeinterval_end_char
          ,round(max(extract(day    from (blu.tvalidity_utc_from - blu.timeinterval_end_utc)) * 86400
                   + extract(hour   from (blu.tvalidity_utc_from - blu.timeinterval_end_utc)) * 3600
                   + extract(minute from (blu.tvalidity_utc_from - blu.timeinterval_end_utc)) * 60
                   + extract(second from (blu.tvalidity_utc_from - blu.timeinterval_end_utc))
               ), 1)                      as processing2tval_sec
     from aether_balancedelta.web_bls_values blu
     join latest ltt on trunc(blu.timeinterval_start_utc,'mi') = ltt.latest_start_min 
    group by blu.timeinterval_start_utc
    order by blu.timeinterval_start_utc desc;

  begin
    for r_bls in c_bls_processing  loop
       pipe row(ot_bls_processing_time( r_bls.timeinterval_start_utc
                                      , r_bls.timeinterval_end_char
                                      , r_bls.processing2tval_sec
                                      , 'sec'
                                      ));

    end loop; --c_bls_processing

  end check_bls_processing_time;

  
  function get_bls_message_processing_trend
     return rt_bls_message_processing_time pipelined
   is
    /*********************************************************************************************************************
     Purpose   : Bepaal elk minuut de verwerkingstijd van het ontvangstbericht.
                 Inzicht krijgen in de ontwikkeling van de doorlooptijd door de tijd heen.
    *********************************************************************************************************************/

    cursor c_bls_message_processing
    is
    with latest 
    as (select trunc(max(rcn.bvalidity_utc_from),'mi') latest_start_min
          from aether_balancedelta.pcs_rcn_receptions rcn
          join aether_balancedelta.sup_deliveries dly on dly.id = rcn.dly_id
           and dly.delivery_code = cn_delivery_high_res
       )
    select distinct rcn.bvalidity_utc_to 
          ,to_char(rcn.bvalidity_utc_to,'dd-mm-yyyy hh24:mi:ss') bvalidity_utc_char
          ,round(extract (day    from (pcs.pcs_end_utc - rcn.bvalidity_utc_to)) * 86400000
               + extract(hour   from (pcs.pcs_end_utc - rcn.bvalidity_utc_to)) * 3600000
               + extract(minute from (pcs.pcs_end_utc - rcn.bvalidity_utc_to)) * 60000
               + extract(second from (pcs.pcs_end_utc - rcn.bvalidity_utc_to)) * 1000
               )                                as time_processed_ms
      from aether_balancedelta.pcs_rcn_receptions rcn
      left join aether_balancedelta.pcs_processes pcs on pcs.id = rcn.pcs_id
      join latest ltt on rcn.bvalidity_utc_from >= latest_start_min
    order by rcn.bvalidity_utc_to desc;

  begin

    for r_bls_mpg in c_bls_message_processing  loop
       pipe row(ot_bls_message_processing_time( r_bls_mpg.bvalidity_utc_to
                                              , r_bls_mpg.bvalidity_utc_char
                                              , r_bls_mpg.time_processed_ms
                                              , 'ms'
                                              ));

    end loop; --c_bls_message_processing

  end get_bls_message_processing_trend;


-- Even laten staan, handig voor later....
--   function check_pcs_job_scheduler
--     return rt_pcs_job_scheduler_information pipelined
--   is
--     /*******************************************************************************************************************************
--      Purpose    : Controleer of pcs_job_Scheduler op aantallen per status. Jobs met status PLANNED of RUNNING zonder bijbehorend
--                   record in dba_scheduler_jobs zijn sowieso fout.
--                   Hier kunnen Elastic alerts op gebouwd worden
--     ********************************************************************************************************************************/
--     cn_module               constant varchar2(100) := cn_package || '.check_pcs_job_scheduler';
--
--     cursor c_job_status
--         is -- Jobs die draaien of gepland zijn met bijbehorende job in dba_scheduler_jobs.
--            -- bij deze kunnen we kijken of er niet teveel in 1 seconde zijn gepland. Wellicht een
--            select distinct status                    as job_status
--                           ,priority
--                           ,total_amount_status
--                           ,start_date_utc
--                           ,amount_prio_start_date_utc
--                           ,oldest
--                           ,case when amount_prio_start_date_utc > sup_ojtppy_actions.get_domain_value_n(p_ojt_code    => 'SCHEDULED_JOBS'
--                                                                                                        ,p_ppy_code    => 'MAX_RUNNING_JOBS_PRIO_' || priority
--                                                                                                        ,p_silent_mode => 'Y'
--                                                            ) then
--                              'WARNING too many jobs with the same priority at the same time'
--                            else
--                              'OK'
--                            end state
--              from (select status
--                           ,priority
--                           ,cast(planned_start_date_utc as date)                                             as start_date_utc
--                           ,count(*)                over (partition by priority, cast(planned_start_date_utc as date)) as amount_prio_start_date_utc
--                           ,min(tvalidity_loc_from) over (partition by status)                               as oldest
--                           ,count(*)                over (partition by status)                               as total_amount_status
--                       from aether.pcs_job_scheduler  jsr
--                      where (    scheduled_job_name in (select job_name
--                                                          from dba_scheduler_jobs
--                                                        )
--                             and status in ('PLANNED', 'RUNNING')
--                            )
--                         or status = 'SCHEDULED'
--                    )
--              union
--              -- Jobs met status PLANNED en RUNNING die niet meer bestaan
--              select distinct status
--                             ,priority
--                             ,total_amount_status
--                             ,start_date_utc
--                             ,amount_prio_start_date_utc
--                             ,oldest
--                             ,'FAILURE'
--                from (select status
--                            ,priority
--                            ,cast(planned_start_date_utc as date)                                             as start_date_utc
--                            ,count(*)                over (partition by priority, cast(planned_start_date_utc as date)) as amount_prio_start_date_utc
--                            ,min(tvalidity_loc_from) over (partition by status)                               as oldest
--                            ,count(*)                over (partition by status)                               as total_amount_status
--                       from aether.pcs_job_scheduler  jsr
--                      where scheduled_job_name not in (select job_name
--                                                         from dba_scheduler_jobs
--                                                      )
--                        and status in ('PLANNED', 'RUNNING')
--                     );
--   begin
--     for r_job_status in c_job_status loop
--         pipe row(tt_pcs_job_scheduler_information(r_job_status.job_status
--                                                  ,r_job_status.priority
--                                                  ,r_job_status.total_amount_status
--                                                  ,r_job_status.start_date_utc
--                                                  ,r_job_status.amount_prio_start_date_utc
--                                                  ,r_job_status.oldest
--                                                  ,r_job_status.state));
--     end loop;
--
--   end check_pcs_job_scheduler;

end mon_mnr_actions;
/