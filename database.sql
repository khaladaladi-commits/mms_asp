CREATE DATABASE IF NOT EXISTS `self_stu_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `self_stu_db`;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `files`;
DROP TABLE IF EXISTS `mm_instructions`;
DROP TABLE IF EXISTS `metric_mm_access`;
DROP TABLE IF EXISTS `mandatory_materials`;
DROP TABLE IF EXISTS `metric_heads`;
DROP TABLE IF EXISTS `standard_heads`;
DROP TABLE IF EXISTS `metrics`;
DROP TABLE IF EXISTS `standards`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `department_mm_access`;
DROP TABLE IF EXISTS `departments`;
SET FOREIGN_KEY_CHECKS = 1;


CREATE TABLE IF NOT EXISTS `users` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(100) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `role` ENUM('admin', 'standard_head', 'metric_head') NOT NULL DEFAULT 'metric_head',
    `name` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `standards` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `order_num` INT NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `metrics` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `standard_id` INT NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `order_num` INT NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`standard_id`) REFERENCES `standards`(`id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `standard_heads` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `standard_id` INT NOT NULL,
    `assigned_by` INT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`standard_id`) REFERENCES `standards`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`assigned_by`) REFERENCES `users`(`id`),
    UNIQUE KEY `user_standard_unique` (`user_id`, `standard_id`)
);

CREATE TABLE IF NOT EXISTS `metric_heads` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `metric_id` INT NOT NULL,
    `assigned_by` INT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`metric_id`) REFERENCES `metrics`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`assigned_by`) REFERENCES `users`(`id`),
    UNIQUE KEY `user_metric_unique` (`user_id`, `metric_id`)
);

CREATE TABLE IF NOT EXISTS `mandatory_materials` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(50) NOT NULL UNIQUE, -- MM1 to MM250
    `name` VARCHAR(255) NULL,
    `metric_id` INT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`metric_id`) REFERENCES `metrics`(`id`) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS `metric_mm_access` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `metric_id` INT NOT NULL,
    `mm_id` INT NOT NULL,
    `granted_by` INT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`metric_id`) REFERENCES `metrics`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`mm_id`) REFERENCES `mandatory_materials`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`granted_by`) REFERENCES `users`(`id`),
    UNIQUE KEY `metric_mm_unique` (`metric_id`, `mm_id`)
);

CREATE TABLE IF NOT EXISTS `mm_instructions` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `mm_id` INT NOT NULL,
    `filename` VARCHAR(255) NOT NULL,
    `original_name` VARCHAR(255) NOT NULL,
    `note` TEXT NULL,
    `uploaded_by` INT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`mm_id`) REFERENCES `mandatory_materials`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`uploaded_by`) REFERENCES `users`(`id`)
);

CREATE TABLE IF NOT EXISTS `files` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `type` ENUM('mandatory', 'supporting') NOT NULL,
    `mm_id` INT NOT NULL,
    `code` VARCHAR(50) NULL,
    `filename` VARCHAR(255) NOT NULL,
    `original_name` VARCHAR(255) NOT NULL,
    `uploaded_by` INT NOT NULL,
    `metric_id` INT NOT NULL,
    `status` ENUM('pending_sh', 'approved_sh', 'rejected_sh', 'pending_admin', 'approved', 'rejected') NOT NULL DEFAULT 'pending_sh',
    `sh_rejection_reason` TEXT NULL,
    `sh_rejection_file` VARCHAR(255) NULL,
    `admin_rejection_reason` TEXT NULL,
    `admin_rejection_file` VARCHAR(255) NULL,
    `reviewed_by_sh` INT NULL,
    `reviewed_by_admin` INT NULL,
    `sh_review_date` TIMESTAMP NULL,
    `admin_review_date` TIMESTAMP NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`mm_id`) REFERENCES `mandatory_materials`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`uploaded_by`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`metric_id`) REFERENCES `metrics`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`reviewed_by_sh`) REFERENCES `users`(`id`) ON DELETE SET NULL,
    FOREIGN KEY (`reviewed_by_admin`) REFERENCES `users`(`id`) ON DELETE SET NULL
);
