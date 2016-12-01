/*
select t.*, c.column_name 
from information_schema.columns c
inner join information_schema.tables t
	on t.table_name = c.table_name
where c.column_name like '%version%'

select t.*
from information_schema.tables t
where t.table_name like '%support_in%'
*/

select distinct 
c.company_name
,case
	when c.inactive = 0 then 'Active'
	else 'Inactive'
end as client_status
,(select top 1 rtrim(ltrim(substring(iv.rn_descriptor, 10, 10)))
	from PSI_VGI iv
	where iv.company_id = c.company_id
	and iv.rn_descriptor like 'PulsePro%'
	order by iv.install_date desc) latest_installed_version
,si.support_incident_code SI
,si.status_text SI_Status
,si.PSI_Jira_Issue_id JIRA
,si.PSI_Jira_Status
,rtrim(ltrim(substring(v.rn_descriptor, 12, len(v.rn_descriptor)))) reported_version
--,v.rn_descriptor as reported_version

from  company c
inner join Support_Incident si
	on si.company_id = c.company_id
inner join PSI_VGN v
	on v.PSI_VGN_id = si.PSI_VGN_id

where si.PSI_Jira_Issue_id like 'PLS%'
and si.PSI_Jira_Status not in ('Closed','Pending Deployment','QA Pass')
and si.status_text != 'Closed Incident'
--and si.support_incident_code = 651069

/*
select top 1 iv.rn_descriptor, iv.install_date
from PSI_VGI iv
where iv.company_id = 0x00000000000001A2 
and iv.rn_descriptor like 'PulsePro%'
order by iv.install_date desc

select * from company where rn_descriptor like 'jewish%'

*/