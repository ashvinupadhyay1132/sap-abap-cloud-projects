CLASS lcl_sales_order DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_order_details,
             order_id      TYPE string,
             customer_name TYPE string,
             gross_amount  TYPE decfloat34,
             discount_pct  TYPE decfloat34,
             net_amount    TYPE decfloat34,
             status        TYPE string,
           END OF ty_order_details.

    " 1. CONSTRUCTOR Method (Executed automatically on object creation)
    METHODS constructor
      IMPORTING
        iv_order_id      TYPE string
        iv_customer_name TYPE string
        iv_customer_type TYPE string
        iv_gross_amount  TYPE decfloat34.

    " 2. INSTANCE METHODS (Called using Arrow Operator ->)
    METHODS process_discount.

    METHODS get_order_details
      RETURNING VALUE(rs_details) TYPE ty_order_details.

  PRIVATE SECTION.
    " Private Instance Attributes (Encapsulation)
    DATA mv_order_id      TYPE string.
    DATA mv_customer_name TYPE string.
    DATA mv_customer_type TYPE string. " VIP, REGULAR, NEW
    DATA mv_gross_amount  TYPE decfloat34.
    DATA mv_discount_pct  TYPE decfloat34.
    DATA mv_net_amount    TYPE decfloat34.
    DATA mv_status        TYPE string.
ENDCLASS.

CLASS lcl_sales_order IMPLEMENTATION.

  METHOD constructor.
    " Initializing instance attributes
    me->mv_order_id      = iv_order_id.
    me->mv_customer_name = iv_customer_name.
    me->mv_customer_type = iv_customer_type.
    me->mv_gross_amount  = iv_gross_amount.

    " Validation using IF/ELSE
    IF me->mv_gross_amount <= 0.
      me->mv_status = 'REJECTED - INVALID AMOUNT'.
    ELSE.
      me->mv_status = 'PENDING DISCOUNT'.
    ENDIF.
  ENDMETHOD.

  METHOD process_discount.
    " Production Logic: IF / ELSEIF / ELSE business rules
    IF me->mv_status = 'REJECTED - INVALID AMOUNT'.
      RETURN.
    ENDIF.

    IF me->mv_customer_type = 'VIP'.
      IF me->mv_gross_amount >= 50000.
        me->mv_discount_pct = 20. " 20% Discount for High-Value VIP
      ELSE.
        me->mv_discount_pct = 15. " 15% Discount for Regular VIP
      ENDIF.
    ELSEIF me->mv_customer_type = 'REGULAR'.
      IF me->mv_gross_amount >= 30000.
        me->mv_discount_pct = 10.
      ELSE.
        me->mv_discount_pct = 5.
      ENDIF.
    ELSE.
      " NEW or OTHER customers
      me->mv_discount_pct = 2.
    ENDIF.

    " Calculate Net Amount
    me->mv_net_amount = me->mv_gross_amount * ( 1 - ( me->mv_discount_pct / 100 ) ).
    me->mv_status     = 'PROCESSED & APPROVED'.
  ENDMETHOD.

  METHOD get_order_details.
    " Returning structured details
    rs_details = VALUE #(
      order_id      = me->mv_order_id
      customer_name = me->mv_customer_name
      gross_amount  = me->mv_gross_amount
      discount_pct  = me->mv_discount_pct
      net_amount    = me->mv_net_amount
      status        = me->mv_status
    ).
  ENDMETHOD.

ENDCLASS.


CLASS zcl_order_processor DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_order_processor IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    " -------------------------------------------------------------------
    " 1. OBJECT REFERENCE TABLE (Internal Table holding Class Instances)
    " -------------------------------------------------------------------
    DATA lt_order_list TYPE STANDARD TABLE OF REF TO lcl_sales_order WITH EMPTY KEY.

    " -------------------------------------------------------------------
    " 2. INSTANTIATION USING 'NEW' OPERATOR (Creating Objects)
    " -------------------------------------------------------------------
    " Object Reference 1
    DATA(lo_order1) = NEW lcl_sales_order(
      iv_order_id      = 'SO-2026-001'
      iv_customer_name = 'TATA Motors Ltd'
      iv_customer_type = 'VIP'
      iv_gross_amount  = 75000
    ).
    APPEND lo_order1 TO lt_order_list.

    " Object Reference 2
    DATA(lo_order2) = NEW lcl_sales_order(
      iv_order_id      = 'SO-2026-002'
      iv_customer_name = 'Infosys Solutions'
      iv_customer_type = 'REGULAR'
      iv_gross_amount  = 35000
    ).
    APPEND lo_order2 TO lt_order_list.

    " Object Reference 3 (Inline NEW directly into table append)
    APPEND NEW lcl_sales_order(
      iv_order_id      = 'SO-2026-003'
      iv_customer_name = 'Startup Hub Tech'
      iv_customer_type = 'NEW'
      iv_gross_amount  = 15000
    ) TO lt_order_list.

    " Object Reference 4 (Edge Case: Invalid Amount)
    APPEND NEW lcl_sales_order(
      iv_order_id      = 'SO-2026-004'
      iv_customer_name = 'Bad Entry Corp'
      iv_customer_type = 'REGULAR'
      iv_gross_amount  = 0
    ) TO lt_order_list.

    " -------------------------------------------------------------------
    " 3. OUTPUT HEADER REPORT
    " -------------------------------------------------------------------
    out->write( '========================================================================================' ).
    out->write( '                       ENTERPRISE SALES ORDER DISCOUNT ENGINE                           ' ).
    out->write( '========================================================================================' ).

    DATA lv_total_revenue TYPE decfloat34 VALUE 0.
    DATA lv_processed_count TYPE i VALUE 0.

    " -------------------------------------------------------------------
    " 4. LOOP AT (Processing Object References)
    " -------------------------------------------------------------------
    LOOP AT lt_order_list INTO DATA(lo_current_order).

      " Calling Instance Method via Arrow Operator ->
      lo_current_order->process_discount( ).

      " Calling Return Method via Arrow Operator ->
      DATA(ls_info) = lo_current_order->get_order_details( ).

      " IF Check on Processing Status
      IF ls_info-status = 'PROCESSED & APPROVED'.
        lv_total_revenue = lv_total_revenue + ls_info-net_amount.
        lv_processed_count = lv_processed_count + 1.
      ENDIF.

      " Print Order Row
      out->write( |Order ID: { ls_info-order_id WIDTH = 13 } | &
                  |Customer: { ls_info-customer_name WIDTH = 20 } | &
                  |Gross: ₹{ ls_info-gross_amount ALIGN = RIGHT WIDTH = 9 } | &
                  |Disc: { ls_info-discount_pct ALIGN = RIGHT WIDTH = 4 }% | &
                  |Net: ₹{ ls_info-net_amount ALIGN = RIGHT WIDTH = 9 } | &
                  |Status: { ls_info-status }| ).

    ENDLOOP.

    " -------------------------------------------------------------------
    " 5. DO LOOP (Batch Log Simulation)
    " -------------------------------------------------------------------
    out->write( '----------------------------------------------------------------------------------------' ).
    DO 2 TIMES.
      out->write( |[LOG BATCH #{ sy-index }]: Batch audit verification completed successfully.| ).
    ENDDO.

    " -------------------------------------------------------------------
    " 6. SUMMARY STATS
    " -------------------------------------------------------------------
    out->write( '========================================================================================' ).
    out->write( |Total Approved Orders : { lv_processed_count }| ).
    out->write( |Total Net Revenue     : ₹{ lv_total_revenue }| ).
    out->write( '========================================================================================' ).

  ENDMETHOD.

ENDCLASS.
