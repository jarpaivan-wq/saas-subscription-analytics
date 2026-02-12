-- =====================================================
-- SAAS SUBSCRIPTION SAMPLE DATA
-- =====================================================
-- This file contains simulated data for demonstration
-- purposes. All user data and subscriptions are fictional
-- and created specifically for this portfolio.
-- =====================================================

USE saas_plataforma;

-- =====================================================
-- Insert Subscription Plans
-- =====================================================
INSERT INTO planes (nombre_plan, precio_mensual, descripcion) VALUES
('Básico', 19.99, 'Plan básico para emprendedores'),
('Profesional', 49.99, 'Plan profesional para equipos pequeños'),
('Empresarial', 99.99, 'Plan empresarial con todas las funcionalidades');

-- =====================================================
-- Insert Features
-- =====================================================
INSERT INTO features (nombre_feature, descripcion) VALUES
('Generación de Reportes', 'Crear reportes personalizados'),
('Exportación PDF', 'Exportar datos a formato PDF'),
('API Access', 'Acceso a la API REST'),
('Almacenamiento Cloud', 'Almacenamiento en la nube'),
('Soporte Prioritario', 'Atención al cliente prioritaria'),
('Integraciones', 'Conectar con apps de terceros'),
('Analytics Avanzado', 'Dashboard de analítica avanzada'),
('Usuarios Ilimitados', 'Sin límite de usuarios en la cuenta');

-- =====================================================
-- Link Features to Plans
-- =====================================================
-- Plan Básico
INSERT INTO plan_features (plan_id, feature_id, limite_uso) VALUES
(1, 1, 10),   -- 10 reportes/mes
(1, 2, 5),    -- 5 exportaciones PDF/mes
(1, 4, 5);    -- 5 GB almacenamiento

-- Plan Profesional
INSERT INTO plan_features (plan_id, feature_id, limite_uso) VALUES
(2, 1, 50),   -- 50 reportes/mes
(2, 2, 25),   -- 25 exportaciones PDF/mes
(2, 3, NULL), -- API ilimitado
(2, 4, 50),   -- 50 GB almacenamiento
(2, 6, 5);    -- 5 integraciones

-- Plan Empresarial
INSERT INTO plan_features (plan_id, feature_id, limite_uso) VALUES
(3, 1, NULL), -- Reportes ilimitados
(3, 2, NULL), -- Exportaciones ilimitadas
(3, 3, NULL), -- API ilimitado
(3, 4, NULL), -- Almacenamiento ilimitado
(3, 5, NULL), -- Soporte prioritario
(3, 6, NULL), -- Integraciones ilimitadas
(3, 7, NULL), -- Analytics avanzado
(3, 8, NULL); -- Usuarios ilimitados

-- =====================================================
-- Insert Users (30 sample users)
-- =====================================================
INSERT INTO usuarios (nombre, email, fecha_registro, empresa) VALUES
('John Smith', 'john.smith@techcorp.com', '2024-01-15', 'TechCorp'),
('Maria Garcia', 'maria.garcia@startup.io', '2024-01-20', 'StartupIO'),
('David Lee', 'david.lee@innovate.com', '2024-02-01', 'Innovate Inc'),
('Sarah Johnson', 'sarah.j@digitalagency.com', '2024-02-10', 'Digital Agency'),
('Michael Chen', 'michael.chen@dataflow.io', '2024-02-15', 'DataFlow'),
('Emma Wilson', 'emma.w@cloudservices.com', '2024-03-01', 'Cloud Services'),
('James Brown', 'james.brown@freelance.com', '2024-03-05', NULL),
('Lisa Martinez', 'lisa.m@consulting.co', '2024-03-10', 'Consulting Co'),
('Robert Taylor', 'robert.t@analytics.io', '2024-03-15', 'Analytics IO'),
('Jennifer Davis', 'jennifer.d@marketing.com', '2024-04-01', 'Marketing Pro'),
('William Anderson', 'william.a@ecommerce.shop', '2024-04-05', 'E-Commerce Shop'),
('Jessica Thomas', 'jessica.t@saastools.com', '2024-04-10', 'SaaS Tools'),
('Daniel Moore', 'daniel.m@automation.io', '2024-04-15', 'Automation IO'),
('Ashley Jackson', 'ashley.j@projects.com', '2024-04-20', 'Projects Inc'),
('Christopher White', 'chris.w@development.co', '2024-05-01', 'Development Co'),
('Amanda Harris', 'amanda.h@growth.io', '2024-05-05', 'Growth IO'),
('Matthew Martin', 'matthew.m@enterprise.com', '2024-05-10', 'Enterprise Corp'),
('Emily Thompson', 'emily.t@solutions.io', '2024-05-15', 'Solutions IO'),
('Ryan Garcia', 'ryan.g@platform.com', '2024-05-20', 'Platform Inc'),
('Nicole Martinez', 'nicole.m@agency.co', '2024-06-01', 'Agency Co'),
('Kevin Robinson', 'kevin.r@tech.io', '2024-06-05', 'Tech IO'),
('Stephanie Clark', 'stephanie.c@business.com', '2024-06-10', 'Business Pro'),
('Brandon Rodriguez', 'brandon.r@startup.co', '2024-06-15', 'Startup Co'),
('Rachel Lewis', 'rachel.l@digital.io', '2024-06-20', 'Digital IO'),
('Justin Walker', 'justin.w@services.com', '2024-07-01', 'Services Inc'),
('Melissa Hall', 'melissa.h@cloud.io', '2024-07-05', 'Cloud IO'),
('Tyler Allen', 'tyler.a@innovation.com', '2024-07-10', 'Innovation Corp'),
('Laura Young', 'laura.y@analytics.co', '2024-07-15', 'Analytics Co'),
('Eric Hernandez', 'eric.h@solutions.com', '2024-07-20', 'Solutions Corp'),
('Kelly King', 'kelly.k@platform.io', '2024-07-25', 'Platform IO');

-- =====================================================
-- Insert Subscriptions (mix of active and cancelled)
-- =====================================================

-- Active subscriptions
INSERT INTO suscripciones (usuario_id, plan_id, fecha_inicio, fecha_fin, fecha_cancelacion, estado) VALUES
(1, 2, '2024-01-15', NULL, NULL, 'activa'),
(2, 1, '2024-01-20', NULL, NULL, 'activa'),
(3, 3, '2024-02-01', NULL, NULL, 'activa'),
(4, 2, '2024-02-10', NULL, NULL, 'activa'),
(5, 2, '2024-02-15', NULL, NULL, 'activa'),
(6, 3, '2024-03-01', NULL, NULL, 'activa'),
(7, 1, '2024-03-05', NULL, NULL, 'activa'),
(8, 2, '2024-03-10', NULL, NULL, 'activa'),
(9, 3, '2024-03-15', NULL, NULL, 'activa'),
(10, 2, '2024-04-01', NULL, NULL, 'activa'),
(15, 2, '2024-05-01', NULL, NULL, 'activa'),
(16, 1, '2024-05-05', NULL, NULL, 'activa'),
(17, 3, '2024-05-10', NULL, NULL, 'activa'),
(18, 2, '2024-05-15', NULL, NULL, 'activa'),
(19, 2, '2024-05-20', NULL, NULL, 'activa'),
(20, 1, '2024-06-01', NULL, NULL, 'activa'),
(25, 1, '2024-07-01', NULL, NULL, 'activa'),
(26, 2, '2024-07-05', NULL, NULL, 'activa'),
(27, 3, '2024-07-10', NULL, NULL, 'activa'),
(28, 2, '2024-07-15', NULL, NULL, 'activa');

-- Cancelled subscriptions (churn examples)
INSERT INTO suscripciones (usuario_id, plan_id, fecha_inicio, fecha_fin, fecha_cancelacion, estado) VALUES
(11, 1, '2024-04-05', '2024-05-05', '2024-05-05', 'cancelada'),
(12, 2, '2024-04-10', '2024-06-10', '2024-06-10', 'cancelada'),
(13, 1, '2024-04-15', '2024-06-15', '2024-06-15', 'cancelada'),
(14, 2, '2024-04-20', '2024-07-20', '2024-07-20', 'cancelada'),
(21, 1, '2024-06-05', '2024-07-05', '2024-07-05', 'cancelada'),
(22, 2, '2024-06-10', '2024-08-10', '2024-08-10', 'cancelada'),
(23, 1, '2024-06-15', '2024-08-15', '2024-08-15', 'cancelada'),
(24, 2, '2024-06-20', '2024-08-20', '2024-08-20', 'cancelada'),
(29, 1, '2024-07-20', '2024-08-20', '2024-08-20', 'cancelada'),
(30, 2, '2024-07-25', '2024-09-25', '2024-09-25', 'cancelada');

-- =====================================================
-- Insert Feature Usage (for active users)
-- =====================================================

-- User 1 (Plan Profesional - active user)
INSERT INTO uso_features (usuario_id, feature_id, fecha_uso, cantidad_usos) VALUES
(1, 1, '2024-07-01', 15),
(1, 2, '2024-07-01', 8),
(1, 3, '2024-07-05', 25),
(1, 1, '2024-07-10', 12),
(1, 6, '2024-07-15', 3);

-- User 2 (Plan Básico - moderate usage)
INSERT INTO uso_features (usuario_id, feature_id, fecha_uso, cantidad_usos) VALUES
(2, 1, '2024-07-02', 5),
(2, 2, '2024-07-05', 2),
(2, 1, '2024-07-15', 3);

-- User 3 (Plan Empresarial - heavy user)
INSERT INTO uso_features (usuario_id, feature_id, fecha_uso, cantidad_usos) VALUES
(3, 1, '2024-07-01', 45),
(3, 2, '2024-07-01', 30),
(3, 3, '2024-07-03', 50),
(3, 5, '2024-07-05', 10),
(3, 7, '2024-07-10', 25),
(3, 1, '2024-07-15', 38);

-- User 4 (Plan Profesional - active)
INSERT INTO uso_features (usuario_id, feature_id, fecha_uso, cantidad_usos) VALUES
(4, 1, '2024-07-03', 18),
(4, 2, '2024-07-06', 12),
(4, 3, '2024-07-08', 20),
(4, 6, '2024-07-12', 4);

-- User 5 (Plan Profesional - moderate)
INSERT INTO uso_features (usuario_id, feature_id, fecha_uso, cantidad_usos) VALUES
(5, 1, '2024-07-05', 10),
(5, 2, '2024-07-10', 5),
(5, 3, '2024-07-15', 15);

-- User 6 (Plan Empresarial - heavy)
INSERT INTO uso_features (usuario_id, feature_id, fecha_uso, cantidad_usos) VALUES
(6, 1, '2024-07-02', 40),
(6, 2, '2024-07-04', 28),
(6, 3, '2024-07-06', 45),
(6, 5, '2024-07-08', 8),
(6, 7, '2024-07-12', 30);

-- User 7 (Plan Básico - low usage - AT RISK)
INSERT INTO uso_features (usuario_id, feature_id, fecha_uso, cantidad_usos) VALUES
(7, 1, '2024-06-15', 2),
(7, 2, '2024-06-20', 1);

-- User 8 (Plan Profesional - active)
INSERT INTO uso_features (usuario_id, feature_id, fecha_uso, cantidad_usos) VALUES
(8, 1, '2024-07-04', 16),
(8, 2, '2024-07-08', 9),
(8, 3, '2024-07-14', 22);

-- User 9 (Plan Empresarial - very active)
INSERT INTO uso_features (usuario_id, feature_id, fecha_uso, cantidad_usos) VALUES
(9, 1, '2024-07-01', 50),
(9, 2, '2024-07-03', 35),
(9, 3, '2024-07-05', 48),
(9, 7, '2024-07-10', 28);

-- User 10 (Plan Profesional - low usage - AT RISK)
INSERT INTO uso_features (usuario_id, feature_id, fecha_uso, cantidad_usos) VALUES
(10, 1, '2024-06-10', 3),
(10, 2, '2024-06-25', 1);

-- User 15 (Plan Profesional - moderate)
INSERT INTO uso_features (usuario_id, feature_id, fecha_uso, cantidad_usos) VALUES
(15, 1, '2024-07-05', 14),
(15, 2, '2024-07-12', 7),
(15, 3, '2024-07-18', 18);

-- User 16 (Plan Básico - active)
INSERT INTO uso_features (usuario_id, feature_id, fecha_uso, cantidad_usos) VALUES
(16, 1, '2024-07-06', 8),
(16, 2, '2024-07-10', 4),
(16, 1, '2024-07-20', 6);

-- User 17 (Plan Empresarial - heavy)
INSERT INTO uso_features (usuario_id, feature_id, fecha_uso, cantidad_usos) VALUES
(17, 1, '2024-07-02', 42),
(17, 2, '2024-07-06', 32),
(17, 3, '2024-07-10', 40),
(17, 7, '2024-07-15', 26);

-- User 18 (Plan Profesional - low usage - AT RISK)
INSERT INTO uso_features (usuario_id, feature_id, fecha_uso, cantidad_usos) VALUES
(18, 1, '2024-06-20', 2);

-- User 19 (Plan Profesional - active)
INSERT INTO uso_features (usuario_id, feature_id, fecha_uso, cantidad_usos) VALUES
(19, 1, '2024-07-08', 17),
(19, 2, '2024-07-12', 10),
(19, 3, '2024-07-16', 21);

-- User 20 (Plan Básico - low usage - AT RISK)
INSERT INTO uso_features (usuario_id, feature_id, fecha_uso, cantidad_usos) VALUES
(20, 1, '2024-06-25', 1);

-- =====================================================
-- End of sample data
-- =====================================================
