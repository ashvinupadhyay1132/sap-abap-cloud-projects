" ============================================================================
" CLASS: zcl_amdp_stock_aging
" PURPOSE: AMDP HANA SQLScript Procedure for EWM Inventory Stock Aging & Fast/Slow Motion
" PATTERN: Common Table Expressions (CTE) & SQLScript Dynamic Aggregation
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_amdp_stock_aging DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .

    TYPES: BEGIN OF ty_stock_aging,
             plant_id        TYPE /dmo/agency_id,
             material_id     TYPE /dmo/carrier_id,
             total_stock_qty TYPE /dmo/booking_id,
             aging_category  TYPE string,
           END OF ty_stock_aging,
           tt_stock_aging TYPE STANDARD TABLE OF ty_stock_aging WITH DEFAULT KEY.

    CLASS-METHODS get_inventory_aging_analytics
      IMPORTING
        VALUE(iv_plant_id)  TYPE /dmo/agency_id
      EXPORTING
        VALUE(et_stock_aging) TYPE tt_stock_aging
      RAISING
        cx_amdp_execution_error.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_amdp_stock_aging IMPLEMENTATION.

  METHOD get_inventory_aging_analytics BY DATABASE PROCEDURE FOR HDB
    LANGUAGE SQLSCRIPT
    OPTIONS READ-ONLY
    USING /dmo/booking.

    -- -------------------------------------------------------------------------
    -- HANA SQLSCRIPT AMDP PROCEDURE WITH CTE:
    -- Evaluates Stock Aging buckets (0-30 Days, 31-90 Days, >90 Days)
    -- -------------------------------------------------------------------------
    WITH cte_stock_raw AS (
      SELECT
        carrier_id    AS material_id,
        connection_id AS plant_id,
        booking_id    AS stock_qty,
        booking_date  AS movement_date
      FROM "/DMO/BOOKING"
    )
    SELECT
      :iv_plant_id AS plant_id,
      material_id,
      SUM(stock_qty) AS total_stock_qty,
      CASE
        WHEN DAYS_BETWEEN(movement_date, CURRENT_DATE) <= 30 THEN 'FAST_MOVING_0_30'
        WHEN DAYS_BETWEEN(movement_date, CURRENT_DATE) BETWEEN 31 AND 90 THEN 'SLOW_MOVING_31_90'
        ELSE 'DEAD_STOCK_OVER_90'
      END AS aging_category
    FROM cte_stock_raw
    GROUP BY material_id, movement_date;

  ENDMETHOD.

ENDCLASS.
