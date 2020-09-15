create table edu_prac(County_ID int NOT NULL,State varchar(255),County_Name varchar(255),l_hss int not null,hss int not null,ass_deg int not null,bach_deg int not null,primary key(County_ID));
alter table edu_prac add column ID int;
update edu_prac set ID=cast(County_ID as double);
alter table edu_prac drop column County_ID;
alter table edu_praedu_prac modify column ID int after State;
alter table edu_prac modify column State varchar(255) after ID;
create table edu_new as select ID,State,County_Name,edu,value from(select l_hss as value,'l_hss' as edu,ID,State,County_Name from edu_prac
union all select hss as value,'hss' as edu,ID,State,County_Name from edu_prac union all select ass_deg as value,'ass_deg'as edu,ID,State,County_name from edu_prac union all select bach_deg as value,'bach_deg' as edu,ID,State,County_Name from edu_prac) as temp order by ID asc;




