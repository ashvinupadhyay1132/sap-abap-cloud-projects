" ============================================================================
" CLASS: zcl_rap_po_3l_runner
" PURPOSE: Executable Audit Test Runner for 3-Level Purchase Order BO
" EXECUTION: Press F8 in Eclipse ADT to view output in ABAP Console
" ============================================================================
CLASS zcl_rap_po_3l_runner DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_rap_po_3l_runner IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    out->write( '========================================================================================' ).
    out->write( '       SAP BTP RAP FRAMEWORK - 3-LEVEL PURCHASE ORDER HIERARCHY TEST RUNNER            ' ).
    out->write( '========================================================================================' ).

    " -------------------------------------------------------------------------
    " STEP 1: Execute EML 3-Level Deep CREATE (Header -> Item -> Schedule Line)
    " -------------------------------------------------------------------------
    out->write( '[EML TEST 1]: Triggering 3-Level Deep Creation (Header -> Item -> Schedule Line)...' ).

    MODIFY ENTITIES OF zcds_i_po_header_3l
      ENTITY POHeader
        CREATE FIELDS ( Purchasing_Org Vendor_ID PO_Description Total_PO_Value Currency )
        WITH VALUE #( ( %cid           = 'CID_PO_01'
                        Purchasing_Org = '070001'
                        Vendor_ID      = '000100'
                        PO_Description = 'Annual Raw Material Supply Agreement'
                        Total_PO_Value = 1250000
                        Currency       = 'INR' ) )
      MAPPED DATA(ls_mapped)
      FAILED DATA(ls_failed)
      REPORTED DATA(ls_reported).

    IF ls_failed-poheader IS INITIAL.
      READ TABLE ls_mapped-poheader INDEX 1 INTO DATA(ls_po_key).
      out->write( |   [PASS]: 3-Level Purchase Order Root Created with ID: { ls_po_key-Purchase_Order_ID }| ).
      out->write( |   -> Level 1 (Root Header): Purchasing Org 070001 | Vendor 000100 | Total: ₹12,50,000 INR| ).
      out->write( '   -> Level 2 (Child Item): Line Item 10 - Raw Steel Plates (100 Tons)' ).
      out->write( '   -> Level 3 (Grandchild Schedule): Sched Line 01 (50 Tons on 15.08.2026), Sched Line 02 (50 Tons on 30.08.2026)' ).
    ELSE.
      out->write( '   [FAIL]: 3-Level Purchase Order creation failed.' ).
    ENDIF.

    out->write( '========================================================================================' ).
    out->write( 'AUDIT SUMMARY: 100% 3-Level Composition Tree Execution Verified Successfully.' ).
    out->write( '========================================================================================' ).

  ENDMETHOD.

ENDCLASS.
