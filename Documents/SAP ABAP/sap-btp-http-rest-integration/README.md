# SAP BTP Cloud REST API Integration

Implements external HTTP API consumption in SAP BTP ABAP Cloud Environment.

---

## Technical Overview

Demonstrates how to connect to third-party REST/JSON API endpoints from ABAP Cloud without using legacy function modules.

### Key Features:
- **HTTP Destination & Client:** Instantiates clients using `cl_http_destination_provider` and `cl_web_http_client_manager`.
- **Request Headers:** Sets HTTP headers (`Accept: application/json`).
- **Response Status Handling:** Validates HTTP status code (`200 OK`) and handles exceptions via `cx_web_http_client_error`.
- **Data Mapping:** Parses JSON response data into ABAP structures.

---

## File Structure

- `zcl_api_consumer.abap`: HTTP API consumer class implementing `if_oo_adt_classrun`.

---

## Execution Output

Running `zcl_api_consumer` in Eclipse ADT (`F8`):

```text
========================================================================================
                   ENTERPRISE CLOUD REST API CONSUMER (HTTP CLIENT)                     
========================================================================================
Base Currency   : USD
Target Currency : INR
Exchange Rate   : 1 USD = 83.45 INR
Last Updated    : 28.07.2026
Status          : 200 OK (Connection Successful)
========================================================================================
```
