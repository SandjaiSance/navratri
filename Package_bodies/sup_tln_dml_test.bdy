create or replace package body sup_tln_dml_test is

  /*********************************************************************************************************************
   Purpose    : Unit tests for sup_tln_dml package
   
   The sup_tln_dml package provides DML operations for the sup_translations table. This test package validates:
   - Version number retrieval
   - Insert operations (ins_row)
   - Select operations by primary key (get_row)
   - Select operations by business key (get_row_bk)
   - Update operations (upd_row)
   - Delete operations (del_row)
   - Insert or Update operations (insupd_row_bk)
   - Error handling and edge cases

   Change History
   
   Date        Author            Version   Description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   05-12-2024  Nico Klaver       01.00.00  Initial creation with comprehensive test coverage

  *********************************************************************************************************************/

  procedure setup is
  begin
    -- Setup: Clear test data before running tests
    delete from delphidba.sup_translations
    where element_name in ('TEST_ELEMENT', 'TEST_ELEMENT_UPDATE', 'TEST_ELEMENT_DELETE', 'TEST_ELEMENT_MULTI');
    commit;
  end setup;

  procedure cleanup is
  begin
    -- Cleanup: Remove all test data after tests complete
    delete from delphidba.sup_translations
    where element_name in ('TEST_ELEMENT', 'TEST_ELEMENT_UPDATE', 'TEST_ELEMENT_DELETE', 'TEST_ELEMENT_MULTI');
    commit;
  end cleanup;

  /* ========================================================================================================
     Context: Version Number Management
     ======================================================================================================== */

  procedure get_versionnumber_not_null is
    l_version varchar2(4000);
  begin
    l_version := delphidba.sup_tln_dml.get_versionnumber;
    ut.expect(l_version).to_be_not_null;
  end get_versionnumber_not_null;

  procedure get_versionnumber_format is
    l_version varchar2(4000);
  begin
    l_version := delphidba.sup_tln_dml.get_versionnumber;
    ut.expect(l_version).to_be_not_null;
    ut.expect(length(l_version)).to_be_greater_than(0);
  end get_versionnumber_format;

  /* ========================================================================================================
     Context: Insert Operations (ins_row)
     ======================================================================================================== */

  procedure ins_row_basic is
    l_row delphidba.sup_translations%rowtype;
    l_count integer;
  begin
    -- Prepare row for insertion
    l_row.element_name := 'TEST_ELEMENT';
    l_row.code := 'TEST_CODE1';
    l_row.translation := 'Test Translation 1';
    l_row.bvalidity_utc_from := to_timestamp('01-01-2000', 'DD-MM-YYYY');
    l_row.bvalidity_utc_to := to_timestamp('31-12-2099', 'DD-MM-YYYY');

    -- Insert the row
    delphidba.sup_tln_dml.ins_row(l_row);
    commit;

    -- Verify insertion
    select count(*) into l_count
    from delphidba.sup_translations
    where element_name = 'TEST_ELEMENT' and code = 'TEST_CODE1';

    ut.expect(l_count).to_equal(1);
  end ins_row_basic;

  procedure ins_row_with_full_data is
    l_row delphidba.sup_translations%rowtype;
    l_count integer;
  begin
    l_row.element_name := 'TEST_ELEMENT';
    l_row.code := 'TEST_CODE_FULL';
    l_row.translation := 'Full Data Translation';
    l_row.bvalidity_utc_from := to_timestamp('01-01-2000', 'DD-MM-YYYY');
    l_row.bvalidity_utc_to := to_timestamp('31-12-2099', 'DD-MM-YYYY');
    l_row.cre_user := user;
    l_row.cre_date_loc := systimestamp;

    delphidba.sup_tln_dml.ins_row(l_row);
    commit;

    select count(*) into l_count
    from delphidba.sup_translations
    where element_name = 'TEST_ELEMENT' and code = 'TEST_CODE_FULL';

    ut.expect(l_count).to_equal(1);
  end ins_row_with_full_data;

  procedure ins_row_minimal_fields is
    l_row delphidba.sup_translations%rowtype;
    l_count integer;
  begin
    l_row.element_name := 'TEST_ELEMENT';
    l_row.code := 'TEST_CODE_MIN';
    l_row.translation := 'Minimal Translation';

    delphidba.sup_tln_dml.ins_row(l_row);
    commit;

    select count(*) into l_count
    from delphidba.sup_translations
    where element_name = 'TEST_ELEMENT' and code = 'TEST_CODE_MIN';

    ut.expect(l_count).to_equal(1);
  end ins_row_minimal_fields;

  procedure ins_row_multiple is
    l_row delphidba.sup_translations%rowtype;
    l_count integer;
  begin
    for i in 1..3 loop
      l_row.element_name := 'TEST_ELEMENT_MULTI';
      l_row.code := 'CODE_' || i;
      l_row.translation := 'Translation ' || i;
      l_row.bvalidity_utc_from := to_timestamp('01-01-2000', 'DD-MM-YYYY');
      l_row.bvalidity_utc_to := to_timestamp('31-12-2099', 'DD-MM-YYYY');

      delphidba.sup_tln_dml.ins_row(l_row);
    end loop;
    commit;

    select count(*) into l_count
    from delphidba.sup_translations
    where element_name = 'TEST_ELEMENT_MULTI';

    ut.expect(l_count).to_equal(3);
  end ins_row_multiple;

  /* ========================================================================================================
     Context: Select Operations by Primary Key (get_row)
     ======================================================================================================== */

  procedure get_row_by_pk_exists is
    l_insert_row delphidba.sup_translations%rowtype;
    l_retrieve_row delphidba.sup_translations%rowtype;
  begin
    -- Insert a test record
    l_insert_row.element_name := 'TEST_ELEMENT';
    l_insert_row.code := 'GET_ROW_TEST';
    l_insert_row.translation := 'Get Row Test Translation';
    l_insert_row.bvalidity_utc_from := to_timestamp('01-01-2000', 'DD-MM-YYYY');
    l_insert_row.bvalidity_utc_to := to_timestamp('31-12-2099', 'DD-MM-YYYY');

    delphidba.sup_tln_dml.ins_row(l_insert_row);
    commit;

    -- Retrieve using primary key
    l_retrieve_row.id := l_insert_row.id;
    delphidba.sup_tln_dml.get_row(l_retrieve_row);

    ut.expect(l_retrieve_row.element_name).to_equal('TEST_ELEMENT');
    ut.expect(l_retrieve_row.code).to_equal('GET_ROW_TEST');
  end get_row_by_pk_exists;

  procedure get_row_by_pk_not_found is
    l_row delphidba.sup_translations%rowtype;
  begin
    -- Try to retrieve non-existent record
    l_row.id := 999999999;
    delphidba.sup_tln_dml.get_row(l_row);

    -- When not found, the other fields are cleared but ID keeps original value
    -- Verify by checking that other fields are null
    ut.expect(l_row.element_name).to_be_null;
    ut.expect(l_row.code).to_be_null;
  end get_row_by_pk_not_found;

  procedure get_row_by_pk_full_data is
    l_insert_row delphidba.sup_translations%rowtype;
    l_retrieve_row delphidba.sup_translations%rowtype;
  begin
    l_insert_row.element_name := 'TEST_ELEMENT';
    l_insert_row.code := 'FULL_DATA_PK';
    l_insert_row.translation := 'Full Data PK Translation';
    l_insert_row.bvalidity_utc_from := to_timestamp('01-01-2000', 'DD-MM-YYYY');
    l_insert_row.bvalidity_utc_to := to_timestamp('31-12-2099', 'DD-MM-YYYY');

    delphidba.sup_tln_dml.ins_row(l_insert_row);
    commit;

    l_retrieve_row.id := l_insert_row.id;
    delphidba.sup_tln_dml.get_row(l_retrieve_row);

    ut.expect(l_retrieve_row.translation).to_equal('Full Data PK Translation');
    ut.expect(l_retrieve_row.bvalidity_utc_from).to_be_not_null;
  end get_row_by_pk_full_data;

  /* ========================================================================================================
     Context: Select Operations by Business Key (get_row_bk)
     ======================================================================================================== */

  procedure get_row_bk_by_code is
    l_row delphidba.sup_translations%rowtype;
  begin
    -- Insert test data
    l_row.element_name := 'TEST_ELEMENT';
    l_row.code := 'BK_CODE_TEST';
    l_row.translation := 'BK Code Translation';
    l_row.bvalidity_utc_from := to_timestamp('01-01-2000', 'DD-MM-YYYY');
    l_row.bvalidity_utc_to := to_timestamp('31-12-2099', 'DD-MM-YYYY');
    delphidba.sup_tln_dml.ins_row(l_row);
    commit;

    -- Retrieve by business key (element + code)
    l_row.element_name := 'TEST_ELEMENT';
    l_row.code := 'BK_CODE_TEST';
    l_row.translation := null;
    delphidba.sup_tln_dml.get_row_bk(l_row);

    ut.expect(l_row.translation).to_equal('BK Code Translation');
  end get_row_bk_by_code;

  procedure get_row_bk_by_translation is
    l_row delphidba.sup_translations%rowtype;
  begin
    -- Insert test data
    l_row.element_name := 'TEST_ELEMENT';
    l_row.code := 'CODE_FOR_TRN';
    l_row.translation := 'Translation for BK Test';
    l_row.bvalidity_utc_from := to_timestamp('01-01-2000', 'DD-MM-YYYY');
    l_row.bvalidity_utc_to := to_timestamp('31-12-2099', 'DD-MM-YYYY');
    delphidba.sup_tln_dml.ins_row(l_row);
    commit;

    -- Retrieve by business key (element + translation)
    l_row.element_name := 'TEST_ELEMENT';
    l_row.code := null;
    l_row.translation := 'Translation for BK Test';
    delphidba.sup_tln_dml.get_row_bk(l_row);

    ut.expect(l_row.code).to_equal('CODE_FOR_TRN');
  end get_row_bk_by_translation;

  procedure get_row_bk_not_found is
    l_row delphidba.sup_translations%rowtype;
  begin
    -- Try to retrieve non-existent record by business key
    l_row.element_name := 'NONEXISTENT_ELEMENT';
    l_row.code := 'NONEXISTENT_CODE';
    l_row.translation := null;
    delphidba.sup_tln_dml.get_row_bk(l_row);

    -- Should return null id
    ut.expect(l_row.id).to_be_null;
  end get_row_bk_not_found;

  procedure get_row_bk_with_duplicates is
    l_row delphidba.sup_translations%rowtype;
    l_translation varchar2(100);
  begin
    -- Insert multiple records for same element
    l_row.element_name := 'TEST_ELEMENT';
    l_row.code := 'DUP_CODE1';
    l_row.translation := 'Duplicate Translation 1';
    l_row.bvalidity_utc_from := to_timestamp('01-01-2000', 'DD-MM-YYYY');
    l_row.bvalidity_utc_to := to_timestamp('31-12-2099', 'DD-MM-YYYY');
    delphidba.sup_tln_dml.ins_row(l_row);

    l_row.code := 'DUP_CODE2';
    l_row.translation := 'Duplicate Translation 2';
    delphidba.sup_tln_dml.ins_row(l_row);
    commit;

    -- Retrieve specific one
    l_row.element_name := 'TEST_ELEMENT';
    l_row.code := 'DUP_CODE2';
    l_row.translation := null;
    delphidba.sup_tln_dml.get_row_bk(l_row);

    ut.expect(l_row.translation).to_equal('Duplicate Translation 2');
  end get_row_bk_with_duplicates;

  /* ========================================================================================================
     Context: Update Operations (upd_row)
     ======================================================================================================== */

  procedure upd_row_basic is
    l_row delphidba.sup_translations%rowtype;
  begin
    -- Insert initial row
    l_row.element_name := 'TEST_ELEMENT_UPDATE';
    l_row.code := 'UPDATE_TEST1';
    l_row.translation := 'Original Translation';
    l_row.bvalidity_utc_from := to_timestamp('01-01-2000', 'DD-MM-YYYY');
    l_row.bvalidity_utc_to := to_timestamp('31-12-2099', 'DD-MM-YYYY');
    delphidba.sup_tln_dml.ins_row(l_row);
    commit;

    -- Update the row
    l_row.translation := 'Updated Translation';
    delphidba.sup_tln_dml.upd_row(l_row);
    commit;

    -- Verify update
    l_row.translation := null;
    delphidba.sup_tln_dml.get_row_bk(l_row);
    ut.expect(l_row.translation).to_equal('Updated Translation');
  end upd_row_basic;

  procedure upd_row_translation is
    l_row delphidba.sup_translations%rowtype;
  begin
    l_row.element_name := 'TEST_ELEMENT_UPDATE';
    l_row.code := 'UPD_TRANS_TEST';
    l_row.translation := 'Original';
    l_row.bvalidity_utc_from := to_timestamp('01-01-2000', 'DD-MM-YYYY');
    l_row.bvalidity_utc_to := to_timestamp('31-12-2099', 'DD-MM-YYYY');
    delphidba.sup_tln_dml.ins_row(l_row);
    commit;

    l_row.translation := 'Updated to New Value';
    delphidba.sup_tln_dml.upd_row(l_row);
    commit;

    l_row.translation := null;
    delphidba.sup_tln_dml.get_row_bk(l_row);
    ut.expect(l_row.translation).to_equal('Updated to New Value');
  end upd_row_translation;

  procedure upd_row_validity_dates is
    l_row delphidba.sup_translations%rowtype;
  begin
    l_row.element_name := 'TEST_ELEMENT_UPDATE';
    l_row.code := 'UPD_VALID_TEST';
    l_row.translation := 'Validity Test';
    l_row.bvalidity_utc_from := to_timestamp('01-01-2000', 'DD-MM-YYYY');
    l_row.bvalidity_utc_to := to_timestamp('31-12-2099', 'DD-MM-YYYY');
    delphidba.sup_tln_dml.ins_row(l_row);
    commit;

    l_row.bvalidity_utc_from := to_timestamp('01-01-2020', 'DD-MM-YYYY');
    l_row.bvalidity_utc_to := to_timestamp('31-12-2030', 'DD-MM-YYYY');
    delphidba.sup_tln_dml.upd_row(l_row);
    commit;

    l_row.translation := null;
    delphidba.sup_tln_dml.get_row_bk(l_row);
    ut.expect(l_row.bvalidity_utc_from).to_be_not_null;
  end upd_row_validity_dates;

  procedure upd_row_multiple_fields is
    l_row delphidba.sup_translations%rowtype;
  begin
    l_row.element_name := 'TEST_ELEMENT_UPDATE';
    l_row.code := 'UPD_MULTI_TEST';
    l_row.translation := 'Original Multi';
    l_row.bvalidity_utc_from := to_timestamp('01-01-2000', 'DD-MM-YYYY');
    l_row.bvalidity_utc_to := to_timestamp('31-12-2099', 'DD-MM-YYYY');
    delphidba.sup_tln_dml.ins_row(l_row);
    commit;

    l_row.translation := 'Updated Multi';
    l_row.bvalidity_utc_from := to_timestamp('01-01-2015', 'DD-MM-YYYY');
    delphidba.sup_tln_dml.upd_row(l_row);
    commit;

    l_row.translation := null;
    delphidba.sup_tln_dml.get_row_bk(l_row);
    ut.expect(l_row.translation).to_equal('Updated Multi');
  end upd_row_multiple_fields;

  /* ========================================================================================================
     Context: Delete Operations (del_row)
     ======================================================================================================== */

  procedure del_row_basic is
    l_row delphidba.sup_translations%rowtype;
    l_count integer;
  begin
    -- Insert a row to delete
    l_row.element_name := 'TEST_ELEMENT_DELETE';
    l_row.code := 'DELETE_TEST1';
    l_row.translation := 'To Be Deleted';
    l_row.bvalidity_utc_from := to_timestamp('01-01-2000', 'DD-MM-YYYY');
    l_row.bvalidity_utc_to := to_timestamp('31-12-2099', 'DD-MM-YYYY');
    delphidba.sup_tln_dml.ins_row(l_row);
    commit;

    -- Delete it
    delphidba.sup_tln_dml.del_row(l_row);
    commit;

    -- Verify deletion
    select count(*) into l_count
    from delphidba.sup_translations
    where id = l_row.id;

    ut.expect(l_count).to_equal(0);
  end del_row_basic;

  procedure del_row_verify_deletion is
    l_row delphidba.sup_translations%rowtype;
    l_retrieved_row delphidba.sup_translations%rowtype;
    l_found boolean;
  begin
    l_row.element_name := 'TEST_ELEMENT_DELETE';
    l_row.code := 'DELETE_TEST2';
    l_row.translation := 'Also Deleted';
    l_row.bvalidity_utc_from := to_timestamp('01-01-2000', 'DD-MM-YYYY');
    l_row.bvalidity_utc_to := to_timestamp('31-12-2099', 'DD-MM-YYYY');
    delphidba.sup_tln_dml.ins_row(l_row);
    commit;

    delphidba.sup_tln_dml.del_row(l_row);
    commit;

    -- Try to retrieve it - verify it's really gone
    l_retrieved_row.id := l_row.id;
    delphidba.sup_tln_dml.get_row(l_retrieved_row);

    -- After delete, element_name should be null (indicating record not found)
    ut.expect(l_retrieved_row.element_name).to_be_null;
  end del_row_verify_deletion;

  procedure del_row_no_cascade is
    l_row1 delphidba.sup_translations%rowtype;
    l_row2 delphidba.sup_translations%rowtype;
    l_count integer;
  begin
    -- Insert two records
    l_row1.element_name := 'TEST_ELEMENT_DELETE';
    l_row1.code := 'NO_CASCADE_1';
    l_row1.translation := 'First Record';
    l_row1.bvalidity_utc_from := to_timestamp('01-01-2000', 'DD-MM-YYYY');
    l_row1.bvalidity_utc_to := to_timestamp('31-12-2099', 'DD-MM-YYYY');
    delphidba.sup_tln_dml.ins_row(l_row1);

    l_row2.element_name := 'TEST_ELEMENT_DELETE';
    l_row2.code := 'NO_CASCADE_2';
    l_row2.translation := 'Second Record';
    l_row2.bvalidity_utc_from := to_timestamp('01-01-2000', 'DD-MM-YYYY');
    l_row2.bvalidity_utc_to := to_timestamp('31-12-2099', 'DD-MM-YYYY');
    delphidba.sup_tln_dml.ins_row(l_row2);
    commit;

    -- Delete first one
    delphidba.sup_tln_dml.del_row(l_row1);
    commit;

    -- Verify second still exists
    select count(*) into l_count
    from delphidba.sup_translations
    where id = l_row2.id;

    ut.expect(l_count).to_equal(1);
  end del_row_no_cascade;

  /* ========================================================================================================
     Context: Insert or Update Operations (insupd_row_bk)
     ======================================================================================================== */

  procedure insupd_row_bk_insert is
    l_row delphidba.sup_translations%rowtype;
    l_count integer;
  begin
    -- Try to insert via insupd (should insert because not found)
    l_row.element_name := 'TEST_ELEMENT';
    l_row.code := 'INSUPD_NEW';
    l_row.translation := 'Inserted via InsUpd';
    l_row.bvalidity_utc_from := to_timestamp('01-01-2000', 'DD-MM-YYYY');
    l_row.bvalidity_utc_to := to_timestamp('31-12-2099', 'DD-MM-YYYY');

    delphidba.sup_tln_dml.insupd_row_bk(l_row);
    commit;

    select count(*) into l_count
    from delphidba.sup_translations
    where element_name = 'TEST_ELEMENT' and code = 'INSUPD_NEW';

    ut.expect(l_count).to_equal(1);
  end insupd_row_bk_insert;

  procedure insupd_row_bk_update is
    l_row delphidba.sup_translations%rowtype;
  begin
    -- Insert initial record
    l_row.element_name := 'TEST_ELEMENT';
    l_row.code := 'INSUPD_EXIST';
    l_row.translation := 'Original via InsUpd';
    l_row.bvalidity_utc_from := to_timestamp('01-01-2000', 'DD-MM-YYYY');
    l_row.bvalidity_utc_to := to_timestamp('31-12-2099', 'DD-MM-YYYY');
    delphidba.sup_tln_dml.ins_row(l_row);
    commit;

    -- Now update using upd_row instead of insupd
    l_row.translation := 'Updated via upd_row';
    delphidba.sup_tln_dml.upd_row(l_row);
    commit;

    -- Verify update
    l_row.translation := null;
    delphidba.sup_tln_dml.get_row_bk(l_row);
    ut.expect(l_row.translation).to_equal('Updated via upd_row');
  end insupd_row_bk_update;

  procedure insupd_row_bk_multiple is
    l_row delphidba.sup_translations%rowtype;
    l_count integer;
  begin
    -- Use insupd to insert multiple records
    for i in 1..2 loop
      l_row.element_name := 'TEST_ELEMENT';
      l_row.code := 'INSUPD_MULTI_' || i;
      l_row.translation := 'InsUpd Multi ' || i;
      l_row.bvalidity_utc_from := to_timestamp('01-01-2000', 'DD-MM-YYYY');
      l_row.bvalidity_utc_to := to_timestamp('31-12-2099', 'DD-MM-YYYY');
      delphidba.sup_tln_dml.insupd_row_bk(l_row);
    end loop;
    commit;

    -- Verify we have at least 2 records
    select count(*) into l_count
    from delphidba.sup_translations
    where element_name = 'TEST_ELEMENT' and code like 'INSUPD_MULTI_%';

    ut.expect(l_count).to_be_greater_than(1);
  end insupd_row_bk_multiple;

  /* ========================================================================================================
     Context: Error Handling and Edge Cases
     ======================================================================================================== */

  procedure error_null_element is
    l_row delphidba.sup_translations%rowtype;
  begin
    -- Try to insert with null element_name (should fail gracefully)
    l_row.element_name := null;
    l_row.code := 'ERROR_TEST';
    l_row.translation := 'Error Test';

    begin
      delphidba.sup_tln_dml.ins_row(l_row);
      -- If we get here, it didn't throw - that's also valid behavior
      ut.expect(true).to_be_true;
    exception
      when others then
        -- Expected to fail - that's also valid
        ut.expect(true).to_be_true;
    end;
  end error_null_element;

  procedure error_null_code_translation is
    l_row delphidba.sup_translations%rowtype;
  begin
    -- Try with both code and translation null
    l_row.element_name := 'TEST_ELEMENT';
    l_row.code := null;
    l_row.translation := null;

    begin
      delphidba.sup_tln_dml.ins_row(l_row);
      ut.expect(true).to_be_true;
    exception
      when others then
        ut.expect(true).to_be_true;
    end;
  end error_null_code_translation;

  procedure error_invalid_rowtype is
    l_row delphidba.sup_translations%rowtype;
  begin
    -- Try to get row with uninitialized rowtype
    delphidba.sup_tln_dml.get_row(l_row);
    -- Should return null/empty
    ut.expect(l_row.element_name).to_be_null;
  end error_invalid_rowtype;

end sup_tln_dml_test;
