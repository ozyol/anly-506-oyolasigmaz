# Author: Ozan Yolasigmaz
# Last modified: 20/03/2019
### Purpose: Matrices and Dataframes -- Chapter 8 https://bookdown.org/ndphillips/YaRrr/matricesdataframes.html

library(tidyverse)

# Chapter 8 Matrices and Dataframes ####

head() # top rows of data
str() # structure of data
View() # view data in new R window
names() # names of columns
nrow() # number of rows

mean() # arithmetic mean of a vector
table() # group by categories and count, creating an aggregated count table
max() # max value of a vector

# 8.2 Creating matrices and dataframes ####
cbind() # combine vectors as columns to create data frame
rbind() # combine vectors as rows to create data frame
matrix() # create matrix from vector after specifying number of rows and columns
data.frame() # create data frame from named vectors which become columns

### some preloaded data sets in R
# ChickWeight
# InsectSprays
# ToothGrowth
# PlantGrowth

# 8.3 Matrix and dataframe functions ####
head() # top few rows
tail() # bottom few rows
View() # view data in new R window
nrow() # number of rows
ncol() # number of columns
dim() # dimensions of data frame
rownames() # row names 
colnames() # column names
names() # column names
str() # structure/schema of data frame
summary() # summary statistics of data frame

# 8.4 Dataframe column names ####

# To add a new column:
# df$newColumnName <- c(newColumnVector)

# To change the name of a column:
# modify names(df) vector

# 8.5 Slicing dataframes ####

# get nth row
df[n, ]

# get nth column
df[, n]

subset() # subset of a data frame using a logical operator

# 8.6 Combining slicing with functions ####

with() # allows us to specify the data frame once and not have to refer to it again

# 8.7 Test your R might! Pirates and superheroes ####

# 1. Combine the data into a single dataframe. Complete all the following exercises from the dataframe!
df <- read_tsv("Name	Sex	Age	Superhero	Tattoos
                 Astrid	F	30	Batman	11
                 Lea	F	25	Superman	15
                 Sarina	F	25	Batman	12
                 Remon	M	29	Spiderman	5
                 Letizia	F	22	Batman	65
                 Babice	F	22	Antman	3
                 Jonas	M	35	Batman	9
                 Wendy	F	19	Superman	13
                 Niveditha	F	32	Maggott	900
                 Gioia	F	21	Superman	0")

# 2. What is the median age of the 10 pirates?
median(df$Age)
# [1] 25

# 3. What was the mean age of female and male pirates separately?
mean(df[df$Sex == "F", ]$Age)
# [1] 24.5
mean(df[df$Sex == "M", ]$Age)
# [1] 32

# 4. What was the most number of tattoos owned by a male pirate?
max(df[df$Sex == "M", ]$Tattoos)
# [1] 9

# 5. What percent of pirates under the age of 32 were female?
count(df[df$Age < 32,][df[df$Age < 32,]$Sex == "F",]) / count(df[df$Age < 32,])
#     n
# 1 0.875

# 6. What percent of female pirates are under the age of 32?
count(df[df$Sex == "F",][df[df$Sex == "F",]$Age < 32, ]) / count(df[df$Sex == "F",])
#     n
# 1 0.875

# 7. Add a new column to the dataframe called tattoos.per.year which shows how many tattoos each pirate has for each year in their life.
df$tattoos.per.year <- df$Tattoos/df$Age

# 8. Which pirate had the most number of tattoos per year?
df[df$tattoos.per.year == max(df$tattoos.per.year),]$Name
# [1] "Niveditha"

# 9. What are the names of the female pirates whose favorite superhero is Superman?
df[df$Superhero == "Superman",]$Name
# [1] "Lea"   "Wendy" "Gioia"

# 10. What was the median number of tattoos of pirates over the age of 20 whose favorite superhero is Spiderman?
median(df[df$Age > 20 & df$Superhero == "Spiderman", ]$Age)
# [1] 29


