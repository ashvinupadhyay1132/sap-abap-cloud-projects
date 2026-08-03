" ============================================================================
" CLASS: zcl_amdp_gl_closing
" PURPOSE: AMDP HANA SQLScript Class for FI Consolidated General Ledger Closing
" PATTERN: High-Performance Database Code Pushdown (HANA SQLScript Aggregations)
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_amdp_gl_closing DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .

    TYPES: BEGIN OF ty_gl_summary,
             company_code TYPE /dmo/agency_id,
             customer_id  TYPE /dmo/customer_id,
             total_debit  TYPE /dmo/total_price,
             total_credit TYPE /dmo/total_price,
             net_balance  TYPE /dmo/total_price,
             currency     TYPE /dmo/currency_code,
           END OF ty_gl_summary,
           tt_gl_summary TYPE STANDARD TABLE OF ty_gl_summary WITH DEFAULT KEY.

    CLASS-METHODS get_consolidated_gl_summary
      IMPORTING
        VALUE(iv_company_code) TYPE /dmo/agency_id
      EXPORTING
        VALUE(et_gl_summary)   TYPE tt_gl_summary
      RAISING
        cx_amdp_execution_error.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_amdp_gl_closing IMPLEMENTATION.

  METHOD get_consolidated_gl_summary BY DATABASE PROCEDURE FOR HDB
    LANGUAGE SQLSCRIPT
    OPTIONS READ-ONLY
    USING /dmo/travel /dmo/booking.

    -- -------------------------------------------------------------------------
    -- HANA SQLSCRIPT AMDP PROCEDURE:
    -- Aggregates General Ledger Debits/Credits and calculates Net Financial Balance
    -- -------------------------------------------------------------------------
    et_gl_summary =
      SELECT
        t.agency_id    AS company_code,
        t.customer_id  AS customer_id,
        SUM(t.total_price) AS total_debit,
        SUM(b.flight_price) AS total_credit,
        ( SUM(t.total_price) - SUM(b.flight_price) ) AS net_balance,
        t.currency_code AS currency
      FROM "/DMO/TRAVEL" AS t
      INNER JOIN "/DMO/BOOKING" AS b
        ON t.travel_id = b.travel_id
      WHERE t.agency_id = :iv_company_code
      GROUP BY t.agency_id, t.customer_id, t.currency_code;

  ENDMETHOD.

ENDCLASS.
