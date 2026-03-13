create or replace package sup_utilities_test is
  
  cn_test_suite constant varchar2(256) := 'SUP_UTILITIES_TEST';
  cn_version_nr constant varchar2(256) := '01.10.00';
  
  --%suite(sup_utilities - utility functions unit tests)
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
  procedure test_get_versionnumber_equals_latest;

  --%endcontext

  /* ========================================================================================================
     context: session information
     ======================================================================================================== */

  --%context(session information)

  --%test(Verify session ID is greater than zero)
  procedure test_get_session_id;

  --%test(Verify session user matches current user)
  procedure test_get_session_user;

  --%test(Verify system environment is set)
  procedure test_get_system_environment;

  --%endcontext

  /* ========================================================================================================
     context: UUID generation
     ======================================================================================================== */

  --%context(uuid generation)

  --%test(Verify UUID contains hyphens and minimal length)
  procedure test_get_uuid_format;

  --%endcontext

  /* ========================================================================================================
     context: numeric checks
     ======================================================================================================== */

  --%context(numeric checks)

  --%test(is_numeric returns true for positive integer)
  procedure test_is_numeric_positive_integer;

  --%test(is_numeric returns true for negative decimal)
  procedure test_is_numeric_negative_decimal;

  --%test(is_numeric returns false for number exceeding precision)
  procedure test_is_numeric_exceeds_precision;

  --%test(is_numeric returns false for non-numeric string)
  procedure test_is_numeric_non_numeric_string;

  --%test(Test edge cases in numeric conversion)
  procedure test_edge_cases_numeric;

  --%endcontext

  /* ========================================================================================================
     context: XML and CLOB operations
     ======================================================================================================== */

  --%context(xml and clob operations)

  --%test(xml_getclobval converts xmltype to clob)
  procedure test_xml_getclobval;

  --%test(xml_getstringval converts xmltype to string)
  procedure test_xml_getstringval;

  --%test(clob2blob converts clob to blob)
  procedure test_clob2blob;

  --%test(clob2blob result has correct length)
  procedure test_clob2blob_length;

  --%endcontext

  /* ========================================================================================================
     context: unit conversion examples
     ======================================================================================================== */

  --%context(unit conversion examples)

  --%test(Test unit conversion example cases)
  procedure test_convert_unit_examples;

  --%endcontext

  /* ========================================================================================================
     context: truncate table
     ======================================================================================================== */

  --%context(truncate table)

  --%test(Test safe truncate table operation)
  procedure test_truncate_table_safe;

  --%endcontext

  /* ========================================================================================================
     context: NLS and timezone operations
     ======================================================================================================== */

  --%context(nls and timezone operations)

  --%test(Keep, set and reset NLS session settings)
  procedure test_session_nls_set_reset;

  --%test(Keep, set and reset timestamp_tz format)
  procedure test_nls_timestamp_format_set_reset;

  --%test(Keep, set and reset session timezone)
  procedure test_session_timezone_set_reset;

  --%test(Keep, set session english and reset)
  procedure test_set_session_english_roundtrip;

  --%endcontext

  /* ========================================================================================================
     context: unit conversion with resolution
     ======================================================================================================== */

  --%context(unit conversion with resolution)

  --%test(Convert energy to power with resolution PT60M)
  procedure test_convert_kwh_to_kw_pt60m;

  --%test(Convert power to energy with resolution PT15M)
  procedure test_convert_kw_to_kwh_pt15m;

  --%test(Convert wh to mw with resolution PT30M)
  procedure test_convert_wh_to_mw_pt30m;

  --%endcontext

  /* ========================================================================================================
     context: unit conversion simple (3 arguments)
     ======================================================================================================== */

  --%context(unit conversion simple)

  --%test(GW to KW conversion without resolution)
  procedure test_convert_gw_to_kw;

  --%test(GW to MW conversion without resolution)
  procedure test_convert_gw_to_mw;

  --%test(GW to W conversion without resolution)
  procedure test_convert_gw_to_w;

  --%test(KW to GW conversion without resolution)
  procedure test_convert_kw_to_gw;

  --%test(KW to MW conversion without resolution)
  procedure test_convert_kw_to_mw;

  --%test(KW to W conversion without resolution)
  procedure test_convert_kw_to_w;

  --%test(MW to GW conversion without resolution)
  procedure test_convert_mw_to_gw;

  --%test(MW to KW conversion without resolution)
  procedure test_convert_mw_to_kw;

  --%test(MW to W conversion without resolution)
  procedure test_convert_mw_to_w;

  --%test(W to GW conversion without resolution)
  procedure test_convert_w_to_gw;

  --%test(W to KW conversion without resolution)
  procedure test_convert_w_to_kw;

  --%test(W to MW conversion without resolution)
  procedure test_convert_w_to_mw;

  --%test(Identity conversions same unit)
  procedure test_convert_unit_identity_operations;

  --%endcontext

end sup_utilities_test;
/