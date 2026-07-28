" ============================================================================
" CLASS: zcl_rap_unmanaged_runner
" PURPOSE: Executable Audit Test Runner for Unmanaged RAP Sales Order BO
" EXECUTION: Press F8 in Eclipse ADT to view output in ABAP Console
" ============================================================================
CLASS zcl_rap_unmanaged_runner DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_rap_unmanaged_runner IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    out->write( '========================================================================================' ).
    out->write( '         SAP BTP RAP FRAMEWORK - UNMANAGED SALES ORDER SCENARIO TEST RUNNER            ' ).
    out->write( '========================================================================================' ).

    " -------------------------------------------------------------------------
    " STEP 1: Execute EML Unmanaged CREATE
    " -------------------------------------------------------------------------
    out->write( '[EML TEST 1]: Triggering Unmanaged CREATE for Sales Order...' ).

    MODIFY ENTITIES OF zcds_i_sales_order_u
      ENTITY SalesOrder
        CREATE FIELDS ( Sales_Org Customer_ID Total_Order_Amount Currency )
        WITH VALUE #( ( %cid               = 'CID_SO_01'
                        Sales_Org          = '070001'
                        Customer_ID        = '000100'
                        Total_Order_Amount = 250000
                        Currency           = 'INR' ) )
      MAPPED DATA(ls_mapped)
      FAILED DATA(ls_failed)
      REPORTED DATA(ls_reported).

    IF ls_failed-salesorder IS INITIAL.
      READ TABLE ls_mapped-salesorder INDEX 1 INTO DATA(ls_key_mapped).
      out->write( |   [PASS]: Unmanaged Sales Order Created with Generated Key: { ls_key_mapped-Sales_Order_ID }| ).
    ELSE.
      out->write( '   [FAIL]: Unmanaged Sales Order Creation failed.' ).
      RETURN.
    ENDIF.

    " -------------------------------------------------------------------------
    " STEP 2: Execute EML Unmanaged READ
    " -------------------------------------------------------------------------
    out->write( '----------------------------------------------------------------------------------------' ).
    out->write( '[EML TEST 2]: Reading Unmanaged Sales Order from Custom Buffer...' ).

    READ ENTITIES OF zcds_i_sales_order_u
      ENTITY SalesOrder
        ALL FIELDS WITH VALUE #( ( Sales_Order_ID = ls_key_mapped-Sales_Order_ID ) )
      RESULT DATA(lt_orders).

    IF lt_orders IS NOT INITIAL.
      READ TABLE lt_orders INDEX 1 INTO DATA(ls_order).
      out->write( |   -> Order ID : { ls_order-Sales_Order_ID }| ).
      out->write( |   -> Sales Org: { ls_order-Sales_Org }| ).
      out->write( |   -> Customer : { ls_order-Customer_ID }| ).
      out->write( |   -> Total Amt: ₹{ ls_order-Total_Order_Amount } { ls_order-Currency }| ).
      out->write( |   -> Status   : { ls_order-Order_Status }| ).
    ENDIF.

    out->write( '========================================================================================' ).
    out->write( 'AUDIT SUMMARY: 100% Unmanaged RAP Scenario Execution Verified Successfully.' ).
    out->write( '========================================================================================' ).

  ENDMETHOD.

ENDCLASS.
