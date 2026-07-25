# 🌐 SAP BTP Cloud REST / JSON HTTP API Integration

This folder contains enterprise integration classes demonstrating third-party HTTP REST/JSON API consumption in **SAP BTP ABAP Cloud Environment**.

---

## 🛠️ Integration Concepts Covered

- **HTTP Client Manager**: `cl_web_http_client_manager` & `cl_http_destination_provider`.
- **HTTP Request Building**: Header parameters (`Accept: application/json`), HTTP GET method.
- **Status & Exception Handling**: Processing HTTP 200 OK responses, catching `cx_web_http_client_error`.
- **Data Parsing**: Extracting JSON payloads into ABAP Cloud structures.

---

## 📄 File Manifest

| File Name | Description |
| :--- | :--- |
| [`zcl_api_consumer.abap`](./zcl_api_consumer.abap) | Enterprise Cloud REST API Consumer Class fetching live exchange rates. |

---

## 🖥️ Execution Output Log

```text
========================================================================================
                   ENTERPRISE CLOUD REST API CONSUMER (HTTP CLIENT)                     
========================================================================================
Base Currency   : USD
Target Currency : INR
Exchange Rate   : 1 USD = 83.45 INR
Last Updated    : 25.07.2026
Status          : 200 OK (Connection Successful)
========================================================================================
```
