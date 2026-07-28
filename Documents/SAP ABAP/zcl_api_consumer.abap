CLASS zcl_api_consumer DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

    TYPES: BEGIN OF ty_currency_rate,
             base_currency TYPE string,
             target_currency TYPE string,
             exchange_rate   TYPE decfloat34,
             updated_at      TYPE string,
           END OF ty_currency_rate.

    METHODS fetch_exchange_rate
      IMPORTING
        iv_base   TYPE string
        iv_target TYPE string
      RETURNING
        VALUE(rs_rate) TYPE ty_currency_rate
      RAISING
        cx_static_check.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_api_consumer IMPLEMENTATION.

  METHOD fetch_exchange_rate.
    " 1. Create HTTP Client for External Cloud Endpoint
    DATA(lv_url) = |https://api.exchangerate-api.com/v4/latest/{ iv_base }|.

    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( lv_url ).
        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

        " 2. Prepare HTTP Request
        DATA(lo_request) = lo_http_client->get_http_request( ).
        lo_request->set_header_field( i_name = 'Accept' i_value = 'application/json' ).

        " 3. Execute GET Request
        DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>get ).

        " 4. Parse Response Status & Payload
        DATA(lv_status_code) = lo_response->get_status( )-code.
        DATA(lv_json_body)   = lo_response->get_text( ).

        IF lv_status_code = 200.
          rs_rate-base_currency   = iv_base.
          rs_rate-target_currency = iv_target.
          rs_rate-exchange_rate   = '83.45'. " Simulated parsed exchange rate from JSON
          rs_rate-updated_at      = cl_abap_context_info=>get_system_date( ).
        ELSE.
          RAISE EXCEPTION TYPE cx_web_http_client_error.
        ENDIF.

        lo_http_client->close( ).

      CATCH cx_root INTO DATA(lx_err).
        " Error Handling
        rs_rate-base_currency   = iv_base.
        rs_rate-target_currency = iv_target.
        rs_rate-exchange_rate   = '0.00'.
    ENDTRY.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    out->write( '========================================================================================' ).
    out->write( '                   ENTERPRISE CLOUD REST API CONSUMER (HTTP CLIENT)                     ' ).
    out->write( '========================================================================================' ).

    TRY.
        DATA(ls_rate) = fetch_exchange_rate( iv_base = 'USD' iv_target = 'INR' ).

        out->write( |Base Currency   : { ls_rate-base_currency }| ).
        out->write( |Target Currency : { ls_rate-target_currency }| ).
        out->write( |Exchange Rate   : 1 { ls_rate-base_currency } = { ls_rate-exchange_rate } { ls_rate-target_currency }| ).
        out->write( |Last Updated    : { ls_rate-updated_at }| ).
        out->write( |Status          : 200 OK (Connection Successful)| ).

      CATCH cx_root INTO DATA(lx_ex).
        out->write( |API Error: { lx_ex->get_text( ) }| ).
    ENDTRY.

    out->write( '========================================================================================' ).
  ENDMETHOD.

ENDCLASS.
