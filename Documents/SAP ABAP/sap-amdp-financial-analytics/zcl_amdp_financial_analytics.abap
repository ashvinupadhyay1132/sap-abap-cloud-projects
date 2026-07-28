" ============================================================================
" CLASS: zcl_amdp_financial_analytics
" PURPOSE: Enterprise Financial Profitability Engine using SAP AMDP & HANA SQLScript
" GOAL: Shift heavy financial computations directly into the SAP HANA DB Kernel
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_amdp_financial_analytics DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    " -------------------------------------------------------------------------
    " 1. AMDP MARKER INTERFACE
    " Required to register this class as an AMDP procedure host in SAP HANA DB
    " -------------------------------------------------------------------------
    INTERFACES if_amdp_marker_hdb .
    INTERFACES if_oo_adt_classrun .

    " -------------------------------------------------------------------------
    " 2. DATA DICTIONARY TYPES & STRUCTURE DEFINITIONS
    " Input structure for raw transactional financial postings
    " -------------------------------------------------------------------------
    TYPES: BEGIN OF ty_financial_posting,
             company_code TYPE string,   " Financial Company Code ID (e.g., '1000')
             division     TYPE string,   " Business Operating Division (e.g., 'CLOUD_SERVICES')
             fiscal_year  TYPE string,   " Fiscal Year Period (e.g., '2026')
             posting_date TYPE dats,     " Transaction Posting Date
             revenue      TYPE decfloat34, " Gross Sales Revenue Amount
             cogs         TYPE decfloat34, " Cost of Goods Sold
             opex         TYPE decfloat34, " Operating Expenses
             currency     TYPE string,     " Currency Code (e.g., 'INR', 'USD')
           END OF ty_financial_posting,

           tt_financial_postings TYPE STANDARD TABLE OF ty_financial_posting WITH EMPTY KEY.

    " Output structure for aggregated HANA database Analytics
    TYPES: BEGIN OF ty_financial_analytics,
             company_code  TYPE string,   " Company Code ID
             division      TYPE string,   " Operating Division
             total_revenue TYPE decfloat34, " Aggregated Total Sales Revenue
             total_cogs    TYPE decfloat34, " Aggregated Total COGS
             total_opex    TYPE decfloat34, " Aggregated Total Operating Expenses
             gross_profit  TYPE decfloat34, " Calculated Gross Profit (Revenue - COGS)
             net_profit    TYPE decfloat34, " Calculated Net Profit (Revenue - COGS - OPEX)
             margin_pct    TYPE decfloat34, " Calculated Net Margin Percentage
             margin_status TYPE string,     " Categorized Status (HIGH / MODERATE / LOW MARGIN)
             revenue_rank  TYPE i,          " Dynamic Rank computed via HANA Window Function
             currency      TYPE string,     " Currency Code
           END OF ty_financial_analytics,

           tt_financial_analytics TYPE STANDARD TABLE OF ty_financial_analytics WITH EMPTY KEY.

    " -------------------------------------------------------------------------
    " 3. AMDP METHOD DEFINITION
    " Pass input table by VALUE and return output analytics table by VALUE
    " -------------------------------------------------------------------------
    METHODS get_financial_revenue_analytics
      IMPORTING
        VALUE(it_postings)  TYPE tt_financial_postings
      EXPORTING
        VALUE(et_analytics) TYPE tt_financial_analytics.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_amdp_financial_analytics IMPLEMENTATION.

  " ============================================================================
  " AMDP PROCEDURE IMPLEMENTATION
  " OPTIONS READ-ONLY ensures execution is safe and non-modifying on HANA DB
  " ============================================================================
  METHOD get_financial_revenue_analytics BY DATABASE PROCEDURE
                                         FOR HDB
                                         LANGUAGE SQLSCRIPT
                                         OPTIONS READ-ONLY.

    -- ------------------------------------------------------------------------
    -- STEP 1: Aggregate raw financial postings by Company Code, Division & Currency
    -- Uses SQLScript SUM() function to combine all line items inside HANA Memory
    -- ------------------------------------------------------------------------
    lt_aggregated = SELECT company_code,
                           division,
                           SUM(revenue) AS total_revenue,
                           SUM(cogs)    AS total_cogs,
                           SUM(opex)    AS total_opex,
                           currency
                    FROM :it_postings
                    GROUP BY company_code, division, currency;

    -- ------------------------------------------------------------------------
    -- STEP 2: Compute Net Profit, Profit Margin %, Status, & Dynamic HANA Ranking
    -- Uses HANA Window Function RANK() OVER () to order divisions by revenue
    -- ------------------------------------------------------------------------
    et_analytics = SELECT company_code,
                          division,
                          total_revenue,
                          total_cogs,
                          total_opex,
                          ( total_revenue - total_cogs ) AS gross_profit,
                          ( total_revenue - total_cogs - total_opex ) AS net_profit,
                          -- Calculate Net Profit Margin Percentage with ROUND function
                          CASE 
                            WHEN total_revenue > 0 THEN 
                              ROUND( ( ( total_revenue - total_cogs - total_opex ) / total_revenue ) * 100, 2 )
                            ELSE 0.00
                          END AS margin_pct,
                          -- Dynamic Conditional Categorization
                          CASE
                            WHEN ( total_revenue - total_cogs - total_opex ) >= 50000 THEN 'HIGH MARGIN'
                            WHEN ( total_revenue - total_cogs - total_opex ) >= 20000 THEN 'MODERATE MARGIN'
                            ELSE 'LOW MARGIN / LOSS'
                          END AS margin_status,
                          -- HANA Window Function: Computes integer rank ordered by total revenue descending
                          CAST( RANK() OVER ( ORDER BY total_revenue DESC ) AS INTEGER ) AS revenue_rank,
                          currency
                   FROM :lt_aggregated
                   ORDER BY revenue_rank ASC;

  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    " Execution runner implemented in zcl_amdp_runner
  ENDMETHOD.

ENDCLASS.
