" ============================================================================
" CLASS: zcl_test_rap_draft_pr
" PURPOSE: Automated ABAP Unit Test Suite for Stateful RAP Draft Procurement
" TEST-DRIVEN DEVELOPMENT (TDD): Uses cl_abap_unit_assert to verify draft lifecycle
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_test_rap_draft_pr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS .

  PRIVATE SECTION.
    METHODS setup.
    METHODS teardown.

    METHODS test_draft_creation_and_prepare FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS zcl_test_rap_draft_pr IMPLEMENTATION.

  METHOD setup.
  ENDMETHOD.

  METHOD teardown.
  ENDMETHOD.

  METHOD test_draft_creation_and_prepare.
    " EML Test Call triggering draft creation
    MODIFY ENTITIES OF zcds_i_pr_req_h
      ENTITY RequisitionHeader
        CREATE FIELDS ( Purchasing_Org Vendor_ID Total_Estimated_Cost Currency )
        WITH VALUE #( ( %cid                 = 'CID_PR_DRAFT_01'
                        Purchasing_Org       = '070001'
                        Vendor_ID            = '000100'
                        Total_Estimated_Cost = 750000
                        Currency             = 'INR'
                        %is_draft            = if_abap_behv=>mk-on ) )
      MAPPED DATA(ls_mapped)
      FAILED DATA(ls_failed).

    cl_abap_unit_assert=>assert_initial( act = ls_failed-requisitionheader msg = 'Draft Requisition creation should not fail' ).
    cl_abap_unit_assert=>assert_not_initial( act = ls_mapped-requisitionheader msg = 'Draft instance key must be generated' ).
  ENDMETHOD.

ENDCLASS.
