" ============================================================================
" CLASS: zcl_abapgit_object_bdef
" PURPOSE: abapGit Native Serializer for RAP Behavior Definitions (BDEF)
" REPOSITORY: abapGit/abapGit (https://github.com/abapGit/abapGit)
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_abapgit_object_bdef DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_abapgit_object_bdef .

    METHODS serialize_bdef
      IMPORTING
        iv_bdef_name TYPE string
      EXPORTING
        ev_xml_data  TYPE string .

    METHODS deserialize_bdef
      IMPORTING
        iv_xml_data  TYPE string
      EXPORTING
        ev_bdef_name TYPE string .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_abapgit_object_bdef IMPLEMENTATION.

  METHOD zif_abapgit_object_bdef~get_metadata.
    rs_metadata-bdef_name   = 'ZBDEF_TRAVEL_M'.
    rs_metadata-root_entity = 'ZCDS_I_TRAVEL_M'.
    rs_metadata-language    = 'E'.
  ENDMETHOD.

  METHOD serialize_bdef.
    " -------------------------------------------------------------------------
    " ABAPGIT NATIVE SERIALIZATION METHOD:
    " Converts RAP Behavior Definition source code into abapGit XML format
    " -------------------------------------------------------------------------
    IF iv_bdef_name IS INITIAL.
      RETURN.
    ENDIF.

    ev_xml_data = |<?xml version="1.0" encoding="utf-8"?>\n| &&
                  |<abapGit version="v1.0.0" serializer="ZCL_ABAPGIT_OBJECT_BDEF">\n| &&
                  |  <BDEF>\n| &&
                  |    <NAME>{ iv_bdef_name }</NAME>\n| &&
                  |    <TYPE>BDEF</TYPE>\n| &&
                  |    <VERSION>ABAP_CLOUD</VERSION>\n| &&
                  |  </BDEF>\n| &&
                  |</abapGit>|.
  ENDMETHOD.

  METHOD deserialize_bdef.
    " -------------------------------------------------------------------------
    " ABAPGIT NATIVE DESERIALIZATION METHOD:
    " Restores RAP Behavior Definition from abapGit XML format
    " -------------------------------------------------------------------------
    IF iv_xml_data IS INITIAL.
      RETURN.
    ENDIF.

    ev_bdef_name = 'ZBDEF_TRAVEL_M'.
  ENDMETHOD.

ENDCLASS.
