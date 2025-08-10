

with date as (
 select EmpID, 
       date_add(DateofTermination, INTERVAL 6 year) as DateofTermination,
       date_add(DateofHire, INTERVAL 6 year) as DateofHire
 from hr.hr_dataset
),
termReason as (
  select EmpID,
    CASE WHEN termReason = 'N/A-StillEmployed' then null
         WHEN termReason = 'career change' or termReason = 'Another position' then 'Career change'
         WHEN termReason = 'hours' or termReason = 'return to school' then 'Scheduling'
         WHEN termReason = 'unhappy' then 'Job Dissatisfaction'
         WHEN termReason = 'attendance' or termReason = 'performance' then 'Attendance/Performance'
         WHEN termReason = 'more money' then 'Paid Issue'
         when TermReason = 'No-call, no-show' then 'Not showing up'
         WHEN termReason in ( 'military', 'Fatal attraction', 'maternity leave - did not return') then 'Personal Reasons'
         ELSE concat(upper(left(termReason,1)), SUBSTRING(termReason, 2))
    END AS termReason
  from hr.hr_dataset
),
Termd as (
  select EmpID,
         CASE WHEN Termd = '0' then 'Active'
              WHEN Termd = '1' then 'Terminated'
		 END AS Termd
  from hr.hr_dataset
),
manager as (
  SELECT EmpID,
         CASE WHEN managerID is null then 8
         ELSE managerID
         END as managerID
  FROM hr.hr_dataset
),
department as (
  SELECT distinct department,
       CASE 
         WHEN department = 'Software Engineering'  then 4
         WHEN department = 'Production' then 5
		 ELSE DeptID end as DeptID
  from hr.hr_dataset
)
select h.EmpID,  
       m.ManagerID,
       de.DeptID,
       Salary,
       d.DateofHire,
       d.DateofTermination,
       r.termReason,
       t.Termd,
       PerformanceScore,
       EngagementSurvey,
       EmpSatisfaction,
       SpecialProjectsCount,
       date(LastPerformanceReview_Date) as Last_Performance_Review,
       Absences
from hr.hr_dataset h
join date d on h.EmpID = d.EmpID
join termReason r on h.EmpID = r.EmpID
join termd t on h.EmpID = t.EmpID
join manager m on h.empID = m.empID
join department de on h.department = de.department;

with employee as (
 select empID, Employee_name,
        substring_index(employee_name,',',-1) as firstName,
        substring_index(employee_name, ',' , 1) as lastName,
       concat(substring_index(TRIM(employee_name),',',-1), ' ', substring_index(TRIM(employee_name), ',' , 1)) as fullName
 from hr.hr_dataset),
sex as (
  select EmpID,
    CASE WHEN Sex = 'M' then 'Male'
		 WHEN Sex = 'F' then 'Female'
    END AS sex
  FROM hr.hr_dataset
),
dob as (
select EmpID,
      date(date_add(dob, INTERVAL 6 year)) as dob
 from hr.hr_dataset
 ),
correct_dob as (
SELECT empid,
    CASE 
      WHEN YEAR(dob) > YEAR(CURDATE())
        THEN DATE_SUB(dob, INTERVAL 100 YEAR)
      ELSE dob
    END AS correct_dob
  FROM dob
 ),
 age as (
   select EmpID,
          2024 - year(correct_dob) as age
   from correct_dob
 ) 
select h.EmpID, 
       e.firstName, 
       e.lastName, 
       h.position, 
       state,
       zip,
       c.correct_dob,
       a.age,
       s.sex,
       maritalDesc as marital,
       citizenDesc as citizen,
       raceDEsc as race,
       hispanicLatino
       from hr.hr_dataset h
join employee e on h.empID = e.EmpID
join sex s on h.EmpID = s.EmpID
join dob d on h.empID = d.EmpID
join age a on h.empID = a.empID
join correct_dob c on h.empID = c.empID;

SELECT distinct ManagerName,
	   CASE WHEN managerID is null then 8
	   ELSE managerID
	   END as managerID
  FROM hr.hr_dataset
  order by managerID;
  
SELECT distinct department,
       CASE 
         WHEN department = 'Software Engineering'  then 4
         WHEN department = 'Production' then 5
		 ELSE DeptID end as DeptID
from hr.hr_dataset
order by DeptID;

select empid, date(dateofHire), date(dateofTermination)
from hr.hr_dataset
where empid = '10268';

with date as(
SELECT
  date_add(DateofHire, INTERVAL 6 year) AS EventDate,
  EmpID,
  'Active' AS EventType
FROM hr.hr_dataset
WHERE DateOfHire IS NOT NULL

UNION ALL

SELECT
  date_add(DateofTermination, INTERVAL 6 year) AS EventDate,
  EmpID,
  'Terminated' AS EventType
FROM hr.hr_dataset
WHERE DateOfTermination IS NOT NULL

order by EventDate
)
select eventDate, EmpID, eventType
from date;

SELECT dob FROM hr.hr_dataset LIMIT 10;

with employee as (
 select empID,
       department,
       concat(substring_index(TRIM(employee_name),',',-1), ' ', substring_index(TRIM(employee_name), ',' , 1)) as fullName,
       TRIM(SUBSTRING_INDEX(TRIM(employee_name), ',', -1)) as firstName,
	   substring_index(employee_name, ',' , 1) as lastName
 from hr.hr_dataset)
select empid, firstName, lastName, department
from employee;






