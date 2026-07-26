CLASS zcl_pr_ddic_engine DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    " -------------------------------------------------------------------
    " 1. DDIC STRUCTURE & TABLE TYPE DEFINITIONS
    " -------------------------------------------------------------------
    TYPES: BEGIN OF ty_pr_item_ddic,
             pr_number        TYPE string,
             pr_item_no       TYPE i,
             material_no      TYPE string,
             material_text    TYPE string,
             quantity         TYPE decfloat34,
             unit_of_measure  TYPE string, " e.g. ST, KG, LTR
             price_per_unit   TYPE decfloat34,
             total_item_value TYPE decfloat34,
             currency_code    TYPE string,
             purchasing_group TYPE string,
           END OF ty_pr_item_ddic,

           " Table Type with Primary Key & Secondary Sorted Key for performance
           tt_pr_items_ddic TYPE STANDARD TABLE OF ty_pr_item_ddic
                            WITH EMPTY KEY
                            WITH NON-UNIQUE SORTED KEY item_key COMPONENTS pr_item_no.

    TYPES: BEGIN OF ty_pr_header_ddic,
             pr_number        TYPE string,
             pr_type          TYPE string, " Domain Values: NB, FO, RV
             pr_status        TYPE string, " Domain Values: D, S, A, R
             plant            TYPE string,
             department       TYPE string,
             created_by       TYPE string,
             creation_date    TYPE dats,
             total_pr_amount  TYPE decfloat34,
             currency_code    TYPE string,
             items            TYPE tt_pr_items_ddic, " Deep Structure Association
           END OF ty_pr_header_ddic,

           tt_pr_headers_ddic TYPE STANDARD TABLE OF ty_pr_header_ddic WITH EMPTY KEY.

    " -------------------------------------------------------------------
    " 2. METHODS SIGNATURES (DDIC VALIDATIONS & CALCULATIONS)
    " -------------------------------------------------------------------
    METHODS validate_pr_type
      IMPORTING
        iv_pr_type TYPE string
      RETURNING
        VALUE(rv_is_valid) TYPE abap_bool.

    METHODS validate_pr_status
      IMPORTING
        iv_pr_status TYPE string
      RETURNING
        VALUE(rv_is_valid) TYPE abap_bool.

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

    " Internal Table Processing using Field Symbol pointer
    LOOP AT cs_pr_header-items ASSIGNING FIELD-SYMBOL(<fs_item>).
      " Calculate line item total value (Quantity * Price)
      <fs_item>-total_item_value = <fs_item>-quantity * <fs_item>-price_per_unit.
      
      " Accumulate into Header Total Amount
      lv_grand_total = lv_grand_total + <fs_item>-total_item_value.
    ENDLOOP.

    cs_pr_header-total_pr_amount = lv_grand_total.
  ENDMETHOD.

ENDCLASS.
