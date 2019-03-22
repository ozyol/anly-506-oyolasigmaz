# Author: Ozan Yolasigmaz
# Last modified: 20/03/2019
### Purpose: Import Files -- Chapter 11 https://r4ds.had.co.nz/data-import.html 

library(tidyverse)

# 11.2 Getting started ####
read_csv() # read csv files with ; delimiter
read_csv2() # read csv files with ; delimiter
read_tsv() # read tsv files with \t delimiter
read_delim() # read text files with any delimiter

read_fwf() # read fixed-width files
read_table() # read fwf that uses white spaces as delimiter
read_log() # read Apache style log files

# 11.2.2 Exercises ####

# 1. ####
# What function would you use to read a file where fields were separated with “|”?
### read_delim(file, delim) allows us to specify any delimiter.

# 2. #### 
# Apart from file, skip, and comment, what other arguments do read_csv() and read_tsv() 
# have in common?

?read_csv
### We see that both read_csv() and read_tsv() are special cases of the read_delim() function.
### The other shared arguments are col_names, col_types, locale, na, quoted_na, quote, trim_ws, 
### n_max, guess_max, and progress.

# 3. #### 
# What are the most important arguments to read_fwf()?

?read_fwf
# read_fwf(file, col_positions, col_types = NULL, locale = default_locale(),
#   na = c("", "NA"), comment = "", skip = 0, n_max = Inf,
#   guess_max = min(n_max, 1000), progress = show_progress())
### The non-default, therefore more important, arguments of read_fwf() are file and col_positions.

# 4. #### 
# Sometimes strings in a CSV file contain commas. To prevent them from causing problems they 
# need to be surrounded by a quoting character, like " or '. By convention, read_csv() assumes 
# that the quoting character will be ", and if you want to change it you’ll need to use 
# read_delim() instead. What arguments do you need to specify to read the following text into a 
# data frame?
# "x,y\n1,'a,b'"

### We use read_delim() function with the following arguments:
### escape_backlash=TRUE -- to read \n correctly
### delim=","
### quote="'" -- in order not to mistake and split 'a,b' string at the comma
read_delim("x,y\n1,'a,b'", escape_backslash=TRUE, delim=",", quote="'")
# A tibble: 1 x 2
#        x     y    
#      <int> <chr>
#  1     1    a,b  

# 5. #### 
# Identify what is wrong with each of the following inline CSV files. What happens when 
# you run the code?

### Unfortunately the tidyverse error messages are a bit messed up here, e.g.:
Warning: 2 parsing failures.
# row # A tibble: 2 x 5 col     row col   expected                     actual    file         expected   
# <int> <chr> <chr>                        <chr>     <chr>        actual 1     1 a     closing quote at 
# end of file ""        literal data file 2     1 NA    2 columns                    1 columns literal data

read_csv("a,b\n1,2,3\n4,5,6")
# Warning: 2 parsing failures.
### We get this error because the rows are of different sizes

read_csv("a,b,c\n1,2\n1,2,3,4")
# Warning: 2 parsing failures.
### Again, the rows are of different sizes

read_csv("a,b\n\"1")
# Warning: 2 parsing failures.
# There is a backslash-escaped quote in the second row, which leaves the last quote alone, leading to error.

read_csv("a,b\n1,2\na,b")
# This one works actually, no problems detected.

read_csv("a;b\n1;3")
# Delimiter is ";" instead of ",", so we should use read_csv2() instead.

# 11.3 Parsing a vector ####
parse_*() # parse variable of type *
# Here, * can be any of the following:
### Logical
### Integer
### Date
### Time
### Datetime
### Double
### Number
### Character
### Factor

# 11.3.2 Strings ####
charToRaw() # raw representation of a string
parse_character() # parses character using default encoding
### Arguments: locale for specifying locale/encoding

guess_encoding() # guess encoding of the string

# 11.3.3 Factors ####
parse_factor() # parse categorical variables at levels

# 11.3.4 Dates, date-times, and times ####
parse_date() # parse dates
parse_time() # parse time
parse_datetime() # parse datetime
### In these datetime functions, we may need to specify the format of date/time/datetime
### using the following schema:
### %Y (4 digits).
### %y (2 digits); 00-69 -> 2000-2069, 70-99 -> 1970-1999.
### Month
### %m (2 digits).
### %b (abbreviated name, like “Jan”).
### %B (full name, “January”).
### Day
### %d (2 digits).
### %e (optional leading space).
### Time
### %H 0-23 hour.
### %I 0-12, must be used with %p.
### %p AM/PM indicator.
### %M minutes.
### %S integer seconds.
### %OS real seconds.
### %Z Time zone (as name, e.g. America/Chicago). Beware of abbreviations: if you’re American, note that “EST” is a Canadian time zone that does not have daylight savings time. It is not Eastern Standard Time! We’ll come back to this time zones.
### %z (as offset from UTC, e.g. +0800).
### Non-digits
### %. skips one non-digit character.
### %* skips any number of non-digits.

# 11.3.5 Exercises ####

# 1. ####
# What are the most important arguments to locale()?

### date_names is the most important argument, which is the language code as string.

# 2. ####
# What happens if you try and set decimal_mark and grouping_mark to the same character? 
# What happens to the default value of grouping_mark when you set decimal_mark to “,”? 
# What happens to the default value of decimal_mark when you set the grouping_mark to “.”?

locale(decimal_mark=",", grouping_mark=",")
# Error: `decimal_mark` and `grouping_mark` must be different

### We cannot do so, however, if we were able to, then we would not be able to identify decimals
### or groupings in any number that is large or that is decimal.

### If decimal_mark is set to ",", grouping_mark is set to ".".
### If grouping_mark is set to ",', then the grouping mark is set to "." since decimal mark can 
### only be ",", or ".".

# 3. ####
# I didn’t discuss the date_format and time_format options to locale(). What do they do? 
# Construct an example that shows when they might be useful.

### They set the default date and time formats.
### In the following example, date_format determines what our output will be, and comes in handy
### when we need to convert our dates to "American."
parse_guess("01/02/2013", locale = locale(date_format = "%m/%d/%Y"))
# [1] "2013-01-02"
parse_guess("01/02/2013", locale = locale(date_format = "%d/%m/%Y"))
# [1] "2013-02-01"

# 4. ####
# If you live outside the US, create a new locale object that encapsulates the settings for the 
# types of file you read most commonly.

### Say we live in the US but need to read files in French.
locale(date_names="fr", date_format = "%m/%d/%Y", decimal_mark=".", grouping_mark=",")

# 5. ####
# What’s the difference between read_csv() and read_csv2()?

### read_csv() has delim="," and read_csv2() has delim=";" due to difference in European/American
### number systems.

# 6. ####
# What are the most common encodings used in Europe? 
# What are the most common encodings used in Asia? Do some googling to find out.

### ASCII is the most common encoding overall.
### In Europe, Western European encodings are the most common, e.g. ISO 8859-1, ISO 8859-15, cp1252
### In Asia, Chinese and Korean encodings are the most common, e.g. GB2312, EUC-KR.

# 7. ####
# Generate the correct format string to parse each of the following dates and times:

d1 <- "January 1, 2010"
parse_date(d1, "%B %d, %Y")
# [1] "2010-01-01"

d2 <- "2015-Mar-07"
parse_date(d2, "%Y-%b-%d")
# [1] "2015-03-07"

d3 <- "06-Jun-2017"
parse_date(d3, "%d-%b-%Y")
# [1] "2017-06-06"

d4 <- c("August 19 (2015)", "July 1 (2015)")
parse_date(d4, "%B %d (%Y)")
# [1] "2015-08-19" "2015-07-01"

d5 <- "12/30/14" # Dec 30, 2014
parse_date(d5, "%m/%d/%y")
# [1] "2014-12-30"

t1 <- "1705"
parse_time(t1, "%H%M")
# 17:05:00

t2 <- "11:15:10.12 PM"
parse_time(t2, "%I:%M:%OS %p")
# 23:15:10.12

# 11.4 Parsing a file ####
guess_parser() # guesses column type
parse_guess() # parses using the above guess

# 11.5 Writing to a file ####
write_csv() # writes data frame as a csv file
write_rds() # writes data frame in rds format, which is R's base format
read_rds() # reads rds files



