-- Task 1
-- решение через представление(более понятно и проще разобраться)

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
	 
-- Task 2
