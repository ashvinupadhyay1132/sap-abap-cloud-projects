" ============================================================================
" CLASS: zcl_btp_destination_client
" PURPOSE: BTP Destination Service Consumer for OAuth2 Client Credentials Security
" PATTERN: Cloud Integration via cl_http_destination_provider
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_btp_destination_client DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_api_response,
             status_code TYPE i,
             reason      TYPE string,
             json_body   TYPE string,
           END OF ty_api_response.

    METHODS consume_authenticated_api
      IMPORTING
        iv_destination_name TYPE string
      EXPORTING
        es_response         TYPE ty_api_response
      RAISING
        cx_static_check.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_btp_destination_client IMPLEMENTATION.

  METHOD consume_authenticated_api.
    " -------------------------------------------------------------------------
    " BTP DESTINATION SERVICE CONSUMPTION:
    " Resolves BTP Destination & executes OAuth2 authenticated HTTP request
    " -------------------------------------------------------------------------
    DATA(lo_destination) = cl_http_destination_provider=>create_by_destination_name(
                             i_name = CONV #( iv_destination_name )
                           ).

    DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination(
                             i_destination = lo_destination
                           ).

    DATA(lo_request) = lo_http_client->get_http_request( ).
    lo_request->set_header_field( i_name = 'Accept' i_value = 'application/json' ).

    DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>get ).

    es_response-status_code = lo_response->get_status( )-code.
    es_response-reason      = lo_response->get_status( )-reason.
    es_response-json_body   = lo_response->get_text( ).

    lo_http_client->close( ).
  ENDMETHOD.

ENDCLASS.
