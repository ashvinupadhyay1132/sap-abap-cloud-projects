CLASS zcl_pr_ddic_runner DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_pr_ddic_runner IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    DATA(lo_engine) = NEW zcl_pr_ddic_engine( ).

    out->write( '========================================================================================' ).
    out->write( '          SAP MM MODULE - PURCHASE REQUISITION DATA DICTIONARY (DDIC) ENGINE           ' ).
    out->write( '========================================================================================' ).

    " -------------------------------------------------------------------
    " 1. INSTANTIATING DEEP DDIC PURCHASE REQUISITION STRUCTURE
    " -------------------------------------------------------------------
    DATA(ls_pr_1) = VALUE zcl_pr_ddic_engine=>ty_pr_header_ddic(
      pr_number     = '10000891'
      pr_type       = 'NB' " Standard PR Domain Value
      pr_status     = 'S'  " Submitted Domain Value
      plant         = '1000'
      department    = 'IT Infrastructure'
      created_by    = 'ASHVIN_U'
      creation_date = cl_abap_context_info=>get_system_date( )
      currency_code = 'INR'
      items         = VALUE #(
        ( pr_number = '10000891' pr_item_no = 10 material_no = 'MAT-SERVER-01' material_text = 'Dell PowerEdge R750 Server'  quantity = 2 unit_of_measure = 'ST' price_per_unit = 250000 currency_code = 'INR' purchasing_group = 'P01' )
        ( pr_number = '10000891' pr_item_no = 20 material_no = 'MAT-RAM-64GB'   material_text = '64GB DDR4 ECC RAM Module'    quantity = 8 unit_of_measure = 'ST' price_per_unit = 18000  currency_code = 'INR' purchasing_group = 'P01' )
      )
    ).

    DATA(ls_pr_2) = VALUE zcl_pr_ddic_engine=>ty_pr_header_ddic(
      pr_number     = '10000892'
      pr_type       = 'INVALID_TYPE' " Invalid Domain Value Test
      pr_status     = 'D'            " Draft Domain Value
      plant         = '2000'
      department    = 'Plant Operations'
      created_by    = 'RIYA_S'
      creation_date = cl_abap_context_info=>get_system_date( )
      currency_code = 'INR'
      items         = VALUE #(
        ( pr_number = '10000892' pr_item_no = 10 material_no = 'MAT-LUBRICANT-X' material_text = 'Industrial Machine Oil 50L' quantity = 5 unit_of_measure = 'LTR' price_per_unit = 4500 currency_code = 'INR' purchasing_group = 'P02' )
      )
    ).

    DATA lt_pr_list TYPE zcl_pr_ddic_engine=>tt_pr_headers_ddic.
    APPEND ls_pr_1 TO lt_pr_list.
    APPEND ls_pr_2 TO lt_pr_list.

    " -------------------------------------------------------------------
    " 2. LOOP & VALIDATE DDIC DOMAIN RULES AND CALCULATE TOTALS
    " -------------------------------------------------------------------
    LOOP AT lt_pr_list REFERENCE INTO DATA(lr_pr).

      out->write( '----------------------------------------------------------------------------------------' ).
      out->write( |PR Number : { lr_pr->pr_number } | &
                  |Plant : { lr_pr->plant } | &
                  |Dept : { lr_pr->department } | &
                  |Created By : { lr_pr->created_by }| ).

      " DDIC Domain Validations
      DATA(lv_type_valid)   = lo_engine->validate_pr_type( lr_pr->pr_type ).
      DATA(lv_status_valid) = lo_engine->validate_pr_status( lr_pr->pr_status ).

      IF lv_type_valid = abap_false.
        out->write( |   [DDIC DOMAIN ERROR]: PR Type '{ lr_pr->pr_type }' is INVALID! Value Range must be NB, FO, or RV.| ).
        CONTINUE.
      ENDIF.

      IF lv_status_valid = abap_false.
        out->write( |   [DDIC DOMAIN ERROR]: PR Status '{ lr_pr->pr_status }' is INVALID! Value Range must be D, S, A, or R.| ).
        CONTINUE.
      ENDIF.

      " Calculate Totals using DDIC Processing Engine
      lo_engine->calculate_pr_totals( CHANGING cs_pr_header = lr_pr->* ).

      out->write( |   [DDIC VALIDATED]: PR Type '{ lr_pr->pr_type }' & Status '{ lr_pr->pr_status }' Passed Data Dictionary Validation.| ).
      out->write( '   Line Items:' ).

      LOOP AT lr_pr->items INTO DATA(ls_item).
        out->write( |     - Item { ls_item-pr_item_no }: { ls_item-material_no WIDTH = 17 } | &
                    |{ ls_item-material_text WIDTH = 30 } | &
                    |Qty: { ls_item-quantity ALIGN = RIGHT WIDTH = 3 } { ls_item-unit_of_measure } | &
                    |Price/Unit: ₹{ ls_item-price_per_unit ALIGN = RIGHT WIDTH = 8 } | &
                    |Total Item Val: ₹{ ls_item-total_item_value ALIGN = RIGHT WIDTH = 9 } { ls_item-currency_code }| ).
      ENDLOOP.

      out->write( |   -> Calculated Total Requisition Value : ₹{ lr_pr->total_pr_amount } { lr_pr->currency_code }| ).

    ENDLOOP.

    out->write( '========================================================================================' ).
    out->write( 'SUMMARY: Purchase Requisition Data Dictionary Processing & Validation Completed.' ).
    out->write( '========================================================================================' ).
  ENDMETHOD.

ENDCLASS.
