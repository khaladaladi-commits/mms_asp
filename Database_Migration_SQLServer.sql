-- SQL Server Migration Script for MMS System
-- Converted from MySQL to SQL Server

-- Drop tables if they exist
IF OBJECT_ID('Files', 'U') IS NOT NULL DROP TABLE Files;
IF OBJECT_ID('MMInstructions', 'U') IS NOT NULL DROP TABLE MMInstructions;
IF OBJECT_ID('MetricMMAccess', 'U') IS NOT NULL DROP TABLE MetricMMAccess;
IF OBJECT_ID('MandatoryMaterials', 'U') IS NOT NULL DROP TABLE MandatoryMaterials;
IF OBJECT_ID('MetricHeads', 'U') IS NOT NULL DROP TABLE MetricHeads;
IF OBJECT_ID('StandardHeads', 'U') IS NOT NULL DROP TABLE StandardHeads;
IF OBJECT_ID('Metrics', 'U') IS NOT NULL DROP TABLE Metrics;
IF OBJECT_ID('Standards', 'U') IS NOT NULL DROP TABLE Standards;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;

-- Users Table
CREATE TABLE Users (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(100) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    Role NVARCHAR(50) NOT NULL CHECK (Role IN ('admin', 'standard_head', 'metric_head')) DEFAULT 'metric_head',
    Name NVARCHAR(255) NOT NULL,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE()
);

-- Standards Table
CREATE TABLE Standards (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    OrderNum INT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE()
);

-- Metrics Table
CREATE TABLE Metrics (
    Id INT PRIMARY KEY IDENTITY(1,1),
    StandardId INT NOT NULL,
    Name NVARCHAR(255) NOT NULL,
    OrderNum INT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (StandardId) REFERENCES Standards(Id) ON DELETE CASCADE
);

-- StandardHeads Table
CREATE TABLE StandardHeads (
    Id INT PRIMARY KEY IDENTITY(1,1),
    UserId INT NOT NULL,
    StandardId INT NOT NULL,
    AssignedBy INT NOT NULL,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE,
    FOREIGN KEY (StandardId) REFERENCES Standards(Id) ON DELETE CASCADE,
    FOREIGN KEY (AssignedBy) REFERENCES Users(Id),
    UNIQUE (UserId, StandardId)
);

-- MetricHeads Table
CREATE TABLE MetricHeads (
    Id INT PRIMARY KEY IDENTITY(1,1),
    UserId INT NOT NULL,
    MetricId INT NOT NULL,
    AssignedBy INT NOT NULL,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE,
    FOREIGN KEY (MetricId) REFERENCES Metrics(Id) ON DELETE CASCADE,
    FOREIGN KEY (AssignedBy) REFERENCES Users(Id),
    UNIQUE (UserId, MetricId)
);

-- MandatoryMaterials Table
CREATE TABLE MandatoryMaterials (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Code NVARCHAR(50) NOT NULL UNIQUE, -- MM1 to MM250
    Name NVARCHAR(255) NULL,
    MetricId INT NULL,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (MetricId) REFERENCES Metrics(Id) ON DELETE SET NULL
);

-- MetricMMAccess Table
CREATE TABLE MetricMMAccess (
    Id INT PRIMARY KEY IDENTITY(1,1),
    MetricId INT NOT NULL,
    MmId INT NOT NULL,
    GrantedBy INT NOT NULL,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (MetricId) REFERENCES Metrics(Id) ON DELETE CASCADE,
    FOREIGN KEY (MmId) REFERENCES MandatoryMaterials(Id) ON DELETE CASCADE,
    FOREIGN KEY (GrantedBy) REFERENCES Users(Id),
    UNIQUE (MetricId, MmId)
);

-- MMInstructions Table
CREATE TABLE MMInstructions (
    Id INT PRIMARY KEY IDENTITY(1,1),
    MmId INT NOT NULL,
    Filename NVARCHAR(255) NOT NULL,
    OriginalName NVARCHAR(255) NOT NULL,
    Note NVARCHAR(MAX) NULL,
    UploadedBy INT NOT NULL,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (MmId) REFERENCES MandatoryMaterials(Id) ON DELETE CASCADE,
    FOREIGN KEY (UploadedBy) REFERENCES Users(Id)
);

-- Files Table
CREATE TABLE Files (
    Id INT PRIMARY KEY IDENTITY(1,1),
    MetricId INT NOT NULL,
    Filename NVARCHAR(255) NOT NULL,
    OriginalName NVARCHAR(255) NOT NULL,
    Status NVARCHAR(50) NOT NULL DEFAULT 'pending_sh',
    UploadedBy INT NOT NULL,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (MetricId) REFERENCES Metrics(Id) ON DELETE CASCADE,
    FOREIGN KEY (UploadedBy) REFERENCES Users(Id)
);

-- Create Indexes
CREATE INDEX idx_Metrics_StandardId ON Metrics(StandardId);
CREATE INDEX idx_StandardHeads_UserId ON StandardHeads(UserId);
CREATE INDEX idx_StandardHeads_StandardId ON StandardHeads(StandardId);
CREATE INDEX idx_MetricHeads_UserId ON MetricHeads(UserId);
CREATE INDEX idx_MetricHeads_MetricId ON MetricHeads(MetricId);
CREATE INDEX idx_Files_MetricId ON Files(MetricId);
CREATE INDEX idx_Files_UploadedBy ON Files(UploadedBy);
CREATE INDEX idx_Files_Status ON Files(Status);
CREATE INDEX idx_MandatoryMaterials_MetricId ON MandatoryMaterials(MetricId);
CREATE INDEX idx_MetricMMAccess_MetricId ON MetricMMAccess(MetricId);
CREATE INDEX idx_MetricMMAccess_MmId ON MetricMMAccess(MmId);

-- Sample Data (Optional)
-- INSERT INTO Users (Username, Password, Role, Name) VALUES ('admin', 'hash_here', 'admin', 'مدير النظام');
-- INSERT INTO Standards (Name, OrderNum) VALUES ('المعيار الأول', 1);
-- INSERT INTO Metrics (StandardId, Name, OrderNum) VALUES (1, 'المقياس الأول', 1);
