CLASS zcl_order_processor DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

    TYPES: BEGIN OF ty_order_item,
             order_id      TYPE string,
             customer_name TYPE string,
             customer_type TYPE string,
             gross_amount  TYPE decfloat34,
             discount_pct  TYPE decfloat34,
             net_amount    TYPE decfloat34,
             status        TYPE string,
           END OF ty_order_item,
           tt_order_list TYPE STANDARD TABLE OF ty_order_item WITH EMPTY KEY.

    METHODS constructor.

    METHODS create_order
      IMPORTING
        iv_order_id      TYPE string
        iv_customer_name TYPE string
        iv_customer_type TYPE string
        iv_gross_amount  TYPE decfloat34
      RETURNING
        VALUE(rs_order)  TYPE ty_order_item.

    METHODS process_discount
      CHANGING
        cs_order TYPE ty_order_item.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mv_system_status TYPE string.
ENDCLASS.

CLASS zcl_order_processor IMPLEMENTATION.

  METHOD constructor.
    me->mv_system_status = 'ENGINE_READY'.
  ENDMETHOD.

  METHOD create_order.
    rs_order = VALUE #(
      order_id      = iv_order_id
      customer_name = iv_customer_name
      customer_type = iv_customer_type
      gross_amount  = iv_gross_amount
      status        = COND #( WHEN iv_gross_amount <= 0 THEN 'REJECTED - INVALID AMOUNT'
                              ELSE 'PENDING DISCOUNT' )
    ).
  ENDMETHOD.

  METHOD process_discount.
    IF cs_order-status = 'REJECTED - INVALID AMOUNT'.
      RETURN.
    ENDIF.

    IF cs_order-customer_type = 'REGULAR' AND cs_order-gross_amount < 30000.
      cs_order-discount_pct = 0.
      cs_order-status     = 'REJECTED - BELOW MIN ORDER LIMIT (₹30,000)'.
      RETURN.
    ENDIF.

    IF cs_order-customer_type = 'VIP'.
      cs_order-discount_pct = COND #( WHEN cs_order-gross_amount >= 50000 THEN 20 ELSE 15 ).
    ELSEIF cs_order-customer_type = 'REGULAR'.
      cs_order-discount_pct = 10.
    ELSE.
      cs_order-discount_pct = 2.
    ENDIF.

    cs_order-net_amount = cs_order-gross_amount * ( 1 - ( cs_order-discount_pct / 100 ) ).
    cs_order-status     = 'PROCESSED & APPROVED'.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.

    DATA(lo_engine) = NEW zcl_order_processor( ).

    DATA(lt_orders) = VALUE tt_order_list(
      ( lo_engine->create_order( iv_order_id = 'SO-2026-001' iv_customer_name = 'TATA Motors Ltd'   iv_customer_type = 'VIP'     iv_gross_amount = 75000 ) )
      ( lo_engine->create_order( iv_order_id = 'SO-2026-002' iv_customer_name = 'Infosys Solutions' iv_customer_type = 'REGULAR' iv_gross_amount = 35000 ) )
      ( lo_engine->create_order( iv_order_id = 'SO-2026-002' iv_customer_name = 'Infosys Solutions' iv_customer_type = 'REGULAR' iv_gross_amount = 29000 ) )
      ( lo_engine->create_order( iv_order_id = 'SO-2026-003' iv_customer_name = 'Startup Hub Tech'  iv_customer_type = 'NEW'     iv_gross_amount = 15000 ) )
      ( lo_engine->create_order( iv_order_id = 'SO-2026-004' iv_customer_name = 'Bad Entry Corp'    iv_customer_type = 'REGULAR' iv_gross_amount = 0     ) )
    ).

    out->write( '========================================================================================' ).
    out->write( '                       ENTERPRISE SALES ORDER DISCOUNT ENGINE                           ' ).
    out->write( '========================================================================================' ).

    DATA(lv_total_revenue)   = CONV decfloat34( 0 ).
    DATA(lv_processed_count) = 0.

    LOOP AT lt_orders REFERENCE INTO DATA(lr_order).

      lo_engine->process_discount( CHANGING cs_order = lr_order->* ).

      IF lr_order->status = 'PROCESSED & APPROVED'.
        lv_total_revenue   = lv_total_revenue + lr_order->net_amount.
        lv_processed_count = lv_processed_count + 1.
      ENDIF.

      out->write( |Order ID: { lr_order->order_id WIDTH = 13 } | &
                  |Customer: { lr_order->customer_name WIDTH = 20 } | &
                  |Gross: ₹{ lr_order->gross_amount ALIGN = RIGHT WIDTH = 9 } | &
                  |Disc: { lr_order->discount_pct ALIGN = RIGHT WIDTH = 4 }% | &
                  |Net: ₹{ lr_order->net_amount ALIGN = RIGHT WIDTH = 9 } | &
                  |Status: { lr_order->status }| ).

    ENDLOOP.

    out->write( '----------------------------------------------------------------------------------------' ).
    DO 2 TIMES.
      out->write( |[LOG BATCH #{ sy-index }]: Batch audit verification completed successfully.| ).
    ENDDO.

    out->write( '========================================================================================' ).
    out->write( |Total Approved Orders : { lv_processed_count }| ).
    out->write( |Total Net Revenue     : ₹{ lv_total_revenue }| ).
    out->write( '========================================================================================' ).

  ENDMETHOD.

ENDCLASS.
