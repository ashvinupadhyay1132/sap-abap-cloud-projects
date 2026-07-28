" ============================================================================
" CLASS: zcl_test_rap_unmanaged_so
" PURPOSE: Automated ABAP Unit Test Suite for Unmanaged RAP Sales Order BO
" TEST-DRIVEN DEVELOPMENT (TDD): Uses cl_abap_unit_assert to verify EML CRUD
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_test_rap_unmanaged_so DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS .

  PRIVATE SECTION.
    METHODS setup.
    METHODS teardown.

    METHODS test_unmanaged_create FOR TESTING RAISING cx_static_check.
    METHODS test_unmanaged_read   FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS zcl_test_rap_unmanaged_so IMPLEMENTATION.

  METHOD setup.
    CLEAR zcl_bp_sales_order_u=>gt_so_buffer.
  ENDMETHOD.

  METHOD teardown.
    CLEAR zcl_bp_sales_order_u=>gt_so_buffer.
  ENDMETHOD.

  METHOD test_unmanaged_create.
    " EML Create Call to Unmanaged BO
    MODIFY ENTITIES OF zcds_i_sales_order_u
      ENTITY SalesOrder
        CREATE FIELDS ( Sales_Org Customer_ID Total_Order_Amount Currency )
        WITH VALUE #( ( %cid               = 'CID1'
                        Sales_Org          = '070001'
                        Customer_ID        = '000100'
                        Total_Order_Amount = 150000
                        Currency           = 'INR' ) )
      MAPPED DATA(ls_mapped)
      FAILED DATA(ls_failed).

    cl_abap_unit_assert=>assert_initial( act = ls_failed-salesorder msg = 'Unmanaged CREATE should not fail' ).
    cl_abap_unit_assert=>assert_not_initial( act = ls_mapped-salesorder msg = 'Mapped keys should return generated unmanaged key' ).
  ENDMETHOD.

  METHOD test_unmanaged_read.
    " Seed custom buffer
    APPEND VALUE #( sales_order_id = '90000101' sales_org = '070001' customer_id = '000100' total_price = 75000 currency_code = 'INR' order_status = 'O' )
      TO zcl_bp_sales_order_u=>gt_so_buffer.

    " EML Read Call
    READ ENTITIES OF zcds_i_sales_order_u
      ENTITY SalesOrder
        ALL FIELDS WITH VALUE #( ( Sales_Order_ID = '90000101' ) )
      RESULT DATA(lt_results).

    cl_abap_unit_assert=>assert_equals( act = lines( lt_results ) exp = 1 msg = 'Read should return exactly 1 order from unmanaged buffer' ).
    cl_abap_unit_assert=>assert_equals( act = lt_results[ 1 ]-Customer_ID exp = '000100' msg = 'Customer ID should match seeded value' ).
  ENDMETHOD.

ENDCLASS.
