-- =====================================================
-- SUPPLY CHAIN ANALYTICS: PHASE 2 SQL SCRIPT
-- Dataset: fact_supply_chain
-- =====================================================

-- QUERY 1: Delivery Status Analysis
SELECT 
    delivery_status,
    COUNT(order_id) AS total_orders,
    ROUND(COUNT(order_id) * 100.0 / SUM(COUNT(order_id)) OVER (), 2) AS percentage
FROM fact_supply_chain
GROUP BY delivery_status
ORDER BY total_orders DESC;


-- QUERY 2: Shipping Mode Delay Analysis
SELECT 
    shipping_mode,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(days_for_shipping_real), 2) AS avg_actual_shipping_days,
    ROUND(AVG(days_for_shipment_scheduled), 2) AS avg_scheduled_shipping_days,
    ROUND(AVG(days_for_shipping_real - days_for_shipment_scheduled), 2) AS avg_delay_days
FROM fact_supply_chain
GROUP BY shipping_mode
ORDER BY avg_delay_days DESC;


-- QUERY 3: High-Risk Regional Markets (>500 Orders)
SELECT 
    market,
    order_region,
    COUNT(order_id) AS total_orders,
    SUM(late_delivery_risk) AS total_late_orders,
    ROUND(SUM(late_delivery_risk) * 100.0 / COUNT(order_id), 2) AS late_delivery_rate_pct
FROM fact_supply_chain
GROUP BY market, order_region
HAVING COUNT(order_id) > 500
ORDER BY late_delivery_rate_pct DESC
LIMIT 10;


-- QUERY 4: Revenue at Risk by Product Category (Top 10)
WITH category_performance AS (
    SELECT 
        category_name,
        SUM(sales) AS total_revenue,
        SUM(CASE WHEN late_delivery_risk = 1 THEN sales ELSE 0 END) AS revenue_at_risk,
        DENSE_RANK() OVER (ORDER BY SUM(sales) DESC) AS revenue_rank
    FROM fact_supply_chain
    GROUP BY category_name
)
SELECT 
    revenue_rank,
    category_name,
    ROUND(total_revenue::numeric, 2) AS total_revenue,
    ROUND(revenue_at_risk::numeric, 2) AS revenue_at_risk,
    ROUND((revenue_at_risk * 100.0 / total_revenue)::numeric, 2) AS risk_percentage
FROM category_performance
WHERE revenue_rank <= 10;