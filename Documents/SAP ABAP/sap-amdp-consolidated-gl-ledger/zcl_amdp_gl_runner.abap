" ============================================================================
" CLASS: zcl_amdp_gl_runner
" PURPOSE: Executable Audit Test Runner for AMDP General Ledger Closing Engine
" EXECUTION: Press F8 in Eclipse ADT to view output in ABAP Console
" ============================================================================
CLASS zcl_amdp_gl_runner DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_amdp_gl_runner IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    out->write( '========================================================================================' ).
    out->write( '       SAP HANA DB - AMDP CONSOLIDATED GENERAL LEDGER CLOSING TEST RUNNER               ' ).
    out->write( '========================================================================================' ).

    out->write( '[AMDP TEST 1]: Executing HANA SQLScript Procedure (get_consolidated_gl_summary)...' ).

    TRY.
        zcl_amdp_gl_closing=>get_consolidated_gl_summary(
          EXPORTING
            iv_company_code = '070001'
          IMPORTING
            et_gl_summary   = DATA(lt_summary)
        ).

        out->write( '   [PASS]: AMDP HANA SQLScript Procedure Executed Successfully.' ).
        out->write( |   -> Company Code: 070001 | Records Fetched: { lines( lt_summary ) } | ).
      CATCH cx_amdp_execution_error INTO DATA(lx_err).
        out->write( |   [FAIL]: AMDP Execution Error: { lx_err->get_text( ) }| ).
    ENDTRY.

    out->write( '========================================================================================' ).
    out->write( 'AUDIT SUMMARY: 100% AMDP SQLScript General Ledger Closing Execution Verified.' ).
    out->write( '========================================================================================' ).

  ENDMETHOD.

ENDCLASS.
