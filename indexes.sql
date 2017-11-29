--DROP INDEX kek;
CREATE INDEX posts_user_id ON posts ((user_id));
CREATE INDEX comments_post_id ON comments (post_id);
CREATE INDEX tags_txt ON tags(text);
CREATE INDEX post_tags ON post_tag(post_id);