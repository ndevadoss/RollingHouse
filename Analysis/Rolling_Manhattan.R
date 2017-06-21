# Taken from pages 49-50 of O'Neil and Schutt (Reference)
#Modified by Nithya D , Thomas D , Juan

library(plyr)

setwd("C:/Users/NithyaDoss/Documents/testrepo/testrepo")

# http://www1.nyc.gov/site/finance/taxes/property-rolling-sales-data.page


# read csv file
man <- read.csv("C:/Nithya/MSDS/Term1/6306_Doing_DS/Week6/Live/Download/rollingsales_manhattan.csv",skip=4,header=TRUE)

## Check the data
head(man)
summary(man)
str(man) # Very handy function!
#Compactly display the internal structure of an R object.

## clean/format the data with regular expressions
## More on these later. For now, know that the
## pattern "[^[:digit:]]" refers to members of the variable name that
## start with digits. We use the gsub command to replace them with a blank space.
# We create a new variable that is a "clean' version of sale.price.
# And sale.price.n is numeric, not a factor.
man$SALE.PRICE.N <- as.numeric(gsub("[^[:digit:]]","", man$SALE.PRICE))
count(is.na(man$SALE.PRICE.N))

names(man) <- tolower(names(man)) # make all variable names lower case

## Removed the 1000 delimiter from the sqft and converted the datatype to numeric for year
man$gross.sqft <- as.numeric(gsub("[^[:digit:]]","", man$gross.square.feet))
man$land.sqft <- as.numeric(gsub("[^[:digit:]]","", man$land.square.feet))
man$year.built <- as.numeric(as.character(man$year.built))


## do a bit of exploration to make sure there's not anything
## weird going on with sale prices
attach(man)
hist(sale.price.n) 
detach(man)

## keep only the actual sales

man.sale <- man[man$sale.price.n!=0,]
plot(man.sale$gross.sqft,man.sale$sale.price.n)
plot(log10(man.sale$gross.sqft),log10(man.sale$sale.price.n))

## for now, let's look at 1-, 2-, and 3-family homes
man.homes <- man.sale[which(grepl("FAMILY",man.sale$building.class.category)),]
dim(man.homes)
plot(log10(man.homes$gross.sqft),log10(man.homes$sale.price.n))
summary(man.homes[which(man.homes$sale.price.n<100000),])


## remove outliers that seem like they weren't actual sales
man.homes$outliers <- (log10(man.homes$sale.price.n) <=5) + 0
man.homes <- man.homes[which(man.homes$outliers==0),]
plot(log10(man.homes$gross.sqft),log10(man.homes$sale.price.n))

