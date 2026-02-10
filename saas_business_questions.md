# 📊 Business Questions Documentation

## Overview
This document provides detailed explanations of each business query developed for CloudMetrics Pro SaaS Analytics, including business context, SQL logic, and actionable insights.

---

## Query #1: Monthly Recurring Revenue (MRR) by Plan

### Business Context
CloudMetrics Pro needs to track revenue trends across subscription tiers to make informed decisions about marketing investment and product development priorities.

### Business Question
**"How much recurring revenue is each subscription plan generating on a monthly basis?"**

### SQL Approach
```sql
SELECT
    DATE_FORMAT(p.fecha_pago, '%Y-%m') AS `mes/año`,
    pl.nombre_plan,
    SUM(p.monto) AS MRR_total
FROM pagos p
INNER JOIN suscripciones s ON p.suscripcion_id = s.suscripcion_id
INNER JOIN planes pl ON s.plan_id = pl.plan_id
WHERE p.estado_pago = 'completado'
    AND YEAR(p.fecha_pago) = 2024
    AND MONTH(p.fecha_pago) >= 4
GROUP BY DATE_FORMAT(p.fecha_pago, '%Y-%m'), pl.nombre_plan
ORDER BY `mes/año` ASC;
```

### Key SQL Concepts
- **DATE_FORMAT()**: Groups payments by month/year
- **Multiple JOINs**: Connects payments → subscriptions → plans
- **SUM()**: Calculates total revenue per plan per month
- **Date filtering**: YEAR() and MONTH() to target specific period

### Business Insights
- Identifies which plans drive the most revenue
- Reveals monthly revenue growth or decline trends
- Shows seasonal patterns in subscription upgrades

### Actionable Outcomes
- Allocate marketing budget toward highest-revenue plans
- Identify months needing promotional campaigns
- Set realistic revenue targets for future periods

---

## Query #2: Monthly Subscription Cancellations

### Business Context
Understanding when cancellations peak helps CloudMetrics Pro plan proactive retention campaigns and identify potential product or pricing issues.

### Business Question
**"How many subscriptions are being cancelled each month, and how many unique users does this represent?"**

### SQL Approach
```sql
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
```

### Key SQL Concepts
- **COUNT(DISTINCT)**: Counts unique users (avoids double-counting users with multiple cancellations)
- **DATE_FORMAT()**: Groups by cancellation month
- **Filtered aggregation**: WHERE clause targets only cancelled subscriptions

### Business Insights
- Identifies months with highest cancellation rates
- Distinguishes between total cancellations and unique affected users
- Helps correlate cancellations with external events or product changes

### Actionable Outcomes
- Plan retention campaigns before historically high-cancellation months
- Investigate root causes during cancellation spikes
- Measure effectiveness of retention initiatives over time

---

## Query #3: Most Used Features by Plan

### Business Context
Understanding which features drive engagement per subscription tier helps CloudMetrics Pro optimize product development investment and create targeted upsell opportunities.

### Business Question
**"Which platform features are most actively used by subscribers on each plan?"**

### SQL Approach
```sql
SELECT
    pl.nombre_plan,
    f.nombre_feature,
    SUM(uf.cantidad_usos) AS total_usos
FROM planes pl
INNER JOIN suscripciones s ON pl.plan_id = s.plan_id
INNER JOIN usuarios u ON s.usuario_id = u.usuario_id
INNER JOIN uso_features uf ON u.usuario_id = uf.usuario_id
INNER JOIN features f ON uf.feature_id = f.feature_id
WHERE s.estado = 'activa'
GROUP BY pl.nombre_plan, f.nombre_feature
ORDER BY pl.nombre_plan ASC, total_usos DESC;
```

### Key SQL Concepts
- **4 INNER JOINs**: Chains 5 tables to connect plans → subscriptions → users → usage → features
- **SUM(cantidad_usos)**: Aggregates total feature interactions
- **WHERE estado = 'activa'**: Focuses on currently active subscribers only
- **Multi-column ORDER BY**: Sorts by plan alphabetically, then by usage descending

### Business Insights
- Reveals which features justify plan upgrades
- Identifies underutilized features needing promotion or redesign
- Shows feature adoption patterns across different customer segments

### Actionable Outcomes
- Highlight most-used features in marketing materials
- Create in-app prompts for underutilized high-value features
- Build upsell campaigns around features unavailable in lower tiers
- Guide product roadmap based on actual usage data

---

## Query #4: Customer Lifetime Value (CLV) by Plan

### Business Context
CLV helps CloudMetrics Pro understand the long-term financial value of customers at each subscription tier, enabling smarter acquisition spending and retention investment decisions.

### Business Question
**"What is the average subscription duration and total revenue generated per customer, broken down by plan?"**

### SQL Approach
```sql
WITH resumen_usuario AS (
    SELECT
        s.usuario_id,
        s.plan_id,
        ABS(TIMESTAMPDIFF(MONTH, MIN(s.fecha_inicio), MAX(s.fecha_fin))) AS meses_suscrito,
        SUM(p.monto) AS revenue_total
    FROM suscripciones s
    INNER JOIN pagos p ON s.suscripcion_id = p.suscripcion_id
    WHERE s.estado IN ('cancelada', 'vencida')
    GROUP BY s.usuario_id, s.plan_id
)
SELECT
    pl.nombre_plan,
    ROUND(AVG(ru.meses_suscrito), 1) AS prom_meses_suscrito,
    ROUND(AVG(ru.revenue_total), 2) AS revenue_prom_por_usuario
FROM planes pl
INNER JOIN resumen_usuario ru ON pl.plan_id = ru.plan_id
GROUP BY pl.nombre_plan
ORDER BY revenue_prom_por_usuario DESC;
```

### Key SQL Concepts
- **CTE (Common Table Expression)**: Pre-aggregates data per user before final calculation
- **TIMESTAMPDIFF()**: Calculates months between subscription start and end
- **ABS()**: Ensures positive values from date calculations
- **AVG()**: Averages per-user metrics across all users of each plan
- **Completed cycle filter**: Only includes cancelled/expired subscriptions for accurate CLV

### Business Insights
- Shows which plans generate highest long-term value
- Identifies plans where customers stay longest
- Helps calculate customer acquisition cost (CAC) payback period

### Actionable Outcomes
- Set customer acquisition cost limits based on CLV per plan
- Focus retention efforts on highest CLV tiers
- Redesign low-CLV plans to improve value proposition
- Create upgrade incentives to move users toward higher-CLV plans

---

## Query #5: Users at Risk of Churning

### Business Context
Early identification of disengaged users allows CloudMetrics Pro to intervene before cancellation, reducing revenue loss and improving overall retention metrics.

### Business Question
**"Which active subscribers show low platform engagement and may be at risk of cancelling their subscription?"**

### SQL Approach
```sql
WITH uso_reciente AS (
    SELECT
        usuario_id,
        MAX(fecha_uso) AS ultima_fecha_uso,
        SUM(CASE WHEN fecha_uso >= CURDATE() - INTERVAL 30 DAY
                 THEN cantidad_usos ELSE 0 END) AS usos_ultimos_30_dias
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
INNER JOIN uso_reciente ur ON u.usuario_id = ur.usuario_id
INNER JOIN suscripciones s ON u.usuario_id = s.usuario_id
INNER JOIN planes pl ON s.plan_id = pl.plan_id
WHERE s.estado = 'activa'
HAVING usos_ultimos_30_dias < 5
    AND dias_ultimo_uso > 7
ORDER BY dias_ultimo_uso DESC;
```

### Key SQL Concepts
- **CTE with conditional SUM**: Calculates usage metrics only within last 30 days using INTERVAL
- **CURDATE()**: Returns current date for dynamic calculations
- **DATEDIFF()**: Calculates days since last platform interaction
- **INTERVAL**: Defines time windows for usage analysis
- **HAVING clause**: Filters aggregated results after grouping

### Risk Criteria
- **Less than 5 uses in 30 days**: Below minimum engagement threshold
- **No activity in last 7 days**: Recent disengagement signal

### Business Insights
- Prioritizes outreach by days since last activity
- Identifies which subscription plans have most at-risk users
- Enables personalized re-engagement based on user context

### Actionable Outcomes
- Trigger automated re-engagement email campaigns
- Assign customer success calls for high-value at-risk users
- Offer temporary discounts or feature unlocks to re-engage
- Investigate common usage patterns before disengagement
- Build early warning systems with automated daily alerts

---

## Summary of Business Impact

### Revenue Optimization
- **MRR Tracking**: Real-time visibility into revenue by plan
- **CLV Analysis**: Data-driven acquisition and retention investment
- **Cancellation Monitoring**: Early detection of revenue loss trends

### User Retention
- **Risk Identification**: Proactive intervention before cancellation
- **Feature Adoption**: Guide users toward high-value features
- **Engagement Metrics**: Measure platform health continuously

### Product Strategy
- **Feature Prioritization**: Build what users actually use
- **Plan Optimization**: Adjust pricing based on CLV data
- **Upsell Opportunities**: Identify upgrade triggers per user segment

---

## Technical Notes

### Performance Considerations
- Indexes on fecha_pago, fecha_cancelacion, and fecha_uso for date filtering
- CTEs reduce complexity and improve readability over nested subqueries
- DISTINCT usage prevents double-counting in multi-join scenarios

### Data Assumptions
- Sample data uses 2024 dates; Query #5 uses CURDATE() for dynamic calculation
- CLV calculation requires completed subscription cycles only
- Feature usage aggregated by cantidad_usos field for accurate counts

---

*Documentation prepared for CloudMetrics Pro SaaS Analytics SQL Portfolio Project*
