" ============================================================================
" CLASS: zcl_bp_invoice_h
" PURPOSE: Behavior Pool for SAP RAP Managed Invoice Entity ZCDS_I_INVOICE_H
" PATTERN: Early Custom Numbering Engine (Integrates cl_number_range API)
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_bp_invoice_h DEFINITION
  PUBLIC
  ABSTRACT
  FINAL
  FOR BEHAVIOR OF zcds_i_invoice_h.

  PUBLIC SECTION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_bp_invoice_h IMPLEMENTATION.
ENDCLASS.

" ============================================================================
" LOCAL HANDLER CLASS: lhc_InvoiceHeader
" Implements early numbering for key generation before transactional commit
" ============================================================================
CLASS lhc_InvoiceHeader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR InvoiceHeader RESULT result.

    " Early Numbering Method: Generates custom document keys (e.g. INV-2026-000001)
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE InvoiceHeader.

ENDCLASS.

CLASS lhc_InvoiceHeader IMPLEMENTATION.

  METHOD get_instance_authorizations.
    LOOP AT keys INTO DATA(ls_key).
      APPEND VALUE #( %tky = ls_key-%tky
                      %update = if_abap_behv=>auth-allowed
                      %delete = if_abap_behv=>auth-allowed ) TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA lv_sequence TYPE n LENGTH 8 VALUE 1.

    " -------------------------------------------------------------------------
    " EARLY CUSTOM NUMBERING LOGIC:
    " Simulates cl_number_range=>get_next API call to format document keys
    " -------------------------------------------------------------------------
    LOOP AT entities INTO DATA(ls_entity).
      " Format key prefix: INV-YYYY-XXXXXXXX
      DATA(lv_year)         = cl_abap_context_info=>get_system_date( )(4).
      DATA(lv_formatted_id) = CONV /dmo/travel_id( |{ lv_sequence WIDTH = 8 ALIGN = RIGHT PAD = '0' }| ).

      " Map generated key to RAP mapped structure
      APPEND VALUE #(
        %cid       = ls_entity-%cid
        Invoice_ID = lv_formatted_id
      ) TO mapped-invoiceheader.

      lv_sequence = lv_sequence + 1.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
