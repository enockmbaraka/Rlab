# data transformation using the dplyr package
library(nycflights13)
library(tidyverse)

# dataset purview
nycflights13::flights

# using glimpse()
glimpse(flights)

# dplyr basics-dplyr verbs (functions)
# These functions solves data manipulation challenges. 
# common traits of these verbs
## The first argument is always a data frame.
## The subsequent arguments typically describe which 
### columns to operate on using the variable names (without quotes).
## The output is always a new data frame.

## using pipe operator(|> or %>%) to combine multiple verbs
##pipe takes the thing on its left and passes it along to the function on right

flights |>
  filter(dest == "IAH") |> 
  group_by(year, month, day) |> 
  summarize(
    arr_delay = mean(arr_delay, na.rm = TRUE)
  )

## dplyr’s verbs are organized into four groups based on what they operate on:
### rows, columns, groups, or tables.
## 1.Rows-filter(), arrange(), distinct()
## filter(), which changes which rows are present without changing their order.
### and arrange(), which changes the order of the rows without
#### changing which are present. 
## Both functions only affect the rows, and the columns are left unchanged. 
## distinct() which finds rows with unique values

## (i)filter() 
### filter() allows you to keep rows based on the values of the columns.
### The first argument is the data frame. 
### The second and subsequent arguments are the conditions
#### that must be true to keep the row.
flights |> 
  filter(dep_delay > 120)

# Flights that departed on January 1
flights |> 
  filter(month == 1 & day == 1)

# Flights that departed in January or February
flights |> 
  filter(month == 1 | month == 2)

##There’s a useful shortcut when you’re combining | and ==: %in%. 
##It keeps rows where the variable equals one of the values on the right:

# A shorter way to select flights that departed in January or February
flights |> 
  filter(month %in% c(1, 2))

## When you run filter() dplyr executes the filtering operation, 
###creating a new data frame, and then prints it. 
###It doesn’t modify the existing flights dataset because dplyr 
###functions never modify their inputs. To save the result, 
####you need to use the assignment operator, <-:

jan1 <- flights |> 
  filter(month == 1 & day == 1)

glimpse(jan1)


## (ii)arrange() 
### arrange() changes the order of the rows based on the value of the columns.
### It takes a data frame and a set of column names 
####(or more complicated expressions) to order by. 
### If you provide more than one column name, 
### each additional column will be used to break ties in the values
### of the preceding columns. For example, the following code sorts 
### by the departure time, which is spread over four columns.

flights |> 
  arrange(year, month, day, dep_time)

flights |> 
  arrange(desc(dep_delay))


## (iii)distinct() 
### distinct() finds all the unique rows in a dataset, so technically,
### it primarily operates on the rows. Most of the time, however, 
### you’ll want the distinct combination of some variables, 
### so you can also optionally supply column names:

# Remove duplicate rows, if any
flights |> 
  distinct()

# Find all unique origin and destination pairs
flights |> 
  distinct(origin, dest)

## Alternatively, if you want to keep the other columns when filtering
## for unique rows, you can use the .keep_all = TRUE option.
flights |> 
  distinct(origin, dest, .keep_all = TRUE)

## If you want to find the number of occurrences instead,
## you’re better off swapping distinct() for count(). 
## With the sort = TRUE argument, 
## you can arrange them in descending order of the number of occurrences.
flights |>
  count(origin, dest, sort = TRUE)

## 2.Columns
### mutate() creates new columns that are derived from the existing columns, 
### select() changes which columns are present, 
### rename() changes the names of the columns, and 
### relocate() changes the positions of the columns.

### (i)mutate()-adds new columns that are calculated from the existing columns.
flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60
  )

#### By default, mutate() adds new columns on the right-hand 
#### side of your dataset, which makes it difficult to 
#### see what’s happening here. We can use the .before argument to instead 
#### add the variables to the left-hand side.
flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .before = 1
  )

#### You can also use .after to add after a variable, and in both .before
#### and .after you can use the variable name instead of a position
flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .after = day
  )

#### Alternatively, you can control which variables are kept 
#### with the .keep argument. A particularly useful argument 
#### is "used" which specifies that we only keep the columns that were 
#### involved or created in the mutate() step.

flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours,
    .keep = "used"
  )


### (ii) select()- allows one to select relevant columns.
#### select() allows you to rapidly zoom in on a useful 
#### subset using operations based on the names of the variables:

### Select columns by name:

flights |> 
  select(year, month, day)

### Select all columns between year and day (inclusive):

flights |> 
  select(year:day)

### Select all columns except those from year to day (inclusive):

flights |> 
  select(!year:day)



## Select all columns that are characters:

flights |> 
  select(where(is.character))

### There are a number of helper functions you can use within select():
#### starts_with("abc"): matches names that begin with “abc”.
#### ends_with("xyz"): matches names that end with “xyz”.
#### contains("ijk"): matches names that contain “ijk”.
#### num_range("x", 1:3): matches x1, x2 and x3.

### You can rename variables as you select() them by using =. 
#### The new name appears on the left-hand side of the =, and 
#### the old variable appears on the right-hand side:

flights |> 
  select(tail_num = tailnum)

###  (iii)rename() 
#### If you want to keep all the existing variables and 
#### just want to rename a few, you can use rename() instead of select():

flights |> 
  rename(tail_num = tailnum)

### (iv)relocate() 
#### Use relocate() to move variables around. 
#### You might want to collect related variables together or 
#### move important variables to the front. By default relocate() 
#### moves variables to the front:

flights |> 
  relocate(time_hour, air_time)

#### You can also specify where to put them 
#### using the .before and .after arguments
flights |> 
  relocate(year:dep_time, .after = time_hour)
flights |> 
  relocate(starts_with("arr"), .before = dep_time)

## Pipe
flights |> 
  filter(dest == "IAH") |> 
  mutate(speed = distance / air_time * 60) |> 
  select(year:day, dep_time, carrier, flight, speed) |> 
  arrange(desc(speed))

## 3.Groups
### group_by(), summarize(), and the slice family of functions.

### (i)group_by() 
#### group_by() to divides dataset into groups meaningful for your analysis:
flights |> 
  group_by(month)

### (ii)summarize() 
#### The most important grouped operation is a summary, which, 
### if being used to calculate a single summary statistic, 
#### reduces the data frame to have a single row for each group. 

flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay)
  )

flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE)
  )
#### one useful summary is n(), which returns the number of rows in each group:
flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE), 
    n = n()
  )

#### grouping by multiple variables
daily <- flights |>  
  group_by(year, month, day)
daily


daily_flights <- daily |> 
  summarize(n = n())


daily_flights <- daily |> 
  summarize(
    n = n(), 
    .groups = "drop_last"
  )

### (iii)Ungrouping
#### You might also want to remove grouping from a data frame without 
#### using summarize(). You can do this with ungroup().
daily |> 
  ungroup()

#### You get a single row back because dplyr treats all the rows 
#### in an ungrouped data frame as belonging to one group.
daily |> 
  ungroup() |>
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE), 
    flights = n()
  )

####  syntax for per-operation grouping, the .by argument.
#### .by works with all verbs and has the advantage that 
#### you don’t need to use the .groups argument to suppress 
#### the grouping message or ungroup() when you’re done.
flights |> 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE), 
    n = n(),
    .by = month
  )

#### Or if you want to group by multiple variables:
flights |> 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE), 
    n = n(),
    .by = c(origin, dest)
  )

### (iv)The slice_ functions
#### There are five handy functions that allow you to 
#### extract specific rows within each group:

##1.df |> slice_head(n = 1) takes the first row from each group.
##2.df |> slice_tail(n = 1) takes the last row in each group.
##3.df |> slice_min(x, n = 1) takes the row with the smallest value of column x.
##4.df |> slice_max(x, n = 1) takes the row with the largest value of column x.
##5.df |> slice_sample(n = 1) takes one random row.

flights |> 
  group_by(dest) |> 
  slice_max(arr_delay, n = 1) |>
  relocate(dest)