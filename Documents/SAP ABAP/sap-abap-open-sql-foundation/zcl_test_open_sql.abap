" ============================================================================
" CLASS: zcl_test_open_sql
" PURPOSE: Automated ABAP Unit Test Suite for Open SQL Queries
" TEST-DRIVEN DEVELOPMENT (TDD): Uses cl_abap_unit_assert to verify SQL results
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_test_open_sql DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS .

  PRIVATE SECTION.
    METHODS setup.
    METHODS teardown.

    METHODS test_agency_validation FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS zcl_test_open_sql IMPLEMENTATION.

  METHOD setup.
  ENDMETHOD.

  METHOD teardown.
  ENDMETHOD.

  METHOD test_agency_validation.
    " Query database for valid agency ID
    SELECT SINGLE agency_id FROM /dmo/agency INTO @DATA(lv_agency_id).

    cl_abap_unit_assert=>assert_not_initial(
      act = lv_agency_id
      msg = 'Master data /dmo/agency should contain valid records'
    ).
  ENDMETHOD.

ENDCLASS.
