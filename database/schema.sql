-- ============================================================
--  Campus Recruitment Management System - Database Schema
--  Compatible with: MySQL 9.x
-- ============================================================

CREATE DATABASE IF NOT EXISTS campus_recruitment
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;
USE campus_recruitment;

-- Admins (Department / University)
CREATE TABLE IF NOT EXISTS admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    department VARCHAR(150),
    university VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Students
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    dob DATE,
    gender VARCHAR(10),
    address TEXT,
    department VARCHAR(100),
    batch VARCHAR(10),
    roll_number VARCHAR(50),
    cgpa DECIMAL(4,2) DEFAULT 0.00,
    tenth_percent DECIMAL(5,2) DEFAULT 0.00,
    twelfth_percent DECIMAL(5,2) DEFAULT 0.00,
    grad_percent DECIMAL(5,2) DEFAULT 0.00,
    masters_percent DECIMAL(5,2) DEFAULT 0.00,
    skills TEXT,
    resume_path VARCHAR(500),
    profile_complete TINYINT(1) DEFAULT 0,
    is_active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Companies
CREATE TABLE IF NOT EXISTS companies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    industry VARCHAR(100),
    description TEXT,
    website VARCHAR(300),
    contact_person VARCHAR(100),
    contact_phone VARCHAR(20),
    status ENUM('pending','approved','rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Placement Drives
CREATE TABLE IF NOT EXISTS drives (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT,
    admin_id INT,
    title VARCHAR(300) NOT NULL,
    description TEXT,
    role VARCHAR(200) NOT NULL,
    salary VARCHAR(100),
    location VARCHAR(200),
    drive_type ENUM('on-campus','off-campus','virtual') DEFAULT 'on-campus',
    min_cgpa DECIMAL(4,2) DEFAULT 0.00,
    min_tenth DECIMAL(5,2) DEFAULT 0.00,
    min_twelfth DECIMAL(5,2) DEFAULT 0.00,
    min_grad DECIMAL(5,2) DEFAULT 0.00,
    eligible_batches VARCHAR(200),
    eligible_branches VARCHAR(500),
    status ENUM('draft','pending_approval','published','closed','cancelled') DEFAULT 'draft',
    application_deadline DATE,
    drive_date DATE,
    created_by ENUM('admin','company') DEFAULT 'admin',
    approved_by INT,
    approved_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE SET NULL,
    FOREIGN KEY (admin_id) REFERENCES admins(id) ON DELETE SET NULL,
    FOREIGN KEY (approved_by) REFERENCES admins(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Drive Eligible Students
CREATE TABLE IF NOT EXISTS drive_eligible_students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    drive_id INT NOT NULL,
    student_id INT NOT NULL,
    marked_by INT,
    marked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_drive_student (drive_id, student_id),
    FOREIGN KEY (drive_id) REFERENCES drives(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (marked_by) REFERENCES admins(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Applications
CREATE TABLE IF NOT EXISTS applications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    drive_id INT NOT NULL,
    student_id INT NOT NULL,
    status ENUM('applied','shortlisted','selected','rejected') DEFAULT 'applied',
    cover_letter TEXT,
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_application (drive_id, student_id),
    FOREIGN KEY (drive_id) REFERENCES drives(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Notifications
CREATE TABLE IF NOT EXISTS notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    drive_id INT,
    title VARCHAR(300),
    message TEXT NOT NULL,
    is_read TINYINT(1) DEFAULT 0,
    type ENUM('drive','application','general') DEFAULT 'general',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (drive_id) REFERENCES drives(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
--  Default Data
-- ============================================================

INSERT INTO admins (name, email, password, department, university)
VALUES ('Admin', 'admin@university.edu', MD5('admin123'), 'Computer Science', 'State University')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO companies (name, email, password, industry, description, website, contact_person, contact_phone, status)
VALUES
('TechCorp Solutions', 'hr@techcorp.com', MD5('company123'), 'Information Technology', 'Leading IT solutions provider', 'https://techcorp.com', 'John Smith', '9876543210', 'approved'),
('Infosys', 'recruitment@infosys.com', MD5('company123'), 'IT Services', 'Global IT company', 'https://infosys.com', 'Priya Sharma', '9876543211', 'approved'),
('Wipro', 'careers@wipro.com', MD5('company123'), 'IT Services', 'Technology corporation', 'https://wipro.com', 'Rahul Verma', '9876543212', 'approved')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO students (name, email, password, phone, department, batch, roll_number, cgpa, tenth_percent, twelfth_percent, grad_percent)
VALUES
('Arjun Sharma',  'arjun@student.edu',  MD5('student123'), '9999000001', 'Computer Science', '2024', 'CS2024001', 8.50, 88.00, 85.00, 82.00),
('Priya Singh',   'priya@student.edu',  MD5('student123'), '9999000002', 'Computer Science', '2024', 'CS2024002', 9.10, 92.00, 90.00, 88.00),
('Rohit Kumar',   'rohit@student.edu',  MD5('student123'), '9999000003', 'Electronics',      '2024', 'EC2024001', 7.80, 78.00, 80.00, 76.00),
('Sneha Patel',   'sneha@student.edu',  MD5('student123'), '9999000004', 'Computer Science', '2024', 'CS2024003', 8.90, 95.00, 91.00, 87.00),
('Amit Gupta',    'amit@student.edu',   MD5('student123'), '9999000005', 'Mechanical',       '2024', 'ME2024001', 7.20, 75.00, 72.00, 70.00)
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO drives (company_id, admin_id, title, description, role, salary, location, drive_type, min_cgpa, min_tenth, min_twelfth, eligible_batches, eligible_branches, status, application_deadline, drive_date, created_by)
VALUES
(1, 1, 'TechCorp Campus Placement 2024', 'Join TechCorp as Software Engineer. Great for freshers.', 'Software Engineer', '6-8 LPA', 'Bangalore', 'on-campus', 7.00, 70.00, 70.00, '2024', 'Computer Science,Electronics', 'published', DATE_ADD(CURDATE(), INTERVAL 15 DAY), DATE_ADD(CURDATE(), INTERVAL 30 DAY), 'admin'),
(2, 1, 'Infosys Systems Engineer', 'Infosys is recruiting for Systems Engineer role.', 'Systems Engineer', '4-6 LPA', 'Multiple Locations', 'on-campus', 6.50, 65.00, 65.00, '2024', 'Computer Science,Electronics,Mechanical', 'published', DATE_ADD(CURDATE(), INTERVAL 10 DAY), DATE_ADD(CURDATE(), INTERVAL 25 DAY), 'admin')
ON DUPLICATE KEY UPDATE title=title;

INSERT IGNORE INTO drive_eligible_students (drive_id, student_id, marked_by)
SELECT 1, id, 1 FROM students WHERE (department='Computer Science' OR department='Electronics') AND cgpa >= 7.00 AND tenth_percent >= 70.00 AND twelfth_percent >= 70.00;

INSERT IGNORE INTO drive_eligible_students (drive_id, student_id, marked_by)
SELECT 2, id, 1 FROM students WHERE cgpa >= 6.50 AND tenth_percent >= 65.00 AND twelfth_percent >= 65.00;

INSERT IGNORE INTO applications (drive_id, student_id, status)
VALUES (1, 1, 'applied'), (1, 2, 'shortlisted'), (1, 4, 'selected'),
       (2, 1, 'applied'), (2, 2, 'applied'), (2, 3, 'applied');

INSERT INTO notifications (student_id, drive_id, title, message, type)
VALUES
(1, 1, 'New Drive: TechCorp Campus Placement 2024', 'You are eligible for TechCorp Campus Placement 2024. Apply before the deadline!', 'drive'),
(2, 1, 'New Drive: TechCorp Campus Placement 2024', 'You are eligible for TechCorp Campus Placement 2024. Apply before the deadline!', 'drive'),
(3, 2, 'New Drive: Infosys Systems Engineer',        'You are eligible for Infosys Systems Engineer drive. Apply before the deadline!', 'drive'),
(4, 1, 'New Drive: TechCorp Campus Placement 2024', 'You are eligible for TechCorp Campus Placement 2024. Apply before the deadline!', 'drive');
