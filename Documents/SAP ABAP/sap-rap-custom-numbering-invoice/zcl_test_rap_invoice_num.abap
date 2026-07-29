" ============================================================================
" CLASS: zcl_test_rap_invoice_num
" PURPOSE: Automated ABAP Unit Test Suite for RAP Early Custom Numbering
" TEST-DRIVEN DEVELOPMENT (TDD): Uses cl_abap_unit_assert to verify key generation
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_test_rap_invoice_num DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS .

  PRIVATE SECTION.
    METHODS setup.
    METHODS teardown.

    METHODS test_early_numbering_key_gen FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS zcl_test_rap_invoice_num IMPLEMENTATION.

  METHOD setup.
  ENDMETHOD.

  METHOD teardown.
  ENDMETHOD.

  METHOD test_early_numbering_key_gen.
    " EML Test Call triggering early numbering
    MODIFY ENTITIES OF zcds_i_invoice_h
      ENTITY InvoiceHeader
        CREATE FIELDS ( Company_Code Customer_ID Net_Amount Currency )
        WITH VALUE #( ( %cid         = 'CID_INV_01'
                        Company_Code = '070001'
                        Customer_ID  = '000100'
                        Net_Amount   = 350000
                        Currency     = 'INR' ) )
      MAPPED DATA(ls_mapped)
      FAILED DATA(ls_failed).

    cl_abap_unit_assert=>assert_initial( act = ls_failed-invoiceheader msg = 'Creation with early numbering should not fail' ).
    cl_abap_unit_assert=>assert_not_initial( act = ls_mapped-invoiceheader msg = 'Early numbering must generate non-initial document key' ).
  ENDMETHOD.

ENDCLASS.
