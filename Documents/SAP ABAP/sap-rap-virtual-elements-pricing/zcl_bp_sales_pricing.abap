" ============================================================================
" CLASS: zcl_bp_sales_pricing
" PURPOSE: Behavior Pool for Sales Pricing Entity ZCDS_I_SALES_PRICING
" ============================================================================
CLASS zcl_bp_sales_pricing DEFINITION
  PUBLIC
  ABSTRACT
  FINAL
  FOR BEHAVIOR OF zcds_i_sales_pricing.

  PUBLIC SECTION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_bp_sales_pricing IMPLEMENTATION.
ENDCLASS.

CLASS lhc_SalesOrder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR SalesOrder RESULT result.
ENDCLASS.

CLASS lhc_SalesOrder IMPLEMENTATION.
  METHOD get_instance_authorizations.
    LOOP AT keys INTO DATA(ls_key).
      APPEND VALUE #( %tky = ls_key-%tky
                      %update = if_abap_behv=>auth-allowed
                      %delete = if_abap_behv=>auth-allowed ) TO result.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
