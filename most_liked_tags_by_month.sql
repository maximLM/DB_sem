CREATE OR REPLACE VIEW most_liked_tags_by_month AS
WITH CNT AS (
	SELECT CNT.user_id, CNT.login, COUNT(*) AS cnt, extract(year from CNT.created) AS year, extract (month from CNT.created) AS month FROM
	(SELECT PU.user_id, PU.login, post_likes.created FROM
		(
		SELECT T.tag_id AS user_id, T.text AS login, T.post_id AS id FROM (tags JOIN post_tag ON tags.id = post_tag.tag_id) AS T
		JOIN posts ON T.post_id =  posts.id
		) AS PU
		JOIN post_likes ON PU.id = post_likes.post_id
	)
	AS CNT GROUP BY year, month, CNT.user_id, CNT.login
)
SELECT CNT.user_id AS tag_id, CNT.login AS text, CNT.cnt, CNT.month, CNT.year FROM
(SELECT CNT.month, MAX(CNT.cnt) AS cnt, CNT.year FROM 
CNT GROUP BY CNT.month, CNT.year) AS A
JOIN CNT ON A.year = CNT.year AND A.month = CNT.month AND A.cnt = CNT.cnt ORDER BY CNT.year DESC, CNT.month DESC;