CLASS zcl_hr_bonus_calc DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    TYPES: BEGIN OF ty_employee,
             emp_id         TYPE string,
             emp_name       TYPE string,
             emp_rating     TYPE string,     " A, B, C
             emp_basesalary TYPE decfloat34,
             emp_experience TYPE i,

             " Output Fields
             bonus_pct      TYPE decfloat34,
             bonus_amount   TYPE decfloat34,
           END OF ty_employee,
           tt_employee_list TYPE STANDARD TABLE OF ty_employee WITH EMPTY KEY.

    METHODS constructor.
    METHODS create_emp
      IMPORTING
        emp_id         TYPE string
        emp_name       TYPE string
        emp_rating     TYPE string
        emp_basesalary TYPE decfloat34
        emp_experience TYPE i
      RETURNING
        VALUE(rs_emp)  TYPE ty_employee.

    METHODS process_bonus
      CHANGING
        cs_emp TYPE ty_employee.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mv_system_status TYPE string.
ENDCLASS.

CLASS zcl_hr_bonus_calc IMPLEMENTATION.

  METHOD constructor.
    me->mv_system_status = 'ENGINE_READY'.
  ENDMETHOD.

  METHOD create_emp.
    rs_emp = VALUE #(
      emp_id         = emp_id
      emp_name       = emp_name
      emp_experience = emp_experience
      emp_basesalary = emp_basesalary
      emp_rating     = emp_rating
    ).
  ENDMETHOD.

  METHOD process_bonus.
    IF cs_emp-emp_rating = 'A'.
      IF cs_emp-emp_experience >= 5.
        cs_emp-bonus_pct = 30.
      ELSE.
        cs_emp-bonus_pct = 20.
      ENDIF.

    ELSEIF cs_emp-emp_rating = 'B'.
      cs_emp-bonus_pct = 10.

    ELSEIF cs_emp-emp_rating = 'C'.
      cs_emp-bonus_pct = 0.
    ENDIF.

    cs_emp-bonus_amount = cs_emp-emp_basesalary * ( cs_emp-bonus_pct / 100 ).
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.

    DATA(lo_hr_engine) = NEW zcl_hr_bonus_calc( ).

    DATA(lt_employees) = VALUE tt_employee_list(
      ( lo_hr_engine->create_emp( emp_id = 'EMP01' emp_name = 'Amit Kumar'   emp_rating = 'A' emp_basesalary = 50000 emp_experience = 6 ) )
      ( lo_hr_engine->create_emp( emp_id = 'EMP02' emp_name = 'Riya Sharma'  emp_rating = 'A' emp_basesalary = 60000 emp_experience = 2 ) )
      ( lo_hr_engine->create_emp( emp_id = 'EMP03' emp_name = 'Rahul Verma'  emp_rating = 'B' emp_basesalary = 45000 emp_experience = 4 ) )
      ( lo_hr_engine->create_emp( emp_id = 'EMP04' emp_name = 'Neha Gupta'   emp_rating = 'C' emp_basesalary = 40000 emp_experience = 3 ) )
    ).

    out->write( '========================================================================================' ).
    out->write( '                       HR BONUS CALCULATION ENGINE                           ' ).
    out->write( '========================================================================================' ).

    LOOP AT lt_employees REFERENCE INTO DATA(lr_emp).

      lo_hr_engine->process_bonus( CHANGING cs_emp = lr_emp->* ).

      out->write( |ID: { lr_emp->emp_id } | &
                  |Name: { lr_emp->emp_name WIDTH = 15 } | &
                  |Rating: { lr_emp->emp_rating } | &
                  |Salary: ₹{ lr_emp->emp_basesalary } | &
                  |Bonus: { lr_emp->bonus_pct }% | &
                  |Bonus Amt: ₹{ lr_emp->bonus_amount }| ).

    ENDLOOP.

    out->write( '========================================================================================' ).

  ENDMETHOD.

ENDCLASS.
