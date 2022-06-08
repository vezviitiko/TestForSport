-- Task 1

select SUM(COALESCE("AMOUNT",0)) AS SUM, date::date
from generate_series('01.01.2020', '31.01.2020', interval '1 day') as date
	left join n_daily_rests 
	on date::date between "DATEBEGIN" and "DATEEND" 
	where id_obj in (171,172,174)
	group by date
	order by date

-- Task 2
