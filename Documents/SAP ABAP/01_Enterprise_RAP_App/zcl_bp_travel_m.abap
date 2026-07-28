CLASS zcl_bp_travel_m DEFINITION
  PUBLIC
  ABSTRACT
  FINAL
  FOR BEHAVIOR OF zcds_i_travel_m.

  PUBLIC SECTION.
    TYPES: tt_travel_id TYPE TABLE OF /dmo/travel_id.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_bp_travel_m IMPLEMENTATION.
ENDCLASS.

CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS acceptTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~acceptTravel RESULT result.

    METHODS rejectTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~rejectTravel RESULT result.

    METHODS validateCustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateCustomer.

    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateDates.

    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Travel~calculateTotalPrice.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_authorizations.
    LOOP AT keys INTO DATA(ls_key).
      APPEND VALUE #( %tky = ls_key-%tky
                      %action-acceptTravel = if_abap_behv=>auth-allowed
                      %action-rejectTravel = if_abap_behv=>auth-allowed ) TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD acceptTravel.
    MODIFY ENTITIES OF zcds_i_travel_m IN LOCAL MODE
      ENTITY Travel
        UPDATE FIELDS ( Overall_Status )
        WITH VALUE #( FOR key IN keys ( %tky           = key-%tky
                                        Overall_Status = 'A' ) )
      FAILED failed
      REPORTED reported.

    READ ENTITIES OF zcds_i_travel_m IN LOCAL MODE
      ENTITY Travel
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_travels).

    result = VALUE #( FOR travel IN lt_travels ( %tky   = travel-%tky
                                                %param = travel ) ).
  ENDMETHOD.

  METHOD rejectTravel.
    MODIFY ENTITIES OF zcds_i_travel_m IN LOCAL MODE
      ENTITY Travel
        UPDATE FIELDS ( Overall_Status )
        WITH VALUE #( FOR key IN keys ( %tky           = key-%tky
                                        Overall_Status = 'X' ) )
      FAILED failed
      REPORTED reported.

    READ ENTITIES OF zcds_i_travel_m IN LOCAL MODE
      ENTITY Travel
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_travels).

    result = VALUE #( FOR travel IN lt_travels ( %tky   = travel-%tky
                                                %param = travel ) ).
  ENDMETHOD.

  METHOD validateCustomer.
    READ ENTITIES OF zcds_i_travel_m IN LOCAL MODE
      ENTITY Travel
        FIELDS ( Customer_ID ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_travels).

    LOOP AT lt_travels INTO DATA(ls_travel).
      IF ls_travel-Customer_ID IS INITIAL.
        APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-travel.
        APPEND VALUE #( %tky                 = ls_travel-%tky
                        %msg                  = new_message_with_text(
                                                  severity = if_abap_behv_message=>severity-error
                                                  text     = 'Customer ID is mandatory for Travel Request' )
                        %element-Customer_ID  = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateDates.
    READ ENTITIES OF zcds_i_travel_m IN LOCAL MODE
      ENTITY Travel
        FIELDS ( Begin_Date End_Date ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_travels).

    LOOP AT lt_travels INTO DATA(ls_travel).
      IF ls_travel-End_Date < ls_travel-Begin_Date.
        APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-travel.
        APPEND VALUE #( %tky                = ls_travel-%tky
                        %msg                 = new_message_with_text(
                                                 severity = if_abap_behv_message=>severity-error
                                                 text     = 'End Date cannot be before Begin Date' )
                        %element-End_Date    = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD calculateTotalPrice.
    READ ENTITIES OF zcds_i_travel_m IN LOCAL MODE
      ENTITY Travel
        FIELDS ( Booking_Fee Total_Price ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_travels).

    LOOP AT lt_travels INTO DATA(ls_travel).
      DATA(lv_calculated_total) = ls_travel-Booking_Fee + 500.

      MODIFY ENTITIES OF zcds_i_travel_m IN LOCAL MODE
        ENTITY Travel
          UPDATE FIELDS ( Total_Price )
          WITH VALUE #( ( %tky        = ls_travel-%tky
                          Total_Price = lv_calculated_total ) ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
