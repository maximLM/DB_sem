DROP TABLE IF EXISTS post_likes;
DROP TABLE IF EXISTS post_photo;
DROP TABLE IF EXISTS post_tag;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS styles;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS photo;

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