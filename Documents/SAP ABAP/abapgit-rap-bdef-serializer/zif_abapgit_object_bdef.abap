" ============================================================================
" INTERFACE: zif_abapgit_object_bdef
" PURPOSE: abapGit Serializer Interface for RAP Behavior Definitions (BDEF)
" REPOSITORY: abapGit/abapGit (https://github.com/abapGit/abapGit)
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
INTERFACE zif_abapgit_object_bdef
  PUBLIC .

  TYPES:
    BEGIN OF ty_bdef_metadata,
      bdef_name TYPE c LENGTH 30,
      root_entity TYPE c LENGTH 30,
      language  TYPE c LENGTH 2,
    END OF ty_bdef_metadata .

  METHODS get_metadata
    RETURNING
      VALUE(rs_metadata) TYPE ty_bdef_metadata .

ENDINTERFACE.
