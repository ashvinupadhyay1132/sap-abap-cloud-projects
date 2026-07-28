" ============================================================================
" CLASS: zcl_bp_sales_order_u
" PURPOSE: Behavior Pool for Unmanaged RAP Business Object ZCDS_I_SALES_ORDER_U
" PATTERN: Unmanaged RAP Application (Wraps Legacy Persistence & Buffer Tables)
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_bp_sales_order_u DEFINITION
  PUBLIC
  ABSTRACT
  FINAL
  FOR BEHAVIOR OF zcds_i_sales_order_u.

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_sales_order_buffer,
             sales_order_id TYPE /dmo/travel_id,
             sales_org      TYPE /dmo/agency_id,
             customer_id    TYPE /dmo/customer_id,
             total_price    TYPE /dmo/total_price,
             currency_code  TYPE /dmo/currency_code,
             order_status   TYPE /dmo/overall_status,
           END OF ty_sales_order_buffer.

    CLASS-DATA gt_so_buffer TYPE STANDARD TABLE OF ty_sales_order_buffer.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_bp_sales_order_u IMPLEMENTATION.
ENDCLASS.

" ============================================================================
" LOCAL HANDLER CLASS: lhc_SalesOrder
" Implements unmanaged CRUD operations wrapping legacy BAPIs / custom buffer
" ============================================================================
CLASS lhc_SalesOrder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR SalesOrder RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE SalesOrder.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE SalesOrder.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE SalesOrder.

    METHODS read FOR READ
      IMPORTING keys FOR READ SalesOrder RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK SalesOrder.

    METHODS rba_Items FOR READ
      IMPORTING keys_rba FOR READ SalesOrder\_Items FULL result_link RESULT result LINK linkage.

    METHODS cba_Items FOR MODIFY
      IMPORTING entities_cba FOR CREATE SalesOrder\_Items.

ENDCLASS.

CLASS lhc_SalesOrder IMPLEMENTATION.

  METHOD get_instance_authorizations.
    " Grant instance authorizations for unmanaged actions
    LOOP AT keys INTO DATA(ls_key).
      APPEND VALUE #( %tky = ls_key-%tky
                      %update = if_abap_behv=>auth-allowed
                      %delete = if_abap_behv=>auth-allowed ) TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD create.
    " -------------------------------------------------------------------------
    " UNMANAGED CREATE: Custom logic wrapping legacy order buffer / BAPI
    " -------------------------------------------------------------------------
    LOOP AT entities INTO DATA(ls_entity).
      " Generate custom unmanaged key sequence
      DATA(lv_new_id) = CONV /dmo/travel_id( '90000101' ).

      " Populate custom unmanaged transactional buffer
      APPEND VALUE #(
        sales_order_id = lv_new_id
        sales_org      = ls_entity-Sales_Org
        customer_id    = ls_entity-Customer_ID
        total_price    = ls_entity-Total_Order_Amount
        currency_code  = ls_entity-Currency
        order_status   = 'O' " Open Status
      ) TO zcl_bp_sales_order_u=>gt_so_buffer.

      " Return mapped keys to RAP framework
      INSERT VALUE #( %cid = ls_entity-%cid Sales_Order_ID = lv_new_id ) INTO TABLE mapped-salesorder.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    " -------------------------------------------------------------------------
    " UNMANAGED UPDATE: Modify custom transactional buffer
    " -------------------------------------------------------------------------
    LOOP AT entities INTO DATA(ls_entity).
      READ TABLE zcl_bp_sales_order_u=>gt_so_buffer REFERENCE INTO DATA(lr_buf)
        WITH KEY sales_order_id = ls_entity-Sales_Order_ID.

      IF sy-subrc = 0.
        IF ls_entity-%control-Customer_ID = if_abap_behv=>mk-on.
          lr_buf->customer_id = ls_entity-Customer_ID.
        ENDIF.
        IF ls_entity-%control-Total_Order_Amount = if_abap_behv=>mk-on.
          lr_buf->total_price = ls_entity-Total_Order_Amount.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    " -------------------------------------------------------------------------
    " UNMANAGED DELETE: Remove entries from custom transactional buffer
    " -------------------------------------------------------------------------
    LOOP AT keys INTO DATA(ls_key).
      DELETE zcl_bp_sales_order_u=>gt_so_buffer WHERE sales_order_id = ls_key-Sales_Order_ID.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    " -------------------------------------------------------------------------
    " UNMANAGED READ: Retrieve entities from transactional buffer / DB
    " -------------------------------------------------------------------------
    LOOP AT keys INTO DATA(ls_key).
      READ TABLE zcl_bp_sales_order_u=>gt_so_buffer INTO DATA(ls_buf)
        WITH KEY sales_order_id = ls_key-Sales_Order_ID.

      IF sy-subrc = 0.
        APPEND VALUE #(
          Sales_Order_ID     = ls_buf-sales_order_id
          Sales_Org          = ls_buf-sales_org
          Customer_ID        = ls_buf-customer_id
          Total_Order_Amount = ls_buf-total_price
          Currency           = ls_buf-currency_code
          Order_Status       = ls_buf-order_status
        ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD lock.
    " Unmanaged Lock implementation (Simulated lock entry)
  ENDMETHOD.

  METHOD rba_Items.
  ENDMETHOD.

  METHOD cba_Items.
  ENDMETHOD.

ENDCLASS.

" ============================================================================
" LOCAL HANDLER CLASS: lhc_SalesItem
" ============================================================================
CLASS lhc_SalesItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE SalesItem.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE SalesItem.

    METHODS read FOR READ
      IMPORTING keys FOR READ SalesItem RESULT result.

    METHODS rba_Header FOR READ
      IMPORTING keys_rba FOR READ SalesItem\_Header FULL result_link RESULT result LINK linkage.
ENDCLASS.

CLASS lhc_SalesItem IMPLEMENTATION.
  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Header.
  ENDMETHOD.
ENDCLASS.

" ============================================================================
" LOCAL SAVER CLASS: lsc_ZCDS_I_SALES_ORDER_U
" Controls Unmanaged Save Sequence to commit custom buffer to Database
" ============================================================================
CLASS lsc_ZCDS_I_SALES_ORDER_U DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize REDEFINITION.
    METHODS check_before_save REDEFINITION.
    METHODS save REDEFINITION.
    METHODS cleanup REDEFINITION.
    METHODS cleanup_finalize REDEFINITION.
ENDCLASS.

CLASS lsc_ZCDS_I_SALES_ORDER_U IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    " -------------------------------------------------------------------------
    " UNMANAGED SAVE: Executed during COMMIT phase to persist custom buffer to DB
    " -------------------------------------------------------------------------
    " In production, this executes BAPI_TRANSACTION_COMMIT or custom SQL INSERT
  ENDMETHOD.

  METHOD cleanup.
    CLEAR zcl_bp_sales_order_u=>gt_so_buffer.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
