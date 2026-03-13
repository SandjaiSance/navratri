create or replace package sup_tln_actions_test is
  cn_package        constant varchar2(256) := 'SUP_TLN_ACTIONS';
  cn_version_number constant varchar2(100) := '01.00.01';

  --%suite(sup_tln_actions - Translation Actions Unit Tests)
  --%rollback(manual)
  
  --%beforeall
  procedure setup;

  --%afterall
  procedure cleanup;

  /* ========================================================================================================
     Context: Version Number Management
     ======================================================================================================== */

  --%context(Version Number)

  --%test(get_versionnumber returns non-empty string)
  procedure get_versionnumber_latest;

  --%endcontext

  /* ========================================================================================================
     Context: Translation Lookup (Code to Translation Mapping)
     ======================================================================================================== */

  --%context(Translation Lookup)

  --%test(returns correct translation for valid code)
  procedure get_translation_basic;

  --%test(returns correct translation for uppercase element)
  procedure get_translation_with_uppercase;

  --%test(returns default translation when code is null)
  procedure get_translation_null_code;

  --%test(returns null for non-existent code)
  procedure get_translation_non_existent_code;

  --%test(returns null for non-existent element)
  procedure get_translation_non_existent_element;

  --%endcontext

  /* ========================================================================================================
     Context: Reverse Code Lookup (Translation to Code Mapping)
     ======================================================================================================== */

  --%context(Reverse Code Lookup)

  --%test(returns correct code for valid translation)
  procedure get_code_basic;

  --%test(returns correct code for different element)
  procedure get_code_different_element;

  --%test(returns null for non-existent translation)
  procedure get_code_non_existent_translation;

  --%test(returns null for non-existent element)
  procedure get_code_non_existent_element;

  --%endcontext

  /* ========================================================================================================
     Context: Error Handling and Edge Cases
     ======================================================================================================== */

  --%context(Error Handling)

  --%test(get_translation handles null element gracefully)
  procedure get_translation_null_element;

  --%test(get_code handles null element gracefully)
  procedure get_code_null_element;

  --%endcontext

  /* ========================================================================================================
     Context: Cache Behavior and Consistency
     ======================================================================================================== */

  --%context(Cache Behavior)

  --%test(get_translation uses cached values for repeated calls)
  procedure get_translation_cache_consistency;

  --%test(multiple calls return consistent results)
  procedure get_translation_consistency;

  --%endcontext

end sup_tln_actions_test;
