create or replace package body argus_actions
is
   /***********************************************************************************************************************************
    Purpose     : Package voor alle sturing van de Argus tijdigheids controles (DQF nieuwe stijl)

    Change History
    Date         Author            Version   Description
    ----------   -----------       --------  ----------------------------------------------------------------------------------------------
    28-01-2026   Xander Pikaar     01.00.00  TRAN-7763: Creatie
    12-02-2026   Xander Pikaar     01.01.00  TRAN-7926: functie is_argus_publication toegevoegd
    20-02-2026   Xander Pikaar     01.01.01  determine_statusses werkte nog niet goed als we op tijd verstuurd haddem em eem APPROVED ontvangem
                                             hadden
    02-03-2026   Xander Pikaar     01.01.02  Foutje in de cn_module van is_argus_publication opgelost
    10-03-2026   Sandjai Ramasray  01.02.00  Tran-8137; procedures aangemaakt 'fill_expectations', 'check_expectations' en 'check_expectation_after_ack'
    13-03-2026   Xander Pikaar     01.02.01  In de c_check_exp werd de check_name niet opgehaald en ook niet doorgegeven aan
                                             ags_epn_dml.dml_row, met een ORA-01407: cannot update ("DELPHIDBA"."AGS_PBN_EXPECTATIONS"."CHECK_NAME")
                                             to NULL als gevolg.
                                             In fill_expectations het proces afsluiten als er een proces is aangemaakt   
    13-03-2026   Xander Pikaar     01.02.02  In check_expectations en check_expectation_after_ack de timezone op UTC te zetten om te voorkomen
                                             dat we een ORA-01878 krijgen op de winter-/zomertijdovergang
    17-03-2026   Xander Pikaar     01.02.03  In check_expectations moet r_tmn voor de fetch leeggemaakt worden, anders blijven de waarden
                                             van de vorige gevonden transmissie in het record staan en krijgen de volgende ags_pbn_expectations
                                             de verkeerde waarde als er geen transmissie gevonden wordt.
    23-04-2026   Nico Klaver       01.02.04  TRAN-8196 Retry_counter alleen verhogen als deadline verstreken is 
    07-05-2026   Sandjai Ramasray  01.03.00  TRAN-8065: Argus: alerting toevoegen als een bepaalde tijd is overschreden.
   ************************************************************************************************************************************/
   cn_package       constant varchar2(100) := 'argus_actions';
   cn_versionnumber constant varchar2(100) := '01.03.00';
   cn_process_id    constant varchar2(10)  := 'PROCESS_ID';

   function get_versionnumber
   return varchar2
   is
     /**********************************************************************************************
      Purpose    : Return package version.
     **********************************************************************************************/
   begin
     return cn_versionnumber;

   end get_versionnumber;


   procedure fill_frequent_pbn_expectations
   is
     /**********************************************************************************************
      Purpose    : Roep de publicatie-specifieke fill_frequent_pbn_expectations procedures aan voor
                   alle Argus publicatie die een bepaald runtime schedule hebben. Dit zijn niet de
                   onregelmatige datadriven publicaties!
     **********************************************************************************************/
      cn_module               varchar2(100) := cn_package || '.' || 'fill_frequent_pbn_expectations';

      v_statement             varchar2(32676);

      cursor c_agn_dfn
          is select distinct object_name || '.' || procedure_name as procedure_name
               from user_procedures          pce
               join sup_publications         pbn     on instr(pbn.name, replace(pce.object_name, 'TMN_','')) > 0
               join sup_publication_switches psh     on (    psh.pbn_id = pbn.id
                                                         and systimestamp at time zone 'UTC' between psh.bvalidity_utc_from and psh.bvalidity_utc_to
                                                        )
               join ags_pbn_definitions      ags_dfn on ags_dfn.pbn_id  = pbn.id
              where pce.object_name like 'TMN%'
                and pce.procedure_name   = 'FILL_EXPECTATIONS'
                and ags_dfn.fill_active  = 'TRUE'
                and ags_dfn.runtime_schedule is not null;
   begin
      pcs_pcs_actions.start_process(p_initiating_procedure => cn_module
                                   ,p_description          => 'Fill frequent Argus expectations for publications'
                                   );

      for r_agn_dfn in c_agn_dfn loop
          v_statement        := 'begin '|| r_agn_dfn.procedure_name || '; end;';
          execute immediate v_statement;
      end loop;

      sup_utilities.reset_session_nls;
      pcs_pcs_actions.end_process;

   exception
     when others then
       pcs_log_actions.log_error(p_module => cn_module);
       raise;

   end fill_frequent_pbn_expectations;

   procedure check_pbn_expectations (p_check_name    in varchar2 default 'ALL')
   is
     /**********************************************************************************************
      Purpose    : Roep de publicatie-specifieke check_pbn_expectations procedures aan voor alle Argus
                   publicatie
     **********************************************************************************************/
      cn_module               varchar2(100) := cn_package || '.' || 'check_pbn_expectations';

      v_statement             varchar2(32676);

      cursor c_agn_dfn (b_check_name        in ags_pbn_definitions.check_name%type)
          is select distinct object_name || '.' || procedure_name as procedure_name
               from user_procedures          pce
               join sup_publications         pbn     on instr(pbn.name, replace(pce.object_name, 'TMN_','')) > 0
               join sup_publication_switches psh     on (    psh.pbn_id = pbn.id
                                                         and systimestamp at time zone 'UTC' between psh.bvalidity_utc_from and psh.bvalidity_utc_to
                                                        )
               join ags_pbn_definitions      ags_dfn on ags_dfn.pbn_id  = pbn.id
              where pce.object_name like 'TMN%'
                and pce.procedure_name      = 'CHECK_EXPECTATIONS'
                and ags_dfn.check_active    = 'TRUE'
                and (   ags_dfn.check_name  = b_check_name
                     or b_check_name        = 'ALL');
   begin
      pcs_pcs_actions.start_process(p_initiating_procedure => cn_module
                                   ,p_description          => 'Check Argus expectations for publications'
                                   );

      sup_utilities.set_session_dutch;

      for r_agn_dfn in c_agn_dfn(b_check_name => p_check_name) loop
          v_statement        := 'begin '|| r_agn_dfn.procedure_name || '; end;';
          execute immediate v_statement;
      end loop;

      pcs_pcs_actions.end_process;

   exception
     when others then
       pcs_log_actions.log_error(p_module => cn_module);
       raise;
   end check_pbn_expectations;

   procedure check_pbn_expectations_after_ack (p_tmn_id      in  pcs_tmn_transmissions.id%type)
   is
    /**********************************************************************************************
      Purpose    : Roep de publicatie-specifieke check_pbn_expectation_after_ack aan in de tmn-package
                   die hoort bij de publicatie.
                   Alleen er een CHECK_EXPECTATION_AFTER_ACK procedure in de tmn-package is en
                   check_active is TRUE mag dit gedaan worden!
     **********************************************************************************************/
      cn_module                             varchar2(100) := cn_package || '.' || 'check_pbn_expectations_after_ack';

      v_statement                           varchar2(32676);
      v_process_created                     boolean;

      cursor c_agn_dfn (b_tmn_id  pcs_tmn_transmissions.id%type)
          is select distinct object_name || '.' || procedure_name as procedure_name
                   ,tmn.mrid
               from pcs_tmn_transmissions    tmn
               join sup_publications         pbn     on pbn.id          = tmn.pbn_id
               join user_procedures          pce     on instr(pbn.name, replace(pce.object_name, 'TMN_','')) > 0
               join sup_publication_switches psh     on (    psh.pbn_id = pbn.id
                                                         and systimestamp at time zone 'UTC' between psh.bvalidity_utc_from and psh.bvalidity_utc_to
                                                        )
               join ags_pbn_definitions      ags_dfn on ags_dfn.pbn_id  = pbn.id
              where pce.object_name like 'TMN%'
                and pce.procedure_name      = 'CHECK_EXPECTATION_AFTER_ACK'
                and ags_dfn.check_active    = 'TRUE'
                and tmn.id                  = b_tmn_id;

   begin
      if sup_globals.get_global_number('PROCESS_ID') is null then
         pcs_pcs_actions.start_process(p_initiating_procedure => cn_module
                                      ,p_description          => 'Check Argus expectation after receiving ack'
                                      );
         v_process_created                  := true;
      else
         v_process_created                  := false;
      end if;

      pcs_log_actions.log_info(p_module => cn_module
                              ,p_text   => 'Start'
                             || chr(13) || 'p_tmn_id  : ' || p_tmn_id
                              );

      for r_agn_dfn in c_agn_dfn(b_tmn_id => p_tmn_id) loop
          v_statement        := 'begin '|| r_agn_dfn.procedure_name || '(p_mrid => :mrid); end;';
          execute immediate v_statement
            using r_agn_dfn.mrid;
      end loop;

      pcs_log_actions.log_info(p_module => cn_module
                              ,p_text   => 'End');

      if v_process_created then
         pcs_pcs_actions.end_process;
      end if;

    exception
     when others then
       pcs_log_actions.log_error(p_module => cn_module);
       raise;
   end check_pbn_expectations_after_ack;

   function determine_fill_from_runtime(p_check_name          in ags_pbn_definitions.check_name%type)
      return date
   is
     /*************************************************************************************************************************************
      Purpose    : Bepaal vanaf welke runtime de ags_pbn_expectations voor de publicatie gevuld moeten worden
      *************************************************************************************************************************************/
      cn_module                             varchar2(100) := cn_package || '.' || 'determine_fill_from_runtime';

      v_runtime_utc                         date;

      cursor c_pbn_epn (b_check_name    in ags_pbn_expectations.check_name%type)
          is select dfn.pbn_id
                   ,max(runtime_utc) as runtime_utc
              from ags_pbn_definitions             dfn
              left outer join ags_pbn_expectations epn on dfn.check_name = epn.check_name
             where dfn.check_name = b_check_name
             group by pbn_id;

     r_pbn_epn            c_pbn_epn%rowtype;

      -- Bepaal de eerste runtime van de meest recente transmissie
      cursor c_tmn (b_pbn_id       in sup_publications.id%type)
          is select min(tmn.cre_date_utc)
               from pcs_tmn_transmissions  tmn
              where pbn_id             = b_pbn_id
                and bvalidity_utc_from = (select max(bvalidity_utc_from)
                                            from pcs_tmn_transmissions  tmn
                                           where tmn.pbn_id = b_pbn_id);

   begin
      pcs_log_actions.log_info(p_module => cn_module
                              ,p_text   => 'Start'
                             || chr(13) || 'p_check_name  : ' || p_check_name
                              );

      -- Zoek het record met de laatste runtime_utc van deze publicatie in ags_pbn_expectations. Deze zou na de eerste run altijd gevonden
      -- moeten worden
      open c_pbn_epn (b_check_name    => p_check_name);

      fetch c_pbn_epn
       into r_pbn_epn;

      close c_pbn_epn;

      if r_pbn_epn.runtime_utc is null then
         -- als er geen eerder ags_pbn_expectations record gevonden is gaan we uit van de runtime van de meeste recente transmissie (qua bvalidity)
         open c_tmn (b_pbn_id    => r_pbn_epn.pbn_id);

         fetch c_tmn
          into v_runtime_utc;

         close c_tmn;
      else
         v_runtime_utc             := r_pbn_epn.runtime_utc;
      end if;

      if v_runtime_utc is null then
         v_runtime_utc             := systimestamp at time zone 'UTC';
      end if;

      pcs_log_actions.log_info(p_module => cn_module
                              ,p_text   => 'End'
                             || chr(13) || 'Fill from runtime (UTC): ' || to_char(v_runtime_utc, 'dd-mm-yyyy hh24:mi')
                              );

      return  v_runtime_utc;

   exception
     when others then
       pcs_log_actions.log_error(p_module => cn_module);
       raise;

   end determine_fill_from_runtime;

   function determine_fill_until_runtime(p_date_from_utc     in date
                                        ,p_check_name        in ags_pbn_definitions.check_name%type)
            return date
   is
     /*************************************************************************************************************************************
      Purpose    : Bepaal tot welke datum/tijd de ags_pbn_expectations-records vooruit gemaakt moeten worden
      *************************************************************************************************************************************/
      cn_module                             varchar2(100) := cn_package || '.' || 'determine_fill_until_runtime';

      v_period_unit_in_advance              varchar2(100);
      v_period_in_advance                   number(10);
      v_return_date_utc                     date;

      v_sw_change_utc_for_in_date      date;
      v_ws_change_utc_for_in_date      date;
      v_sw_change_utc_for_ret_date     date;
      v_ws_change_utc_for_ret_date     date;

      e_invalid_unit_in_advance             exception;

   begin
      pcs_log_actions.log_info(p_module => cn_module
                              ,p_text   => 'Start'
                             || chr(13) || 'p_date_from_utc: ' || to_char(p_date_from_utc, 'dd-mm-yyyy hh24:mi')
                             || chr(13) || 'p_check_name   : ' || p_check_name
                              );

      -- zeker weten dat we UTC draaien, dit om te voorkomen dat we een fout krijgen op het winter-/zomertijduur
      sup_utilities.keep_session_timezone;
      sup_utilities.set_session_timezone(p_timezone => 'UTC');

      v_period_unit_in_advance               := sup_ojtppy_actions.get_domain_value(p_ojt_code   => p_check_name
                                                                                   ,p_ppy_code   => sup_constants.cn_create_expectations_period_in_advance);

      v_period_in_advance                    := sup_ojtppy_actions.get_domain_value_n(p_ojt_code => p_check_name
                                                                                     ,p_ppy_code => sup_constants.cn_create_expectations_period_in_advance);

      -- om 01:00 UTC ga je van wintertijd naar zomeretijd
      v_ws_change_utc_for_in_date            :=  sup_date_actions.date_wintersummerchange(p_year => to_char(p_date_from_utc, 'yyyy')) + interval '0 01:00:00' day to second;
      -- 00:00 UTC is de eerste keer in het dubbele uur.
      v_sw_change_utc_for_in_date            :=  sup_date_actions.date_summerwinterchange(p_year => to_char(p_date_from_utc, 'yyyy'));


      case v_period_unit_in_advance
           when 'YEARS' then
                v_return_date_utc            := add_months(p_date_from_utc, 12 * v_period_in_advance);
           when 'MONTHS' then
                -- add_months houdt rekening met de laatste dag van de maand, in tegenstelling tot de interval year to month
                v_return_date_utc            := add_months(p_date_from_utc, v_period_in_advance);
           when 'DAYS' then
                v_return_date_utc            := p_date_from_utc + v_period_in_advance;
           when 'HOURS' then
                v_return_date_utc            := p_date_from_utc + v_period_in_advance / 24;
           when 'MINUTES' then
                v_return_date_utc            := p_date_from_utc + v_period_in_advance / 1440;
           else
                raise e_invalid_unit_in_advance;
      end case;

      -- bepaal apart de DST-tijdovergangen voor de berekende datum. Die kan namelijk in een volgend jaar komen.
      v_ws_change_utc_for_ret_date            :=  sup_date_actions.date_wintersummerchange(p_year => to_char(v_return_date_utc, 'yyyy')) + interval '0 01:00:00' day to second;
      v_sw_change_utc_for_ret_date            :=  sup_date_actions.date_summerwinterchange(p_year => to_char(v_return_date_utc, 'yyyy'));

      -- Als de periode meer dan uren is, kan het zijn dat we een Z/W correctie moeten doen. Dit om te voorkomen dat we een uur te laat zitten waardoor de eind runtime een uur teveel
      -- of te weinig is zodat er een record teveel of te weinig aangemaakt wordt.
      if v_period_unit_in_advance in('YEARS', 'DAYS', 'MONTHS') then
         if  v_ws_change_utc_for_in_date    > p_date_from_utc
         and v_ws_change_utc_for_ret_date   < v_return_date_utc
         and v_sw_change_utc_for_ret_date   > v_return_date_utc  then
             -- Gaan we van wintertijd naar de zomertijd, dan 1 uur aftrekken van de tijd. Een publicatie die in de wintertijd om 13:00 UTC draait, draait in de
             -- zomertijd om 12:00 UTC
             v_return_date_utc                := v_return_date_utc - 1/24;
         elsif v_sw_change_utc_for_in_date  > p_date_from_utc
           and v_ws_change_utc_for_in_date  < p_date_from_utc
           and v_sw_change_utc_for_ret_date < v_return_date_utc then
             -- Gaan we van zomertijd naar de wintertijd, dan 1 uur optellen bij de tijd.
             -- Een publicatie die in de zomertijd om 13:00 UTC draait, draait in de wintertijd om 14:00 UTC
             v_return_date_utc              := v_return_date_utc + 1/24;
         end if;
      end if;

      sup_utilities.reset_session_timezone;

      pcs_log_actions.log_info(p_module => cn_module
                              ,p_text   => 'End'
                             || chr(13) || 'Fill until date: ' || to_char(v_return_date_utc, 'dd-mm-yyyy hh24:mi')
                              );

      return v_return_date_utc;

   exception
    when e_invalid_unit_in_advance then
         pcs_log_actions.log_error('Unit '|| v_period_unit_in_advance || ' not supported to calculate Argus period in advance');
         pcs_pcs_actions.end_process;
     when others then
       pcs_log_actions.log_error(p_module => cn_module);
       raise;
   end determine_fill_until_runtime;

   procedure determine_statusses (p_delivered_utc     in  date
                                 ,p_approved_utc      in  date
                                 ,p_rejected_utc      in  date
                                 ,p_deadline_utc      in  date
                                 ,p_timely            out varchar2
                                 ,p_complete          out varchar2)
   is
     /*************************************************************************************************************************************
      Purpose    : Bepaal de statussen timely en complete o.b.v. de tijden dat we een status DELIVERED en/of APPROVED hebben ontvangen

      Generieke procedure van gemaakt, zodat we de beslisboom (zie de Argus pagina op de Wiki) maar 1 keer hoeven te maken
      *************************************************************************************************************************************/
      cn_module                             varchar2(100) := cn_package || '.' || 'determine_statusses';

   begin
      if  p_delivered_utc <= p_deadline_utc
      and p_approved_utc  is not null then
          -- Netjes op tijd verstuurd en approved. Als hij approved is, maakt de tijd van de aprroval niet uit
          p_timely                   := 'TRUE';
          p_complete                 := 'TRUE';
      elsif p_delivered_utc is null then
            if p_approved_utc  <=  p_deadline_utc then
               -- Geen TACK ontvangen, maar wel op tijd approved, dat is ook goed
               p_timely              := 'TRUE';
               p_complete            := 'TRUE';
            elsif p_approved_utc > p_deadline_utc then
               -- Geen TACK ontvangen, maar wel approved na de deadline, dan zijn we te laat, maat wel compleet
               p_timely              := 'FALSE';
               p_complete            := 'TRUE';
            elsif p_approved_utc is null then
                  if p_deadline_utc < systimestamp at time zone 'UTC' then
                     -- We hebben geen TACK en geen FACK, maar zitten na de deadline, dan zijn we dus te laat en niet compleet
                     p_timely        := 'FALSE';
                     p_complete      := 'FALSE';
                  else
                     -- We hebben nog geen TACK en geen FACK, maar zitten nog voor de deadline, dan doen we niets.
                     p_timely        := null;
                     p_complete      := null;
                  end if;
            end if;
      elsif p_delivered_utc <= p_deadline_utc then
         if p_rejected_utc is not null then
             -- Op tijd verstuurd, maar REJECTED, dan beiden op FALSE zetten, ondanks dat we nog op tijd kunnen zijn.
             -- FAB gaat dan proberen nog tijdig te zijn
             p_timely                 := 'FALSE';
             p_complete               := 'FALSE';
         else
            -- In dit geval is p_approved_utc null, we hebbn nog geen approved
            if  p_deadline_utc > systimestamp at time zone 'UTC' then
                -- op tijd verstuurd, we hebben nog geen approved en de deadline is nog niet verstreken. Dan weten we nog niets zeker
                p_timely             := null;
                p_complete           := null;
            else
               -- Te laat en geen approved, dan zijn beiden FALSE
                p_timely             := 'FALSE';
                p_complete           := 'FALSE';
            end if;
         end if;
      elsif p_delivered_utc > p_deadline_utc then
         if p_approved_utc  is not null then
            -- 'Te laat tijd verstuurd, wel approved. De tijd van approved kan dan niet meer op tijd zijn
            p_timely                 := 'FALSE';
            p_complete               := 'TRUE';
         else
            -- Te laat verstuurd en geen approved (dat kan ook een rejected zijn, dan zijn we te laat en niet compleet
            p_timely                 := 'FALSE';
            p_complete               := 'FALSE';
         end if;
      end if;

   end determine_statusses;

   function is_argus_publication (p_publication_name         in  sup_publications.name%type)
      return boolean
   is
     /**********************************************************************************************
      Purpose    : Bepaal of de publicatie een Argus prublicatie is. Dit is nodig voor de prio-bepaling
                   in de job-scheduler
     **********************************************************************************************/
      cn_module                varchar2(100) := cn_package || '.' || 'is_argus_publication';

      v_check_name             ags_pbn_definitions.check_name%type;
      v_is_argus_publication   boolean;

      -- Publicatie moet actief zijn en er moet een actief ags_pbn_defintions record zijn
      cursor c_agn_dfn(b_publication_name         in  sup_publications.name%type)
          is select ags_dfn.check_name
               from sup_publications         pbn
               join sup_publication_switches psh     on (    psh.pbn_id = pbn.id
                                                         and systimestamp at time zone 'UTC' between psh.bvalidity_utc_from and psh.bvalidity_utc_to
                                                        )
               join ags_pbn_definitions      ags_dfn on ags_dfn.pbn_id  = pbn.id
              where pbn.name             = b_publication_name
                and ags_dfn.fill_active  = 'TRUE';

   begin
      pcs_log_actions.log_info(p_module => cn_module
                              ,p_text   => 'Start'
                             || chr(13) || 'p_publication_name: ' || p_publication_name
                              );

      open c_agn_dfn(b_publication_name => p_publication_name);
      fetch c_agn_dfn
       into v_check_name;

      v_is_argus_publication              := c_agn_dfn%found;

      close c_agn_dfn;

      pcs_log_actions.log_info(p_module => cn_module
                              ,p_text   => 'Start'
                             || chr(13) || case
                                             when v_is_argus_publication then
                                                  p_publication_name || ' is an Argus publication'
                                             else
                                                  p_publication_name || ' is not an Argus publication'
                                             end
                              );

      return v_is_argus_publication;
    exception
     when others then
       pcs_log_actions.log_error(p_module => cn_module);
       raise;
   end is_argus_publication;

   procedure fill_expectations (p_publication            in sup_publications.name%type)
   /***********************************************************************************************************************************
    Doel     : Standaard procedure om de ags_pbn_expectations records van een specifieke publicatie klaar te zetten voor de Argus controle
               Gebruik deze procedure voor alle publicaties die geen afwijkende manier hebben om de expectations te vullen
   ************************************************************************************************************************************/
   is
     cn_module                constant varchar2(100) := cn_package || '.fill_expectations';

     v_pbn_expression                  varchar2(200);
     v_pbn_date_from_utc               date;
     v_fill_from_runtime_utc           date;
     v_fill_until_runtime_utc          date;
     v_runtime_utc                     date;
     v_runtime_loc                     date;
     v_alerttime_utc                   date;
     v_deadline_utc                    date;
     v_mrid                            varchar2(100);
     v_next_version                    number;
     v_statement                       varchar2(32767);
     v_process_started                 boolean;

     r_ags_epn                         ags_pbn_expectations%rowtype;

     cursor c_ags_dfn (b_publication  in varchar2)
         is select ags_dfn.check_name
                  ,ags_dfn.runtime_schedule
                  ,ags_dfn.alert_after_runtime
                  ,ags_dfn.deadline_after_runtime
              from ags_pbn_definitions ags_dfn
              join sup_publications    pbn     on pbn.id = ags_dfn.pbn_id
             where pbn.name    = b_publication
               and fill_active = 'TRUE';

     r_ags_dfn                         c_ags_dfn%rowtype;

     e_no_ags_definition               exception;
   begin
     if sup_globals.get_global_number(p_name => cn_process_id) is null then
        pcs_pcs_actions.start_process(p_initiating_procedure => cn_module
                                     ,p_description          => 'Fill ARGUS expectations for publication ' || p_publication);
        v_process_started                  := true;
     else
        v_process_started                  := false;
     end if;

     pcs_log_actions.log_info(p_module => cn_module
                             ,p_text   => 'Create Argus expectations for publication ' || p_publication);

     sup_utilities.keep_session_nls;
     sup_utilities.set_session_dutch;

     open c_ags_dfn (b_publication => p_publication);

     fetch c_ags_dfn
      into r_ags_dfn;

     if c_ags_dfn%found then
        v_pbn_expression                 := sup_ojtppy_actions.get_domain_value(p_ojt_code   => p_publication
                                                                               ,p_ppy_code   => sup_constants.cn_pbn_date_expression);

        v_fill_from_runtime_utc          := argus_actions.determine_fill_from_runtime(p_check_name     => r_ags_dfn.check_name);
        v_fill_until_runtime_utc         := argus_actions.determine_fill_until_runtime(p_date_from_utc => systimestamp at time zone 'UTC'
                                                                                      ,p_check_name    => r_ags_dfn.check_name);
        v_runtime_utc                    := v_fill_from_runtime_utc;

        while v_runtime_utc <= v_fill_until_runtime_utc loop
          -- Bepaal het eerstvolgende runmoment
          -- Bij het schedule moeten we met CET tijden werken, omdat de deadline CET gebaseerd is en niet UTC. Het schedule kan daarom alleen met CET tijden
          -- werken. Hier blijven we dus een mogelijk zomer-/wintertijd probleem houden.
          -- Voor start_date wordt wel een UTC tijd gebruikt, maar dat lijkt niet uit te maken omdat de return_date_after meer doet. De toekomst moet uitwijzen of we hier niet toch ook CET moeten gebruiken.
           v_runtime_loc                 := sup_date_actions.convertutc2local(p_utc_date => v_runtime_utc);

           dbms_scheduler.evaluate_calendar_string(calendar_string    => r_ags_dfn.runtime_schedule       -- b.v.'freq=hourly;byminute=0,15,30,45;bysecond=0'
                                                  ,start_date         => v_fill_from_runtime_utc          -- Deze waarde blijft gedurende het proces hetzelfde als starttijd.
                                                  ,return_date_after  => v_runtime_loc                    -- De volgende runtime bereken na de vorige
                                                  ,next_run_date      => v_runtime_loc
                                                  );

           v_runtime_utc                 := sup_date_actions.convertlocal2utc(p_loc_date => v_runtime_loc);

           -- Bepaal welke bvalidity daarbij hoort
           v_statement                   := 'select ' || replace(v_pbn_expression
                                                                ,'p_rundate_utc'
                                                                ,q'[to_date(']' || to_char(v_runtime_utc, 'ddmmyyyyhh24miss') || q'[', 'ddmmyyyyhh24miss')]'
                                                                )
                                         || ' from dual';
           execute immediate v_statement into v_pbn_date_from_utc;

           -- bepaal de document-mrid die bij de bvalidity hoort
           tmn_utilities.get_mrid(p_publication      => p_publication
                                 ,p_pbn_date_utc     => v_pbn_date_from_utc
                                 ,p_tmn_mrid         => v_mrid
                                 ,p_tmn_next_version => v_next_version
                                 );

           -- bepaal de deadline. Die ligt een bepaald moment na de runtime. We gaan hier altijd uit van een interval day to second formaat, omdat de deadline nooit
           -- bijvoorbeeld een maand is.
           v_deadline_utc                := v_runtime_utc + to_dsinterval(r_ags_dfn.deadline_after_runtime);
           
           if r_ags_dfn.alert_after_runtime is not null then
              -- Bepaal de alerttime 
              v_alerttime_utc            := v_runtime_utc + to_dsinterval(r_ags_dfn.alert_after_runtime);
           else
              v_alerttime_utc            := null;   
           end if;

           r_ags_epn                     := null;
           r_ags_epn.check_name          := p_publication;
           r_ags_epn.mrid                := replace(replace(v_mrid, '_FINAL',''), '_PROVISIONAL','');
           r_ags_epn.runtime_utc         := v_runtime_utc;
           r_ags_epn.alerttime_utc       := v_alerttime_utc;
           r_ags_epn.deadline_utc        := v_deadline_utc;
           r_ags_epn.retry_counter       := 0;
           ags_epn_dml.dml_row(p_row => r_ags_epn);

        end loop;
     else
        raise e_no_ags_definition;
     end if;

     close c_ags_dfn;

     pcs_log_actions.log_info(p_module => cn_module
                             ,p_text   => 'Ags_pbn_definitions records added for publication ' || p_publication);
                             
     if v_process_started then
         pcs_pcs_actions.end_process;
     end if;
   exception
     when e_no_ags_definition then
          pcs_log_actions.log_error(p_module => cn_module
                                   ,p_text   => 'No ags_pbn_definitions record found for publication ' || p_publication
                                   );

          if c_ags_dfn%isopen then
            close c_ags_dfn;
          end if;

          if v_process_started then
             pcs_pcs_actions.end_process;
          end if;
     when others then
          pcs_log_actions.log_error(p_module => cn_module);

          if v_process_started then
             pcs_pcs_actions.end_process;
          end if;
   end fill_expectations;

   procedure check_expectations (p_publication  in sup_publications.name%type)
   is
   /***********************************************************************************************************************************
    Doel     : Standaard procedure voor de controle van de tijdigheid en compleetheid van de transmissies met Argus
               Gebruik deze procedure voor alle publicaties die geen afwijkende manier hebben om de expectations te controleren
   ************************************************************************************************************************************/
    cn_module                constant varchar2(100) := cn_package || '.check_expectations';

    r_ags_epn                         ags_pbn_expectations%rowtype;

    v_timely                          ags_pbn_expectations.timely%type;
    v_complete                        ags_pbn_expectations.complete%type;
    v_tmn_id                          pcs_tmn_transmissions.id%type;
    v_continue                        boolean;

    e_no_ags_pbn_expectations         exception;

    cursor c_check_exp (b_publication  in varchar2)
        is with max_retries
             as (select sup_ojtppy_actions.get_domain_value_n(p_ojt_code    => 'ARGUS'
                                                             ,p_ppy_code    => 'MAX_RETRIES'
                                                             ,p_silent_mode => 'Y') as max_retries
                   from dual
                )
         select ags_epn.check_name
               ,ags_epn.mrid
               ,ags_epn.runtime_utc
               ,ags_epn.deadline_utc
               ,ags_epn.timely
               ,ags_epn.complete
               ,ags_epn.retry_counter
           from ags_pbn_expectations ags_epn
          cross join max_retries
          where check_name                 = b_publication
            and ags_epn.runtime_utc       <  systimestamp at time zone 'UTC'
            and (   ags_epn.complete      != 'TRUE'  -- Als complete FALSE is heb je nog een kans
                 or ags_epn.complete      is null)
            and (   ags_epn.timely        != 'TRUE'  -- In principe kan FALSE alleen TRUE worden na een datamutatie
                 or ags_epn.timely        is null)
            and (   ags_epn.retry_counter <= max_retries
                 or ags_epn.deadline_utc  <  systimestamp at time zone 'UTC'); -- Voor de deadline blijven we controleren. dan maakt het aantal retries niet uit

    cursor c_tmn (b_mrid  in pcs_tmn_transmissions.mrid%type)
        is select tmn_id
                 ,started
                 ,created
                 ,coalesce(enqueued , failed, sending) as enqueued  -- Webservice statussen failed en sending worden behandeld als enqueued. Bij een status failed is het bericht wel verstuurd,
                                                                    -- maar hebben we een lege response header terug gekregen. Beetje dubieus of het klopt deze status als enqueued te zien
                 ,sent
                 ,coalesce(delivered, accepted       ) as delivered -- Webservice status accepted wordt behandeld als delivered
                 ,coalesce(approved , accepted       ) as approved  -- Webservice status accepted wordt behandeld als approved
                 ,rejected
                 ,duplicate
            from (select tmn.id                      as tmn_id
                        ,tse.state                   as tse_state
                        ,tse.tvalidity_utc_from      as tse_tvalidity_utc_from
                    from delphidba.pcs_tmn_transmissions     tmn
                    left outer join delphidba.pcs_tmn_states tse on tse.tmn_id = tmn.id
                   where tmn.mrid = b_mrid)
                   pivot(min(tse_tvalidity_utc_from)                -- een aggregate-functie is nodig voor de PIVOT, doet verder eigenlijk niks
                     for tse_state in('STARTED'   as started
                                     ,'CREATED'   as created
                                     ,'ENQUEUED'  as enqueued
                                     ,'SENT'      as sent
                                     ,'DELIVERED' as delivered
                                     ,'APPROVED'  as approved
                                     ,'REJECTED'  as rejected
                                     ,'DUPLICATE' as duplicate
                                     ,'SENDING'   as sending
                                     ,'FAILED'    as failed
                                     ,'ACCEPTED'  as accepted));

    r_tmn              c_tmn%rowtype;

  begin
    pcs_log_actions.log_info(p_module => cn_module
                            ,p_text   => 'Check Argus expectations for publication ' || p_publication
                            );
                            
    -- Zet de timesone op UTC, omdat de cursr c_check_exp anders klapt op het winter-/zomertijduur, ondanks dat de kolommen een date datatype hebben.
    sup_utilities.keep_session_timezone;
    sup_utilities.set_session_timezone(p_timezone => 'UTC');                            

    for r_check_exp in c_check_exp(b_publication => p_publication)  loop
        -- Zet de op te zoeken statussen op eventuele statussen die we al hebben. Lege statussen initieel op FALSE zetten
        -- Dit om bestaande statussen TRUE niet te overschrijven
        v_timely                       := nvl(r_check_exp.timely  , 'FALSE');
        v_complete                     := nvl(r_check_exp.complete, 'FALSE');
        v_tmn_id                       := null;
        v_continue                     := true;
        r_tmn                          := null;

        open c_tmn(b_mrid => r_check_exp.mrid);
        fetch c_tmn
         into r_tmn;
         
        -- Loop door de transmissies heen, het kan namelijk zo zijn dat de eerste bijvoorbeeld niet verzonden is, maar de 2e transmissie
        -- nog netjes op tijd was.
        while v_continue loop
           v_tmn_id                    := r_tmn.tmn_id;

           argus_actions.determine_statusses(p_delivered_utc => r_tmn.delivered
                                            ,p_approved_utc  => r_tmn.approved
                                            ,p_rejected_utc  => r_tmn.rejected
                                            ,p_deadline_utc  => r_check_exp.deadline_utc
                                            ,p_timely        => v_timely
                                            ,p_complete      => v_complete);

           -- Zodra de status complete is gezet, maar dit is niet een REJECTED, dan hebben we een eindstatus.
           -- Bij een rejected even verder kijken, want het kan zo maar dat er een APPROVED achteraan komt
           if (    v_complete     is not null
               and r_tmn.rejected is null) then
              v_continue               := false;
           else
              fetch c_tmn
               into r_tmn;
           end if;

           -- Hebben we geen transmissie meer gevonden, dan kunnen we nu ook stoppen
           if c_tmn%notfound then
              v_continue              := false;
           end if;
        end loop;

        close c_tmn;

        -- Als status complete leeg is, is de deadline is nog niet verstreken. Dan is er nog niks aan de hand, want de ACK kan nog op tijd komen.
        -- In dat geval doen we niets, ook het aantal retries niet ophogen.
        if v_complete is not null then
           r_ags_epn                   := null;
           r_ags_epn.check_name        := r_check_exp.check_name;
           r_ags_epn.mrid              := r_check_exp.mrid;
           ags_epn_dml.get_row_mrid(p_row => r_ags_epn);
           
           if r_ags_epn.id is null then
              -- dit zou niet moeten kunnen
              pcs_log_actions.log_error(p_module => cn_module
                                       ,p_text   => 'Unable to find ags_pbn_expectations record for mrid ' || r_check_exp.mrid);
              raise e_no_ags_pbn_expectations;
           end if;

           -- Zet de statussen in het expecations-record. Ook hier geldt dat status TRUE mag nooit overschreven worden
           if nvl(r_ags_epn.timely, 'XX') != 'TRUE' then
              r_ags_epn.timely         := v_timely;
           end if;

           if nvl(r_ags_epn.complete, 'XX') != 'TRUE' then
              r_ags_epn.complete              := v_complete;
           end if;

           if r_check_exp.deadline_utc < cast(sys_extract_utc(systimestamp) as date) then
              r_ags_epn.retry_counter         := nvl(r_check_exp.retry_counter, 0) + 1;
           else
              r_ags_epn.retry_counter         := nvl(r_check_exp.retry_counter, 0);
           end if;
           r_ags_epn.tmn_id                   := v_tmn_id;
           ags_epn_dml.dml_row(p_row => r_ags_epn);
        end if;
    end loop;

    sup_utilities.reset_session_timezone;
    
    pcs_log_actions.log_info(p_module => cn_module
                            ,p_text   => 'End');
   exception
     when others then
       pcs_log_actions.log_error(p_module => cn_module);
 
       if c_tmn%isopen then
          close c_tmn;
       end if;

      pcs_pcs_actions.end_process;
   end check_expectations;

   procedure check_expectation_after_ack (p_publication  in sup_publications.name%type
                                         ,p_mrid         in pcs_tmn_transmissions.mrid%type)
   is
   /***********************************************************************************************************************************
    Doel     : Standaard procedure voor de controle op de tijdigheid en compleetheid van de transmissies met Argus na binnenkomst van
               een Acknowledgement
               Gebruik deze procedure voor alle publicaties die geen afwijkende manier hebben om de expectations te controleren
   ************************************************************************************************************************************/
      r_ags_epn                         ags_pbn_expectations%rowtype;

      cn_module                constant varchar2(100) := cn_package || '.check_expectation_after_ack';
      v_timely                          ags_pbn_expectations.timely%type;
      v_complete                        ags_pbn_expectations.complete%type;

      v_tmn_id                          pcs_tmn_transmissions.id%type;
      v_continue                        boolean;
      v_update                          boolean;

      cursor c_check_exp (b_mrid  in ags_pbn_expectations.mrid%type)
          is select ags_epn.check_name
                   ,ags_epn.mrid
                   ,ags_epn.runtime_utc
                   ,ags_epn.deadline_utc
                   ,ags_epn.timely
                   ,ags_epn.complete
                   ,ags_epn.tmn_id
                   ,ags_epn.retry_counter
               from ags_pbn_expectations ags_epn
              where ags_epn.mrid              = b_mrid
                and (   (   ags_epn.complete != 'TRUE'  -- Als complete FALSE is heb je nog een kans.
                         or ags_epn.complete is null)
                     or (   ags_epn.timely   != 'TRUE'  -- Ook als complete FALSE is heb je nog een kans
                         or ags_epn.timely   is null)
                    );

      r_check_exp   c_check_exp%rowtype;

      cursor c_tmn (b_mrid  in pcs_tmn_transmissions.mrid%type)
          is select tmn_id
                   ,started
                   ,created
                   ,coalesce(enqueued , failed, sending) as enqueued  -- Webservice statussen failed en sending worden behandeld als enqueued. Bij een status failed is het bericht wel verstuurd,
                                                                      -- maar hebben we een lege response header terug gekregen. Beetje dubieus of het klopt deze status als enqueued te zien
                   ,sent
                   ,coalesce(delivered, accepted       ) as delivered -- Webservice status accepted wordt behandeld als delivered
                   ,coalesce(approved , accepted       ) as approved  -- Webservice status accepted wordt behandeld als approved
                   ,rejected
                   ,duplicate
              from (select tmn.id                      as tmn_id
                          ,tse.state                   as tse_state
                          ,tse.tvalidity_utc_from      as tse_tvalidity_utc_from
                      from delphidba.pcs_tmn_transmissions     tmn
                      left outer join delphidba.pcs_tmn_states tse on tse.tmn_id = tmn.id
                     where tmn.mrid = b_mrid)
                     pivot(min(tse_tvalidity_utc_from)                -- een aggregate-functie is nodig voor de PIVOT, doet verder eigenlijk niks
                       for tse_state in('STARTED'   as started
                                       ,'CREATED'   as created
                                       ,'ENQUEUED'  as enqueued
                                       ,'SENT'      as sent
                                       ,'DELIVERED' as delivered
                                       ,'APPROVED'  as approved
                                       ,'REJECTED'  as rejected
                                       ,'DUPLICATE' as duplicate
                                       ,'SENDING'   as sending
                                       ,'FAILED'    as failed
                                       ,'ACCEPTED'  as accepted));

      r_tmn              c_tmn%rowtype;

   begin
      pcs_log_actions.log_info(p_module => cn_module
                              ,p_text   => 'Check Argus expectations after ACK for publication ' || p_publication
                                        || ' mrid: ' || p_mrid);

      -- Zet de timesone op UTC, omdat de cursr c_check_exp anders klapt op het winter-/zomertijduur, ondanks dat de kolommen een date datatype hebben.
      sup_utilities.keep_session_timezone;
      sup_utilities.set_session_timezone(p_timezone => 'UTC');                            


      v_update                           := false;
      v_continue                         := true;

      open c_check_exp(b_mrid  => p_mrid);
      fetch c_check_exp
       into r_check_exp;

      if c_check_exp%found then
         open c_tmn(b_mrid => r_check_exp.mrid);

         fetch c_tmn
          into r_tmn;

          -- Loop door de transmissies heen, het kan namelijk zo zijn dat de eerste bijvoorbeeld niet verzonden is, maar de 2e transmissie
          -- nog netjes op tijd was.
          while v_continue loop
             v_tmn_id                    := r_tmn.tmn_id;

             argus_actions.determine_statusses(p_delivered_utc => r_tmn.delivered
                                              ,p_approved_utc  => r_tmn.approved
                                              ,p_rejected_utc  => r_tmn.rejected
                                              ,p_deadline_utc  => r_check_exp.deadline_utc
                                              ,p_timely        => v_timely
                                              ,p_complete      => v_complete);

             -- Zodra de status complete is gezet, maar dit is niet een REJECTED, dan hebben we een eindstatus.
             -- Bij een rejected even verder kijken, want het kan zo maar dat er een APPROVED achteraan komt
             if (    v_complete     is not null
                 and r_tmn.rejected is null) then
                v_continue               := false;
             else
                fetch c_tmn
                 into r_tmn;
             end if;

             -- Hebben we geen transmissie meer gevonden, dan kunnen we nu ook stoppen
             if c_tmn%notfound then
                v_continue               := false;
             end if;
          end loop;

          close c_tmn;

          -- Zet de statussen in het expecations-record. Ook hier geldt dat status TRUE mag nooit overschreven worden
          if nvl(r_check_exp.timely, 'XX') != 'TRUE' then
             r_check_exp.timely          := v_timely;
             v_update                    := true;
          end if;

          if nvl(r_check_exp.complete, 'XX') != 'TRUE' then
             r_check_exp.complete        := v_complete;
             v_update                    := true;
          end if;

          if v_update then
             r_ags_epn                   := null;
             r_ags_epn.check_name        := r_check_exp.check_name;
             r_ags_epn.mrid              := r_check_exp.mrid;
             r_ags_epn.timely            := r_check_exp.timely;
             r_ags_epn.complete          := r_check_exp.complete;
             r_ags_epn.runtime_utc       := r_check_exp.runtime_utc;
             r_ags_epn.deadline_utc      := r_check_exp.deadline_utc;
             if r_check_exp.deadline_utc < cast(sys_extract_utc(systimestamp) as date) then
                r_ags_epn.retry_counter  := nvl(r_check_exp.retry_counter, 0) + 1;
             else
                r_ags_epn.retry_counter  := nvl(r_check_exp.retry_counter, 0);
             end if;
             r_ags_epn.tmn_id            := v_tmn_id;

             ags_epn_dml.dml_row(p_row => r_ags_epn);
          end if;
      end if;   -- if c_check_exp%found

      close c_check_exp;

      sup_utilities.reset_session_timezone;
      
   exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);

      if c_tmn%isopen then
         close c_tmn;
      end if;

      if c_check_exp%isopen then
         close c_check_exp;
      end if;
   end check_expectation_after_ack;

end argus_actions;
/
