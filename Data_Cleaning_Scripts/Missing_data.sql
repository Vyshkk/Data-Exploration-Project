# Create table and load files
create table hp_new(County_ID varchar(255),Home_price varchar(255));
load data local infile 'Data/county_house_price.csv' into table hp_new fields terminated by ',' enclosed by '"' lines terminated by '\r' ignore 1 rows(County_ID,Home_price);
create table c_table(County_ID varchar(255) not null,County_Name varchar(255));
load data local infile 'Data/c_table.csv' into table c_table fields terminated by ',' lines terminated by '\r' ignore 1 rows(County_ID,County_Name);

# Delete rows from hp_new not present in c_table
delete from hp_new where County_ID not in(select c_table.County_ID from c_table);

# Find missing rows, present in c_table but not in hp_new
select c_table.County_ID from c_table where not exists(select hp_new.County_ID from hp_new where c_table.County_ID=hp_new.County_ID);

# Insert missing values from c_table to hp_new
insert into hp_new select  c_table.County_ID,'NULL' from c_table left join hp_new on c_table.County_ID = hp_new.County_ID where hp_new.County_ID is null;
##select * from hp_new;

# Convert County_ID to int for both c_table and hp_new
alter table hp_new add column ID int;
update hp_new set ID=cast(County_ID as double);
alter table hp_new drop column County_ID;
alter table c_table add column ID int;
update c_table set ID=cast(c_table.County_ID as double);
alter table c_table drop column County_ID;

# Replace null values with 0
update hp_new set Home_price=0 where Home_price='NULL';
# Remove $ sign from Home_price
update hp_new set Home_price=right(Home_price,length(Home_price)-1) where Home_price!='0';
# Remove comma from Home_price
update hp_new set Home_price=replace(Home_price,',','');
# Convert Home_price column to int
alter table hp_new add column h_price int;
update hp_new set h_price=cast(hp_new.Home_price as double);
alter table hp_new drop column Home_price;

# Add county_Name to hp_new
alter table hp_new add column County_name varchar(255);
update hp_new inner join c_table on hp_new.ID=c_table.ID set hp_new.County_Name=c_table.County_Name;

# Change position of County_name column
alter table hp_new modify County_Name varchar(255) after ID;

select * from hp_new;

