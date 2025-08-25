-- -----------------------------------------------------
-- Database: Clinic Booking System
-- Description: Manages patients, doctors, appointments, treatments, and billing
-- Author: [Your Name]
-- -----------------------------------------------------

-- Drop database if it exists (for clean setup)
DROP DATABASE IF EXISTS clinic_db;

-- Create the database
CREATE DATABASE clinic_db;
USE clinic_db;

-- -----------------------------------------------------
-- Table: Patients
-- Stores patient information
-- -----------------------------------------------------
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    address TEXT
);

-- -----------------------------------------------------
-- Table: Doctors
-- Stores doctor information
-- -----------------------------------------------------
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialty VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE
);

-- -----------------------------------------------------
-- Table: Rooms
-- Each appointment is assigned a room
-- -----------------------------------------------------
CREATE TABLE Rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    room_type ENUM('Consultation', 'Surgery', 'Recovery') NOT NULL
);

-- -----------------------------------------------------
-- Table: Appointments
-- Links patients to doctors and rooms
-- -----------------------------------------------------
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    room_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
);

-- -----------------------------------------------------
-- Table: Treatments
-- Treatments prescribed during appointments
-- -----------------------------------------------------
CREATE TABLE Treatments (
    treatment_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    treatment_description TEXT NOT NULL,
    medication VARCHAR(100),
    cost DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

-- -----------------------------------------------------
-- Table: Billing
-- Billing information for each appointment
-- -----------------------------------------------------
CREATE TABLE Billing (
    billing_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE, -- One-to-one relationship
    total_amount DECIMAL(10,2) NOT NULL,
    payment_status ENUM('Pending', 'Paid', 'Overdue') DEFAULT 'Pending',
    payment_date DATE,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

-- -----------------------------------------------------
-- Table: Doctor_Schedule
-- Many-to-many relationship between doctors and available time slots
-- -----------------------------------------------------
CREATE TABLE TimeSlots (
    slot_id INT AUTO_INCREMENT PRIMARY KEY,
    slot_time DATETIME NOT NULL UNIQUE
);

CREATE TABLE Doctor_Schedule (
    doctor_id INT NOT NULL,
    slot_id INT NOT NULL,
    PRIMARY KEY (doctor_id, slot_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (slot_id) REFERENCES TimeSlots(slot_id)
);

-- -----------------------------------------------------
-- Sample Data (Optional for testing)
-- -----------------------------------------------------
-- INSERT INTO Patients (first_name, last_name, date_of_birth, gender, phone, email, address)
-- VALUES ('John', 'Doe', '1990-05-15', 'Male', '08012345678', 'john.doe@example.com', '123 Main St');

-- INSERT INTO Doctors (first_name, last_name, specialty, phone, email)
-- VALUES ('Alice', 'Smith', 'Cardiology', '08098765432', 'alice.smith@clinic.com');

-- INSERT INTO Rooms (room_number, room_type)
-- VALUES ('101', 'Consultation');

-- INSERT INTO TimeSlots (slot_time)
-- VALUES ('2025-08-26 09:00:00'), ('2025-08-26 10:00:00');

-- INSERT INTO Doctor_Schedule (doctor_id, slot_id)
-- VALUES (1, 1), (1, 2);