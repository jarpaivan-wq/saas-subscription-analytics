-- ================================================
-- SAAS SUBSCRIPTION ANALYTICS - BUSINESS QUERIES
-- ================================================
-- Author: SQL Portfolio Project
-- Business: CloudMetrics Pro - Data Analytics Platform
-- Description: Analytical queries for SaaS subscription insights
-- ================================================

USE saas_analytics;

-- ================================================
-- QUERY #1: Monthly Recurring Revenue (MRR) by Plan
-- ================================================
-- Business Question: How much revenue is each plan generating monthly?
-- Purpose: Track revenue trends and plan marketing budget allocation
-- Period: Last 6 months of 2024 (April - September)
-- ================================================

SELECT
    DATE_FORMAT(p.fecha_pago, '%Y-%m') AS `mes/año`,
    pl.nombre_plan,
    SUM(p.monto) AS MRR_total
FROM pagos p
INNER JOIN suscripciones s
    ON p.suscripcion_id = s.suscripcion_id
INNER JOIN planes pl
    ON s.plan_id = pl.plan_id
WHERE p.estado_pago = 'completado'
    AND YEAR(p.fecha_pago) = 2024
    AND MONTH(p.fecha_pago) >= 4
GROUP BY DATE_FORMAT(p.fecha_pago, '%Y-%m'), pl.nombre_plan
ORDER BY `mes/año` ASC;

-- ================================================
-- QUERY #2: Monthly Subscription Cancellations
-- ================================================
-- Business Question: How many subscriptions are cancelled each month?
-- Purpose: Identify cancellation trends and plan retention campaigns
-- Period: 2024 from April onwards
-- ================================================

SELECT
    DATE_FORMAT(fecha_cancelacion, '%Y-%m') AS `mes/año`,
    COUNT(*) AS total_cancelaciones,
    COUNT(DISTINCT usuario_id) AS usuarios_unicos_cancelados
FROM suscripciones
WHERE estado = 'cancelada'
    AND YEAR(fecha_cancelacion) = 2024
    AND MONTH(fecha_cancelacion) >= 4
GROUP BY DATE_FORMAT(fecha_cancelacion, '%Y-%m')
ORDER BY `mes/año` ASC;

-- ================================================
-- QUERY #3: Most Used Features by Plan
-- ================================================
-- Business Question: Which features are most popular per subscription plan?
-- Purpose: Guide product development and feature promotion strategy
-- ================================================

SELECT
    pl.nombre_plan,
    f.nombre_feature,
    SUM(uf.cantidad_usos) AS total_usos
FROM planes pl
INNER JOIN suscripciones s
    ON pl.plan_id = s.plan_id
INNER JOIN usuarios u
    ON s.usuario_id = u.usuario_id
INNER JOIN uso_features uf
    ON u.usuario_id = uf.usuario_id
INNER JOIN features f
    ON uf.feature_id = f.feature_id
WHERE s.estado = 'activa'
GROUP BY pl.nombre_plan, f.nombre_feature
ORDER BY pl.nombre_plan ASC, total_usos DESC;

-- ================================================
-- QUERY #4: Customer Lifetime Value (CLV) by Plan
-- ================================================
-- Business Question: What is the average revenue and duration per customer by plan?
-- Purpose: Understand long-term value of each subscription tier
-- Logic: Only completed subscription cycles (cancelled or expired)
-- ================================================

WITH resumen_usuario AS (
    SELECT
        s.usuario_id,
        s.plan_id,
        ABS(TIMESTAMPDIFF(MONTH,
            MIN(s.fecha_inicio),
            MAX(s.fecha_fin))) AS meses_suscrito,
        SUM(p.monto) AS revenue_total
    FROM suscripciones s
    INNER JOIN pagos p
        ON s.suscripcion_id = p.suscripcion_id
    WHERE s.estado IN ('cancelada', 'vencida')
    GROUP BY s.usuario_id, s.plan_id
)
SELECT
    pl.nombre_plan,
    ROUND(AVG(ru.meses_suscrito), 1) AS prom_meses_suscrito,
    ROUND(AVG(ru.revenue_total), 2) AS revenue_prom_por_usuario
FROM planes pl
INNER JOIN resumen_usuario ru
    ON pl.plan_id = ru.plan_id
GROUP BY pl.nombre_plan
ORDER BY revenue_prom_por_usuario DESC;

-- ================================================
-- QUERY #5: Users at Risk of Churning
-- ================================================
-- Business Question: Which active users show low engagement and may cancel soon?
-- Purpose: Proactively re-engage at-risk users before cancellation
-- Criteria: Active subscription + fewer than 5 uses in last 30 days
--           + no activity in last 7 days
-- Note: Sample data uses 2024 dates. In production with current data,
--       this query identifies users with low recent engagement.
-- ================================================

WITH uso_reciente AS (
    SELECT
        usuario_id,
        MAX(fecha_uso) AS ultima_fecha_uso,
        SUM(CASE WHEN fecha_uso >= CURDATE() - INTERVAL 30 DAY
                 THEN cantidad_usos
                 ELSE 0 END) AS usos_ultimos_30_dias
    FROM uso_features
    GROUP BY usuario_id
)
SELECT
    u.nombre AS nombre_usuario,
    u.email,
    pl.nombre_plan AS nombre_plan_actual,
    DATEDIFF(CURDATE(), ur.ultima_fecha_uso) AS dias_ultimo_uso,
    ur.usos_ultimos_30_dias
FROM usuarios u
INNER JOIN uso_reciente ur
    ON u.usuario_id = ur.usuario_id
INNER JOIN suscripciones s
    ON u.usuario_id = s.usuario_id
INNER JOIN planes pl
    ON s.plan_id = pl.plan_id
WHERE s.estado = 'activa'
HAVING usos_ultimos_30_dias < 5
    AND dias_ultimo_uso > 7
ORDER BY dias_ultimo_uso DESC;

-- ================================================
-- END OF QUERIES
-- ================================================
