# Global-Layoff-Analysis-2020-2023-SQL

### Project Overview
This project analyzes layoffs data from various companies between **March 11, 2020, and March 6, 2023**. The primary objectives are to identify trends in layoffs across different industries and countries, understand the factors influencing these layoffs, and provide actionable insights for organizations.

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

1. **Preserving Raw Data**:
   - A staging table was created to perform cleaning tasks while maintaining the integrity of the original dataset.
   ```sql
   CREATE TABLE layoffs_staging AS
   SELECT * FROM layoffs_data;
   ```

2. **Removing Duplicates**:
   - Duplicate records were eliminated based on unique combinations of `company`, `location`, and `date`.
   ```sql
   DELETE FROM layoffs_data
   WHERE id NOT IN (
       SELECT MIN(id)
       FROM layoffs_data
       GROUP BY company, location, date
   );
   ```

3. **Standardizing Text**:
   - Text in the `industry` column was standardized by trimming whitespace and converting it to uppercase.
   ```sql
   UPDATE layoffs_data
   SET industry = UPPER(TRIM(industry));
   ```

4. **Handling Missing Values**:
   - Missing values in the `industry` column were addressed using the COALESCE function to fill gaps based on existing records.
   ```sql
   UPDATE layoffs_data
   SET industry = COALESCE(industry, (SELECT industry FROM layoffs_data WHERE company = t.company AND location = t.location LIMIT 1))
   FROM layoffs_data t
   WHERE layoffs_data.company = t.company AND layoffs_data.location = t.location AND layoffs_data.industry IS NULL;
   ```

5. **Correcting Data Types**:
   - The data type of the `date` column was corrected to ensure it is recognized as a date type.
   ```sql
   ALTER TABLE layoffs_data
   ALTER COLUMN date TYPE DATE USING date::DATE;
   ```

6. **Final Cleanup**:
   - Records with null values for both `total_laid_off` and `percentage_laid_off` were removed.
   ```sql
   DELETE FROM layoffs_data
   WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
   ```

These steps are crucial for preparing the dataset for further analysis, ensuring that insights drawn are reliable and actionable.

---

### Exploratory Data Analysis (EDA)
The exploratory analysis provided key insights into the trends and patterns of layoffs over the specified period. Below are the major findings:

1. **Timeline of Layoffs**:
   - The dataset encompasses layoffs from **March 2020 to March 2023**, with noticeable fluctuations in layoff counts reflecting broader economic trends, particularly the impacts of the COVID-19 pandemic.

2. **Company Closures**:
   - A total of **116 companies** were identified as having completely closed, as indicated by a **percentage_laid_off** of 1. This highlights the severe impact of market conditions on business sustainability.

3. **Top Companies by Layoffs**:
   - The analysis revealed that **Amazon** led the layoffs with **18,150 employees** affected, followed by **Google** and **Meta**. This indicates that even major players in the tech industry faced significant workforce reductions, suggesting shifts in business strategies or economic pressures.

4. **Industries with Most Layoffs**:
   - The **Consumer** industry experienced the highest total layoffs at **45,182**, closely followed by **Retail** with **43,613** layoffs. This trend may reflect changing consumer behaviors and the shift toward e-commerce, which could have disproportionately affected traditional retail sectors.

5. **Geographical Impact**:
   - The analysis identified the **United States** as the country with the highest layoffs, totaling **256,559**. This significant number underscores the economic challenges faced by many U.S.-based companies during this period, particularly in high-impact industries.

6. **Yearly Analysis**:
   - **2022** recorded the highest number of layoffs, totaling **160,661 employees**. The surge in layoffs during this year might correlate with post-pandemic adjustments and economic recovery challenges.

7. **Company Stage Impact**:
   - Companies classified as **Post-IPO** faced the most layoffs, totaling **204,132 employees**. This finding suggests that companies in growth stages might be more vulnerable to market fluctuations and may need to reassess their workforce strategies.

8. **Monthly Trends**:
   - A rolling total of layoffs from **2020 to 2023** amounted to **383,159** employees. Monthly analyses indicate peaks in layoffs, possibly aligning with broader economic indicators such as inflation rates or market contractions.

9. **Top 5 Companies and Industries by Year**:
   - Identifying the top 5 companies and industries for layoffs in each year provides valuable insights into specific trends and outliers. For instance, understanding which companies consistently appear can help identify those most affected by external pressures.

---

### Key Insights
- Amazon, Google, and Meta were the most affected companies during the analyzed period.
- The Consumer and Retail industries experienced significant layoffs, each exceeding **40,000** employees.
- The United States faced the highest total layoffs, highlighting substantial employment impacts.
- Post-IPO companies accounted for a disproportionate number of layoffs compared to private firms.

### Suggestions
Based on the analysis, the following recommendations can be made:

1. **Industry Focus**:
   - Companies in the **Consumer** and **Retail** sectors should evaluate workforce strategies to mitigate risks during economic downturns.

2. **Geographic Considerations**:
   - Firms should analyze their geographical exposure to layoffs, especially in regions heavily impacted, like the United States, to develop proactive measures.

3. **Post-IPO Strategies**:
   - Companies that have recently gone public should manage their growth and employee retention strategies carefully, as they appear more susceptible to layoffs.

4. **Ongoing Monitoring**:
   - Continuous tracking of industry trends and economic indicators will enable organizations to adapt swiftly to changing market conditions.

