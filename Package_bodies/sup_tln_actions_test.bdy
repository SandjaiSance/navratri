create or replace package body sup_tln_actions_test is

  /*********************************************************************************************************************
   Purpose    : Unit tests for sup_tln_actions package
   
   The sup_tln_actions package provides translation management functionality. This test package validates:
   - Version number retrieval
   - Translation lookups (code to translation mapping)
   - Reverse code lookups (translation to code mapping)
   - Default value handling for null/non-existent codes
   - Cache behavior and consistency
   - Error handling for invalid inputs

   Change History
   
   Date        Author            Version   Description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   04-12-2024  Nico Klaver       01.00.00  Initial creation

  *********************************************************************************************************************/
  cn_test_package constant varchar2(256) := 'SUP_TLN_ACTIONS_TEST';
  
  procedure setup is
  begin
    -- Setup test data once for all tests
    -- Clear any existing test data
    delete from delphidba.sup_translations
    where element_name in ('TEST_ELEMENT', 'TEST_ELEMENT_EMPTY', 'TEST_ELEMENT_CASE');

    -- Insert standard test data with validity dates
    insert into delphidba.sup_translations (id, element_name, code, translation, bvalidity_utc_from, bvalidity_utc_to)
    values (sup_tln_seq.nextval, 'TEST_ELEMENT', 'CODE1', 'Translation 1', 
            to_timestamp('01-01-2000', 'DD-MM-YYYY'), to_timestamp('31-12-2099', 'DD-MM-YYYY'));

    insert into delphidba.sup_translations (id, element_name, code, translation, bvalidity_utc_from, bvalidity_utc_to)
    values (sup_tln_seq.nextval, 'TEST_ELEMENT', 'CODE2', 'Translation 2',
            to_timestamp('01-01-2000', 'DD-MM-YYYY'), to_timestamp('31-12-2099', 'DD-MM-YYYY'));

    insert into delphidba.sup_translations (id, element_name, code, translation, bvalidity_utc_from, bvalidity_utc_to)
    values (sup_tln_seq.nextval, 'TEST_ELEMENT', 'CODE3', 'Translation 3',
            to_timestamp('01-01-2000', 'DD-MM-YYYY'), to_timestamp('31-12-2099', 'DD-MM-YYYY'));

    insert into delphidba.sup_translations (id, element_name, code, translation, bvalidity_utc_from, bvalidity_utc_to)
    values (sup_tln_seq.nextval, 'TEST_ELEMENT', '##', 'Default Translation',
            to_timestamp('01-01-2000', 'DD-MM-YYYY'), to_timestamp('31-12-2099', 'DD-MM-YYYY'));

    -- Test data for case sensitivity
    insert into delphidba.sup_translations (id, element_name, code, translation, bvalidity_utc_from, bvalidity_utc_to)
    values (sup_tln_seq.nextval, 'TEST_ELEMENT_CASE', 'UPPER', 'Upper Translation',
            to_timestamp('01-01-2000', 'DD-MM-YYYY'), to_timestamp('31-12-2099', 'DD-MM-YYYY'));

    insert into delphidba.sup_translations (id, element_name, code, translation, bvalidity_utc_from, bvalidity_utc_to)
    values (sup_tln_seq.nextval, 'TEST_ELEMENT_CASE', '##', 'Default Case Translation',
            to_timestamp('01-01-2000', 'DD-MM-YYYY'), to_timestamp('31-12-2099', 'DD-MM-YYYY'));

    commit;
  end setup;

  procedure cleanup is
  begin
    -- Cleanup test data after all tests
    delete from delphidba.sup_translations
    where element_name in ('TEST_ELEMENT', 'TEST_ELEMENT_EMPTY', 'TEST_ELEMENT_CASE');
    commit;
  end cleanup;

  /* ========================================================================================================
     Context: Version Number Management
     ======================================================================================================== */

  procedure get_versionnumber_latest is
    l_version varchar2(4000);
  begin
    l_version := delphidba.sup_tln_actions.get_versionnumber;
    ut.expect(l_version).to_be_not_null;
    -- Verify it contains version equel to cn_version_number (latest version)
    ut.expect(l_version).to_equal(cn_version_number);
  end get_versionnumber_latest;

  /* ========================================================================================================
     Context: Translation Lookup (Code to Translation Mapping)
     ======================================================================================================== */

  procedure get_translation_basic is
    l_translation varchar2(4000);
  begin
    l_translation := delphidba.sup_tln_actions.get_translation(
      p_tln_elm  => 'TEST_ELEMENT',
      p_tln_code => 'CODE1'
    );

    ut.expect(l_translation).to_equal('Translation 1');
  end get_translation_basic;

  procedure get_translation_with_uppercase is
    l_translation varchar2(4000);
  begin
    -- Verify uppercase element names work
    l_translation := delphidba.sup_tln_actions.get_translation(
      p_tln_elm  => 'TEST_ELEMENT',
      p_tln_code => 'CODE2'
    );

    ut.expect(l_translation).to_equal('Translation 2');
  end get_translation_with_uppercase;

  procedure get_translation_null_code is
    l_translation varchar2(4000);
  begin
    -- When code is null, it should use '##' as default
    l_translation := delphidba.sup_tln_actions.get_translation(
      p_tln_elm  => 'TEST_ELEMENT',
      p_tln_code => null
    );

    ut.expect(l_translation).to_equal('Default Translation');
  end get_translation_null_code;

  procedure get_translation_non_existent_code is
    l_translation varchar2(4000);
  begin
    -- Non-existent code should return null (not fallback to default)
    -- Only explicit NULL code converts to '##', not non-existent codes
    l_translation := delphidba.sup_tln_actions.get_translation(
      p_tln_elm  => 'TEST_ELEMENT',
      p_tln_code => 'NONEXISTENT_CODE'
    );

    ut.expect(l_translation).to_be_null;
  end get_translation_non_existent_code;

  procedure get_translation_non_existent_element is
    l_translation varchar2(4000);
  begin
    -- Non-existent element should return null
    l_translation := delphidba.sup_tln_actions.get_translation(
      p_tln_elm  => 'NONEXISTENT_ELEMENT',
      p_tln_code => 'CODE1'
    );

    ut.expect(l_translation).to_be_null;
  end get_translation_non_existent_element;

  /* ========================================================================================================
     Context: Reverse Code Lookup (Translation to Code Mapping)
     ======================================================================================================== */

  procedure get_code_basic is
    l_code varchar2(4000);
  begin
    l_code := delphidba.sup_tln_actions.get_code(
      p_tln_elm         => 'TEST_ELEMENT',
      p_tln_translation => 'Translation 2'
    );

    ut.expect(l_code).to_equal('CODE2');
  end get_code_basic;

  procedure get_code_different_element is
    l_code varchar2(4000);
  begin
    l_code := delphidba.sup_tln_actions.get_code(
      p_tln_elm         => 'TEST_ELEMENT_CASE',
      p_tln_translation => 'Upper Translation'
    );

    ut.expect(l_code).to_equal('UPPER');
  end get_code_different_element;

  procedure get_code_non_existent_translation is
    l_code varchar2(4000);
  begin
    l_code := delphidba.sup_tln_actions.get_code(
      p_tln_elm         => 'TEST_ELEMENT',
      p_tln_translation => 'Nonexistent Translation'
    );

    ut.expect(l_code).to_be_null;
  end get_code_non_existent_translation;

  procedure get_code_non_existent_element is
    l_code varchar2(4000);
  begin
    l_code := delphidba.sup_tln_actions.get_code(
      p_tln_elm         => 'NONEXISTENT_ELEMENT',
      p_tln_translation => 'Translation 1'
    );

    ut.expect(l_code).to_be_null;
  end get_code_non_existent_element;

  /* ========================================================================================================
     Context: Error Handling and Edge Cases
     ======================================================================================================== */

  procedure get_translation_null_element is
    l_translation varchar2(4000);
  begin
    -- Null element should handle gracefully (return null)
    l_translation := delphidba.sup_tln_actions.get_translation(
      p_tln_elm  => null,
      p_tln_code => 'CODE1'
    );

    ut.expect(l_translation).to_be_null;
  end get_translation_null_element;

  procedure get_code_null_element is
    l_code varchar2(4000);
  begin
    -- Null element should handle gracefully
    l_code := delphidba.sup_tln_actions.get_code(
      p_tln_elm         => null,
      p_tln_translation => 'Translation 1'
    );

    ut.expect(l_code).to_be_null;
  end get_code_null_element;

  /* ========================================================================================================
     Context: Cache Behavior and Consistency
     ======================================================================================================== */

  procedure get_translation_cache_consistency is
    l_translation_1 varchar2(4000);
    l_translation_2 varchar2(4000);
  begin
    -- First call
    l_translation_1 := delphidba.sup_tln_actions.get_translation(
      p_tln_elm  => 'TEST_ELEMENT',
      p_tln_code => 'CODE1'
    );

    -- Second call - should use cache
    l_translation_2 := delphidba.sup_tln_actions.get_translation(
      p_tln_elm  => 'TEST_ELEMENT',
      p_tln_code => 'CODE1'
    );

    ut.expect(l_translation_1).to_equal(l_translation_2);
    ut.expect(l_translation_1).to_equal('Translation 1');
  end get_translation_cache_consistency;

  procedure get_translation_consistency is
    l_translation_1 varchar2(4000);
    l_translation_2 varchar2(4000);
    l_translation_3 varchar2(4000);
  begin
    -- Verify multiple different translations are consistent
    l_translation_1 := delphidba.sup_tln_actions.get_translation(
      p_tln_elm  => 'TEST_ELEMENT',
      p_tln_code => 'CODE1'
    );

    l_translation_2 := delphidba.sup_tln_actions.get_translation(
      p_tln_elm  => 'TEST_ELEMENT',
      p_tln_code => 'CODE2'
    );

    l_translation_3 := delphidba.sup_tln_actions.get_translation(
      p_tln_elm  => 'TEST_ELEMENT',
      p_tln_code => 'CODE1'
    );

    -- First and third calls should match (same parameters)
    ut.expect(l_translation_1).to_equal(l_translation_3);

    -- Second call should be different
    ut.expect(l_translation_2).not_to_equal(l_translation_1);
  end get_translation_consistency;

end sup_tln_actions_test;
/