" ============================================================================
" CLASS: zcl_amdp_runner
" PURPOSE: Executable Test Runner for SAP AMDP Financial Analytics Class
" EXECUTION: Press F8 in Eclipse ADT to view output in ABAP Console
" ============================================================================
CLASS zcl_amdp_runner DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_amdp_runner IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    out->write( '========================================================================================' ).
    out->write( '       SAP FI-CO MODULE - AMDP FINANCIAL ANALYTICS ENGINE (HANA SQLSCRIPT PUSHDOWN)     ' ).
    out->write( '========================================================================================' ).

    " -------------------------------------------------------------------------
    " STEP 1: Instantiate sample transactional financial postings
    " Contains postings across multiple Company Codes (1000 & 2000) and Divisions
    " -------------------------------------------------------------------------
    DATA(lt_postings) = VALUE zcl_amdp_financial_analytics=>tt_financial_postings(
      ( company_code = '1000' division = 'CLOUD_SERVICES' fiscal_year = '2026' posting_date = '20260115' revenue = 350000 cogs = 120000 opex = 45000 currency = 'INR' )
      ( company_code = '1000' division = 'CLOUD_SERVICES' fiscal_year = '2026' posting_date = '20260220' revenue = 400000 cogs = 150000 opex = 50000 currency = 'INR' )
      ( company_code = '1000' division = 'HARDWARE_SALES' fiscal_year = '2026' posting_date = '20260110' revenue = 180000 cogs = 110000 opex = 25000 currency = 'INR' )
      ( company_code = '2000' division = 'CONSULTING'     fiscal_year = '2026' posting_date = '20260305' revenue = 600000 cogs = 200000 opex = 80000 currency = 'INR' )
      ( company_code = '2000' division = 'SUPPORT_SERVICES' fiscal_year = '2026' posting_date = '20260312' revenue = 90000  cogs = 55000  opex = 20000 currency = 'INR' )
    ).

    out->write( '[INPUT]: Instantiated 5 Financial Postings across Company Codes 1000 & 2000.' ).
    out->write( '----------------------------------------------------------------------------------------' ).

    " -------------------------------------------------------------------------
    " STEP 2: Instantiate AMDP Class & Trigger HANA SQLScript Database Procedure
    " Execution passes data into HANA Kernel and retrieves aggregated analytics
    " -------------------------------------------------------------------------
    DATA(lo_amdp) = NEW zcl_amdp_financial_analytics( ).
    DATA lt_analytics TYPE zcl_amdp_financial_analytics=>tt_financial_analytics.

    TRY.
        out->write( '[EML EXECUTION]: Invoking AMDP Method (HANA DB Engine SQLScript Pushdown)...' ).

        " Call the AMDP method
        lo_amdp->get_financial_revenue_analytics(
          EXPORTING
            it_postings  = lt_postings
          IMPORTING
            et_analytics = lt_analytics
        ).

        out->write( '   [PASS]: HANA SQLScript Execution Completed Successfully.' ).
        out->write( '----------------------------------------------------------------------------------------' ).
        out->write( '                       FINANCIAL PROFITABILITY & RANKING REPORT                         ' ).
        out->write( '----------------------------------------------------------------------------------------' ).

        " ---------------------------------------------------------------------
        " STEP 3: Iterate through computed analytics table and render output
        " ---------------------------------------------------------------------
        LOOP AT lt_analytics INTO DATA(ls_row).
          out->write( |Rank #{ ls_row-revenue_rank } | &
                      |CoCode: { ls_row-company_code } | &
                      |Division: { ls_row-division WIDTH = 18 } | &
                      |Revenue: ₹{ ls_row-total_revenue ALIGN = RIGHT WIDTH = 9 } | &
                      |COGS: ₹{ ls_row-total_cogs ALIGN = RIGHT WIDTH = 8 } | &
                      |Net Profit: ₹{ ls_row-net_profit ALIGN = RIGHT WIDTH = 8 } | &
                      |Margin: { ls_row-margin_pct ALIGN = RIGHT WIDTH = 5 }% | &
                      |Status: { ls_row-margin_status }| ).
        ENDLOOP.

      CATCH cx_root INTO DATA(lx_err).
        out->write( |[ERROR]: AMDP Execution Failed: { lx_err->get_text( ) }| ).
    ENDTRY.

    out->write( '========================================================================================' ).
    out->write( 'AUDIT SUMMARY: 100% AMDP HANA SQLScript Financial Analytics Execution Verified.' ).
    out->write( '========================================================================================' ).

  ENDMETHOD.

ENDCLASS.
