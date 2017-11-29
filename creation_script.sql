DROP TABLE IF EXISTS post_likes;
DROP TABLE IF EXISTS post_photo;
DROP TABLE IF EXISTS post_tag;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS styles;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS photo;
DROP TABLE IF EXISTS user_edit;

CREATE TABLE photo (
	id SERIAL PRIMARY KEY,
	url TEXT,
	created DATE
);

CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	login VARCHAR(50) NOT NULL,
	password VARCHAR(50) NOT NULL,
	photo_id INTEGER,
	created DATE,
	CONSTRAINT unique_login UNIQUE(login),
	FOREIGN KEY (photo_id) REFERENCES photo (id)
);
CREATE TABLE styles (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50),
	description TEXT,
	CONSTRAINT unique_name_of_style UNIQUE(name)
);
CREATE TABLE posts (
	id SERIAL PRIMARY KEY,
	text TEXT NOT NULL,
	user_id INTEGER NOT NULL,
	likes INTEGER DEFAULT 0,
	style_id INTEGER,
	created DATE,
	FOREIGN KEY (user_id) REFERENCES users (id),
	FOREIGN KEY (style_id) REFERENCES styles (id)
);

CREATE TABLE tags (
	id SERIAL PRIMARY KEY,
	text TEXT NOT NULL,
	created DATE,
	CONSTRAINT unique_text_of_tag UNIQUE(text)
);

CREATE TABLE comments (
	id SERIAL PRIMARY KEY,
	text TEXT NOT NULL,
	user_id INTEGER NOT NULL,
	post_id INTEGER NOT NULL,
	created DATE,
	FOREIGN KEY (user_id) REFERENCES users (id),
	FOREIGN KEY (post_id) REFERENCES posts (id)
);

CREATE TABLE post_tag (
	post_id INTEGER NOT NULL,
	tag_id INTEGER NOT NULL,
	CONSTRAINT unique_post_to_tag UNIQUE(post_id, tag_id),
	FOREIGN KEY (post_id) REFERENCES posts (id),
	FOREIGN KEY (tag_id) REFERENCES tags (id)
);

CREATE TABLE post_photo (
	post_id INTEGER NOT NULL,
	photo_id INTEGER NOT NULL,
	CONSTRAINT unique_post_to_photo UNIQUE(post_id, photo_id),
	FOREIGN KEY (post_id) REFERENCES posts (id),
	FOREIGN KEY (photo_id) REFERENCES photo (id)
);

CREATE TABLE post_likes (
	post_id INTEGER NOT NULL,
	user_id INTEGER NOT NULL,
	CONSTRAINT unique_user_to_post UNIQUE(post_id, user_id),
	FOREIGN KEY (post_id) REFERENCES posts (id),
	FOREIGN KEY (user_id) REFERENCES users (id),
	created DATE
);

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


CREATE TABLE user_edit (
	operation CHAR(1) NOT NULL,
	time TIMESTAMP NOT NULL,
	username_pg TEXT NOT NULL,
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	login VARCHAR(50) NOT NULL,
	password VARCHAR(50) NOT NULL,
	photo_id INTEGER,
	created DATE
);

CREATE OR REPLACE FUNCTION process_user_edit() RETURNS TRIGGER AS 
$$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		INSERT INTO user_edit SELECT 'D', now(), user, OLD.*;
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO user_edit SELECT 'U', now(), user, NEW.*;
		RETURN NEW;
	ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO user_edit SELECT 'I', now(), user, NEW.*;
		RETURN NEW;
	END IF;
	RETURN NULL; 
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER user_edit
AFTER INSERT OR UPDATE OR DELETE ON users
FOR EACH ROW EXECUTE PROCEDURE process_user_edit();