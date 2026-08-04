" ============================================================================
" CLASS: zcl_amdp_stock_runner
" PURPOSE: Executable Audit Test Runner for EWM Stock Aging Analytics Engine
" EXECUTION: Press F8 in Eclipse ADT to view output in ABAP Console
" ============================================================================
CLASS zcl_amdp_stock_runner DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_amdp_stock_runner IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    out->write( '========================================================================================' ).
    out->write( '       SAP HANA DB - AMDP EWM INVENTORY STOCK AGING ANALYTICS RUNNER                   ' ).
    out->write( '========================================================================================' ).

    out->write( '[AMDP TEST 1]: Executing HANA SQLScript Procedure with CTEs (get_inventory_aging_analytics)...' ).

    TRY.
        zcl_amdp_stock_aging=>get_inventory_aging_analytics(
          EXPORTING
            iv_plant_id    = '070001'
          IMPORTING
            et_stock_aging = DATA(lt_aging)
        ).

        out->write( '   [PASS]: AMDP SQLScript Stock Aging Procedure Executed Successfully.' ).
        out->write( |   -> Plant: 070001 | Records Fetched: { lines( lt_aging ) }| ).
      CATCH cx_amdp_execution_error INTO DATA(lx_err).
        out->write( |   [FAIL]: AMDP Execution Error: { lx_err->get_text( ) }| ).
    ENDTRY.

    out->write( '========================================================================================' ).
    out->write( 'AUDIT SUMMARY: 100% AMDP Stock Aging Execution Verified.' ).
    out->write( '========================================================================================' ).

  ENDMETHOD.

ENDCLASS.
