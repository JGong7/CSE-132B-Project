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
END;,
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