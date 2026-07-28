CLASS zcl_open_sql DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

    TYPES: BEGIN OF ty_travel_detail,
             travel_id     TYPE /dmo/travel_id,
             agency_id     TYPE /dmo/agency_id,
             customer_id   TYPE /dmo/customer_id,
             booking_fee   TYPE /dmo/booking_fee,
             total_price   TYPE /dmo/total_price,
             currency_code TYPE /dmo/currency_code,
             customer_name TYPE string,
           END OF ty_travel_detail,
           tt_travel_detail TYPE STANDARD TABLE OF ty_travel_detail WITH EMPTY KEY.

    TYPES: BEGIN OF ty_agency_summary,
             agency_id    TYPE /dmo/agency_id,
             travel_count TYPE i,
             avg_price    TYPE /dmo/total_price,
             max_price    TYPE /dmo/total_price,
             min_price    TYPE /dmo/total_price,
           END OF ty_agency_summary,
           tt_agency_summary TYPE STANDARD TABLE OF ty_agency_summary WITH EMPTY KEY.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_open_sql IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    out->write( '========================================================================================' ).
    out->write( '          SAP BTP CLOUD - OPEN SQL DEMONSTRATION REPORT (MAPPED FOR BTP TRIAL)         ' ).
    out->write( '========================================================================================' ).

    DATA(p_agency_id)   = '070001'.
    DATA(p_currency)    = 'EUR'.

    IF p_agency_id IS INITIAL OR p_currency IS INITIAL.
      out->write( 'ERROR: Please enter both Agency ID and Currency.' ).
      RETURN.
    ENDIF.

    SELECT SINGLE agency_id, name, city
      FROM /dmo/agency
      WHERE agency_id = @p_agency_id
      INTO @DATA(ls_agency_check).

    IF sy-subrc <> 0.
      out->write( |ERROR: Agency ID { p_agency_id } does not exist in BTP Master Data.| ).
      RETURN.
    ELSE.
      out->write( |[VALIDATION OK]: Found Agency { ls_agency_check-name } in City: { ls_agency_check-city }| ).
    ENDIF.

    SELECT COUNT( * )
      FROM /dmo/travel AS a
      INNER JOIN /dmo/booking AS b ON a~travel_id = b~travel_id
      WHERE a~agency_id = @p_agency_id AND a~currency_code = @p_currency
      INTO @DATA(gv_count).

    IF gv_count = 0.
      out->write( |No travel records found for Agency: { p_agency_id } and Currency: { p_currency }| ).
      RETURN.
    ELSE.
      out->write( |[COUNT RESULT]: Found { gv_count } matching travel records.| ).
    ENDIF.

    SELECT a~travel_id,
           a~agency_id,
           a~customer_id,
           a~booking_fee,
           a~total_price,
           a~currency_code,
           c~first_name && ' ' && c~last_name AS customer_name
      FROM /dmo/travel AS a
      INNER JOIN /dmo/booking AS b ON a~travel_id = b~travel_id
      LEFT OUTER JOIN /dmo/customer AS c ON a~customer_id = c~customer_id
      WHERE a~agency_id = @p_agency_id AND a~currency_code = @p_currency
      ORDER BY a~travel_id ASCENDING
      INTO TABLE @DATA(lt_travel_details).

    out->write( '----------------------------------------------------------------------------------------' ).
    out->write( '                         DETAIL REPORT (JOINS & SELECTION)                              ' ).
    out->write( '----------------------------------------------------------------------------------------' ).

    LOOP AT lt_travel_details INTO DATA(ls_detail).
      out->write( |Travel ID    : { ls_detail-travel_id WIDTH = 10 } | &
                  |Customer ID  : { ls_detail-customer_id WIDTH = 8 } | &
                  |Customer Name: { ls_detail-customer_name WIDTH = 20 } | &
                  |Price        : { ls_detail-total_price ALIGN = RIGHT WIDTH = 8 } { ls_detail-currency_code }| ).
    ENDLOOP.

    SELECT a~agency_id,
           COUNT( * ) AS travel_count,
           AVG( a~total_price ) AS avg_price,
           MAX( a~total_price ) AS max_price,
           MIN( a~total_price ) AS min_price
      FROM /dmo/travel AS a
      WHERE a~currency_code = @p_currency
      GROUP BY a~agency_id
      HAVING COUNT( * ) > 0
      ORDER BY COUNT( * ) DESCENDING
      INTO TABLE @DATA(lt_summary).

    out->write( '----------------------------------------------------------------------------------------' ).
    out->write( '                 SUMMARY REPORT (GROUP BY, COUNT, AVG, MAX, MIN, HAVING)               ' ).
    out->write( '----------------------------------------------------------------------------------------' ).

    LOOP AT lt_summary INTO DATA(ls_sum).
      out->write( |Agency ID    : { ls_sum-agency_id WIDTH = 8 } | &
                  |Travel Count : { ls_sum-travel_count WIDTH = 4 } | &
                  |Avg Price    : { ls_sum-avg_price ALIGN = RIGHT WIDTH = 10 } { p_currency } | &
                  |Max Price    : { ls_sum-max_price ALIGN = RIGHT WIDTH = 10 } { p_currency } | &
                  |Min Price    : { ls_sum-min_price ALIGN = RIGHT WIDTH = 10 } { p_currency }| ).
    ENDLOOP.

    SELECT DISTINCT currency_code
      FROM /dmo/travel
      ORDER BY currency_code ASCENDING
      INTO TABLE @DATA(lt_currencies).

    out->write( '----------------------------------------------------------------------------------------' ).
    out->write( '                 SELECT DISTINCT EXAMPLE (UNIQUE CURRENCIES IN BTP)                    ' ).
    out->write( '----------------------------------------------------------------------------------------' ).

    LOOP AT lt_currencies INTO DATA(ls_curr).
      out->write( |Currency Code: { ls_curr-currency_code }| ).
    ENDLOOP.

    out->write( '========================================================================================' ).

  ENDMETHOD.

ENDCLASS.
