-- init_db.sql
-- SQL script to create and initialize the database tables

-- Drop tables if they exist to start fresh (optional)
DROP TABLE IF EXISTS Student_take_class, Enrollment, Meeting, Days_of_week, Section, Class, Course, 
                   Grade_option, Units, Faculty_department, Faculty, Teaching_schedule, Prerequisite, 
                   Pursuing, Degree, Student_to_account, Payment_method, Payment_history, Account, 
                   Probation, Degrees_obtained, Attendance_periods, Thesis_committee, Phd_student, 
                   Additional_phd_professors, Master_student, BSMS_student, Graduate_student, 
                   Undergraduate_student, Student CASCADE;

-- Student table
CREATE TABLE Student (
    student_id CHAR(9) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    ssn CHAR(11),
    residential_status VARCHAR(50),
    enrolled BOOLEAN NOT NULL
);

-- Faculty
CREATE TABLE Faculty (
    name VARCHAR(255) PRIMARY KEY,
    title VARCHAR(255) NOT NULL
);

-- Undergraduate student
CREATE TABLE Undergraduate_student (
    student_id CHAR(9) PRIMARY KEY,
    college VARCHAR(25) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Student(student_id)
);

-- Graduate student
CREATE TABLE Graduate_student (
    student_id CHAR(9) PRIMARY KEY,
    department VARCHAR(50) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Student(student_id)
);

-- BSMS student
CREATE TABLE BSMS_student (
    student_id CHAR(9) PRIMARY KEY,
    college VARCHAR(25) NOT NULL,
    plan VARCHAR(50) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Student(student_id)
);

-- Master student
CREATE TABLE Master_student (
    student_id CHAR(9) PRIMARY KEY,
    plan VARCHAR(50) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Student(student_id)
);

-- PhD student
CREATE TABLE Phd_student (
    student_id CHAR(9) PRIMARY KEY,
    candidacy_status BOOLEAN NOT NULL,
    advisor VARCHAR(50),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (advisor) REFERENCES Faculty(name)
);

-- Additional Phd advisors
CREATE TABLE Additional_phd_professors (
    student_id CHAR(9),
    professor VARCHAR(50),
    PRIMARY KEY (student_id, professor),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (professor) REFERENCES Faculty(name)
);

-- Thesis committee
CREATE TABLE Thesis_committee (
    student_id CHAR(9),
    professor VARCHAR(50),
    PRIMARY KEY (student_id, professor),
    FOREIGN KEY (student_id) REFERENCES Student(student_id), 
    FOREIGN KEY (professor) REFERENCES Faculty(name)
);

-- Attendance periods
CREATE TABLE Attendance_periods (
    student_id CHAR(9),
    period_start DATE,
    period_end DATE,
    PRIMARY KEY (student_id, period_start, period_end),
    FOREIGN KEY (student_id) REFERENCES Student(student_id)
);

-- Degrees obtained
CREATE TABLE Degrees_obtained (
    student_id CHAR(9),
    degree_type VARCHAR(255),
    major VARCHAR(255),
    start_date DATE,
    end_date DATE,
    university VARCHAR(255),
    PRIMARY KEY (student_id, degree_type, major, start_date, end_date, university),
    FOREIGN KEY (student_id) REFERENCES Student(student_id)
);

-- Probation
CREATE TABLE Probation (
    student_id CHAR(9),
    start_date DATE,
    end_date DATE,
    reason VARCHAR(255) NOT NULL,
    PRIMARY KEY (student_id, start_date, end_date),
    FOREIGN KEY (student_id) REFERENCES Student(student_id)
);

-- Account table
CREATE TABLE Account (
    account_number VARCHAR(50) PRIMARY KEY,
    balance DECIMAL(10, 2) NOT NULL
);

-- Payment history
CREATE TABLE Payment_history (
    account_number VARCHAR(50),
    amount DECIMAL(10, 2) NOT NULL,
    time TIMESTAMP,
    PRIMARY KEY (account_number, time),
    FOREIGN KEY (account_number) REFERENCES Account(account_number)
);

-- Student to account
CREATE TABLE Student_to_account (
    student_id CHAR(9),
    account_number VARCHAR(50),
    PRIMARY KEY (student_id, account_number),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (account_number) REFERENCES Account(account_number)
);

-- Payment method
CREATE TABLE Payment_method (
    account_number VARCHAR(50),
    method VARCHAR(255),
    PRIMARY KEY (account_number, method),
    FOREIGN KEY (account_number) REFERENCES Account(account_number)
);

-- Degree
CREATE TABLE Degree (
    degree_id SERIAL PRIMARY KEY,
    degree_name VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL,
    department VARCHAR(255) NOT NULL,
    concentration VARCHAR(255) NOT NULL,
    upper_credits INT NOT NULL,
    lower_credits INT NOT NULL
);

-- Pursuing
CREATE TABLE Pursuing (
    student_id CHAR(9),
    degree_id INT,
    PRIMARY KEY (student_id, degree_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (degree_id) REFERENCES Degree(degree_id)
);

-- Faculty department
CREATE TABLE Faculty_department (
    name VARCHAR(255),
    department VARCHAR(255),
    PRIMARY KEY (name, department),
    FOREIGN KEY (name) REFERENCES Faculty(name)
);

-- Course
CREATE TABLE Course (
    course_number VARCHAR(50) PRIMARY KEY,
    department VARCHAR(255) NOT NULL,
    require_lab_work BOOLEAN NOT NULL
);

-- Units
CREATE TABLE Units (
    course_number VARCHAR(50),
    unit INT,
    PRIMARY KEY (course_number, unit),
    FOREIGN KEY (course_number) REFERENCES Course(course_number)
);

-- Grade option
CREATE TABLE Grade_option (
    course_number VARCHAR(50),
    option VARCHAR(50),
    PRIMARY KEY (course_number, option),
    FOREIGN KEY (course_number) REFERENCES Course(course_number)
);

-- Prerequisite
CREATE TABLE Prerequisite (
    course_number VARCHAR(50),
    required_course_number VARCHAR(50),
    PRIMARY KEY (course_number, required_course_number),
    FOREIGN KEY (course_number) REFERENCES Course(course_number),
    FOREIGN KEY (required_course_number) REFERENCES Course(course_number)
);

-- Class
CREATE TABLE Class (
    class_id SERIAL PRIMARY KEY,
    course_number VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    year INT NOT NULL,
    quarter VARCHAR(50) NOT NULL,
    FOREIGN KEY (course_number) REFERENCES Course(course_number)
);

-- Teaching schedule
CREATE TABLE Teaching_schedule (
    name VARCHAR(255),
    class_id INT,
    PRIMARY KEY (name, class_id),
    FOREIGN KEY (name) REFERENCES Faculty(name),
    FOREIGN KEY (class_id) REFERENCES Class(class_id)
);

-- Section
CREATE TABLE Section (
    section_id SERIAL PRIMARY KEY,
    class_id INT NOT NULL,
    professor VARCHAR(50) NOT NULL,
    enrollment_limit INT NOT NULL,
    FOREIGN KEY (class_id) REFERENCES Class(class_id),
    FOREIGN KEY (professor) REFERENCES Faculty(name)
);

-- Student take class
CREATE TABLE Student_take_class (
    student_id CHAR(9),
    class_id INT,
    grade CHAR(2) NOT NULL,
    PRIMARY KEY (student_id, class_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (class_id) REFERENCES Class(class_id)
);

-- Enrollment
CREATE TABLE Enrollment (
    student_id CHAR(9),
    section_id INT,
    enrollment_type VARCHAR(50) NOT NULL,
    grading_option VARCHAR(50) NOT NULL,
    units INT NOT NULL,
    enroll_order SERIAL NOT NULL,
    PRIMARY KEY (student_id, section_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (section_id) REFERENCES Section(section_id)
);

-- Meeting
CREATE TABLE Meeting (
    section_id INT,
    meeting_id CHAR(3),
    type VARCHAR(50) NOT NULL,
    room VARCHAR(255) NOT NULL,
    building VARCHAR(255) NOT NULL,
    mandatory BOOLEAN NOT NULL,
    time_start TIME NOT NULL,
    time_end TIME NOT NULL,
    date_start DATE NOT NULL,
    date_end DATE NOT NULL,
    PRIMARY KEY (section_id, meeting_id),
    FOREIGN KEY (section_id) REFERENCES Section(section_id)
);

-- Days of week
CREATE TABLE Days_of_week (
    section_id INT,
    meeting_id CHAR(3),
    days VARCHAR(50),
    PRIMARY KEY (section_id, meeting_id, days),
    FOREIGN KEY (section_id, meeting_id) REFERENCES Meeting(section_id, meeting_id)
);
