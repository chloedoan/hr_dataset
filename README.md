# HR Analytics — SQL Cleaning + Tableau Dashboard

A compact HR analytics project demonstrating **SQL-based data cleaning** and a **Tableau dashboard** built on top of a public dataset.  
The goal was to transform a raw HR table into clean, analysis-ready data and visualize hiring/termination trends, performance, and workforce demographics.

---

## 📂 Live Assets

- Tableau dashboard screenshot: `Dashboard-Overview.png`  
- SQL script: `sample_store_table.sql` (contains cleaning logic and CTEs)

<img width="902" height="723" alt="image" src="https://github.com/user-attachments/assets/0260c775-e24e-424e-95e9-5d0971926a65" />

<img width="925" height="722" alt="image" src="https://github.com/user-attachments/assets/ea67bce1-3269-4bf9-a13b-a284884a708e" />



---

## 📊 Dataset

- **Source:** [Human Resources Data Set — Kaggle (Richard Huebner)](https://www.kaggle.com/datasets/rhuebner/human-resources-data-set)  
- **Raw table used:** `hr.hr_dataset`
- **Grain:** One row per employee (hire/termination dates + demographics)

---

## 🛠 Tech Stack

- **SQL:** MySQL (compatible syntax) for data cleaning & feature engineering  
- **BI Tool:** Tableau for interactive visuals and KPI tracking

---

## 🎯 Objectives

1. Clean and standardize the HR dataset for reliable analysis.  
2. Fix messy or misleading fields (dates, names, codes, and reasons).  
3. Create a unified **Event Date** dimension to analyze hires vs. terminations over time.  
4. Build a single **Overview Dashboard** answering:
   - *How is our workforce changing?*
   - *Who are we hiring and losing?*

---

## 🧹 Data Cleaning & Feature Engineering (SQL)

> Full queries in [`sample_store_table.sql`](sample_store_table.sql)  
> Key highlights:

- **Normalize Dates**
  - Standardized all date fields to correct formats.
  - **DOB Century Fix:** Convert years like `'99'` interpreted as **2099** to **1999**.
- **Employment Status & Reasons**
  - Map `Termd` values to **Active/Terminated**.
  - Recode `termReason` into formal categories (*Career Change*, *Job Dissatisfaction*, etc.).
  - Treat `"N/A-StillEmployed"` as NULL.
- **Names & IDs**
  - Clean `Employee_Name` (remove commas, rearrange to `First Last`).
  - Extract `firstName`, `lastName`, and `fullName`.
  - Fill missing `ManagerID` with a valid placeholder.
- **Dimensions**
  - Map gender codes (`M`/`F`) to full labels.
  - Standardize `DeptID` where necessary.
- **Unified Event Date**
  - Created an `EventDate` dimension by **UNION ALL**:
    - `DateOfHire → EventType = 'Active'`
    - `DateOfTermination → EventType = 'Terminated'`

---

## 📈 Tableau Dashboard Features

The **Overview Dashboard** includes:
- **BANs:** Active vs. Terminated counts & percentages.
- **Hiring Trend:** Hires vs. Terminations over time (from `EventDate`).
- **Performance Distribution:** Fully Meets, Exceeds, Needs Improvement, PIP.
- **Department Breakdown.**
- **Demographics:** Gender, Race, Marital Status, Citizenship.
- **Age Distribution** and **Average Age** metric.
- **Average Annual Salary** & share of workforce.

**Filters:**  
Status | Department | Position | Gender

---

## 🚀 How to Reproduce

### 1️⃣ SQL Setup
```sql
-- Load raw data into table hr_dataset
SOURCE sample_store_table.sql;
