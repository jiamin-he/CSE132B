with tmp as (select * 
from (select s.ssn, s.firstname, s.middlename, s.lastname , ccc.name, sum(ce.units) as sum_major_category_units
from student as s
,undergraduate as u
,classes_taken_in_the_past as ce
,course as co
,degree_requirements as d
,department as dp
,course_category_conversion as ccc 
-- right outer join course_categories as cc on ccc.name = cc.course_category
where s.student_id = u.student_id
	and s.ssn  = 7 -- input X
	and s.student_id = ce.student_id
	and dp.department_name = 'Mechanical Engineering' -- input Y
	and d.cur_degree = 'B.S.'
	and d.department_id = dp.department_id
	-- and cc.degree_id = d.degree_id
	and ce.course_id = ccc.course_id
	-- and ccc.name = cc.course_category
	and co.department_id = d.department_id
	and co.course_id = ce.course_id
group by s.ssn, s.firstname, s.middlename, s.lastname , ccc.name --,cc.course_category, cc.degree_id
) as sub right outer join
(select * from
course_categories as cc --on cc.course_category = sub.name
-- join student as ss on ss.ssn = sub.ssn
,department as dpp
,degree_requirements as dd -- on dpp.department_id = dd.department_id
where dpp.department_name = 'Computer Science' -- input Y
and dd.cur_degree = 'B.S.'
and dpp.department_id = dd.department_id
and cc.degree_id = dd.degree_id) as cc1 on sub.name = cc1.course_category)
--select * from tmp
select ssn,firstname,middlename,lastname,course_category, min_units,coalesce(sum_major_category_units,0) as sum_major_category_units, units_required from
(select distinct(ssn), firstname, middlename, lastname
from tmp
where ssn is not null) as t1,
((select course_category, min_units, sum_major_category_units, (min_units-sum_major_category_units) as units_required 
from tmp 
where name = course_category)
union
(select course_category, min_units, sum_major_category_units, min_units as units_required
from tmp 
where name is null)) as t2