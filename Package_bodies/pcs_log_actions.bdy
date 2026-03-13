create or replace package body pcs_log_actions is

  /***********************************************************************************************************************************
   Purpose    : do all the things for logging

   Change History
   Date        Author            Version   Description
   ----------  ----------------  -------   -------------------------------------------------------------------------------------------
   06-03-2017  A Kluck           01.00.00  created
   10-04-2017  X. Pikaar         01.00.01  Rollback alleen in log_ins doen. Omdat de procedures vanuit triggers aangeroepen
                                           worden mag de rollback alleen in de autonomous transaction gedaan worden.
                                           Tevens: call-stack alleen gebruiken als deze gevuld is.
   12-05-2017 X. Pikaar          01.00.02  Echte technische logging ingebouwd met message_codes, substitution parameters e.d.
   06-09-2017 X. Pikaar          01.00.03  Tabel sup_globals.gtab_pcs_tle vertplaats naar sup_globals daar in het initialization deel van
                                           pcs_log_actions een proces geinitialiseerd wordt als er nog geen proces aangemaakt
                                           is. Bij een log-off van een user wordt dan ook deze package aangeroepen om eventuele
                                           trace-log weg te schrijven (write_log_trace), met als gevolg dat er heel veel
                                           proces-records geschreven werden zonder verdere logging eronder.
   21-09-2017 X. Pikaar          01.00.04  write_log_trace: named-parameter call naar pcs_tle_dml
   05-01-2018 X. Pikaar          01.01.00  log_ins: Default waarden in kolommen zetten als deze leeg aangeleverd worden om
                                           te voorkomen dat bulk-insert faalt.
   15-05-2018 X. Pikaar          01.02.00  TRAN-762: Beperktere logging door rekening te houden met log-levels
   17-05-2018 X. Pikaar          01.02.01  log_ins aaangepast: I.v.m. volgorde bij een E, F niet hier direct de trace-log
                                           weg schrijven, moet altijd via end_process
   19-06-2018 X. Pikaar          01.02.02  log_ins: hier de primary key nog niet vullen, anders gaat de sqeuence onnodig
                                           hard terwijl er geen records geschrveen worden.
   02-10-2018 X. Pikaar          01.03.00  Tekst UNKOWN gewijzigd naar UNKNOWN
   09-11-2018 X. Pikaar          01.03.01  Commit toegevoegd aan write_log_trace om te voorkomen dat wel de logging alsnog
                                           kwijt raken
   05-06-2019 X. Pikaar          01.04.00  TRAN_3083: Logging niet meer uit PL/SQL-tabel halen, maar uit pcs_runtime_tle om
                                           pcs_technical_log_lines te vullen. Hierdoor zouden we geen PGA-problemen meer moeten
                                           hebben
   07-06-2019 X. Pikaar          01.04.01  TRAN_3083: Alleen positieve pcs_id's loggen. Vanuit test of losse procesjes kan er weleens
                                           een negatief pcs_id aan komen waaien. Daarvan is er geen pcs_processes-record, zodat we een
                                           fout krijgen op het wegschrijven van de technical_log_lines.
                                           Bovendien bij een fout in write_log_trace een raise_application_error doen waarbij het pcs_id
                                           getoond wordt.
   03-07-2019 X. Pikaar          01.04.02  id van pcs_runtime_tle vullen vanuit een sequence i.p.v. global, want dat bleek nog weleens mis
                                           te gaan qua volgorde
   15-07-2019 X. Pikaar          01.04.03  asc toegevoegd aan cursor c_rte_tle.
   03-12-2019 X. Pikaar          01.04.04  write_log_trace kon mis gaan als er precies een veelvoud van 1000 logregels was
   11-02-2020 X. Pikaar          01.04.05  Log-level WARNING werd nooit weggeschreven in pcs_technical_log_lines
   19-02-2020 X. Pikaar          01.04.06  min/max-id in write_log_trace uit pcs_runtime_tle.id%type halen i.p.v. number(10)
   20-02-2020 X. Pikaar          01.04.07  TRAN-3704: max-severity bijhouden. Die schrijven we weg in pcs_processes zodat zodat
                                           eenvoudiger in Pythia te tonen is of er warnings geweest zijn. Als we dat uit de log-lines
                                           moeten halen stort de performance van die views nog verder in.
   22-04-2020 R. Standhaft       01.04.08  TRAN-3594: logging direct naar tabel "pcs_technical_log_lines"
                                           (ipv zoals vroeger eerst naar tabel "pcs_runtime_tle")
                                           tevens: log_error, log_fatal, log_warning: v_stack gewijzigd in varchar2(32767)
   29-04-2020 X. Pikaar          01.04.09  Niet alle logging werd bewaard bij een error of fatal
   27-05-2020 X. Pikaar          01.04.10  Bij bepalen van de max_severity kan geen null in het case statement gebruikt worden, dat
                                           ziet de case om een of andere reden niet. Met nvl werkt het wel
   16-06-2020 X. Pikaar          01.04.11  global PRESERVE_ALL_LOGGING werd niet initieel gezet, waardoor altijd alle logging weggeschreven
                                           werd
   13-02-2024 X. Pikaar          01.05.00  TRAN-6125: trace- en debuglogging van DML en ACTIONS-packages alleen loggen als we niet in
                                           SILENT_LOG_MODE draaien. Dit om grote bakken met overbodige logging te voorkomen waardoor
                                           je door de bomen het bos niet meer ziet.
  ************************************************************************************************************************************/
  cn_package            constant varchar2(100) := 'pcs_log_actions';
  cn_versionnumber      constant varchar2(100) := '01.05.00';
  cn_process_id         constant varchar2(10)  := 'PROCESS_ID';
  cn_unknown            constant varchar2(10)  := 'UNKNOWN';
  cn_max_severity       constant varchar2(100) := 'MAX_SEVERITY';
  cn_logging            constant  varchar2(20)  := 'LOGGING';

  function get_versionnumber
  return varchar2
  is
    /**********************************************************************************************************************
     Purpose    : return package version
    **********************************************************************************************************************/
begin
    return cn_versionnumber;
  end get_versionnumber;

  procedure del_row (p_id   in pcs_technical_log_lines.id%type)
  is
    /**********************************************************************************************************************
     Purpose    : delete row from table PCS_TECHNICAL_LOG_LINES
    **********************************************************************************************************************/
    cn_module  constant varchar2(100)    := cn_package || '.del_row';
    --

    pragma autonomous_transaction;

  begin

    -- delete row
    delete from pcs_technical_log_lines tls where tls.id = p_id;
    commit;

  exception
    when others
      then
        raise;

  end del_row;

  --
  procedure log_ins    (p_module       in varchar2
                       ,p_message_code in varchar2
                       ,p_severity     in varchar2 default null
                       ,p_subst1       in varchar2 default null
                       ,p_subst2       in varchar2 default null
                       ,p_subst3       in varchar2 default null
                       ,p_subst4       in varchar2 default null
                       ,p_subst5       in varchar2 default null
                       ,p_subst6       in varchar2 default null
                       ,p_subst7       in varchar2 default null
                       ,p_subst8       in varchar2 default null
                       ,p_subst9       in varchar2 default null
                       ,p_subst10      in varchar2 default null
                   )
  is
  /***********************************************************************************************************************************
   Vertaal de substitution parameters via sup_log_message_texts naar een tekstregel en schrijf de log-regel weg in associative array.
  ***********************************************************************************************************************************/
    cn_module            constant varchar2(100)   := cn_package||'.log_ins';
    r_tls                         pcs_technical_log_lines%rowtype;

    v_message_text                clob;

    pragma autonomous_transaction;
  begin
    -- Ophalen tekst
    v_message_text := sup_lmt_actions.get_message_text(p_message_code => p_message_code
                                                      ,p_subst1       => p_subst1
                                                      ,p_subst2       => p_subst2
                                                      ,p_subst3       => p_subst3
                                                      ,p_subst4       => p_subst4
                                                      ,p_subst5       => p_subst5
                                                      ,p_subst6       => p_subst6
                                                      ,p_subst7       => p_subst7
                                                      ,p_subst8       => p_subst8
                                                      ,p_subst9       => p_subst9
                                                      ,p_subst10      => p_subst10);

    -- kolom "message_text" in tabel "pcs_technical_log_lines" is (vooralsnog) een VARCHAR2(4000)
    v_message_text                := substr(v_message_text, 1, 3999);

    r_tls                         := null;
    r_tls.id                      := pcs_tle_seq.nextval();
    r_tls.message_code            := nvl(p_message_code, cn_unknown);
    r_tls.module                  := nvl(p_module, cn_unknown);
    r_tls.pcs_id                  := sup_globals.get_global_number(p_name => cn_process_id);
    r_tls.severity                := nvl(p_severity, '?');
    r_tls.message_text            := nvl(v_message_text, cn_unknown);
    r_tls.cre_date_loc            := systimestamp;
    r_tls.cre_date_utc            := systimestamp at time zone 'UTC';

    -- Schrijf foutmelding naar tabel "pcs_technical_log_lines" (alleen als pcs_id bekend is)
    if sup_globals.get_global_number(p_name => cn_process_id) is not null
    then
      insert into pcs_technical_log_lines
            values r_tls;
    end if;

    -- hou bij wat de maximale severity van de meldingen is geweest
    -- Vergelijk de severity die we gaan zetten met de maximale severity
    -- Volgorde van minst-erg naar ergst: D, T, I, W, E, F
    -- in de case kunnen we niet null gebruiken, om een of andere reden ziet de case dat niet. Met een nvl met 'NULL' werkt het wel
    case nvl(sup_globals.get_global_varchar(p_name => cn_max_severity), 'NULL')
      when 'NULL' then
        if p_severity != sup_constants.cn_severity_global then
           -- globals krijgen we als het goed is hier niet
           sup_globals.set_global(p_name  => cn_max_severity
                                 ,p_value => p_severity);
        end if;
      when sup_constants.cn_severity_debug then
        if p_severity in (sup_constants.cn_severity_trace
                         ,sup_constants.cn_severity_info
                         ,sup_constants.cn_severity_warning
                         ,sup_constants.cn_severity_error
                         ,sup_constants.cn_severity_fatal) then
           sup_globals.set_global(p_name  => cn_max_severity
                                 ,p_value => p_severity);
        end if;
      when sup_constants.cn_severity_trace then
        if p_severity in (sup_constants.cn_severity_info
                         ,sup_constants.cn_severity_warning
                         ,sup_constants.cn_severity_error
                         ,sup_constants.cn_severity_fatal) then
           sup_globals.set_global(p_name  => cn_max_severity
                                 ,p_value => p_severity);
        end if;
      when sup_constants.cn_severity_info then
        if p_severity in (sup_constants.cn_severity_warning
                         ,sup_constants.cn_severity_error
                         ,sup_constants.cn_severity_fatal) then
           sup_globals.set_global(p_name  => cn_max_severity
                                 ,p_value => p_severity);
        end if;
      when sup_constants.cn_severity_warning then
        if p_severity in (sup_constants.cn_severity_error
                         ,sup_constants.cn_severity_fatal) then
           sup_globals.set_global(p_name  => cn_max_severity
                                 ,p_value => p_severity);
        end if;
      when sup_constants.cn_severity_error then
        if p_severity in (sup_constants.cn_severity_fatal) then
           sup_globals.set_global(p_name  => cn_max_severity
                                 ,p_value => p_severity);
        end if;
      else
        -- dan zou hij al op F(atal) moeten staan, dus hoeven we niks te doen
        null;
    end case;

    commit;

  exception
    when others
      then
        raise;

  end log_ins;

  procedure write_log_trace
  is
  /***********************************************************************************************************************************
   Voor ieder module geldt een default-log-level.
   Log-regels van modules, waarvan het default-log-level hoger is dan het gelogde level, worden hier verwijderd.
   Altijd bewaard blijven: - als 'PRESERVE_ALL_LOGGING' = 'TRUE' alle regels (dan is er een fout opgetreden)
                     Anders:
                           - de eerste en laatste log-regel van een process
                           - alle G(lobals)
                           - de rest afhankelijk van het log-level (globaal log level en het log-level op module-niveau)
   (De naam "write_log_trace" is ongelukkig, want de procedure verwijdert regels, maar de naam blijft vanuit het verleden nog even staan.)
  ***********************************************************************************************************************************/
    cn_module            constant varchar2(100)   := cn_package||'.write_log_trace';

    -- kijk alleen naar records met pcs_id, zonder de eerste en de laatste regel, omdat wij deze regels altijd loggen
    cursor c_tle
        is with row_id as (select min(id)          as first
                                 ,max(id)          as last
                                 from pcs_technical_log_lines rte_tle
                                 where pcs_id = sup_globals.get_global_number(p_name => cn_process_id)
                          )
           select tle.id,
                  tle.pcs_id,
                  tle.message_code,
                  tle.severity,
                  tle.module,
                  sup_mll_actions.get_module_log_level(p_module_name => tle.module)    as default_log_level,
                  tle.message_text,
                  tle.cre_date_utc,
                  tle.cre_date_loc,
                  row_id.first,
                  row_id.last
             from pcs_technical_log_lines tle
             join row_id                  row_id on 1 = 1
            where tle.pcs_id = sup_globals.get_global_number(p_name => cn_process_id);

     type rt_tle        is table of c_tle%rowtype index by simple_integer;
     r_tle              rt_tle;

     v_stack            varchar2(32767);

  begin
    -- met 'PRESERVE_ALL_LOGGING' = 'TRUE' worden alle log-regels bewaard -> als deze false is moeten we per regel
    -- kijken of hij bewaard moet blijven
    if nvl(sup_globals.get_global_varchar(p_name => 'PRESERVE_ALL_LOGGING'), 'FALSE') != 'TRUE' then
      -- haal de ereste 1000 regels van de cursor op
      -- loop er regel voor regel doorheen, bekijk het log-level en verwijder wat niet meer nodig is
      open c_tle;

      fetch c_tle
       bulk collect
       into r_tle
      limit 1000;

      <<technical_log_lines>>
      while r_tle.count > 0 loop

        <<array_loop>>
        for indx in 1 .. r_tle.last loop
          -- Eerste en laatste regel en start/end process altijd bewaren! Eerste regel zal start proces zijin,. laatste regel waarschijnlijk default log level
          if  r_tle(indx).id != r_tle(indx).first
          and r_tle(indx).id != r_tle(indx).last
          and r_tle(indx).module != 'pcs_pcs_actions.start_process'
          and r_tle(indx).module != 'pcs_pcs_actions.end_process'
          and r_tle(indx).severity <> sup_constants.cn_severity_global then                  -- De gelogde globals altijd bewaren!
              -- vergelijk het default-log-level met het gelogde level
              case r_tle(indx).default_log_level
                 -- level E
                 when sup_constants.cn_severity_error then
                     -- E en F bewaren --> alles andere weggoien
                     if r_tle(indx).severity not in (sup_constants.cn_severity_error
                                                    ,sup_constants.cn_severity_fatal)
                     then
                       del_row(p_id => r_tle(indx).id);
                     end if;
                 -- level W
                 when sup_constants.cn_severity_warning then
                     -- W, E en F bewaren --> alles andere weggoien
                     if r_tle(indx).severity not in (sup_constants.cn_severity_warning
                                                    ,sup_constants.cn_severity_error
                                                    ,sup_constants.cn_severity_fatal)
                     then
                       del_row(p_id => r_tle(indx).id);
                     end if;
                 -- level I
                 when sup_constants.cn_severity_info then
                     -- I, W, E en F bewaren --> alles andere weggoien
                     if r_tle(indx).severity not in (sup_constants.cn_severity_info
                                                    ,sup_constants.cn_severity_warning
                                                    ,sup_constants.cn_severity_error
                                                    ,sup_constants.cn_severity_fatal)
                     then
                       del_row(p_id => r_tle(indx).id);
                     end if;
                 -- level T
                 when sup_constants.cn_severity_trace then
                     -- T, I, W, E en F bewaren --> alles andere weggoien
                     if r_tle(indx).severity not in (sup_constants.cn_severity_trace
                                                    ,sup_constants.cn_severity_info
                                                    ,sup_constants.cn_severity_warning
                                                    ,sup_constants.cn_severity_error
                                                    ,sup_constants.cn_severity_fatal)
                     then
                       del_row(p_id => r_tle(indx).id);
                     end if;
                 -- Level D ( = sup_constants.cn_severity_debug ), dan alles bewaren
                 else
                   null;
              end case;
          end if;
        end loop array_loop;

        exit technical_log_lines when r_tle.count < 1000
                                   or c_tle%notfound;

        -- haal de volgende 1000 regels van de cursor op
        fetch c_tle
         bulk collect
         into r_tle
        limit 1000;

      end loop technical_log_lines;

      close c_tle;
    end if;

  exception
    when others
      then
        if utl_call_stack.error_depth > 0 then
          v_stack := dbms_utility.format_error_stack()
                  || dbms_utility.format_error_backtrace()
                  || dbms_utility.format_call_stack()
                  || utl_call_stack.error_number(utl_call_stack.error_depth)||': '||utl_call_stack.error_msg(utl_call_stack.error_depth)
                  || utl_call_stack.backtrace_unit(utl_call_stack.backtrace_depth)||' line '||utl_call_stack.backtrace_line(utl_call_stack.backtrace_depth);
        else
          v_stack                          := sqlerrm;
        end if;

        -- alleen raisen, we kunnen hier geen fout loggen omdat we al in de log-package zitten
        raise_application_error(-20999, cn_module || ': error pcs_id '|| sup_globals.get_global_number(p_name => cn_process_id) || ' ' || v_stack);

  end write_log_trace;

  procedure log_debug(p_module        in varchar2
                     ,p_message_code  in varchar2 default sup_constants.cn_msg_code_debug
                     ,p_text          in varchar2 default null
                     )
  is
  /***********************************************************************************************************************************
   Log een debug regel met alleen tekst (zonder substitution-parameters)
  ***********************************************************************************************************************************/
    cn_module  constant  varchar2(100)   := cn_package||'.log_debug';

    v_owner              varchar2(100);
    v_calling_package    varchar2(100);
    v_line_number        number;
    v_caller_type        varchar2(100);
  begin
    v_calling_package             := upper(p_module);

    -- Als de logging aangeroepen is door een DML of ACTIONS package alleen loggen als we niet in 'silent_mode' draaien
    if (   (   v_calling_package like '%DML%'
            or v_calling_package like '%ACTIONS%'
           )
        and nvl(sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode), 'TRUE') = 'FALSE'
        and v_calling_package not in ('TMN_MESSAGE_ACTIONS', 'RCN_DOWNLOAD_ACTIONS') -- dit zijn geen tabel-specifieke packages
       )
    or (    v_calling_package not like '%DML%'
        and v_calling_package not like '%ACTIONS%'
       )
    then
       log_ins(p_module           => p_module
              ,p_message_code     => p_message_code
              ,p_severity         => sup_constants.cn_severity_debug
              ,p_subst1           => p_text
              );
    end if;

  exception
    when others
      then
        -- alleen raisen, we kunnen hier geen fout loggen omdat we al in de log-package zitten
        raise;

  end log_debug;

  procedure log_trace(p_module       in varchar2
                     ,p_message_code in varchar2 default sup_constants.cn_msg_code_trace
                     ,p_text         in varchar2 default null
                     )
  is
  /***********************************************************************************************************************************
   Log een trace regel met alleen tekst (zonder substitution-parameters)
  ***********************************************************************************************************************************/
    cn_module  constant varchar2(100)   := cn_package||'.log_trace';

    v_owner              varchar2(100);
    v_calling_package    varchar2(100);
    v_line_number        number;
    v_caller_type        varchar2(100);
  begin
    v_calling_package             := upper(p_module);

    -- Als de logging aangeroepen is door een DML of ACTIONS package alleen loggen als we niet in 'silent_mode' draaien
    if (   (   v_calling_package like '%DML%'
            or v_calling_package like '%ACTIONS%'
           )
        and nvl(sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode), 'TRUE') = 'FALSE'
        and v_calling_package not in ('TMN_MESSAGE_ACTIONS', 'RCN_DOWNLOAD_ACTIONS') -- dit zijn geen tabel-specifieke packages
       )
    or (    v_calling_package not like '%DML%'
        and v_calling_package not like '%ACTIONS%'
       )
    then
       log_ins(p_module           => p_module
              ,p_message_code     => p_message_code
              ,p_severity         => sup_constants.cn_severity_trace
              ,p_subst1           => p_text
              );
    end if;

  exception
    when others
      then
        -- alleen raisen, we kunnen hier geen fout loggen omdat we al in de log-package zitten
        raise;

  end log_trace;

  procedure log_info (p_module       in varchar2
                     ,p_message_code in varchar2 default sup_constants.cn_msg_code_info
                     ,p_text         in varchar2 default null
                     )
  is
  /***********************************************************************************************************************************
   Log een info regel met alleen tekst (zonder substitution-parameters)
  ***********************************************************************************************************************************/
    cn_module  constant varchar2(100)   := cn_package||'.log_info';

  begin
    log_ins(p_module           => p_module
           ,p_message_code     => p_message_code
           ,p_severity         => sup_constants.cn_severity_info
           ,p_subst1           => p_text
           );

  exception
    when others
      then
        -- alleen raisen, we kunnen hier geen fout loggen omdat we al in de log-package zitten
        raise;

  end log_info;

  procedure log_global (p_module       in varchar2
                       ,p_text         in varchar2 default null
                       )
  is
  /***********************************************************************************************************************************
   Log een info regel met alleen tekst (zonder substitution-parameters)
  ***********************************************************************************************************************************/
    cn_module  constant varchar2(100)   := cn_package||'.log_global';

  begin
    log_ins(p_module           => p_module
           ,p_message_code     => sup_constants.cn_msg_code_global
           ,p_severity         => sup_constants.cn_severity_global
           ,p_subst1           => p_text
           );

  exception
    when others
      then
        -- alleen raisen, we kunnen hier geen fout loggen omdat we al in de log-package zitten
        raise;

  end log_global;

  procedure log_warning(p_module       in varchar2
                       ,p_message_code in varchar2 default sup_constants.cn_msg_code_warning
                       ,p_text         in varchar2 default null
                       )
  is
  /***********************************************************************************************************************************
   Log een warning regel met alleen tekst (zonder substitution-parameters)
  ***********************************************************************************************************************************/
    cn_module  constant varchar2(100)   := cn_package||'.log_warning';

  begin
    log_ins(p_module           => p_module
           ,p_message_code     => p_message_code
           ,p_severity         => sup_constants.cn_severity_warning
           ,p_subst1           => p_text
           );

  exception
    when others
      then
        -- alleen raisen, we kunnen hier geen fout loggen omdat we al in de log-package zitten
        raise;

  end log_warning;

  procedure log_error(p_module       in varchar2
                     ,p_message_code in varchar2 default sup_constants.cn_msg_code_error
                     ,p_text         in varchar2 default null
                     )
  is
  /***********************************************************************************************************************************
   Log een error regel met alleen tekst (zonder substitution-parameters)
  ***********************************************************************************************************************************/
    cn_module  constant varchar2(100)   := cn_package||'.log_error';

    v_stack varchar2(32767);
  begin
    -- We hebben een Error, dan gaan we de volledige logging wegschrijven
    sup_globals.set_global(p_name  => 'PRESERVE_ALL_LOGGING'
                          ,p_value => 'TRUE');

    --stacktrace
    if utl_call_stack.error_depth > 0 then
      v_stack := dbms_utility.format_error_stack()
              || dbms_utility.format_error_backtrace()
              || dbms_utility.format_call_stack()
              || utl_call_stack.error_number(utl_call_stack.error_depth)||': '||utl_call_stack.error_msg(utl_call_stack.error_depth)
              || utl_call_stack.backtrace_unit(utl_call_stack.backtrace_depth)||' line '||utl_call_stack.backtrace_line(utl_call_stack.backtrace_depth);
    else
      v_stack                          := null;
    end if;

    -- call stack is substitution parameter 10!
    log_ins(p_module           => p_module
           ,p_message_code     => p_message_code
           ,p_severity         => sup_constants.cn_severity_error
           ,p_subst1           => p_text
           ,p_subst10          => v_stack
           );

  exception
    when others
      then
        -- alleen raisen, we kunnen hier geen fout loggen omdat we al in de log-package zitten
        raise;

  end log_error;

  procedure log_fatal(p_module in varchar2
                     ,p_message_code in varchar2 default sup_constants.cn_msg_code_fatal
                     ,p_text   in varchar2 default null
                     )
  is
  /***********************************************************************************************************************************
   Log een fatal regel met alleen tekst (zonder substitution-parameters)
  ***********************************************************************************************************************************/
    cn_module  constant varchar2(100)   := cn_package||'.log_fatal';

    v_stack varchar2(32767);
  begin
    -- We hebben een Fatal, dan gaan we de volledige logging wegschrijven
    sup_globals.set_global(p_name  => 'PRESERVE_ALL_LOGGING'
                          ,p_value => 'TRUE');

    --stacktrace
    if utl_call_stack.error_depth > 0 then
      v_stack := dbms_utility.format_error_stack()
               ||dbms_utility.format_error_backtrace()
               ||dbms_utility.format_call_stack()
               ||utl_call_stack.error_number(utl_call_stack.error_depth)||': '||utl_call_stack.error_msg(utl_call_stack.error_depth)
               ||utl_call_stack.backtrace_unit(utl_call_stack.backtrace_depth)||' line '||utl_call_stack.backtrace_line(utl_call_stack.backtrace_depth);
    else
      v_stack                          := null;
    end if;


    -- call stack is substitution parameter 10!
    log_ins(p_module           => p_module
           ,p_message_code     => p_message_code
           ,p_severity         => sup_constants.cn_severity_fatal
           ,p_subst1           => p_text
           ,p_subst10          => v_stack
           );

  exception
    when others
      then
        -- alleen raisen, we kunnen hier geen fout loggen omdat we al in de log-package zitten
        raise;

  end log_fatal;

-- OVERLOADED. Let op: bij deze procedures is de message_code verplicht, anders kunnen we hem niet overloaden
--
  procedure log_debug(p_module       in varchar2
                     ,p_message_code in varchar2
                     ,p_subst1       in varchar2 default null
                     ,p_subst2       in varchar2 default null
                     ,p_subst3       in varchar2 default null
                     ,p_subst4       in varchar2 default null
                     ,p_subst5       in varchar2 default null
                     ,p_subst6       in varchar2 default null
                     ,p_subst7       in varchar2 default null
                     ,p_subst8       in varchar2 default null
                     ,p_subst9       in varchar2 default null
                     )
    is
  /***********************************************************************************************************************************
   Log een debug regel met substitution-parameters
  ***********************************************************************************************************************************/
    cn_module  constant varchar2(100)   := cn_package||'.log_debug';

    v_owner              varchar2(100);
    v_calling_package    varchar2(100);
    v_line_number        number;
    v_caller_type        varchar2(100);
  begin
    v_calling_package             := upper(p_module);

    -- Als de logging aangeroepen is door een DML of ACTIONS package alleen loggen als we niet in 'silent_mode' draaien
    if (   (   v_calling_package like '%DML%'
            or v_calling_package like '%ACTIONS%'
           )
        and nvl(sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode), 'TRUE') = 'FALSE'
        and v_calling_package not in ('TMN_MESSAGE_ACTIONS', 'RCN_DOWNLOAD_ACTIONS') -- dit zijn geen tabel-specifieke packages
       )
    or (    v_calling_package not like '%DML%'
        and v_calling_package not like '%ACTIONS%'
       )
    then
       log_ins(p_module           => p_module
              ,p_message_code     => nvl(p_message_code, sup_constants.cn_msg_code_debug)
              ,p_severity         => sup_constants.cn_severity_debug
              ,p_subst1           => p_subst1
              ,p_subst2           => p_subst2
              ,p_subst3           => p_subst3
              ,p_subst4           => p_subst4
              ,p_subst5           => p_subst5
              ,p_subst6           => p_subst6
              ,p_subst7           => p_subst7
              ,p_subst8           => p_subst8
              ,p_subst9           => p_subst9
              );
    end if;

  exception
    when others
      then
        -- alleen raisen, we kunnen hier geen fout loggen omdat we al in de log-package zitten
        raise;

  end log_debug;

  procedure log_trace(p_module       in varchar2
                     ,p_message_code in varchar2
                     ,p_subst1       in varchar2 default null
                     ,p_subst2       in varchar2 default null
                     ,p_subst3       in varchar2 default null
                     ,p_subst4       in varchar2 default null
                     ,p_subst5       in varchar2 default null
                     ,p_subst6       in varchar2 default null
                     ,p_subst7       in varchar2 default null
                     ,p_subst8       in varchar2 default null
                     ,p_subst9       in varchar2 default null
                     )
  is
  /***********************************************************************************************************************************
   Log een tracing regel met substitution-parameters
  ***********************************************************************************************************************************/
    cn_module  constant varchar2(100)   := cn_package||'.log_trace';

    v_owner              varchar2(100);
    v_calling_package    varchar2(100);
    v_line_number        number;
    v_caller_type        varchar2(100);
  begin
    v_calling_package             := upper(p_module);

    -- Als de logging aangeroepen is door een DML of ACTIONS package alleen loggen als we niet in 'silent_mode' draaien
    if (   (   v_calling_package like '%DML%'
            or v_calling_package like '%ACTIONS%'
           )
        and nvl(sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode), 'TRUE') = 'FALSE'
        and v_calling_package not in ('TMN_MESSAGE_ACTIONS', 'RCN_DOWNLOAD_ACTIONS') -- dit zijn geen tabel-specifieke packages
       )
    or (    v_calling_package not like '%DML%'
        and v_calling_package not like '%ACTIONS%'
       )
    then
       log_ins(p_module           => p_module
              ,p_message_code     => nvl(p_message_code,  sup_constants.cn_msg_code_trace)
              ,p_severity         => sup_constants.cn_severity_trace
              ,p_subst1           => p_subst1
              ,p_subst2           => p_subst2
              ,p_subst3           => p_subst3
              ,p_subst4           => p_subst4
              ,p_subst5           => p_subst5
              ,p_subst6           => p_subst6
              ,p_subst7           => p_subst7
              ,p_subst8           => p_subst8
              ,p_subst9           => p_subst9
              );
    end if;

  exception
    when others
      then
        -- alleen raisen, we kunnen hier geen fout loggen omdat we al in de log-package zitten
        raise;

  end log_trace;

  procedure log_info (p_module in varchar2
                     ,p_message_code in varchar2
                     ,p_subst1       in varchar2 default null
                     ,p_subst2       in varchar2 default null
                     ,p_subst3       in varchar2 default null
                     ,p_subst4       in varchar2 default null
                     ,p_subst5       in varchar2 default null
                     ,p_subst6       in varchar2 default null
                     ,p_subst7       in varchar2 default null
                     ,p_subst8       in varchar2 default null
                     ,p_subst9       in varchar2 default null
                     )
  is
  /***********************************************************************************************************************************
   Log een info regel met substitution-parameters
  ***********************************************************************************************************************************/
    cn_module  constant varchar2(100)   := cn_package||'.log_info';

  begin
    log_ins(p_module           => p_module
           ,p_message_code     => nvl(p_message_code,  sup_constants.cn_msg_code_info)
           ,p_severity         => sup_constants.cn_severity_info
           ,p_subst1           => p_subst1
           ,p_subst2           => p_subst2
           ,p_subst3           => p_subst3
           ,p_subst4           => p_subst4
           ,p_subst5           => p_subst5
           ,p_subst6           => p_subst6
           ,p_subst7           => p_subst7
           ,p_subst8           => p_subst8
           ,p_subst9           => p_subst9
           );

  exception
    when others
      then
        -- alleen raisen, we kunnen hier geen fout loggen omdat we al in de log-package zitten
        raise;

  end log_info;

  procedure log_warning(p_module in varchar2
                       ,p_message_code in varchar2
                       ,p_subst1       in varchar2 default null
                       ,p_subst2       in varchar2 default null
                       ,p_subst3       in varchar2 default null
                       ,p_subst4       in varchar2 default null
                       ,p_subst5       in varchar2 default null
                       ,p_subst6       in varchar2 default null
                       ,p_subst7       in varchar2 default null
                       ,p_subst8       in varchar2 default null
                       ,p_subst9       in varchar2 default null
                       )
  is
  /***********************************************************************************************************************************
   Log een warning regel met substitution-parameters
  ***********************************************************************************************************************************/
    cn_module  constant varchar2(100)   := cn_package||'.log_warning';

  begin

    log_ins(p_module           => p_module
           ,p_message_code     => nvl(p_message_code,sup_constants.cn_msg_code_warning)
           ,p_severity         => sup_constants.cn_severity_warning
           ,p_subst1           => p_subst1
           ,p_subst2           => p_subst2
           ,p_subst3           => p_subst3
           ,p_subst4           => p_subst4
           ,p_subst5           => p_subst5
           ,p_subst6           => p_subst6
           ,p_subst7           => p_subst7
           ,p_subst8           => p_subst8
           ,p_subst9           => p_subst9
           );

  exception
    when others
      then
        -- alleen raisen, we kunnen hier geen fout loggen omdat we al in de log-package zitten
        raise;

  end log_warning;

  procedure log_error  (p_module       in varchar2
                       ,p_message_code in varchar2
                       ,p_subst1       in varchar2 default null
                       ,p_subst2       in varchar2 default null
                       ,p_subst3       in varchar2 default null
                       ,p_subst4       in varchar2 default null
                       ,p_subst5       in varchar2 default null
                       ,p_subst6       in varchar2 default null
                       ,p_subst7       in varchar2 default null
                       ,p_subst8       in varchar2 default null
                       ,p_subst9       in varchar2 default null
                     )
  is
  /***********************************************************************************************************************************
   Log een error regel met substitution-parameters
  ***********************************************************************************************************************************/
    cn_module  constant varchar2(100)   := cn_package||'.log_error';

    v_stack varchar2(32767);
  begin
    -- We hebben een Error, dan gaan we de volledige logging wegschrijven
    sup_globals.set_global(p_name  => 'PRESERVE_ALL_LOGGING'
                          ,p_value => 'TRUE');

    --stacktrace
    if utl_call_stack.error_depth > 0 then
      v_stack := dbms_utility.format_error_stack()
               ||dbms_utility.format_error_backtrace()
               ||dbms_utility.format_call_stack()
               ||utl_call_stack.error_number(utl_call_stack.error_depth)||': '||utl_call_stack.error_msg(utl_call_stack.error_depth)
               ||utl_call_stack.backtrace_unit(utl_call_stack.backtrace_depth)||' line '||utl_call_stack.backtrace_line(utl_call_stack.backtrace_depth);
    else
      v_stack                           := null;
    end if;


    log_ins(p_module           => p_module
           ,p_message_code     => nvl(p_message_code, sup_constants.cn_msg_code_error)
           ,p_severity         => sup_constants.cn_severity_error
           ,p_subst1           => p_subst1
           ,p_subst2           => p_subst2
           ,p_subst3           => p_subst3
           ,p_subst4           => p_subst4
           ,p_subst5           => p_subst5
           ,p_subst6           => p_subst6
           ,p_subst7           => p_subst7
           ,p_subst8           => p_subst8
           ,p_subst9           => p_subst9
           ,p_subst10          => v_stack
           );

  exception
    when others
      then
        -- alleen raisen, we kunnen hier geen fout loggen omdat we al in de log-package zitten
        raise;

  end log_error;

  procedure log_fatal  (p_module       in varchar2
                       ,p_message_code in varchar2
                       ,p_subst1       in varchar2 default null
                       ,p_subst2       in varchar2 default null
                       ,p_subst3       in varchar2 default null
                       ,p_subst4       in varchar2 default null
                       ,p_subst5       in varchar2 default null
                       ,p_subst6       in varchar2 default null
                       ,p_subst7       in varchar2 default null
                       ,p_subst8       in varchar2 default null
                       ,p_subst9       in varchar2 default null
                     )
  is
  /***********************************************************************************************************************************
   Log een fatal regel met substitution-parameters
  ***********************************************************************************************************************************/
    cn_module  constant varchar2(100)   := cn_package||'.log_fatal';

    v_stack varchar2(32767);
  begin
    -- We hebben een Fatal, dan gaan we de volledige logging wegschrijven
    sup_globals.set_global(p_name  => 'PRESERVE_ALL_LOGGING'
                          ,p_value => 'TRUE');

    --stacktrace
    if utl_call_stack.error_depth > 0 then
      v_stack := dbms_utility.format_error_stack()
               ||dbms_utility.format_error_backtrace()
               ||dbms_utility.format_call_stack()
               ||utl_call_stack.error_number(utl_call_stack.error_depth)||': '||utl_call_stack.error_msg(utl_call_stack.error_depth)
               ||utl_call_stack.backtrace_unit(utl_call_stack.backtrace_depth)||' line '||utl_call_stack.backtrace_line(utl_call_stack.backtrace_depth);
    else
      v_stack                          := null;
    end if;

    log_ins(p_module           => p_module
           ,p_message_code     => nvl(p_message_code, sup_constants.cn_msg_code_fatal)
           ,p_severity         => sup_constants.cn_severity_fatal
           ,p_subst1           => p_subst1
           ,p_subst2           => p_subst2
           ,p_subst3           => p_subst3
           ,p_subst4           => p_subst4
           ,p_subst5           => p_subst5
           ,p_subst6           => p_subst6
           ,p_subst7           => p_subst7
           ,p_subst8           => p_subst8
           ,p_subst9           => p_subst9
           ,p_subst10          => v_stack
           );

  exception
    when others
      then
        -- alleen raisen, we kunnen hier geen fout loggen omdat we al in de log-package zitten
        raise;

  end log_fatal;

begin
  -- Als er geen proces aanwezig is, is deze er eigenlijk iets "illegaal" aangeroepen (dus zonder proces). Omdat dat in geval van bijvoorbeeld datamutaties
  -- wel mogelijk is, vangen we dat hier af door alsnog een process te maken
  if sup_globals.get_global_number(p_name      => cn_process_id) is null then
    pcs_pcs_actions.start_process(p_initiating_procedure => cn_package);
  end if;

  -- Initieel gaan we niet de volledige logging wegschrijven. In geval van een Error of Fatal schrijven we wel de gehel reut weg, want dan wil je trace-logging hebben
  sup_globals.set_global(p_name  => 'PRESERVE_ALL_LOGGING'
                        ,p_value => 'FALSE');

  -- Voor het geval de 'silent_log_mode' global not niet gevuld is, hem alsnog ophalen. Dit zou niet moeten voorkomen, want dan is er iets gestart zonder proces.
  if sup_globals.get_global_varchar(p_name => sup_constants.cn_silent_log_mode) is null then
     sup_globals.set_global(p_name  => sup_constants.cn_silent_log_mode
                           ,p_value => sup_ojtppy_actions.get_domain_value(p_ojt_code    => cn_logging
                                                                          ,p_ppy_code    => sup_constants.cn_silent_log_mode
                                                                          ,p_silent_mode => 'Y'));
  end if;

end pcs_log_actions;
/
