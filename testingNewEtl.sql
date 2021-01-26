
create table if not exists pseudonym(
  psid varchar primary key,
  peid varchar not null unique
);

INSERT into pseudonym
  select distinct 'P'||random() psid, Id peid from patients_cov pc 
    union
  select distinct 'P'||random() psid, Id peid from patients_alle pa
    union
  select distinct 'E'||random() psid, Id peid from encounters_alle ea
    union
  select distinct 'E'||random() psid, Id peid from encounters_cov ec 
;

--gender

create table if not exists dimGender(
  genderId varchar primary key,
  genderName varchar not null
);

insert into dimGender
  values 
  ('M', 'Male'),
  ('F', 'Female');


create table if not exists dimCity(
  cityId integer primary key autoincrement,
  cityName varchar not null unique
);

delete from dimCity;
insert into dimCity(cityName)
  select distinct city from v_patients vp where city not like ''; 

 

--loinc
create table if not exists dimLoinc(
  loincCode varchar primary key,
  loincDescription varchar not null
);

delete from dimLoinc;
insert into dimLoinc 
select distinct code, description from(
  select distinct code, description FROM observations_alle oa 
    union
  select distinct code, description FROM observations_cov oc
) as loinc 
group by code
having max(LENGTH(description))
order by code
;


drop table if exists dimEthnicity;
create table if not exists dimEthnicity(
  ethnicityId varchar primary key,
  ethnicityName varchar not null unique
);

delete from dimEthnicity;
insert into dimEthnicity
  select DISTINCT substr(ethnicity, 1,3) , ethnicity from patients_alle where ethnicity not like ''
    union 
  select DISTINCT substr(ethnicity, 1,3) , ethnicity from patients_cov where ethnicity not like ''
;

CREATE table if not exists dimRace(
  raceId varchar primary key,
  raceName varchar not null unique
)
;

insert into dimRace
  select DISTINCT substr(race, 1,1), Race from patients_alle where Race not like ''
    UNION 
  select DISTINCT substr(race, 1,1), Race from patients_cov where Race not like '';
