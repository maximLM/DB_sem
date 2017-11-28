CREATE OR REPLACE FUNCTION like_trigger() RETURNS trigger AS 
$$
    BEGIN
	UPDATE posts SET likes = (
	(SELECT likes FROM posts WHERE id = NEW.post_id) + 1
	)
	WHERE id = NEW.post_id;
	RETURN NEW;
    END;
$$ LANGUAGE plpgsql;
DROP TRIGGER IF EXISTS like_trigger ON post_likes;
CREATE TRIGGER like_trigger BEFORE INSERT ON post_likes
FOR EACH ROW EXECUTE PROCEDURE like_trigger();