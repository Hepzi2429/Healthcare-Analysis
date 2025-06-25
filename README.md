# 📊 Healthcare Dataset SQL Analysis

## 🗂️ Dataset Overview

The `healthcare_dataset` contains structured patient-level data collected from one or more hospitals. It includes information such as demographics, medical conditions, admission/discharge details, assigned doctors, billing amounts, and insurance coverage. Each row represents a unique patient visit.

This dataset supports the analysis of hospital operations, revenue trends, doctor performance, readmissions, and insurance usage.

## 🎯 Purpose of Analysis

* Identify trends in patient admissions and medical conditions
* Analyze hospital revenue and billing accuracy
* Evaluate doctor and insurance provider performance
* Understand demographic patterns (age, gender)
* Detect and resolve data quality issues (e.g., NULLs, outliers)

## 🔍 Dataset Summary

* **Total Rows**: 55,500 — a relatively large dataset
* **Null Check**: All missing values have been handled
* **Outlier Check**:

  * **Age**: No outliers found
  * **Billing Amount**: 108 negative values identified as outliers and replaced with the average billing amount


## 📈 SQL Analysis – Questions & Queries with Solutions

Each query below is followed by a brief explanation of its significance in a real-world healthcare data context.

**Q1: What is the total number of admissions?**

```sql
SELECT COUNT(DISTINCT PatientID) AS Total_Admission FROM healthcare_dataset;
```

**Solution**: This identifies the number of unique patients admitted. Useful for hospital capacity planning.

**Q2: What is the total revenue of the hospital?**

```sql
SELECT SUM(Billing_Amount) AS Total_Revenue FROM healthcare_dataset;
```

**Solution**: Calculates overall revenue. Key for financial reporting and budgeting.

**Q3: Who are the top 5 doctors by number of patients?**

```sql
SELECT TOP 5 Doctor, COUNT(DISTINCT PatientID) AS TotalPatients
FROM healthcare_dataset
GROUP BY Doctor
ORDER BY TotalPatients DESC;
```

**Solution**: Highlights the busiest or most trusted doctors. Helps in resource allocation.

**Q4: What are the most common medical conditions?**

```sql
SELECT TOP 3 Medical_Condition, COUNT(*) AS Case_Count
FROM healthcare_dataset
GROUP BY Medical_Condition
ORDER BY Case_Count DESC;
```

**Solution**: Identifies top diagnoses. Useful for stocking medication and preventive care programs.

**Q5: Which hospital has the highest billing amount?**

```sql
SELECT TOP 1 Hospital, SUM(Billing_Amount) AS Highest_Billing
FROM healthcare_dataset
GROUP BY Hospital
ORDER BY Highest_Billing DESC;
```

**Solution**: Determines which hospital generates the most revenue.

**Q6: Which medications are most frequently used?**

```sql
SELECT Medication, COUNT(*) AS Frequency
FROM healthcare_dataset
GROUP BY Medication
ORDER BY Frequency DESC;
```

**Solution**: Tracks the most prescribed drugs, helping pharmacy management.

**Q7: Which patients were readmitted multiple times?**

```sql
SELECT Name, COUNT(PatientID) AS AdmissionCount,
       MIN(Date_of_Admission) AS FirstAdmission,
       MAX(Date_of_Admission) AS LastAdmission
FROM healthcare_dataset
GROUP BY Name
HAVING COUNT(PatientID) > 1
ORDER BY AdmissionCount DESC;
```

**Solution**: Detects patients with frequent admissions, indicating chronic conditions or quality of care issues.

**Q8: What are the most common conditions among patients over 60?**

```sql
SELECT Medical_Condition, COUNT(PatientID) AS PatientCount
FROM healthcare_dataset
WHERE Age > 60
GROUP BY Medical_Condition
ORDER BY PatientCount DESC;
```

**Solution**: Helps target elderly care programs and tailor specialized services.

**Q9: Which insurance providers cover the most patients?**

```sql
SELECT Insurance_Provider, COUNT(PatientID) AS PatientCount
FROM healthcare_dataset
GROUP BY Insurance_Provider
ORDER BY PatientCount DESC;
```

**Solution**: Indicates market share of insurance companies. Useful for negotiations.

**Q10: What is the distribution of patients by age group?**

```sql
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
ORDER BY Total DESC;
```

**Solution**: Shows which age segments form the bulk of hospital visits.

**Q11: Do males or females get admitted more often?**

```sql
SELECT Gender, COUNT(Gender) AS Count
FROM healthcare_dataset
GROUP BY Gender;
```

**Solution**: Gender distribution analysis supports gender-specific health program planning.

**Q12: What is the length of stay for each patient?**

```sql
SELECT PatientID, DATEDIFF(DAY, Date_of_Admission, Discharge_Date) AS Length_of_Stay
FROM healthcare_dataset
WHERE Discharge_Date IS NOT NULL
ORDER BY Length_of_Stay DESC;
```

**Solution**: Identifies patients with longer stays. Useful for cost analysis and efficiency tracking.

## ✅ Conclusion

The healthcare dataset analysis uncovered key patterns in admissions, billing, patient demographics, and medical conditions. After thorough data cleaning, accurate insights were derived on hospital revenue, doctor performance, and patient trends.

This project demonstrates the application of SQL for real-world healthcare analytics, enabling hospitals to improve operational efficiency, enhance quality of care, and make informed decisions using data.
