" ============================================================================
" CLASS: zcl_test_amdp_analytics
" PURPOSE: Automated ABAP Unit Test Suite for AMDP Financial Analytics Engine
" TEST-DRIVEN DEVELOPMENT (TDD): Uses cl_abap_unit_assert to verify results
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_test_amdp_analytics DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS .

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO zcl_amdp_financial_analytics.

    METHODS setup.
    METHODS teardown.

    " Unit Test Method: Verifies financial profit and window rank calculations
    METHODS test_margin_and_ranking FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS zcl_test_amdp_analytics IMPLEMENTATION.

  METHOD setup.
    " Instantiate Class Under Test (CUT)
    mo_cut = NEW #( ).
  ENDMETHOD.

  METHOD teardown.
    CLEAR mo_cut.
  ENDMETHOD.

  METHOD test_margin_and_ranking.
    " 1. Prepare Mock Postings Input
    DATA(lt_postings) = VALUE zcl_amdp_financial_analytics=>tt_financial_postings(
      ( company_code = '1000' division = 'CLOUD_SERVICES' fiscal_year = '2026' posting_date = '20260115' revenue = 100000 cogs = 40000 opex = 10000 currency = 'INR' )
      ( company_code = '1000' division = 'HARDWARE_SALES' fiscal_year = '2026' posting_date = '20260110' revenue = 50000  cogs = 30000 opex = 5000  currency = 'INR' )
    ).

    DATA lt_analytics TYPE zcl_amdp_financial_analytics=>tt_financial_analytics.

    " 2. Execute Method Under Test
    mo_cut->get_financial_revenue_analytics(
      EXPORTING
        it_postings  = lt_postings
      IMPORTING
        et_analytics = lt_analytics
    ).

    " 3. Assertions (TDD Verification)
    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_analytics )
      exp = 2
      msg = 'Result table should contain exactly 2 aggregated rows'
    ).

    " Verify Rank #1 (CLOUD_SERVICES with 100000 revenue)
    READ TABLE lt_analytics WITH KEY division = 'CLOUD_SERVICES' INTO DATA(ls_cloud).
    cl_abap_unit_assert=>assert_equals( act = ls_cloud-revenue_rank exp = 1 msg = 'Cloud division should be Rank 1' ).
    cl_abap_unit_assert=>assert_equals( act = ls_cloud-net_profit   exp = 50000 msg = 'Net profit should be 100000 - 40000 - 10000 = 50000' ).
    cl_abap_unit_assert=>assert_equals( act = ls_cloud-margin_status exp = 'HIGH MARGIN' msg = '50000 net profit should qualify as HIGH MARGIN' ).
  ENDMETHOD.

ENDCLASS.
