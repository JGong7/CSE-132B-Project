-- 5.1: CPQG table and trigger
CREATE TABLE CPQG (
    course_id INT,
    professor VARCHAR(50),
    quarter VARCHAR(50),
    year INT,
    grade CHAR(2),
    grade_count INT,
    PRIMARY KEY (course_id, professor, quarter, year, grade), 
    FOREIGN KEY (professor) REFERENCES Faculty(name) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE
);

-- Initialize CPQG view
INSERT INTO CPQG (course_id, professor, quarter, year, grade, grade_count)
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

CREATE OR REPLACE FUNCTION update_CPQG_on_update() RETURNS TRIGGER AS $$
BEGIN
    -- Decrease the count for the old grade
    UPDATE CPQG SET grade_count = grade_count - 1
    WHERE course_id = (SELECT course_id FROM Class WHERE class_id = OLD.class_id)
    AND professor = (SELECT professor FROM Section WHERE section_id = OLD.section_id AND class_id = OLD.class_id)
    AND grade = OLD.grade
    AND quarter = (SELECT quarter FROM Class WHERE class_id = OLD.class_id)
    AND year = (SELECT year FROM Class WHERE class_id = OLD.class_id);

    -- Increase the count for the new grade
    WITH new_row AS (
        UPDATE CPQG SET grade_count = grade_count + 1
        WHERE course_id = (SELECT course_id FROM Class WHERE class_id = NEW.class_id)
        AND professor = (SELECT professor FROM Section WHERE section_id = NEW.section_id AND class_id = NEW.class_id)
        AND grade = NEW.grade
        AND quarter = (SELECT quarter FROM Class WHERE class_id = NEW.class_id)
        AND year = (SELECT year FROM Class WHERE class_id = NEW.class_id)
        RETURNING *
    )
    INSERT INTO CPQG (course_id, professor, grade, quarter, year, grade_count)
    SELECT 
        (SELECT course_id FROM Class WHERE class_id = NEW.class_id),
        (SELECT professor FROM Section WHERE section_id = NEW.section_id AND class_id = NEW.class_id),
        NEW.grade,
        (SELECT quarter FROM Class WHERE class_id = NEW.class_id),
        (SELECT year FROM Class WHERE class_id = NEW.class_id),
        1
    WHERE NOT EXISTS (SELECT * FROM new_row);

    DELETE FROM CPQG
    WHERE grade_count = 0;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_CPQG_on_update
AFTER UPDATE ON Student_take_class
FOR EACH ROW EXECUTE PROCEDURE update_CPQG_on_update();

-- 5.2: CPG view and trigger
CREATE TABLE CPG (
    course_id INT,
    professor VARCHAR(50),
    grade CHAR(2),
    grade_count INT,
    PRIMARY KEY (course_id, professor, grade),
    FOREIGN KEY (professor) REFERENCES Faculty(name) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE
);

-- Initialize CPG view
INSERT INTO CPG (course_id, professor, grade, grade_count)
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

-- Trigger to update CPG view on insert
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

-- Trigger to update CPG view on update
CREATE OR REPLACE FUNCTION update_CPG_on_update() RETURNS TRIGGER AS $$
BEGIN
    -- Decrease the count for the old grade
    UPDATE CPG SET grade_count = grade_count - 1
    WHERE course_id = (SELECT course_id FROM Class WHERE class_id = OLD.class_id)
    AND professor = (SELECT professor FROM Section WHERE section_id = OLD.section_id AND class_id = OLD.class_id)
    AND grade = OLD.grade;

    -- Increase the count for the new grade
    WITH new_row AS (
        UPDATE CPG SET grade_count = grade_count + 1
        WHERE course_id = (SELECT course_id FROM Class WHERE class_id = NEW.class_id)
        AND professor = (SELECT professor FROM Section WHERE section_id = NEW.section_id AND class_id = NEW.class_id)
        AND grade = NEW.grade
        RETURNING *
    )
    INSERT INTO CPG (course_id, professor, grade, grade_count)
    SELECT 
        (SELECT course_id FROM Class WHERE class_id = NEW.class_id),
        (SELECT professor FROM Section WHERE section_id = NEW.section_id AND class_id = NEW.class_id),
        NEW.grade,
        1
    WHERE NOT EXISTS (SELECT * FROM new_row);
    
    DELETE FROM CPG
    WHERE grade_count = 0;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER update_CPG_on_update
AFTER UPDATE ON Student_take_class
FOR EACH ROW EXECUTE PROCEDURE update_CPG_on_update();
