CREATE OR REPLACE VIEW most_liked_users_by_month AS
WITH CNT AS (
	SELECT CNT.user_id, CNT.login, COUNT(*) AS cnt, extract(year from CNT.created) AS year, extract (month from CNT.created) AS month FROM
	(SELECT PU.user_id, PU.login, post_likes.created FROM
		(
		SELECT posts.user_id, users.login, posts.id FROM
		users JOIN posts ON posts.user_id = users.id
		) AS PU
		JOIN post_likes ON PU.id = post_likes.post_id ORDER BY PU.user_id ASC
	)
	AS CNT GROUP BY year, month, CNT.user_id, CNT.login
)
SELECT CNT.user_id, CNT.login, CNT.cnt, CNT.month, CNT.year FROM
(SELECT CNT.month, MAX(CNT.cnt) AS cnt, CNT.year FROM 
CNT GROUP BY CNT.month, CNT.year) AS A
JOIN CNT ON A.year = CNT.year AND A.month = CNT.month AND A.cnt = CNT.cnt ORDER BY CNT.year DESC, CNT.month DESC;