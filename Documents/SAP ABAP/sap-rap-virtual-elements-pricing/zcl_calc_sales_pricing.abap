" ============================================================================
" CLASS: zcl_calc_sales_pricing
" PURPOSE: Virtual Element Exit Class for Dynamic Sales Pricing & Tax Math
" INTERFACE: if_sadl_exit_calc_element_read
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_calc_sales_pricing DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_calc_sales_pricing IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~calculate.
    " -------------------------------------------------------------------------
    " VIRTUAL ELEMENT CALCULATION METHOD:
    " Evaluates Discount_Amount, Net_Tax_Amount (18% GST), and Final_Gross_Price
    " -------------------------------------------------------------------------
    DATA lt_original_data TYPE STANDARD TABLE OF zcds_i_sales_pricing WITH DEFAULT KEY.
    lt_original_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<ls_order>).
      " 1. Calculate Discount Amount
      DATA(lv_discount_pct) = <ls_order>-Discount_Percentage.
      IF lv_discount_pct > 0.
        <ls_order>-Discount_Amount = ( <ls_order>-Base_List_Price * lv_discount_pct ) / 100.
      ELSE.
        <ls_order>-Discount_Amount = 0.
      ENDIF.

      " 2. Calculate Net Taxable Price
      DATA(lv_taxable_amount) = <ls_order>-Base_List_Price - <ls_order>-Discount_Amount.

      " 3. Calculate 18% GST Tax Amount
      <ls_order>-Net_Tax_Amount = ( lv_taxable_amount * 18 ) / 100.

      " 4. Calculate Final Gross Price
      <ls_order>-Final_Gross_Price = lv_taxable_amount + <ls_order>-Net_Tax_Amount.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_original_data ).
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    " Declare dependent fields required for virtual calculation
    IF line_exists( it_requested_calc_elements[ table_line = 'DISCOUNT_AMOUNT' ] ) OR
       line_exists( it_requested_calc_elements[ table_line = 'NET_TAX_AMOUNT' ] ) OR
       line_exists( it_requested_calc_elements[ table_line = 'FINAL_GROSS_PRICE' ] ).

      INSERT `BASE_LIST_PRICE` INTO TABLE et_requested_orig_elements.
      INSERT `DISCOUNT_PERCENTAGE` INTO TABLE et_requested_orig_elements.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
