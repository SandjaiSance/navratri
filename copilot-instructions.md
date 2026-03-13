# GitHub Copilot Instructions voor Oracle PL/SQL Workspace

## Workspace Overzicht
Dit is een Oracle PL/SQL ontwikkelingsworkspace voor het `delphidba` schema met packages en bijbehorende unit tests.

## Directory Structuur
- `Packages/` - Package specificaties (.spc bestanden)
- `Package_bodies/` - Package implementaties (.bdy bestanden)

## Naamgevingsconventies
- Package specificaties: `[package_naam].spc`
- Package bodies: `[package_naam].bdy`
- Test packages: `[package_naam]_test.spc` en `[package_naam]_test.bdy`
- Gebruik snake_case voor alle namen
- Schema prefix: `delphidba.`

## Test Framework
- Gebruik **utPLSQL** framework voor alle unit tests
- Test annotaties gebruiken: `--%suite`, `--%test`, `--%context`, etc.
- Elke test procedure moet een duidelijke naam hebben die de functionaliteit beschrijft
- Gebruik `ut.expect()` voor assertions

## Code Standaarden

### Package Specificaties (.spc)
```sql
create or replace package [package_naam] is
  function get_versionnumber return varchar2;
  -- Andere functie en procedure declaraties
end [package_naam];
/
```

### Package Bodies (.bdy)
```sql
create or replace package body [package_naam] is
  function get_versionnumber return varchar2 is
  begin
    return '[versie_nummer]';
  end get_versionnumber;
  -- Andere implementaties
end [package_naam];
/
```

### Test Package Specificaties (.spc)
```sql
create or replace package [package_naam]_test is
  cn_test_suite constant varchar2(256) := '[PACKAGE_NAAM]_TEST';
  cn_version_nr constant varchar2(256) := '01.00.00';

  --%suite([package_naam])
  --%rollback(manual)

  --%beforeall
  procedure setup;

  --%afterall
  procedure cleanup;

  /* ========================================================================================================
     context: [beschrijving van test groep]
     ======================================================================================================== */

  --%context([context_naam])

    --%test([test_beschrijving])
    procedure test_[functie_naam];

  --%endcontext

end [package_naam]_test;
/
```

### Test Package Bodies (.bdy)
```sql
create or replace package body [package_naam]_test is

  /* ========================================================================================================
     setup and cleanup procedures
     ======================================================================================================== */

  procedure setup is
  begin
    xxut_processes.create_test_process(cn_test_suite);
  end setup;

  procedure cleanup is
  begin
    xxut_processes.delete_test_process(cn_test_suite);
  end cleanup;

  /* ========================================================================================================
     context: [beschrijving van test groep]
     ======================================================================================================== */

  procedure test_[functie_naam] is
    -- Variabelen
  begin
    -- Test logica
    ut.expect(actual_value).to_equal(expected_value);
  end test_[functie_naam];

end [package_naam]_test;
/
```

**BELANGRIJKE TEST REGELS:**
- **GEEN --%test annotaties in package bodies** - alleen in specificaties!
- Gebruik **context comments** voor elke test sectie in bodies
- Test procedures in bodies hebben **geen annotaties**

## Ontwikkelingsrichtlijnen

### Voor Test Development:
1. **Volledige coverage**: Elke functie en procedure in het hoofd package moet getest worden
2. **Test alle edge cases**: Null waarden, extreme waarden, foutcondities
3. **Gebruik duidelijke test namen**: `test_[functie_naam]_[scenario]`
4. **Groepeer gerelateerde tests**: Gebruik `--%context` voor logische groepering
5. **Test zowel happy path als error paths**
6. **Annotaties alleen in .spc**: Package bodies bevatten GEEN --%test annotaties
7. **Context comments**: Gebruik gestructureerde comment blocks voor elke test sectie in bodies
8. **Direct testing**: Test direct op waarden, vermijd count-based testing waar mogelijk
9. **Exact value testing**: Gebruik `.to_equal()` voor precieze waarde vergelijkingen
10. **Coverage improvement**: Test overloaded procedures met verschillende parameter counts

### Test Optimization Patterns:
**GOED - Direct value testing:**
```sql
procedure test_log_debug is
  l_severity varchar2(10);
  l_pcs_id number;
begin
  l_pcs_id := sup_globals.get_global_number('PROCESS_ID');
  
  delphidba.pcs_log_actions.log_debug(
    p_module => 'test_module',
    p_message_code => sup_constan (inclusief overloaded variants)
4. Implementeer test declaraties in .spc met --%test annotaties
5. Implementeer test procedures in .bdy ZONDER annotaties maar MET context comments
6. Gebruik setup/cleanup met xxut_processes.create_test_process(cn_test_suite)
7. Test overloaded procedures met verschillende parameter counts voor betere coverage
  select severity
    into l_severity
    from pcs_technical_log_lines
   where pcs_id = l_pcs_id
     and id = (select max(id) from pcs_technical_log_lines where pcs_id = l_pcs_id);
  
  ut.expect(l_severity).to_equal('D');
end test_log_debug;
```

**SLECHT - Count-based testing:**
```sql
-- NIET GEBRUIKEN: count before/after pattern is inefficiënt
l_count_before := ...;
-- actie
l_count_after := ...;
ut.expect(l_count_after - l_count_before).to_equal(1);
```

### Setup/Cleanup Pattern:
```sql
procedure setup is
begin
  xxut_processes.create_test_process(cn_test_suite);
end setup;

procedure cleanup is
begin
  xxut_processes.delete_test_process(cn_test_suite);
end cleanup;
```

### Voor Package Development:
1. **Versioning**: Elke package moet een `get_versionnumber` functie hebben
2. **Error handling**: Gebruik proper exception handling
3. **Documentation**: Voeg commentaar toe voor complexe logica
4. **Schema referencing**: Gebruik altijd `delphidba.` prefix bij package aanroepen

### Specifieke Package Types:
- **sup_utilities**: Algemene hulp functies (sessie management, conversies, XML/CLOB handling)
- **sup_date_actions**: Datum en tijd gerelateerde functies
- **pcs_***: Business logic packages voor PCS systeem
- **tmn_***: Transmission gerelateerde packages

## Test Implementatie Workflow
Wanneer gevraagd wordt om tests te maken:
1. Analyseer het hoofd package (.spc) voor alle functies en procedures
2. Controleer bestaande test package (.spc en .bdy) voor coverage
3. Identificeer ontbrekende tests
4. Implementeer nieuwe test procedures in zowel .spc als .bdy
5. Gebruik consistent test patroon met setup/teardown waar nodig

## Database Specifieke Instructies
- Target database: Oracle Database
- Schema: `delphidba`
- Test framework: utPLSQL
- Gebruik `execute immediate` voor dynamische SQL waar nodig
- Handle database specific features appropriately

## Belangrijke Notities
- Wanneer je wijzigingen maakt aan package specificaties, update ook de bodies
- Zorg ervoor dat alle tests compileren zonder fouten
- Test procedures moeten onafhankelijk uitvoerbaar zijn
- Gebruik proper cleanup in tests (bijv. drop temporary tables)

## Copilot Gedrag
- Maak altijd zowel deze `copilot-instructions.md` als `copilot_workspace.json` aan in nieuwe workspaces
- Lees altijd eerst bestaande code voordat je wijzigingen voorstelt
- Bij test development: zorg voor 100% functie/procedure coverage
- Gebruik multi_replace_string_in_file voor efficiënte bulk edits
- Verklaar Nederlandse vragen in het Nederlands, technische code in het Engels