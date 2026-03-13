create or replace package body sup_date_actions
is
  /***********************************************************************************************************************************
   Purpose    : All kind of actions with dates

   Change History
   Date        Author            Version   Description
   ----------  ----------------  -------   -------------------------------------------------------------------------------------------
   23-03-2017  X. Pikaar         01.00.00  created
   07-06-2017  X. Pikaar         01.00.01  convertutc2local had onbereikbare code na de return
   14-06-2017  X. Pikaar         01.00.02  get_utc_timeinterval_by_ptu: lengte toegevoegd bij number-kolommen
   30-06-2017  X. Pikaar         01.00.03  Datumformaat timestamp_tz expliciet zetten om te voorkomen dat de vertaling mislukt
                                           door database instellingen
   04-07-2017  X. Pikaar         01.00.04  Nog meer geklooi met timestamp_tz conversie: i.p.v. xff moet je .ff gebruiken,
                                           anders snapt Oracle het niet (altijd)
                                           translate_resolution_2_minutes had parameter p_date, maar die werd niet gebruikt, dus
                                           verwijderd
   10-07-2017  X. Pikaar         01.00.05  Datumformaten zonder secondes toegevoegd
   13-07-2017  X. Pikaar         01.00.06  date_wintersummerchange, date_summerwinterchange en get_ptu_from_utc_date
                                           toegevoegd
   14-08-2017  X. Pikaar         01.00.07  get_ptu_from_utc_date: Lengte toegevoegd aan number kolom
   15-08-2017  X. Pikaar         01.00.08  bepalen zomer-/wintertijdovergangsdag in het Engels, dus nls-settings Engels
   21-02-2017  A Kluck           01.00.09  Wijziging return value van convert_any_date2timestamp_utc van timestamp with time zone naar timestamp
   11-10-2017  A Zwijnenburg     01.00.10  Curvetype A03 Variable Blocksize ingebouwd.
                                           get_utc_timeinterval_by_ptu() overloaded.
   19-10-2017  X. Pikaar         01.00.11  Bugfix: convert_any_date2timestamp_utc maakte in de zomer van een local wintertijd een
                                           UTC door 02:00 van de lokale tijd af te trekken (in de winter zal het ook wel misgegaan
                                           zijn met zomertijden).
   03-11-2017  X. Pikaar         01.00.12  Als een lokale timestamp met timezone binnen kwam werd er een to_date gedaan. Dat kan
                                           helemaal niet (ORA-018021 date format not recognized). Die data moeten direct met een
                                           to_timestamp_tz naar een timestamp gezet worden
   22-05-2018  M. Zuijdendorp    01.00.13  Functies convert_localtimestamp2utcdate en convert_utctimestamp2localdate toegevoegd
   24-05-2018  M. Zuijdendorp    01.00.14  Sonar issues verwerkt
   06-06-2018  M. Zuijdendorp    01.00.15  In Function convertutc2local werd timestamp parameter met to_timestamp geconverteerd naar timestamp.
                                           Dat ging bij overgang zomer<->winter tijd niet goed met NL session parameters van Fitnesse.
                                           Verwarrend want ENG session parameters in PL/SQL Developer gaf geen problemen.
   07-06-2018  N.Wenting         01.00.16  functies get_position_for_point en get_position_for_point toegevoegd.
   11-06-2018  M. Zuijdendorp    01.00.17  Functie get_ptu_from_utc_date aangepast ivm bug bij zomer-/wintertijdovergangsdag. TRAN-1829
   05-07-2018  N.Wenting         01.00.18  Kleine sonar bevindingen.
   10-07-2018  X. Pikaar         01.00.19  TRAN-1933: bug in exception handler get_utc_timeinterval_by_ptu opgelost: to_char om parameter
                                           p_ptu_eind
   25-07-2018  N.Wenting         01.00.20  Nieuwe versie get_ptu_from_utc_date opgezet en doorgetest, voornamelijk wordt er rekening gehouden
                                           met hoe oracle de DST omgaat en corrigeren we alleen de overgang dagen.
   06-08-2018  X. Pikaar         01.00.21  get_ptu_from_utc_time_from: datatype veld v_pte_tz gewijzigd van varchar naar varchar2
   08-08-2018  X. Pikaar         01.00.22  Niet-gebruikte variabelen verwijderd
   10-08-2018  X. Pikaar         01.00.23  get_ptu_from_utc_date aangepast, zomer/wintertijd-overgang gign nog steeds niet goed.
                                           get_ptu_from_utc_time_from verwijderd, want die was niet nodig
   18-09-2018  X. Pikaar         01.01.00  Function get_first_day_of_week toegevoegd
   18-10-2018  X. Pikaar         01.02.00  Resolutie PT3S en PT4S (3 en 4 seconden) toegevoegd
   23-10-2018  Y. Krop           01.02.01  Trailing spaces verwijderd.
   22-01-2019  X. Pikaar         01.03.00  translate_resolution_2_minutes: resoluties P1D, P7D, P1M en P1Y toegvoegd
                                           calculate_winter_summer_date en calculate_summer_winter_date verwijderd, waren dubbel
   24-01-2019  X. Pikaar         01.03.01  In date_summerwinterchange en date_wintersummerchange alleen de NLS_DATE_LANGUAGE zetten
                                           en niet alle nls-parameters, want met de reset via procedure reset_session_nls erna worden
                                           anders alle nls-parameters gereset op een moment dat we dat nog niet willen
   28-01-2019  M. Zuijdendorp    01.04.00  In functies convert_any_date2timestamp_utc, convertutc2local en convertlocal2utc
                                           de parameter p_date hernoemd naar p_text_date, p_utc_date, p_local_date
   17-04-2019  X. Pikaar         01.05.00  convertlocal2utc: het kan zijn dat je op de winter-/zomertijdovergang met een tijd tussen
                                           02:00 en 03:00 binnenkomt omdat de timestamp niet weet in welke tijdzone hij zit. Als dat
                                           zo is een uurtje bij de tijd optellen om naar de zomertijd te gaan.
   18-04-2019  X. Pikaar         01.05.01  Zomer-/wintertijd-overgang alleen bepalen als er een datum aangeleverd is. Anders kan je
                                           een Oraclefout krijgen.
                                           convertlocal2utc: ook rekening houden met de zomer-/wintertijdovergang door tussen 02:00
                                           en 03:00 in de zomertijd een uur van de lokale tijd af te trekken, zodat de UTC-tijd
                                           wel klopt. Dit werkt alleen als we zelf in de zomertijd zitten.
   21-05-2019  X. Pikaar         01.05.02  Ongebruikte constante verwijderd
   31-05-2019  Y. Krop           01.05.03  Sonar-melding m.b.t. trailing spaces opgelost.
   04-06-2019  Y. Krop           01.06.00  translate_resolution_2_minutes: resolutie PT4H toegevoegd.
   07-06-2019  X. Pikaar         01.07.00  Logging verwijderd omdat deze package zovaak aangeroepen wordt dat hij enorm veel logging genereert
   17-09-2019  Y. Krop           01.08.00  TRAN-3186 Functie transform_resolution toegevoegd.
   24-09-2019  Y. Krop           01.08.01  Sonar-melding weggepoetst.
   08-11-2019  X. Pikaar         01.09.00  get_utc_ptus_between_two_dates toegevoegd
   27-11-2019  X. Pikaar         01.10.00  resolutie PT24H toegeveoegd aan functie get_max_position toegevoegd
   04-02-2020  X. Pikaar         01.11.00  translate_resolution_2_minutes gegerieker gemaakt zodat deze alle PT-resoluties aankan
   28-02-2020  M. Walraven       01.12.00  aanpassing op de convertlocal2utc om te corrigeren voor zomer en wintertijd
   02-04-2020  X. Pikaar         01.13.00  Functie transform_resolution hield geen rekening met Z/W en W/Z overgang bij resolutie P1D
   06-05-2020  T. Bakker         01.14.00  Functie transform_resolution uitgebreid voor berichten met resolutie PT3H en PT5H
   13-08-2020  R.Koomen          01.15.00  TRAN-4035. Datums worden nu correct op zomertijd/wintertijd herkend.
   24-08-2020  R.Koomen          01.15.01  Bugfix op TRAN-4035
   26-08-2020  R.Koomen          01.16.00  TRAN-4289 add_interval_to_timestamp_tz toegevoegd om probleemloos timestamps en intervallen op te tellen.
   01-09-2020  X. Pikaar         01.16.01  convertutc2local_ts ging nog niet goed op moment dat je zelf in de zomertijd zit en een wintertijd
                                           datum hebt en hetzelfde met de zomertijd als je in de wintertijd zit.
   25-09-2020  X. Pikaar         01.16.02  Sonar-dingen opgelost
   29-09-2020  X. Pikaar         01.16.03  get_utc_ptus_between_two_dates gaf veel teveel ptu's
   01-09-2020  M. Walraven       01.17.00  TRAN-4368 fixes voor zomer/wintertijd.
   04-11-2020  X. Pikaar         01.18.00  convertlocal2utc_ts aangepast op juiste DST-overgangen
   03-06-2021  X. Pikaar         01.19.00  translate_resolution_2_minutes kan nu ook PT*H*M aan en translate_hours_to_resolution toegevoegd
   07-07-2021  X. Pikaar         01.20.00  Voorloophekje (stom OSB-toevoegsel) verwijderen van datum in convert_any_date2timestamp_utc
   01-10-2021  X. Pikaar         01.20.01  Bugje uit transform_resolution gehaald en functie gelijk een beetje flexibeler gemaakt
   11-10-2021  X. Pikaar         01.21.00  get_hours_between_2_dates toegevoegd
   29-10-2021  X. Pikaar         01.22.00  Meerdere datum formaten dag-maand-jaar toegevoegd in convert_any_date2timestamp_utc
   04-11-2021  X. Pikaar         01.22.01  Iets te enthousiast convert_any_date2timestamp_utc uit AVY overgenomen waardoor formaat yyyy-mm-dd hh24:mi
                                           stuk liep
   09-02-2022  X. Pikaar         01.23.00  Functie get_ptus_between_two_dates toegevoegd
   08-04-2022  Nico KLaver       01.24.00  TRAN-5170: utc2local, local2utl, hours2dsinterval en trunc_local toegevoegd
   18-07-2022  X. Pikaar         01.25.00  add_interval_to_timestamp_tz werkte niet goed op de eind van de maand, dan kwam je soms
                                           een dag te vroeg of een maand te laat uit. Bovendien ging het niet goed op het W/Z uur
   20-07-2022  X. Pikaar         01.26.00  convertutc2local_ts en convert_local2utc_ts houden rekening met zomer/wintertijden en geven CET/CEST
                                           terug
   12-08-2022  Y. Krop           01.27.00  TRAN-4975: get_position_for_point en get_max_position kunnen overweg met PTnHnM-resoluties
   25-08-2022  X. Pikaar         01.27.01  Versie 01.16.00 teruggedraaid, was door foute merge in branch gekomen
   26-08-2022  Nico Klaver       01.28.00  TRAN-5453: get_month toegevoegd.
   20-10-2022  Nico Klaver       01.29.00  TRAN-5820: add_interval_to_timestamp_tz niet naar laatste dag van maand wanneer er alleen
                                                      een interval day to second wordt opgegeven
   29-03-2023  Nico Klaver       01.30.00  trunc_tz toegevoegd
   05-04-2023  Nico KLaver       01.31.00  Dubbele conversies van local naar utc en viceversa verwijderd, round_ts toegevoegd
   25-04-2023  X. Pikaar         01.32.00  Ophalen PERIOD_TO_PUBLISH_START en PERIOD_TO_PUBLISH_END via sup_ojtppy_actions i.p.v. een directe select into
   14-09-2023  X. Pikaar         01.33.00  Functie get_hours_between_2_dates hield er geen rekening mee als de to_date in de wintertijd
                                           van het volgende jaar lag. Dan werd er een uur te weinig berekend.
   09-01-2023  R. Brinker        01.34.00  TRAN-6565 Fout weeknummer in Webpublication: ATR_09 Settled imbalance volumes
   15-01-2024  Nico Klaver       01.34.01  TRAN-6565 dag 1 is zondag en dag 7 is zaterdag
   24-01-2024  R. Brinker        01.34.02  TRAN-6565 dagnummers zijn ruk, over naar dagnamen
   23-02-2024  Nico Klaver       01.34.03  TRAN-6214 local/utc functies moeten controleren of er wel een datum is aangeleverd
   27-06-2024  X. Pikaar         01.35.00  Functies compute_easter en get_day_type toegevoegd
   12-03-2025  Xander Pikaar     01.36.00  Functie get_previous_workday toegevoegd
   08-07-2025  Xander Pikaar     01.37.00  Geen session-settings aanpassen in get_day_type en get_previous_workday omdat deze vanuit 
                                           materialized views aangeroepen worden, dat levert een "ORA-30372: Toegangspolicy met fijne 
                                           structuur conflicteert met snapshot." op
   22-10-2025  Nico KLaver       01.38.00  TRAN-6727: exec_expression function voor het executeren van date expressions. Deze
                                           functie werkt met UTC. Voor ZW ellende is correct period toegevoegd die de periode netjes
                                           laat lopen van het begin van een dag naar het einde van de dag (lokaal) wanneer het
                                           een periode van hele dagen betreft.         
  ***********************************************************************************************************************************/
  cn_package                      constant  varchar2(100) := 'sup_date_actions';
  cn_versionnumber                constant  varchar2(100) := '01.38.00';

  cn_hour_min_res_pattern         constant  varchar2(100) := '^PT[[:digit:]]+(S|M|(H|H([[:digit:]]+M+)))$';

  function get_versionnumber
    return varchar2
  is
    -- return versionnumber
  begin
    return cn_versionnumber;
  end get_versionnumber;

  function trunc_local_new
    ( p_utc_date in date
    , p_fmt      in varchar2 default null
    )
    return date is
  /************************************************************************************************************************************
   Purpose:  Wrapper voor de standaard Oracle TRUNC functie. Resultaat is een trunc op de LOCAL timestamp
             Input en output zijn UTC datums
  ************************************************************************************************************************************/
     v_trunc_date                                date;
     v_local_date                                date;
  begin
    if  p_fmt is not null 
    and lower(p_fmt) in ('hh', 'hh12', 'hh24', 'mi') then
       --
       -- Geen correctie nodig
       v_trunc_date := trunc(p_utc_date, p_fmt);
    else
       -- Zet om naar een local date 
       v_local_date := convertutc2local(p_utc_date => p_utc_date);
       -- Voer de TRUNC uit 
       v_trunc_date := case
                        when p_fmt is null then trunc(v_local_date)
                        else                    trunc(v_local_date, p_fmt)
                     end;

       -- Terug naar UTC no worries we zitten nooit open een "enge" datum/tijd
       v_trunc_date  := convertlocal2utc(p_loc_date => v_trunc_date);
    end if;
    
    return v_trunc_date;
  end trunc_local_new;

  function create_statement
    ( p_bvalidity_expr in varchar2
    )
    return varchar2 deterministic is
    /************************************************************************************************************************************
     Purpose:  Creeer het statement voor het bepalen van de bvalidity
    ************************************************************************************************************************************/
    cn_module                 constant varchar2(100) := cn_package || '.create_statement';
    cn_trunc_local            constant varchar2(100) := 'sup_date_actions.trunc_local_new(';

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

    -- Vervang trunc( door sup_date_actions.trunc_local_new(
    -- p_checktime is een utc date, we rekenen echter met met UTC timestamps zodat we een truc moeten uithalen
    -- de functie sup_date_actions.trunc_local_new levert een trunc op van de local date echter met een UTC input
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

  function zw_code(p_utc_date in date) return char is
    /************************************************************************************************************************************
     Purpose:  Bepaal of de datum (UTC) in Zomer of Wintertijd ligt
    ************************************************************************************************************************************/
     v_zw_date date;   -- Tijdstip overgang zomer- naar wintertijd
     v_wz_date date;   -- Tijdstip overgang winter- naar zomertijd

     v_zw_code char(1); -- W: Wintertijd Z: Zomertijd
  begin
     -- UTC datum/tijd overgang zomer- naar wintertijd en vice versa
     v_zw_date := date_summerwinterchange(extract(year from p_utc_date)) + interval '01' hour;
     v_wz_date := date_wintersummerchange(extract(year from p_utc_date)) + interval '01' hour;
     if p_utc_date < v_wz_date or p_utc_date >= v_zw_date then
        -- Wintertijd
        v_zw_code := 'W';
     else 
        -- zomertijd
        v_zw_code := 'Z';
     end if;
     
     return v_zw_code;
  end zw_code;     
     
  function local_timezone_offset( p_date       in date
                                , p_timezone   in varchar2  default sup_constants.cn_loc_timezone
                                )
    return varchar2
  is
    /******************************************************************************************************************************
     Purpose    : Returns the offset in hours for the local time zone at the timestamp submitted
     Remarks    :

    ******************************************************************************************************************************/
    cn_module                     constant  varchar2(100) := cn_package || '.local_timezone_offset';

    cn_no_dst_offset  constant varchar2(10) := '+01:00';--wintertijd
    cn_dst_offset     constant varchar2(10) := '+02:00';--zomertijd
    v_dst_start                date;
    v_dst_end                  date;
    v_year                     number(4);
    v_return                   varchar2(10);
  begin
    --bepaal begin- en eindmoment van de zomertijd
    v_year                             := extract(year from p_date);
    v_dst_start                        := date_wintersummerchange(v_year);
    v_dst_end                          := date_summerwinterchange(v_year);
    --
    if p_timezone = sup_constants.cn_utc_timezone then
      v_dst_start                      := v_dst_start + 1/24;
      v_dst_end                        := v_dst_end   + 1/24;
    else
      v_dst_start                      := v_dst_start + 2/24;
      v_dst_end                        := v_dst_end   + 2/24;
    end if;
    --
    case
      --vang het niet bestaande uur in de overgang van winter- naar zomertijd af.
      --Ga er van uit dat de klok nog op wintertijd staat/stond.
      when  p_timezone = sup_constants.cn_loc_timezone
        and p_date     > v_dst_start
        and p_date     < v_dst_start + 1/24
      then
        v_return                       := cn_no_dst_offset;
      --vang het dubbele uur in de overgang vann zomer- naar wintertijd af
      --en probeer het op te lossen. Lukt dat niet, dan gaan we uit van wintertijd
      when p_timezone = sup_constants.cn_loc_timezone
       and p_date     > v_dst_end
       and p_date     < v_dst_end + 1/24
      then
          v_return                     := cn_no_dst_offset;
      when p_date     <= v_dst_start
        or p_date     >= v_dst_end then
          v_return                     := cn_no_dst_offset;
      else
          v_return                     := cn_dst_offset;
    end case;
    --
    return v_return;
  end local_timezone_offset;

  function translate_resolution_2_minutes(p_resolution           in varchar2
                                         )
    return number
  is
    /******************************************************************************************************************************
     Purpose    : Returns the amount of minutes for a given resolution
     Remarks    : we expect p_resolution to be either PT*S, PT*M, PT*H, PT*H*M

    ******************************************************************************************************************************/
    cn_module                     constant  varchar2(100) := cn_package || '.translate_resolution_2_minutes';
    v_amount_of_minutes                     number(15,5);

    e_unknown_resolution                    exception;
  begin
    if p_resolution like 'PT%H%M' then
       v_amount_of_minutes             := substr(p_resolution, 3, instr(p_resolution, 'H') - 3) * 60  -- van uren naar minuten
                                       +  substr(p_resolution, instr(p_resolution, 'H') + 1, length(p_resolution) - (instr(p_resolution, 'M') - 2)); -- De minuten
    elsif p_resolution    like 'PT%M' then
       v_amount_of_minutes             := replace(replace(p_resolution, 'PT',''),'M','');
    elsif p_resolution like 'PT%S' then
       v_amount_of_minutes             := replace(replace(p_resolution, 'PT',''),'S','') / 60;
    elsif p_resolution like 'PT%H' then
       v_amount_of_minutes             := replace(replace(p_resolution, 'PT',''),'H','') * 60;
    else
        null;
    end if;

    if v_amount_of_minutes is null then
       raise e_unknown_resolution;
    end if;

    return v_amount_of_minutes;
  exception
    when e_unknown_resolution then
      raise_application_error(-20999,  cn_module ||':  Resolution ' || p_resolution || ' not supported');
    when others then
      raise;
  end translate_resolution_2_minutes;

  function translate_hours_to_resolution (p_hours  in number)
     return varchar2
  is
     cn_module        constant varchar2(61) := cn_package || '.translate_hours_to_resolution';
     v_resolution              varchar2(10);
  begin
    if p_hours < 1 then
       -- Kleiner dan een uur zetten we om naar PT..M
       v_resolution            := 'PT' || p_hours * 60 || 'M';
    elsif p_hours > 1
    and trunc(p_hours) != p_hours then -- dan heb je dus decimalen
       v_resolution            := 'PT' || trunc(p_hours) || 'H' || ((p_hours - trunc(p_hours)) * 60) || 'M';
    elsif mod(p_hours, 24) = 0 then
       -- Als we de uren naar dagen om kunnen zetten maken we er P.D van
       v_resolution            := 'P' || p_hours / 24 || 'D';
    else
       -- En anders PT..H
       v_resolution            := 'PT'|| p_hours || 'H';
    end if;

    return v_resolution;
  exception
    when others then
      raise;
  end translate_hours_to_resolution;

  function convert_any_date2timestamp_utc (p_text_date  in varchar2)
    return timestamp
  is
    /*********************************************************************************************************************
     Converteren van een datum die in een varchar-formaat wordt aangeleverd naar een UTC timestamp
     De functie probeert a.d.h.v. het datum formaat de vertaling te maken
      ondersteunde formaten:
       - 'yyyy-mm-dd hh24:mi"Z"'
       - 'yyyy-mm-dd hh24:mi:ss"Z"'
       - 'yyyy-mm-dd hh24:mi:ss.ff"Z"'
       - 'yyyy-mm-dd hh24:mi'
       - 'yyyy-mm-dd hh24:mi:ss'
       - 'yyyy-mm-dd hh24:mi:sstzh:tzm'
       - 'yyyy-mm-dd hh24:mi:ss.fftzh:tzm
       - 'yyyy-mm-dd hh24:mi:ss.ff'
       - 'yyyy-mm-dd"T"hh24:mi"Z"'
       - 'yyyy-mm-dd"T"hh24:mi:ss"Z"'
       - 'yyyy-mm-dd"T"hh24:mi:ss.ff"Z"'
       - 'yyyy-mm-dd"T"hh24:mi'
       - 'yyyy-mm-dd"T"hh24:mi:ss'
       - 'yyyy-mm-dd"T"hh24:mi:sstzh:tzm'
       - 'yyyy-mm-dd"T"hh24:mi:ss.fftzh:tzm
       - 'yyyy-mm-dd"T"hh24:mi:ss.ff'
       - 'dd-mm-yyyy'
       - 'dd.mm.yyyy'
      Het datum deel mag ook in dd-mm-yyyy formaat staan en ook de Duitse schrijfwijze (dd.mm.yyyy) wordt ondersteund
      Eventueel voorlophekje wordt verwijderd

     Invoer  : varchar2
     Uitvoer : timestamp
    **********************************************************************************************************************/
    cn_module                     constant  varchar2(100) := cn_package || '.convert_any_date2timestamp_utc';

    v_ts_tz                           timestamp with time zone;
    v_return_ts                       timestamp;
    v_date                            varchar2(100);
  begin
    -- Zet expliciet de datumformaat van de timestamp_tz om te voorkomen dat de databaseinstellingen anders staan waardoor de conversie
    -- niet werkt. Het lijkt erop dat dit alleen voor de timezone_tz nodig is
    sup_utilities.keep_nls_timestamp_tz_format;
    sup_utilities.set_nls_timestamp_tz_format;

    if trim(p_text_date) is null then
       pcs_log_actions.log_error(p_module => cn_module
                                       ,p_text   => 'Input parameter p_text_date is empty! '
                                );
      v_return_ts                      := null;
    else
       -- trim de binnenkomende datum om eventuele problemen door voor- of naloop spaties te voorkomen
       v_date                             := trim(p_text_date);
       -- Het kan zijn dat we van de OSB een hekje voor de datum krijgen. Die moeten we eraf halen
       v_date                             := ltrim(p_text_date, '#');
       -- Vertaal eerst de eventuele 'T' naar een spatie, dan hoeven we daar verder geen rekening mee te houden
       v_date                             := replace(v_date, 'T',' ');
       -- zet eventuele slashes in de datum om naar '-'
       v_date                             := replace(v_date, '/', '-');
       -- zet eventuele punten (Duits formaat) in de datum om naar '-'. Alleen de eerste 10 posities (het datum deel) pakken, het tijddeel er daarna weer aanplakken
       v_date                             := replace(substr(v_date,1,10), '.', '-') || substr(v_date, 11, length(v_date) -10);

       -- Bekijk of we formaat dd-mm-yyyy hebben ontvangen, dan gaan we die vertalen naar yyyy-mm-dd. mm-dd-yyyy zou natuurlijk niet gaan
       if  substr(v_date, 3, 1) = '-'
       and substr(v_date, 6, 1) = '-' then
         v_date                           := substr(v_date, 7,4)
                                          || '-'
                                          || substr(v_date, 4,2)
                                          || '-'
                                          || substr(v_date, 1,2)
                                          || substr(v_date, 11, length(v_date) -10);
       end if;

       -- d-mm-yyyy
       if  substr(v_date, 2, 1) = '-'
       and substr(v_date, 5, 1) = '-' then
         v_date                           := substr(v_date, 6,4)
                                          || '-'
                                          || substr(v_date, 3,2)
                                          || '-0'
                                          || substr(v_date, 1,1)
                                          || substr(v_date, 10, length(v_date) -9);
       end if;

       -- dd-m-yyyy
       if  substr(v_date, 3, 1) = '-'
       and substr(v_date, 5, 1) = '-' then
         v_date                           := substr(v_date, 6,4)
                                          || '-0'
                                          || substr(v_date, 4,1)
                                          || '-'
                                          || substr(v_date, 1,2)
                                          || substr(v_date, 10, length(v_date) -9);
       end if;

       -- d-m-yyyy
       if  substr(v_date, 2, 1) = '-'
       and substr(v_date, 4, 1) = '-' then
         v_date                           := substr(v_date, 5,4)
                                          || '-0'
                                          || substr(v_date, 3,1)
                                          || '-0'
                                          || substr(v_date, 1,1)
                                          || substr(v_date, 9, length(v_date) -8);
       end if;

       -- maak de correcte tzh:tzm aan voor de datum en houdt rekening met zomertijd (alleen voor formats zonder tijdzone informatie)
       if      substr(v_date, -1, 1) != 'Z'
       and (   length(v_date)in (16, 19)
            or (    length(v_date)         > 20
                   and substr(v_date, 20, 1)  = '.'
                and substr(v_date, -3, 1) != ':'
                  )
              )
       then
         v_date                    := v_date || local_timezone_offset( p_date  => to_date(substr(v_date,1,16), 'yyyy-mm-dd hh24:mi'));
       end if;

       -- Als de laatste positie een Z is, is het ZULU-time, dus UTC. Anders is het local en moeten we vertalen
       case
         when length (v_date) = 10
          and substr(v_date, 5, 1) = '-'
          and substr(v_date, 8, 1) = '-' then
          -- yyyy-mm-dd, zonder tijdscomponent
              v_return_ts     := convertlocal2utc(cast(to_date(v_date,'yyyy-mm-dd') as timestamp));
         when substr(v_date, -1, 1)  = 'Z'
          and length(v_date)         = 17 then
              -- bv 2017-06-27 09:00Z
              --v_return_ts     := to_timestamp_tz(v_date,'yyyy-mm-dd hh24:mi"Z"');
              v_return_ts     := cast(to_date(v_date,'yyyy-mm-dd hh24:mi"Z"') as timestamp);
         when substr(v_date, -1, 1)  = 'Z'
          and length(v_date)         = 20 then
              -- bv 2017-06-27 09:00:29Z
              v_return_ts     := cast(to_date(v_date,'yyyy-mm-dd hh24:mi:ss"Z"') as timestamp);
         when substr(v_date, -1, 1)  = 'Z'
          and length(v_date)         > 20 then
              -- bv 2017-06-27 09:01:03.225062Z
              v_return_ts     := cast(to_timestamp_tz(v_date, 'yyyy-mm-dd hh24:mi:ss.ff"Z"') as timestamp);
         when substr(v_date, -1, 1) != 'Z'
          and length(v_date)         = 16 then
              -- bv 2017-06-27 09:01
              v_return_ts     := convertlocal2utc(cast(to_date(v_date,'yyyy-mm-dd hh24:mi') as timestamp));
         when substr(v_date, -1, 1) != 'Z'
          and length(v_date)         = 19 then
              -- bv 2017-06-27 09:01:33
              v_return_ts     := convertlocal2utc(cast(to_date(v_date,'yyyy-mm-dd hh24:mi:ss') as timestamp));
         when substr(v_date,-1, 1)  != 'Z'
          and length(v_date)         = 25 then
              -- bv 2017-06-27 08:57:18+02:00
              v_return_ts     := convertlocal2utc_ts(to_timestamp_tz(v_date,'yyyy-mm-dd hh24:mi:sstzh:tzm'));
         when substr(v_date,-1, 1)  != 'Z'
          and length(v_date)         = 22 then
              -- bv 2017-06-27 08:57+02:00
              v_return_ts     := convertlocal2utc_ts(to_timestamp_tz(v_date,'yyyy-mm-dd hh24:mitzh:tzm'));
         when substr(v_date,-1, 1)  != 'Z'
          and length(v_date)         > 20
          and substr(v_date, 20, 1)  = '.'
          and substr(v_date, -3, 1)  = ':' then
              -- bv 2017-06-27 09:57:18.983619+02:00
              v_return_ts     := convertlocal2utc_ts(to_timestamp_tz(v_date,'yyyy-mm-dd hh24:mi:ss.fftzh:tzm'));
         when substr(v_date,-1)     != 'Z'
          and length(v_date)         > 20
          and substr(v_date, 20, 1)  = '.'
          and substr(v_date, -3, 1) != ':' then
              -- bv 2017-06-27 09:02:21.406125
              v_return_ts     := convertlocal2utc(to_timestamp(v_date,'yyyy-mm-dd hh24:mi:ss.ff'));
         when length(v_date)         = 28
          and substr(v_date,3,1)     = '-'
          and regexp_instr(substr(v_date, 4,3), '[a-zA-Z]') > 0
          and substr(v_date,13,1)    = '.' then
             -- bv 04-DEC-17 09.18.06.000000 PM
             v_return_ts      := convertlocal2utc(to_timestamp(v_date,'dd-mon-rr hh.mi.ss.ff AM'));
         when length(v_date)         = 28
          and substr(v_date,3,1)     = '-'
          and regexp_instr(substr(v_date, 4,3), '[a-zA-Z]') > 0
          and substr(v_date,13,1)    = ':' then
             -- bv 04-DEC-17 09:18:06.000000 PM
             v_return_ts      := convertlocal2utc(to_timestamp(v_date,'dd-mon-rr hh:mi:ss.ff AM'));
         when length(v_date)         = 25
          and substr(v_date,3,1)     = '-'
          and regexp_instr(substr(v_date, 4,3), '[a-zA-Z]') > 0
          and substr(v_date,13,1)    = '.' then
             -- bv 04-DEC-17 09.18.06.000000
             v_return_ts      := convertlocal2utc(to_timestamp(v_date,'dd-mon-rr hh24.mi.ss.ff'));
         when length(v_date)         = 25
          and substr(v_date,3,1)     = '-'
          and regexp_instr(substr(v_date, 4,3), '[a-zA-Z]') > 0
          and substr(v_date,13,1)    = ':' then
             -- bv 04-DEC-17 09:18:06.000000
             v_return_ts      := convertlocal2utc(to_timestamp(v_date,'dd-mon-rr hh24:mi:ss.ff'));
         else
              pcs_log_actions.log_error(p_module => cn_module
                                       ,p_text   => 'Invalid date format!'
                                      || chr(10) || '  p_text_date: ' || p_text_date
                                        );
              v_return_ts       := null;
       end case;
    end if;

    sup_utilities.reset_nls_timestamp_tz_format;

    return v_return_ts;
  exception
    when others then
      raise;
  end convert_any_date2timestamp_utc;

  function convertutc2local(p_utc_date in timestamp)
     return timestamp
  is
    /*********************************************************************************************************************
     Converteren van een UTC timestamp naar de locale timestamp
     Invoer  : timestamp
     Uitvoer : timestamp
    **********************************************************************************************************************/
    cn_module                     constant  varchar2(100) := cn_package || '.convertutc2local';

    v_return_date        timestamp with time zone;

  begin
    v_return_date                 := from_tz(p_utc_date
                                            ,sup_constants.cn_offset_utc) at time zone sup_constants.cn_loc_timezone;

    return cast(v_return_date as timestamp);

  exception
    when others then
      raise;
  end convertutc2local;

  function convertlocal2utc(p_loc_date in timestamp)
    return timestamp
  is
    /*********************************************************************************************************************
     Converteren van een locale timestamp naar de UTC timestamp
     Invoer  : timestamp
     Uitvoer : timestamp
    **********************************************************************************************************************/
    cn_module                     constant varchar2(100) := cn_package || '.convertlocal2utc';

    v_loc_date                             timestamp with time zone;
    v_utc_plus_date                        timestamp with time zone;
    v_utc_date                             timestamp with time zone;
    v_return_date                          timestamp;
    v_local_tz                             varchar2(8);
  begin
    -- Het is mogelijk dat we een lokale tijd binnen krijgen die op de winter-/zomertijd overgang tussen 02:00 en 03:00 valt. Dat komt
    -- omdat in de datum geen timezone zit. Dat gaat helemaal mis omdat het lokaal geen bestaande tijd is. Als we dat foute uurtje
    -- binnenkrijgen een uurtje bij de tijd optellen ter correctie.
    <<convert>>
    begin
      v_loc_date                    := p_loc_date at time zone sup_constants.cn_loc_timezone;
      v_local_tz                    := to_char(v_loc_date, 'TZH:TZM');
      -- Verander de timezone naar een UTC + tijdzone om de DST van Oracle te negeren
      execute immediate 'alter session set time_zone = '''||v_local_tz||'''';
      v_utc_plus_date               := p_loc_date at time zone v_local_tz;
    exception when others then
      --Issue waarbij de lokale tijd niet bestaat: b.v. 02:00 AM - 02:59 AM niet in Europe/Amsterdam tijzone.
      --Pak dezelfde tijd een dag later om de UTC + tijdzone af te leiden
      v_loc_date                    := p_loc_date + numtodsinterval(1, 'DAY');
      v_local_tz                    := to_char(v_loc_date at time zone sup_constants.cn_loc_timezone, 'TZH:TZM');
      -- Verander de timezone naar een UTC + tijdzone om de DST van Oracle te negeren
      execute immediate 'alter session set time_zone = '''||v_local_tz||'''';
      v_utc_plus_date               := p_loc_date at time zone v_local_tz;
    end convert;

    -- Haal het tijdverschil tussen UTC + en UTC van de lokale tijd af (dan hebben we dus de UTC-tijd in de UTC + tijdzone)
    v_utc_plus_date                 := v_utc_plus_date - numtodsinterval(to_number(substr(v_local_tz, 1, instr(v_local_tz, ':')-1)), 'HOUR');
    -- Koppel de UTC-tijdzone aan de timestamp. Dan is het echt UTC
    v_utc_date                      := to_timestamp_tz(to_char(v_utc_plus_date, 'dd-mm-yyyy hh24:mi:ss')||'+0:00','dd-mm-yyyy hh24:mi:ssxff tzh:tzm');

    v_return_date                   := v_utc_date;
    -- Verander de timezone terug naar de lokale tijdzone
    execute immediate 'alter session set time_zone = '''||sup_constants.cn_loc_timezone||'''';
    return v_return_date;

  exception
    when others then
      execute immediate 'alter session set time_zone = '''||sup_constants.cn_loc_timezone||'''';
      raise;

  end convertlocal2utc;

  function convertutc2local_ts(p_ts_tz in timestamp with time zone )
     return timestamp with time zone
   is
    /*********************************************************************************************************************
       Converteren van een UTC datum/tijd naar de locale timestamp
       Invoer  : timestamp
       Uitvoer : timestamp
    **********************************************************************************************************************/
    cn_module                     constant  varchar2(100) :=  cn_package || '.convertutc2local_ts';

      v_return_date timestamp with time zone;
  begin
    v_return_date                 := from_tz(p_ts_tz
                                            ,sup_constants.cn_offset_utc) at time zone sup_constants.cn_loc_timezone;
    return v_return_date;

  exception
    when others then
      raise;
  end convertutc2local_ts;

  function convertlocal2utc_ts(p_ts_tz in timestamp with time zone )
    return timestamp with time zone
  is
    /*********************************************************************************************************************
     Converteren van een locale timestamp naar UTC timestamp
     Invoer  : timestamp
     Uitvoer : timestamp
    **********************************************************************************************************************/
    cn_module                     constant  varchar2(100) := cn_package || '.convertlocal2utc_ts';

    v_local_date  timestamp with time zone;
    v_return_date timestamp with time zone;

    v_offset      varchar2(10);
    v_year        varchar2(4);

  begin
    v_offset                      := to_char(p_ts_tz, 'tzh:tzm');

    v_local_date                  := to_timestamp_tz(to_char(p_ts_tz,'dd-mm-yyyy hh24:mi:ssxff') || ' ' || v_offset
                                                    ,'dd-mm-yyyy hh24:mi:ssxff tzh:tzm'
                                                    );

    v_year                        := to_char(v_local_date,'yyyy');

    -- Zet de off-set juist, ongeacht de offset die we binnenkrijgen. Hiermee voorkomen we problemen met datum in de zomertijd
    -- terwijl we zelf in de wintertijd zitten en andersom
    if    date_wintersummerchange(p_year => v_year) = trunc(v_local_date)
      and to_number(to_char(v_local_date,'hh24'))   < 02
      and v_offset                                  = '+02:00' then
         -- De datum ligt op de w/z dag, maar nog in de wintertijd en wij zitten al in de zomertijd
         v_local_date := to_timestamp_tz(to_char(p_ts_tz,'dd-mm-yyyy hh24:mi:ssxff') || ' ' || '+01:00'
                                                        ,'dd-mm-yyyy hh24:mi:ssxff tzh:tzm'
                                         );
    elsif date_wintersummerchange(p_year => v_year) = trunc(v_local_date)
      and to_number(to_char(v_local_date,'hh24'))   < 02
      and v_offset                                  = '+01:00' then
         -- De datum ligt op de w/z dag, in de wintertijd en wij zitten al in de wintertijd, helemaal goed
         null;
    elsif date_summerwinterchange(p_year => v_year) = trunc(v_local_date)
      and to_number(to_char(v_local_date, 'hh24')) > 02
      and v_offset                                  = '+02:00' then
          -- De datum ligt op de z/w-dat in de wintertijd, maar wij zitten nog in de zomertijd (datum in de toekomst)
         v_local_date := to_timestamp_tz(to_char(p_ts_tz,'dd-mm-yyyy hh24:mi:ssxff') || ' ' || '+01:00'
                                                        ,'dd-mm-yyyy hh24:mi:ssxff tzh:tzm'
                                        );
    elsif  date_wintersummerchange(p_year => v_year) > trunc(v_local_date)
    and v_offset                                  = '+02:00' then
       -- De datum zit nog in de wintertijd, maar wij zitten al in de zomertijd (datum in het verleden)
       v_local_date := to_timestamp_tz(to_char(p_ts_tz,'dd-mm-yyyy hh24:mi:ssxff') || ' ' || '+01:00'
                                                       ,'dd-mm-yyyy hh24:mi:ssxff tzh:tzm'
                                       );
    elsif date_wintersummerchange(p_year => v_year) > trunc(v_local_date)
      and v_offset                                  = '+01:00' then
      -- De datum zit in de wintertijd en wij zitten ook in de wintertijd. Dan is het goed
      -- deze hebben we nodig omdat de datum voor de W/Z overgang kan zitten, dan zit hij ook voor de Z/W overgang (volgende elsif)
         null;
    elsif date_summerwinterchange(p_year => v_year) < trunc(v_local_date)
      and v_offset                                  = '+02:00' then
         -- de datum ligt al in de wintertijd, maar wij zitten nog in de wintertijd (datum ligt in de toekomst)
         v_local_date := to_timestamp_tz(to_char(p_ts_tz,'dd-mm-yyyy hh24:mi:ssxff') || ' ' || '+01:00'
                                                        ,'dd-mm-yyyy hh24:mi:ssxff tzh:tzm'
                                         );
    elsif date_summerwinterchange(p_year => v_year) > trunc(v_local_date)
      and v_offset                                  = '+01:00' then
         -- de datum ligt nog in de zomertijd, maar wij zitten al in de wintertijd (datum in het verleden)
         v_local_date := to_timestamp_tz(to_char(p_ts_tz,'dd-mm-yyyy hh24:mi:ssxff') || ' ' || '+02:00'
                                                        ,'dd-mm-yyyy hh24:mi:ssxff tzh:tzm'
                                         );
    end if;

    v_return_date                 := v_local_date at time zone 'UTC';

    return v_return_date;

  exception
    when others then
      raise;
  end convertlocal2utc_ts;

  function get_utc_timeinterval_by_ptu(p_utc_datetime        in date
                                      ,p_interval_in_minutes in number
                                      ,p_ptu                 in number
                                      )
    return rt_interval
  /******************************************************************************************************************************
   Project    : DELPHI
   Purpose    : For curvetype A01 Fixed BlockSize for ordered fixed interval lists of PTU's, f.e. 1,2,3,4,5
                Returns startdatetime en enddatetime in UTC for given datetime in UTC, interval and which ptu
                ptu 1 starts at <p_utc_datetime> and ends one step further at <p_utc_datetime>+<p_interval_in_minutes>
   Remarks    : we expect p_interval_in_minutes to be either 5, 15 or 60
                we expect p_ptu at least 1

  ******************************************************************************************************************************/
  is
    cn_module                     constant varchar2(100) := cn_package ||'.get_utc_timeinterval_by_ptu';

    v_utc_datetime        date  ;
    v_interval_in_minutes number(15,5);
    v_ptu                 number(5);

    r_interval            rt_interval;
    e_invalid_ptu         exception;
  begin
    v_utc_datetime        := p_utc_datetime       ;
    v_interval_in_minutes := p_interval_in_minutes;
    v_ptu                 := p_ptu                ;

    --checks
    if v_ptu < 1
    then
      raise e_invalid_ptu;
    end if;

    -- walk through time starting at v_utc_datetime with steps of v_interval_in_minutes
    r_interval.starttime := v_utc_datetime + (v_ptu-1) * (v_interval_in_minutes) * (1/24/60);
    r_interval.endtime   := v_utc_datetime + (v_ptu  ) * (v_interval_in_minutes) * (1/24/60);

    return r_interval;
  --
  exception
    when e_invalid_ptu
    then
      raise_application_error(-20901, cn_module ||' Started with '
                                                || ' p_utc_datetime        : '||to_char(p_utc_datetime,sup_constants.cn_utc_date_format)
                                                || ' p_interval_in_minutes : '||p_interval_in_minutes
                                                || ' p_ptu                 : '||p_ptu
                             );
    when others
    then
      raise;
  end get_utc_timeinterval_by_ptu;
  --

  function get_utc_timeinterval_by_ptu(p_utc_datetime        in date
                                      ,p_interval_in_minutes in number
                                      ,p_ptu_start           in number
                                      ,p_ptu_eind            in number
                                      )
    return rt_interval
  is
  /******************************************************************************************************************************
   Project    : DELPHI
   Purpose    : For curvetype A03 Variable BlockSize for varable interval lists of PTU's, f.e. 1,2,3,7,8,12
                Returns startdatetime en enddatetime in UTC for given datetime in UTC, interval and ptu_start/eind
   Remarks    : we expect p_interval_in_minutes to be either 5, 15 or 60
                p_ptu_start at least 1
                p_ptu_eind can be NULL; in that case the returned record endtime will be empty.
                If p_ptu_eind is present it should be larger than v_ptu_start

  ******************************************************************************************************************************/
    cn_module                     constant varchar2(100) := cn_package ||'.get_utc_timeinterval_by_ptu';

    v_utc_datetime        date  ;
    v_interval_in_minutes number(15,5);
    v_ptu_start           number(5);
    v_ptu_eind            number(5);

    r_interval            rt_interval;
    e_invalid_ptu         exception;
  begin
    v_utc_datetime        := p_utc_datetime       ;
    v_interval_in_minutes := p_interval_in_minutes;
    v_ptu_start           := p_ptu_start          ;
    v_ptu_eind            := p_ptu_eind           ;

    --checks
    if (   v_ptu_start < 1
        or nvl(v_ptu_eind,999) < 1
       )
    or (    v_ptu_eind is not null
        and v_ptu_eind <= v_ptu_start
       )
    then
      raise e_invalid_ptu;
    end if;

    -- walk through time starting at v_utc_datetime with steps of v_interval_in_minutes
    r_interval.starttime := v_utc_datetime + (v_ptu_start - 1) * (v_interval_in_minutes) * (1/24/60);
    if v_ptu_eind is not null then
      r_interval.endtime := v_utc_datetime + (v_ptu_eind - 1 ) * (v_interval_in_minutes) * (1/24/60);
    else
      r_interval.endtime := null;   -- explicit nullify and 2 please Sonar..
    end if;

    return r_interval;
  --
  exception
    when e_invalid_ptu
    then
      raise_application_error(-20901, cn_module ||' Started with '
                                                || ' p_utc_datetime        : '||to_char(p_utc_datetime,sup_constants.cn_utc_date_format)
                                                || ' p_interval_in_minutes : '||p_interval_in_minutes
                                                || ' p_ptu_start           : '||p_ptu_start
                                                || ' p_ptu_eind            : '||nvl(to_char(p_ptu_eind), '<leeg>')
                               );
    when others
    then
      raise;
  end get_utc_timeinterval_by_ptu;

  function get_utc_startmoment_by_ptu(p_utc_datetime        in date
                                     ,p_interval_in_minutes in number
                                     ,p_ptu                 in number
                                     )
    return timestamp
    /******************************************************************************************************************************
     Project    : DELPHI
     Purpose    : Returns startdatetime in UTC for given datetime in UTC, interval and which pte
     Remarks    : we expect p_interval_in_minutes to be either 5, 15 or 60
                  we expect p_ptu at least 1

    ******************************************************************************************************************************/
  is
    cn_module                     constant  varchar2(100) := cn_package || '.get_utc_startmoment_by_ptu';

    r_interval                              rt_interval;
  begin
    r_interval                    := sup_date_actions.get_utc_timeinterval_by_ptu(p_utc_datetime        => p_utc_datetime
                                                                                 ,p_interval_in_minutes => p_interval_in_minutes
                                                                                 ,p_ptu                 => p_ptu
                                                                                 );
    return r_interval.starttime;

  exception
    when others then
      raise;
  end get_utc_startmoment_by_ptu;

  function get_utc_endmoment_by_ptu(p_utc_datetime        in date
                                   ,p_interval_in_minutes in number
                                   ,p_ptu                 in number
                                   )
    return timestamp
    /******************************************************************************************************************************
     Project    : DELPHI
     Purpose    : Returns enddatetime in UTC for given datetime in UTC, interval and which pte
     Remarks    : we expect p_interval_in_minutes to be either 5, 15 or 60
                  we expect p_ptu at least 1

    ******************************************************************************************************************************/
  is
    cn_module                     constant  varchar2(100) := cn_package || '.get_utc_startmoment_by_ptu';

    r_interval                              rt_interval;
  begin
    r_interval := sup_date_actions.get_utc_timeinterval_by_ptu(p_utc_datetime        => p_utc_datetime
                                                              ,p_interval_in_minutes => p_interval_in_minutes
                                                              ,p_ptu                 => p_ptu
                                                              );

    return r_interval.endtime;
  exception
    when others then
      raise;
  end get_utc_endmoment_by_ptu;

  function date_summerwinterchange(p_year in number)
    return date deterministic
  is
    /******************************************************************************************************************************
     Purpose    : Returns the summer-/wintertime changedate in a given year (last sunday in October)

    ******************************************************************************************************************************/
    cn_module                     constant  varchar2(100) := cn_package || '.date_summerwinterchange';
    v_return_date                           date;
    v_nls_date_language                     varchar2(100);
    v_stmt                                  varchar2(200);

  begin
    -- Als we geen jaar binnenkrijgen de hele selectie overslaan om een ORA-01840 te voorkomen. Vanuit views is het mogelijk dat
    -- we b.v. een convertlocal2utc doen zonder datum. Dan kan van die datum ook niet de zomer-/wintertijdovergang bepaald worden.
    if p_year is null then
       v_return_date              := null;
    else
       -- Huidige datum-instelling bewaren
       select value into v_nls_date_language  from v$nls_parameters where parameter = 'NLS_DATE_LANGUAGE';
       -- Dan de datum-instelling op Amerikaans zetten zodat het goed gaat met de dag "sunday"
       execute immediate 'alter session set NLS_DATE_LANGUAGE=''AMERICAN'' ';

       v_return_date              := next_day(last_day(to_date('01-10-' || p_year, 'dd-mm-rrrr')) -7, 'sunday');

       -- Zet de datum-taal weer terug op wat hij was.
       v_stmt := 'alter session set nls_date_language = ''' || v_nls_date_language || ''' ';
       execute immediate v_stmt;
    end if;

    return v_return_date;
  exception
    when others then
      raise;
  end date_summerwinterchange;

  function date_wintersummerchange(p_year in number)
    return date deterministic
  is
    /******************************************************************************************************************************
     Purpose    : Returns the winter-/summertime changedate in a given year (last sunday in March)

    ******************************************************************************************************************************/
    cn_module                     constant  varchar2(100) := cn_package || '.date_wintersummerchange';
    v_return_date                           date;
    v_nls_date_language                     varchar2(100);
    v_stmt                                  varchar2(200);

  begin
    -- Als we geen jaar binnenkrijgen de hele selectie overslaan om een ORA-01840 te voorkomen. Vanuit views is het mogelijk dat
    -- we b.v. een convertlocal2utc doen zonder datum. Dan kan van die datum ook niet de zomer-/wintertijdovergang bepaald worden.
    if p_year is null then
       v_return_date              := null;
    else
       -- Huidige datum-instelling bewaren
       select value into v_nls_date_language  from v$nls_parameters where parameter = 'NLS_DATE_LANGUAGE';
       -- Dan de datum-instelling op Amerikaans zetten zodat het goed gaat met de dag "sunday"
       execute immediate 'alter session set NLS_DATE_LANGUAGE=''AMERICAN'' ';

       v_return_date                 := next_day(last_day(to_date('01-03-' || p_year, 'dd-mm-rrrr')) -7, 'sunday');

       -- Zet de datum-taal weer terug op wat hij was.
       v_stmt := 'alter session set nls_date_language = ''' || v_nls_date_language || ''' ';
       execute immediate v_stmt;
    end if;


    return v_return_date;
  exception
    when others then
      raise;
  end date_wintersummerchange;

  function get_current_utc_timestamp
    return timestamp
  is
    /*********************************************************************************************************************
     Geeft de huidige systeemtijd in UTC timestamp
     Uitvoer : timestamp
    **********************************************************************************************************************/
    cn_module                     constant varchar2(100) := cn_package || '.get_current_utc_timestamp';

    v_return_date timestamp;
  begin
    v_return_date := from_tz(systimestamp
                            ,sup_constants.cn_loc_timezone) at time zone sup_constants.cn_offset_utc;

    return v_return_date;

  exception
    when others then
      raise;

  end get_current_utc_timestamp;

  --
  function get_ptu_from_utc_date(p_utc_time    in date
                                ,p_ptu_length  in number)
    return number
  is

  /**********************************************************************************************************
   Purpose      : Bepaal de pte van een meegegeven UTC tijd
  ***********************************************************************************************************/

    cn_module                     constant  varchar2(61) := cn_package||'.get_ptu_from_utc_date';

    v_local_time                            date;
    v_utc_time                              date;
    v_current_ptu                           number(10);
  begin

    v_utc_time                    := p_utc_time;
    v_local_time                  := convertutc2local(v_utc_time);

    -- sssss geeft aantal seconden vanaf begin etmaal (ahv tijd)
    -- delen door aantal seconden in minuut (60) en aantal minuten in PTE
    -- round((p_ptu_length * 60) is nodig omdat je bij 4 seconde-waarden anders 0,9999999995 krijg, waardoor je op de grensseconde net 1 ptu te laag uit komt
    -- vreemd genoeg werkt ceil hier overigens niet.
    -- geeft PTE + restwaarde. FLOOR schrapt de restwaarde
    -- Met 1 ophogen omdat anders eerste PTE = 0

    select floor(to_char(v_local_time, 'sssss') / round((p_ptu_length * 60))) + 1
      into v_current_ptu
      from dual;

    -- Als winter-zomer en tijd na 03:00, dan pte = pte - 1 uur (dus - 60/p_pte)
    -- Als het verschil tussen lokaal en UTC 2 uur is, zitten we in de zomertijd en moet er een uurtje aan ptu's afgehaald worden i.v.m. het 'verloren' uurtje.
    -- Alleen op de overgangsdag!
    if trunc(v_local_time) = date_wintersummerchange(to_char(v_local_time,'yyyy'))
    and v_local_time       = (v_utc_time + interval '0 02:00:00' day to second) then
      -- opm. Probleem als PTE > 60 minuten en/of uur geen veelvoud van pte
      v_current_ptu := v_current_ptu - (60 / p_ptu_length);
    end if;

    -- Op zomer-winter en tijd na 03:00 (UTC 01:00), dan pte = pte + 1 uur (dus + 60/p_pte)
    -- Als het verschil tussen lokaal en UTC 1 uur is, zitten we in de wintertijd en moet er een extra uurtje aan ptu's bij opgeteld worden i.v.m. het dubbele uurtje.
    -- ook hier alleen op de overgangsdag
    if trunc(v_local_time) = date_summerwinterchange(to_char(v_local_time,'yyyy'))
    and v_local_time       = (v_utc_time + interval '0 01:00:00' day to second) then
      -- opm. Probleem als PTE > 60 minuten en/of uur geen veelvoud van pte
      v_current_ptu := v_current_ptu + (60 / p_ptu_length);
    end if;

    return(v_current_ptu);

  exception
    when others then
      raise;

  end get_ptu_from_utc_date;

  function convert_localtimestamp2utcdate(p_timestamp in timestamp)
    return date
  /**********************************************************************************************************
   Purpose      : Converteert een local timestamp naar UTC date
  ***********************************************************************************************************/
  is
  begin
    return cast(sup_date_actions.convertlocal2utc(p_timestamp) as date);
  end convert_localtimestamp2utcdate;

  function convert_utctimestamp2localdate(p_timestamp in timestamp)
    return date
  is
  /**********************************************************************************************************
   Purpose      : Converteert een UTC timestamp naar local date
  ***********************************************************************************************************/
  begin
    return cast(sup_date_actions.convertutc2local(p_timestamp) as date);
  end convert_utctimestamp2localdate;
  --
  function get_position_for_point(p_utc_timestamp_start        in timestamp
                                 ,p_utc_position_timestamp_end in timestamp
                                 ,p_resolution                 in varchar2
                                 )
    return number
  is
  /**********************************************************************************************************
   Purpose      : Calculate the current position of a specific point based on a utc position start and end date.
  ***********************************************************************************************************/
    cn_module               constant varchar2(61) := cn_package || 'get_position_for_point';
    v_point_start_date               date;
    v_position_end_date              date;
    v_resolution                     number(15,5);
    v_position                       number(20);
    e_unknown_resolution             exception;
  begin
    v_point_start_date       := p_utc_timestamp_start;
    v_position_end_date      := p_utc_position_timestamp_end;

    case
      when regexp_like(p_resolution, cn_hour_min_res_pattern) then
        v_resolution        := translate_resolution_2_minutes(p_resolution     => p_resolution);
        v_position          := round((v_position_end_date - v_point_start_date) * ((60 / v_resolution)*24),0);
      when p_resolution = sup_constants.cn_resolution_day then
        v_position          := round(v_position_end_date - v_point_start_date);
      when p_resolution = sup_constants.cn_resolution_week then
        v_position          := round((v_position_end_date - v_point_start_date) / 7);
      when p_resolution = sup_constants.cn_resolution_month then
        v_position          := round(months_between(v_position_end_date, v_point_start_date));
      when p_resolution = sup_constants.cn_resolution_year then
        v_position          := round(months_between(v_position_end_date, v_point_start_date) / 12);
      else
          raise e_unknown_resolution;
    end case;

    return v_position;
  exception
    when e_unknown_resolution then
      raise_application_error(-20902, cn_module || ': Resolution ' || p_resolution || ' not supported');
    when others then
      raise;
  end get_position_for_point;
  --
  function get_max_position      (p_utc_timestamp_start in timestamp
                                 ,p_utc_timestamp_end   in timestamp
                                 ,p_resolution          in varchar2
                                 )
    return number
  is
  /**********************************************************************************************************
   Purpose      : Calculate the max position of a point based on a point utc end date.
  ***********************************************************************************************************/
    cn_module               constant varchar2(61) := cn_package || 'get_max_position';
    v_point_start_date               date;
    v_point_end_date                 date;
    v_resolution                     number(15,5);
    v_max_position                   number(20);
    e_unknown_resolution             exception;
  begin
    v_point_start_date  := p_utc_timestamp_start;
    v_point_end_date    := p_utc_timestamp_end;

    case
      when regexp_like(p_resolution, cn_hour_min_res_pattern) then
        v_resolution        := translate_resolution_2_minutes(p_resolution     => p_resolution);
        v_max_position      := round((v_point_end_date - v_point_start_date) * ((60 / v_resolution)*24),0);
      when p_resolution = sup_constants.cn_resolution_day_hours then
        v_max_position      := round(v_point_end_date - v_point_start_date);
      when p_resolution = sup_constants.cn_resolution_day then
        v_max_position      := round(v_point_end_date - v_point_start_date);
      when p_resolution = sup_constants.cn_resolution_week then
        v_max_position      := round((v_point_end_date - v_point_start_date) / 7);
      when p_resolution = sup_constants.cn_resolution_month then
        v_max_position      := round(months_between(v_point_end_date, v_point_start_date));
      when p_resolution = sup_constants.cn_resolution_year then
        v_max_position      := round(months_between(v_point_end_date, v_point_start_date) / 12);
      else
          raise e_unknown_resolution;
      end case;

    return v_max_position;

  exception
    when e_unknown_resolution then
      raise_application_error(-20902, cn_module || ': Resolution ' || p_resolution || ' not supported');
    when others then
      raise;
        --
  end get_max_position;

  function get_first_date_of_week (p_year        in number
                                  ,p_week        in number)
     return date
  /**********************************************************************************************************
   Purpose      : Determine the first date (monday) of a week in a certain year
  ***********************************************************************************************************/
  is
    cn_module                     constant  varchar2(61) := cn_package||'.get_first_date_of_week';

    v_date                                  date;
    e_wrong_year                            exception;
    e_wrong_week                            exception;

    cursor c_date
      is with all_days
              as (select to_date('01-01-' || p_year, 'MM/DD/RRRR') + rownum - 1 datum  -- datum in het Nederlands, "date" mag immers niet.
                    from dual
                 connect by level <= 366
                 )
             ,week_days
              as (select datum
                        ,to_number(to_char(datum, 'iw')) week_of_year
                    from all_days
                 )
             select min(datum)
               from week_days
              where week_of_year = p_week;
  begin
    if length (p_year) != 4 then
       raise e_wrong_year;
    end if;

    -- Week moet tussen 1 en 53 liggen. Als het jaar niet de week 53 heeft, gaat dit niet goed, maar dat is dan maar even zo...
    if not p_week between 1 and 53 then
       raise e_wrong_week;
    end if;

    open c_date;
    fetch c_date
      into v_date;
    close c_date ;

    return v_date;
  exception
    when e_wrong_year then
      raise_application_error(-20903, cn_module || ': Year must be 4 positions long!');
    when e_wrong_week then
      raise_application_error(-20903, cn_module || ': Week must be between 1 and 53!');
    when others then
      raise;
  end get_first_date_of_week;

  function transform_resolution (p_bvalidity_utc_from in timestamp
                                ,p_resolution_in      in varchar2
                                ,p_resolution_out     in varchar2 default 'PT15M'
                                )
    return tt_interval
    /**********************************************************************************************************
     Purpose      : Transform one resolution to another.
    ***********************************************************************************************************/
    is

      cn_module constant    varchar2(61) default cn_package || 'transform_resolution';

      v_minutes_in          varchar2(10);
      v_minutes_out         varchar2(10);
      v_resolution_to_check varchar2(10);
      v_result_tab          tt_interval;
      v_bvalidity_loc_day  timestamp;

      e_unknown_resolution  exception;

    begin
      -- Controleren of wij de aangeboden resoluties wel kennen
      -- Ingaand
      v_bvalidity_loc_day   := trunc(convertutc2local(p_utc_date => p_bvalidity_utc_from));

      if  p_resolution_in        != 'P1D'
      and p_resolution_in  not like 'PT%M'
      and p_resolution_in  not like 'PT%M'
      and p_resolution_in  not like 'PT%H'
      and p_resolution_in  not like 'PT%M' then
          v_resolution_to_check  := p_resolution_in;
          raise e_unknown_resolution;
      elsif p_resolution_out       != 'P1D'
        and p_resolution_out not like 'PT%M'
        and p_resolution_out not like 'PT%M'
        and p_resolution_out not like 'PT%H'
        and p_resolution_out not like 'PT%M' then
          v_resolution_to_check  := p_resolution_out;
          raise e_unknown_resolution;
      else
         -- okidokie
         null;
      end if;

      if p_resolution_in = sup_constants.cn_resolution_day then
         case
            when v_bvalidity_loc_day = date_summerwinterchange(p_year => to_char(v_bvalidity_loc_day, 'yyyy')) then
              v_minutes_in := 1500;
            when v_bvalidity_loc_day = date_wintersummerchange(p_year => to_char(v_bvalidity_loc_day, 'yyyy')) then
              v_minutes_in := 1380;
            else
              v_minutes_in := 1440;
         end case;
      else
         v_minutes_in      := translate_resolution_2_minutes(p_resolution => p_resolution_in);
      end if;

      -- Uitgaand
      if p_resolution_out = sup_constants.cn_resolution_day then
         case
            when v_bvalidity_loc_day = date_summerwinterchange(p_year => to_char(v_bvalidity_loc_day, 'yyyy')) then
              v_minutes_out := 1500;
            when v_bvalidity_loc_day = date_wintersummerchange(p_year => to_char(v_bvalidity_loc_day, 'yyyy')) then
              v_minutes_out := 1380;
            else
              v_minutes_out := 1440;
          end case;
      else
         v_minutes_out      := translate_resolution_2_minutes(p_resolution => p_resolution_out);
      end if;

      if  v_minutes_in  is not null
      and v_minutes_out is not null
      then
        for i in 1 .. (v_minutes_in / v_minutes_out)
        loop
          v_result_tab(i).starttime := p_bvalidity_utc_from      + numtodsinterval(v_minutes_out * (i - 1)
                                                                                  ,'minute');
          v_result_tab(i).endtime   := v_result_tab(i).starttime + numtodsinterval(v_minutes_out
                                                                                  ,'minute');

        end loop;
      end if;

      return v_result_tab;

    exception
      when e_unknown_resolution then
        pcs_log_actions.log_error(p_module => cn_module
                                 ,p_text =>  'Given resolution ' || v_resolution_to_check || ' not supported for this function.');
        raise;

      when others then
        raise;

    end transform_resolution;

    function get_utc_ptus_between_two_dates (p_date_utc_from         in date
                                            ,p_date_utc_to           in date
                                            ,p_ptu_length_in_minutes in number)
       return tt_utc_timestamps
    /*********************************************************************************************************************************
      Bereken alle PTU's en de bijbehorende datum/tijd (er staat UTC, maar dat maakt eigenlijk niet uit) tussen 2 data
      Er wordt geen rekening gehouden met dagovergangen
     *********************************************************************************************************************************/
    is
      cn_module                constant varchar2(61) := cn_package || '.get_utc_ptus_between_two_dates';
      v_utc_timestamps                  tt_utc_timestamps;
    begin
      v_utc_timestamps                := null;

      if p_date_utc_to <= p_date_utc_from then
         pcs_log_actions.log_error(p_module => cn_module
                                  ,p_text   =>  'End_date must be greater then start_date!');
      else
         select rt_utc_timestamp(lvl + 1           -- Hier weer die -1 compenseren om op de jusite PTU uit te komen
                                ,cast(trunc(p_date_utc_from, 'mi') + ((lvl / 24 / 60) * p_ptu_length_in_minutes) as timestamp)
                                )
          bulk collect
          into v_utc_timestamps
        from (select level - 1 lvl   -- - 1 doen, anders zitten we een minuut ptu laat
                from dual
              connect by level <= (p_date_utc_to - (p_date_utc_from) ) * ((24 * 60) / p_ptu_length_in_minutes));
      end if;

      return v_utc_timestamps;
   exception
      when others then
        pcs_log_actions.log_error(p_module => cn_module);
        raise;
   end get_utc_ptus_between_two_dates;

    function get_ptus_between_two_dates (p_date_utc_from         in date
                                        ,p_date_utc_to           in date
                                        ,p_ptu_length_in_minutes in number)
       return number
    /*********************************************************************************************************************************
      Bereken het aantal PTU's tussen 2 data
      Er wordt geen rekening gehouden met dagovergangen
     *********************************************************************************************************************************/
    is
      cn_module                constant varchar2(61) := cn_package || '.get_ptus_between_two_dates';
      v_ptus                            number(10);

    begin
      if p_date_utc_to <= p_date_utc_from then
         pcs_log_actions.log_error(p_module => cn_module
                                  ,p_text   =>  'End_date must be greater then start_date!');
      else
        v_ptus                         := (p_date_utc_to - p_date_utc_from) * (1440 / p_ptu_length_in_minutes);
      end if;

      return v_ptus;
   exception
      when others then
        pcs_log_actions.log_error(p_module => cn_module);
        raise;
   end get_ptus_between_two_dates;


  function add_interval_to_timestamp_tz( p_ts_tz        in timestamp with time zone
                                       , p_interval_ym  in interval year to month
                                       , p_interval_ds  in interval day to second
                                       )
    return timestamp with time zone
    /*********************************************************************************************************************************
      Optellen van maanden bij timestamps kan ivm variabele maandlengte problemen opleveren, bovendien kan een zomertijdgrens
      gepasseerd worden. Het is daarom om de berekening in UTC te doen en achteraf terug te converteren. Voor het optellen van
      maanden en jaren is helaas geen mooie oplossing.
      Opgelet deze functie kan 2 tijdzones aan, UTC en Europe/Amsterdam. Alles wat geen offset +00:00 heeft wordt afgehandeld als
      Amsterdamse tijd.

      Als we op de laatste dag van de maand zitten gaan we ook naar de laatste dag van de te berekenen maand: 28-02 gaat naar b.v. 31-03
      en 31-03 naar 30-04
     *********************************************************************************************************************************/
  is
    v_result     timestamp with time zone;
    v_date       date;
    v_months     number(8);
    v_ts_utc     timestamp with time zone;
    v_tz_offset  varchar2(10);

  begin
    v_ts_utc    := p_ts_tz at time zone 'UTC';
    v_tz_offset := to_char( p_ts_tz, 'tzh:tzm' );

    v_date      := to_date( to_char( v_ts_utc, 'yyyymmdd' ), 'yyyymmdd' );
    v_months    := extract( month from( p_interval_ym )) + 12 * extract( year from( p_interval_ym ));
    v_date      := add_months( v_date, v_months );

    v_ts_utc    := to_timestamp_tz( to_char( v_date, 'yyyymmdd' ) || ' ' || to_char( v_ts_utc, 'hh24:mi:ss,ff' ) || ' +00:00'
                                  , 'yyyymmdd hh24:mi:ss,ff tzh:tzm'
                                  );
    v_ts_utc    := v_ts_utc +  p_interval_ds;

    if v_tz_offset != '+00:00' then
      v_result  := v_ts_utc at time zone 'Europe/Amsterdam';


      --corrigeer voor het zomer/winter uur bij een overgang waarbij het interval >= 1 dag is.
      if  v_tz_offset                  = '+01:00'
      and to_char(v_result, 'tzh:tzm') = '+02:00'
      then
          -- Als we van wintertijd naar zomertijd gaan verschuift de tijd 1 uur vooruit. Dat is niet de bedoeling, dus corrigeer dan uur
          -- Dta moeten we NIET doen als we van wintertijd 02:mi naar zomertijd 03:mi gegaan zijn
          if not (    trunc(v_result)             = date_wintersummerchange(p_year => to_char(v_result, 'yyyy'))
                  and to_char(v_result, 'hh24')   = '03'
                 ) then
             if p_interval_ds not like '+00 %' --interval is minimaal 1 dag dan passen we de uurcorrectie toe
             or p_interval_ym != '+00-00'      --interval is minimaal 1 dag dan passen we de uurcorrectie toe
             then
                 v_result := v_result - to_dsinterval('0 01:00:00');
             end if;
          end if;
      elsif  v_tz_offset = '+02:00'
      and to_char(v_result, 'tzh:tzm') = '+01:00' then
          if p_interval_ds not like '+00 %' --interval is minimaal 1 dag dan passen we de uurcorrectie toe
          or p_interval_ym != '+00-00'      --interval is minimaal 1 dag dan passen we de uurcorrectie toe
          then
             v_result := v_result + to_dsinterval('0 01:00:00');
          end if;
        else
          null;
      end if;
    else
      v_result  := v_ts_utc;
    end if;

    if p_interval_ym <> interval '0' month
    then
      -- Nu kan het nog dat we op de laatste dag van de maand binnenkwamen, maar nu niet meer op de laatste dag zitten. Dat kan met de lokaal -> UTC conversie
      -- Ga in dat geval alsnog naar de laatste dag van de maand
      if  p_ts_tz   = last_day(p_ts_tz)
      and v_result != last_day(v_result) then
          if round(months_between(p_ts_tz, v_result)) != v_months then
             v_result           := last_day(v_result - 1);
          else
             v_result           := last_day(v_result);
          end if;
      end if;
    end if;


    return v_result;
  end add_interval_to_timestamp_tz;

  function get_hours_between_2_dates (p_date_one_loc    in date
                                     ,p_date_two_loc    in date)
    return number
  is
    cn_module                 constant varchar2(61) := cn_package || '.get_hours_between_2_dates';

    v_hours                            number(10);
  v_date_from                        date;
  v_date_to                          date;
  begin
    -- Zet de datums zo dat we een nette van/tot datum hebben, da's handiger om te kijken of er een z/w-overgang inzit
    if p_date_one_loc > p_date_two_loc then
      v_date_from                := p_date_two_loc;
      v_date_to                  := p_date_one_loc;
    else
      v_date_from                := p_date_one_loc;
      v_date_to                  := p_date_two_loc;
    end if;

    v_hours                      := (v_date_to - v_date_from) * 24;

    -- Corrigeer eventuele zomer-/wintertijd of winter-/zomertijd overgang
    -- Als beiden in de zomertijd of wintertijd liggen hoeven we niets te corrigeren
    if  v_date_from       < date_wintersummerchange(p_year => to_char(v_date_from, 'yyyy'))
    and v_date_to   between date_wintersummerchange(p_year => to_char(v_date_to  , 'yyyy'))
                        and date_summerwinterchange(p_year => to_char(v_date_to  , 'yyyy')) then
        -- Van datum in de wintertijd en tot-datum in de zomertijd, dan 1 uur van het totaal aftrekken
        v_hours                  := v_hours - 1;
    elsif v_date_from between date_wintersummerchange(p_year => to_char(v_date_from, 'yyyy'))                                -- from_date in zomertijd
                          and date_summerwinterchange(p_year => to_char(v_date_from, 'yyyy'))
      and (    v_date_to                                   > date_summerwinterchange(p_year => to_char(v_date_to, 'yyyy'))   -- to_date in wintertijd
           or (    to_number(to_char(v_date_from, 'yyyy')) < to_number(to_char(v_date_to, 'yyyy'))                           -- to_date in het volgende jaar, maar nog wel in de wintertijd
               and v_date_to                               < date_wintersummerchange(p_year => to_char(v_date_to, 'yyyy'))   -- dat geldt ook als de to_date 1 januari is
              )
          )
      then
        -- Van datum in de zomertijd en tot-datum in de wintertijd, dan 1 uur bij het totaal optellen
        v_hours                  := v_hours + 1;
    end if;

    -- Nog even een correctie doen als p_one_date_loc na p_two_date_loc ligt geven we een negatief aantal dagen terug
    if p_date_one_loc > p_date_two_loc then
      v_hours                    := v_hours * -1;
    end if;

    return v_hours;

  exception
     when others then
        pcs_log_actions.log_error(p_module   => cn_module);
  end get_hours_between_2_dates;

  function hours2dsinterval( p_hours in number )
    return interval day to second
    /*********************************************************************************************************************************
      Zet een aantal uren om in een interval day to second
     *********************************************************************************************************************************/
  is
    v_days           pls_integer;
    v_hours          pls_integer;
    v_min            pls_integer;
    v_sec            pls_integer;
    v_hours_min      number;
    v_min_sec        number;
    v_interval       varchar2(100);
  begin
    v_min_sec   := p_hours - trunc(p_hours);
    v_days      := trunc( p_hours / 24);
    v_hours_min := mod(p_hours,24);
    v_hours     := trunc( v_hours_min);
    v_min_sec   := 60 * (v_hours_min - v_hours);
    v_min       := to_char(trunc(v_min_sec), '00');
    v_sec       := trunc(60 * (v_min_sec - trunc(v_min_sec)));

    v_interval := to_char(v_days)               || ' '
               || to_char(v_hours, '00')        || ':'
               || to_char(v_min  , '00')        || ':'
               || to_char(v_sec  , '00.000000');
    return to_dsinterval(v_interval) ;
  end hours2dsinterval;

  function trunc_local
    ( p_date in date
    , p_fmt  in varchar2 default null
    )
    return date is
  /************************************************************************************************************************************
   Purpose:  Wrapper voor de standaard Oracle TRUNC functie. Resultaat is een trunc op de LOCAL timestamp
             Input en output zijn UTC datums
  ************************************************************************************************************************************/
  v_utc                                timestamp with time zone;
  v_local                              timestamp with time zone;
  v_local_dt                           date;
  begin

    -- Zet p_date (UTC) om naar de LOCAL timezone
    v_local    := from_tz( cast( p_date as timestamp), sup_constants.cn_utc_timezone) at time zone sup_constants.cn_loc_timezone;

    -- Voer de TRUNC uit op v_local (resultaat van TRUNC is DATE).
    v_local_dt := case
                    when p_fmt is null then
                       trunc(v_local)
                    else
                       trunc(v_local, p_fmt)
                    end;

    -- zet het resultaat om naar UTC, retourneer v_utc als DATE
    v_utc      := from_tz( cast( v_local_dt as timestamp)
                         , sup_constants.cn_loc_timezone) at time zone sup_constants.cn_utc_timezone;
    return cast( v_utc as date);
  end trunc_local;

  function trunc_tz
    ( p_date in date
    , p_fmt  in varchar2 default null
    )
    return timestamp with time zone is
  /************************************************************************************************************************************
   Purpose:  Wrapper voor de standaard Oracle TRUNC functie. Resultaat is een trunc op de LOCAL timestamp
             Input is UTC, timestamp LOCAL timezone
  ************************************************************************************************************************************/
  v_local                              timestamp with time zone;
  v_local_dt                           date;
  begin

-- XaPi: zo was het, maar dat is heel verwarrend dat je een trunc op een UTC gaat doen (en gaf ook problemen). De hele functie lijkt
--  vooralsnog overbodig
    -- Zet p_date (UTC) om naar de LOCAL timezone
--    v_local    := from_tz( cast( p_date as timestamp), sup_constants.cn_utc_timezone) at time zone sup_constants.cn_loc_timezone;

    -- Voer de TRUNC uit op v_local (resultaat van TRUNC is DATE).
    v_local_dt := case
                    when p_fmt is null then trunc(p_date)
                    else                    trunc(p_date, p_fmt)
                  end;

    -- zet het resultaat om naar de LOCAL timezone, retourneer v_local als TIMESTAMP WITH TIME ZONE
    v_local      := from_tz( cast( v_local_dt as timestamp)
                          , sup_constants.cn_loc_timezone);
    return v_local;
  end trunc_tz;

  function round_tz
    ( p_date in date
    )
    return timestamp with time zone is
  /************************************************************************************************************************************
   Purpose:  Wrapper voor de standaard Oracle ROUND functie. Resultaat is een trunc op de LOCAL timestamp
             Input is UTC, output timestamp LOCAL timezone
  ************************************************************************************************************************************/
  v_local                              timestamp with time zone;
  v_local_dt                           date;
  begin

-- XaPi: zo was het, maar dat is heel verwarrend dat je een round op een UTC gaat doen (en gaf ook problemen). De hele functie lijkt vooralsnog
-- overbodig
    -- Zet p_date (UTC) om naar de LOCAL timezone
--    v_local    := from_tz( cast( p_date as timestamp), sup_constants.cn_utc_timezone) at time zone sup_constants.cn_loc_timezone;

    -- Voer de ROUND uit op v_local (resultaat van ROUNDis DATE).
    v_local_dt := round(p_date);

    -- zet het resultaat om naar de LOCAL timezone, retourneer v_local als TIMESTAMP WITH TIME ZONE
    v_local      := from_tz( cast( v_local_dt as timestamp)
                          , sup_constants.cn_loc_timezone);
    return v_local;
  end round_tz;


  function day_number(p_date in date)
    return pls_integer
    /**********************************************************************************************************
     Purpose      : Returns day of week (monday = 1). NLS independent
    ***********************************************************************************************************/
    is
    begin
      -- ISO week IW begint altijd op maandag
      return 1 + trunc(p_date) - trunc(p_date, 'IW');
    end day_number;

  function saturday (p_date in date)
    return date
    /**********************************************************************************************************
     Purpose      : Returns the last saturday before the date supplied
    ***********************************************************************************************************/
    is
      v_saturday_offset         pls_integer; -- Verschil dag nummer en zaterdag dagnummer
      v_offset      pls_integer;             -- Aantal dagen na de laatse zaterdag
    begin
      v_saturday_offset    := day_number(p_date => p_date) - 6;
      v_offset             := case
                              when v_saturday_offset < 0 then v_saturday_offset + 7
                              else                            v_saturday_offset
                              end;
      return p_date - v_offset;
    end saturday;

  function imbalance_week(p_date in date)
    return pls_integer
    /*********************************************************************************************************
     Purpose      : Returns imbalance week. Imbalance weeks start on Saturday.
    **********************************************************************************************************/
  is
  begin
    return cast(case
                  when trim(to_char(p_date,'day','nls_date_language = Dutch')) in ('zaterdag','zondag') --de trim is noodzakelijk, blijkbaar zitten er spaties in het resultaat van de 'day' functie
                  then to_char(p_date + 7,'iw')
                  else to_char(p_date,'iw')
                end
                as pls_integer);
  end imbalance_week;

  function imbalance_year (p_date in date)
    return varchar2
    /**********************************************************************************************************
     Purpose      : Returns imbalance week. Imbalance weeks start on Saturday.
    ***********************************************************************************************************/
    is
    begin
      return to_char(saturday(p_date => p_date), 'YYYY');
    end imbalance_year;

  function get_month (p_ts in timestamp)
    return varchar2 deterministic
    /**********************************************************************************************************
     Purpose      : Returns the local month for the UTC timestamp given.
    ***********************************************************************************************************/
    is
    begin
      return to_char(from_tz(p_ts, sup_constants.cn_utc_timezone) at time zone sup_constants.cn_loc_timezone, 'YYYYMM');
    end get_month;

  function compute_easter(p_year in integer) return date is
    /**********************************************************************************************************
     Purpose      : Geef de datum van 1e pinksterdag terug
                    Dit is een hele complexe berekening, functie is eerlijk gepikt uit CDS. Vanwege de complexe
                    berekening alle variabelen ongemoeid gelaten (behalve de v_ prefix), omdat ik ook geen idee
                    heb hoe ik ze zou moeten noemen.
    ***********************************************************************************************************/
    cn_module  constant varchar2(100) := cn_package || '.compute_easter';
    cn_version constant varchar2(8) := '1.00';

    v_a                 number;
    v_b                 number;
    v_c                 number;
    v_d                 number;
    v_e                 number;
    v_g                 number;
    v_h                 number;
    v_i                 number;
    v_j                 number;
    v_k                 number;
    v_l                 number;
    v_m                 number;
    v_month             number;
    v_day               number;

  begin
    v_a             := mod(p_year, 19);
    v_b             := trunc(p_year / 100);
    v_c             := mod(p_year, 100);
    v_d             := trunc(v_b / 4);
    v_e             := mod(v_b, 4);
    v_g             := trunc((8 * v_b + 13) / 25);
    v_h             := trunc((11 * (v_b - v_d - v_g) - 4) / 30);
    v_i             := trunc((7 * v_a + v_h + 6) / 11);
    v_j             := mod((19 * v_a + (v_b - v_d - v_g) + 15 - v_i), 29);
    v_k             := trunc(v_c / 4);
    v_l             := mod(v_c, 4);
    v_m             := mod(((32 + 2 * v_e) + 2 * v_k - v_l - v_j), 7);
    v_month         := trunc((90 + (v_j + v_m)) / 25);
    v_day           := mod((19 + (v_j + v_m) + v_month), 32);

    return(to_date(v_day || '-' || v_month || '-' || p_year, 'dd-mm-yyyy'));

  exception
    when others then
      pcs_log_actions.log_error(p_module => cn_module);
      raise;
  end compute_easter;


  function get_day_type(p_date in date)
      return varchar2
   /**************************************************************************************
    Bepaal aan de hand van de datum of het een speciale feestdag, weekdag of weekend is
     *************************************************************************************/
   is
    cn_module  constant varchar2(100) := cn_package || '.get_day_type';

    v_year                 number(4);
    v_hours_in_day         number(2);
    v_newdate              date;
    v_enddate              date;
    v_new_year             date;
    v_royal_day             date;
    v_christmas_day        date;
    v_boxing_day           date;
    v_easter               date;
    v_easter_monday        date;
    v_pentecost            date;
    v_whit_monday          date;
    v_ascension_day        date;
    v_winter_summer_change date;
    v_summer_winter_change date;
    v_day_type             varchar2(100);

  begin
--    sup_utilities.keep_session_nls;
--    sup_utilities.set_session_dutch;

    v_year                        := to_char(p_date, 'yyyy');
    v_new_year                    := to_date('01-01-' || v_year, 'dd-mm-yyyy');
    v_royal_day                   := to_date(sup_ojtppy_actions.get_domain_value(p_ojt_code    => 'SPECIAL_DATES'
                                                                                ,p_ppy_code    => 'ROYAL_DAY'
                                                                                ,p_silent_mode => 'Y'
                                                                                ) || v_year, 'dd-mmyyyy');

    -- als koningsdag op zondag valt, wordt het op de zaterdag ervoor gevierd
    if to_char(v_royal_day, 'DY') in ('ZO', 'SUN')
    then
      v_royal_day                 := v_royal_day - 1;
    end if;

    v_christmas_day               := to_date('25-12-' || v_year, 'dd-mm-yyyy');
    v_boxing_day                  := to_date('26-12-' || v_year, 'dd-mm-yyyy'); -- 2e kerstdag
    v_easter                      := compute_easter(v_year);
    v_easter_monday               := v_easter + 1;
    v_pentecost                   := v_easter + 49;
    v_whit_monday                 := v_easter + 50;
    v_ascension_day               := v_easter + 39;

    case p_date
      when v_new_year then
        v_day_type                := 'NEW_YEAR';
      when v_royal_day then
        v_day_type                := 'ROYAL_DAY';
      when v_christmas_day then
        v_day_type                := 'CHRISTMAS';
      when v_boxing_day then
        v_day_type                := 'BOXING_DAY';
      when v_easter then
        v_day_type                := 'EASTER';
      when v_easter_monday then
        v_day_type                := 'EASTER_MONDAY';
      when v_pentecost then
        v_day_type                := 'PENTECOST';
      when v_whit_monday then
        v_day_type                := 'WHIT_MONDAY';
      when v_ascension_day then
        v_day_type                := 'ASCENSION_DAY';
      else
        if to_char(p_date, 'DY') in ('ZA', 'SAT', 'ZO', 'SUN') then
           v_day_type             := 'WEEKEND';
        else
           v_day_type             := 'WEEKDAY';
        end if;
    end case;

--    sup_utilities.reset_session_nls;

    return v_day_type;

  exception
    when others then
      pcs_log_actions.log_error(p_module        => cn_module);
      raise;

  end get_day_type;

  function get_previous_workday (p_date in date default sysdate)
     return date
   /**********************************************************************************************************************************
    Bepaal aan de hand van de datum wat de laatste werkdag was, rekening houdend met weekend en feestdagen
    **********************************************************************************************************************************/
  is
     cn_module            constant varchar2(100) := cn_package || '.get_previous_workday';

     v_previous_workday            date;
     v_yesterday                   date;
     v_today                       date;
     v_yesterday_name              varchar2(10);
  begin
--      sup_utilities.keep_session_nls;
--     sup_utilities.set_session_english;

     v_today                       := trunc(p_date);
     v_yesterday                   := v_today - 1;
     v_yesterday_name              := to_char(v_yesterday, 'DY');

     -- welke dag was het gisteren?
     v_previous_workday            := case delphidba.sup_date_actions.get_day_type(p_date => v_yesterday)
                                         when 'WEEKDAY' then
                                              v_yesterday
                                         when 'WEEKEND' then
                                              case v_yesterday_name
                                                 when 'SUN' then
                                                      v_today - 3
                                                 else
                                                      v_today - 2
                                                 end
                                         when 'NEW_YEAR' then
                                              case v_yesterday_name
                                                 when 'SUN' then
                                                      v_today - 4
                                                 when 'SAT' then
                                                      v_today - 3
                                                 else
                                                      v_today - 2
                                                 end
                                         when 'ROYAL_DAY' then
                                              case v_yesterday_name
                                                 when 'SUN' then
                                                      v_today - 4
                                                 when 'SAT' then
                                                      v_today - 3
                                                 else
                                                      v_today - 2
                                                 end
                                         when 'CHRISTMAS' then
                                              case v_yesterday_name
                                                 when 'SUN' then
                                                      v_today - 4
                                                 when 'SAT' then
                                                      v_today - 3
                                                 else
                                                      v_today - 2
                                                 end
                                         when 'BOXING_DAY' then
                                              case v_yesterday_name
                                                 when 'MON' then
                                                      v_today - 5
                                                 when 'SUN' then
                                                      v_today - 4
                                                 else
                                                      v_today - 3
                                                 end
                                         when 'EASTER' then
                                              v_today - 3
                                         when 'EASTER_MONDAY' then
                                              v_today - 4
                                         when 'PENTECOST'     then
                                              v_today - 3
                                         when 'WHIT_MONDAY'   then
                                              v_today - 4
                                         when 'ASCENSION_DAY' then
                                              v_today -2
                                         else
                                              v_yesterday
                                         end;

--     sup_utilities.reset_session_nls;

     return v_previous_workday;
  end get_previous_workday;

  function correct_datetime(p_utc_date in date) return date is
    /************************************************************************************************************************************
     Purpose:  Zorg er voor dat het tijdgedeelte altijd overeenkomt met 00:00:00 lokale tijd:
     W: 23:00:00
     Z: 22:00:00
    ************************************************************************************************************************************/
     v_zw_code              char(1); -- W: Wintertijd Z: Zomertijd
     v_return_date          date;
  begin
     v_zw_code := zw_code(p_utc_date => p_utc_date);
     
     case v_zw_code
        when 'W' then v_return_date := trunc(p_utc_date) + 23/24;  -- 23:00
        when 'Z' then v_return_date := trunc(p_utc_date) + 22/24;  -- 22:00   
     end case;
     
     return v_return_date;
  end correct_datetime;
  
  procedure correct_period(p_bvalidity_utc_from in out nocopy date, p_bvalidity_utc_to in out nocopy date) is
    /************************************************************************************************************************************
     Purpose:  Zorg dat het tijdgedeelte de bvalidities van publicaties die over hele dagen gaan  altijd beginnen en eindigen op 
               00:00:00 lokale tijd
    ************************************************************************************************************************************/
   begin
      if (p_bvalidity_utc_to - p_bvalidity_utc_from) >= 23/24 then
         -- Deze publicatie gaat over hele dagen
         p_bvalidity_utc_from := correct_datetime(p_utc_date => p_bvalidity_utc_from);
         p_bvalidity_utc_to   := correct_datetime(p_utc_date => p_bvalidity_utc_to);
      end if;
   end correct_period;      

  function exec_expression(p_expr in varchar2, p_utc_date_in in date) return date is
    /************************************************************************************************************************************
     Purpose:  Bepaal de bvalidity op basis van de opgevoerde UTC date en de opgegeven expressie. Voorwaarde is wel dat de 
               TRUNC functie werkt alsof we een local date opgeven. Bijvoorbeeld trunc(p_date)) gaat naar 00:00:00 lokale tijd. Hiervoor 
               verbouwen we de opgegeven expressie zodanig dat er i.p.v. TRUNC, TRUNC_LOCAL_NEW wordt aangeroepen, die daarvoor zorgt. Dit
               vindt plaats in de functie create_statement.
    ************************************************************************************************************************************/
    cn_module                 constant varchar2(100) := cn_package || '.execute_expression';

    v_calculated_date date;
  begin
      pcs_log_actions.log_trace( p_module => cn_module,
                                 p_text   => 'Start' || chr(10)
                                          || 'p_utc_date_in   : ' || to_char(p_utc_date_in, 'dd-mm-yyyy hh24:mi:ss') || chr(10)
                                          || 'p_expr          : ' || p_expr                                      
                               );

    -- Voer de expressie uit
    execute immediate create_statement(p_expr)
      using out v_calculated_date
               ,p_utc_date_in;

    pcs_log_actions.log_trace( p_module => cn_module
                             , p_text   => 'End'                                                                        || chr(10) 
                                        || 'v_calculated_date: ' || to_char(v_calculated_date, 'dd-mm-yyyy hh24:mi:ss')
                             );

    return v_calculated_date;
  exception
    when others then
      pcs_log_actions.log_error( p_module => cn_module
                               , p_text   => 'Error' || chr(10)
                                          || 'p_utc_date_in   : ' || to_char(p_utc_date_in, 'dd-mm-yyyy hh24:mi:ss') || chr(10)
                                          || 'p_expr          : ' || p_expr                                      
                               );
      raise;
  end exec_expression;   


end sup_date_actions;
/
