use Healthcare;
select * from [dbo].[healthcare_dataset];

select count(*) from healthcare_dataset

--Data Cleaning:-

-- Check for outliers
SELECT * FROM healthcare_dataset
WHERE Age < 0 OR Age > 120;

SELECT * FROM healthcare_dataset
WHERE Billing_Amount < 0;



--Handling null values
select * from healthcare_dataset 
where Name is null
or
Age is null
or
Gender is null
or
Blood_Type is null
or
Medical_Condition is null
or
Date_of_Admission is null
or
Doctor is null
or 
Hospital is null
or
Insurance_Provider is null 
or 
Billing_Amount is null
or
Room_Number is null
or
Admission_Type is null
or 
Discharge_Date is null
or 
Medication is null
or
Test_Results is null

--Checking for other possible gender values. 
select distinct Gender from healthcare_dataset

-- Step 1: Add PatientID column
ALTER TABLE healthcare_dataset
ADD PatientID INT;

-- Step 2: Update PatientID using stable fields
UPDATE healthcare_dataset
SET PatientID = sub.PatientRank
FROM (
    SELECT 
        DENSE_RANK() OVER (
            ORDER BY Name, Gender, [Blood_Type]
        ) AS PatientRank,
        Name,
        Gender,
        [Blood_Type]
    FROM healthcare_dataset
) AS sub
WHERE 
    healthcare_dataset.Name = sub.Name AND
    healthcare_dataset.Gender = sub.Gender AND
    healthcare_dataset.[Blood_Type] = sub.[Blood_Type];


--changing data type:
ALTER TABLE healthcare_dataset
ALTER COLUMN [Billing_Amount] DECIMAL(18,2);

--changing data type:
ALTER TABLE healthcare_dataset
ALTER COLUMN [Age] Int;

--1.Total number of Admission:
select count(distinct PatientID) as Total_Admission from healthcare_dataset;

--2.Total revenue of the Hospital:
select sum(Billing_Amount) as Total_Revenue from healthcare_dataset;

--3. Top 5 Doctors by Number of Patients
SELECT top 5 Doctor, COUNT(Distinct PatientID) AS TotalPatients
FROM healthcare_dataset
GROUP BY Doctor
ORDER BY TotalPatients DESC;

--4. What are the most common medical conditions?
select Top 3 Medical_condition, count(Medical_condition) as case_count
from healthcare_dataset 
group by Medical_Condition
order by case_count desc;

--5. Which hospital handle the highest billing amount?
select Top 1 Hospital,sum(Billing_Amount) as Highest_billing_amnt
from healthcare_dataset
Group by Hospital
order by Highest_billing_amnt desc;

--6.Which medications are most frequently used?
select Medication, count(Medication) as frequent_medication
from healthcare_dataset
group by Medication 
order by frequent_medication desc;

--7.Patient Readmission Analysis
SELECT Name, COUNT(PatientID) AS AdmissionCount, 
       MIN([Date_of_Admission]) AS FirstAdmission,
       MAX([Date_of_Admission]) AS LastAdmission
FROM healthcare_dataset
GROUP BY Name
HAVING COUNT(PatientID) > 1
ORDER BY AdmissionCount DESC;

--8. Most Common Conditions (for Age > 60
SELECT Medical_Condition, COUNT(PatientID) AS PatientCount
FROM healthcare_dataset
WHERE Age > 60
GROUP BY Medical_Condition
ORDER BY PatientCount DESC;

--9.Top Insurance Providers by Patient Volume
select Insurance_provider,count(PatientID) as no_of_patients
from healthcare_dataset
group by Insurance_provider
order by no_of_patients desc;

--10.Age group distribution
SELECT 
  CASE 
    WHEN Age BETWEEN 0 AND 18 THEN '0-18'
    WHEN Age BETWEEN 19 AND 35 THEN '19-35'
    WHEN Age BETWEEN 36 AND 60 THEN '36-60'
    ELSE '60+'
  END AS Age_Group,
  COUNT(PatientID) AS Total
FROM healthcare_dataset
GROUP BY 
  CASE 
    WHEN Age BETWEEN 0 AND 18 THEN '0-18'
    WHEN Age BETWEEN 19 AND 35 THEN '19-35'
    WHEN Age BETWEEN 36 AND 60 THEN '36-60'
    ELSE '60+'
  END
  order by Total desc;

select * from [dbo].[healthcare_dataset]

--11.Do males or females get admitted more often?
select Gender, count(Gender) as count_case
from healthcare_dataset
group by Gender

--12.Length of stay Analysis
SELECT PatientID,DATEDIFF(DAY, Date_of_Admission, Discharge_Date) AS Length_of_Stay
FROM healthcare_dataset
WHERE Discharge_Date IS NOT NULL
order by Length_of_Stay desc;
