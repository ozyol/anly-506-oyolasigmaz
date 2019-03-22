# Author: Ozan Yolasigmaz
# Last modified: 20/03/2019
### Purpose: Data transformation-- Chapter 5 https://r4ds.had.co.nz/transform.html

library(nycflights13)
library(tidyverse)

# 5.1 Introduction ####

flights
# A tibble: 336,776 x 19
#year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time arr_delay carrier flight tailnum
#<int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>     <dbl> <chr>    <int> <chr>  
#  1  2013     1     1      517            515         2      830            819        11 UA        1545 N14228 

## dplyr functions
filter() # filter rows
arrange() # reorder rows
select () # select columns
mutate() # create new columns
summarise() # aggregate values

# 5.2 Filter rows with filter() ####

filter(flights, month == 1, day == 1) # filter flights for which month and day are 1

### logical operators
### ! not
### & and
### | or
xor() # exclusive or

is.na() # find if a value is missing

# 5.2.4 Exercises ####

# 1. ####
# Find all flights that:
# Had an arrival delay of two or more hours
filter(flights, arr_delay > 120)
# Flew to Houston (IAH or HOU)
filter(flights, dest == "IAH" | dest == "HOU")
# Were operated by United, American, or Delta
filter(flights, carrier %in% c("UA", "AA", "DL"))
# Departed in summer (July, August, and September)
filter(flights, month %in% c(7, 8, 9))
# Arrived more than two hours late, but didn’t leave late
filter(flights, arr_delay > 120 & dep_delay <= 0)
# Were delayed by at least an hour, but made up over 30 minutes in flight
filter(flights, dep_delay >= 60 & dep_delay - arr_delay >= 30)
# Departed between midnight and 6am (inclusive)
filter(flights, dep_time <= 600 | dep_time == 2400)

# 2. ####
# Another useful dplyr filtering helper is between(). What does it do? 
# Can you use it to simplify the code needed to answer the previous challenges?

### between(x, left, right) filters values to be in between left and right.
### We can simplify the one of the challenges as such:
# Departed in summer (July, August, and September)
filter(flights, month %in% c(7, 8, 9))
### New
filter(flights, between(month, 7, 9))

# 3. ####
# How many flights have a missing dep_time? What other variables are missing? 
# What might these rows represent?
nrow(flights[is.na(flights$dep_time),])
# [1] 8255

### Other columns with missing values:
colnames(flights)[colSums(is.na(flights)) > 0]
# [1] "dep_time"  "dep_delay" "arr_time"  "arr_delay" "tailnum"   "air_time" 
### Not sure what they represent, but they might coming from airports with security or who knows what?

# 4. ####
# Why is NA ^ 0 not missing? Why is NA | TRUE not missing? Why is FALSE & NA not missing? 
# Can you figure out the general rule? (NA * 0 is a tricky counterexample!)
NA ^ 0
### Anything to power zero is zero

NA | TRUE
### OR TRUE is always true

FALSE & NA
### AND FALSE is always false

### The rule seems to be this: if the value that NA is representing doesn't change the results and
### is just a placeholder basically, then we can compute these operations
NA * 0
### Not sure why this would work

# 5.3 Arrange rows with arrange() ####

# order flights by the three given columns, descending by the last, ascending by the rest
arrange(flights, year, month, desc(day))

# 5.3.1 Exercises ####

# 1. ####
# How could you use arrange() to sort all missing values to the start? (Hint: use is.na()).

arrange(flights, desc(is.na(dep_time)))
# A tibble: 336,776 x 19
#year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time arr_delay carrier flight tailnum
#<int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>     <dbl> <chr>    <int> <chr>  
#  1  2013     1     1       NA           1630        NA       NA           1815        NA EV        4308 N18120 
#  2  2013     1     1       NA           1935        NA       NA           2240        NA AA         791 N3EHAA 


# 2. ####
# Sort flights to find the most delayed flights. Find the flights that left earliest.

arrange(flights, desc(dep_delay))
#1  2013     1     9      641            900      1301     1242           1530      1272 HA          51 N384HA 
#2  2013     6    15     1432           1935      1137     1607           2120      1127 MQ        3535 N504MQ 
#3  2013     1    10     1121           1635      1126     1239           1810      1109 MQ        3695 N517MQ 

# 3. ####
# Sort flights to find the fastest flights.

arrange(flights, desc(distance/air_time))
#1  2013     5    25     1709           1700         9     1923           1937       -14 DL        1499 N666DN 
#2  2013     7     2     1558           1513        45     1745           1719        26 EV        4667 N17196 
#3  2013     5    13     2040           2025        15     2225           2226        -1 EV        4292 N14568 

# 4. ####
# Which flights travelled the longest? Which travelled the shortest?

# longest
arrange(flights, desc(distance))
#1  2013     1     1      857            900        -3     1516           1530       -14 HA          51 N380HA 
#2  2013     1     2      909            900         9     1525           1530        -5 HA          51 N380HA 
#3  2013     1     3      914            900        14     1504           1530       -26 HA          51 N380HA 

# shortest
arrange(flights, distance)
#1  2013     7    27       NA            106        NA       NA            245        NA US        1632 NA     
#2  2013     1     3     2127           2129        -2     2222           2224        -2 EV        3833 N13989 
#3  2013     1     4     1240           1200        40     1333           1306        27 EV        4193 N14972 

# 5.4 Select columns with select() ####

# select only the specified columns
select(flights, year, month, day)

starts_with() # matches strings that start with given string
ends_with() # matches strings that end with given string
contains() # matches strings that contain the given string
matches() # matches strings using a regular expression
num_range() # matches a num range following a string

# 5.4.1 Exercises ####

# 1. ####
# Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.
select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, dep_time:arr_delay, -(starts_with("sched")))
select(flights, starts_with(("dep_")), starts_with(("arr_")))

# 2. ####
# What happens if you include the name of a variable multiple times in a select() call?

select(flights, dep_time, arr_time, dep_time)
### Displays it just once, ignores the ones after the first

# 3. ####
# What does the one_of() function do? Why might it be helpful in conjunction with this vector?
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
?one_of
### Selects those that matches one of the strings in a given vector.

select(flights, one_of(vars))
#year month   day dep_delay arr_delay
#<int> <int> <int>     <dbl>     <dbl>
#  1  2013     1     1         2        11
#  2  2013     1     1         4        20

# 4. ####
# Does the result of running the following code surprise you? 
# How do the select helpers deal with case by default? How can you change that default?
select(flights, contains("TIME"))

### Apparently it uses lowercase, or it possibly matches strings irregardless of cases.

# 5.5 Add new variables with mutate() ####

mutate() # adds a new column based on a rule
transmute() # mutate and select only those columns

# 5.5.2 Exercises ####

# 1. ####
# Currently dep_time and sched_dep_time are convenient to look at, but hard to compute 
# with because they’re not really continuous numbers. Convert them to a more convenient 
# representation of number of minutes since midnight.

mutate(flights, dep_time_mins = floor(dep_time/100) * 60 + dep_time - floor(dep_time/100) * 100)
mutate(flights, sched_dep_time_mins = floor(sched_dep_time/100) * 60 + sched_dep_time - floor(sched_dep_time/100) * 100)

# 2. ####
# Compare air_time with arr_time - dep_time. What do you expect to see? What do you see? 
# What do you need to do to fix it?

filter(transmute(flights, air_time = arr_time - dep_time), air_time < 0)
### We have negative values, which shouldn't happen!
### To fix this, we need to take into account whether the dates of departure and arrival are
### the same or not

# 3. ####
# Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers 
# to be related?
select(flights, sched_dep_time, dep_time, dep_delay)

### sched_dep_time + dep_delay = dep_time (mod 2400)

# 4. ####
# Find the 10 most delayed flights using a ranking function. How do you want to handle ties? 
# Carefully read the documentation for min_rank().

arrange(mutate(flights, dep_rank = min_rank(flights$dep_delay)), desc(dep_rank))

# 5. ####
# What does 1:3 + 1:10 return? Why?
1:3 + 1:10
#  [1]  2  4  6  5  7  9  8 10 12 11
# Warning message:
#  In 1:3 + 1:10 :
#  longer object length is not a multiple of shorter object length

### It adds the elements of 1:3 to the elements of 1:10 and returns a vector of length 10.
### First it adds 1, then 2, then 3, then goes back to 1, and so on.

# 6. ####
# What trigonometric functions does R provide?

cos() # cosine
sin() # sine
tan() # tangent

acos() # arccosine
asin() # arcsine
atan() # arctangent

# 5.6 Grouped summaries with summarise() ####

summarise() # aggregate data

# here we are calculating the mean of dep_delay:
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

group_by() # groups by data to be used in aggregation

#%>% # piping operations
  
# 5.6.7 Exercises ####

# 1. ####
# Brainstorm at least 5 different ways to assess the typical delay characteristics 
# of a group of flights. Consider the following scenarios:
# A flight is 15 minutes early 50% of the time, and 15 minutes late 50% of the time.
# A flight is always 10 minutes late.
# A flight is 30 minutes early 50% of the time, and 30 minutes late 50% of the time.
# 99% of the time a flight is on time. 1% of the time it’s 2 hours late.
# Which is more important: arrival delay or departure delay?

flights %>% 
  group_by(tailnum) %>%
  summarise(
    avg_dep_delay = mean(dep_delay),
    avg_pos_dep_delay = mean(dep_delay[dep_delay > 0]),
    avg_neg_dep_delay = mean(dep_delay[dep_delay < 0]),
    avg_arr_delay = mean(arr_delay),
    avg_pos_arr_delay = mean(arr_delay[arr_delay > 0]),
    avg_neg_arr_delay = mean(arr_delay[arr_delay < 0]),
  ) %>%
  arrange(desc(avg_dep_delay))

### departure delay is more important because no one wants to wait at the airport

# 2. ####
# Come up with another approach that will give you the same output as 
# not_cancelled %>% count(dest) and not_cancelled %>% count(tailnum, wt = distance) 
# (without using count()).

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% count(dest)
#1 ABQ     254
#2 ACK     264
#3 ALB     418
#4 ANC       8

not_cancelled %>% group_by(dest) %>% summarize(n())
#1 ABQ     254
#2 ACK     264
#3 ALB     418
#4 ANC       8

not_cancelled %>% count(tailnum, wt = distance) 
#1 D942DN    3418
#2 N0EGMQ  239143
#3 N10156  109664
#4 N102UW   25722

not_cancelled %>% group_by(tailnum) %>% summarize(sum(distance))
#1 D942DN             3418
#2 N0EGMQ           239143
#3 N10156           109664
#4 N102UW            25722

# 3. ####
# Our definition of cancelled flights (is.na(dep_delay) | is.na(arr_delay) ) is 
# slightly suboptimal. Why? Which is the most important column?

flights %>% filter(is.na(dep_delay) & !is.na(arr_delay))
# A tibble: 0 x 19

flights %>% filter(!is.na(dep_delay) & is.na(arr_delay))
# A tibble: 1,175 x 19

### So, we could just use is.na(dep_delay) and we're good.

# 4. ####
# Look at the number of cancelled flights per day. Is there a pattern? 
# Is the proportion of cancelled flights related to the average delay?
  
flights %>% 
  group_by(day, month, year) %>% 
  summarise(
    mean_delay = mean(dep_delay, na.rm=TRUE),
    cancel_ratio = sum(is.na(dep_delay))/(sum(is.na(dep_delay)) + sum(!is.na(dep_delay)))
) %>%
  ggplot(mapping = aes(x = mean_delay, y = cancel_ratio)) + 
  geom_point() +
  geom_smooth(se = FALSE)

### Ignoring the outliers, we see that as the delays increase, cancel ratio increases as well.

# 5. ####
# Which carrier has the worst delays? Challenge: can you disentangle the effects of bad airports
# vs. bad carriers? Why/why not? 
# (Hint: think about flights %>% group_by(carrier, dest) %>% summarise(n()))

### Worst carriers
flights %>% 
  group_by(carrier) %>% 
  summarise(mean_delay = mean(dep_delay, na.rm=TRUE)) %>%
  arrange(desc(mean_delay))
#  1 F9           20.2 
#  2 EV           20.0 
#  3 YV           19.0 
#  4 FL           18.7 
#  5 WN           17.7 

### Worst destinations
flights %>% 
  group_by(dest) %>% 
  summarise(mean_delay = mean(dep_delay, na.rm=TRUE)) %>%
  arrange(desc(mean_delay))
#1 CAE         35.6
#2 TUL         34.9
#3 OKC         30.6
#4 BHM         29.7


### Worst carrier + dest combinations
flights %>% 
  group_by(carrier, dest) %>% 
  summarise(mean_delay = mean(dep_delay, na.rm=TRUE)) %>%
  arrange(desc(mean_delay))
#1 UA      STL         77.5
#2 OO      ORD         67  
#3 OO      DTW         61  
#4 UA      RDU         60  

### We can now remove the worst destinations from the list and run an average to remove the bias

# 6. ####
# What does the sort argument to count() do. When might you use it?

### Sorts output in descending order of counts. Useful when we want to see the top counts,
### rather than just calculating the counts.

# 5.7.1 Exercises ####

# 1. ####
# Refer back to the lists of useful mutate and filtering functions. Describe how each operation 
# changes when you combine it with grouping.

# 2. ####
# Which plane (tailnum) has the worst on-time record?

flights %>% group_by(tailnum) %>% filter(rank(desc(dep_delay)) < 2)
# 1  2013     1     1      826            715        71     1136           1045        51 AA         443 N3GVAA 

# 3. ####
# What time of day should you fly if you want to avoid delays as much as possible?

flights %>%
  filter(dep_delay > 0) %>% 
  mutate(dep_hour = round(dep_time/100)) %>%
  select(dep_hour, dep_delay) %>%
  group_by(dep_hour) %>%
  summarise(mean(dep_delay)) %>%
  arrange(desc(`mean(dep_delay)`))

### Avoid early morning:
#1        4             503  
#2        3             292. 
#3        2             238. 
#4        1             192. 

# 4. ####
# For each destination, compute the total minutes of delay. For each flight, 
# compute the proportion of the total delay for its destination.

# Total delay by destination
flights %>% 
  filter(!is.na(dep_delay)) %>% 
  group_by(dest) %>%
  summarise(sum(dep_delay))

# Proportion of delay per flights and its destination
flights %>% 
  filter(!is.na(dep_delay)) %>% 
  group_by(dest) %>%
  mutate(total_delay = sum(dep_delay),
         delay_prop = dep_delay/total_delay)

# 5. ####
# Delays are typically temporally correlated: even once the problem that caused the 
# initial delay has been resolved, later flights are delayed to allow earlier flights 
# to leave. Using lag(), explore how the delay of a flight is related to the delay of 
# the immediately preceding flight.

flights %>%
  filter(!is.na(dep_delay)) %>%
  group_by(origin) %>%
  mutate(prev_delay = lag(dep_delay),
         imposed_delay = dep_delay - prev_delay) %>%
  filter(imposed_delay > 0)
# A tibble: 164,508 x 21

# Out of 328,511 flights, 164,508 of them, or about half, have had delays imposed
# on them by the previous flights.

# 6. ####
# Look at each destination. Can you find flights that are suspiciously fast? (i.e. 
# flights that represent a potential data entry error). Compute the air time a flight 
# relative to the shortest flight to that destination. Which flights were most delayed 
# in the air?

### Not sure what's happening here.

# 7. ####
# Find all destinations that are flown by at least two carriers. Use that information 
# to rank the carriers.

flights %>%
  filter(!is.na(dep_delay)) %>%
  group_by(dest) %>%
  filter(n_distinct(carrier) > 1) %>%
  group_by(carrier) %>%
  summarise(total_dest = n_distinct(dest)) %>%
  arrange(desc(total_dest))

# The carriers that go to the more popular destinations the most:
#1 EV              51
#2 9E              48
#3 UA              42
#4 DL              39
#5 B6              35






