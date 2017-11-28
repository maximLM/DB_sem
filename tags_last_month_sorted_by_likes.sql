SELECT TP.tag_id, TP.text, COUNT(*) AS cnt FROM
	(SELECT T.tag_id, T.post_id, T.text FROM
	(tags JOIN post_tag ON tags.id = post_tag.tag_id) AS T
	JOIN posts ON T.post_id = posts.id) AS TP
	JOIN post_likes ON TP.post_id = post_likes.post_id
WHERE EXTRACT(month FROM post_likes.created) = EXTRACT(month FROM current_date)
GROUP BY TP.tag_id, TP.text
ORDER BY  cnt DESC;