-- 1. Kommando för att skapa databas
CREATE DATABASE EventFlow;
GO

USE EventFlow;
GO

-- 2. Skapa tabeller (i denna ordning)

-- Besökare
CREATE TABLE Attendees(
    BesökareId INT IDENTITY(1,1) PRIMARY KEY,
    Namn NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    Telefon NVARCHAR(30) NOT NULL
);

-- Kategori
CREATE TABLE Categories(
    KategoriId INT IDENTITY(1,1) PRIMARY KEY,
    Namn NVARCHAR(100) NOT NULL
);

-- Arrangör
CREATE TABLE Organizers(
    ArrangörId INT IDENTITY(1,1) PRIMARY KEY,
    Namn NVARCHAR(100) NOT NULL,
    Telefon NVARCHAR(30) NOT NULL,
    Email NVARCHAR(255) NOT NULL
);

-- Evenemang
CREATE TABLE Events(
    EvenemangId INT IDENTITY(1,1) PRIMARY KEY,
    Titel NVARCHAR(150) NOT NULL,
    Beskrivning NVARCHAR(MAX) NOT NULL,
    Datum DATE NOT NULL,
    Tid TIME NOT NULL,
    Plats NVARCHAR(200) NOT NULL,
    Pris DECIMAL(10,2) NOT NULL,
    KategoriId INT NOT NULL FOREIGN KEY REFERENCES Categories(KategoriId),
    ArrangörId INT NOT NULL FOREIGN KEY REFERENCES Organizers(ArrangörId)
);

-- Anmälning
CREATE TABLE Registrations(
    AnmälningId INT IDENTITY(1,1) PRIMARY KEY,
    BesökareId INT NOT NULL,
    EvenemangId INT NOT NULL,
    Anmälningsdatum DATE NOT NULL,
    AntalPlatser INT NOT NULL,

    FOREIGN KEY (BesökareId) REFERENCES Attendees(BesökareId),
    FOREIGN KEY (EvenemangId) REFERENCES Events(EvenemangId)
);

/*
ALTER TABLE Events 
ADD UppdateradSenast DATETIME2;
GO
*/