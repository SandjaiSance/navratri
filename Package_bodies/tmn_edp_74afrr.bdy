create or replace package body tmn_edp_74afrr
is
  /*********************************************************************************************************************
   Purpose    : EDP_74AFRR publication

   Change History
   Date        Author            Version   Description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   23-05-2024  X. Pikaar         01.00.00  TRAN-6755: Creation
   28-05-2024  X. Pikaar         01.01.01  Bepaling Final/provisional o.b.v. p_runtime_utc i.p.v. sysdate
   13-11-2025  Mirjam Buuts      01.02.00  TRAN-7781 Provisional not timely. Bij de Finals lagere prioriteit aan job geven zodat 
                                           de prosionals voorrang krijgen.
  **********************************************************************************************************************/
  cn_package                      constant  varchar2(100) := 'tmn_edp_74afrr';
  cn_versionnumber                constant  varchar2(100) := '01.02.00';
  cn_process_id                   constant  varchar2(10)  := 'PROCESS_ID';
  cn_publication                  constant varchar2(100) := 'EDP_74AFRR';

  function get_versionnumber
    return varchar2
  is
  begin
    return cn_versionnumber;
  end get_versionnumber;

  procedure schedule_transmission_job(p_publication        in varchar2
                                     ,p_pbn_date_utc_from  in date
                                     ,p_pbn_date_utc_to    in date
                                     ,p_runtime_utc        in timestamp
                                     ,p_priority           in number
                                     )
  is
    cn_module                   constant varchar2(100) := cn_package || 'schedule_transmission_job';
  
    v_mrid                               varchar2(100);
    v_next_version                       number(3);
    v_delay_allowed                      boolean    := FALSE;
  begin
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start'
                              ||chr(10)|| 'p_publication      : ' || p_publication
                              ||chr(10)|| 'p_pbn_date_utc_from: ' || to_char(p_pbn_date_utc_from, sup_constants.cn_utc_date_format)
                              ||chr(10)|| 'p_pbn_date_utc_to  : ' || to_char(p_pbn_date_utc_to  , sup_constants.cn_utc_date_format)
                              ||chr(10)|| 'p_runtime_utc      : ' || to_char(p_runtime_utc      , sup_constants.cn_utc_date_format)
                              ||chr(10)|| 'p_priority         : ' || p_priority
                             );
    -- Get Mrid
    tmn_utilities.get_mrid( p_publication      => cn_publication
                          , p_pbn_date_utc     => p_pbn_date_utc_from
                          , p_tmn_mrid         => v_mrid
                          , p_tmn_next_version => v_next_version
                          );
       
     -- Indien een delay periode is gedefinieerd, dan is een vertraagde start dus toegestaan
     v_delay_allowed         := (sup_ojtppy_actions.get_domain_value(p_ojt_code                => p_publication
                                                                    ,p_ppy_code                => 'START_TRANSMISSION_DELAY'
                                                                    ,p_tvalidity_utc_timestamp => p_runtime_utc
                                                                    ,p_bvalidity_utc_timestamp => p_runtime_utc
                                                                    )
                                 is not null);
   
     pcs_jsr_actions.schedule_job(p_pbn_name           => p_publication
                                 ,p_mrid               => v_mrid
                                 ,p_priority           => p_priority
                                 ,p_bvalidity_utc_from => p_pbn_date_utc_from
                                 ,p_bvalidity_utc_to   => p_pbn_date_utc_to
                                 ,p_delay_allowed      => v_delay_allowed
                                 ,p_runtime_utc        => p_runtime_utc
                                 );
   
     pcs_log_actions.log_trace(p_module => cn_module
                              ,p_text   => 'End'
                              );
   
  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module
                               );
  end schedule_transmission_job;    
 

  procedure start_publication ( p_pbn_date_utc            in timestamp
                              , p_runtime_utc             in timestamp default systimestamp at time zone 'UTC'
                              , p_catch_up_transmission   in varchar2  default 'N'                                
                              )
  /***********************************************************************************************************************************
   Doel        : Publiceren van EDP_74AFRR Aggregated balancing energy bids
                 
                 De provisional versie wordt ieder kwartier gestart.
                 
                 Om 14:00 wordt de volledige vorige dag in losse transmissies gestart.
                 Er wordt gekeken of er een final of provisional publicatie gedaan moet worden, dat is afhankeljk van de starttijd van
                 job publish_edp_74afrr_final en object_property DAYS_FINAL: Als de ptu ligt op de dag DAYS_FINAL geleden (hierbij gaan
                 we uit van de dag om 00:00, en de systimestamp ligt na de starttijd van publish_edp_74afrr_final, dan is het altijd
                 een final publicatie.
                 Ze ook bouwinstructies EDP_74AFRR voor uitleg
  ************************************************************************************************************************************/
  is
    cn_module                constant varchar2(100) := cn_package || '.start_publication';

    v_tmn_xml_result         xmltype;
    v_pbn_date_utc_from      date;
    v_pbn_date_utc_to        date;
    v_end_time_utc           date;
    v_priority               number(1);
    v_final_low_priority     number(1);
    v_days_final             number(5);
    v_publication            varchar2(100);
    v_final_provisional      varchar2(50);
    v_job_run_time_final     varchar2(5);
    v_publication_period     number;
    
    cursor c_job
        is select to_char(nvl(next_run_date, start_date), 'hh24:mi') next_run_time
             from user_scheduler_jobs
            where job_name = 'PUBLISH_EDP_74AFRR_FINAL';

    e_no_final_job           exception;
    
    pragma autonomous_transaction;
  begin
    -- Bij bijdraaien geen nieuw proces aanmaken, die is er al
    if upper(p_catch_up_transmission) = 'N' then  
      pcs_pcs_actions.start_process(p_initiating_procedure => cn_module
                                   ,p_description          => cn_publication
                                   ,p_legal_owner          => sup_constants.cn_legal_owner_ttn
                                   );
    end if;                                   
                                   
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start'
                              ||chr(10)||' p_pbn_date_utc: '||to_char(p_pbn_date_utc, 'dd-mm-yyyy hh24:mi:ss')
                              ||chr(10)||' p_runtime_utc : '||to_char(p_runtime_utc    ,sup_constants.cn_utc_date_format)
                             );


    -- Bepaal of de publicatie een final of provisional moet zijn.
    -- Haal eerst de aantal dagen op voor het bepalen van wanneer een publicatie final is.
    v_days_final                  := sup_ojtppy_actions.get_domain_value_n(p_ojt_code => cn_publication
                                                                          ,p_ppy_code => 'DAYS_FINAL'
                                                                          );
    -- Wanneer draait de final-job weer?
    open c_job;
    
    fetch c_job
     into v_job_run_time_final;                                                             
     
    close c_job;
    
    if v_job_run_time_final is null then
       pcs_log_actions.log_error(p_module      => cn_module
                                ,p_text        => 'Cannot determine provisional or final, job PUBLISH_EDP_74AFRR_FINAL does not exist!'
                                );
       raise e_no_final_job;
    end if;                                

    -- Bepaal nu of we final of provisional draaien.
    if  trunc(sup_date_actions.convertutc2local(p_utc_date       => p_pbn_date_utc))           > trunc(sup_date_actions.convertutc2local(p_utc_date => p_runtime_utc)) - v_days_final
    or (    trunc(sup_date_actions.convertutc2local(p_utc_date   => p_pbn_date_utc))           = trunc(sup_date_actions.convertutc2local(p_utc_date => p_runtime_utc)) - v_days_final  
        and to_char(sup_date_actions.convertutc2local(p_utc_date => p_runtime_utc), 'hh24:mi') < v_job_run_time_final
       ) then
        -- Provisional: vandaag, of gisteren met een runtime voor de runtime van de final-job.
        v_final_provisional            := 'PROVISIONAL';
    else
        -- Final is als het gaat om een dag voor de huidige dag, maar dan ook nog eens met een runtime die vanaf de runtime van de final-job ligt 
        v_final_provisional            := 'FINAL';
    end if;

    v_publication                      := cn_publication || '_' || v_final_provisional;
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Publication kind: '||v_publication
                             );

    -- Bepaal de "standaard" publicatie periode. PROVISIONAL is altijd een kwartier. 
    tmn_utilities.get_period_to_publish(p_publication       => v_publication
                                       ,p_pbn_date_utc      => cast(p_pbn_date_utc as date)
                                       ,p_pbn_date_utc_from => v_pbn_date_utc_from
                                       ,p_pbn_date_utc_to   => v_pbn_date_utc_to
                                       );
                                       
    -- Kijk eerst of we bij moeten draaien, alleen als we niet vanuit het bijdraaien gestart zijn
    if upper(p_catch_up_transmission) = 'N' then
       sup_tse_actions.check_missing_transmissions(p_publication            => v_publication
                                                  ,p_current_bvalidity_utc  => v_pbn_date_utc_from
                                                  ,p_runtime_utc            => p_runtime_utc);
    end if;
                             
     -- Als er moet worden bijgedraad, wordt de priority hier bepaald, zo niet dan in jsr_scheduler_actions
    if upper(p_catch_up_transmission) = 'Y' then
      v_priority := sup_ojtppy_actions.get_domain_value_n(p_ojt_code                => v_publication
                                                         ,p_ppy_code                => 'PRIORITY_CATCH_UP_TRANSMISSION'
                                                         ,p_tvalidity_utc_timestamp => p_runtime_utc
                                                         ,p_bvalidity_utc_timestamp => p_runtime_utc
                                                         );
    end if;
 

    -- Als er bij een final publicatie een specifieke PTU is meegegeven (anders dan lokaal 00:00), alleen die PTU publiceren, zodat je 1 PTU kunt herpubliceren   
    if v_final_provisional      = 'PROVISIONAL' 
    or (    v_final_provisional = 'FINAL'
        and to_char(sup_date_actions.convertutc2local(p_utc_date => v_pbn_date_utc_from), 'hh24:mi') != '00:00'
       ) then
        schedule_transmission_job(p_publication           => v_publication
                                 ,p_pbn_date_utc_from     => v_pbn_date_utc_from
                                 ,p_pbn_date_utc_to       => v_pbn_date_utc_to
                                 ,p_runtime_utc           => p_runtime_utc
                                 ,p_priority              => v_priority
                                 );
    else
        -- lagere prioriteit aan final meegeven waardoor de provisional altijd voor gaat zodat deze tijdig is.
        v_final_low_priority := sup_ojtppy_actions.get_domain_value_n(p_ojt_code                => v_publication
                                                                     ,p_ppy_code                => 'LOWER_PRIORITY_UPDATE_TRANSMISSION'
                                                                     ,p_tvalidity_utc_timestamp => p_runtime_utc
                                                                     ,p_bvalidity_utc_timestamp => p_runtime_utc
                                                                     );
        -- 'Normale Final' die moet voor alle ptu's op de vorige dag een transmissie maken
        v_publication_period           := v_pbn_date_utc_to - v_pbn_date_utc_from;
        v_end_time_utc                 := sup_date_actions.convertlocal2utc(p_loc_date => sup_date_actions.convertutc2local(p_utc_date => v_pbn_date_utc_from) + 1);
      
        -- Bereken de lengte van de publicatieperiode. Door hem te berekenen zijn we voorbereid op een eventuele wijziging naar een andere perioden dan 15 minuten
        while v_pbn_date_utc_from < v_end_time_utc loop
           schedule_transmission_job(p_publication        => v_publication
                                    ,p_pbn_date_utc_from  => v_pbn_date_utc_from
                                    ,p_pbn_date_utc_to    => v_pbn_date_utc_from + v_publication_period
                                    ,p_runtime_utc        => p_runtime_utc
                                    ,p_priority           => v_final_low_priority
                                    );
           v_pbn_date_utc_from         := v_pbn_date_utc_from + v_publication_period;
        end loop;
    end if; 

       -- Commit en het proces alleen beeindigen als we niet aan het bijdraaien zijn
    commit;

    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End'
                             );
   
    if upper(p_catch_up_transmission) = 'N' then
       pcs_pcs_actions.end_process;
    end if;

  exception
    when others then
      commit;

      -- Log xml-bericht, als die gevuld is
      if v_tmn_xml_result is not null
      then
        pcs_message_actions.store_message(p_message => v_tmn_xml_result
                                         ,p_pcs_id  => sup_globals.get_global_number(p_name => cn_process_id));
      end if;

      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Parameters'
                                ||chr(10)|| 'p_pbn_date_utc  : '||        p_pbn_date_utc
                                ||chr(10)|| 'p_runtime_utc   : '||to_char(p_runtime_utc    ,sup_constants.cn_utc_date_format)
                             );
      -- Beeindig het proces
      pcs_pcs_actions.end_process;
  end start_publication;
end tmn_edp_74afrr;
/
