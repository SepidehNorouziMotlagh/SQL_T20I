# SQL_T20I

# 🏏 T20 International Cricket Analysis (2024)

## 📌 Project Overview
This project uses **Microsoft SQL Server** to analyze T20 International (T20I) cricket match results from **January 2024 to November 2024**. The dataset covers major series and tournaments, including the **2024 T20 World Cup**.

The primary focus of this project is **Data Manipulation** and **Performance Metrics**. Since the "Margin" column contains mixed text data (e.g., "135 runs" vs "5 wickets"), significant T-SQL string functions were used to clean and extract numerical values for analysis.

## 📂 Dataset Description
The database was built manually using DDL and DML commands to simulate a sports analytics environment.

| Column | Description |
| :--- | :--- |
| **Team1** | Name of the first team |
| **Team2** | Name of the second team |
| **Winner** | The winner of the match |
| **Margin** | The result margin (Text format: e.g., '10 runs', '6 wickets', 'tied') |
| **MatchDate** | Date of the match |
| **Ground** | The stadium/city where the match was played |

## 🛠️ Technologies Used
*   **Database:** SQL Server (T-SQL)
*   **Concepts:** String Manipulation, CTEs, Window Functions, Aggregate Functions, Variables.

## 🔍 Key SQL Challenges Solved
This project demonstrates solutions to common data challenges:
1.  **Handling Unstructured Data:**  
    Used `SUBSTRING` and `CHARINDEX` to separate numerical values from text in the 'Margin' column to calculate average run margins.
2.  **Win Percentage Calculation:**  
    Used CTEs and `UNION ALL` to count total matches played per team (both as Team1 and Team2) vs. their total wins.
3.  **Ranking Logic:**  
    Implemented `DENSE_RANK` and `RANK` to order teams by wins and find the most successful team at specific venues.

## 📊 Analysis Highlights
The SQL script (`T20_Analysis.sql`) answers the following:
1.  **Head-to-Head:** Records between specific rivals (e.g., India vs. South Africa).
2.  **Top Chasers:** Teams with the most wins batting second.
3.  **Dominance:** Teams with winning margins higher than the global average.
4.  **Venue Kings:** The most successful team at every specific cricket ground.
5.  **Seasonal Trends:** Identified the busiest month for cricket in 2024.

## 📝 Sample Query
*Extracting numerical values from a text column ('135 runs') to find the average winning margin:*

```sql
SELECT TOP 1 
    Winner,
    AVG(CAST(SUBSTRING(Margin, 1, CHARINDEX(' ', Margin)-1) AS INT)) AS AvgMargin
FROM T20I 
WHERE Margin LIKE '%runs'
GROUP BY Winner 
ORDER BY AvgMargin DESC;
