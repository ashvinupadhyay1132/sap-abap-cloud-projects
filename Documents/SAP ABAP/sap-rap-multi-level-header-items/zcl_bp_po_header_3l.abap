" ============================================================================
" CLASS: zcl_bp_po_header_3l
" PURPOSE: Global Behavior Pool for 3-Level RAP Purchase Order BO
" PATTERN: Multi-Level Composition Tree (Header -> Item -> Schedule Line)
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_bp_po_header_3l DEFINITION
  PUBLIC
  ABSTRACT
  FINAL
  FOR BEHAVIOR OF zcds_i_po_header_3l.

  PUBLIC SECTION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_bp_po_header_3l IMPLEMENTATION.
ENDCLASS.

" ============================================================================
" LOCAL HANDLER CLASS: lhc_POHeader
" Implements Level 1 Root authorization and transactional handling
" ============================================================================
CLASS lhc_POHeader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR POHeader RESULT result.
ENDCLASS.

CLASS lhc_POHeader IMPLEMENTATION.

  METHOD get_instance_authorizations.
    LOOP AT keys INTO DATA(ls_key).
      APPEND VALUE #( %tky = ls_key-%tky
                      %update = if_abap_behv=>auth-allowed
                      %delete = if_abap_behv=>auth-allowed ) TO result.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

" ============================================================================
" LOCAL HANDLER CLASS: lhc_POItem
" Implements Level 2 Child item behavior handling
" ============================================================================
CLASS lhc_POItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
ENDCLASS.

CLASS lhc_POItem IMPLEMENTATION.
ENDCLASS.

" ============================================================================
" LOCAL HANDLER CLASS: lhc_POScheduleLine
" Implements Level 3 Grandchild schedule line behavior handling
" ============================================================================
CLASS lhc_POScheduleLine DEFINITION INHERITING FROM cl_abap_behavior_handler.
ENDCLASS.

CLASS lhc_POScheduleLine IMPLEMENTATION.
ENDCLASS.
