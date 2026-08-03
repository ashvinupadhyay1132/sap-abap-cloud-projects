" ============================================================================
" CLASS: zcl_test_abapgit_bdef
" PURPOSE: Automated ABAP Unit Test Suite for abapGit RAP BDEF Serializer
" TEST-DRIVEN DEVELOPMENT (TDD): Uses cl_abap_unit_assert to verify serialization
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_test_abapgit_bdef DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS .

  PRIVATE SECTION.
    METHODS setup.
    METHODS teardown.

    METHODS test_bdef_serialization FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS zcl_test_abapgit_bdef IMPLEMENTATION.

  METHOD setup.
  ENDMETHOD.

  METHOD teardown.
  ENDMETHOD.

  METHOD test_bdef_serialization.
    DATA(lo_serializer) = NEW zcl_abapgit_object_bdef( ).

    lo_serializer->serialize_bdef(
      EXPORTING
        iv_bdef_name = 'ZBDEF_INVOICE_H'
      IMPORTING
        ev_xml_data  = DATA(lv_xml)
    ).

    cl_abap_unit_assert=>assert_char_cp(
      act = lv_xml
      exp = '*<NAME>ZBDEF_INVOICE_H</NAME>*'
      msg = 'abapGit serialization XML must contain target BDEF name'
    ).
  ENDMETHOD.

ENDCLASS.
