# Global-Layoff-Analysis-2020-2023-SQL

## Table of Contents
1. [Project Objective](#project-overview)
2. [Dataset](#dataset)
3. [Data Cleaning](#data-cleaning)
4. [Exploratory Data Analysis (EDA)](#exploratory-data-analysis-eda)
5. [Key Insights](#key-insights)
6. [Suggestions](#suggestions)

### Project Objective
This project aims to analyze layoffs data from various companies between **March 11, 2020, and March 6, 2023**. The primary objectives are to identify trends in layoffs across different industries and countries, understand the factors influencing these layoffs, and provide actionable insights for organizations.

### Dataset
The dataset includes the following attributes related to layoffs:

- **Company**: Name of the company where layoffs occurred.
- **Location**: City of the company’s headquarters.
- **Industry**: Sector in which the company operates.
- **Total Laid Off**: Total number of employees laid off by the company.
- **Percentage Laid Off**: Proportion of the workforce affected by layoffs.
- **Date**: Date of the layoffs.
- **Stage**: Company growth stage (e.g., Post-IPO, Acquired).
- **Country**: Country where the layoffs took place.
- **Funds Raised (in millions)**: Total funding raised by the company.

---

### Data Cleaning
The dataset underwent several cleaning processes to ensure accuracy and consistency. Below are the steps taken, accompanied by relevant SQL code snippets:

1. **Creating a Staging Table:**
   - A staging table was created to preserve the raw data, allowing for safe manipulation without altering the original dataset.
   ```sql
   CREATE TABLE layoff_staging
   LIKE layoffs;

   INSERT INTO layoff_staging
   SELECT *
   FROM layoffs;
   ```

2. **Removing Duplicates:**
   - Duplicate records were identified using `ROW_NUMBER()` to assign unique row numbers, enabling the deletion of redundant entries.
   ```sql
   DELETE 
   FROM layoff_staging2
   WHERE row_num > 1;
   ```

3. **Standardizing Data:**
   - Text fields were standardized by trimming whitespace and unifying representations of industries and countries to ensure consistency.
   ```sql
   UPDATE layoff_staging2
   SET company = TRIM(company);

   UPDATE layoff_staging2
   SET industry = 'Crypto'
   WHERE industry LIKE 'crypto%';

   UPDATE layoff_staging2
   SET country = TRIM(TRAILING '.' FROM country)
   WHERE country LIKE 'united states%';
   ```

4. **Changing Data Types:**
   - The data types of columns were altered to appropriate formats, ensuring accurate data representation for analysis.
   ```sql
   ALTER TABLE layoff_staging2
   MODIFY COLUMN `date` DATE;

   ALTER TABLE layoff_staging2
   MODIFY COLUMN total_laid_off INT;

   ALTER TABLE layoff_staging2
   MODIFY COLUMN percentage_laid_off FLOAT;

   ALTER TABLE layoff_staging2
   MODIFY COLUMN funds_raised_millions INT;
   ```

5. **Handling Null and Blank Values:**
   - Blank entries in the industry column were replaced with NULL values, and relevant records were updated based on existing data to maintain accuracy.
   ```sql
   UPDATE layoff_staging2
   SET industry = NULL
   WHERE industry = '';

   UPDATE layoff_staging2 t1
   JOIN layoff_staging2 t2
   ON t1.company = t2.company
   AND t1.location = t2.location
   SET t1.industry = t2.industry
   WHERE t1.industry IS NULL
   AND t2.industry IS NOT NULL;
   ```

6. **Removing Unnecessary Rows:**
   - Records with NULL values in both `total_laid_off` and `percentage_laid_off` were deleted, as they did not provide useful information for analysis.
   ```sql
   DELETE
   FROM layoff_staging2
   WHERE total_laid_off IS NULL
   AND percentage_laid_off IS NULL;
   ```

7. **Dropping Unused Columns:**
   - The `row_num` column was removed from the dataset, as it was no longer necessary after identifying and deleting duplicates.
   ```sql
   ALTER TABLE layoff_staging2
   DROP COLUMN row_num;
   ```

8. **Final Dataset Check:**
   - A final verification of the cleaned dataset was conducted to confirm its readiness for exploratory data analysis (EDA).
   ```sql
   SELECT *
   FROM layoff_staging2;
   ```

These steps ensure that the dataset is clean, consistent, and ready for further analysis, allowing for accurate insights to be derived.

---

### Exploratory Data Analysis (EDA)
The exploratory analysis provided key insights into the trends and patterns of layoffs over the specified period. Below are the major findings:

1. **Timeline of Layoffs**:
   - The dataset encompasses layoffs from **March 2020 to March 2023**, with noticeable fluctuations in layoff counts reflecting broader economic trends, particularly the impacts of the COVID-19 pandemic.

2. **Company Closures**:
   - A total of **116 companies** were identified as having completely closed, as indicated by a **percentage_laid_off** of 1. This highlights the severe impact of market conditions on business sustainability.

3. **Top Companies by Layoffs**:
   - The analysis revealed that **Amazon** led the layoffs with **18,150 employees** affected, followed by **Google** and **Meta**. This indicates that even major players in the tech industry faced significant workforce reductions, suggesting shifts in business strategies or economic pressures.
  
    <img width="167" alt="Screenshot 2024-10-23 at 4 39 36 PM" src="https://github.com/user-attachments/assets/ead1f9bc-18a9-4416-8ab0-48dc3331a91e">

4. **Industries with Most Layoffs**:
   - The **Consumer** industry experienced the highest total layoffs at **45,182**, closely followed by **Retail** with **43,613** layoffs. This trend may reflect changing consumer behaviors and the shift toward e-commerce, which could have disproportionately affected traditional retail sectors.
  
    <img width="191" alt="Screenshot 2024-10-23 at 4 51 38 PM" src="https://github.com/user-attachments/assets/46e59ac7-475e-41cb-87e0-b6f798b09ca1">

5. **Geographical Impact**:
   - The analysis identified the **United States** as the country with the highest layoffs, totaling **256,559**. This significant number underscores the economic challenges faced by many U.S.-based companies during this period, particularly in high-impact industries.
  
    <img width="216" alt="Screenshot 2024-10-23 at 4 52 37 PM" src="https://github.com/user-attachments/assets/6a5d4e70-592f-4e46-9b8c-b3511b09e31b">

6. **Yearly Analysis**:
   - **2022** recorded the highest number of layoffs, totaling **160,661 employees**. The surge in layoffs during this year might correlate with post-pandemic adjustments and economic recovery challenges.
  
    <img width="191" alt="Screenshot 2024-10-23 at 4 53 19 PM" src="https://github.com/user-attachments/assets/c6d81fdf-46c7-420e-886b-affdc1da469f">

7. **Company Stage Impact**:
   - Companies classified as **Post-IPO** faced the most layoffs, totaling **204,132 employees**. This finding suggests that companies in growth stages might be more vulnerable to market fluctuations and may need to reassess their workforce strategies.
  
    <img width="168" alt="Screenshot 2024-10-23 at 5 03 15 PM" src="https://github.com/user-attachments/assets/a5e5b4d5-e734-44f6-b579-c59206fffec1">

8. **Monthly Trends**:
   - A rolling total of layoffs from **2020 to 2023** amounted to **383,159** employees. Monthly analyses indicate peaks in layoffs, possibly aligning with broader economic indicators such as inflation rates or market contractions.
   
    <img width="199" alt="Screenshot 2024-10-23 at 5 05 07 PM" src="https://github.com/user-attachments/assets/4314f44a-23f9-400b-8bbf-cd35c8c7846f">

9. **Top 5 Companies by Year**:
   - Amazon and Meta appear multiple times, indicating their ongoing challenges amidst a volatile market, particularly in 2022 when Meta and Amazon ranked among the top companies for layoffs, reflecting pressures in the tech industry.
     
    - **2020**
      <img width="237" alt="Screenshot 2024-10-23 at 5 22 00 PM" src="https://github.com/user-attachments/assets/0a1c9224-f5a0-4529-bcc9-401d1135be26">

    - **2021**
      <img width="237" alt="Screenshot 2024-10-23 at 5 25 54 PM" src="https://github.com/user-attachments/assets/0f70e097-4108-4b81-993f-df3bc6728f8b">

   - **2022**
     <img width="237" alt="Screenshot 2024-10-23 at 5 27 39 PM" src="https://github.com/user-attachments/assets/99bdec62-5f9b-474e-8581-e30df81031a2">

   - **2023**
     <img width="237" alt="Screenshot 2024-10-23 at 5 27 50 PM" src="https://github.com/user-attachments/assets/51ed133a-89dd-41cd-aa6d-248353fa9072">
  
10. **Top 5 Industries by Year**:
   - The Retail industry saw a dramatic increase in layoffs in 2022, with over 20,000 employees affected. In 2023, the emergence of the 'Other' category with the highest number of layoffs indicates a shift in industry dynamics, possibly reflecting broader economic trends that affected multiple sectors.

   - **2020**
     <img width="237" alt="Screenshot 2024-10-23 at 5 29 45 PM" src="https://github.com/user-attachments/assets/9c0a7592-f65f-4447-a88c-1b817cd42c5a">

  - **2021**
    <img width="237" alt="Screenshot 2024-10-23 at 5 30 06 PM" src="https://github.com/user-attachments/assets/0ce07e39-07e9-4dcc-acd2-911b5c299c9f">

  - **2022**
    <img width="237" alt="Screenshot 2024-10-23 at 5 30 22 PM" src="https://github.com/user-attachments/assets/007ac9b8-9393-4aeb-899a-89c9dc454bf1">

 - **2023**
   <img width="237" alt="Screenshot 2024-10-23 at 5 30 34 PM" src="https://github.com/user-attachments/assets/b50c654f-b40e-4a46-9644-64eff00c58a7">
    
  

---

### Key Insights
- Amazon, Google, and Meta were the most affected companies during the analyzed period.
- The Consumer and Retail industries experienced significant layoffs, each exceeding **40,000** employees.
- The United States faced the highest total layoffs, highlighting substantial employment impacts.
- Post-IPO companies accounted for a disproportionate number of layoffs compared to private firms.

### Suggestions
1. **Strategic Workforce Planning**:
   - As the **Consumer** and **Retail** industries have seen the highest layoffs, companies should implement proactive workforce planning strategies to anticipate and manage potential future layoffs.

2. **Enhance Employee Engagement**:
   - Given the significant layoffs at major companies like **Amazon** and **Google**, organizations should prioritize employee engagement and retention initiatives, such as career development programs and employee feedback systems.

3. **Diversify Business Models**:
   - With **Post-IPO** companies experiencing high layoff rates, firms should consider diversifying their revenue streams to reduce reliance on single markets and enhance financial resilience.

4. **Localized Response Strategies**:
   - The data shows high layoff numbers concentrated in the **United States**, **India**, and the **Netherlands**. Companies should tailor their operational strategies to address regional economic conditions and workforce needs.

5. **Crisis Management Planning**:
   - To mitigate the impact of layoffs, organizations should develop robust crisis management plans, including clear communication strategies and support mechanisms for affected employees.


