

# Data: Credit dataset 
#install.packages("ISLR")
library(ISLR)

# check sample of data
head(Credit)
tail(Credit)
# check data structure
str(Credit)
# check summary
summary(Credit)

df <- Credit
head(df)
tail(df)
str(df)

#transform column to factor - categorical variable 
df$Cards <- factor(df$Cards)
df$column1 <- df$Limit + 500
df$column2 <- 'Bank Data'
  
# structure of dataframe
str(df)

##########################################
### plot functions in ggplot2 package ####
###           Introduction            ####
##########################################
#https://ggplot2.tidyverse.org

#install.packages("ggplot2")
library(ggplot2)

## GGPLOT CHEATSHEET: https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf
## https://ggplot2.tidyverse.org/reference/ggplot.html
## Data visualisation with ggplot2 - Chapter 3###

## ggplot is based on the philosophy of grammar of graphics
## the idea is to add layers to visualisation
## layers 1-3 
## layer 1: data , layer 2: aesthetics (data columns to use in plotting), 
## layer 3 : geometries (type of plot)
## layer 4-7: not necessary - allows to customise - facets (multiple plots on a single canvas), statistics(add a statistics layer), co-ords(limit co-ordinate values), theme (plot size, colouring etc)
head(Credit)
str(Credit)

#### scatterplot - correlation between two variables###
## First steps - ##
## Aesthetic mappings (data columns to use in plotting) ##
p1 <- ggplot(data=Credit, aes(x=Income, y=Balance)) 
## Geometric objects (type of plot) ##
p1 + geom_point()
p1 + geom_point(color='Blue', alpha=0.3)
p1 + geom_point(color='blue',alpha=0.5) + labs(x="Income", y="Balance", title="Balance vs. Income")
#https://www.color-hex.com
p1 + geom_point(color='#1AA13E',alpha=0.5)
#p1 + geom_point(color='blue',alpha=0.5, aes(shape=factor(Married))) 
#p2 <-  p1 + geom_point(color='blue',alpha=0.5) 



ggplot(data=Credit, aes(x=Income, y=Balance)) + geom_point(color='blue',alpha=0.5)
#change axis labels
ggplot(data=Credit, aes(x=Income, y=Balance)) + geom_point(color='blue',alpha=0.5) + labs(x="Income", y="Balance", title="Balance vs. Income")



#### histogram 1###
### in ggplot histogram is used to get frequency by band for for one continious variable

## data and aesthetics##
p <- ggplot(data=Credit, aes(x=Income))
# geometry
p + geom_histogram() 
p + geom_histogram() + labs(x='Income band',y='Count',title="Income distribution")

ggplot(data=Credit, aes(x=Income)) + geom_histogram(binwidth=20)

ggplot(data=Credit, aes(x=Income)) + geom_histogram(fill='blue',alpha=0.4,binwidth=10) + 
  labs(x='Income band',y='Count',title="Income distribution")


## Barplots ##
## in ggplot barplot is used to get frequency by category for a categorical variable##

## data and aesthetics
p <- ggplot(data=Credit,aes(x=Gender))
# geometry 
# barplot - categorical data, bars separated by spaces
p + geom_bar()
p + geom_bar(fill='blue', alpha=0.3)

ggplot(data=Credit,aes(x=Gender)) + geom_bar(fill='blue', alpha=0.5)

ggplot(data=Credit,aes(x=Gender)) + geom_bar(fill='blue', alpha=0.5) + 
   labs(x='Gender',y='Count',title="Gender distribution")

#bar plot for student
barplot <-   ggplot(data=Credit, aes(x=Student)) + geom_bar()
barplot

barplot2 <-   ggplot(data=Credit, aes(x=Married)) + geom_bar()
print(barplot2)

str(Credit)
## Boxplots ##
## quartiles, end of whiskers 1.5 IQL - check wiki

## data and aesthetics 
# discrete x, continuous y
## quartiles, end of whiskers 1.5 IQL - check wiki

## data and aesthetics
p <- ggplot(data=Credit, aes(x=Student, y=Balance))
# geometry - boxplot
p + geom_boxplot() 
# flip coords
p + geom_boxplot() + coord_flip()

ggplot(data=Credit, aes(x=Student, y=Balance)) + geom_boxplot() + 
  labs(x='Student',y='Balance',title="Balance Distribution by Student") 

ggplot(data=Credit, aes(x=Student, y=Balance)) + geom_boxplot(aes(fill=Student)) + 
  labs(x='Student',y='Balance',title="Balance Distribution by Student")


head(Credit)
#install.packages('dplyr')
library(dplyr)

# balance by Married flag
df.married.balance <- Credit %>% group_by(Married) %>% summarise(sum.balance=sum(Balance)) 
head(df.married.balance)
str(df.married.balance)

# balance by Married flag
# geom_col()  :  x = discrete, y=continious 
ggplot(data=df.married.balance, aes(x=Married, y=sum.balance)) + geom_col() + 
  labs(x='Married',y='Balance',title="Balance Distribution by Married") 

# balance by cards
df.cards.balance <- Credit %>% group_by(Cards) %>% summarise(sum.balance=sum(Balance)) %>% arrange(desc(Cards))
head(df.cards.balance)
str(df.cards.balance)

# balance by cards
# geom_col()  :  x = discrete, y=continious 
ggplot(data=df.cards.balance, aes(x=factor(Cards), y=sum.balance)) + geom_col() + 
  labs(x='Cards',y='Balance',title="Balance Distribution by Cards") 




#################################
### plot functions in Base R ####
#################################

# https://cran.r-project.org/doc/contrib/Short-refcard.pdf

# plot(x) plot of the values of x (on the y-axis) ordered on the x-axis
plot(Credit$Income)

#barplot
plot(Credit$Married)
#barplot
plot(factor(Credit$Education))
#barplot
plot(Credit$Gender)
# plot(x) plot of the values of x (on the y-axis) ordered on the x-axis
plot(Credit$Cards)
#barplot
plot(factor(Credit$Cards))
#histogram of cards
hist(Credit$Cards)
#boxplot
boxplot(Credit$Cards)



