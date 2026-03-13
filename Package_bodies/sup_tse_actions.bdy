create or replace package body sup_tse_actions
is
  /*********************************************************************************************************************
   Purpose    : Controleer ontbrekende transmissies sinds de laatste verzonden transmissie en start deze transmissies
                alsnog

   Change History
   Date        Author            Version   Description
   ----------  ----------------  -------   ------------------------------------------------------------------------------
   15-05-2019  X. Pikaar         01.00.00  creatie
   31-05-2019  Y. Krop           01.00.01  Sonar-melding m.b.t. trailing spaces opgelost.
   12-06-2019  X. Pikaar         01.00.02  Ophalen object_property CATCH_UP_TRANSMISSION_ALLOWED haalde de numerieke
                                           waarde op i.p.v. alfanumerieke
                                           Bij het bepalen van de laatste transmissie de bvalidities met elkaar vergelijken
                                           i.p.v. de rundate. Anders kan je de laatste missen
   01-07-2019  M. Slobbe         01.00.03  Pbn_id opgenomen in sup_tmn_periods_gtt, en opgenomen in cursor c_catch_up_tmns
   26-08-2020  R.Koomen          01.01.00  TRAN-4289: De berekeningen met intervallen en timestamps bijgewerkt om problemen 
                                                      met zomer- wintertijd te voorkomen.
   21-01-2022  X. Pikaar         01.02.00  process_globals bewaren en terugzetten rondom het starten van gemiste publicaties
   12-09-2022  Nico Klaver       01.03.00  TRAN-5721: In check_missing_transmissions sup_constants.cn_tmn_state_sending ook 
                                           meenemen voor de webservice stromen
   26-02-2026  Sandjai Ramasray  01.04.00  TRAN-8067 Bijwerken sup_transmission_schedules en het slimmer maken                                           
   **********************************************************************************************************************/
  cn_package                  constant varchar2(100) := 'sup_tse_actions';
  cn_versionnumber            constant varchar2(100) := '01.04.00';
  cn_process_id               constant varchar2(100) := 'PROCESS_ID';
  --
  function get_versionnumber
  return varchar2
  is
    /**********************************************************************************************************************
     Purpose    : return package version
    **********************************************************************************************************************/
  begin
    return cn_versionnumber;
  end get_versionnumber;

 procedure check_missing_transmissions(p_publication            in varchar2
                                       ,p_current_bvalidity_utc in timestamp
                                       ,p_runtime_utc           in timestamp)
  is
     cn_module                     constant varchar2(61) := cn_package || '.check_missing_transmissions';
     cn_catch_up_allowed           constant varchar2(50) := 'CATCH_UP_TRANSMISSION_ALLOWED';

     v_starttime_utc                        timestamp;
     v_runtime_utc                          timestamp;
     v_pbn_date_utc                         timestamp;
     v_statement                            varchar2(32767);
     v_mrid                                 varchar2(35);
     v_interval_ym                          interval year to month;
     v_interval_ds                          interval day to second;
     v_pcs_id                               pcs_processes.id%type;
     
     -- Zoek de bvalidity van de laatste transmissie die status ENQUEUED heeft (Als er een status ENQUEUED is, hebben we hem verstuurd).
     -- We kunnen niet de create_date van het transmissie-record gebruiken om de laatste te zoeken, omdat er na de laatste transmissie
     -- die door de job gestart is nog een handmatige transmissie gestart kan zijn.
     -- Als er nooit een status supplied is geweest gaan we uit van de begindatum van sup_transmission_schedules
     -- Die moet dus wel een beetje handig gekozen worden
     -- Time-driven publicaties worden uit User_Scheduler_Jobs gehaald en de starttime bepaald door de runtijd van de job.
     -- Data-driven publicaties zijn in Sup_Transmission_Schedules opgeslagen.
     cursor c_tse (b_publication         in sup_publications.name%type)
         is
         with publications
         as (select pbn.id                  as pbn_id
                   ,tse.run_schedule        --Bijv.: freq=daily; byhour=11; byminute=00
                   ,tse.pbn_date_expression --Bijv.: cast(trunc(sup_date_actions.convertutc2local(p_startdate_utc) + 7) as timestamp) at time zone 'UTC'
                   ,tse.bvalidity_utc_from  as starttime_utc
               from sup_publications pbn
               join sup_transmission_schedules tse on tse.pbn_id = pbn.id
               left join sup_publication_switches pss on pss.pbn_id    = pbn.id 
                                                     and sup_date_actions.convertlocal2utc(p_loc_date => sysdate) between pss.bvalidity_utc_from 
                                                                                                                      and pss.bvalidity_utc_to -- we sluiten afgesloten publicaties uit
              where pbn.name        = b_publication 
                and pbn.name not like 'TDW%'
             union
             select pbn.id                  as pbn_id
                   ,sjb.repeat_interval     as run_schedule
                   ,nvl(replace(replace(trim(regexp_substr(sjb.job_action
                                            ,'p_pbn_date_utc\s*=>\s*(.+?)\s*\)\s*[,;]'
                                            ,1, 1, null, 1)
                                            )
                                      ,'systimestamp'
                                      ,'p_startdate_utc')
                               ,'sysdate'
                               ,'p_startdate_utc')
                       ,sjb.job_action )    as pbn_date_expression
                   ,sjb.last_start_date      as starttime_utc
               from user_scheduler_jobs sjb
               join sup_publications pbn on instr(sjb.job_name, pbn.name,1) > 0
               join sup_publication_switches pss on pss.pbn_id    = pbn.id 
                                                and sup_date_actions.convertlocal2utc(p_loc_date => sysdate) between pss.bvalidity_utc_from 
                                                                                                                 and pss.bvalidity_utc_to -- we sluiten afgesloten publicaties uit
             where pbn.name        = b_publication 
               and pbn.name not like 'TDW%'
               and sjb.enabled     = 'TRUE' -- alleen actieve jobs
          )
          select pbn.pbn_id
                ,pbn.run_schedule        
                ,pbn.pbn_date_expression 
                ,max(nvl(tmn.bvalidity_utc_from, pbn.starttime_utc)) as starttime_utc
            from publications pbn
          left outer join (select tmn.pbn_id
                                 ,tmn.bvalidity_utc_from
                             from pcs_tmn_transmissions tmn
                             join pcs_tmn_states ste on (ste.tmn_id = tmn.id and
                                                          ste.state in ('ENQUEUED', 'SENDING'))) tmn on tmn.pbn_id = pbn.pbn_id
          group by pbn.run_schedule
                  ,pbn.pbn_date_expression
                  ,pbn.pbn_id;

     r_tse     c_tse%rowtype;

     -- Expressies om a.d.h.v. de runtime de bvalidity te bepalen -> klopt niet! We hebben de bvalidity, daar moeten we het runmoment bij hebben
     cursor c_pbn_date (b_runtime_utc         in timestamp
                       ,b_pbn_date_expression in varchar2)
         is select replace(b_pbn_date_expression
                          ,'p_startdate_utc'
                          ,'to_timestamp('''||to_char(b_runtime_utc, 'dd-mm-yyyy hh24:mi:ss') ||''',''dd-mm-yyyy hh24:mi:ss'')')
              from dual;

    -- Bekijk welke niet voldoende gepubliceerd zijn. Dit moeten we doen omdat we soms voor dezelfde bvalidity vaker een publicatie moeten doen
    -- bijvoorbeeld bij dagpublicaties die ieder uur een update krijgen (b.v. EDP_28)
    cursor c_catch_up_tmns
        is with tpg as -- transmissies die gedaan moeten worden
                   (select tpg.bvalidity_utc_from
                          ,tpg.mrid
                          ,count(tpg.mrid)        as amount_to_publish
                          ,tpg.pbn_id
                        from sup_tmn_periods_gtt tpg
                       group by tpg.bvalidity_utc_from
                               ,tpg.mrid
                               ,tpg.pbn_id)
               ,tmn as -- transmissies die gedaan zijn. Hier kijken we naar transmissies die status enqueued hebben gehaald, daardoor worden
                       -- transmissies die niet enqueued zijn nog een keer geprobeerd
                   (select tmn.bvalidity_utc_from
                          ,tmn.mrid
                          ,count(tmn.mrid)        as amount_published
                          ,tmn.pbn_id
                      from pcs_tmn_transmissions tmn
                      join (select distinct tpg.mrid
                              from sup_tmn_periods_gtt tpg)  tpg on tpg.mrid   = tmn.mrid
                      join pcs_tmn_states                    tse on tse.tmn_id = tmn.id
                     where tse.state in (sup_constants.cn_tmn_state_enqueued
                                        ,sup_constants.cn_tmn_state_sending)
                      group by tmn.bvalidity_utc_from
                              ,tmn.mrid
                              ,tmn.pbn_id)
               select tpg.bvalidity_utc_from
                     ,tpg.amount_to_publish
                     ,nvl(tmn.amount_published,0) as amount_published
                 from tpg
                 left outer join tmn on ( tpg.mrid    = tmn.mrid
                                      and tpg.pbn_id  = tmn.pbn_id)  -- het kan zijn dat er nog nooit een transmissie is geweest
               order by bvalidity_utc_from asc;

  begin
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start'
                              ||chr(10)||' p_publication            : '||p_publication
                              ||chr(10)||' p_current_bvalidity_utc  : '||to_char(p_current_bvalidity_utc, 'dd-mm-yyyy hh24:mi:ss')
                             );

    if upper(sup_ojtppy_actions.get_domain_value(p_ojt_code                => p_publication
                                                ,p_ppy_code                => cn_catch_up_allowed
                                                ,p_tvalidity_utc_timestamp => p_runtime_utc
                                                ,p_bvalidity_utc_timestamp => p_runtime_utc
                                                )
            ) = 'Y' then

       -- Bepaal voor deze publicatie het startmoment
       open c_tse (b_publication => p_publication);

       fetch c_tse
        into r_tse;

       if c_tse%found  -- Als die niet bestaat is er (nog) geen transmission_schedule-record voor deze publicatie en doet hij nog niet mee in het bijdraaien.
       then
          v_starttime_utc                      := r_tse.starttime_utc;

          -- Controleer de laatst geslaagde bvalidity ook nog een keer, het kan zijn dat deze bvalidity meerdere keren moet gaan en nu juist mislukt is
          -- Ga daarom (ongeveer) 1 run-interval terug in de tijd om te starten met de controle. We gaan hiermee terug in de tijd voor de laatste die ENQUEUED is
          -- bij de definitieve bepaling welke bijgedraaid moeten worden sluiten we die oudere weer uit
          v_interval_ym := to_yminterval('00-00');
          v_interval_ds := to_dsinterval('0 00:00:00');
          case
              when instr(lower(r_tse.run_schedule), 'yearly') > 0 then
                   v_interval_ym := to_yminterval('-01-00');
              when instr(lower(r_tse.run_schedule), 'monthly') > 0 then
                   v_interval_ym := to_yminterval('-00-01');
              when instr(lower(r_tse.run_schedule), 'weekly') > 0 then
                   v_interval_ds := to_dsinterval('-7 00:00:00');
              when instr(lower(r_tse.run_schedule), 'daily') > 0 then
                   v_interval_ds := to_dsinterval('-1 00:00:00');
              when instr(lower(r_tse.run_schedule), 'hourly') > 0 then
                   v_interval_ds := to_dsinterval('-0 01:00:00');
              when instr(lower(r_tse.run_schedule), 'minutely') > 0 then
                   -- Bij een publicatie die iedere zoveel minuten afgaat ook een uur terug, straks wordt toch gekeken welke echt opgemist zijn
                   v_interval_ds := to_dsinterval('-0 01:00:00');
              when instr(lower(r_tse.run_schedule), 'secondly') > 0 then
                   -- Bij een publicatie die iedere zoveel seconde afgaat 5 minuten terug, straks wordt toch gekeken welke echt opgemist zijn
                   v_interval_ds := to_dsinterval('-0 00:05:00');
              else
                   -- iets anders? dan een dag terug, maar dat kan eigenlijk helemaal niet
                   v_interval_ds := to_dsinterval('-1 00:00:00');
          end case;
          v_runtime_utc := sup_date_actions.add_interval_to_timestamp_tz( r_tse.starttime_utc, v_interval_ym, v_interval_ds );

          -- Bepaal alle transmissies die vanaf het zojuist bepaalde startmoment hadden moeten draaien
          <<schedule_loop>>
          while v_runtime_utc < p_current_bvalidity_utc loop
              dbms_scheduler.evaluate_calendar_string(calendar_string    => r_tse.run_schedule       -- b.v. 'freq=hourly;byminute=0,15,30,45;bysecond=0'
                                                     ,start_date         => v_starttime_utc
                                                     ,return_date_after  => v_runtime_utc            -- De volgende runtime
                                                     ,next_run_date      => v_runtime_utc
                                                     );

               -- Bepaal de pbn_date_utc die bij deze starttijd zou horen
               open c_pbn_date (b_runtime_utc         => v_runtime_utc
                               ,b_pbn_date_expression => r_tse.pbn_date_expression);

               fetch c_pbn_date
                into v_statement;
               close c_pbn_date;

               -- Bepaal de publicatieperiode van deze transmissie. Die is niet de PERIOD_TO_PUBLISH_START uit sup_ojt_ppy, omdat de echte pbn_date_utc in de job
               -- bepaald wordt.
               execute immediate 'select ' || v_statement || ' as pbn_date_utc from dual '
                  into v_pbn_date_utc;

              -- Als we nu op of na de huidige bvalidity uitkomen (dat is de bvalidity van de originele transmissie), dan mag dit geen transmissie triggeren, anders
              -- krijgen we dubbelen, of gaan we te ver de toekomst in.

              if v_pbn_date_utc < p_current_bvalidity_utc then
                 -- Bepaal de mrid van deze transmissie, hebben we nodig om straks in pcs_tmn_transmissions te zoeken
                 tmn_utilities.get_mrid(p_publication  => p_publication
                                       ,p_pbn_date_utc => v_pbn_date_utc
                                       ,p_tmn_mrid     => v_mrid);

                 -- Sla de  bepaalde waarden op in een global temporary table
                 insert into sup_tmn_periods_gtt
                            (job_starttime
                            ,bvalidity_utc_from
                            ,mrid
                            ,pbn_id)
                     values (v_runtime_utc
                            ,v_pbn_date_utc
                            ,v_mrid
                            ,r_tse.pbn_id);
              end if;
          end loop schedule_loop;

          -- Schedule nu alle ontbrekende transmissies. Hier wordt het aantal gestartte publicaties vergeleken met het aantal te starten.
          -- Publicaties die alleen gestart zijn, maar nooit op ENQUEUED gekomen zullen niet herstart worden als ze het benodigde aantal maal gestart zijn!
          v_pcs_id                     := sup_globals.get_global_number(p_name => cn_process_id);
          sup_globals.save_process_globals;
          
          <<catch_up_loop>>
          for r_catch_up_tmns in c_catch_up_tmns loop
            if  r_catch_up_tmns.amount_to_publish  >  r_catch_up_tmns.amount_published
            and r_catch_up_tmns.bvalidity_utc_from >= v_starttime_utc -- De laatste enqueued nemen we nog mee, maar niet verder terug kijken
            then
               -- We gebruiken de transmissie-package weer om de transmissie te starten. Parameter p_catch_up_transmission moet nu 'Y' zijn, anders gaat het
               -- bijdraai-feest opnieuw beginnen en blijt hij zichzelf oneindig opstarten
               v_statement    := 'begin '
                              || '  tmn_' || p_publication || '.start_publication(p_pbn_date_utc => to_timestamp(''' || to_char(r_catch_up_tmns.bvalidity_utc_from,'dd-mm-yyyy hh24:mi:ss') || ''',''dd-mm-yyyy hh24:mi:ss'')'
                              ||                                               ' ,p_catch_up_transmission => ''Y'');'
                              || 'end;';

                pcs_log_actions.log_info(p_module => cn_module
                                        ,p_text   => 'Catch-up publication '
                                                  || p_publication
                                                  || ', bvalidity_utc_from: '
                                                  || to_char(r_catch_up_tmns.bvalidity_utc_from,'dd-mm-yyyy hh24:mi:ss')
                                );
               execute immediate v_statement;
               
               -- Zet pcs_id terug, anders heb je die uit de tmn_package
               sup_globals.set_global(p_name  => cn_process_id
                                     ,p_value => v_pcs_id);
            end if;
          end loop catch_up_loop;
          
          sup_globals.restore_process_globals(p_pcs_id => v_pcs_id);
       end if;

       close c_tse;
    else
       pcs_log_actions.log_info(p_module => cn_module
                               ,p_text   => 'Catch-up not allowed for this publication'
                               );
    end if;

    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End'
                             );

  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Parameters'
                              ||chr(10)||' p_publication   : '||p_publication
                             );
  end check_missing_transmissions;

end sup_tse_actions;
/
