create or replace package sup_ojtppy_actions_test is
  
  cn_test_suite constant varchar2(256) := 'SUP_OJTPPY_ACTIONS_TEST';
  cn_package    constant varchar2(256) := 'SUP_OJTPPY_ACTIONS';
  cn_version_nr constant varchar2(256) := '01.10.00';
  
  --%suite(sup_ojtppy_actions - object property unit tests)
  --%rollback(manual)
  
  --%beforeall
  procedure setup;

  --%afterall
  procedure cleanup;

  /* ========================================================================================================
     context: version number management
     ======================================================================================================== */

  --%context(version number)

  --%test(Verify version equals latest package version)
  procedure check_versionnumber_equals_latest;

  --%endcontext

  /* ========================================================================================================
     context: domain value validation
     ======================================================================================================== */

  --%context(domain value validation)

  --%test(check_value_in_domain returns true for valid value)
  procedure check_value_valid;

  --%test(check_value_in_domain returns false for invalid value)
  procedure check_value_invalid;

  --%test(check_value_in_domain handles null ojt_code)
  procedure check_value_null_ojt_code;

  --%test(check_value_in_domain with bvalidity timestamp within range)
  procedure check_value_bvalidity_within;

  --%test(check_value_in_domain with bvalidity timestamp outside range)
  procedure check_value_bvalidity_outside;

  --%endcontext

  /* ========================================================================================================
     context: get domain value (varchar2)
     ======================================================================================================== */

  --%context(get domain value varchar2)

  --%test(get_domain_value returns correct value)
  procedure get_domain_value_basic;

  --%test(get_domain_value returns null for non-existent ojt_code)
  procedure get_domain_value_non_existent_ojt;

  --%test(get_domain_value returns null for non-existent ppy_code)
  procedure get_domain_value_non_existent_ppy;

  --%test(get_domain_value handles null ppy_code)
  procedure get_domain_value_null_ppy;

  --%test(get_domain_value with bvalidity timestamp within range)
  procedure get_domain_value_bvalidity_within;

  --%test(get_domain_value with bvalidity timestamp outside range)
  procedure get_domain_value_bvalidity_outside;

  --%endcontext

  /* ========================================================================================================
     context: get domain values (array - apex_t_varchar2)
     ======================================================================================================== */

  --%context(get domain values array)

  --%test(get_domain_values returns array of values)
  procedure get_domain_values_multiple;

  --%test(get_domain_values returns empty array for non-existent)
  procedure get_domain_values_empty;

  --%test(get_domain_values returns single value correctly)
  procedure get_domain_values_single;

  --%test(get_domain_values with bvalidity timestamp within range)
  procedure get_domain_values_bvalidity_within;

  --%test(get_domain_values with bvalidity timestamp outside range)
  procedure get_domain_values_bvalidity_outside;

  --%endcontext

  /* ========================================================================================================
     context: get domain value (number)
     ======================================================================================================== */

  --%context(get domain value number)

  --%test(get_domain_value_n returns correct number)
  procedure get_domain_value_n_basic;

  --%test(get_domain_value_n returns null for non-existent)
  procedure get_domain_value_n_non_existent;

  --%test(get_domain_value_n with bvalidity timestamp within range)
  procedure get_domain_value_n_bvalidity_within;

  --%test(get_domain_value_n with bvalidity timestamp outside range)
  procedure get_domain_value_n_bvalidity_outside;

  --%endcontext

  /* ========================================================================================================
     context: get domain value (date)
     ======================================================================================================== */

  --%context(get domain value date)

  --%test(get_domain_value_d returns correct date)
  procedure get_domain_value_d_basic;

  --%test(get_domain_value_d returns null for non-existent)
  procedure get_domain_value_d_non_existent;

  --%test(get_domain_value_d with bvalidity timestamp within range)
  procedure get_domain_value_d_bvalidity_within;

  --%test(get_domain_value_d with bvalidity timestamp outside range)
  procedure get_domain_value_d_bvalidity_outside;

  --%endcontext

  /* ========================================================================================================
     context: get domain value (timestamp)
     ======================================================================================================== */

  --%context(get domain value timestamp)

  --%test(get_domain_value_t returns correct timestamp)
  procedure get_domain_value_t_basic;

  --%test(get_domain_value_t returns null for non-existent)
  procedure get_domain_value_t_non_existent;

  --%test(get_domain_value_t with bvalidity timestamp within range)
  procedure get_domain_value_t_bvalidity_within;

  --%test(get_domain_value_t with bvalidity timestamp outside range)
  procedure get_domain_value_t_bvalidity_outside;

  --%endcontext

  /* ========================================================================================================
     context: get domain property by value (reverse lookup)
     ======================================================================================================== */

  --%context(get domain property by value)

  --%test(get_domain_property_by_value returns correct property)
  procedure get_property_by_value_basic;

  --%test(get_domain_property_by_value returns null for non-existent value)
  procedure get_property_by_value_non_existent;

  --%test(get_domain_property_by_value handles null value)
  procedure get_property_by_value_null;

  --%test(get_domain_property_by_value with bvalidity timestamp within range)
  procedure get_property_by_value_bvalidity_within;

  --%test(get_domain_property_by_value with bvalidity timestamp outside range)
  procedure get_property_by_value_bvalidity_outside;

  --%endcontext

  /* ========================================================================================================
     context: result cache behavior
     ======================================================================================================== */

  --%context(cache behavior)

  --%test(get_domain_value uses cached values for repeated calls)
  procedure get_domain_value_cache_consistency;

  --%test(multiple calls return consistent results)
  procedure get_domain_value_consistency;

  --%endcontext

end sup_ojtppy_actions_test;
/