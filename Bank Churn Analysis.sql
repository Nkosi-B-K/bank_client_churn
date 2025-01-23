USE bank_churn;

SELECT * FROM cust_info;

#Performing EDA to understand some high level nuances in the data which may inform the in depth analysis

# Average Credit Score
SELECT ROUND(AVG(CreditScore) ,2) FROM cust_info;

# NO. of Customers by Geographical Location
SELECT Geography, COUNT(Geography) AS Num_by_Loc
FROM cust_info
WHERE Geography IN ('France', 'Germany', 'Spain')
GROUP BY Geography;

# Average customer Age
SELECT ROUND(AVG(age)) AS AVG_Age
FROM cust_info;

# Average no. of bank products held by customers
SELECT ROUND(AVG(NumOfProducts) ,2) AS Avg_Num_Prods
FROM cust_info;

# Average customer estimated salary
SELECT ROUND(AVG(EstimatedSalary) ,2) AS Avg_Salar
FROM cust_info;

# Number of customers retained and exited
SELECT 
    Exited,
    COUNT(*) AS Count
FROM cust_info
GROUP BY Exited;

# Average customer tenure
SELECT ROUND(AVG(Tenure) ,2) AS Avg_Tenure
FROM cust_info;

SELECT * FROM cust_info
LIMIT 10;

SELECT ROUND(AVG(Balance) ,2) AS Avg_Balance
FROM cust_info;

# Commencement of in depth analysis
# Intitial Analysis - Analysis of those customers who were not retained.
DROP VIEW churners;

CREATE VIEW churners AS 
SELECT Geography, Gender, Age, Tenure, NumOfProducts, CreditScore, HasCrCard, IsActiveMember, Exited
FROM cust_info
WHERE Exited = 1;

SELECT * FROM churners;

# Churn numbers by location and gender C1
SELECT 
    Geography AS Location,
    Gender AS Gender,
    COUNT(*) AS Churn_Numbers
FROM churners
GROUP BY Geography, Gender
ORDER BY Geography;

# Churn numbers based on tenure, location, gender and number of products C2
SELECT 
    Geography AS Location,
    Gender AS Gender,
    COUNT(*) AS Churn_Numbers,
    ROUND(AVG(Tenure), 1) AS Avg_Tenure,
    CEIL(AVG(NumOfProducts)) AS No_of_Products
FROM churners
GROUP BY Geography, Gender
ORDER BY Geography;

# churn by location, gender, tenure, no of products all by age group C3
SELECT 
    Geography AS Location,
    Gender AS Gender,
    COUNT(*) AS Churns,
    ROUND(AVG(Tenure), 1) AS Avg_Tenure,
    CEIL(AVG(NumOfProducts)) AS No_of_Products,
    CEIL(AVG(CreditScore)) AS Avg_CredScore,
    SUM(CASE WHEN Age >= 13 AND Age <= 19 THEN 1 ELSE 0 END) AS Teens,
    SUM(CASE WHEN Age >= 20 AND Age <= 29 THEN 1 ELSE 0 END) AS Twenties,
    SUM(CASE WHEN Age >= 30 AND Age <= 39 THEN 1 ELSE 0 END) AS Thirties,
    SUM(CASE WHEN Age >= 40 AND Age <= 49 THEN 1 ELSE 0 END) AS Forties,
    SUM(CASE WHEN Age >= 50 AND Age <= 59 THEN 1 ELSE 0 END) AS Fifties,
    SUM(CASE WHEN Age >= 60 AND Age <= 69 THEN 1 ELSE 0 END) AS Sixties,
    SUM(CASE WHEN Age >= 70 AND Age <= 79 THEN 1 ELSE 0 END) AS Seventies,
    SUM(CASE WHEN Age >= 80 AND Age <= 89 THEN 1 ELSE 0 END) AS Eighties,
    SUM(CASE WHEN Age >= 90 AND Age <= 100 THEN 1 ELSE 0 END) AS Nineties
FROM churners
GROUP BY Geography, Gender
ORDER BY Geography;


# Continued Analysis - Analysis of those customers who were retained.
DROP VIEW retained;

CREATE VIEW retained AS 
SELECT Geography, Gender, Age, Tenure, CreditScore, NumOfProducts, HasCrCard, IsActiveMember, Exited
FROM cust_info
WHERE Exited = 0;

SELECT * FROM retained;

# Retention numbers based on tenure, location, gender and number of products R1
SELECT 
    Geography AS Location,
    Gender AS Gender,
    COUNT(*) AS Ret_Numbers,
    ROUND(AVG(Tenure), 1) AS Avg_Tenure,
    CEIL(AVG(NumOfProducts)) AS No_of_Products
FROM retained
GROUP BY Geography, Gender
ORDER BY Geography;

# retentions by location, gender, tenure, no of products all by age group R2
SELECT 
    Geography AS Location,
    Gender AS Gender,
    COUNT(*) AS Retentions,
    ROUND(AVG(Tenure), 1) AS Avg_Tenure,
    CEIL(AVG(NumOfProducts)) AS No_of_Products,
    SUM(CASE WHEN Age >= 13 AND Age <= 19 THEN 1 ELSE 0 END) AS Teens,
    SUM(CASE WHEN Age >= 20 AND Age <= 29 THEN 1 ELSE 0 END) AS Twenties,
    SUM(CASE WHEN Age >= 30 AND Age <= 39 THEN 1 ELSE 0 END) AS Thirties,
    SUM(CASE WHEN Age >= 40 AND Age <= 49 THEN 1 ELSE 0 END) AS Forties,
    SUM(CASE WHEN Age >= 50 AND Age <= 59 THEN 1 ELSE 0 END) AS Fifties,
    SUM(CASE WHEN Age >= 60 AND Age <= 69 THEN 1 ELSE 0 END) AS Sixties,
    SUM(CASE WHEN Age >= 70 AND Age <= 79 THEN 1 ELSE 0 END) AS Seventies,
    SUM(CASE WHEN Age >= 80 AND Age <= 89 THEN 1 ELSE 0 END) AS Eighties,
    SUM(CASE WHEN Age >= 90 AND Age <= 100 THEN 1 ELSE 0 END) AS Nineties
FROM retained
GROUP BY Geography, Gender
ORDER BY Geography;

#segementation of churner credit scores with geogrpahy, gender and age C4
SELECT
    Geography,
    Gender,
    Age,
    CreditScore,
    CASE 
        WHEN CreditScore >= 0 AND CreditScore <= 499 THEN 'Very Poor'
        WHEN CreditScore >= 500 AND CreditScore <= 550 THEN 'Poor'
        WHEN CreditScore >= 551 AND CreditScore <= 600 THEN 'Good'
        WHEN CreditScore >= 601 AND CreditScore <= 650 THEN 'Very Good'
        WHEN CreditScore >= 651 THEN 'Excellent'
        ELSE 'Unknown'
    END AS CreditScore_Segment
FROM churners
ORDER BY Age ASC;

#segementation of retainees credit scores with geogrpahy, gender and age R3
SELECT
    Geography,
    Gender,
    Age,
    CreditScore,
    CASE 
        WHEN CreditScore >= 0 AND CreditScore <= 499 THEN 'Very Poor'
        WHEN CreditScore >= 500 AND CreditScore <= 550 THEN 'Poor'
        WHEN CreditScore >= 551 AND CreditScore <= 600 THEN 'Good'
        WHEN CreditScore >= 601 AND CreditScore <= 650 THEN 'Very Good'
        WHEN CreditScore >= 651 THEN 'Excellent'
        ELSE 'Unknown'
    END AS CreditScore_Segment
FROM retained
ORDER BY Age ASC;

# Looking into whether there is a difference between German, French and Spanish customers' account behaviour B1

SELECT
	Geography,
    CreditScore,
    Balance,
    NumOfProducts,
    HasCrCard,
    IsActiveMember
FROM cust_info
ORDER BY Geography ASC;

# Analysing if customers with more products are less likely to churn D1
SELECT 
    NumOfProducts,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS Churned_Customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100 AS Churn_Rate_Percentage
FROM cust_info
GROUP BY NumOfProducts
ORDER BY NumOfProducts ASC;

# profitability index of customers analysis - top 20 P1

SELECT 
    CustomerId,
    Geography AS Location,
    Gender,
    Age,
    EstimatedSalary,
    Balance,
    NumOfProducts,
    ROUND((Balance + (EstimatedSalary * 0.2)) * NumOfProducts, 2) AS Profitability_Index
FROM cust_info
ORDER BY Profitability_Index DESC
LIMIT 20;

# customer balance analysis 

SELECT 
    CASE 
        WHEN Balance < 50000 THEN 'Low Balance'
        WHEN Balance BETWEEN 50000 AND 150000 THEN 'Medium Balance'
        WHEN Balance > 150000 THEN 'High Balance'
        ELSE 'Unknown Balance'
    END AS Balance_Group,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND((SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS Churn_Rate_Percentage
FROM cust_info
GROUP BY Balance_Group
ORDER BY Balance_Group;

SELECT * FROM cust_info;

SELECT
	geography,
	gender,
    age,
    (CASE WHEN Age >= 13 AND Age <= 19 THEN 1 ELSE 0 END) AS Teens,
    (CASE WHEN Age >= 20 AND Age <= 29 THEN 1 ELSE 0 END) AS Twenties,
    (CASE WHEN Age >= 30 AND Age <= 39 THEN 1 ELSE 0 END) AS Thirties,
    (CASE WHEN Age >= 40 AND Age <= 49 THEN 1 ELSE 0 END) AS Forties,
    (CASE WHEN Age >= 50 AND Age <= 59 THEN 1 ELSE 0 END) AS Fifties,
    (CASE WHEN Age >= 60 AND Age <= 69 THEN 1 ELSE 0 END) AS Sixties,
    (CASE WHEN Age >= 70 AND Age <= 79 THEN 1 ELSE 0 END) AS Seventies,
    (CASE WHEN Age >= 80 AND Age <= 89 THEN 1 ELSE 0 END) AS Eighties,
    (CASE WHEN Age >= 90 AND Age <= 100 THEN 1 ELSE 0 END) AS Nineties
FROM
	cust_info
ORDER BY age ASC;