
# README
## Assignment Group: Nithya, Damarcus, Juan
### Assignment 6 Due Date:6/22
## Date Modified: 6/21/2017

### Our Assignment:  Manhattan Rolling House Sales Data Analysis
---
Below is from the assignment document given by Dr. Mahesh Fernando. 

Using the Rolling Data Sales website, download and examine another housing sales data set (not the one we will use in live session, which is linked here - Rolling Housing Sales for NYC).
(http://www1.nyc.gov/site/finance/taxes/property-rolling-sales-data.page)

> * Goal: Create an RStudio project for the analysis of this data set. Your file structure within the project should include the following: 
>   * A README file in the project root directory that includes an explanation of the purpose of the project and the other files
>   * A data directory containing files to load in and clean up the data. The clean up should include finding out where there are 
outliers or missing values, deciding how you will treat them, making sure values you think are numerical are being treated as such >>>(correct R class), etc.
>   * An Analysis directory containing a file (or files) for exploratory data analysis on the clean data to visualize compare the square >footage and sales price for your neighborhood.
>
> * Deliverable: A link to a repository on GitHub containing the above. 
***
### File Organization
---
> The Rolling House Repository has two Directories, Data, Analysis, and a single Readme.md
> * Inside the Data Directory there is various stages of the raw data in txt and csv
> * Inside the Analysis Diretory there is a clean version of the data in two different forms
> * Analysis of plots from the clean data like the ones below plus more saved individually.
> * Analysis was done in R
> * This ReadMe contains an outline of the process, and analysis below for directions on reproducibility
---

 Check the data
```{r echo = TRUE}
head(man)
summary(man)
str(man) # Very handy function!
#Compactly display the internal structure of an R object.
```
***
>Clean/format the data with regular expressions
>More on these later. For now, know that the
>pattern "[^[:digit:]]" refers to members of the variable name that
>start with digits. We use the gsub command to replace them with a blank space.
>We create a new variable that is a "clean' version of sale.price.
>And sale.price.n is numeric, not a factor.
```{r echo = FALSE}
man$SALE.PRICE.N <- as.numeric(gsub("[^[:digit:]]","", man$SALE.PRICE))
count(is.na(man$SALE.PRICE.N))

names(man) <- tolower(names(man)) # make all variable names lower case
```
Removed the 1000 delimiter from the sqft and converted the datatype to numeric for year
```{r echo = FALSE}
man$gross.sqft <- as.numeric(gsub("[^[:digit:]]","", man$gross.square.feet))
man$land.sqft <- as.numeric(gsub("[^[:digit:]]","", man$land.square.feet))
man$year.built <- as.numeric(as.character(man$year.built))
***
```
Doing a bit of data exploration to make sure there's not anything
weird going on with sale prices

```{r echo = FALSE}
attach(man)
hist(sale.price.n) 
detach(man)
```
***
Here's some cool Plots:
             Manhattan Sale Price
![](https://github.com/WindDAnalytics/testrepo-1/blob/master/Analysis/man.sale.price.png) 
             Actual Sales with Original Data
![](https://github.com/WindDAnalytics/testrepo-1/blob/master/Analysis/Orig_ActualSales_Scatterplot.png)

```{r echo = FALSE}
keep only the actual sales
man.sale <- man[man$sale.price.n!=0,]
```
for now, let's look at 1-, 2-, and 3-family homes
            Transformed Price Data  
![](https://github.com/WindDAnalytics/testrepo-1/blob/master/Analysis/logT_HomesSq_Price_ScatterPlot.png)

***
More Cleaning and Polishing
```{r echo = FALSE}

man.homes <- man.sale[which(grepl("FAMILY",man.sale$building.class.category)),]
dim(man.homes)
plot(log10(man.homes$gross.sqft),log10(man.homes$sale.price.n))
summary(man.homes[which(man.homes$sale.price.n<100000),])
```
         Transformed Sales Data
![](https://github.com/WindDAnalytics/testrepo-1/blob/master/Analysis/NoOutliers_logT_Homes_Sales_ScatterPlot.png)

         Sales Vs Sqft
![](https://github.com/WindDAnalytics/testrepo-1/blob/master/Analysis/logT_Sales_per_sqft_Scatterplot.png)


Removed outliers that seem like they weren't actual sales

```{r echo = FALSE}
man.homes$outliers <- (log10(man.homes$sale.price.n) <=5) + 0
man.homes <- man.homes[which(man.homes$outliers==0),]
plot(log10(man.homes$gross.sqft),log10(man.homes$sale.price.n))
```
