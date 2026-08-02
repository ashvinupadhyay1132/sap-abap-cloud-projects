" ============================================================================
" CLASS: zcl_badi_order_calc_impl
" PURPOSE: BAdI Enhancement Implementation Class for Customer Discount Rules
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_badi_order_calc_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_badi_order_calc .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_badi_order_calc_impl IMPLEMENTATION.

  METHOD zif_badi_order_calc~calculate_custom_discount.
    " -------------------------------------------------------------------------
    " BADI ENHANCEMENT LOGIC:
    " Applies 12% VIP discount for premium customer IDs (e.g. '000100')
    " -------------------------------------------------------------------------
    IF iv_customer_id = '000100' OR iv_customer_id = '000200'.
      ev_discount_rate = 12.
    ELSE.
      ev_discount_rate = 5.
    ENDIF.

    ev_discount_amt = ( iv_base_amount * ev_discount_rate ) / 100.
  ENDMETHOD.

ENDCLASS.
