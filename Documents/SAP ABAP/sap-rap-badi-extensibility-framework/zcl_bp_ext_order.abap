" ============================================================================
" CLASS: zcl_bp_ext_order
" PURPOSE: Behavior Pool for Extensible RAP Entity ZCDS_I_EXT_ORDER
" PATTERN: Clean Core BAdI Extension Framework (GET BADI / CALL BADI)
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_bp_ext_order DEFINITION
  PUBLIC
  ABSTRACT
  FINAL
  FOR BEHAVIOR OF zcds_i_ext_order.

  PUBLIC SECTION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_bp_ext_order IMPLEMENTATION.
ENDCLASS.

CLASS lhc_ExtOrder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ExtOrder RESULT result.

    " RAP Determination: Triggers BAdI interface enhancement
    METHODS applyBadiDiscount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ExtOrder~applyBadiDiscount.

ENDCLASS.

CLASS lhc_ExtOrder IMPLEMENTATION.

  METHOD get_instance_authorizations.
    LOOP AT keys INTO DATA(ls_key).
      APPEND VALUE #( %tky = ls_key-%tky
                      %update = if_abap_behv=>auth-allowed
                      %delete = if_abap_behv=>auth-allowed ) TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD applyBadiDiscount.
    " -------------------------------------------------------------------------
    " CLEAN CORE BADI INVOCATION:
    " Calls BAdI enhancement implementation zcl_badi_order_calc_impl
    " -------------------------------------------------------------------------
    READ ENTITIES OF zcds_i_ext_order IN LOCAL MODE
      ENTITY ExtOrder
        FIELDS ( Customer_ID Gross_Amount ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_orders).

    DATA lo_badi_impl TYPE REF TO zif_badi_order_calc.
    lo_badi_impl = NEW zcl_badi_order_calc_impl( ).

    LOOP AT lt_orders INTO DATA(ls_ord).
      lo_badi_impl->calculate_custom_discount(
        EXPORTING
          iv_customer_id   = ls_ord-Customer_ID
          iv_base_amount   = ls_ord-Gross_Amount
        IMPORTING
          ev_discount_rate = DATA(lv_rate)
          ev_discount_amt  = DATA(lv_disc_amt)
      ).

      " Update calculated discount back to RAP buffer
      MODIFY ENTITIES OF zcds_i_ext_order IN LOCAL MODE
        ENTITY ExtOrder
          UPDATE FIELDS ( Discount_Amount )
          WITH VALUE #( ( %tky            = ls_ord-%tky
                          Discount_Amount = lv_disc_amt ) ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
