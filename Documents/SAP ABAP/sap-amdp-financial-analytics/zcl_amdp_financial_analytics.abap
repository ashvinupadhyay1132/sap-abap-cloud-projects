CLASS zcl_amdp_financial_analytics DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    " -------------------------------------------------------------------
    " 1. AMDP MARKER INTERFACE FOR SAP HANA DATABASE (HDB)
    " -------------------------------------------------------------------
    INTERFACES if_amdp_marker_hdb .
    INTERFACES if_oo_adt_classrun .

    " -------------------------------------------------------------------
    " 2. FINANCIAL DATA STRUCTURE & TABLE TYPE DEFINITIONS
    " -------------------------------------------------------------------
    TYPES: BEGIN OF ty_financial_posting,
             company_code TYPE string,
             division     TYPE string,
             fiscal_year  TYPE string,
             posting_date TYPE dats,
             revenue      TYPE decfloat34,
             cogs         TYPE decfloat34, " Cost of Goods Sold
             opex         TYPE decfloat34, " Operating Expenses
             currency     TYPE string,
           END OF ty_financial_posting,

           tt_financial_postings TYPE STANDARD TABLE OF ty_financial_posting WITH EMPTY KEY.

    TYPES: BEGIN OF ty_financial_analytics,
             company_code   TYPE string,
             division       TYPE string,
             total_revenue  TYPE decfloat34,
             total_cogs     TYPE decfloat34,
             total_opex     TYPE decfloat34,
             gross_profit   TYPE decfloat34,
             net_profit     TYPE decfloat34,
             margin_pct     TYPE decfloat34,
             margin_status  TYPE string,
             revenue_rank   TYPE i, " HANA Window Function Rank
             currency       TYPE string,
           END OF ty_financial_analytics,

           tt_financial_analytics TYPE STANDARD TABLE OF ty_financial_analytics WITH EMPTY KEY.

    " -------------------------------------------------------------------
    " 3. AMDP METHOD SIGNATURE (HANA SQLScript Execution)
    " -------------------------------------------------------------------
    METHODS get_financial_revenue_analytics
      IMPORTING
        VALUE(it_postings) TYPE tt_financial_postings
      EXPORTING
        VALUE(et_analytics) TYPE tt_financial_analytics.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_amdp_financial_analytics IMPLEMENTATION.

  " -------------------------------------------------------------------
  " 4. AMDP METHOD IMPLEMENTATION IN HANA SQLSCRIPT
  " -------------------------------------------------------------------
  " BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY
  " This transfers execution directly into the SAP HANA DB Engine!
  METHOD get_financial_revenue_analytics BY DATABASE PROCEDURE
                                         FOR HDB
                                         LANGUAGE SQLSCRIPT
                                         OPTIONS READ-ONLY.

    -- SQLScript Step 1: Aggregate Financial Postings by Company Code & Division
    lt_aggregated = SELECT company_code,
                           division,
                           SUM(revenue) AS total_revenue,
                           SUM(cogs)    AS total_cogs,
                           SUM(opex)    AS total_opex,
                           currency
                    FROM :it_postings
                    GROUP BY company_code, division, currency;

    -- SQLScript Step 2: Compute Gross Profit, Net Profit, Profit Margin %, Status & HANA Window Ranking
    et_analytics = SELECT company_code,
                          division,
                          total_revenue,
                          total_cogs,
                          total_opex,
                          ( total_revenue - total_cogs ) AS gross_profit,
                          ( total_revenue - total_cogs - total_opex ) AS net_profit,
                          CASE 
                            WHEN total_revenue > 0 THEN 
                              ROUND( ( ( total_revenue - total_cogs - total_opex ) / total_revenue ) * 100, 2 )
                            ELSE 0.00
                          END AS margin_pct,
                          CASE
                            WHEN ( total_revenue - total_cogs - total_opex ) >= 50000 THEN 'HIGH MARGIN'
                            WHEN ( total_revenue - total_cogs - total_opex ) >= 20000 THEN 'MODERATE MARGIN'
                            ELSE 'LOW MARGIN / LOSS'
                          END AS margin_status,
                          -- HANA Window Function: RANK() OVER (ORDER BY Revenue DESC)
                          CAST( RANK() OVER ( ORDER BY total_revenue DESC ) AS INTEGER ) AS revenue_rank,
                          currency
                   FROM :lt_aggregated
                   ORDER BY revenue_rank ASC;

  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    " Implementation in Runner class ZCL_AMDP_RUNNER
  ENDMETHOD.

ENDCLASS.
