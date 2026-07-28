" ============================================================================
" CLASS: zcl_pr_ddic_engine
" PURPOSE: Purchase Requisition Data Dictionary (DDIC) Processing Engine
" FUNCTION: Implements DDIC structures, secondary keys, domain checks & totals
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_pr_ddic_engine DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    " -------------------------------------------------------------------------
    " 1. DDIC STRUCTURE & TABLE TYPE DEFINITIONS
    " Flat structure representing a single Purchase Requisition Line Item
    " -------------------------------------------------------------------------
    TYPES: BEGIN OF ty_pr_item_ddic,
             pr_number        TYPE string,       " Header PR Association Key
             pr_item_no       TYPE i,            " Line Item Sequence Number (10, 20)
             material_no      TYPE string,       " Material Master ID
             material_text    TYPE string,       " Material Short Description
             quantity         TYPE decfloat34,   " Item Requisition Quantity
             unit_of_measure  TYPE string,       " Unit of Measure Semantics (ST, KG, LTR)
             price_per_unit   TYPE decfloat34,   " Unit Price
             total_item_value TYPE decfloat34,   " Calculated Line Item Total (Qty * Price)
             currency_code    TYPE string,       " Currency Semantics (INR, EUR, USD)
             purchasing_group TYPE string,       " Purchasing Group ID
           END OF ty_pr_item_ddic,

           " Table Type with Primary Key & Secondary Sorted Key for performance
           tt_pr_items_ddic TYPE STANDARD TABLE OF ty_pr_item_ddic
                            WITH EMPTY KEY
                            WITH NON-UNIQUE SORTED KEY item_key COMPONENTS pr_item_no.

    " Deep Structure representing Purchase Requisition Header + Associated Items
    TYPES: BEGIN OF ty_pr_header_ddic,
             pr_number       TYPE string,           " Requisition ID (Key)
             pr_type         TYPE string,           " Domain Fixed Values: NB, FO, RV
             pr_status       TYPE string,           " Domain Fixed Values: D, S, A, R
             plant           TYPE string,           " Receiving Plant ID
             department      TYPE string,           " Requisitioning Department
             created_by      TYPE string,           " User ID of Creator
             creation_date   TYPE dats,             " Requisition Creation Date
             total_pr_amount TYPE decfloat34,       " Aggregated Grand Total Amount
             currency_code   TYPE string,           " Header Currency Code
             items           TYPE tt_pr_items_ddic, " Deep Structure Line Items Table
           END OF ty_pr_header_ddic,

           tt_pr_headers_ddic TYPE STANDARD TABLE OF ty_pr_header_ddic WITH EMPTY KEY.

    " -------------------------------------------------------------------------
    " 2. METHOD SIGNATURES
    " -------------------------------------------------------------------------
    " Validates PR Document Type against DDIC Domain Fixed Values ('NB', 'FO', 'RV')
    METHODS validate_pr_type
      IMPORTING
        iv_pr_type          TYPE string
      RETURNING
        VALUE(rv_is_valid) TYPE abap_bool.

    " Validates PR Document Status against DDIC Domain Fixed Values ('D', 'S', 'A', 'R')
    METHODS validate_pr_status
      IMPORTING
        iv_pr_status        TYPE string
      RETURNING
        VALUE(rv_is_valid) TYPE abap_bool.

    " Computes line item values and accumulates grand total into header
    METHODS calculate_pr_totals
      CHANGING
        cs_pr_header TYPE ty_pr_header_ddic.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_pr_ddic_engine IMPLEMENTATION.

  METHOD validate_pr_type.
    " DDIC Domain Value Range Check ('NB' = Standard, 'FO' = Framework, 'RV' = Outline Agreement)
    rv_is_valid = COND #( WHEN iv_pr_type = 'NB' OR iv_pr_type = 'FO' OR iv_pr_type = 'RV'
                           THEN abap_true
                           ELSE abap_false ).
  ENDMETHOD.

  METHOD validate_pr_status.
    " DDIC Domain Value Range Check ('D' = Draft, 'S' = Submitted, 'A' = Approved, 'R' = Rejected)
    rv_is_valid = COND #( WHEN iv_pr_status = 'D' OR iv_pr_status = 'S' OR iv_pr_status = 'A' OR iv_pr_status = 'R'
                           THEN abap_true
                           ELSE abap_false ).
  ENDMETHOD.

  METHOD calculate_pr_totals.
    DATA lv_grand_total TYPE decfloat34 VALUE 0.

    " Internal Table Processing using Field Symbol pointer for performance
    LOOP AT cs_pr_header-items ASSIGNING FIELD-SYMBOL(<fs_item>).
      " Calculate line item total value (Quantity * Price)
      <fs_item>-total_item_value = <fs_item>-quantity * <fs_item>-price_per_unit.
      
      " Accumulate into Header Total Amount
      lv_grand_total = lv_grand_total + <fs_item>-total_item_value.
    ENDLOOP.

    cs_pr_header-total_pr_amount = lv_grand_total.
  ENDMETHOD.

ENDCLASS.
