-----------------------------------------
--- Task 1 ------------------------------
-----------------------------------------
-- решение через представление

CREATE VIEW dat AS (select gs::date from generate_series('2020-01-01', '2020-01-31', interval '1 day') as gs);
SELECT d.gs, COALESCE(sum(amount),0) as sm 
	FROM dat d LEFT JOIN n_daily_rests n 
		ON d.gs >= n.datebegin 
		AND d.gs < n.dateend 
		AND n.id_obj IN (171, 172, 174) 
	GROUP BY d.gs ORDER BY d.gs;

-- решение одним запросом

SELECT d.gs, COALESCE(sum(amount),0) as sm FROM 
	(select gs::date 
	 from generate_series('2020-01-01', '2020-01-31', interval '1 day') as gs) d 
	 LEFT JOIN n_daily_rests n 
	 	ON d.gs >= n.datebegin 
		AND d.gs < n.dateend 
	 	AND n.id_obj IN (171, 172, 174) 
	 GROUP BY d.gs ORDER BY d.gs;
	
-----------------------------------------
--- Task 2 ------------------------------
-----------------------------------------

CREATE VIEW bb AS (SELECT d.gs, n.id_obj, n.art, n.datebegin, n.dateend, n.amount, a.category 
		   FROM (select gs::date from generate_series('2020-01-01', '2020-01-31', interval '1 day') as gs) d 
		   LEFT JOIN n_daily_rests n 
		   	ON d.gs >= n.datebegin 
		   	AND d.gs < n.dateend 
		   LEFT JOIN art_category a 
		   	ON a.art = n.art 
		   ORDER BY d.gs);

CREATE VIEW ee AS (SELECT gs, id_obj, category, COUNT(DISTINCT art) 
		   FROM bb 
		   WHERE category = 'Футболки' 
		   GROUP BY gs, id_obj, category);

CREATE VIEW yy AS (SELECT gs, id_obj, category, COUNT(DISTINCT art) 
		   FROM bb 
		   WHERE category = 'Обувь' 
		   GROUP BY gs, id_obj, category);

CREATE VIEW dd AS (SELECT b.gs, b.id_obj, b.art, b.amount, b.category, e.count 
		   FROM bb b JOIN ee e 
		   ON e.gs = b.gs 
		   AND e.id_obj = b.id_obj 
		   AND e.category = b.category
UNION
SELECT b.gs, b.id_obj, b.art, b.amount, b.category, y.count 
		   FROM bb b JOIN yy y 
		   ON y.gs = b.gs 
		   AND y.id_obj = b.id_obj 
		   AND y.category = b.category);

CREATE VIEW kk AS (SELECT d.gs, d.id_obj, d.amount, d.category as category1, d.count 
		   AS count1, h.category as category2, h.count AS count2 
		   FROM dd d JOIN dd h 
		   ON d.gs = h.gs 
		   AND d.id_obj = h.id_obj 
		   AND d.category <> h.category);

CREATE VIEW itog AS (SELECT a1.gs, a1.id_obj, a1.sm FROM 
		     (SELECT d.gs, n.id_obj, COALESCE(sum(amount),0) as sm 
		      FROM (select gs::date from generate_series('2020-01-01', '2020-01-31', interval '1 day') as gs) d 
		      LEFT JOIN n_daily_rests n 
		      	ON d.gs >= n.datebegin 
		      	AND d.gs < n.dateend 
		      GROUP BY d.gs, n.id_obj ORDER BY d.gs) a1 
		     JOIN (SELECT gs, id_obj FROM kk 
			   WHERE category1 = 'Футболки' 
			   AND count1 > 1 
			   AND category2 = 'Обувь' 
			   AND count2 > 0 
			   GROUP BY gs, id_obj) a2 
		     ON a1.gs=a2.gs 
		     AND a1.id_obj=a2.id_obj 
		     WHERE a2.id_obj IS NOT NULL);

SELECT gs, id_obj FROM (SELECT i.gs, i.id_obj, i.sm, 
			DENSE_RANK() OVER(PARTITION BY i.gs ORDER BY i.sm DESC) as ds 
			FROM itog i) h 
			WHERE ds = 3;


