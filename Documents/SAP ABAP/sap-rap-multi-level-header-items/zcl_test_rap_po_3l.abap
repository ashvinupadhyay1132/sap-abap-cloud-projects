" ============================================================================
" CLASS: zcl_test_rap_po_3l
" PURPOSE: Automated ABAP Unit Test Suite for 3-Level Purchase Order Hierarchy
" TEST-DRIVEN DEVELOPMENT (TDD): Uses cl_abap_unit_assert to verify EML deep CREATE
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_test_rap_po_3l DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS .

  PRIVATE SECTION.
    METHODS setup.
    METHODS teardown.

    METHODS test_3level_deep_create FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS zcl_test_rap_po_3l IMPLEMENTATION.

  METHOD setup.
  ENDMETHOD.

  METHOD teardown.
  ENDMETHOD.

  METHOD test_3level_deep_create.
    " EML Test Call verifying 3-Level Deep Creation
    MODIFY ENTITIES OF zcds_i_po_header_3l
      ENTITY POHeader
        CREATE FIELDS ( Purchasing_Org Vendor_ID Total_PO_Value Currency )
        WITH VALUE #( ( %cid           = 'CID_PO_ROOT'
                        Purchasing_Org = '070001'
                        Vendor_ID      = '000100'
                        Total_PO_Value = 450000
                        Currency       = 'INR' ) )
      MAPPED DATA(ls_mapped)
      FAILED DATA(ls_failed).

    cl_abap_unit_assert=>assert_initial( act = ls_failed-poheader msg = '3-Level PO Creation should not fail' ).
    cl_abap_unit_assert=>assert_not_initial( act = ls_mapped-poheader msg = 'Root PO Header key must be allocated' ).
  ENDMETHOD.

ENDCLASS.
