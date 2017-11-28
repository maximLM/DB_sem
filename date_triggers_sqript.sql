CREATE OR REPLACE FUNCTION set_current_date() RETURNS trigger AS 
$$
    BEGIN
	IF NEW.created is NULL THEN
		NEW.created = current_date;
	END IF;
	RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER created_date BEFORE INSERT ON users
FOR EACH ROW EXECUTE PROCEDURE set_current_date();

CREATE TRIGGER created_date BEFORE INSERT ON posts
FOR EACH ROW EXECUTE PROCEDURE set_current_date();

CREATE TRIGGER created_date BEFORE INSERT ON tags
FOR EACH ROW EXECUTE PROCEDURE set_current_date();

CREATE TRIGGER created_date BEFORE INSERT ON comments
FOR EACH ROW EXECUTE PROCEDURE set_current_date();

CREATE TRIGGER created_date BEFORE INSERT ON post_likes
FOR EACH ROW EXECUTE PROCEDURE set_current_date();

CREATE TRIGGER created_date BEFORE INSERT ON photo
FOR EACH ROW EXECUTE PROCEDURE set_current_date();