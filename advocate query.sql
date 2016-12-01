/*
select * from Company  where Company_Name like 'idaho%'

select c.* from INFORMATION_SCHEMA.COLUMNS c
inner join INFORMATION_SCHEMA.TABLES t
	on t.TABLE_NAME = c.TABLE_NAME
where c.COLUMN_NAME = 'company_id'
and t.TABLE_TYPE = 'BASE TABLE'
and c.TABLE_NAME like '%inc%'

select c.Company_Id, c.Company_Name, max(cr.Rn_Create_Date) as Rn_Create_Date
from PSI_Company_Reference cr
inner join PSI_RefDef rd
	on rd.PSI_RefDef_Id = cr.PSI_RefDef_Id
inner join Company c
	on c.Company_Id = cr.Company_Id
group by c.Company_Id, c.Company_Name
*/

select c.Company_Id, c.psi_company_id_code, c.company_name, rd.Short_Desc as reference_status, cr.Rn_Create_Date as ref_as_of_date
from PSI_Company_Reference cr
inner join PSI_RefDef rd
	on rd.PSI_RefDef_Id = cr.PSI_RefDef_Id
inner join Company c
	on c.Company_Id = cr.Company_Id
inner join (select c.Company_Id, c.Company_Name, max(cr.Rn_Create_Date) as Rn_Create_Date
	from PSI_Company_Reference cr
	inner join PSI_RefDef rd
		on rd.PSI_RefDef_Id = cr.PSI_RefDef_Id
	inner join Company c
		on c.Company_Id = cr.Company_Id
	group by c.Company_Id, c.Company_Name) maxd
	on maxd.Company_Id = c.Company_Id
	and maxd.Rn_Create_Date = cr.Rn_Create_Date
where ( rd.Short_Desc in ('Positive reference','Advocate')
--and c.Company_Name like '%Abay Neuroscience%'
	or c.psi_company_id_code in (5611,411,4124,9196,3050,5437,9020,423,265,1930,3085,418,680,557,71,107))
and c.Inactive = 0
order by rd.Short_Desc, c.Company_Name


