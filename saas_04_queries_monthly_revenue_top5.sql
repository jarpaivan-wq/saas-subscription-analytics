-- ============================================================
-- QUERY 13: Top 5 Subscriptions by Monthly Revenue
-- ============================================================
-- Database: saas_plataforma
-- Author: Ivan Jarpa
-- Date: February 2026
-- Complexity Level: ⭐⭐⭐⭐ Advanced
-- ============================================================

-- BUSINESS QUESTION:
-- Which subscriptions generate the highest monthly revenue?
-- Calculate average monthly income (total paid ÷ active months)
-- and show top 5 with global ranking.

-- KEY CONCEPTS:
-- ✓ TIMESTAMPDIFF for date calculations
-- ✓ COALESCE for NULL handling (active subscriptions)
-- ✓ NULLIF for division by zero protection
-- ✓ CTE pattern for filtering window functions
-- ✓ DENSE_RANK for ranking with ties

-- ============================================================
-- SOLUTION
-- ============================================================

USE saas_plataforma;

WITH tab_meses_act AS (
    -- CTE1: Calculate active months per subscription
    SELECT
        suscripcion_id,
        TIMESTAMPDIFF(
            MONTH,
            fecha_inicio,
            COALESCE(fecha_fin, CURDATE())
        ) AS meses_activos
    FROM suscripciones
),
tab_pago_sus AS (
    -- CTE2: Calculate total payments per subscription
    SELECT
        suscripcion_id,
        SUM(monto) AS monto_pago
    FROM pagos
    GROUP BY suscripcion_id
),
tab_con_ranking AS (
    -- CTE3: Calculate monthly revenue and ranking
    SELECT
        usu.nombre AS nombre_usuario,
        pla.nombre_plan,
        cte1.meses_activos,
        cte2.monto_pago,
        cte2.monto_pago / NULLIF(cte1.meses_activos, 0) AS ingreso_mensual,
        DENSE_RANK() OVER(
            ORDER BY cte2.monto_pago / NULLIF(cte1.meses_activos, 0) DESC
        ) AS ranking_general
    FROM usuarios usu
    INNER JOIN suscripciones sus
        ON usu.usuario_id = sus.usuario_id
    INNER JOIN planes pla
        ON sus.plan_id = pla.plan_id
    INNER JOIN tab_meses_act cte1
        ON sus.suscripcion_id = cte1.suscripcion_id
    INNER JOIN tab_pago_sus cte2
        ON cte1.suscripcion_id = cte2.suscripcion_id
)
-- Final query: Filter top 5 subscriptions
SELECT *
FROM tab_con_ranking
WHERE ranking_general <= 5
ORDER BY ranking_general ASC;

-- ============================================================
-- EXPECTED OUTPUT COLUMNS:
-- ============================================================
-- nombre_usuario: Subscriber name
-- nombre_plan: Plan name
-- meses_activos: Months subscription has been active
-- monto_pago: Total amount paid
-- ingreso_mensual: Average monthly revenue (total ÷ months)
-- ranking_general: Global ranking (1 = highest monthly revenue)

-- ============================================================
-- BUSINESS VALUE:
-- ============================================================
-- Identifies most valuable subscriptions normalized by duration:
-- - Highlights high-value customers
-- - Accounts for subscription length
-- - Useful for customer success prioritization
-- - Helps identify upsell opportunities
-- - Supports LTV (Lifetime Value) analysis

-- ============================================================
-- TECHNICAL NOTES:
-- ============================================================
-- COALESCE(fecha_fin, CURDATE()): Handles active subscriptions
--   (fecha_fin = NULL) by using current date
-- NULLIF(meses_activos, 0): Prevents division by zero errors
-- CTE pattern: Window function in CTE3, filter in final SELECT
--   (cannot filter window functions in same level WHERE clause)
