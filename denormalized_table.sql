DROP TABLE IF EXISTS posts_with_tags;
CREATE TABLE posts_with_tags AS 
	SELECT PT.post_id, PT.text, PT.tag_id, PT.user_id, PT.created FROM 
	(posts JOIN post_tag ON posts.id = post_tag.tag_id) AS PT
	JOIN tags ON tags.id = PT.tag_id;
TRUNCATE TABLE posts_with_tags;

CREATE OR REPLACE FUNCTION fill_denormalized_table()
	RETURNS TABLE(a INTEGER,b TEXT,c INTEGER,d INTEGER,e DATE) AS 
$$
BEGIN
	INSERT INTO posts_with_tags 
	SELECT PT.post_id, PT.text, PT.tag_id, PT.user_id, PT.created FROM 
	(posts JOIN post_tag ON posts.id = post_tag.tag_id) AS PT
	JOIN tags ON tags.id = PT.tag_id;
	RETURN QUERY SELECT * FROM posts_with_tags;
END;
$$ LANGUAGE plpgsql;
