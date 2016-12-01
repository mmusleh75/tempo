select case 
	when Type = 1 then 'In'
	else 'Out'
end as Type
,COUNT(1) 
from Message 
where CreateTime>='2014-01-01' and CreateTime <'2015-01-01' 
group by Type

-- in 11435
-- out 10769