" ============================================================================
" CLASS: zcl_bp_inventory_m
" PURPOSE: Global Behavior Pool for Managed RAP Inventory Entity ZCDS_I_INVENTORY_M
" PATTERN: Dynamic Feature Control, Side Effects, Determinations & Actions
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_bp_inventory_m DEFINITION
  PUBLIC
  ABSTRACT
  FINAL
  FOR BEHAVIOR OF zcds_i_inventory_m.

  PUBLIC SECTION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_bp_inventory_m IMPLEMENTATION.
ENDCLASS.

" ============================================================================
" LOCAL HANDLER CLASS: lhc_Inventory
" Implements Dynamic Instance Features, Actions, Determinations, and Validations
" ============================================================================
CLASS lhc_Inventory DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Inventory RESULT result.

    " Instance Feature Control: Dynamically enables/disables 'reorderStock' action
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Inventory RESULT result.

    " RAP Action Handler: Triggers automated stock replenishment order
    METHODS reorderStock FOR MODIFY
      IMPORTING keys FOR ACTION Inventory~reorderStock RESULT result.

    " RAP Determination: Recalculates stock status upon Stock_Quantity modification
    METHODS calculateStockStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Inventory~calculateStockStatus.

    " RAP Validation: Enforces non-negative stock quantity rules on save
    METHODS validateStockThreshold FOR VALIDATE ON SAVE
      IMPORTING keys FOR Inventory~validateStockThreshold.

ENDCLASS.

CLASS lhc_Inventory IMPLEMENTATION.

  METHOD get_instance_authorizations.
    LOOP AT keys INTO DATA(ls_key).
      APPEND VALUE #( %tky = ls_key-%tky
                      %update = if_abap_behv=>auth-allowed
                      %delete = if_abap_behv=>auth-allowed ) TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.
    " -------------------------------------------------------------------------
    " DYNAMIC INSTANCE FEATURE CONTROL:
    " Reads Stock_Quantity to determine if 'reorderStock' action is enabled
    " -------------------------------------------------------------------------
    READ ENTITIES OF zcds_i_inventory_m IN LOCAL MODE
      ENTITY Inventory
        FIELDS ( Stock_Quantity Stock_Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_inventory).

    LOOP AT lt_inventory INTO DATA(ls_inv).
      " Enable 'reorderStock' ONLY if stock quantity is below critical threshold (<= 10)
      DATA(lv_action_state) = COND #( WHEN ls_inv-Stock_Quantity <= 10
                                       THEN if_abap_behv=>fc-o-enabled
                                       ELSE if_abap_behv=>fc-o-disabled ).

      APPEND VALUE #(
        %tky                 = ls_inv-%tky
        %action-reorderStock = lv_action_state
      ) TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD reorderStock.
    " -------------------------------------------------------------------------
    " RAP ACTION HANDLER: reorderStock
    " Executes purchase requisition trigger for critical stock levels
    " -------------------------------------------------------------------------
    MODIFY ENTITIES OF zcds_i_inventory_m IN LOCAL MODE
      ENTITY Inventory
        UPDATE FIELDS ( Stock_Status Reorder_Flag )
        WITH VALUE #( FOR key IN keys ( %tky         = key-%tky
                                        Stock_Status = 'O'  " Set Status to Optimal
                                        Reorder_Flag = 'N' ) ) " Reset Reorder Flag
      FAILED failed
      REPORTED reported.

    " Read updated instance for UI response
    READ ENTITIES OF zcds_i_inventory_m IN LOCAL MODE
      ENTITY Inventory
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_updated).

    result = VALUE #( FOR inv IN lt_updated ( %tky   = inv-%tky
                                              %param = inv ) ).
  ENDMETHOD.

  METHOD calculateStockStatus.
    " -------------------------------------------------------------------------
    " RAP DETERMINATION: calculateStockStatus
    " Triggered automatically on modifying Stock_Quantity (Side Effects Target)
    " -------------------------------------------------------------------------
    READ ENTITIES OF zcds_i_inventory_m IN LOCAL MODE
      ENTITY Inventory
        FIELDS ( Stock_Quantity ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_inventory).

    LOOP AT lt_inventory INTO DATA(ls_inv).
      " Evaluate Stock Threshold (< 10 = Critical, > 10 = Optimal)
      DATA(lv_status) = COND #( WHEN ls_inv-Stock_Quantity <= 10 THEN 'C' ELSE 'O' ).
      DATA(lv_flag)   = COND #( WHEN ls_inv-Stock_Quantity <= 10 THEN 'Y' ELSE 'N' ).

      " Update calculated fields in local buffer
      MODIFY ENTITIES OF zcds_i_inventory_m IN LOCAL MODE
        ENTITY Inventory
          UPDATE FIELDS ( Stock_Status Reorder_Flag )
          WITH VALUE #( ( %tky         = ls_inv-%tky
                          Stock_Status = lv_status
                          Reorder_Flag = lv_flag ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD validateStockThreshold.
    " -------------------------------------------------------------------------
    " RAP VALIDATION: validateStockThreshold
    " Prevents saving negative inventory quantities
    " -------------------------------------------------------------------------
    READ ENTITIES OF zcds_i_inventory_m IN LOCAL MODE
      ENTITY Inventory
        FIELDS ( Stock_Quantity ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_inventory).

    LOOP AT lt_inventory INTO DATA(ls_inv).
      IF ls_inv-Stock_Quantity < 0.
        APPEND VALUE #( %tky = ls_inv-%tky ) TO failed-inventory.
        APPEND VALUE #( %tky                  = ls_inv-%tky
                        %msg                  = new_message_with_text(
                                                  severity = if_abap_behv_message=>severity-error
                                                  text     = 'Stock Quantity cannot be negative' )
                        %element-Stock_Quantity = if_abap_behv=>mk-on ) TO reported-inventory.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
