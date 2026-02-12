-- =====================================================
-- SAAS SUBSCRIPTION DATABASE SCHEMA
-- =====================================================
-- This schema represents a SaaS platform with users,
-- subscription plans, features, and usage tracking.
-- =====================================================

-- Drop existing database if exists
DROP DATABASE IF EXISTS saas_plataforma;

-- Create database
CREATE DATABASE saas_plataforma;
USE saas_plataforma;

-- =====================================================
-- Table: planes
-- Purpose: Subscription tier definitions
-- =====================================================
CREATE TABLE planes (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_plan VARCHAR(50) NOT NULL UNIQUE,
    precio_mensual DECIMAL(10, 2) NOT NULL,
    descripcion TEXT
);

-- =====================================================
-- Table: usuarios
-- Purpose: Platform users/customers
-- =====================================================
CREATE TABLE usuarios (
    usuario_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    fecha_registro DATE NOT NULL,
    empresa VARCHAR(100)
);

-- =====================================================
-- Table: suscripciones
-- Purpose: User subscription records with status tracking
-- =====================================================
CREATE TABLE suscripciones (
    suscripcion_id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    plan_id INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    fecha_cancelacion DATE,
    estado ENUM('activa', 'cancelada', 'pausada') NOT NULL DEFAULT 'activa',
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id),
    FOREIGN KEY (plan_id) REFERENCES planes(plan_id)
);

-- =====================================================
-- Table: features
-- Purpose: Platform feature catalog
-- =====================================================
CREATE TABLE features (
    feature_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_feature VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT
);

-- =====================================================
-- Table: plan_features
-- Purpose: Features available per plan (many-to-many)
-- =====================================================
CREATE TABLE plan_features (
    plan_feature_id INT PRIMARY KEY AUTO_INCREMENT,
    plan_id INT NOT NULL,
    feature_id INT NOT NULL,
    limite_uso INT,
    FOREIGN KEY (plan_id) REFERENCES planes(plan_id),
    FOREIGN KEY (feature_id) REFERENCES features(feature_id),
    UNIQUE KEY unique_plan_feature (plan_id, feature_id)
);

-- =====================================================
-- Table: uso_features
-- Purpose: Feature usage tracking per user
-- =====================================================
CREATE TABLE uso_features (
    uso_id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    feature_id INT NOT NULL,
    fecha_uso DATE NOT NULL,
    cantidad_usos INT NOT NULL DEFAULT 1,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id),
    FOREIGN KEY (feature_id) REFERENCES features(feature_id)
);

-- =====================================================
-- Indexes for performance optimization
-- =====================================================
CREATE INDEX idx_suscripciones_usuario ON suscripciones(usuario_id);
CREATE INDEX idx_suscripciones_plan ON suscripciones(plan_id);
CREATE INDEX idx_suscripciones_estado ON suscripciones(estado);
CREATE INDEX idx_suscripciones_fecha_inicio ON suscripciones(fecha_inicio);
CREATE INDEX idx_uso_features_usuario ON uso_features(usuario_id);
CREATE INDEX idx_uso_features_feature ON uso_features(feature_id);
CREATE INDEX idx_uso_features_fecha ON uso_features(fecha_uso);

-- =====================================================
-- End of schema definition
-- =====================================================
