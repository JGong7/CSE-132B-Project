-- init_db.sql
-- SQL script to create and initialize the database tables

-- Drop tables if they exist to start fresh (optional)
DROP TABLE IF EXISTS Student, Faculty, Undergraduate_student, BSMS_student, Master_student,
                    Phd_student, Thesis_committee, Attendance_period, Degrees_obtained, 
                    Probation, Account, Payment_history, Degree, Pursuing, Faculty_department,
                    Course, Units, Grade_option, Prerequisite, Class, Teaching_schedule, 
                    Section, Student_take_class, Enrollment, Meeting, Review_Session CASCADE;

-- Student table
CREATE TABLE Student (
    student_id CHAR(9) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    ssn CHAR(11) UNIQUE,
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
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE
);

-- BSMS student
CREATE TABLE BSMS_student (
    student_id CHAR(9) PRIMARY KEY,
    college VARCHAR(25) NOT NULL,
    department VARCHAR(50) NOT NULL,
    plan VARCHAR(50) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE
);

-- Master student
CREATE TABLE Master_student (
    student_id CHAR(9) PRIMARY KEY,
    department VARCHAR(50) NOT NULL,
    plan VARCHAR(50) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE
);

-- PhD student
CREATE TABLE Phd_student (
    student_id CHAR(9) PRIMARY KEY,
    department VARCHAR(50) NOT NULL,
    candidacy_status VARCHAR(15) NOT NULL,
    advisor VARCHAR(50),
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE,
    FOREIGN KEY (advisor) REFERENCES Faculty(name)
);

-- Student enrollment
CREATE TABLE Student_Enrollment (
    student_id CHAR(9),
    quarter VARCHAR(20),
    year INT,
    PRIMARY KEY (student_id, quarter, year),
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE 
);

-- Thesis committee
CREATE TABLE Thesis_committee (
    student_id CHAR(9),
    professor VARCHAR(50),
    is_external BOOLEAN NOT NULL,
    PRIMARY KEY (student_id, professor),
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE, 
    FOREIGN KEY (professor) REFERENCES Faculty(name) ON DELETE CASCADE
);

-- Attendance periods
CREATE TABLE Attendance_period (
    student_id CHAR(9),
    period_start DATE,
    period_end DATE,
    PRIMARY KEY (student_id, period_start, period_end),
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE
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
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE
);

-- Probation
CREATE TABLE Probation (
    student_id CHAR(9),
    start_date DATE,
    end_date DATE,
    reason VARCHAR(255) NOT NULL,
    PRIMARY KEY (student_id, start_date, end_date),
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE
);

-- Account table
CREATE TABLE Account (
    account_number VARCHAR(50) PRIMARY KEY,
    student_id CHAR(9),
    balance DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE
);

-- Payment history
CREATE TABLE Payment_history (
    account_number VARCHAR(50),
    amount DECIMAL(10, 2) NOT NULL,
    time TIMESTAMP,
    PRIMARY KEY (account_number, time),
    FOREIGN KEY (account_number) REFERENCES Account(account_number) ON DELETE CASCADE
);

-- Degree
CREATE TABLE Degree (
    degree_id CHAR(4) PRIMARY KEY,
    degree_name VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL,
    department VARCHAR(255) NOT NULL,
    upper_credits INT NOT NULL,
    lower_credits INT NOT NULL, 
    elective_credits INT NOT NULL
);

-- Pursuing
CREATE TABLE Pursuing (
    student_id CHAR(9),
    degree_id CHAR(4),
    PRIMARY KEY (student_id, degree_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE,
    FOREIGN KEY (degree_id) REFERENCES Degree(degree_id) ON DELETE CASCADE
);

-- Faculty department
CREATE TABLE Faculty_department (
    name VARCHAR(255),
    department VARCHAR(255),
    PRIMARY KEY (name, department),
    FOREIGN KEY (name) REFERENCES Faculty(name) ON DELETE CASCADE
);

-- Course
CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    course_number VARCHAR(50) UNIQUE NOT NULL,
    department VARCHAR(255) NOT NULL,
    require_lab_work BOOLEAN NOT NULL,
    require_consent_of_instructor BOOLEAN NOT NULL
);

-- Course degree
CREATE TABLE Course_degree (
    course_id INT,
    degree_id CHAR(4),
    lower BOOLEAN NOT NULL,
    upper BOOLEAN NOT NULL,
    elective BOOLEAN NOT NULL,
    PRIMARY KEY (course_id, degree_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE,
    FOREIGN KEY (degree_id) REFERENCES Degree(degree_id) ON DELETE CASCADE
);

-- Concentration
CREATE TABLE Concentration (
    degree_id CHAR(4),
    concentration VARCHAR(50),
    course_id INT,
    PRIMARY KEY (degree_id, concentration, course_id),
    FOREIGN KEY (degree_id) REFERENCES Degree(degree_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE
);

-- Units
CREATE TABLE Units (
    course_id INT,
    unit INT,
    PRIMARY KEY (course_id, unit),
    FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE
);

-- Grade option
CREATE TABLE Grade_option (
    course_id INT,
    option VARCHAR(50),
    PRIMARY KEY (course_id, option),
    FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE
);

-- Prerequisite
CREATE TABLE Prerequisite (
    course_id INT,
    required_course_id INT,
    PRIMARY KEY (course_id, required_course_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE,
    FOREIGN KEY (required_course_id) REFERENCES Course(course_id) ON DELETE CASCADE
);

-- Class
CREATE TABLE Class (
    class_id SERIAL PRIMARY KEY,
    course_id INT NOT NULL,
    year INT NOT NULL,
    quarter VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE,
    UNIQUE (course_id, year, quarter, title) -- Ensures combination is unique, but doesn't burden the primary key
);

-- Teaching schedule
CREATE TABLE Teaching_schedule (
    name VARCHAR(255),
    class_id INT,
    section_id CHAR(3),
    PRIMARY KEY (name, class_id, section_id),
    FOREIGN KEY (name) REFERENCES Faculty(name) ON DELETE CASCADE,
    FOREIGN KEY (class_id, section_id) REFERENCES Section(class_id, section_id) ON DELETE CASCADE
);

-- Section
CREATE TABLE Section (
    section_id VARCHAR(3),
    class_id INT,
    professor VARCHAR(50) NOT NULL,
    enrollment_limit INT NOT NULL,
    PRIMARY KEY (section_id, class_id),
    FOREIGN KEY (class_id) REFERENCES Class(class_id) ON DELETE CASCADE,
    FOREIGN KEY (professor) REFERENCES Faculty(name) ON DELETE CASCADE
);

-- Student take class
CREATE TABLE Student_take_class (
    student_id CHAR(9),
    class_id INT,
    section_id CHAR(3),
    grade CHAR(2) NOT NULL,
    units INT NOT NULL,
    grade_option VARCHAR(10) NOT NULL,
    PRIMARY KEY (student_id, class_id, section_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE,
    FOREIGN KEY (class_id, section_id) REFERENCES Section(class_id, section_id) ON DELETE CASCADE
);

-- Enrollment
CREATE TABLE Enrollment (
    student_id CHAR(9),
    class_id INT,
    section_id CHAR(3),
    enrollment_type VARCHAR(50) NOT NULL,
    grading_option VARCHAR(50) NOT NULL,
    units INT NOT NULL,
    PRIMARY KEY (student_id, class_id, section_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE,
    FOREIGN KEY (class_id, section_id) REFERENCES Section(class_id, section_id) ON DELETE CASCADE
);

-- Meeting
CREATE TABLE Meeting (
    class_id INT,
    section_id CHAR(3),
    meeting_id SERIAL,
    type VARCHAR(50) NOT NULL,
    room VARCHAR(255) NOT NULL,
    building VARCHAR(255) NOT NULL,
    mandatory BOOLEAN NOT NULL,
    time_start TIME NOT NULL,
    time_end TIME NOT NULL,
    date_start DATE NOT NULL,
    date_end DATE NOT NULL,
    days_of_week VARCHAR(7) NOT NULL,
    PRIMARY KEY (class_id, section_id, meeting_id),
    FOREIGN KEY (class_id, section_id) REFERENCES Section(class_id, section_id) ON DELETE CASCADE
);

-- Review Session
CREATE TABLE Review_Session (
    class_id INT,
    section_id CHAR(3),
    review_session_id SERIAL,
    room VARCHAR(255) NOT NULL,
    building VARCHAR(255) NOT NULL,
    mandatory BOOLEAN NOT NULL,
    time_start TIME NOT NULL,
    time_end TIME NOT NULL,
    date DATE NOT NULL,
    PRIMARY KEY (class_id, section_id, review_session_id),
    FOREIGN KEY (class_id, section_id) REFERENCES Section(class_id, section_id) ON DELETE CASCADE
);

CREATE TABLE Student_Enrollment (
    student_id CHAR(9),
    quarter VARCHAR(20),
    year INT,
    PRIMARY KEY (student_id, quarter, year),
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE 
);

CREATE TABLE GRADE_CONVERSION(
    LETTER_GRADE CHAR(2) NOT NULL,
    NUMBER_GRADE DECIMAL(2,1)
);

-- 4.1: Trigger to check overlapping meetings
CREATE OR REPLACE FUNCTION check_overlapping_meetings() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Meeting
        WHERE class_id = NEW.class_id
        AND section_id = NEW.section_id
        AND ((NEW.time_start, NEW.time_end) OVERLAPS (time_start, time_end))
        AND (days_of_week LIKE '%' || NEW.days_of_week || '%'
             OR NEW.days_of_week LIKE '%' || days_of_week || '%')
        AND meeting_id != NEW.meeting_id
    ) THEN
        RAISE EXCEPTION 'Overlapping meetings of a section are not allowed';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_overlapping_meetings_trigger
BEFORE INSERT OR UPDATE ON Meeting
FOR EACH ROW EXECUTE PROCEDURE check_overlapping_meetings();

-- 4.2: Trigger to check enrollment limit in the Student_take_class table
CREATE OR REPLACE FUNCTION check_enrollment_limit()
RETURNS TRIGGER AS $$
DECLARE
    current_enrollments INT;
    max_limit INT;
BEGIN
    SELECT COUNT(*) INTO current_enrollments
    FROM Student_take_class
    WHERE class_id = NEW.class_id AND section_id = NEW.section_id;

    SELECT enrollment_limit INTO max_limit
    FROM Section
    WHERE class_id = NEW.class_id AND section_id = NEW.section_id;

    IF current_enrollments >= max_limit THEN
        RAISE EXCEPTION 'Enrollment limit of % for class %, section % has been reached. Enrollment rejected.', max_limit, NEW.class_id, NEW.section_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_enrollment_limit
BEFORE INSERT ON Student_take_class
FOR EACH ROW
EXECUTE PROCEDURE check_enrollment_limit();

-- 4.3: Trigger to check professor schedule
CREATE OR REPLACE FUNCTION check_professor_schedule() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Meeting AS M1
        JOIN Section AS S1 ON M1.class_id = S1.class_id AND M1.section_id = S1.section_id
        JOIN Section AS S2 ON S2.class_id = NEW.class_id AND S2.section_id = NEW.section_id
        WHERE S1.professor = S2.professor
        AND ((M1.time_start, M1.time_end) OVERLAPS (NEW.time_start, NEW.time_end))
        AND ((M1.date_start, M1.date_end) OVERLAPS (NEW.date_start, NEW.date_end))
        AND (M1.days_of_week LIKE '%' || NEW.days_of_week || '%'
             OR NEW.days_of_week LIKE '%' || M1.days_of_week || '%')
        AND M1.meeting_id != NEW.meeting_id
    ) THEN
        RAISE EXCEPTION 'A professor cannot have multiple sections at the same time';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_professor_schedule_trigger
BEFORE INSERT OR UPDATE ON Meeting
FOR EACH ROW EXECUTE PROCEDURE check_professor_schedule();

-- 5.1: CPQG view and trigger
CREATE MATERIALIZED VIEW CPQG AS
SELECT 
    c.course_id, s.professor, c.quarter, c.year, stc.grade, COUNT(*) as grade_count
FROM 
    Student_take_class stc
JOIN 
    Section s ON stc.section_id = s.section_id AND stc.class_id = s.class_id 
JOIN 
    Class c ON stc.class_id = c.class_id
GROUP BY 
    course_id, professor, quarter, year, grade;

-- Trigger to update CPQG view on insert
CREATE OR REPLACE FUNCTION update_CPQG() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO CPQG (course_id, professor, quarter, year, grade, grade_count)
    VALUES (
        (SELECT course_id FROM Class WHERE class_id = NEW.class_id),
        (SELECT professor FROM Section WHERE section_id = NEW.section_id AND class_id = NEW.class_id),
        (SELECT quarter FROM Class WHERE class_id = NEW.class_id),
		(SELECT year FROM Class WHERE class_id = NEW.class_id),
        NEW.grade,
        1
    )
    ON CONFLICT (course_id, professor, quarter, year, grade) DO UPDATE SET grade_count = CPQG.grade_count + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_CPQG
AFTER INSERT ON Student_take_class
FOR EACH ROW EXECUTE PROCEDURE update_CPQG();


-- 5.2: CPG view and trigger
CREATE MATERIALIZED VIEW CPG AS
SELECT 
    c.course_id, s.professor, stc.grade, COUNT(*) as grade_count
FROM 
    Student_take_class stc 
JOIN 
    Section s ON stc.section_id = s.section_id AND stc.class_id = s.class_id 
JOIN 
    Class c ON stc.class_id = c.class_id
GROUP BY 
    course_id, professor, grade;

CREATE OR REPLACE FUNCTION update_CPG() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO CPG (course_id, professor, grade, grade_count)
    VALUES (
        (SELECT course_id FROM Class WHERE class_id = NEW.class_id),
        (SELECT professor FROM Section WHERE section_id = NEW.section_id AND class_id = NEW.class_id),
        NEW.grade,
        1
    )
    ON CONFLICT (course_id, professor, grade) DO UPDATE SET grade_count = CPG.grade_count + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_CPG
AFTER INSERT ON Student_take_class
FOR EACH ROW EXECUTE PROCEDURE update_CPG();