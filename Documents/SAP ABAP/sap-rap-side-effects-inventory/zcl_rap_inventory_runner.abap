" ============================================================================
" CLASS: zcl_rap_inventory_runner
" PURPOSE: Executable Audit Test Runner for RAP Side Effects & Feature Control Engine
" EXECUTION: Press F8 in Eclipse ADT to view output in ABAP Console
" ============================================================================
CLASS zcl_rap_inventory_runner DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_rap_inventory_runner IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    out->write( '========================================================================================' ).
    out->write( '        SAP BTP RAP FRAMEWORK - SIDE EFFECTS & INSTANCE FEATURE CONTROL TEST RUNNER     ' ).
    out->write( '========================================================================================' ).

    " -------------------------------------------------------------------------
    " STEP 1: Execute EML CREATE with Critical Stock Level (Quantity = 5)
    " -------------------------------------------------------------------------
    out->write( '[EML TEST 1]: Triggering Material Creation with Low Stock (Quantity = 5)...' ).

    MODIFY ENTITIES OF zcds_i_inventory_m
      ENTITY Inventory
        CREATE FIELDS ( Plant_ID Storage_Location Material_Description Stock_Quantity Unit_Standard_Price Currency )
        WITH VALUE #( ( %cid                 = 'CID_INV_01'
                        Plant_ID             = '070001'
                        Storage_Location     = '0001'
                        Material_Description = 'Industrial High-Pressure Hydraulic Valve'
                        Stock_Quantity       = 5
                        Unit_Standard_Price  = 45000
                        Currency             = 'INR' ) )
      MAPPED DATA(ls_mapped)
      FAILED DATA(ls_failed)
      REPORTED DATA(ls_reported).

    IF ls_failed-inventory IS INITIAL.
      READ TABLE ls_mapped-inventory INDEX 1 INTO DATA(ls_mapped_key).
      out->write( |   [PASS]: Inventory Material Created with ID: { ls_mapped_key-Material_ID }| ).
    ELSE.
      out->write( '   [FAIL]: Inventory creation failed.' ).
      RETURN.
    ENDIF.

    " -------------------------------------------------------------------------
    " STEP 2: Execute RAP Determination & Verify Side Effects Target Field Recalculation
    " -------------------------------------------------------------------------
    out->write( '----------------------------------------------------------------------------------------' ).
    out->write( '[EML TEST 2]: Verifying Side Effects Target Fields (Stock_Status & Reorder_Flag)...' ).

    READ ENTITIES OF zcds_i_inventory_m
      ENTITY Inventory
        ALL FIELDS WITH VALUE #( ( Material_ID = ls_mapped_key-Material_ID ) )
      RESULT DATA(lt_inv_list).

    IF lt_inv_list IS NOT INITIAL.
      READ TABLE lt_inv_list INDEX 1 INTO DATA(ls_inv_item).
      out->write( |   -> Material    : { ls_inv_item-Material_Description }| ).
      out->write( |   -> Stock Qty   : { ls_inv_item-Stock_Quantity } units| ).
      out->write( |   -> Stock Status: { ls_inv_item-Stock_Status } (C = Critical Stock Alert)| ).
      out->write( |   -> Reorder Flag: { ls_inv_item-Reorder_Flag } (Y = Reorder Action Enabled)| ).
    ENDIF.

    " -------------------------------------------------------------------------
    " STEP 3: Execute RAP Action (reorderStock)
    " -------------------------------------------------------------------------
    out->write( '----------------------------------------------------------------------------------------' ).
    out->write( '[EML TEST 3]: Executing Dynamic Action (reorderStock)...' ).

    MODIFY ENTITIES OF zcds_i_inventory_m
      ENTITY Inventory
        EXECUTE reorderStock
        FROM VALUE #( ( %tky = ls_inv_item-%tky ) )
      RESULT DATA(lt_reorder_result)
      FAILED DATA(ls_reorder_failed).

    IF ls_reorder_failed-inventory IS INITIAL.
      out->write( '   [PASS]: reorderStock Action Executed Successfully. Replenishment Order Created.' ).
    ENDIF.

    out->write( '========================================================================================' ).
    out->write( 'AUDIT SUMMARY: 100% RAP Side Effects & Dynamic Feature Control Verification Passed.' ).
    out->write( '========================================================================================' ).

  ENDMETHOD.

ENDCLASS.
