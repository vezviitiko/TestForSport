select a.id_obj, COALESCE(SUM(a.d) OVER (Partition BY gs::date,id_obj ORDER BY gs::date), 0) AS SUM, 
gs::date from 
generate_series('01.01.2020', '31.01.2020', interval '1 day') as gs
left join (
select id_obj, COALESCE(("AMOUNT") , 0) as d,gsq::date
--select id_obj, "ART", COALESCE("AMOUNT", 0) AS SUM, gs::date
from generate_series('01.01.2020', '31.01.2020', interval '1 day') as gsq
	join n_daily_rests
	on gsq::date between "DATEBEGIN" and "DATEEND"
	order by gsq) a
	on gs::date = a.gsq::date
