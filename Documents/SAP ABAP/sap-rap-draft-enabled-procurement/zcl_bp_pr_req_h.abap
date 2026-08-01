" ============================================================================
" CLASS: zcl_bp_pr_req_h
" PURPOSE: Behavior Pool for Stateful Draft-Enabled Requisition BO ZCDS_I_PR_REQ_H
" PATTERN: RAP Draft Framework (Edit, Activate, Discard, Resume, Prepare)
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_bp_pr_req_h DEFINITION
  PUBLIC
  ABSTRACT
  FINAL
  FOR BEHAVIOR OF zcds_i_pr_req_h.

  PUBLIC SECTION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_bp_pr_req_h IMPLEMENTATION.
ENDCLASS.

" ============================================================================
" LOCAL HANDLER CLASS: lhc_RequisitionHeader
" Implements draft validation methods and instance authorizations
" ============================================================================
CLASS lhc_RequisitionHeader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR RequisitionHeader RESULT result.

    " Draft Validation Method: Validates master vendor ID during 'Prepare' action
    METHODS validateVendor FOR VALIDATE ON SAVE
      IMPORTING keys FOR RequisitionHeader~validateVendor.

ENDCLASS.

CLASS lhc_RequisitionHeader IMPLEMENTATION.

  METHOD get_instance_authorizations.
    LOOP AT keys INTO DATA(ls_key).
      APPEND VALUE #( %tky = ls_key-%tky
                      %update = if_abap_behv=>auth-allowed
                      %delete = if_abap_behv=>auth-allowed ) TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateVendor.
    " -------------------------------------------------------------------------
    " DRAFT PREPARE VALIDATION: validateVendor
    " Executed during Draft Prepare action before activation to active persistence
    " -------------------------------------------------------------------------
    READ ENTITIES OF zcds_i_pr_req_h IN LOCAL MODE
      ENTITY RequisitionHeader
        FIELDS ( Vendor_ID ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_requisitions).

    LOOP AT lt_requisitions INTO DATA(ls_req).
      " Validate non-initial Vendor ID constraint
      IF ls_req-Vendor_ID IS INITIAL.
        APPEND VALUE #( %tky = ls_req-%tky ) TO failed-requisitionheader.
        APPEND VALUE #( %tky               = ls_req-%tky
                        %msg               = new_message_with_text(
                                               severity = if_abap_behv_message=>severity-error
                                               text     = 'Vendor ID is required for Requisition Activation' )
                        %element-Vendor_ID = if_abap_behv=>mk-on ) TO reported-requisitionheader.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
