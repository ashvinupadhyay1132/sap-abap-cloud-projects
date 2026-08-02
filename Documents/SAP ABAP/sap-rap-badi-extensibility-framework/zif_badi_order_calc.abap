" ============================================================================
" INTERFACE: zif_badi_order_calc
" PURPOSE: Clean Core BAdI Interface for Dynamic Order Extensibility Calculations
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
INTERFACE zif_badi_order_calc
  PUBLIC .

  INTERFACES if_badi_interface .

  METHODS calculate_custom_discount
    IMPORTING
      iv_customer_id   TYPE /dmo/customer_id
      iv_base_amount   TYPE /dmo/total_price
    EXPORTING
      ev_discount_rate TYPE /dmo/booking_fee
      ev_discount_amt  TYPE /dmo/total_price.

ENDINTERFACE.
