create or replace package body delphidba.dqf_rst_actions is

  /***********************************************************************************************************************************
   Purpose     : Actions towards table dqf_compliancy.

   Change History
   Date         Author          Version     Description
   ----------   --------------- --------    ----------------------------------------------------------------------------------------------
   10-09-2018   Y. Krop         01.00.00    TRAN-1913 Created.
   24-09-2018   X. Pikaar       01.01.00    Package hernoemd. Procedure check_expectations toegevoegd. Nog lang niet volledig, maar er is
                                            een begin
   04-10-2018   M. Zuijdendorp  01.01.01    In cursor c_crt de Where-clause op bvaliditiy verplaatst naar de outer join
   05-10-2018   X. Pikaar       01.01.02    Foutieve naamgeving record en table gecorrigeerd
   16-10-2018   X. Pikaar       01.01.03    Enkele pls_integers gewijzigd naar simple_integers omdat Sonar dan blij is
   17-10-2018   X. Pikaar       01.01.04    Statussen veranderd (zie Wikipagina DQF-statusses transmissions)
   18-10-2018   Y. Krop         01.02.00    Procedure fill_expectations grondig gewijzigd.
   19-10-2018   Y. Krop         01.02.01    Sonar-melding weggepoetst.
   24-10-2018   Y. Krop         01.02.02    Sonar-melding over te lange regels weggewerkt.
   31-10-2018   Y. Krop         01.02.03    Aanpassing aan fill_expectations t.b.v. voorkomen duplicate records.
   02-11-2018   X. Pikaar       01.02.04    Aanmaken van verwachtingen hield helemaal geen rekening met 15-minuten publicaties. Nu even
                                            quick and dirty opgelost door alleen 15-minuten en uren aan te kunnen. Dit wordt met
                                            TRAN-2400/2413 opgelost
   07-11-2018   X. Pikaar       02.00.00    TRAN-2400/2413: hernoemd naar dqf_rst_actions. Gebruik maken van tabel dqf_definitions i.p.v.
                                            dqf_compliancy. Procedure fill_expectations compleet herbouwd: werkt nu op alle processen.
   30-11-2018   M. Zuijdendorp  02.00.01    Extra check bij berekening result record
   06-12-2018   X. Pikaar       02.00.02    Bepalen compliancy_deadline uit laten gaan van de first_checktime_utc. Deze had zijn
                                            eigen variabele waardoor het gebeurde dat de check-time na de deadline kwam te liggen
   08-01-2019   X. Pikaar       02.00.03    fill_expectations: De rekenvelden voor timestamps gewijzigd naar timestamp with LOCAL time zone
                                            en de timezone keihard op UTC zetten. Anders zet Oracle de timezone stiekem omzet naar lokaal
                                            waardoor de vergelijking first_checktime_utc met systimestamp UTC in de check_expectations te laat
                                            afgaat. Heel raar overigens...
   09-01-2019   M. Zuijdendorp  02.00.04    Extra column in DQF_Definitions: bvalidity_execute_expression_to
   25-01-2019   X. Pikaar       02.00.05    Berekening data in verwachtingsrecords ging nog steeds niet altijd goed. Nu lijkt het wel te
                                            werken
   19-02-2019   M. Zuijdendorp  02.00.06    TRAN-2649: Check_expectations aangepast zodat het ook slechts 1 transmissie kan checken ipv alles
                                                       parameter p_tmn_id toegevoegd.
   21-02-2019   X. Pikaar       02.00.07    check_expectations: IN-mode aan parameter toegevoegd
   22-02-2019   M. Zuijdendorp  02.00.08    TRAN-2649: Nieuwe proc Check_single_expectation toegevoegd ipv de originele check_expectations misbruiken
   25-02-2019   M. Zuijdendorp  02.00.09    In check de vergelijking tussen tussen compliancy_deadline en delivery_date aangepast
                                            zodat ze beide in hetzelfde formaat staan
   07-03-2019   M. Zuijdendorp  02.00.10    In check_single_expectation number of retries verwijderd, omdat deze check altijd uitgevoerd moet kunnen worden
   29-03-2019   X. Pikaar       02.00.11    Niet gebruikte variabele verwijderd
   08-04-2019   X. Pikaar       02.00.12    fill_expectations: Vertaling naar UTC ging toch nog niet goed. Nu keihard UTC toevoegen aan de datum
   12-08-2019   M. Zuijdendorp  02.00.13    TRAN-3062 pbn_id toegevoegd aan dqf_definitions
   23-08-2019   Y. Krop         02.00.14    TRAN-3066 Lelijke oplossing voor to_yminteval i.c.m. (bijvoorbeeld) 31 januari ingebouwd.
   26-08-2019   Y. Krop         02.00.15    Sonar-melding m.b.t. get_bval_loc_from_EDP52FCR opgelost.
   08-10-2019   Y. Krop         02.00.16    TRAN-3384 quick 'n VERY dirty oplossing voor de EDP_08 ingebouwd, moet nog een keer netjes.
   28-10-2019   X. Pikaar       02.00.17    TRAN-3478: convertlocal2utc_ts i.p.v. convertlocal2utc zodat de zomer-/wintertijdovergang hopelijk
                                             wel goed gaat werken
   30-12-2019   M. Zuijdendorp  02.00.18    TRAN-3498: DQF results voor inkomende stromen vullen en checken
   02-01-2020   M. Zuijdendorp  02.00.19    TRAN-3400: In geval van een FINAL publicatie ook de PROVISIONAL publicatie
                                                       met dezelfde mrid extra checken.
   21-01-2020   X. Pikaar       02.00.20    TRAN-3400: Bijwerken PROVISIONALs o.b.v. de FINALs gebeurde alleen in de check_expectations en
                                            niet in de check_single_expectation. De check_single_expectation wordt bij ontvangst van een
                                            ACK aangeroepen
   31-01-2020   X. Pikaar       02.00.21    TRAN-3723 Update provisional DQF record after Final FACK (de wijzigingen van release 02.00.19
                                            en 02.00.20 werkten niet)
   06-05-2020   X. Pikaar       02.01.00    TRAN-4048: DQF-results werden alleen gecontroleerd als er een transmission of reception
                                            was. Als er nooit een transmissie gedaan werd of nooit iets ontvangen, werd ook de DQF-controle
                                            niet gedaan (da's niet goed)
   07-05-2020   X. Pikaar       02.01.01    Bij check_single_expectation van de reception werd UTC-tijd tegen sysdate aangehouden i.p.v.
                                            systimestamp at time zone 'UTC'
   11-05-2020   T. Bakker       02.01.02    TRAN-3663 DQF records van de TDW_01_PROVISIONAL staan ten onrechte op TIMELY 'UNKNOWN'
   16-06-2020   R. Standhaft    02.01.03    TRAN-4087: toegevoegd: controle op meerdere bestanden met dezelfde bvalidity's
   20-07-2020   R. Standhaft    02.01.04    TRAN-3479: een TDW, rejected voor de deadline, moet de statussen UNKNOWN krijgen
   05-08-2020   R. Standhaft    02.01.05    TRAN-3479: vervolg (aanpassingen na test)
   06-08-2020   R. Standhaft    02.01.06    TRAN-3479: vervolg (aanpassingen na test)
   26-08-2020   R.Koomen        02.02.00    TRAN-4289: Alle timestamp afhandeling in fill_expectations omgewerkt om de zomer- wintertijd
                                            goed te krijgen
   25-09-2020   X. Pikaar       02.02.01    Sonar-meldingen
   16-11-2020   X. Pikaar       02.03.00    TRAN-4356: Optimalisering dqf_expectations i.v.m ORA-01555: snapshot too old
   18-11-2020   X. Pikaar       02.04.00    TRAN-4424: fill_expectations aangepast om Z/W en W/Z overgangsfouten te corrigeren
   24-11-2020   X. Pikaar       02.04.01    Vervolg TRAN-4424, flink wat magie ingebouwd om de W/Z en Z/W overgang goed te krijgen in
                                            fill_expectations. Hopelijk zijn we er nu.
   11-12-2020   X. Pikaar       02.04.02    Loop label toegevoegd aan exit-statement in check_expectations.
   22-12-2020   M. Walraven     02.04.03    Performance fix check_single_expectation van TRAN-4084.
   15-01-2021   X. Pikaar       02.05.00    TRAN-4494: DQF bijwerken o.b.v. berichtencontrole: als er in de technical_log_lines van het
                                            transmissieproces een fout voorkomt, wordt  de status_accurate op 'FALSE' gezet.
   29-01-2021   X. Pikaar       02.05.01    TRAN-4146: fill_expectation uitgaand uitgebreid met vullen van publication_time
   29-01-2021   M. Zuijdendorp  02.05.02    TRAN-4146: Check_single_expectation uitgaand uitgebreid met controle op publication_time
   01-02-2021   X. Pikaar       02.05.03    TRAN-4146: Check_single_expectation: tmn.cre_date_utc niet vergelijken met de first_check_time
                                            want de transmissie kan na de first_check_time liggen.
   02-02-2021   X. Pikaar       02.05.04    TRAN-4146: ook in check_expectations de tmn.cre_date_utc vergelijken met de publication-time
                                            van dqf_results om ook hier meerdere publicaties met dezelfde bvalidity aan te kunnen
   03-02-2021   M. Zuijdendorp  02.05.05    TRAN-4568: Bij data-driven publicaties ook de reception meenemen in de timely beoordeling
   08-02-2021   X. Pikaar       02.06.00    TRAN-4568: Met kolom check_name kunnen we meerdere tijdlijnen controleren bij een dqf-proces
   03-03-2021   X. Pikaar       02.07.00    TRAN-4721: correctie op berekende publication_time_utc ingebouwd
   09-03-2021   X. Pikaar       02.08.00    TRAN-4572: in check_single_expectation geen rekening meer houden met de compliancy_deadline_utc en
                                            first_checktime_utc omdat daardoor de ACK niet direct aan het dqf_results record te koppelen
                                            is als de first_checktime_utc na de publicatietijd ligt. Procedure check_expectations
                                            selecteert zelf al alleen die dqf_resuls-records waarvan de first_checktime_utc vertreken is
                                            en vanuit de ACK krijg je al het juiste transmissie-record mee.
   23-03-2021   X. Pikaar       02.08.01    In fill_expectations werd het dqf_results-record niet geinitialiseerd
   24-03-2021   R. Standhaft    02.08.02    TRAN-4535: Controle op timeliness bij TDW's geeft verkeerde status (state_timely)
   14-04-2021   X. Pikaar       02.09.00    TRAN-4798: Bij publicaties die meerdere keren per dag over dezelfde bvalidity publiceren
                                            werden bij iedere alle records gecontroleerd met een publication_time_utc tijd voor de
                                            huidige controletijd. Daardoor werd dus veel teveel gecontroleerd.
                                            Check_single_expectation is niet hierop aangepast, dat lijkt niet nodig.
   01-07-2021   Y. Krop         02.09.01    TRAN-4628 EDP_48_FINAL first check half uurtje later gezet.
   14-07-2021   X. Pikaar       02.10.00    TRAN-4991: check_single_expectation (tmn) moest ook wel rekening houden met de 'volgende'
                                            transmissie(s). Nu werden alle DQF-records van volgende transmissies geselecteerd, terwijl
                                            er maar 1 specifieke geselecteerd moest worden. Cursor gesplitst in versie die via
                                            dfq_results (rst_id) loopt en versie die via pcs_tmn_transmissions (tmn_id) loopt omdat
                                            je anders niet meer via transmissie kunt zoeken
   19-07-2021   X. Pikaar       02.10.01    TRAN-4991: als er geen this_pbn_date/next_pbn_date was werd helemaal geen transmissie gevonden.
   21-07-2021   X. Pikaar       02.10.02    TRAN-4991: wizjiging 02.10.01 ging nog niet helemaal lekker
   08-08-2021   R. Standhaft    02.10.03    TRAN-5024: in "fill_expectations" correcties voor "first_checktime" en "compliancy_deadline" maken
   11-08-2021   M. Zuijdendorp  02.10.04    TRAN-5051: In fill_expectations alleen dqf_definitions met check_type 'DATA' of 'TIME' selecteren
   11-08-2021   M. Zuijdendorp  02.10.04    TRAN-5051: fill_single_expectation toegevoegd (bedoeld voor ad-hoc expectations)
   27-08-2021   X. Pikaar       02.11.00    TRAN-5016: diverse variabelen niet vullen in declaratie van de procedure omdat je dan een
                                            niet herleidbaar proces start.
                                            Description meegeven bij start_process
   09-09-2021   X. Pikaar       02.12.00    check_single_expectation (rcn) gebruikte precies de verkeerde cursor. Als het rst_id bekend
                                            is, moet er een outer-join op de receptions gedaan worden (die kan er immers niet zijn en dat
                                            willen we juist zien). Als het tmn_id bekend is, kan je wel inner joinen. Cursornamen ook
                                            wat verduidelijkt in deze procedure.
                                            Ook wat bugs uit de compliancy-bepaling van de receptions gehaald
   20-09-2021  X. Pikaar        02.13.00    Correctie op publicatiemoment hield geen rekening met het foutief in het niet bestaande
                                            W/Z uur terecht  te komen
   04-10-2021  X. Pikaar        02.14.00    TRAN-5086: check_single_expectation (tmn) moet ook rekening houden met status DUPLICATE en in
                                            dat geval de status van het vorige dqf_results-record voor hetzelfde process/bvalidity overnemen
                                            of het record niet aanpassen
   15-10-2021  X. Pikaar        02.14.01    De duplicate-controle zorgde er bij een final met duplicaat voor dat de controle mis gaat omdat
                                            er dan naar de provisional-versie gekeken moet worden
   20-10-2021  X. Pikaar        02.14.02    State_accurate werd op TRUE gezet als er helemaal geen transmissie was geweest.
   11-08-2021  P. Schriek       02.15.00    TRAN-5023: toevoegen procedure fill_single_expectation_for_date
   11-08-2021  X. Pikaar        02.15.01    Mogelijkheid om uren van tevoren toe te voegen uit fill_single_expectation_for_date verwijderd,
                                            want dit is altijd voor 1 datum
   07-12-2021  X. Pikaar        02.16.00    TRAN-5177: check_single_expectation(tmn): oracle raakte kluts kwijt door een and/or sutiatie in de
                                            c_crt_rst-query die door de haakjes wel klopte, maar geen resultaat gaf als de this_pbn_date gevuld
                                            was, maar de next_pbn_date null was.
   06-01-2022  X. Pikaar        02.16.01    Cursor c_last_rst werd niet gesloten
   08-04-2022  Nico Klaver      03.00.00    TRAN-5170: Volledig herschreven mbt date en timestamp behandeling
                                                       Refactoring mbt Herhalende code
                                                       Dode takken eruit
   19-04-2022  Nico Klaver      03.01.00    TRAN-5351: Optionele parameter p_process voor check_expectations zodat we per publicatie
                                                       Kunnen bijdraaien
   25-04-2022  X. Pikaar        03.01.01    Op diverse plaatsen werd de cursor niet gesloten
   25-04-2022  X. Pikaar        03.01.02    Cursor c_dfn: niet meer kijken naar checktype, ADHOC moet ook kunnen. Ook afvangen of er
                                            wel definitions gevonden zijn in de fill_expectation-procedures
   26-04-2022  X. Pikaar        03.01.03    cursor c_dfn zette deadline_after_bval_from op null. Na controle van deadline_after_bval_from_src
                                            op juist formaat moest de to_dsinterval van deadline_after_bval_from_src gedaan worden,
                                            maar dat werd van deadline_after_bval_from (die dus null bevatte vanuit de query) gedaan
                                            waardoor er nooit een interval bij de bval to opgeteld werd.
                                            Dit gold ook voor period_interval_day_to_second en period_interval_year_to_month
                                            Rare constructie met deadline_after_bval_from_src en deadline_after_bval_from uit de query
                                            gehaald en venvangen door een variabele
  02-05-2022   Nico KLaver      03.02.00    TRAN-5482: Er kan nu direct op document mRID gematched worden i.p.v. process/bvalidity.
  03-05-2022   Nico Klaver      03.03.00    TRAN-5255: Geschikt gemaakt voor webservice statussen (check_expectations)
  13-05-2022   Nico KLaver      03.04.00    TRAN-5530: ACTIVE_YN vervangen door IND_ACTIVE_CHECK en IND_ACTIVE_FILL
  13-05-2022   Nico KLaver      03.05.00    TRAN-5491: Retrofitting en toevoegen fill_expectation_data
  23-05-2022   Nico KLaver      03.06.00    TRAN-5357: 1. Alleen fill_expectations doen voor niet ADHOC (DATA en TIME) checktype (terug gezet)
                                                       2. Matchen op mrid ook in check_single expectation
                                                       3. state_accurate meegenomen in de queries van check_expectations en
                                                          check_single expectation
  07-06-2022  Nico Klaver       03.07.00   Bij webservice publications delivered ook vullen in check_single_expectation
  08-06-2022  Nico Klaver       03.08.00   TRAN-5557: Query C_DFN cursor wordt lokaal gedefinieerd. Bij de fill_single* procedures
                                                      De gevraagde definitie ophalen, niet verder filteren.
  10-06-2022  X. Pikaar         03.08.01   Afvangen of DQF wel actief is in fill_single_expectation en fill_single_expectation_for_date
  22-06-2022  X. Pikaar         03.08.02   Queries in check_single_expectation werkten niet als er meerdere dqf_defintions records
                                           voor hetzelfde proces waren met afwijkende waarden voor ind_check_active e.d.
  27-06-2022  X. Pikaar         03.09.00   TRAN-5612: Controle op accuraatheid niet doen voor inkomende stromen.
  01-07-2022  X. Pikaar         03.10.00   TRAN-5137: functionaliteit toegevoegd om de deadline en first_check_date te berekenen o.b.v.
                                           de bvalidity van een publicatie. Dit is nodig voor ADP_09
                                           Tevens enkele functies een wat duidelijker naam gegeven
  15-07-2022  Nico Klaver       03.11.00   MRID_SUFFIX implementeren
  18-07-2022  X. Pikaar         03.12.00   TRAN-5676: bij berekeningen met een interval niet mee direct de intervallen erbij optellen
                                           omdat dat niet goed gaat met het eind van de maand. sup_date_actions.add_interval_to_timestamp_tz
                                           doet dit wel goed.
  10-08-2022  Y. Krop           03.12.01   Bugfix op 03.12.00: geen null in de aanroep naar sup_date_actions.add_interval_to_timestamp_tz
  03-08-2022  P. Schriek        03.13.00   TRAN-5546 DQF - sla de PK van het definition record op in het result record (dfn_id toegevoegd)
  11-08-2022  Y. Krop           03.13.01   TRAN-5610: Bij inkomende stroom kijken naar SUPPLIED i.p.v. RECEIVED
  15-08-2022  Nico Klaver       03.13.02   TRAN-5610: Ook bij check_double_expectations kijken naar SUPPLIED ipv RECEIVED
  15-08-2022  X. Pikaar         03.14.00   TRAN-5609: publication_time_utc hernoemd naar processing_time_utc om bij ook inkomende stromen
                                           meerdere berichten over dezelfde bvalidity te kunnen controleren.
                                           Check_single_expectation (rcn) houdt rekening met de processing_time.
                                           Join dqf_definitions en dqf_results op check_name i.p.v. process, omdat er meerdere records
                                           kunnen zijn met hetzelfde process, maar afwijkende check_name
  26-08-2022  X. Pikaar         03.14.01   min/max uit de queries gehaald van check_single_expectation omdat deze nu op check_name
                                           joint i.p.v. process, waardoor matching niet meer werkte
  26-08-2022 Nico Klaver        03.15.00   TRAN-5453: Verzamel de KPI cijfers aan het eind van check_expectations;
  21-10-2022 X. Pikaar          03.16.00   timestamps met (0) in de fill_expectations zodat we geen fractionele secondes in de deadline e.d.
                                           krijgen
                                           De mrid van ADP_09_TTG/TTN is een beetje apart, dus die op een andere manier bepalen
  04-11-2022 X. Pikaar          03.16.01   timestamps met (0) in de fill_expectations zorgde voor een oneindige loop, dus verwijderd
  09-11-2022 X. Pikaar          03.17.00   ind_local_bvalidity toegevoegd om mrid's te maken die een lokale bvalidity krijgen (edp_51/52fcr bijvoorbeeld)
  14-11-2022 Nico Klaver        03.18.00   TRAN-5823: Andere behandeling van publicaties de een uniek record hebben voor iedere
                                                      bvalidity in de dqf_results tabel. Hier kijken we niet meer naar de
                                                      processing date

                                           Extra parameters voor fill_single_expectation_for_date zodat er voor TDW-23 maar 1 result
                                           record wordt aangemaakt
  21-11-2022 Nico Klaver        03.18.01   Performance en bugfix
  22-11-2022 Nico Klaver        03.18.02   Performance check_single_expectation_tmn c_rst cursor
  23-11-2022 Nico Klaver        03.18.03   Multi had nog fout in de cursor c_crt_tmn
  28-11-2022 Nico Klaver        03.18.04   Cursor c_crt%isopen toegevoegd
  18-01-2023 X. Pikaar          03.19.00   TRAN-6013: parameter p_publication_time hernoemd naar p_processing_time_utc
  19-01-2023 Y. Krop            03.20.00   TRAN-6016 Bij niet-verstuurde transmissie state_complete en state_timely naar FALSE zetten.
  21-03-2023 Y. Krop            03.20.01   TRAN-5864 Sortering aan cursor c_rst in check_expectations toegevoegd.
  04-04-2023 Nico Klaver        03.20.02   TRAN-5484 utc2local vervangen door convertutc2local_ts en
                                                     local2utc vervangen door convertlocal2utc_ts
  01-05-2023 X. Pikaar          03.20.03   In fill_expectation_for_pbn_date werd calculate_correction aangeroepen met v_processing_time_loc
                                           als input. Deze variabele wordt echter niet gevuld, waardoor in sup_date_actions.convertlocal2utc_ts
                                           een ORA-01840: input value not long enough for date format ontstond.
  26-05-2023 X. Pikaar          03.21.00   In fill_expectations werd na de bulk collect met een %notfound gecontroleerd of er nog iets
                                           te doen is. Bij een bulk collect met een resultaat onder de limit wordt een %notfound-status
                                           gezet, dus stopte de verwerking terwijl er nog wel dingen te doen waren. Dit moet afgevangen
                                           worden door te kijken of de collectie nog iets bevat
  05-06-2023 Nico KLaver        03.22.00   TRAN-5547 vullen van tmn_id of rcn_id op basis waarvan we het DQF record hebben aangepast
  27-06-2023 Nico Klaver        03.23.00   TRAN-6198 Bepaling STATE_ACCURATE losgemaakt van de CHECK_EXPECTATION stroom
  03-07-2023 Nico Klaver        03.23.01   Bugfix lege index in collection
  19-07-2023 Nico Klaver        03.23.02   Overbodige logging vewijderd
  06-11-2024 Xander Pikaar      03.24.00   I.v.m. TRAN-7043: functie correction_stmt kan nu ook functies op de datum aan voor de correctie
                                           i.p.v. alleen een interval
  10-12-2024 Xander Pikaar      03.24.01   functie correction_stmt werkte door de regexp niet met intervallen anders dan het day to second
  06-07-2025 Sandjai Ramasray   03.25.00   TRAN-8243 Correctie foutieve UTC-conversiepatronen.
                                           formaat
  ************************************************************************************************************************************/
  cn_package                  constant varchar2(100) := 'dqf_rst_actions';
  cn_versionnumber            constant varchar2(100) := '03.25.00';

  cn_ts_format                constant varchar2(100) := 'DD-MM-YYYY HH24:MI:SS TZR';
  cn_single                   constant varchar2(100) := 'DQF_RESULT_SINGLE_MATCH';
  g_default_log_level                  varchar2(10);

  type t_dfn_row is record(id                                 dqf_definitions.id%type
                          ,process                            dqf_definitions.process%type
                          ,process_type                       dqf_definitions.process_type%type
                          ,check_type                         dqf_definitions.check_type%type
                          ,deadline_schedule                  dqf_definitions.deadline_schedule%type
                          ,first_check_schedule               dqf_definitions.first_check_schedule%type
                          ,bvalidity_from_expression          dqf_definitions.bvalidity_from_expression%type
                          ,bvalidity_to_expression            dqf_definitions.bvalidity_to_expression%type
                          ,pbn_id                             dqf_definitions.pbn_id%type
                          ,dly_id                             dqf_definitions.dly_id%type
                          ,check_name                         dqf_definitions.check_name%type
                          ,processing_time_correction         dqf_definitions.processing_time_correction%type
                          ,deadline_correction                dqf_definitions.deadline_correction%type
                          ,first_check_correction             dqf_definitions.first_check_correction%type
                          ,publication_schedule               user_scheduler_jobs.repeat_interval%type
                          ,deadline_after_bval_from           dqf_definitions.deadline_after_bval_from%type
                          ,period_interval_day_to_second      dqf_definitions.period_interval_day_to_second%type
                          ,period_interval_year_to_month      dqf_definitions.period_interval_year_to_month%type
                          ,match_on_mrid                      dqf_definitions.match_on_mrid%type
                          ,mrid_prefix                        dqf_definitions.mrid_prefix%type
                          ,mrid_suffix_format                 dqf_definitions.mrid_suffix_format%type
                          ,ind_active_fill                    dqf_definitions.ind_active_fill%type
                          ,deadline_expression                dqf_definitions.deadline_expression%type
                          ,first_check_expression             dqf_definitions.first_check_expression%type
                          ,mrid_suffix                        dqf_definitions.mrid_suffix%type
                          ,ind_local_bvalidity                dqf_definitions.ind_local_bvalidity%type
                          );

  type c_dfn_type is ref cursor return t_dfn_row;

  function get_versionnumber
    return varchar2
  is
    -- return versionnumber
  begin
    return cn_versionnumber;
  end get_versionnumber;

  function create_statement
    ( p_bvalidity_expr in varchar2
    )
    return varchar2 deterministic is
    /************************************************************************************************************************************
     Purpose:  Creeer het statement voor het bepalen van de bvalidity
    ************************************************************************************************************************************/
    cn_module                 constant varchar2(100) := cn_package || '.create_statement';
    cn_trunc_local            constant varchar2(100) := 'sup_date_actions.trunc_local(';

    v_stmt                             varchar2(4000);
    v_occurences                       number(10);
  begin
    v_stmt                        := p_bvalidity_expr;

    v_occurences                  := regexp_count(v_stmt, 'p_');

    -- Maak van parameter p_xxxxx een bind variable
    -- Hier wordt de parameter p_xxxx vervangen door :p_xxxx, b.v. p_checktime wordt in het statement :p_check_time

    if v_occurences > 0 then
      for occurence in 1 .. v_occurences loop
         v_stmt := replace(v_stmt
                          ,substr(v_stmt
                                 ,instr(v_stmt, 'p_', 1, occurence)                                                  -- De positie van p_
                                 ,replace(instr(v_stmt, ' ', instr(v_stmt, 'p_', 1, occurence)),0, length(v_stmt))   -- de spatie na p_. Als er geen spatie is, dan tot het eind van de string pakken
                                 )
                          ,':' ||substr(v_stmt
                                       ,instr(v_stmt, 'p_', 1, occurence)
                                       ,replace(instr(v_stmt, ' ', instr(v_stmt, 'p_', 1, occurence)),0, length(v_stmt))
                                       )
                          );
      end loop;

    -- Vervang trunc( door sup_date_actions.trunc_local(
    -- p_checktime is een local timestamp, we rekenen echter met met UTC timestamps zodat we een truc moeten uithalen
    -- de functie sup_date_actions.trunc_local levert een trunc op van de local date echter met een UTC input
      v_stmt := replace(v_stmt, 'trunc('     , cn_trunc_local);
    else
       pcs_log_actions.log_error('Statement does not contain a parameter starting with p_');
    end if;
    -- Maak er een anoniem block van
    v_stmt := 'begin :out := ' || v_stmt || '; end;';
    --
    return v_stmt;
  exception
    when others then
      pcs_log_actions.log_error( p_module => cn_module
                               );
      raise;
  end create_statement;

  function correction_stmt ( p_correction_expr in varchar2    )
    return varchar2 deterministic is
    /************************************************************************************************************************************
     Purpose:  Creeer het statement voor het corrigeren van de datum
    ************************************************************************************************************************************/
    cn_module                 constant varchar2(100) := cn_package || '.correction_stmt';

    v_stmt                             varchar2(4000);
  begin
    if p_correction_expr like '%p_checktime%' then
       -- statement met een andere functie op de datum, waarbij "p_checktime" vervangen moet worden door een waarde.
       -- Bijvoorbeeld q'[add_months(trunc(p_checktime, 'mm'), 1) - interval '0 00:01:00' day to second]
       v_stmt := 'begin :out := ' || replace(p_correction_expr, 'p_checktime', ':p_checktime') || '; end;';
    else
       -- Berekening o.b.v. (alleen) een interval, bijvoorbeeld -0 00:30:00
       v_stmt := 'begin :out := ' || ':p_checktime' || p_correction_expr || '; end;';
    end if;

    return v_stmt;
  exception
    when others then
      pcs_log_actions.log_error( p_module => cn_module
                               );
      raise;
  end correction_stmt;

  function calculate_correction (p_checktime       in timestamp
                                ,p_correction_expr in varchar2
                                ,p_exec_expr       in boolean default true
                                )
    return timestamp is
    /************************************************************************************************************************************
     Purpose:  Voer calculate_correction interval uit
               Return UTC
    ************************************************************************************************************************************/
    cn_module                 constant varchar2(100) := cn_package || '.calculate_correction';

    v_bvalidity_local                  timestamp;
  begin
    pcs_log_actions.log_trace( p_module => cn_module,
                               p_text   => 'Start' || chr(10)
                                        || 'p_checktime      : ' || to_char(p_checktime, cn_ts_format) || chr(10)
                                        || 'p_correction_expr: ' || p_correction_expr                  || chr(10)
                             );
    if  p_correction_expr is not null
    and p_exec_expr then
      --
      -- Voer de expressie uit
      execute immediate correction_stmt(p_correction_expr)
        using out v_bvalidity_local, p_checktime;
    else
      v_bvalidity_local := p_checktime;
    end if;
    --
    pcs_log_actions.log_trace( p_module => cn_module
                             , p_text   => 'End' || chr(10)
                                        || 'v_bvalidity_local: ' || to_char(v_bvalidity_local, cn_ts_format) || chr(10)
                             );
    --
    return sup_date_actions.convertlocal2utc_ts( p_ts_tz => v_bvalidity_local );
  exception
    when others then
      pcs_log_actions.log_error( p_module => cn_module
                               );
      raise;
  end calculate_correction;

  function execute_expression   (p_time      in timestamp
                                ,p_expr      in varchar2
                                )
    return timestamp is
    /************************************************************************************************************************************
     Purpose:  Bepaal de bvalidity op basis van de opgevoerde LOCAL timestamp en de opgegeven expressie
               Crux van deze functie is dat de p_validity_expr wordt uitgevoerd op een UTC datum. Daardoor kunnen we nooit in
               "verboden" uren terecht komen. Voorwaarde is wel dat de TRUNC functie op de LOCAL timestamp wordt uitgevoerd. Daarvoor
               verbouwen we de opgegeven expressie zodanig dat er i.p.v. TRUNC, TRUNC_LOCAL wordt aangeroepen, die daarvoor zorgt. Dit
               vindt plaats in de functie create_statement.
    ************************************************************************************************************************************/
    cn_module                 constant varchar2(100) := cn_package || '.execute_expression';

    v_in_date                          date;
    v_in_date_utc                      timestamp;
    v_calculated_date                  date;
    v_out_date_loc                     timestamp;
  begin
      pcs_log_actions.log_trace( p_module => cn_module,
                                 p_text   => 'Start' || chr(10)
                                          || 'p_time          : ' || to_char(p_time, cn_ts_format) || chr(10)
                                          || 'p_expr          : ' || p_expr                        || chr(10)
                               );

    -- Zet de opgegeven LOCAL timestamp om naar UTC, maak er een date van
    v_in_date_utc                 := sup_date_actions.convertlocal2utc_ts(p_time);
    v_in_date                     := cast(v_in_date_utc as date);

    -- Voer de expressie uit
    execute immediate create_statement(p_expr)
      using out v_calculated_date
               ,v_in_date;

    -- Zet het resultaat v_bvalidity om naar een LOCAL timestamp, return deze
    v_out_date_loc := sup_date_actions.convertutc2local(from_tz(v_calculated_date, sup_constants.cn_utc_timezone));

    pcs_log_actions.log_trace( p_module => cn_module
                             , p_text   => 'End' || chr(10)
                                        || 'v_out_date_loc          : ' || to_char(v_out_date_loc, cn_ts_format) || chr(10)
                             );

    return v_out_date_loc;
  exception
    when others then
      pcs_log_actions.log_error( p_module => cn_module
                               );
      raise;
  end execute_expression;

  function get_rst_id(p_tmn_id in pcs_tmn_transmissions.id%type) return dqf_results.id%type
  is
    cursor c_tmn(b_tmn_id              in pcs_tmn_transmissions.id%type)
        is select ppy.v_value
             from pcs_tmn_transmissions tmn
             join sup_publications      pbn on       tmn.pbn_id     = pbn.id
             left join sup_ojt_ppy      ppy on  (    ppy.ojt_code   = pbn.name
                                                 and ppy.ppy_code   = cn_single)
            where tmn.id = b_tmn_id;

    cursor c_rst(b_tmn_id              in pcs_tmn_transmissions.id%type)
        is select rst.id
             from dqf_results           rst
             join dqf_definitions       dfn on dfn.check_name  = rst.check_name
             join pcs_tmn_transmissions tmn on rst.mrid        = tmn.mrid
            where dfn.match_on_mrid = 'Y'
              and tmn.id = b_tmn_id
            union all
            select rst.id
              from dqf_results           rst
              join dqf_definitions       dfn on      dfn.check_name  = rst.check_name
              join pcs_tmn_transmissions tmn on (    dfn.pbn_id             = tmn.pbn_id
                                                 and rst.bvalidity_utc_from = tmn.bvalidity_utc_from
                                                 and rst.bvalidity_utc_to   = tmn.bvalidity_utc_to )
             where dfn.match_on_mrid = 'N'
               and tmn.id = b_tmn_id;

    v_value                           sup_ojt_ppy.v_value%type;
    v_rst_id                          dqf_results.id%type;
  begin
     open c_tmn(b_tmn_id        => p_tmn_id);

     fetch c_tmn
      into v_value;

     close c_tmn;

     -- Is het een single_expectation (1 per bvalidity) of een multi (meerdere dqf records met dezelfde bvalidity)?
     if coalesce(v_value, 'X') =  'Y'
     then
       open c_rst(b_tmn_id => p_tmn_id);

       fetch c_rst
        into v_rst_id;

        close c_rst;
     else
       v_rst_id := -1;
     end if;

     return v_rst_id;
  end get_rst_id;

  function get_tmn_id(p_rst_id in dqf_results.id%type) return apex_t_number
  is
    --
    -- Haal de waarde van property DQF_RESULT_SINGLE_MATCH op voor de publicatie
    cursor c_rst(b_rst_id              in dqf_results.id%type)
        is select ppy.v_value
             from dqf_results      rst
             join dqf_definitions  dfn on       dfn.check_name = rst.check_name
             join sup_publications pbn on       dfn.pbn_id     = pbn.id
             left join sup_ojt_ppy ppy on  (    ppy.ojt_code   = pbn.name
                                            and ppy.ppy_code   = cn_single)
            where dfn.ind_active_check = 'Y'
              and rst.id               = b_rst_id;

    cursor c_tmn(b_rst_id              in dqf_results.id%type)
        is select coalesce(tmn_n.id, tmn_y.id) as tmn_id
             from dqf_results                rst
             join dqf_definitions            dfn   on      dfn.check_name           = rst.check_name
             left join pcs_tmn_transmissions tmn_n on (    dfn.match_on_mrid        = 'N'
                                                       and tmn_n.pbn_id             = dfn.pbn_id
                                                       and tmn_n.bvalidity_utc_from = rst.bvalidity_utc_from)
             left join pcs_tmn_transmissions tmn_y on (    dfn.match_on_mrid        = 'Y'
                                                       and tmn_y.mrid               = rst.mrid)
            where rst.id = b_rst_id
            order by coalesce(tmn_n.version     , tmn_y.version)
                   , coalesce(tmn_n.cre_date_utc, tmn_y.cre_date_utc);

    v_value                           sup_ojt_ppy.v_value%type;
    v_tmn_tab                         apex_t_number := apex_t_number();
  begin
     open c_rst(b_rst_id => p_rst_id);

     fetch c_rst
      into v_value;

     -- Is het een single_expectation (1 per bvalidity) of een multi (meerdere over dezelfde bvalidity)?
     if coalesce(v_value, 'X') =  'Y'
     then
        open c_tmn(b_rst_id => p_rst_id);

        fetch c_tmn
         bulk collect
         into v_tmn_tab;

        close c_tmn;
     elsif c_rst%found -- Zonder result record valt er niks te checken
     then
       v_tmn_tab.extend(1);
       v_tmn_tab(1) := -1;
     end if;

     close c_rst;
     return v_tmn_tab;
  end  get_tmn_id;

  procedure fill_expectation_priv
           (p_dfn_row              in out nocopy t_dfn_row
           ,p_processing_time_loc  in            timestamp default null
           ,p_dates_count          in out nocopy simple_integer)
  is
  /************************************************************************************************************************************
   Purpose:  Vul de verwachtingsrecords van de opgegeven dqf-controle
             Let op! We moeten alles in lokale tijd berekenen en pas net voor het opslaan naar UTC gaan!
             private procedure aangeroepen vanuit
             fill_expectations
             fill_single_expectation
             fill_single_expectation_for_date
  ************************************************************************************************************************************/
    cn_module                 constant varchar2(100) := cn_package || '.fill_expectation_priv';
    cn_ojt_code               constant varchar2(100) := 'DQF_FILL_EXPECTATIONS';

    v_bvalidity_loc_from               timestamp;
    v_bvalidity_loc_to                 timestamp;
    v_deadline_loc                     timestamp;
    v_first_checktime_loc              timestamp;
    v_processing_time_loc              timestamp;
    v_start_time_loc                   timestamp;

    v_tmn_time_before_checktime        interval day  to second;
    v_period_interval_year_to_month    interval year to month;
    v_period_interval_day_to_second    interval day  to second;
    v_deadline_after_bval_from         interval day  to second;

    v_end_time_utc                     timestamp default SYS_EXTRACT_UTC(SYSTIMESTAMP);
    v_hours_in_advance                 number(10);

    r_dqf_results                      dqf_results%rowtype;

    v_error                            varchar2(2000);
    v_next_version                     number(10);

    -- exceptions
    e_wrong_format exception;
    e_date_dst_error exception;
    pragma exception_init(e_date_dst_error, -01878);

    cursor c_cpy (b_check_name   in varchar2)
        -- Laatste transmissie als eerst mogelijke startmoment gebruiken. Straks kijken of we al een result record hebben met dezelfde first_check_time om dubbelen te voorkomen
        is select sup_date_actions.convertutc2local( coalesce( max(rst.first_checktime_utc)
                                                                , max(rcn_tmn.bvalidity_utc_from)
                                                                , max(rst.bvalidity_utc_from)
                                                                , max(dfn.bvalidity_utc_from)
                                                                , SYS_EXTRACT_UTC(SYSTIMESTAMP))) as start_time_loc
            from dqf_definitions dfn
            left outer join      dqf_results rst  on dfn.check_name = rst.check_name
            left outer join (select dly.delivery_code            as process
                                   ,min(rcn.bvalidity_utc_from)  as bvalidity_utc_from
                               from pcs_rcn_receptions rcn
                               join sup_deliveries dly on dly.id = rcn.dly_id
                              group by dly.delivery_code
                              union all
                             select pbn.name
                                   ,min(tmn.bvalidity_utc_from)
                               from pcs_tmn_transmissions tmn
                               join sup_publications pbn on pbn.id = tmn.pbn_id
                              group by pbn.name
                             ) rcn_tmn on rcn_tmn.process = dfn.process
           where dfn.check_name   = b_check_name;
    r_cpy    c_cpy%rowtype;

    cursor c_rst(b_process        dqf_results.process%type
                ,b_bvalidity_from dqf_results.bvalidity_utc_from%type)
        is select *
             from dqf_results
            where process            = b_process
              and bvalidity_utc_from = b_bvalidity_from;
    r_rst c_rst%rowtype;

  begin
    -- Logging
    pcs_log_actions.log_trace( p_module => cn_module
                             , p_text   => 'Start' || chr(10)
                                        || 'check_name            : ' || p_dfn_row.check_name   || chr(10)
                                        || 'p_processing_time_loc : ' || p_processing_time_loc  || chr(10)
                             );

    v_hours_in_advance := sup_ojtppy_actions.get_domain_value_n( p_ojt_code   => cn_ojt_code
                                                               , p_ppy_code   => 'CREATE_EXPECTATIONS_HOURS_IN_ADVANCE');
    v_end_time_utc     := v_end_time_utc + sup_date_actions.hours2dsinterval(v_hours_in_advance);

    sup_globals.set_global( p_name  => 'PROCESS'
                          , p_value => p_dfn_row.process);

    -- Bepaal het starttijdstip van de reeks.
    if p_processing_time_loc is null then
      open c_cpy (b_check_name => p_dfn_row.check_name);

      fetch c_cpy
       into r_cpy;

      close c_cpy;
     else
       r_cpy.start_time_loc := p_processing_time_loc;
       v_end_time_utc       := p_processing_time_loc + sup_date_actions.hours2dsinterval(v_hours_in_advance); -- XaPi 20230118: dit klopt niet, hier zet je een lokale tijd in de UTC-kolom
     end if;

    -- deadline_after_bval_from en period_interval moeten het formaat interval day to second hebben, period_interval_year_to_month moet formaat interval year to month
    -- hebben
    if (    p_dfn_row.deadline_after_bval_from is not null
        and regexp_instr(p_dfn_row.deadline_after_bval_from     , '\-?\d+ \d{2}:\d{2}:\d{2}') != 1
       )
    or (    p_dfn_row.period_interval_day_to_second is not null
        and regexp_instr(p_dfn_row.period_interval_day_to_second, '\-?\d+ \d{2}:\d{2}:\d{2}') != 1
       )
    or (    p_dfn_row.period_interval_year_to_month is not null
        and regexp_instr(p_dfn_row.period_interval_year_to_month, '\-?(\d{1,2}-\d{1,2}$)')    != 1
       )
--    or (    p_dfn_row.processing_time_correction is not null
--        and regexp_instr(p_dfn_row.processing_time_correction      , '\-?(\d{1,2}-\d{1,2}$)')    != 1
--       )
    then
      v_error := 'WRONG FORMAT'
              ||chr(10)||' process                            : ' || p_dfn_row.process
              ||chr(10)||' r_dfn.deadline_after_bval_from     : ' || p_dfn_row.deadline_after_bval_from
              ||chr(10)||' r_dfn.period_interval_day_to_second: ' || p_dfn_row.period_interval_day_to_second
              ||chr(10)||' r_dfn.period_interval_year_to_month: ' || p_dfn_row.period_interval_year_to_month
--              ||chr(10)||' r_dfn.processing_time_correction  : ' || p_dfn_row.processing_time_correction
              ;
      raise e_wrong_format;
    else
      v_deadline_after_bval_from              := nvl( to_dsinterval(p_dfn_row.deadline_after_bval_from)
                                                    , interval '0' second);
      v_period_interval_year_to_month         := nvl( to_yminterval(p_dfn_row.period_interval_year_to_month)
                                                    , interval '0' month);
      v_period_interval_day_to_second         := nvl( to_dsinterval(p_dfn_row.period_interval_day_to_second)
                                                    , interval '0' second);
    end if;

    pcs_log_actions.log_info( p_module => cn_module
                            , p_text   => 'Process                  : ' || p_dfn_row.process                               || chr(10)
                                       || 'deadline_schedule        : ' || p_dfn_row.deadline_schedule                     || chr(10)
                                       || 'deadline_after_bval_from : ' || p_dfn_row.deadline_after_bval_from              || chr(10)
                                       || 'bvalidity_from_expression: ' || p_dfn_row.bvalidity_from_expression             || chr(10)
                                       || 'Startdatum               : ' || to_char(r_cpy.start_time_loc, cn_ts_format)     || chr(10)
                            );

    -- Bereken de tijd tussen publicatie en first_checktime. Die interval hebben we nodig om o.b.v. de first_check_time te kunnen berekenen hoe laat de publicatie
    -- geweest is. Dit hebben we nodig voor controle van meerdere transmissies over dezelfde bvalidity
    -- We gebruiken een fictieve datum/tijd. De v_first_checktime_loc en v_processing_time_loc zijn geen tijden die we gaan controleren, dit dient puur om het
    -- verschil te berekenen.
    if p_dfn_row.publication_schedule is not null then
      dbms_scheduler.evaluate_calendar_string( calendar_string    => p_dfn_row.first_check_schedule       -- b.v. 'freq=hourly;byminute=0,15,30,45;bysecond=0'
                                             , start_date         => to_date('01-01-2021 00:00','dd-mm-yyyy hh24:mi')
                                             , return_date_after  => to_date('01-01-2021 00:00','dd-mm-yyyy hh24:mi')
                                             , next_run_date      => v_first_checktime_loc
                                             );
      dbms_scheduler.evaluate_calendar_string( calendar_string    =>  p_dfn_row.publication_schedule      -- b.v. 'freq=hourly;byminute=0,15,30,45;bysecond=0'
                                             , start_date         => to_date('01-01-2021 00:00','dd-mm-yyyy hh24:mi')
                                             , return_date_after  => to_date('01-01-2021 00:00','dd-mm-yyyy hh24:mi')
                                             , next_run_date      => v_processing_time_loc
                                             );

      v_tmn_time_before_checktime  := v_first_checktime_loc - v_processing_time_loc;
    else
      v_tmn_time_before_checktime  := null;
      v_processing_time_loc        := null;
    end if;
    --
    -- v_start_time_loc moet Europe/Amsterdam zijn
    v_start_time_loc               := r_cpy.start_time_loc;
    -- De eerste keer moeten we de eerst volgende check-time en deadline vanaf de start-time berekenen
    v_first_checktime_loc          := v_start_time_loc;
    v_deadline_loc                 := v_start_time_loc;

    -- Aanmaken reeks
    <<create_array>>
    -- XaPi: deze vergelijking is vreemd, maar laat maar ff staan. Het werkt
    while v_start_time_loc < v_end_time_utc
    loop
      if p_dfn_row.first_check_schedule is not null then
        -- Reken het eerste start-moment van de controle
        dbms_scheduler.evaluate_calendar_string( calendar_string    => p_dfn_row.first_check_schedule   -- b.v. 'freq=hourly;byminute=0,15,30,45;bysecond=0'
                                               , start_date         => r_cpy.start_time_loc             -- Deze waarde blijft gedurende het proces hetzelfde al starttijd
                                               , return_date_after  => v_first_checktime_loc            -- De volgende checktime bereken na de vorige
                                               , next_run_date      => v_first_checktime_loc
                                               );
        if v_tmn_time_before_checktime is null then
           v_processing_time_loc := v_first_checktime_loc;
        else
           v_processing_time_loc := v_first_checktime_loc - v_tmn_time_before_checktime;
        end if;

        -- Het is mogelijk dat we door de berekening die uitgaat van de first_check_date op een verkeerd publicatiemoment uitkomen. B.v. de EDP_01 komt een half uur te laat uit
        -- Die tijd wordt hier gecorrigeerd door r_dfn.processing_time_correction (als die negatief is wordt hij dus automatisch ervan afgetrokken)
        if p_dfn_row.processing_time_correction is not null then
          if instr(p_dfn_row.processing_time_correction, 'interval') = 0 then         -- niet wanneer er 'interval' in staat, die gaan we later doen
--            v_processing_time_loc := v_processing_time_loc + to_dsinterval(p_dfn_row.processing_time_correction);
            v_processing_time_loc           := sup_date_actions.add_interval_to_timestamp_tz(p_ts_tz       => v_processing_time_loc
                                                                                            ,p_interval_ym => to_yminterval('00-00')
                                                                                            ,p_interval_ds => to_dsinterval(p_dfn_row.processing_time_correction));

          end if;
        end if;
      else
        v_processing_time_loc := null;
      end if;

      -- Reken de bvalidity_utc_from uit. Dat gaat o.b.v. de checktime. Deze zal dicht in de buurt van de job-runtijd liggen.
      v_bvalidity_loc_from := execute_expression( p_time      => v_first_checktime_loc
                                                , p_expr      => p_dfn_row.bvalidity_from_expression
                                                );


      -- Reken daarna de deadline uit. Voorlopig alleen voor time-driven. Als kolom deadline_schedule gevuld is moet hij er op bepaalde tijden zijn (bijvoorbeeld iedere dag om 13:00)
      if p_dfn_row.deadline_schedule is not null then
        dbms_scheduler.evaluate_calendar_string( calendar_string    => p_dfn_row.deadline_schedule      -- b.v. 'freq=hourly;byminute=0,15,30,45;bysecond=0'
                                               , start_date         => r_cpy.start_time_loc
                                               , return_date_after  => v_first_checktime_loc            -- de volgende deadline berekenen na de vorige. De deadline ligt altijd na de checktime
                                               , next_run_date      => v_deadline_loc
                                               );
      else
        -- Geen deadline schedule, dan moet hij een bepaalde tijd na de bvalidity zitten (dit zal meestal het geval zijn)
        v_deadline_loc := v_bvalidity_loc_from + v_deadline_after_bval_from;
      end if;

      -- a.g.v. het startmoment van de job kunnen v_bvalidity_loc_from en v_start_utc de eerste run gelijk aan elkaar zijn.
      -- dit geeft een unique-key violation bij de insert. Tel daarom de interval op bij de starttijd zodat we in de volgende periode uitkomen
      -- Let op: dit zorgt er bij de allereerste run voor een proces voor (er staat nog niets van dat proces in dqf_results) dat er 1 record in de
      -- toekomst aangemaakt wordt. Is niet erg...
      -- Milko Zuijdendorp: Wel erg voor testen, want er komt een record uit wat je niet verwacht
      --                    Check ingebouwd of het result record wel echt al bestaat
      if v_bvalidity_loc_from = v_start_time_loc
      then
        open c_rst( b_process        => p_dfn_row.process
                  , b_bvalidity_from => v_bvalidity_loc_from);
        fetch c_rst
         into r_rst;

        if c_rst%found then
          v_bvalidity_loc_from              := sup_date_actions.add_interval_to_timestamp_tz(p_ts_tz       => v_bvalidity_loc_from
                                                                                            ,p_interval_ym => v_period_interval_year_to_month
                                                                                            ,p_interval_ds => v_period_interval_day_to_second);
        end if;

        close c_rst;
      end if;

      -- Bereken het einde van de te controleren bvalidity
      v_bvalidity_loc_to                    := sup_date_actions.add_interval_to_timestamp_tz(p_ts_tz       => v_bvalidity_loc_from
                                                                                            ,p_interval_ym => v_period_interval_year_to_month
                                                                                            ,p_interval_ds => v_period_interval_day_to_second);

      if p_dfn_row.bvalidity_to_expression is not null then
        v_bvalidity_loc_to := execute_expression( p_time      => v_first_checktime_loc
                                                , p_expr      => p_dfn_row.bvalidity_to_expression
                                                );
      end if;

      -- Vullen dqf_results-tabel met verwachtingen
      r_dqf_results                         := null;
      r_dqf_results.process                 := p_dfn_row.process;
      r_dqf_results.check_name              := p_dfn_row.check_name;
      r_dqf_results.id                      := null;
      r_dqf_results.dfn_id                  := p_dfn_row.id;

      -- Vertaal de tijd naar UTC. Omdat de sessie op lokaal staat doet Oracle wel de -1/-2 uur, maar blijft de timeszone nog steeds lokaal. Daarom keihard UTC
      -- toevoegen als timezone. De sessie op UTC zetten geeft wel een vertaling naar UTC, maar als je dan in de zomertijd een datum wil omzetten in januari, doet
      -- Oracle net alsof januari in de zomertijd valt, en dus -2 uur
      r_dqf_results.bvalidity_utc_from      := sup_date_actions.convertlocal2utc_ts( p_ts_tz => v_bvalidity_loc_from );
      r_dqf_results.bvalidity_utc_to        := sup_date_actions.convertlocal2utc_ts( p_ts_tz => v_bvalidity_loc_to   );

      -- ADP_09_TTN en TTG krijgen een lokale datum in de mrid, omdat de mrid met een volledige UTC-tijd te lang wordt
      if p_dfn_row.process in ('ADP_09_TTN', 'ADP_09_TTG') then
         tmn_utilities.get_mrid(p_publication          => rtrim(p_dfn_row.mrid_prefix, '_')
                               ,p_border_ara_code      => rtrim(p_dfn_row.mrid_suffix, '_') -- mrid_suffix bevat de borderarea
                               ,p_pbn_date_loc         => to_char(v_bvalidity_loc_from, p_dfn_row.mrid_suffix_format)
                               ,p_tmn_mrid             => r_dqf_results.mrid
                               ,p_tmn_next_version     => v_next_version -- doen we niks meer mee
                               );
      else
        if p_dfn_row.mrid_suffix_format is not null
        then
          -- Bepaal de mrid waar we op willen matchen
          tmn_utilities.get_mrid( p_mrid_prefix        => p_dfn_row.mrid_prefix
                                , p_mrid_suffix_format => p_dfn_row.mrid_suffix_format
                                , p_pbn_date           => case p_dfn_row.ind_local_bvalidity   -- b.v. EDP_51/52FCR hebben een lokale datum in de mrid

                                                            when 'N' then r_dqf_results.bvalidity_utc_from
                                                            when 'Y' then v_bvalidity_loc_from
                                                          end
                                , p_mrid_suffix        => p_dfn_row.mrid_suffix
                                , p_tmn_mrid           => r_dqf_results.mrid
                                );
        end if;
      end if;

      -- Die tijd wordt hier gecorrigeerd door de velden ".._correction" (als die negatief is wordt hij dus automatisch ervan afgetrokken)

      r_dqf_results.compliancy_deadline_utc := calculate_correction(p_checktime       => v_deadline_loc
                                                                   ,p_correction_expr => p_dfn_row.deadline_correction
                                                                   );
      r_dqf_results.first_checktime_utc     := calculate_correction(p_checktime       => v_first_checktime_loc
                                                                   ,p_correction_expr => p_dfn_row.first_check_correction
                                                                   );
      r_dqf_results.processing_time_utc     := calculate_correction(p_checktime       => v_processing_time_loc
                                                                   ,p_correction_expr => p_dfn_row.processing_time_correction
                                                                   ,p_exec_expr       => instr(p_dfn_row.processing_time_correction, 'interval') > 0
                                                                   );

      -- Zoek of er al een dqf_results record voor dit proces is met dezelfde bval en first_check_time. Dit is nodig omdat er
      -- meerdere publicaties met dezelfde bvalidity kunnen zijn
      dqf_rst_dml.get_row_uk(p_row => r_dqf_results);

      if r_dqf_results.id is null then
        -- Als niets gevonden is voor de zekerheid de max_version op 0 zetten (om te voorkomen dat we een vorige waarde hebben). Anders moet die ongewijzigd blijven.
        r_dqf_results.max_version           := 0;
      end if;

      dqf_rst_dml.dml_row(p_row => r_dqf_results);

      -- Zet de volgende start-time op de laatst berekende deadline
      v_start_time_loc                     := v_first_checktime_loc;

      -- Hou bij hoeveel records toegevoegd zijn. Leuk voor de statistieken...
      p_dates_count                        := p_dates_count + 1;
    end loop create_array;

    commit;

    -- Logging afsluiten
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End');

    sup_utilities.reset_session_timezone;

  exception
    when e_wrong_format then
      pcs_log_actions.log_error(p_module  => cn_module
                               ,p_text    => v_error
                                );
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;

  end fill_expectation_priv;
  --
  procedure check_accurate_priv (p_tmn_id    in pcs_tmn_transmissions.id%type
                                ,p_rst_id    in dqf_results.id%type)
  is
  /************************************************************************************************************************************
   Purpose:  Bepaal STATE_ACCURATE hier gebeurt het echte werk
  ************************************************************************************************************************************/
    cn_module                 constant varchar2(100) := cn_package || '.check_accurate_priv';

    cursor c_tmn(p_tmn_id in pcs_tmn_transmissions.id%type)
    is  with tse as
          (select tmn_id
                 ,coalesce(started_severity  , 'EMPTY') as started_severity
                 ,coalesce(created_severity  , 'EMPTY') as created_severity
                 ,coalesce(enqueued_severity , 'EMPTY') as enqueued_severity
                 ,coalesce(sent_severity     , 'EMPTY') as sent_severity
                 ,coalesce(delivered_severity, 'EMPTY') as delivered_severity
                 ,coalesce(approved_severity , 'EMPTY') as approved_severity
                 ,coalesce(rejected_severity , 'EMPTY') as rejected_severity
                 ,coalesce(duplicate_severity, 'EMPTY') as duplicate_severity
                 ,coalesce(sending_severity  , 'EMPTY') as sending_severity
                 ,coalesce(failed_severity   , 'EMPTY') as failed_severity
                 ,coalesce(accepted_severity , 'EMPTY') as accepted_severity
             from (select tse.tmn_id
                         ,tse.state
                         ,case when coalesce(pcs.max_severity, 'I') in ('E', 'F') then 'FALSE'
                               else                                                    'TRUE'
                          end as max_severity
                     from pcs_tmn_states tse
                     join pcs_processes  pcs on tse.pcs_id = pcs.id )
           pivot(max(max_severity) as severity
                 for(state) in ('STARTED'   as started
                               ,'CREATED'   as created
                               ,'ENQUEUED'  as enqueued
                               ,'SENT'      as sent
                               ,'DELIVERED' as delivered
                               ,'APPROVED'  as approved
                               ,'REJECTED'  as rejected
                               ,'DUPLICATE' as duplicate
                               ,'SENDING'   as sending
                               ,'FAILED'    as failed
                               ,'ACCEPTED'  as accepted)))
        select tmn.id                        as tmn_id
              ,tmn.pbn_id
              ,duplicate_severity
              ,greatest(started_severity
                       ,created_severity
                       ,enqueued_severity
                       ,sent_severity
                       ,delivered_severity
                       ,approved_severity
                       ,rejected_severity
                       ,duplicate_severity
                       ,sending_severity
                       ,failed_severity
                       ,accepted_severity) as state_accurate
          from pcs_tmn_transmissions tmn
          join tse                   tse on tse.tmn_id = tmn.id
         where tmn_id = p_tmn_id;

      cursor c_prv(p_rst_id             in dqf_results.id%type
                  ,p_bvalidity_utc_from in dqf_results.bvalidity_utc_from%type
                  ,p_check_name         in dqf_results.check_name%type)
      is select rst.state_accurate
           from dqf_results rst
          where rst.id = (select max(prv_rst.id)
                            from dqf_results prv_rst
                           where prv_rst.check_name         = p_check_name
                             and prv_rst.bvalidity_utc_from = p_bvalidity_utc_from
                            and prv_rst.id                 < p_rst_id
                         );

      e_no_input_parameters             exception;

      r_rst                             dqf_results%rowtype;
      r_tmn                             c_tmn%rowtype;
  begin
    if p_rst_id is null or p_tmn_id is null
    then
      raise e_no_input_parameters;
    end if;

    -- Haal het DQF record op
    select rst.*
      into r_rst
      from dqf_results rst
     where rst.id = p_rst_id;

     if coalesce(r_rst.state_accurate, 'UNKNOWN') <> 'TRUE'
     then
       -- TRUE is een eind status
       -- Nu de transmissie gegevens
       open c_tmn(p_tmn_id => p_tmn_id);

       fetch c_tmn
        into r_tmn;

       if c_tmn%found
       then
         r_rst.state_accurate := case
                                   when r_tmn.state_accurate = 'EMPTY' then 'UNKNOWN'
                                   else r_tmn.state_accurate
                                 end;

         if r_tmn.duplicate_severity <> 'EMPTY'
         then
           open c_prv(p_rst_id              => r_rst.id
                     ,p_bvalidity_utc_from  => r_rst.bvalidity_utc_from
                     ,p_check_name          => r_rst.check_name);
           fetch c_prv into r_rst.state_accurate;
           close c_prv;
         end if;
       end if;

       close c_tmn;

       -- Eenmaal TRUE, dan niet meer overschrijven
       update dqf_results
          set max_version       = nvl(r_rst.max_version, 0) + 1
            ,state_accurate     = r_rst.state_accurate
            ,tvalidity_utc_from = SYS_EXTRACT_UTC(SYSTIMESTAMP)
            ,tvalidity_loc_from = systimestamp
            ,tmn_id             = p_tmn_id
      where id = r_rst.id;
     end if;
  exception
    when e_no_input_parameters then
      null;
      --pcs_log_actions.log_error(p_module => cn_module
      --                         ,p_text   => 'No mandatory input parameters!');
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
  end check_accurate_priv;

  procedure check_accurate_multi(p_tmn_id    in pcs_tmn_transmissions.id%type
                                ,p_rst_id    in dqf_results.id%type)
  is
  /************************************************************************************************************************************
   Purpose:  Zet STATE_ACCURATE voor de publicaties waar de property DQF_RESULT_SINGLE_MATCH op N staat
  ************************************************************************************************************************************/
    cn_module                 constant varchar2(100) := cn_package || '.check_accurate_multi';

    cursor c_crt_rst (b_rst_id         in dqf_results.id%type)
      is with rst as
            (select rst.id
                   ,rst.bvalidity_utc_from
                   ,rst.bvalidity_utc_to
                   ,rst.mrid
                   ,dfn.pbn_id
                   ,dfn.match_on_mrid
                   ,cast (rst.processing_time_utc as date)                                                        as this_pcs_time
                   ,cast (lead (rst.processing_time_utc) over (partition by rst.check_name
                                                                   order by rst.bvalidity_utc_from  asc
                                                                           ,rst.processing_time_utc asc) as date) as next_pcs_time
               from dqf_results      rst
               join dqf_definitions  dfn on  dfn.check_name = rst.check_name
              where      rst.id              = b_rst_id
                and     dfn.ind_active_check = 'Y'
            )
      select coalesce(tmn_y.id, tmn_n.id)       as tmn_id
                     ,rst.id                    as rst_id
           from rst                              rst
           left outer join pcs_tmn_transmissions tmn_n on (    rst.match_on_mrid                 = 'N'
                                                           and rst.pbn_id                        = tmn_n.pbn_id
                                                           and tmn_n.bvalidity_utc_from          = rst.bvalidity_utc_from
                                                           and tmn_n.bvalidity_utc_to            = rst.bvalidity_utc_to
                                                           and cast(tmn_n.cre_date_utc as date)  between nvl(rst.this_pcs_time, cast (tmn_n.cre_date_utc as date))
                                                                                                     and nvl(rst.next_pcs_time, cast (tmn_n.cre_date_utc as date))
                                                          )
           left outer join pcs_tmn_transmissions tmn_y on (    rst.match_on_mrid                 = 'Y'
                                                           and tmn_y.mrid                        = rst.mrid
                                                           and cast(tmn_y.cre_date_utc as date)  between coalesce(rst.this_pcs_time, cast (tmn_y.cre_date_utc as date))
                                                                                                     and coalesce(rst.next_pcs_time, cast (tmn_y.cre_date_utc as date))
                                                          );

    cursor c_crt_tmn (b_tmn_id         in pcs_tmn_transmissions.id%type)
        is select tmn.id as tmn_id
                 ,rst.id as rst_id
             from (select rst.id
                         ,rst.check_name
                         ,rst.bvalidity_utc_to
                         ,rst.bvalidity_utc_from
                         ,rst.state_complete
                         ,rst.state_timely
                         ,cast(rst.processing_time_utc as date)                                                      as this_pcs_time
                         ,cast(lead(rst.processing_time_utc) over(partition by rst.check_name
                                                                      order by rst.bvalidity_utc_from asc
                                                                              ,rst.processing_time_utc asc) as date) as next_pcs_time
                     from dqf_results rst) rst
             join dqf_definitions       dfn on dfn.check_name              = rst.check_name
             join pcs_tmn_transmissions tmn on (    dfn.match_on_mrid      = 'N'
                                                and dfn.pbn_id             = tmn.pbn_id
                                                and rst.bvalidity_utc_from = tmn.bvalidity_utc_from
                                                and rst.bvalidity_utc_to   = tmn.bvalidity_utc_to
                                                and cast(tmn.cre_date_utc as date) between coalesce(rst.this_pcs_time, cast(tmn.cre_date_utc as date))
                                                                                       and coalesce(rst.next_pcs_time, cast(tmn.cre_date_utc as date)))
            where  tmn.id = b_tmn_id
              and  dfn.ind_active_check = 'Y'
            union all
            select tmn.id as tmn_id
                  ,rst.id as rst_id
              from (select rst.id
                          ,tmn.id as tmn_id
                          ,cast(rst.processing_time_utc as date)                                                      as this_pcs_time
                          ,cast(lead(rst.processing_time_utc) over(partition by rst.check_name
                                                                       order by rst.bvalidity_utc_from  asc
                                                                               ,rst.processing_time_utc asc) as date) as next_pcs_time
                      from dqf_results rst
                      join dqf_definitions dfn on dfn.check_name = rst.check_name
                      join pcs_tmn_transmissions tmn on rst.mrid = tmn.mrid
                     where     tmn.id                                = b_tmn_id
                       and     dfn.match_on_mrid                     = 'Y'
                       and     dfn.ind_active_check                  = 'Y') rst
              join pcs_tmn_transmissions tmn on (    rst.tmn_id                           = tmn.id
                                                 and cast(tmn.cre_date_utc as date) between coalesce(rst.this_pcs_time, cast(tmn.cre_date_utc as date))
                                                                                        and coalesce(rst.next_pcs_time, cast(tmn.cre_date_utc as date)));

    -- let op: wordt gebruikt voor beide cursoren!
    r_crt               c_crt_rst%rowtype;
  begin
    if g_default_log_level = 'T'
    or g_default_log_level = 'D' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'Start'
                                );
    end if;

    -- loop over resultaten uit cursor c_crt_tmn of c_crt_rst
    if p_tmn_id is not null then
       open c_crt_tmn(b_tmn_id  => p_tmn_id);

       fetch c_crt_tmn
         into r_crt;
    elsif p_rst_id is not null then
       open c_crt_rst(b_rst_id  => p_rst_id);

       fetch c_crt_rst
         into r_crt;
    end if;

    <<dqf_results_loop>>
    while (    c_crt_tmn%isopen
           and c_crt_tmn%found )
       or (    c_crt_rst%isopen
           and c_crt_rst%found )
    loop
       check_accurate_priv(p_rst_id => r_crt.rst_id
                          ,p_tmn_id => r_crt.tmn_id);
       if c_crt_tmn%isopen
       then
          fetch c_crt_tmn into r_crt;
       else
          fetch c_crt_rst into r_crt;
       end if;
    end loop dqf_results_loop;

    if c_crt_tmn%isopen then
       close c_crt_tmn;
    end if;

    if c_crt_rst%isopen then
       close c_crt_rst;
    end if;

    -- Logging afsluiten, alleen bij Tracing of Debug om idioot veel niets-zeggende logging te voorkomen
    if g_default_log_level = 'T'
    or g_default_log_level = 'D' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'End'
                                );
    end if;
  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      if c_crt_tmn%isopen then
         close c_crt_tmn;
      end if;

      if c_crt_rst%isopen then
         close c_crt_rst;
      end if;
  end check_accurate_multi;
  --
  procedure check_accurate(p_tmn_id    in pcs_tmn_transmissions.id%type
                          ,p_rst_id    in dqf_results.id%type)
  is
  /************************************************************************************************************************************
   Purpose:  Bepaal STATE_ACCURATE
  ************************************************************************************************************************************/
    v_rst_id        dqf_results.id%type;
    v_tmn_tab       apex_t_number;
    v_idx           pls_integer;
  begin
    if  p_tmn_id is not null
    and p_rst_id is not null
    then
      check_accurate_priv(p_tmn_id => p_tmn_id
                         ,p_rst_id => p_rst_id);
    elsif p_tmn_id is not null
    then
      v_rst_id := get_rst_id(p_tmn_id => p_tmn_id);
      if coalesce(v_rst_id, -1) <> -1
      then
        check_accurate_priv(p_tmn_id => p_tmn_id
                           ,p_rst_id => v_rst_id);
      else
        check_accurate_multi(p_tmn_id => p_tmn_id
                            ,p_rst_id => p_rst_id);
      end if;
    elsif p_rst_id is not null
    then
      v_tmn_tab := get_tmn_id(p_rst_id => p_rst_id);
      v_idx     := v_tmn_tab.last();

      if  v_idx is not null
      and v_tmn_tab(v_idx) <> -1
      then
        check_accurate_priv(p_tmn_id  => v_tmn_tab(v_idx)
                           ,p_rst_id  => p_rst_id);
      else
        check_accurate_multi(p_tmn_id => v_tmn_tab(v_idx)
                            ,p_rst_id => p_rst_id);
      end if;
    end if;
  end check_accurate;
  --
  procedure check_tmn_expectation_priv(p_tmn_id    in pcs_tmn_transmissions.id%type
                                      ,p_rst_id    in dqf_results.id%type)
  is
  /************************************************************************************************************************************
   Purpose:  Controleer de verwachtingen tegen de werkelijkheid
  ************************************************************************************************************************************/
    cn_module                 constant varchar2(100) := cn_package || '.check_tmn_expectation_priv';
    cn_process_tdw            constant varchar2(3)   := 'TDW';

    v_state_timely                    dqf_results.state_timely%type;
    v_state_complete                  dqf_results.state_complete%type;

    e_no_input_parameters             exception;

    cursor c_crt (b_rst_id         in dqf_results.id%type
                 ,b_tmn_id         in pcs_tmn_transmissions.id%type)
    is
      select tmn_id
            ,rst_id
            ,process
            ,check_name
            ,bvalidity_utc_from
            ,bvalidity_utc_to
            ,check_type
            ,max_version
            ,state_complete
            ,state_timely
            ,state_accurate
            ,compliancy_deadline_utc
            ,started
            ,created
            ,coalesce(enqueued , failed,sending) as enqueued  -- Webservice statussen failed en sending worden behandeld als enqueued. Bij een status failed is het bericht wel verstuurd, maar hebben we een lege respomnse header terug gekregen. Beetje dubieus of het klopt deze status als enqueued te zien
            ,sent
            ,coalesce(delivered, accepted      ) as delivered -- Webservice status accepted wordt behandeld als delivered
            ,coalesce(approved , accepted      ) as approved  -- Webservice status accepted wordt behandeld als approved
            ,rejected
            ,duplicate
       from (select rst.id                      as rst_id
                   ,rst.process
                   ,rst.check_name
                   ,rst.bvalidity_utc_from
                   ,rst.bvalidity_utc_to
                   ,dfn.check_type
                   ,rst.max_version
                   ,rst.state_complete
                   ,rst.state_timely
                   ,rst.state_accurate
                   ,rst.compliancy_deadline_utc
                   ,tmn.id                      as tmn_id
                   ,tse.state                   as tse_state
                   ,tse.tvalidity_utc_from      as tse_tvalidity_utc_from
               from delphidba.dqf_results                rst
               join delphidba.dqf_definitions            dfn on dfn.check_name = rst.check_name
              cross join delphidba.pcs_tmn_transmissions tmn
               join delphidba.pcs_tmn_states             tse on tse.tmn_id     = tmn.id
              where tmn.id = b_tmn_id
                and rst.id = b_rst_id)
              pivot(min(tse_tvalidity_utc_from) -- een aggregate-functie is nodig voor de PIVOT, doet verder eigenlijk niks
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

    r_crt               c_crt%rowtype;

    cursor c_prov_rst(b_process             dqf_results.process%type
                     ,b_bvalidity_utc_from  timestamp
                     ,b_bvalidity_utc_to    timestamp)
    is
      select rst.id
            ,rst.state_complete
        from dqf_results rst
       where rst.process            = b_process
         and rst.bvalidity_utc_from = b_bvalidity_utc_from
         and rst.bvalidity_utc_to   = b_bvalidity_utc_to;

    r_prov_rst               c_prov_rst%rowtype;

   -- Cursor om in geval van data-driven publicaties de reception mee te nemen in de timely controle
   cursor c_rcn(b_tmn_id     in pcs_tmn_transmissions.id%type)
       is select rcn_id
               , reception_id
               , bvalidity_utc_from
               , bvalidity_utc_to
               , started          as started
               , supplied         as supplied
               , received         as received
               , saved            as saved
               , downloaded       as downloaded
               , download_error   as download_error
               , invalid_doc      as invalid_doc
          from (select r.id as rcn_id
                     , r.reception_id
                     , r.bvalidity_utc_from
                     , r.bvalidity_utc_to
                     , rs.state
                     , rs.tvalidity_utc_from
                  from delphidba.pcs_rcn_receptions           r
                  join delphidba.pcs_receptions_transmissions rt on (rt.rcn_id = r.id)
                  join delphidba.pcs_rcn_states               rs on (rs.rcn_id = r.id)
                 where rt.tmn_id = b_tmn_id
               )
          pivot (min(tvalidity_utc_from)
                 for state in ('STARTED'            as started
                              ,'SUPPLIED'           as supplied
                              ,'RECEIVED'           as received
                              ,'SAVED'              as saved
                              ,'MESSAGE_DOWNLOADED' as downloaded
                              ,'DOWNLOAD_ERROR'     as download_error
                              ,'INVALID_DOCUMENT'   as invalid_doc
                              )
                );
    r_rcn c_rcn%rowtype;

    -- Zoek het laatste dqf_result-record voor dit proces/bvalidity. Dit in in geval van een DUPLICATE, dan moeten we de status
    -- van het vorige results-record overnemen. Als die op tijd was en we hebben een DUPLICATE, dan was et duplicaat ook op tijd.
    -- Er is immers niets te updaten, dus hoeven we niks te versturen
    cursor c_last_rst (b_process            in varchar2
                      ,b_bvalidity_utc_from in timestamp)
        is select *
             from dqf_results
            where id in (select max(id)
                           from dqf_results
                          where process            = b_process
                            and bvalidity_utc_from = b_bvalidity_utc_from
                            and state_complete     is not null);

    r_last_rst            c_last_rst%rowtype;

  begin
    -- Logging, alleen bij Tracing of Debug om idioot veel niets-zeggende logging te voorkomen
    if g_default_log_level = 'T'
    or g_default_log_level = 'D' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'Start'                  || chr(10)
                                          || 'p_tmn_id: ' || p_tmn_id || chr(10)
                                          || 'p_rst_id: ' || p_rst_id || chr(10)
                                );
    end if;

    -- Haal de gegevens op
    if  p_tmn_id is not null
    and p_rst_id is not null
    then
       open c_crt(b_rst_id  => p_rst_id
                 ,b_tmn_id  => p_tmn_id);
       fetch c_crt
        into r_crt;
    elsif p_rst_id is not null
    then
       -- Dan is er wel een dqf_result-record, maar geen transmissie
       update dqf_results drt
          set drt.max_version        = nvl(r_crt.max_version, 0) + 1
             ,drt.state_accurate     = case drt.state_accurate
                                         when sup_constants.cn_true then sup_constants.cn_true
                                         else                            sup_constants.cn_unknown
                                       end
             ,drt.state_complete     = sup_constants.cn_false
             ,drt.state_timely       = sup_constants.cn_false
             ,drt.tvalidity_utc_from = SYS_EXTRACT_UTC(SYSTIMESTAMP)
             ,drt.tvalidity_loc_from = systimestamp
        where drt.id                      = p_rst_id
          and drt.compliancy_deadline_utc < SYS_EXTRACT_UTC(SYSTIMESTAMP);
    else
       raise e_no_input_parameters;
    end if;

    -- Alleen result records die nog niet "af" zijn behandelen
    if  c_crt%isopen
    and c_crt%found
    and coalesce(r_crt.state_complete, sup_constants.cn_unknown) <> sup_constants.cn_true
    and coalesce(r_crt.state_timely  , sup_constants.cn_unknown) <> sup_constants.cn_true
    then
       v_state_timely          := null;
       v_state_complete        := null;

       -- Als we een status DUPLICATE vinden is er geen bericht verstuurd. In dat geval zoeken we het laatste dqf_result-record voor dit proces/bvalidity
       if r_crt.duplicate is not null then
          open c_last_rst(b_process            => r_crt.process
                         ,b_bvalidity_utc_from => r_crt.bvalidity_utc_from);
          fetch c_last_rst
           into r_last_rst;

          if  c_last_rst%notfound
          and r_crt.process like '%FINAL' then
             -- Geen eerder resultaat gevonden. Dat kan omdat we te maken hebben met een FINAL die de PROVISIONAL zou uopdaten. Als de FINAL echter een DUPLICATE
             -- is, is er geen publicatie de deur uitgegaan. In dat geval moeten we de status van de provisional overnemen in de final
             close c_last_rst;

             -- Zoek het result-record van de povisional
             open c_last_rst(b_process            => replace(r_crt.process, 'FINAL', 'PROVISIONAL')
                            ,b_bvalidity_utc_from => r_crt.bvalidity_utc_from);
             fetch c_last_rst
              into r_last_rst;
          end if;

          if c_last_rst%found then
             if r_last_rst.id = r_crt.rst_id then
                -- Als het ID hetzelfde is doen we niks aan de status die is immers al gezet
                null;
             else
                -- Als het dqf_result-id afwijkt van het net gevonden record, dan nemen we het resultaat over. Als de originele op tijd was (of niet), geldt dat ook voor het
                -- duplicaat-record.
                update dqf_results
                   set state_timely    = r_last_rst.state_timely
                      ,state_complete  = r_last_rst.state_complete
                      ,state_accurate  = r_last_rst.state_accurate
                      ,max_version     = max_version + 1
                      ,tmn_id          = p_tmn_id
                 where id = r_crt.rst_id;
             end if;
          else
            -- Als we nu nog geen eerder record gevonden hebben is dat een foutsituatie. Dit zou naar verwachting niet voor moeten komen, omdat het (naar verwachting)
            -- alleen bij PROVISIONAL/FINALs kan gebeuren.
            pcs_log_actions.log_error(p_module => cn_module
                                     ,p_text   => 'Transmission for process '
                                               || r_crt.process
                                               || '  with bvalidity_utc_from '
                                               || to_char(r_crt.bvalidity_utc_from,' dd-mm-yyyy hh24:mi')
                                               || ' found with status DUPLICATE, but no earlier checked dqf_results-record found for this combination!');
          end if;

          if c_last_rst%isopen then
             close c_last_rst;
          end if;
       else
          -- Timely is true als op tijd een DELIVERED is ontvangen; uitzondering voor TDW's (zie TRAN-4535)
          -- Soms ontvangen we geen delivered, als dan op tijd een APPROVED is ontvangen is de transmissie ook op tijd.
          -- Complete is true als ooit APPROVED
          if  r_crt.rejected is not null
          and r_crt.approved is null then
             -- een TDW, rejected voor de deadline -> state_timely en state_complete zijn UNKNOWN
             if substr(r_crt.process, 1, 4) = 'TDW_'
             then
               if cast(r_crt.rejected as date) <= cast(r_crt.compliancy_deadline_utc as date)
               then
                 v_state_complete             := sup_constants.cn_unknown;
                 v_state_timely               := sup_constants.cn_unknown;
               else
                 v_state_complete             := sup_constants.cn_false;
                 v_state_timely               := sup_constants.cn_false;
               end if;
             else
               if r_crt.compliancy_deadline_utc >= SYS_EXTRACT_UTC(SYSTIMESTAMP) then
                  -- REJECTED, maar de compliancy_deadline_utc is nog niet voorbij
                  -- het kan dus nog goedkomen met een volgend bericht
                  v_state_complete             := sup_constants.cn_false;
                  v_state_timely               := sup_constants.cn_unknown;
               else
                 -- REJECTED en de compliancy_deadline_utc is ook voorbij
                 -- het kan niet meer goed komen -> state_timely en state_complete zijn FALSE
                  v_state_complete             := sup_constants.cn_false;
                  v_state_timely               := sup_constants.cn_false;
               end if;
             end if;
          else
             if  r_crt.rejected is null
             and r_crt.approved is null
             and r_crt.delivered is null
             and r_crt.compliancy_deadline_utc < SYS_EXTRACT_UTC(SYSTIMESTAMP) then
                  -- We hebben niets op de queue gezet en de deadline is verstreken
                  v_state_complete           := sup_constants.cn_false;
                  v_state_timely             := sup_constants.cn_false;
             elsif cast(r_crt.approved as date) <= cast(r_crt.compliancy_deadline_utc as date)
             then
                  -- Bericht is op tijd approved, dan is niet meer belangrijk wat de tijd van status delivered was: bericht was tijdig en compleet
                  v_state_complete           := sup_constants.cn_true;
                  v_state_timely             := sup_constants.cn_true;
             elsif r_crt.delivered is null
               and cast(r_crt.approved as date) > cast(r_crt.compliancy_deadline_utc as date)
             then
                  if upper(substr(r_crt.process,1,3)) = cn_process_tdw
                  and cast(r_crt.enqueued as date) > cast(r_crt.compliancy_deadline_utc as date)
                  then
                      -- (TDW) Hij is approved, na de deadline, delivered hebben we niet (nooit voor TDW)
                      --       en enqueued was niet op tijd: bericht is compleet, state_timely is UNKNOWN
                      v_state_complete           := sup_constants.cn_true;
                      v_state_timely             := sup_constants.cn_unknown;
                  else
                      -- (GEEN TDW) Hij is approved, na de deadline, maar delivered hebben we niet, we weten dan nog niet zeker of hij op tijd was.
                      v_state_complete           := sup_constants.cn_true;
                      v_state_timely             := sup_constants.cn_unknown;
                  end if;
             elsif r_crt.delivered              >  r_crt.approved
               and cast(r_crt.approved as date) > cast(r_crt.compliancy_deadline_utc as date)
             then
                  -- Als status approved is te laat ontvangen en hij was te laat verstuurd
                  v_state_complete           := sup_constants.cn_true;
                  v_state_timely             := sup_constants.cn_false;
             elsif cast(r_crt.delivered as date) <= cast(r_crt.compliancy_deadline_utc as date)
               and cast(r_crt.approved as date)   > cast(r_crt.compliancy_deadline_utc as date)
             then
                   -- Te laat approved
                  v_state_complete           := sup_constants.cn_true;
                  v_state_timely             := sup_constants.cn_true;
             elsif cast(r_crt.delivered as date) > cast(r_crt.compliancy_deadline_utc as date)
             then
                  -- Als de status SENT (delivered) te laat was zijn we niet tijdig.
                  v_state_timely             := sup_constants.cn_false;

                  -- Als de publicatie data-driven is verstuurd en de reception was niet op tijd binnen
                  -- maar we hebben de publicatie wel direct daarna verstuurd, dan wordt dat toch als op tijd beschouwd.
                  -- (want is niet onze schuld)
                  if r_crt.check_type = 'DATA'
                  then
                    open c_rcn(p_tmn_id);
                    fetch c_rcn into r_rcn;
                    close c_rcn;
                    if  r_rcn.received               is not null
                    and cast(r_rcn.received as date)  > cast(r_crt.compliancy_deadline_utc as date)
                    and cast(r_rcn.received as date)  < cast(r_crt.started                 as date)
                    then
                      v_state_timely             := sup_constants.cn_true;
                    end if;
                  end if;

                  -- Hij kan te laat, maar wel compleet geweest zijn
                  if r_crt.approved is not null then
                     v_state_complete        := sup_constants.cn_true;
                  else
                     -- Approved null, dan weten we het niet. Hij kan rejected zijn, maar dat staat hier boven al
                     v_state_complete        := sup_constants.cn_unknown;
                  end if;
             else
                  v_state_complete           := sup_constants.cn_unknown;
                  v_state_timely             := sup_constants.cn_unknown;
            end if;
          end if;

          -- Eenmaal TRUE, dan niet meer overschrijven
          update dqf_results
             set max_version        = nvl(r_crt.max_version, 0) + 1
                ,state_timely       = case state_timely
                                        when sup_constants.cn_true then
                                          sup_constants.cn_true
                                        else
                                          v_state_timely
                                      end
                ,state_complete     = case state_complete
                                        when sup_constants.cn_true then
                                          sup_constants.cn_true
                                        else
                                          v_state_complete
                                      end
                ,tvalidity_utc_from = SYS_EXTRACT_UTC(SYSTIMESTAMP)
                ,tvalidity_loc_from = systimestamp
                ,tmn_id             = p_tmn_id
          where id = r_crt.rst_id;

          check_accurate_priv(p_rst_id => r_crt.rst_id
                             ,p_tmn_id => r_crt.tmn_id);

          if r_crt.process like '%FINAL' then
             -- Zoek naar de Provisional publicatie met zelfde mrid
             open c_prov_rst (b_process            => replace(r_crt.process, 'FINAL', 'PROVISIONAL')
                             ,b_bvalidity_utc_from => r_crt.bvalidity_utc_from
                             ,b_bvalidity_utc_to   => r_crt.bvalidity_utc_to);

             fetch c_prov_rst
              into r_prov_rst;

             -- Als de provisional-versie niet COMPLETE was en de final wel, dan moet de dqf van de provisional nog bijgewerkt worden
             -- Alleen status complete werken we bij, timely mag niet bijgewerkt worden
             if  r_prov_rst.state_complete != 'TRUE'
             and v_state_complete           = 'TRUE' then
                 update dqf_results rst
                    set rst.state_complete     = 'TRUE'
                       ,rst.tvalidity_loc_from = systimestamp
                       ,rst.tvalidity_utc_from = SYS_EXTRACT_UTC(SYSTIMESTAMP)
                       ,lamu_pcs_id            = sup_globals.get_global_number(p_name => 'PROCESS_ID')
                       ,tmn_id                 = p_tmn_id
                  where rst.id = r_prov_rst.id;
             end if;

             close c_prov_rst;
          end if;
       end if;
    end if;

    if c_crt%isopen then
       close c_crt;
    end if;

    -- Logging afsluiten, alleen bij Tracing of Debug om idioot veel niets-zeggende logging te voorkomen
    if g_default_log_level = 'T'
    or g_default_log_level = 'D' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'End'
                                );
    end if;
  exception
    when e_no_input_parameters then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'No mandatory input parameters!');
      if c_crt%isopen then
         close c_crt;
      end if;
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      if c_crt%isopen then
         close c_crt;
      end if;

  end check_tmn_expectation_priv;
  --
  procedure check_multi_expectation(p_tmn_id    in pcs_tmn_transmissions.id%type
                                   ,p_rst_id    in dqf_results.id%type)
  is
  /************************************************************************************************************************************
   Purpose:  Controleer de verwachtingen tegen de werkelijkheid voor de publicaties waar de property DQF_RESULT_SINGLE_MATCH op N staat
  ************************************************************************************************************************************/
    cn_module                 constant varchar2(100) := cn_package || '.check_multi_expectation';

    e_no_input_parameters             exception;

    cursor c_crt_rst (b_rst_id         in dqf_results.id%type)
        is with rst as
              (select rst.id
                     ,rst.bvalidity_utc_from
                     ,rst.bvalidity_utc_to
                     ,rst.mrid
                     ,dfn.pbn_id
                     ,dfn.match_on_mrid
                     ,cast (rst.processing_time_utc as date)                                                        as this_pcs_time
                     ,cast (lead (rst.processing_time_utc) over (partition by rst.check_name
                                                                     order by rst.bvalidity_utc_from  asc
                                                                             ,rst.processing_time_utc asc) as date) as next_pcs_time
                 from dqf_results      rst
                 join dqf_definitions  dfn on  dfn.check_name = rst.check_name
                where      rst.id              = b_rst_id
                  and     dfn.ind_active_check = 'Y'
                  and (   rst.state_complete                                is null
                       or rst.state_complete                                != sup_constants.cn_true
                       or nvl(rst.state_timely  , sup_constants.cn_unknown)  = sup_constants.cn_unknown
                      )
              )
        select coalesce(tmn_y.id, tmn_n.id)       as tmn_id
                       ,rst.id                    as rst_id
             from rst                              rst
             left outer join pcs_tmn_transmissions tmn_n on (    rst.match_on_mrid                 = 'N'
                                                             and rst.pbn_id                        = tmn_n.pbn_id
                                                             and tmn_n.bvalidity_utc_from          = rst.bvalidity_utc_from
                                                             and tmn_n.bvalidity_utc_to            = rst.bvalidity_utc_to
                                                             and cast(tmn_n.cre_date_utc as date)  between nvl(rst.this_pcs_time, cast (tmn_n.cre_date_utc as date))
                                                                                                       and nvl(rst.next_pcs_time, cast (tmn_n.cre_date_utc as date))
                                                            )
             left outer join pcs_tmn_transmissions tmn_y on (    rst.match_on_mrid                 = 'Y'
                                                             and tmn_y.mrid                        = rst.mrid
                                                             and cast(tmn_y.cre_date_utc as date)  between coalesce(rst.this_pcs_time, cast (tmn_y.cre_date_utc as date))
                                                                                                       and coalesce(rst.next_pcs_time, cast (tmn_y.cre_date_utc as date))
                                                            );

    cursor c_crt_tmn (b_tmn_id         in pcs_tmn_transmissions.id%type)
        is select tmn.id as tmn_id
                 ,rst.id as rst_id
             from (select rst.id
                         ,rst.check_name
                         ,rst.bvalidity_utc_to
                         ,rst.bvalidity_utc_from
                         ,rst.state_complete
                         ,rst.state_timely
                         ,cast(rst.processing_time_utc as date)                                                      as this_pcs_time
                         ,cast(lead(rst.processing_time_utc) over(partition by rst.check_name
                                                                      order by rst.bvalidity_utc_from asc
                                                                              ,rst.processing_time_utc asc) as date) as next_pcs_time
                     from dqf_results rst) rst
             join dqf_definitions       dfn on dfn.check_name              = rst.check_name
             join pcs_tmn_transmissions tmn on (    dfn.match_on_mrid      = 'N'
                                                and dfn.pbn_id             = tmn.pbn_id
                                                and rst.bvalidity_utc_from = tmn.bvalidity_utc_from
                                                and rst.bvalidity_utc_to   = tmn.bvalidity_utc_to
                                                and cast(tmn.cre_date_utc as date) between coalesce(rst.this_pcs_time, cast(tmn.cre_date_utc as date))
                                                                                       and coalesce(rst.next_pcs_time, cast(tmn.cre_date_utc as date)))
            where  tmn.id = b_tmn_id
              and  dfn.ind_active_check = 'Y'
              and (   rst.state_complete                   is null
                   or rst.state_complete                   != 'TRUE'
                   or coalesce(rst.state_timely,'UNKNOWN')  = 'UNKNOWN')
            union all
            select tmn.id as tmn_id
                  ,rst.id as rst_id
              from (select rst.id
                          ,tmn.id as tmn_id
                          ,cast(rst.processing_time_utc as date)                                                      as this_pcs_time
                          ,cast(lead(rst.processing_time_utc) over(partition by rst.check_name
                                                                       order by rst.bvalidity_utc_from  asc
                                                                               ,rst.processing_time_utc asc) as date) as next_pcs_time
                      from dqf_results rst
                      join dqf_definitions dfn on dfn.check_name = rst.check_name
                      join pcs_tmn_transmissions tmn on rst.mrid = tmn.mrid
                     where     tmn.id                                = b_tmn_id
                       and     dfn.match_on_mrid                     = 'Y'
                       and     dfn.ind_active_check                  = 'Y'
                       and (   rst.state_complete                   is null
                            or rst.state_complete                   != 'TRUE'
                            or coalesce(rst.state_timely,'UNKNOWN')  = 'UNKNOWN')) rst
              join pcs_tmn_transmissions tmn on (    rst.tmn_id                           = tmn.id
                                                 and cast(tmn.cre_date_utc as date) between coalesce(rst.this_pcs_time, cast(tmn.cre_date_utc as date))
                                                                                        and coalesce(rst.next_pcs_time, cast(tmn.cre_date_utc as date)));

    -- let op: wordt gebruikt voor beide cursoren!
    r_crt               c_crt_rst%rowtype;
  begin
    -- Logging, alleen bij Tracing of Debug om idioot veel niets-zeggende logging te voorkomen
    if g_default_log_level = 'T'
    or g_default_log_level = 'D' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'Start'
                                );
    end if;

    -- loop over resultaten uit cursor c_crt_tmn of c_crt_rst
    if p_tmn_id is not null then
       open c_crt_tmn(b_tmn_id  => p_tmn_id);

       fetch c_crt_tmn
         into r_crt;
    elsif p_rst_id is not null then
       open c_crt_rst(b_rst_id  => p_rst_id);

       fetch c_crt_rst
         into r_crt;
    else
       raise e_no_input_parameters;
    end if;

    <<dqf_results_loop>>
    while (    c_crt_tmn%isopen
           and c_crt_tmn%found )
       or (    c_crt_rst%isopen
           and c_crt_rst%found )
    loop
       check_tmn_expectation_priv(p_rst_id => r_crt.rst_id
                                 ,p_tmn_id => r_crt.tmn_id);
       if c_crt_tmn%isopen
       then
          fetch c_crt_tmn into r_crt;
       else
          fetch c_crt_rst into r_crt;
       end if;
    end loop dqf_results_loop;

    if c_crt_tmn%isopen then
       close c_crt_tmn;
    end if;

    if c_crt_rst%isopen then
       close c_crt_rst;
    end if;

    -- Logging afsluiten, alleen bij Tracing of Debug om idioot veel niets-zeggende logging te voorkomen
    if g_default_log_level = 'T'
    or g_default_log_level = 'D' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'End'
                                );
    end if;
  exception
    when e_no_input_parameters then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'No mandatory input parameters!');
      if c_crt_tmn%isopen then
         close c_crt_tmn;
      end if;

      if c_crt_rst%isopen then
         close c_crt_rst;
      end if;
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      if c_crt_tmn%isopen then
         close c_crt_tmn;
      end if;

      if c_crt_rst%isopen then
         close c_crt_rst;
      end if;

  end check_multi_expectation;

  procedure fill_expectation_for_pbn_date
           (p_dfn_row          in out nocopy t_dfn_row
           ,p_pbn_date_utc     in            timestamp default null)
  is
  /************************************************************************************************************************************
   Purpose:  Vul de verwachtingsrecords van de opgegeven dqf-controle
             Let op! We moeten alles in lokale tijd berekenen en pas net voor het opslaan naar UTC gaan!
             private procedure aangeroepen vanuit
             fill_expectations
             fill_single_expectation
             fill_single_expectation_for_date
  ************************************************************************************************************************************/
    cn_module                 constant varchar2(100) := cn_package || '.fill_expectation_for_pbn_date';
    -- variabelen Timstamps met 0 fractionele secondes, anders kan dat rare dingen geven
    v_bvalidity_loc_from               timestamp;
    v_bvalidity_loc_to                 timestamp;
    v_deadline_loc                     timestamp;
    v_first_checktime_loc              timestamp;

    v_period_interval_year_to_month    interval year to month;
    v_period_interval_day_to_second    interval day  to second;

    r_dqf_results                      dqf_results%rowtype;

    v_error                            varchar2(2000);
    v_next_version                     number(10);

    -- exceptions
    e_wrong_format exception;
    e_date_dst_error exception;
    pragma exception_init(e_date_dst_error, -01878);

  begin
    -- Logging
    pcs_log_actions.log_trace( p_module => cn_module
                             , p_text   => 'Start' || chr(10)
                                        || 'check_name        : ' || p_dfn_row.check_name   || chr(10)
                                        || 'p_pbn_date_utc    : ' || p_pbn_date_utc     || chr(10)
                             );

    sup_globals.set_global( p_name  => 'PROCESS'
                          , p_value => p_dfn_row.process);

    -- deadline_after_bval_from en period_interval moeten het formaat interval day to second hebben, period_interval_year_to_month moet formaat interval year to month
    -- hebben
    if (    p_dfn_row.deadline_after_bval_from is not null
        and regexp_instr(p_dfn_row.deadline_after_bval_from     , '\-?\d+ \d{2}:\d{2}:\d{2}') != 1
       )
    or (    p_dfn_row.period_interval_day_to_second is not null
        and regexp_instr(p_dfn_row.period_interval_day_to_second, '\-?\d+ \d{2}:\d{2}:\d{2}') != 1
       )
    or (    p_dfn_row.period_interval_year_to_month is not null
        and regexp_instr(p_dfn_row.period_interval_year_to_month, '\-?(\d{1,2}-\d{1,2}$)')    != 1
       )
--    or (    p_dfn_row.processing_time_correction is not null
--        and regexp_instr(p_dfn_row.processing_time_correction      , '\-?(\d{1,2}-\d{1,2}$)')    != 1
--       )
    then
      v_error := 'WRONG FORMAT'
              ||chr(10)||' process                            : ' || p_dfn_row.process
              ||chr(10)||' r_dfn.deadline_after_bval_from     : ' || p_dfn_row.deadline_after_bval_from
              ||chr(10)||' r_dfn.period_interval_day_to_second: ' || p_dfn_row.period_interval_day_to_second
              ||chr(10)||' r_dfn.period_interval_year_to_month: ' || p_dfn_row.period_interval_year_to_month
--              ||chr(10)||' r_dfn.processing_time_correction  : ' || p_dfn_row.processing_time_correction
              ;
      raise e_wrong_format;
    else
      v_period_interval_year_to_month         := nvl( to_yminterval(p_dfn_row.period_interval_year_to_month)
                                                    , interval '0' month);
      v_period_interval_day_to_second         := nvl( to_dsinterval(p_dfn_row.period_interval_day_to_second)
                                                    , interval '0' second);
    end if;

    v_bvalidity_loc_from := sup_date_actions.convertutc2local(p_utc_date => p_pbn_date_utc);
    -- Bereken het einde van de te controleren bvalidity
    if p_dfn_row.bvalidity_to_expression is not null then
       v_bvalidity_loc_to                     := execute_expression(p_time      => v_bvalidity_loc_from
                                                                   ,p_expr      => p_dfn_row.bvalidity_to_expression
                                                                   );
    else
       v_bvalidity_loc_to                     := sup_date_actions.add_interval_to_timestamp_tz(p_ts_tz       => v_bvalidity_loc_from
                                                                                            ,p_interval_ym => v_period_interval_year_to_month
                                                                                            ,p_interval_ds => v_period_interval_day_to_second);
    end if;

    v_deadline_loc                            := execute_expression(p_time      => v_bvalidity_loc_from
                                                                   ,p_expr      => p_dfn_row.deadline_expression
                                                                   );

    v_first_checktime_loc                     := execute_expression(p_time      => v_bvalidity_loc_from
                                                                   ,p_expr      => p_dfn_row.first_check_expression
                                                                   );

    -- Vullen dqf_results-tabel met verwachtingen
    r_dqf_results                         := null;
    r_dqf_results.process                 := p_dfn_row.process;
    r_dqf_results.check_name              := p_dfn_row.check_name;
    r_dqf_results.id                      := null;
    r_dqf_results.dfn_id                  := p_dfn_row.id;

    -- Vertaal de tijd naar UTC. Omdat de sessie op lokaal staat doet Oracle wel de -1/-2 uur, maar blijft de timeszone nog steeds lokaal. Daarom keihard UTC
    -- toevoegen als timezone. De sessie op UTC zetten geeft wel een vertaling naar UTC, maar als je dan in de zomertijd een datum wil omzetten in januari, doet
    -- Oracle net alsof januari in de zomertijd valt, en dus -2 uur
    r_dqf_results.bvalidity_utc_from      := sup_date_actions.convertlocal2utc_ts( p_ts_tz => v_bvalidity_loc_from );
    r_dqf_results.bvalidity_utc_to        := sup_date_actions.convertlocal2utc_ts( p_ts_tz => v_bvalidity_loc_to   );

      -- ADP_09_TTN en TTG krijgen een lokale datum in de mrid, omdat de mrid met een volledige UTC-tijd te lang wordt
      if p_dfn_row.process in ('ADP_09_TTN', 'ADP_09_TTG') then
         tmn_utilities.get_mrid(p_publication          => rtrim(p_dfn_row.mrid_prefix, '_')
                               ,p_border_ara_code      => rtrim(p_dfn_row.mrid_suffix, '_') -- mrid_suffix bevat de borderarea
                               ,p_pbn_date_loc         => to_char(v_bvalidity_loc_from, p_dfn_row.mrid_suffix_format)
                               ,p_tmn_mrid             => r_dqf_results.mrid
                               ,p_tmn_next_version     => v_next_version -- doen we niks meer mee
                               );
      else
        if p_dfn_row.mrid_suffix_format is not null
        then
          -- Bepaal de mrid waar we op willen matchen
          tmn_utilities.get_mrid( p_mrid_prefix        => p_dfn_row.mrid_prefix
                                , p_mrid_suffix_format => p_dfn_row.mrid_suffix_format
                                , p_pbn_date           => case p_dfn_row.ind_local_bvalidity   -- b.v. EDP_51/52FCR hebben een lokale datum in de mrid
                                                            when 'N' then r_dqf_results.bvalidity_utc_from
                                                            when 'Y' then v_bvalidity_loc_from
                                                          end
                                , p_mrid_suffix        => p_dfn_row.mrid_suffix
                                , p_tmn_mrid           => r_dqf_results.mrid
                                );
        end if;
      end if;

    -- Die tijd wordt hier gecorrigeerd door de velden ".._correction" (als die negatief is wordt hij dus automatisch ervan afgetrokken)

    r_dqf_results.compliancy_deadline_utc := calculate_correction(p_checktime       => v_deadline_loc
                                                                 ,p_correction_expr => p_dfn_row.deadline_correction
                                                                 );
    r_dqf_results.first_checktime_utc     := calculate_correction(p_checktime       => v_first_checktime_loc
                                                                 ,p_correction_expr => p_dfn_row.first_check_correction
                                                                  );

    -- Zoek of er al een dqf_results record voor dit proces is met dezelfde bval en first_check_time. Dit is nodig omdat er
    -- meerdere publicaties met dezelfde bvalidity kunnen zijn
    dqf_rst_dml.get_row_uk(p_row => r_dqf_results);

    if r_dqf_results.id is null then
      -- Als niets gevonden is voor de zekerheid de max_version op 0 zetten (om te voorkomen dat we een vorige waarde hebben). Anders moet die ongewijzigd blijven.
      r_dqf_results.max_version           := 0;
    end if;

    dqf_rst_dml.dml_row(p_row => r_dqf_results);

    commit;

    -- Logging afsluiten
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End');

    sup_utilities.reset_session_timezone;

    pcs_pcs_actions.end_process;

  exception
    when e_wrong_format then
      pcs_log_actions.log_error(p_module  => cn_module
                               ,p_text    => v_error
                                );
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;

  end fill_expectation_for_pbn_date;

  procedure fill_expectation_data
           ( p_process                 in varchar2
           , p_bvalidity_utc_from      in timestamp
           , p_bvalidity_utc_to        in timestamp
           , p_mrid                    in varchar2
           , p_check_name              in varchar2
           , p_check_time              in timestamp
           , p_deadline_input          in timestamp
           , p_processing_time_utc     in timestamp
           )
  is
  /************************************************************************************************************************************
   Purpose:  Vul het verwachtingsrecord voor de aangegeven data driven transmissie
             Wordt aangeroepen vauit het tmn package na het schedulen van de job.
  ************************************************************************************************************************************/
    cn_module                 constant varchar2(100) := cn_package || '.fill_expectation_data';

    cursor c_dfn
      (b_check_name in varchar2
      )
    is
    select dfn.id dfn_id
          ,dfn.deadline_expression
          ,dfn.first_check_expression
      from dqf_definitions dfn
     where dfn.check_name              = b_check_name
       and dfn.ind_active_check        = 'Y'
       and dfn.deadline_expression    is not null
       and dfn.first_check_expression is not null;

    v_dqf_row                          dqf_results%rowtype;
    r_dfn                              c_dfn%rowtype;

    v_compliancy_deadline_utc          dqf_results.compliancy_deadline_utc%type;
    v_first_checktime_utc              dqf_results.first_checktime_utc%type;

  begin
    pcs_log_actions.log_trace( p_module => cn_module
                             , p_text   => 'Start' || chr(10)
                                        || 'p_process           : ' || p_process                                   || chr(10)
                                        || 'p_bvalidity_utc_from: ' || to_char(p_bvalidity_utc_from, cn_ts_format) || chr(10)
                                        || 'p_bvalidity_utc_to  : ' || to_char(p_bvalidity_utc_to, cn_ts_format)   || chr(10)
                                        || 'p_mrid              : ' || p_mrid                                      || chr(10)
                                        || 'p_check_name        : ' || p_check_name                                || chr(10)
                                        || 'p_check_time        : ' || to_char(p_check_time, cn_ts_format)         || chr(10)
                                        || 'p_deadline_input    : ' || to_char(p_deadline_input, cn_ts_format)     || chr(10)
                             );
    open c_dfn(b_check_name => p_check_name);
    fetch c_dfn into r_dfn;
    if c_dfn%found then
      v_compliancy_deadline_utc         := sup_date_actions.convertlocal2utc_ts(p_ts_tz => execute_expression( p_time => p_deadline_input
                                                                                                             , p_expr => r_dfn.deadline_expression
                                                                                                             )
                                                                               );
      v_first_checktime_utc             := sup_date_actions.convertlocal2utc_ts(p_ts_tz => execute_expression( p_time => p_check_time
                                                                                                             , p_expr => r_dfn.first_check_expression
                                                                                                             )
                                                                               );

      v_dqf_row.process                 := p_process;
      v_dqf_row.bvalidity_utc_from      := p_bvalidity_utc_from;
      v_dqf_row.bvalidity_utc_to        := p_bvalidity_utc_to;
      v_dqf_row.compliancy_deadline_utc := v_compliancy_deadline_utc;
      v_dqf_row.first_checktime_utc     := v_first_checktime_utc;
      v_dqf_row.mrid                    := p_mrid;
      v_dqf_row.dfn_id                  := r_dfn.dfn_id;
      v_dqf_row.check_name              := p_check_name;
      v_dqf_row.max_version             := 0;
      v_dqf_row.processing_time_utc     := p_processing_time_utc;

      dqf_rst_dml.dml_row(p_row => v_dqf_row);
    end if;
    close c_dfn;
  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;

  end fill_expectation_data;
  --
  procedure fill_expectations
  is
  /************************************************************************************************************************************
   Purpose:  Vul de verwachtingsrecords van alle actieve dqf-controles
             Let op! We moeten alles in lokale tijd berekenen en pas net voor het opslaan naar UTC gaan!
  ************************************************************************************************************************************/
    cn_module                 constant varchar2(100) := cn_package || '.fill_expectations';

    type t_dfn_rows is table of t_dfn_row index by pls_integer;
    -- variabelen
    v_dates_count                      simple_integer := 0;
    v_dfn_rows_t                       t_dfn_rows;
    c_dfn                              c_dfn_type;
  begin
    pcs_pcs_actions.start_process(p_initiating_procedure => cn_module
                                 ,p_description          => 'Fill DQF expectations');

    sup_utilities.keep_session_timezone;
    sup_utilities.set_session_timezone(p_timezone => 'Europe/Amsterdam');
    sup_utilities.set_session_english;

    -- Logging
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start');

    -- Vanuit de fill-job alleen de DATA en TIME driven publicaties starten. Deze data-driven zijn publicaties die afgaan als er data
    -- binnenkomt, maar wel b.v. iedere dag gepubliceerd moeten worden
    open c_dfn for select dfn.id
                         ,dfn.process
                         ,dfn.process_type
                         ,dfn.check_type
                         ,dfn.deadline_schedule
                         ,dfn.first_check_schedule
                         ,dfn.bvalidity_from_expression
                         ,dfn.bvalidity_to_expression
                         ,dfn.pbn_id
                         ,dfn.dly_id
                         ,dfn.check_name
                         ,dfn.processing_time_correction
                         ,dfn.deadline_correction
                         ,dfn.first_check_correction
                         ,usb.repeat_interval               as publication_schedule
                         ,dfn.deadline_after_bval_from      as deadline_after_bval_from
                         ,dfn.period_interval_day_to_second as period_interval_day_to_second
                         ,dfn.period_interval_year_to_month as period_interval_year_to_month
                         ,dfn.match_on_mrid
                         ,dfn.mrid_prefix
                         ,dfn.mrid_suffix_format
                         ,dfn.ind_active_fill
                         ,dfn.deadline_correction
                         ,dfn.first_check_expression
                         ,dfn.mrid_suffix
                         ,dfn.ind_local_bvalidity
                     from dqf_definitions dfn
                     left outer join user_scheduler_jobs usb on dfn.process = replace(usb.job_name, 'PUBLISH_', '')
                    where dfn.ind_active_fill  =  'Y'
                      and dfn.check_type in ('DATA', 'TIME')
                      and dfn.bvalidity_from_expression is not null; -- Moet er zijn anders kunnen we niks checken  --
    <<processes>>
    loop
      fetch c_dfn
       bulk collect
       into v_dfn_rows_t
      limit 1000;

      for idx in 1 .. v_dfn_rows_t.count
      loop
        fill_expectation_priv(p_dfn_row     => v_dfn_rows_t(idx)
                             ,p_dates_count => v_dates_count);
      end loop;

      exit when v_dfn_rows_t.count = 0;
      v_dfn_rows_t.delete;
    end loop processes;

    commit;

    pcs_log_actions.log_info( p_module => cn_module
                            , p_text   => 'Aantal aangemaakte records: ' || v_dates_count || chr(10)
                            );

    -- Logging afsluiten
    pcs_log_actions.log_trace( p_module => cn_module
                             , p_text   => 'End');

    sup_utilities.reset_session_timezone;

    pcs_pcs_actions.end_process;

  exception
    when others then
      pcs_log_actions.log_info( p_module => cn_module
                              , p_text   => 'Aantal aangemaakte records: ' || v_dates_count || chr(10)
                              );
      pcs_log_actions.log_error( p_module => cn_module
                               );
      pcs_pcs_actions.end_process;
      raise;
  end fill_expectations;
  --
  procedure fill_single_expectation
    (p_dfn_row in dqf_definitions%rowtype)
  is
  /************************************************************************************************************************************
   Purpose:  Vul de verwachtingsrecord van een enkele actieve dqf-controle
             Let op! We moeten alles in lokale tijd berekenen en pas net voor het opslaan naar UTC gaan!
  ************************************************************************************************************************************/
    cn_module                 constant varchar2(100) := cn_package || '.fill_single_expectation';

    -- variabelen
    c_dfn                              c_dfn_type;
    r_dfn                              t_dfn_row;
    v_dates_count                      simple_integer := 0;
  begin
    pcs_pcs_actions.start_process(p_initiating_procedure => cn_module
                                 ,p_description          => 'Fill single DQF expectation');
    sup_utilities.keep_session_timezone;
    sup_utilities.set_session_timezone(p_timezone => 'Europe/Amsterdam');
    sup_utilities.set_session_english;

    -- Logging
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start');

    -- Hierbij niet specifiek de check_type selecteren, zodat wel ook ADHOC geselecteerd wordt
    open c_dfn for select dfn.id
                         ,dfn.process
                         ,dfn.process_type
                         ,dfn.check_type
                         ,dfn.deadline_schedule
                         ,dfn.first_check_schedule
                         ,dfn.bvalidity_from_expression
                         ,dfn.bvalidity_to_expression
                         ,dfn.pbn_id
                         ,dfn.dly_id
                         ,dfn.check_name
                         ,dfn.processing_time_correction
                         ,dfn.deadline_correction
                         ,dfn.first_check_correction
                         ,usb.repeat_interval               as publication_schedule
                         ,dfn.deadline_after_bval_from      as deadline_after_bval_from
                         ,dfn.period_interval_day_to_second as period_interval_day_to_second
                         ,dfn.period_interval_year_to_month as period_interval_year_to_month
                         ,dfn.match_on_mrid
                         ,dfn.mrid_prefix
                         ,dfn.mrid_suffix_format
                         ,dfn.ind_active_fill
                         ,dfn.deadline_expression
                         ,dfn.first_check_expression
                         ,dfn.mrid_suffix
                         ,dfn.ind_local_bvalidity
                     from dqf_definitions dfn
                     left outer join user_scheduler_jobs usb on dfn.process = replace(usb.job_name, 'PUBLISH_', '')
                    where dfn.id = p_dfn_row.id
                      and dfn.bvalidity_from_expression is not null; -- Moet er zijn anders kunnen we niks checken  --

    fetch c_dfn
     into r_dfn;

    if c_dfn%found then
       if r_dfn.ind_active_fill = 'Y' then
          fill_expectation_priv(p_dfn_row     => r_dfn
                               ,p_dates_count => v_dates_count);
       else
          pcs_log_actions.log_info(p_module => cn_module
                                  ,p_text   => 'DQF not active for process ' || r_dfn.process);
       end if;
    else
      pcs_log_actions.log_error( p_module => cn_module
                                ,p_text   => 'dqf_definitions.id ' || p_dfn_row.id || ' gives no result. DQF-expectation cannot be determined'
                               );
    end if;

    close c_dfn;

    pcs_log_actions.log_info(p_module => cn_module
                            ,p_text   => 'Aantal aangemaakte records: ' || v_dates_count || '.');

    -- Logging afsluiten
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End');

    sup_utilities.reset_session_timezone;

    pcs_pcs_actions.end_process;

  exception
    when others then
      pcs_log_actions.log_info( p_module => cn_module
                              , p_text   => 'Aantal aangemaakte records: ' || v_dates_count || '.'
                              );
      pcs_log_actions.log_error( p_module => cn_module
                               );
      pcs_pcs_actions.end_process;
      raise;
  end fill_single_expectation;
  --
 procedure fill_single_expectation_for_pbn_date
          (p_dfn_row                in dqf_definitions%rowtype
          ,p_pbn_date_utc           in timestamp)
  is
  /************************************************************************************************************************************
   Purpose:  Vul de verwachtingsrecord van een enkele actieve dqf-controle o.b.v. de pbn_date (bvalidity)
             Let op! We moeten alles in lokale tijd berekenen en pas net voor het opslaan naar UTC gaan!
  ************************************************************************************************************************************/
    cn_module                 constant varchar2(100) := cn_package || '.fill_single_expectation_for_pbn_date';

    -- variabelen
    c_dfn                              c_dfn_type;
    r_dfn                              t_dfn_row;
    v_dates_count                      simple_integer := 0;
  begin
    pcs_pcs_actions.start_process(p_initiating_procedure => cn_module
                                 ,p_description          => 'Fill single DQF expectation for bvalidity');
    sup_utilities.keep_session_timezone;
    sup_utilities.set_session_timezone(p_timezone => 'Europe/Amsterdam');
    sup_utilities.set_session_english;

    -- Logging
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start');

    -- Hierbij niet specifiek de check_type selecteren, zodat wel ook ADHOC geselecteerd wordt
    open c_dfn for select dfn.id
                         ,dfn.process
                         ,dfn.process_type
                         ,dfn.check_type
                         ,dfn.deadline_schedule
                         ,dfn.first_check_schedule
                         ,dfn.bvalidity_from_expression
                         ,dfn.bvalidity_to_expression
                         ,dfn.pbn_id
                         ,dfn.dly_id
                         ,dfn.check_name
                         ,dfn.processing_time_correction
                         ,dfn.deadline_correction
                         ,dfn.first_check_correction
                         ,usb.repeat_interval               as publication_schedule
                         ,dfn.deadline_after_bval_from      as deadline_after_bval_from
                         ,dfn.period_interval_day_to_second as period_interval_day_to_second
                         ,dfn.period_interval_year_to_month as period_interval_year_to_month
                         ,dfn.match_on_mrid
                         ,dfn.mrid_prefix
                         ,dfn.mrid_suffix_format
                         ,dfn.ind_active_fill
                         ,dfn.deadline_expression
                         ,dfn.first_check_expression
                         ,dfn.mrid_suffix
                         ,dfn.ind_local_bvalidity
                     from dqf_definitions dfn
                     left outer join user_scheduler_jobs usb on dfn.process = replace(usb.job_name, 'PUBLISH_', '')
                    where dfn.id = p_dfn_row.id
                      and dfn.deadline_expression is not null
                      and dfn.first_check_expression is not null; -- Moet er zijn anders kunnen we niks checken  --

    fetch c_dfn
     into r_dfn;

    if c_dfn%found then
       if r_dfn.ind_active_fill = 'Y' then
          fill_expectation_for_pbn_date(p_dfn_row      => r_dfn
                                       ,p_pbn_date_utc => p_pbn_date_utc);
       else
          pcs_log_actions.log_info(p_module => cn_module
                                  ,p_text   => 'DQF not active for process ' || r_dfn.process);
       end if;
    else
      pcs_log_actions.log_error( p_module => cn_module
                                ,p_text   => 'dqf_definitions.id ' || p_dfn_row.id || ' gives no result. DQF-expectation cannot be determined'
                               );
    end if;

    close c_dfn;

    pcs_log_actions.log_info(p_module => cn_module
                            ,p_text   => 'Aantal aangemaakte records: ' || v_dates_count || '.');

    -- Logging afsluiten
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End');

    sup_utilities.reset_session_timezone;

    pcs_pcs_actions.end_process;

  exception
    when others then
      pcs_log_actions.log_info( p_module => cn_module
                              , p_text   => 'Aantal aangemaakte records: ' || v_dates_count || '.'
                              );
      pcs_log_actions.log_error( p_module => cn_module
                               );
      pcs_pcs_actions.end_process;
      raise;
  end fill_single_expectation_for_pbn_date;
  --
  procedure fill_single_expectation_for_date
    (p_dfn_row                     in dqf_definitions%rowtype
    ,p_processing_time_utc         in timestamp
    ,p_bvalidity_utc_from          in timestamp
    ,p_bvalidity_utc_to            in timestamp
    ,p_deadline_input              in timestamp
    )
  is
  /************************************************************************************************************************************
   Purpose:  Vul de verwachtingsrecord van een enkele actieve dqf-controle o.b.v. een publicatie-tijd (niet de bval)
             Let op! We moeten alles in lokale tijd berekenen en pas net voor het opslaan naar UTC gaan!
  ************************************************************************************************************************************/
    cn_module                 constant varchar2(100) := cn_package || '.fill_single_expectation_for_date';

    -- variabelen
    c_dfn                              c_dfn_type;
    r_dfn                              t_dfn_row;
    v_dates_count                      simple_integer := 0;
  begin
    pcs_pcs_actions.start_process(p_initiating_procedure => cn_module
                                 ,p_description          => 'Fill single DQF expectation for process '
                                                         ||  p_dfn_row.process
                                                         || ' and transmission date '
                                                         || to_char(p_processing_time_utc, 'dd-mm-yyyy hh24:mi'));
    sup_utilities.keep_session_timezone;
    sup_utilities.set_session_timezone(p_timezone => 'Europe/Amsterdam');
    sup_utilities.set_session_english;

    -- Logging
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start');

    -- Hierbij niet specifiek de check_type selecteren, zodat wel ook ADHOC geselecteerd wordt
    open c_dfn for select dfn.id
                         ,dfn.process
                         ,dfn.process_type
                         ,dfn.check_type
                         ,dfn.deadline_schedule
                         ,dfn.first_check_schedule
                         ,dfn.bvalidity_from_expression
                         ,dfn.bvalidity_to_expression
                         ,dfn.pbn_id
                         ,dfn.dly_id
                         ,dfn.check_name
                         ,dfn.processing_time_correction
                         ,dfn.deadline_correction
                         ,dfn.first_check_correction
                         ,usb.repeat_interval               as publication_schedule
                         ,dfn.deadline_after_bval_from      as deadline_after_bval_from
                         ,dfn.period_interval_day_to_second as period_interval_day_to_second
                         ,dfn.period_interval_year_to_month as period_interval_year_to_month
                         ,dfn.match_on_mrid
                         ,dfn.mrid_prefix
                         ,dfn.mrid_suffix_format
                         ,dfn.ind_active_fill
                         ,dfn.deadline_expression
                         ,dfn.first_check_expression
                         ,dfn.mrid_suffix
                         ,dfn.ind_local_bvalidity
                     from dqf_definitions dfn
                     left outer join user_scheduler_jobs usb on dfn.process = replace(usb.job_name, 'PUBLISH_', '')
                    where dfn.id = p_dfn_row.id
                      and dfn.bvalidity_from_expression is not null; -- Moet er zijn anders kunnen we niks checken  --

    fetch c_dfn
     into r_dfn;

    if c_dfn%found then
       if r_dfn.ind_active_fill = 'Y' then
          if    r_dfn.check_type = 'ADHOC'
            and r_dfn.deadline_expression is not null
          then
            fill_expectation_data(p_process              => r_dfn.process
                                 ,p_bvalidity_utc_from   => p_bvalidity_utc_from
                                 ,p_bvalidity_utc_to     => p_bvalidity_utc_to
                                 ,p_mrid                 => null
                                 ,p_check_name           => r_dfn.check_name
                                 ,p_check_time           => systimestamp at time zone sup_constants.cn_utc_timezone
                                 ,p_deadline_input       => p_deadline_input
                                 ,p_processing_time_utc  => p_processing_time_utc);
          else
             fill_expectation_priv(p_dfn_row              => r_dfn
                                  ,p_dates_count          => v_dates_count
                                  ,p_processing_time_loc  => sup_date_actions.convertutc2local(p_utc_date => p_processing_time_utc)
                                  );
          end if;
        else
          pcs_log_actions.log_info(p_module => cn_module
                                  ,p_text   => 'DQF not active for process ' || r_dfn.process);
       end if;
    else
       pcs_log_actions.log_error( p_module => cn_module
                                 ,p_text   => 'dqf_definitions.id ' || p_dfn_row.id || ' gives no result. DQF-expectation cannot be determined'
                                );
    end if;

    close c_dfn;

    pcs_log_actions.log_info( p_module => cn_module
                            , p_text   => 'Aantal aangemaakte records: ' || v_dates_count || '.'
                            );

    -- Logging afsluiten
    pcs_log_actions.log_trace(p_module => cn_module
                            ,p_text   => 'End');

    sup_utilities.reset_session_timezone;

    pcs_pcs_actions.end_process;

  exception
    when others then
      pcs_log_actions.log_info ( p_module => cn_module
                               , p_text   => 'Aantal aangemaakte records: ' || v_dates_count || '.'
                               );
      pcs_log_actions.log_error( p_module => cn_module
                               );
      pcs_pcs_actions.end_process;
      raise;
  end fill_single_expectation_for_date;
  --
  procedure check_expectations
    (p_process                     in varchar2 default null
    )
  is
  /************************************************************************************************************************************
   Purpose:  Controleer de verwachtingen tegen de werkelijkheid (JOB)
  ************************************************************************************************************************************/
    cn_module                 constant varchar2(100) := cn_package || '.check_expectations';
    cn_ojt_code               constant varchar2(100) := 'DQF_CHECK_EXPECTATIONS';
    cn_process_type_tmn       constant varchar2(3)   := 'TMN';
    cn_process_type_rcn       constant varchar2(3)   := 'RCN';


    v_number_of_retries                number(4);

    cursor c_rst (b_number_of_retries    in number
                 ,b_process              in varchar2)
        is select rst.id
                 ,dfn.process_type
                 ,rst.process
             from dqf_results rst
             join dqf_definitions dfn on dfn.check_name = rst.check_name
            where dfn.ind_active_check = 'Y'
              and (        rst.first_checktime_utc            < SYS_EXTRACT_UTC(SYSTIMESTAMP) -- Alleen controleren als de first_checktime verstreken is
                   or (    rst.first_checktime_utc           is null                            -- Of, als er geen checktime is, als de deadline verstreken is
                       and rst.compliancy_deadline_utc        < SYS_EXTRACT_UTC(SYSTIMESTAMP)))
              and coalesce(to_number(rst.max_version), 0)     < b_number_of_retries
              and rst.process                                 = coalesce(b_process, rst.process)
              and (   coalesce(rst.state_complete,'UNKNOWN') != 'TRUE'
                   or coalesce(rst.state_timely ,'UNKWOWN')   = 'UNKWOWN')
            order by rst.id asc;

  begin
    pcs_pcs_actions.start_process(p_initiating_procedure => cn_module
                                 ,p_description          => 'Check DQF expectations');

    -- Logging
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start'
                             );

    v_number_of_retries                := sup_ojtppy_actions.get_domain_value_n(p_ojt_code   => cn_ojt_code
                                                                               ,p_ppy_code   => 'NUMBER_OF_RETRIES');

    <<dqf_results_loop>>
    for r_rst in c_rst (b_number_of_retries => v_number_of_retries
                       ,b_process           => p_process)
    loop
       if nvl(sup_ojtppy_actions.get_domain_value_n(p_ojt_code  => r_rst.process
                                                   ,p_ppy_code  => 'DQF_CHECK_NUMBER_OF_FILES'), 1) > 1
       then
         -- check expectations voor meer dan een bestand met dezelfde bvalidity's
         check_double_expectation(p_rcn_id => null
                                 ,p_rst_id => r_rst.id);
       else
         if r_rst.process_type = cn_process_type_tmn then
           -- Check expectations for Transmission
           check_single_expectation(p_tmn_id => null
                                   ,p_rst_id => r_rst.id);
         elsif r_rst.process_type = cn_process_type_rcn then
           -- Check expectations for Reception
           check_single_expectation(p_rcn_id => null
                                   ,p_rst_id => r_rst.id);
         end if;
       end if;
    end loop dqf_results_loop;
    commit;

    -- Verzamel de KPI cijfers
    dqf_kpi_dml.refresh_pbn;

    -- Logging afsluiten
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End'
                             );

    pcs_pcs_actions.end_process;
  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
  end check_expectations;

  --
  procedure check_double_expectation(p_rcn_id    in pcs_rcn_receptions.id%type
                                    ,p_rst_id    in dqf_results.id%type)
  is
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- LET OP!!! Niet aangepast aan meerdere checks op dezelfde bvalidity. Functionaliteit is nog nergens in gebruik,
-- dus als de controles met meerdere checks op dezelfde bvalidity goed werken kan deze procedure weg
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  /************************************************************************************************************************************
   Purpose:  Controleer de verwachtingen tegen de werkelijkheid
             voor het geval, dat er meer dan een bestand met dezelfde bvalidity's aanwezig moet zijn
  ************************************************************************************************************************************/
    cn_module                         constant varchar2(100) := cn_package || '.check_double_expectation(rcn)';

    v_state_timely                    dqf_results.state_timely%type;
    v_state_complete                  dqf_results.state_complete%type;

    v_process                         varchar2(100);
    v_gevonden                        integer;
    v_vereist                         integer;

    e_files_found                     exception;

    -- selecteer alle verwachtingen met dezelfde "p_rst_id", ongeacht de status 'Timely' of 'Completed'
    cursor c_crt (b_rcn_id         in pcs_rcn_receptions.id%type
                 ,b_rst_id         in dqf_results.id%type)
        is select rcn_id
                 ,rst_id
                 ,process
                 ,bvalidity_utc_from
                 ,bvalidity_utc_to
                 ,max_version
                 ,state_complete
                 ,state_timely
                 ,compliancy_deadline_utc
                 ,compliancy_one_day_ahead
                 ,started                       as started
                 ,received                      as received
                 ,supplied                      as supplied
                 ,saved                         as saved
                 ,downloaded                    as downloaded
                 ,download_error                as download_error
                 ,invalid_doc                   as invalid_doc
             from (select rcn.id rcn_id
                         ,rst.id rst_id
                         ,rst.process
                         ,rst.bvalidity_utc_from
                         ,rst.bvalidity_utc_to
                         ,rst.max_version
                         ,rst.state_complete
                         ,rst.state_timely
                         ,rst.compliancy_deadline_utc
                         ,rst.compliancy_deadline_utc - interval '1' day as compliancy_one_day_ahead
                         ,rse.state               as rse_state
                         ,rse.tvalidity_utc_from  as rse_tvalidity_utc_from
                     from delphidba.dqf_results rst
                     join delphidba.dqf_definitions dfn on rst.process = dfn.process
                     left outer join delphidba.pcs_rcn_receptions rcn on (    dfn.dly_id             = rcn.dly_id
                                                                          and rcn.bvalidity_utc_from = rst.bvalidity_utc_from
                                                                          and rcn.bvalidity_utc_to   = rst.bvalidity_utc_to
                                                                         )
                     left outer join delphidba.pcs_rcn_states        rse on rse.rcn_id  = rcn.id
                    where (   rst.first_checktime_utc < SYS_EXTRACT_UTC(SYSTIMESTAMP)              -- Alleen controleren als de first_checktime verstreken is
                           or (    rst.first_checktime_utc is null                                   -- Of, als er geen checktime is, als de deadline verstreken is
                               and rst.compliancy_deadline_utc < SYS_EXTRACT_UTC(SYSTIMESTAMP)
                              )
                          )
                     and (   (     b_rcn_id is not null
                               and rcn.id   = b_rcn_id
                              )
                           or (    b_rst_id is not null
                               and rst.id   = b_rst_id
                              )
                          )
                  )
            pivot (min(rse_tvalidity_utc_from)  -- een aggregate-functie is nodig voor de PIVOT, doet verder eigenlijk niks
                    for rse_state in ('STARTED'            as started
                                     ,'RECEIVED'           as received
                                     ,'SUPPLIED'           as supplied
                                     ,'SAVED'              as saved
                                     ,'MESSAGE_DOWNLOADED' as downloaded
                                     ,'DOWNLOAD_ERROR'     as download_error
                                     ,'INVALID_DOCUMENT'   as invalid_doc)
                  )
            where (    ( bvalidity_utc_to < started )
                   and ( started < compliancy_deadline_utc )
                  )
               or (    ( bvalidity_utc_from < started )
                   and ( started < compliancy_one_day_ahead )
                  );

    r_crt      c_crt%rowtype;

  begin

    -- write 'Start' into log-trace
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start');

    open c_crt (b_rcn_id => p_rcn_id
               ,b_rst_id => p_rst_id);
    fetch c_crt into r_crt;
    if c_crt%found then
       v_gevonden                         := c_crt%rowcount;
       v_vereist                          := nvl(sup_ojtppy_actions.get_domain_value_n(p_ojt_code  => r_crt.process
                                                                                      ,p_ppy_code  => 'DQF_CHECK_NUMBER_OF_FILES'), 1);
    end if;

    close c_crt;

    -- klopt het aantal verwachtingen (gevonden) met het aantal verwachtingen (vereist) in de object-property
    if v_vereist = v_gevonden
    then
      -- loop door de verwachtingen, begin met de statussen = null
      v_state_timely          := null;
      v_state_complete        := null;

      <<dqf_results_loop>>
      for r_crt in c_crt (b_rcn_id => p_rcn_id
                         ,b_rst_id => p_rst_id)
      loop

      -- als een van de verwachtingen de 'Timely'-status UNKNOWN of FALSE heeft bereikt -> niet meer wijzigen
       if v_state_timely <> sup_constants.cn_false and v_state_timely <> sup_constants.cn_unknown
       then

         -- Timely is true als op tijd een SUPPLIED is geregistreerd.
         -- anders kan timely nog true worden als op voor het verlopen van de deadline nog een nieuwe reception wordt ontvangen
         if  r_crt.supplied               is not null
         and cast(r_crt.supplied as date) <= cast(r_crt.compliancy_deadline_utc as date)
         then
           v_state_timely        := sup_constants.cn_true;
         elsif r_crt.supplied is null
           and cast(r_crt.compliancy_deadline_utc as date) <= cast(SYS_EXTRACT_UTC(SYSTIMESTAMP) as date)
         then
           v_state_timely        := sup_constants.cn_unknown;
         else
           v_state_timely        := sup_constants.cn_false;
         end if;

       end if;

      -- als een van de verwachtingen de 'Complete'-status UNKNOWN of FALSE heeft bereikt -> niet meer wijzigen
       if v_state_timely <> sup_constants.cn_false and v_state_timely <> sup_constants.cn_unknown
       then

         -- Complete is true als op tijd een SAVED is geregistreerd.
         -- anders kan complete nog true worden als op voor het verlopen van de deadline nog een nieuwe reception wordt ontvangen
         if  r_crt.saved               is not null
         and r_crt.download_error      is null
         and r_crt.invalid_doc         is null
         and cast(r_crt.saved as date) <= cast(r_crt.compliancy_deadline_utc as date)
         then
           v_state_complete      := sup_constants.cn_true;
         elsif r_crt.saved               is not null
           and (   r_crt.download_error  is not null
                or r_crt.invalid_doc     is not null)
           and cast(r_crt.saved as date) <= cast(r_crt.compliancy_deadline_utc as date)
         then
           v_state_complete      := sup_constants.cn_unknown;
         elsif r_crt.saved               is not null
           and (   r_crt.download_error  is not null
                or r_crt.invalid_doc     is not null)
           and cast(r_crt.saved as date) >= cast(r_crt.compliancy_deadline_utc as date)
         then
           v_state_complete      := sup_constants.cn_false;
         elsif r_crt.saved                                 is null
           and cast(r_crt.compliancy_deadline_utc as date) <= cast(SYS_EXTRACT_UTC(SYSTIMESTAMP) as date)
         then
           v_state_complete      := sup_constants.cn_false;
         else
           v_state_complete      := sup_constants.cn_false;
         end if;

       end if;

      end loop dqf_results_loop;

    else

      v_process                 := r_crt.process;
      raise e_files_found;

    end if;

    -- de status 'Timely' en 'Complete' op alle verwachtingen toepassen
    <<set_reception_states>>
    for r_crt in c_crt (b_rcn_id => p_rcn_id
                       ,b_rst_id => p_rst_id)
    loop
       -- Eenmaal TRUE, dan niet meer overschrijven
       update dqf_results
          set max_version        = nvl(r_crt.max_version, 0) + 1
             ,state_timely       = case state_timely   when sup_constants.cn_true
                                                       then
                                                         sup_constants.cn_true
                                                       else
                                                         v_state_timely
                                                       end
             ,state_complete     = case state_complete when sup_constants.cn_true
                                                       then
                                                         sup_constants.cn_true
                                                       else
                                                         v_state_complete
                                                       end
             ,tvalidity_utc_from = SYS_EXTRACT_UTC(SYSTIMESTAMP)
             ,tvalidity_loc_from = systimestamp
       where id                  = p_rst_id;
    end loop set_reception_states;

    -- write 'End' into log-trace
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End');

    exception
      when e_files_found then
        pcs_log_actions.log_warning(p_module => cn_module
                                   ,p_text   => 'Verwachtingen voor process: ' || v_process || ', '
                                                 || 'gevonden: ' || v_gevonden || ', '
                                                 || 'vereist: ' || v_vereist || '.');

      when others then
        pcs_log_actions.log_error(p_module => cn_module);

  end check_double_expectation;

  procedure check_expectation_rst(p_rst_id    in dqf_results.id%type)
  is
  /************************************************************************************************************************************
   Purpose:  Controleer de verwachtingen tegen de werkelijkheid (rst)
  ************************************************************************************************************************************/
    --
    -- Haal de waarde van property DQF_RESULT_SINGLE_MATCH op voor de publicatie
    cursor c_rst(b_rst_id              in dqf_results.id%type)
        is select ppy.v_value
             from dqf_results      rst
             join dqf_definitions  dfn on       dfn.check_name = rst.check_name
             join sup_publications pbn on       dfn.pbn_id     = pbn.id
             left join sup_ojt_ppy ppy on  (    ppy.ojt_code   = pbn.name
                                            and ppy.ppy_code   = cn_single)
            where dfn.ind_active_check = 'Y'
              and rst.id               = b_rst_id;

    cursor c_tmn(b_rst_id              in dqf_results.id%type)
        is select coalesce(tmn_n.id, tmn_y.id) as tmn_id
             from dqf_results                rst
             join dqf_definitions            dfn   on      dfn.check_name           = rst.check_name
             left join pcs_tmn_transmissions tmn_n on (    dfn.match_on_mrid        = 'N'
                                                       and tmn_n.pbn_id             = dfn.pbn_id
                                                       and tmn_n.bvalidity_utc_from = rst.bvalidity_utc_from)
             left join pcs_tmn_transmissions tmn_y on (    dfn.match_on_mrid        = 'Y'
                                                       and tmn_y.mrid               = rst.mrid)
            where rst.id = b_rst_id
            order by coalesce(tmn_n.version     , tmn_y.version)
                   , coalesce(tmn_n.cre_date_utc, tmn_y.cre_date_utc);

    v_value                           sup_ojt_ppy.v_value%type;
  begin
     open c_rst(b_rst_id => p_rst_id);

     fetch c_rst
      into v_value;

     -- Is het een single_expectation (1 per bvalidity) of een multi (meerdere over dezelfde bvalidity)?
     if coalesce(v_value, 'X') =  'Y'
     then
        for r_tmn in c_tmn(b_rst_id => p_rst_id)
        loop
          check_tmn_expectation_priv(p_tmn_id => r_tmn.tmn_id
                                    ,p_rst_id => p_rst_id);
        end loop;
     elsif c_rst%found -- Zonder result record valt er niks te checken
     then
       check_multi_expectation(p_tmn_id => null
                              ,p_rst_id => p_rst_id);
     end if;

     close c_rst;
  end check_expectation_rst;

  procedure check_expectation_tmn(p_tmn_id    in pcs_tmn_transmissions.id%type)
  is
  /************************************************************************************************************************************
   Purpose:  Controleer de verwachtingen tegen de werkelijkheid (tmn)
  ************************************************************************************************************************************/
    --
    -- Haal de waarde van property DQF_RESULT_SINGLE_MATCH op voor de publicatie
    cursor c_tmn(b_tmn_id              in pcs_tmn_transmissions.id%type)
        is select ppy.v_value
             from pcs_tmn_transmissions tmn
             join sup_publications      pbn on       tmn.pbn_id     = pbn.id
             left join sup_ojt_ppy      ppy on  (    ppy.ojt_code   = pbn.name
                                                 and ppy.ppy_code   = cn_single)
            where tmn.id = b_tmn_id;

    cursor c_rst(b_tmn_id              in pcs_tmn_transmissions.id%type)
        is select rst.id
             from dqf_results           rst
             join dqf_definitions       dfn on dfn.check_name  = rst.check_name
             join pcs_tmn_transmissions tmn on rst.mrid        = tmn.mrid
            where dfn.match_on_mrid = 'Y'
              and tmn.id = b_tmn_id
            union all
            select rst.id
              from dqf_results           rst
              join dqf_definitions       dfn on      dfn.check_name  = rst.check_name
              join pcs_tmn_transmissions tmn on (    dfn.pbn_id             = tmn.pbn_id
                                                 and rst.bvalidity_utc_from = tmn.bvalidity_utc_from
                                                 and rst.bvalidity_utc_to   = tmn.bvalidity_utc_to )
             where dfn.match_on_mrid = 'N'
               and tmn.id = b_tmn_id;

    v_value                           sup_ojt_ppy.v_value%type;
    v_rst_id                          dqf_results.id%type;
  begin
     open c_tmn(b_tmn_id        => p_tmn_id);

     fetch c_tmn
      into v_value;

     close c_tmn;

     -- Is het een single_expectation (1 per bvalidity) of een multi (meerdere over dezelfde bvalidity)?
     if coalesce(v_value, 'X') =  'Y'
     then
       open c_rst(b_tmn_id => p_tmn_id);

       fetch c_rst
        into v_rst_id;

       if v_rst_id is not null -- Zonder result record valt er niks te checken
       then
          check_tmn_expectation_priv(p_tmn_id => p_tmn_id, p_rst_id => v_rst_id);
       end if;

       close c_rst;
     else
       check_multi_expectation(p_tmn_id => p_tmn_id, p_rst_id => null);
     end if;
  end check_expectation_tmn;

  procedure check_single_expectation(p_tmn_id    in pcs_tmn_transmissions.id%type
                                    ,p_rst_id    in dqf_results.id%type)
  is
  /************************************************************************************************************************************
   Purpose:  Controleer de verwachtingen tegen de werkelijkheid
  ************************************************************************************************************************************/
  begin
    if p_tmn_id is not null
    then
      check_expectation_tmn(p_tmn_id => p_tmn_id);
    else
      check_expectation_rst(p_rst_id => p_rst_id);
    end if;
    check_accurate(p_tmn_id => p_tmn_id
                  ,p_rst_id => p_rst_id);
  end check_single_expectation;
  --
  procedure check_single_expectation(p_rcn_id    in pcs_rcn_receptions.id%type
                                    ,p_rst_id    in dqf_results.id%type)
  is
  /************************************************************************************************************************************
   Purpose:  Controleer de verwachtingen tegen de werkelijkheid voor RECEPTIONS
  ************************************************************************************************************************************/
    cn_module                 constant varchar2(100) := cn_package || '.check_single_expectation(rcn)';

    v_state_timely                    dqf_results.state_timely%type;
    v_state_complete                  dqf_results.state_complete%type;

    cursor c_crt_by_rst_id (b_rst_id         in dqf_results.id%type)
        is select rcn_id
                 ,rst_id
                 ,process
                 ,check_name
                 ,bvalidity_utc_from
                 ,bvalidity_utc_to
                 ,max_version
                 ,state_complete
                 ,state_timely
                 ,compliancy_deadline_utc
                 ,started                       as started
                 ,received                      as received
                 ,supplied                      as supplied
                 ,saved                         as saved
                 ,downloaded                    as downloaded
                 ,download_error                as download_error
                 ,invalid_doc                   as invalid_doc
             from (select rcn.id rcn_id
                         ,rst.rst_id
                         ,rst.process
                         ,rst.check_name
                         ,rst.bvalidity_utc_from
                         ,rst.bvalidity_utc_to
                         ,rst.max_version
                         ,rst.state_complete
                         ,rst.state_timely
                         ,rst.compliancy_deadline_utc
                         ,rse.state               as rse_state
                         ,rse.tvalidity_utc_from  as rse_tvalidity_utc_from
                    from (select  dfn.dly_id
                                 ,rst.mrid
                                 ,rst.id rst_id
                                 ,rst.process
                                 ,rst.check_name
                                 ,rst.bvalidity_utc_from
                                 ,rst.bvalidity_utc_to
                                 ,rst.max_version
                                 ,dfn.check_type
                                 ,rst.state_complete
                                 ,rst.state_timely
                                 ,rst.compliancy_deadline_utc
                                 ,cast (rst.processing_time_utc as date)                                                        as this_pcs_time
                                 ,cast (lead (rst.processing_time_utc) over (partition by rst.check_name
                                                                                 order by rst.bvalidity_utc_from  asc
                                                                                         ,rst.processing_time_utc asc) as date) as next_pcs_time
                             from dqf_results rst
                             join (select dfn.check_name
                                         ,dfn.check_type
                                         ,dfn.dly_id
                                         ,dfn.match_on_mrid
                                     from dqf_definitions dfn
                                    where dfn.ind_active_check = 'Y'  -- Alleen actieve controles pakken!
                                  ) dfn on rst.check_name = dfn.check_name  -- Noodgreep omdat we de results niet 1 op 1 kunnen matchen met de definition
                            where rst.id         = b_rst_id
                              and (   rst.state_complete                                is null
                                   or rst.state_complete                                != sup_constants.cn_true
                                   or nvl(rst.state_timely  , sup_constants.cn_unknown)  = sup_constants.cn_unknown
                                  )
                          ) rst
                     join pcs_rcn_receptions rcn on (    rst.dly_id             = rcn.dly_id
                                                     and rcn.bvalidity_utc_from = rst.bvalidity_utc_from
                                                     and rcn.bvalidity_utc_to   = rst.bvalidity_utc_to
                                                    )
                     join pcs_rcn_states     rse on rse.rcn_id  = rcn.id
                     join pcs_rcn_states     rse_supplied on (    rse_supplied.rcn_id = rcn.id     -- Deze extra join is nodig om het juiste reception-record te vinden. Het SUPPLIED record moet ergens tussen de 2 verwachte ontvangstmomenten liggen
                                                              and rse_supplied.state = 'SUPPLIED'  -- We kunnen hiet niet de creatiedatum van de reception gebruiken, omdat dat het moment is dat wij het verwerken en dat zou weleens buiten het venster kunnen vallen.
                                                              and cast(rse_supplied.tvalidity_utc_from as date)  between nvl(rst.this_pcs_time, cast (rse_supplied.tvalidity_utc_from as date))
                                                                                                                     and nvl(rst.next_pcs_time, cast (rse_supplied.tvalidity_utc_from as date))
                                                              )
                  )
            pivot (min(rse_tvalidity_utc_from)  -- een aggregate-functie is nodig voor de PIVOT, doet verder eigenlijk niks
                    for rse_state in ('STARTED'            as started
                                     ,'RECEIVED'           as received
                                     ,'SUPPLIED'           as supplied
                                     ,'SAVED'              as saved
                                     ,'MESSAGE_DOWNLOADED' as downloaded
                                     ,'DOWNLOAD_ERROR'     as download_error
                                     ,'INVALID_DOCUMENT'   as invalid_doc)
                  );


    cursor c_crt_by_rcn_id (b_rcn_id         in pcs_rcn_receptions.id%type)
        is select rcn_id
                 ,rst_id
                 ,process
                 ,check_name
                 ,bvalidity_utc_from
                 ,bvalidity_utc_to
                 ,max_version
                 ,state_complete
                 ,state_timely
                 ,compliancy_deadline_utc
                 ,started                       as started
                 ,received                      as received
                 ,supplied                      as supplied
                 ,saved                         as saved
                 ,downloaded                    as downloaded
                 ,download_error                as download_error
                 ,invalid_doc                   as invalid_doc
             from (select rcn.id rcn_id
                         ,rst.dly_id
                         ,rst.rst_id
                         ,rst.process
                         ,rst.check_name
                         ,rst.bvalidity_utc_from
                         ,rst.bvalidity_utc_to
                         ,rst.max_version
                         ,rst.state_complete
                         ,rst.state_timely
                         ,rst.compliancy_deadline_utc
                         ,rse.state               as rse_state
                         ,rse.tvalidity_utc_from  as rse_tvalidity_utc_from
                     from (select dfn.dly_id
                                 ,rst.mrid
                                 ,rst.id rst_id
                                 ,rst.process
                                 ,rst.check_name
                                 ,rst.bvalidity_utc_from
                                 ,rst.bvalidity_utc_to
                                 ,rst.max_version
                                 ,dfn.check_type
                                 ,rst.state_complete
                                 ,rst.state_timely
                                 ,rst.compliancy_deadline_utc
                                 ,cast (rst.processing_time_utc as date)                                                        as this_pcs_time
                                 ,cast (lead (rst.processing_time_utc) over (partition by rst.check_name
                                                                                 order by rst.bvalidity_utc_from  asc
                                                                                         ,rst.processing_time_utc asc) as date) as next_pcs_time
                             from dqf_results     rst
                             join dqf_definitions dfn on rst.check_name = dfn.check_name
                            where dfn.ind_active_check = 'Y'
                              and (   rst.state_complete                                is null
                                   or rst.state_complete                                != sup_constants.cn_true
                                   or nvl(rst.state_timely  , sup_constants.cn_unknown)  = sup_constants.cn_unknown
                                  )
                              and (   rst.first_checktime_utc          < SYS_EXTRACT_UTC(SYSTIMESTAMP)         -- Alleen controleren als de first_checktime verstreken is
                                   or (    rst.first_checktime_utc     is null                                   -- Of, als er geen checktime is, als de deadline verstreken is
                                       and rst.compliancy_deadline_utc < SYS_EXTRACT_UTC(SYSTIMESTAMP)
                                      )
                                   )
                          ) rst
                     join pcs_rcn_receptions rcn on (    rst.dly_id             = rcn.dly_id
                                                     and rcn.bvalidity_utc_from = rst.bvalidity_utc_from
                                                     and rcn.bvalidity_utc_to   = rst.bvalidity_utc_to
                                                    )
                     join pcs_rcn_states     rse on rse.rcn_id  = rcn.id
                     join pcs_rcn_states     rse_supplied on (    rse_supplied.rcn_id = rcn.id     -- Deze extra join is nodig om het juiste reception-record te vinden. Het SUPPLIED record moet ergens tussen de 2 verwachte ontvangstmomenten liggen
                                                              and rse_supplied.state = 'SUPPLIED'  -- We kunnen hiet niet de creatiedatum van de reception gebruiken, omdat dat het moment is dat wij het verwerken en dat zou weleens buiten het venster kunnen vallen.
                                                              and cast(rse_supplied.tvalidity_utc_from as date)  between nvl(rst.this_pcs_time, cast (rse_supplied.tvalidity_utc_from as date))
                                                                                                                     and nvl(rst.next_pcs_time, cast (rse_supplied.tvalidity_utc_from as date))
                                                              )
                    where rcn.id                 = b_rcn_id                  )
            pivot (min(rse_tvalidity_utc_from)  -- een aggregate-functie is nodig voor de PIVOT, doet verder eigenlijk niks
                    for rse_state in ('STARTED'            as started
                                     ,'RECEIVED'           as received
                                     ,'SUPPLIED'           as supplied
                                     ,'SAVED'              as saved
                                     ,'MESSAGE_DOWNLOADED' as downloaded
                                     ,'DOWNLOAD_ERROR'     as download_error
                                     ,'INVALID_DOCUMENT'   as invalid_doc)
                  );

    r_crt    c_crt_by_rst_id%rowtype;
    v_rcn_id dqf_results.rcn_id%type;

  begin
    -- Logging, alleen bij Tracing of Debug om idioot veel niets-zeggende logging te voorkomen
    if g_default_log_level = 'T'
    or g_default_log_level = 'D' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'Start'
                                );
    end if;

    -- loop over resultaten uit cursor c_crt
    <<dqf_results_loop>>
    if p_rcn_id is not null then
      open c_crt_by_rcn_id (b_rcn_id => p_rcn_id);
    else
      open c_crt_by_rst_id (b_rst_id => p_rst_id);
    end if;
    loop
       if p_rcn_id is not null then
         fetch c_crt_by_rcn_id
          into r_crt;
         v_rcn_id := p_rcn_id;

         exit when c_crt_by_rcn_id%notfound;
       else
         fetch c_crt_by_rst_id
          into r_crt;
         v_rcn_id := r_crt.rcn_id;

         exit when c_crt_by_rst_id%notfound;
       end if;
       v_state_timely          := null;
       v_state_complete        := null;

       -- Timely is true als op tijd een SUPPLIED is geregistreerd.
       -- anders kan timely nog true worden als op voor het verlopen van de deadline nog een nieuwe reception wordt ontvangen
       if  r_crt.supplied               is not null
       and cast(r_crt.supplied as date) <= cast(r_crt.compliancy_deadline_utc as date)
       then
         v_state_timely        := sup_constants.cn_true;
       elsif r_crt.supplied                              is null
         and cast(r_crt.compliancy_deadline_utc as date)  > cast(SYS_EXTRACT_UTC(SYSTIMESTAMP) as date)
       then
         -- We hebben nog tijd
         v_state_timely        := sup_constants.cn_unknown;
       else
         -- niks ontvangen en deadline is verstreken
         v_state_timely        := sup_constants.cn_false;
       end if;

       -- Complete is true als op tijd een SAVED is geregistreerd.
       -- anders kan complete nog true worden als op voor het verlopen van de deadline nog een nieuwe reception wordt ontvangen
       if  r_crt.saved               is not null
       and r_crt.download_error      is null
       and r_crt.invalid_doc         is null
       and cast(r_crt.saved as date) <= cast(r_crt.compliancy_deadline_utc as date)
       then
         v_state_complete      := sup_constants.cn_true;
       elsif r_crt.saved               is not null
         and (   r_crt.download_error  is not null
              or r_crt.invalid_doc     is not null)
         and cast(r_crt.saved as date) <= cast(r_crt.compliancy_deadline_utc as date)
       then
         --  wel wat ontvangen, maar dat is mislukt, maar we hebben nog tijd
         v_state_complete      := sup_constants.cn_unknown;
       elsif r_crt.saved               is not null
         and (   r_crt.download_error  is not null
              or r_crt.invalid_doc     is not null)
         and cast(r_crt.saved as date) >= cast(r_crt.compliancy_deadline_utc as date)
       then
         -- wel wat ontvangen, maar dat is mislukt en de deadline was al verstreken
         v_state_complete      := sup_constants.cn_false;
       elsif r_crt.saved                                 is null
         and cast(r_crt.compliancy_deadline_utc as date) <= cast(SYS_EXTRACT_UTC(SYSTIMESTAMP) as date)
       then
         -- Niks ontvangen en deadline verstreken dus zijn we te laat
         v_state_complete      := sup_constants.cn_false;
       else
         -- Er is niks en we weten niks. Deze situatie zou niet voor moeten kunnen komen
         v_state_complete      := sup_constants.cn_false;
       end if;

       -- Eenmaal TRUE, dan niet meer overschrijven

       update dqf_results
          set max_version        = nvl(r_crt.max_version, 0) + 1
             ,state_timely       = case state_timely
                                     when sup_constants.cn_true then
                                       sup_constants.cn_true
                                     else
                                       v_state_timely
                                   end
             ,state_complete     = case state_complete
                                     when sup_constants.cn_true then
                                       sup_constants.cn_true
                                     else
                                       v_state_complete
                                   end
             ,tvalidity_utc_from = SYS_EXTRACT_UTC(SYSTIMESTAMP)
             ,tvalidity_loc_from = systimestamp
             ,rcn_id             = v_rcn_id
       where id = r_crt.rst_id;

    end loop dqf_results_loop;

    if c_crt_by_rst_id%isopen then
       close c_crt_by_rst_id;
    end if;

    if c_crt_by_rcn_id%isopen then
       close c_crt_by_rcn_id;
    end if;

    -- Logging afsluiten, alleen bij Tracing of Debug om idioot veel niets-zeggende logging te voorkomen
    if g_default_log_level = 'T'
    or g_default_log_level = 'D' then
       pcs_log_actions.log_trace(p_module => cn_module
                                ,p_text   => 'End'
                                );
    end if;
  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
  end check_single_expectation;
begin
    g_default_log_level                := sup_ojtppy_actions.get_domain_value( p_ojt_code                => 'LOGGING'
                                                                              ,p_ppy_code                => 'DEFAULT_LOG_LEVEL'
                                                                              ,p_bvalidity_utc_timestamp => SYS_EXTRACT_UTC(SYSTIMESTAMP)
                                                                              ,p_tvalidity_utc_timestamp => SYS_EXTRACT_UTC(SYSTIMESTAMP)
                                                                              ,p_silent_mode             => 'Y'
                                                                             );
end dqf_rst_actions;
/
