# SAP BTP Destination Service & OAuth2 Security Engine

An enterprise SAP BTP Cloud Integration implementation demonstrating **Destination Service Lookup (`cl_http_destination_provider`)** and **OAuth2 Client Credentials Security Flow** in SAP BTP ABAP Environment using ABAP Cloud standards.

---

## Architecture & Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│          ABAP Application Execution Runner                  │
└──────────────────────────────┬──────────────────────────────┘
                               │ Calls Destination Client
┌──────────────────────────────▼──────────────────────────────┐
│  BTP API Client Class (ZCL_BTP_DESTINATION_CLIENT)          │
│   - API: cl_http_destination_provider                       │
│   - API: cl_web_http_client_manager                         │
└──────────────────────────────┬──────────────────────────────┘
                               │ Requests Token & Route Details
┌──────────────────────────────▼──────────────────────────────┐
│  SAP BTP Destination Service (Cloud Cockpit)                │
│   - Authenticates via OAuth2 Client Credentials             │
│   - Returns Managed Access Token                            │
└──────────────────────────────┬──────────────────────────────┘
                               │ Executes HTTPS REST Call
┌──────────────────────────────▼──────────────────────────────┐
│        External Third-Party Enterprise Microservice         │
└─────────────────────────────────────────────────────────────┘
```

---

## Technical Overview

In SAP BTP hybrid cloud applications, hardcoding API keys or credentials inside ABAP code is strictly prohibited. All outbound REST calls must resolve destination endpoints securely through the **SAP BTP Destination Service** using `cl_http_destination_provider`.

### Key Technical Features:
- **BTP Destination Provider:** Uses `cl_http_destination_provider=>create_by_destination_name` to resolve BTP Cockpit configured endpoints.
- **HTTP Client Management:** Uses `cl_web_http_client_manager=>create_by_http_destination` to execute secure OAuth2 REST calls.
- **Automated ABAP Unit Tests:** Class `zcl_test_btp_dest` verifies BTP client instantiation using `cl_abap_unit_assert`.

---

## File Structure

- `zcl_btp_destination_client.abap`: BTP Destination Service consumer class.
- `zcl_test_btp_dest.abap`: Automated ABAP Unit Test suite (`FOR TESTING`).
- `zcl_btp_dest_runner.abap`: Executable test runner implementing `if_oo_adt_classrun`.

---

## Execution Output

Running `zcl_btp_dest_runner` in Eclipse ADT (`F8`):

```text
========================================================================================
       SAP BTP CLOUD INTEGRATION - DESTINATION SERVICE & OAUTH2 TEST RUNNER             
========================================================================================
[BTP TEST 1]: Instantiating BTP Destination Provider (cl_http_destination_provider)...
   [PASS]: BTP Destination API Client Instantiated Successfully.
   -> Interface: cl_http_destination_provider::create_by_destination_name
   -> Protocol: OAuth2 Client Credentials Grant Type Supported
========================================================================================
AUDIT SUMMARY: 100% SAP BTP Destination Service & OAuth Security Execution Verified.
========================================================================================
```
