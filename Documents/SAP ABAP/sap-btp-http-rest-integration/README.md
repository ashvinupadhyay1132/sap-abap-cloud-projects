# SAP BTP Cloud REST API Integration

Implements external HTTP API consumption in SAP BTP ABAP Cloud Environment.

---

## Architecture & Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                 ABAP Application Layer                      │
│      ZCL_API_CONSUMER / Unit Test ZCL_TEST_API_CONSUMER     │
└──────────────────────────────┬──────────────────────────────┘
                               │ HTTPS GET Request
┌──────────────────────────────▼──────────────────────────────┐
│                BTP Cloud Connectivity Layer                 │
│      cl_http_destination_provider => cl_web_http_client     │
└──────────────────────────────┬──────────────────────────────┘
                               │ Outbound HTTP Call
┌──────────────────────────────▼──────────────────────────────┐
│              External Third-Party REST API Endpoint          │
│            https://api.exchangerate-api.com/v4/...          │
└─────────────────────────────────────────────────────────────┘
```

---

## Technical Overview

Demonstrates how to connect to third-party REST/JSON API endpoints from ABAP Cloud without using legacy function modules.

### Key Features:
- **HTTP Destination & Client:** Instantiates clients using `cl_http_destination_provider` and `cl_web_http_client_manager`.
- **Request Headers:** Sets HTTP headers (`Accept: application/json`).
- **Response Status Handling:** Validates HTTP status code (`200 OK`) and handles exceptions via `cx_web_http_client_error`.
- **Automated ABAP Unit Tests:** Class `zcl_test_api_consumer` verifies API exchange rate fetching.

---

## File Structure

- `zcl_api_consumer.abap`: HTTP API consumer class implementing `if_oo_adt_classrun`.
- `zcl_test_api_consumer.abap`: Automated ABAP Unit Test suite (`FOR TESTING`).

---

## How to Answer in MNC Technical Interviews

### Q1: How do we consume external REST APIs in ABAP Cloud / BTP without legacy HTTP function modules?
**Senior Answer:** In ABAP Cloud, legacy classes like `CL_HTTP_CLIENT` are released with restrictions. We use `cl_http_destination_provider=>create_by_url()` or `create_by_destination_service()` to obtain an HTTP destination instance, and then pass it to `cl_web_http_client_manager=>create_by_http_destination()` to execute `GET`, `POST`, or `PUT` requests asynchronously or synchronously.

### Q2: How do you handle HTTP client exceptions in production ABAP Cloud code?
**Senior Answer:** We wrap the HTTP execution in a `TRY...CATCH` block catching `cx_web_http_client_error` and generic `cx_root`. Always ensure `lo_http_client->close()` is executed to prevent open socket leaks on the SAP BTP application server.

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
