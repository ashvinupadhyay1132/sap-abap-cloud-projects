# 🌐 SAP BTP Cloud REST API Integration (`sap-btp-http-rest-integration`)

Production-grade integration module for consuming third-party HTTP REST/JSON APIs in **SAP BTP ABAP Cloud Environment**.

---

## 📌 Business Requirement (Functional Spec)
- **Domain:** Enterprise Cloud Integration & Financial Exchange Rates
- **Problem Statement:** A multi-national company operating on SAP BTP needs real-time foreign currency exchange rates (e.g. USD to INR) for currency conversions during cross-border sales order billing. The solution must connect to external Cloud HTTPS REST endpoints, set proper HTTP Headers (`Accept: application/json`), execute GET requests safely, process HTTP 200 responses, parse JSON payloads into ABAP Cloud structures, and handle HTTP connection errors via `cx_web_http_client_error`.

---

## 📥 Inputs & 📤 Outputs

### Inputs:
- `iv_base` (Base Currency Code, e.g., `'USD'`)
- `iv_target` (Target Currency Code, e.g., `'INR'`)

### Outputs:
- **`exchange_rate`**: Decimal exchange rate (e.g., `83.45`)
- **`updated_at`**: System Date timestamp
- **`status`**: HTTP Response Code & Connection Status (`200 OK`)

---

## 📄 Component Manifest

| File Name | Object Type | Business Purpose |
| :--- | :--- | :--- |
| [`zcl_api_consumer.abap`](./zcl_api_consumer.abap) | ABAP Cloud Integration Class | HTTP Client implementation using `cl_web_http_client_manager` & `cl_http_destination_provider`. |

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
