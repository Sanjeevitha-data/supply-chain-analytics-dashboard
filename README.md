# 🚚 End-to-End Supply Chain Risk & Performance Analytics Dashboard

## 📌 Executive Summary
This end-to-end data analytics project analyzes ~180k supply chain records to isolate delivery bottlenecks, carrier SLA failures, and financial risk across global operations. By standardizing raw operational metrics into a 3-page interactive Power BI report, this dashboard provides operational leaders with actionable insights to mitigate late delivery exposure.

* **Total Orders Analyzed:** 180.5K
* **Total Revenue:** $36.79M
* **Baseline Late Delivery Rate:** 54.83%
* **Revenue at Risk:** $20.13M

---

## 🛠️ Data Architecture & Pipeline
1. **Python (Data Preprocessing & Cleaning):** Handled missing values, formatted timestamps, eliminated duplicate records, and generated target validation standard `cleaned_supply_chain.csv`.
2. **PostgreSQL (Database Operations & KPI Validation):** Engineered SQL analytical queries to cross-verify baseline totals (Revenue, Order volume, Delay counts).
3. **Power BI (Data Modeling & Star Schema Design):** 
   * Configured **Import Mode** for optimal query performance.
   * Built a explicit `Dim_Date` dimension table with 1-to-Many single-direction relationships to the core fact table.
   * Engineered dynamic DAX measures for financial and operational metrics.

---

## 📊 Core DAX KPIs
```dax
Total Revenue = SUM(cleaned_supply_chain[sales])

Total Orders = DISTINCTCOUNT(cleaned_supply_chain[order_id])

Late Delivery Rate % = 
DIVIDE(
    CALCULATE(COUNT(cleaned_supply_chain[order_id]), cleaned_supply_chain[late_delivery_risk] = 1),
    [Total Orders],
    0
)

Revenue at Risk = 
CALCULATE(
    [Total Revenue],
    cleaned_supply_chain[late_delivery_risk] = 1
)

Avg Delay Days = AVERAGE(cleaned_supply_chain[days_for_shipping_real]) - AVERAGE(cleaned_supply_chain[days_for_shipment_scheduled])
