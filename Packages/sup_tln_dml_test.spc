create or replace package sup_tln_dml_test is
  
  --%suite(sup_tln_dml - Translation DML Unit Tests)
  --%rollback(manual)
  
  --%beforeall
  procedure setup;

  --%afterall
  procedure cleanup;

  /* ========================================================================================================
     Context: Version Number Management
     ======================================================================================================== */

  --%context(Version Number)

  --%test(get_versionnumber returns valid version number)
  procedure get_versionnumber_not_null;

  --%test(get_versionnumber returns non-empty string)
  procedure get_versionnumber_format;

  --%endcontext

  /* ========================================================================================================
     Context: Insert Operations (ins_row)
     ======================================================================================================== */

  --%context(Insert Row Operations)

  --%test(inserts new translation record successfully)
  procedure ins_row_basic;

  --%test(inserts record with all fields populated)
  procedure ins_row_with_full_data;

  --%test(inserts record with minimal required fields)
  procedure ins_row_minimal_fields;

  --%test(inserts multiple records sequentially)
  procedure ins_row_multiple;

  --%endcontext

  /* ========================================================================================================
     Context: Select Operations by Primary Key (get_row)
     ======================================================================================================== */

  --%context(Get Row by Primary Key)

  --%test(retrieves existing record by primary key)
  procedure get_row_by_pk_exists;

  --%test(returns null when record not found by primary key)
  procedure get_row_by_pk_not_found;

  --%test(retrieves record with all fields intact)
  procedure get_row_by_pk_full_data;

  --%endcontext

  /* ========================================================================================================
     Context: Select Operations by Business Key (get_row_bk)
     ======================================================================================================== */

  --%context(Get Row by Business Key)

  --%test(retrieves record by business key (element and code))
  procedure get_row_bk_by_code;

  --%test(retrieves record by business key (element and translation))
  procedure get_row_bk_by_translation;

  --%test(returns null for non-existent business key)
  procedure get_row_bk_not_found;

  --%test(retrieves correct record among duplicates)
  procedure get_row_bk_with_duplicates;

  --%endcontext

  /* ========================================================================================================
     Context: Update Operations (upd_row)
     ======================================================================================================== */

  --%context(Update Row Operations)

  --%test(updates existing record successfully)
  procedure upd_row_basic;

  --%test(updates translation value)
  procedure upd_row_translation;

  --%test(updates validity dates)
  procedure upd_row_validity_dates;

  --%test(updates multiple fields at once)
  procedure upd_row_multiple_fields;

  --%endcontext

  /* ========================================================================================================
     Context: Delete Operations (del_row)
     ======================================================================================================== */

  --%context(Delete Row Operations)

  --%test(deletes existing record successfully)
  procedure del_row_basic;

  --%test(deletes record and verifies removal)
  procedure del_row_verify_deletion;

  --%test(deletion does not affect other records)
  procedure del_row_no_cascade;

  --%endcontext

  /* ========================================================================================================
     Context: Insert or Update Operations (insupd_row_bk)
     ======================================================================================================== */

  --%context(Insert or Update by Business Key)

  --%test(inserts new record when business key not found)
  procedure insupd_row_bk_insert;

  --%test(updates existing record when business key found)
  procedure insupd_row_bk_update;

  --%test(handles multiple insupd operations sequentially)
  procedure insupd_row_bk_multiple;

  --%endcontext

  /* ========================================================================================================
     Context: Error Handling and Edge Cases
     ======================================================================================================== */

  --%context(Error Handling)

  --%test(handles null element_name gracefully)
  procedure error_null_element;

  --%test(handles null code and translation gracefully)
  procedure error_null_code_translation;

  --%test(handles operations on invalid rowtype)
  procedure error_invalid_rowtype;

  --%endcontext

end sup_tln_dml_test;
