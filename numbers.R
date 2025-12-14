library(tidyverse)
library(nycflights13)

# Making numbers
# readr provides two useful functions for parsing strings into numbers: 
## parse_double() and parse_number(). Use parse_double() 
## when you have numbers that have been written as strings:
x <- c("1.2", "5.6", "1e3")
parse_double(x)

##
x <- c("$1,234", "USD 3,513", "59%")
parse_number(x)

# Counts
# dplyr strives to make counting as easy as possible with count(). 
# This function is great for quick exploration and checks during analysis:

flights |> count(dest)

##
flights |> count(dest, sort = TRUE)

## And remember that if you want to see all the values, 
## you can use |> View() or |> print(n = Inf).

## You can perform the same computation “by hand” with group_by(), 
## summarize() and n(). This is useful because it allows you to compute 
## other summaries at the same time:

flights |> 
  group_by(dest) |> 
  summarize(
    n = n(),
    delay = mean(arr_delay, na.rm = TRUE)
  )

# n() is a special summary function that doesn’t take any arguments and 
# instead accesses information about the “current” group. 
# This means that it only works inside dplyr verbs:

## There are a couple of variants of n() and count() that you might find useful:

## n_distinct(x) counts the number of distinct (unique) values of one or 
## more variables. For example, we could figure out which destinations 
## are served by the most carriers:
flights |> 
  group_by(dest) |> 
  summarize(carriers = n_distinct(carrier)) |> 
  arrange(desc(carriers))

## A weighted count is a sum. For example you could “count” the number 
## of miles each plane flew:
flights |> 
  group_by(tailnum) |> 
  summarize(miles = sum(distance))

## Weighted counts are a common problem so count() 
## has a wt argument that does the same thing:
flights |> count(tailnum, wt = distance)

## You can count missing values by combining sum() and is.na(). 
## In the flights dataset this represents flights that are cancelled:
flights |> 
  group_by(dest) |> 
  summarize(n_cancelled = sum(is.na(dep_time)))

# Numeric transformations
## Arithmetic and recycling rules
## recycling rules which determine what happens when the left and 
## right hand sides have different lengths.
x <- c(1, 2, 10, 20)
x / 5
# is shorthand for
x / c(5, 5, 5, 5)

## These recycling rules are also applied to logical comparisons 
## (==, <, <=, >, >=, !=) and can lead to a surprising result if 
## you accidentally use == instead of %in% and the data frame has 
## an unfortunate number of rows

flights |> 
  filter(month == c(1, 2))

## Minimum and maximum
### The arithmetic functions work with pairs of variables. 
## Two closely related functions are pmin() and pmax(), 
## which when given two or more variables will return the smallest or 
## largest value in each row:

df <- tribble(
  ~x, ~y,
  1,  3,
  5,  2,
  7, NA,
)

df |> 
  mutate(
    min = pmin(x, y, na.rm = TRUE),
    max = pmax(x, y, na.rm = TRUE)
  )

## Modular arithmetic
##  In R, %/% does integer division and %% computes the remainder:
1:10 %/% 3

##
flights |> 
  mutate(
    hour = sched_dep_time %/% 100,
    minute = sched_dep_time %% 100,
    .keep = "used"
  )

##
flights |> 
  group_by(hour = sched_dep_time %/% 100) |> 
  summarize(prop_cancelled = mean(is.na(dep_time)), n = n()) |> 
  filter(hour > 1) |> 
  ggplot(aes(x = hour, y = prop_cancelled)) +
  geom_line(color = "grey50") + 
  geom_point(aes(size = n))


# General transformations
# (i)Ranks
## dplyr provides a number of ranking functions inspired by SQL, 
## but you should always start with dplyr::min_rank(). 
## It uses the typical method for dealing with ties, e.g., 1st, 2nd, 2nd, 4th.
x <- c(1, 5, 5, 17, 22, NA)
min_rank(x)

## Note that the smallest values get the lowest ranks; 
## use desc(x) to give the largest values the smallest ranks:

min_rank(desc(x))

## If min_rank() doesn’t do what you need, look at the variants 
## dplyr::row_number(), dplyr::dense_rank(), dplyr::percent_rank(), 
## and dplyr::cume_dist().
df <- tibble(x = x)
df |> 
  mutate(
    row_number = row_number(x),
    dense_rank = dense_rank(x),
    percent_rank = percent_rank(x),
    cume_dist = cume_dist(x)
  )

##
df <- tibble(id = 1:10)

df |> 
  mutate(
    row0 = row_number() - 1,
    three_groups = row0 %% 3,
    three_in_each_group = row0 %/% 3
  )

## (ii) Offsets
## dplyr::lead() and dplyr::lag() allow you to refer to the values just 
## before or just after the “current” value. They return a vector of 
## the same length as the input, padded with NAs at the start or end:

x <- c(2, 5, 11, 11, 19, 35)
lag(x)

lead(x)

##
# x - lag(x) gives you the difference between the current and previous value.

x - lag(x)
#> [1] NA  3  6  0  8 16

# x == lag(x) tells you when the current value changes.

x == lag(x)
#> [1]    NA FALSE FALSE  TRUE FALSE FALSE


## Consecutive identifiers
## Sometimes you want to start a new group every time some event occurs.
events <- tibble(
  time = c(0, 1, 2, 3, 5, 10, 12, 15, 17, 19, 20, 27, 28, 30)
)

## And you’ve computed the time between each event, and 
## figured out if there’s a gap that’s big enough to qualify:
events <- events |> 
  mutate(
    diff = time - lag(time, default = first(time)),
    has_gap = diff >= 5
  )
events

##
events |> mutate(
  group = cumsum(has_gap)
)

## Another approach for creating grouping variables is consecutive_id(), 
## which starts a new group every time one of its arguments changes
df <- tibble(
  x = c("a", "a", "a", "b", "c", "c", "d", "e", "a", "a", "b", "b"),
  y = c(1, 2, 3, 2, 4, 1, 3, 9, 4, 8, 10, 199)
)

## If you want to keep the first row from each repeated x, 
## you could use group_by(), consecutive_id(), and slice_head():
df |> 
  group_by(id = consecutive_id(x)) |> 
  slice_head(n = 1)

##
flights |> 
  mutate(hour = dep_time %/% 100) |> 
  group_by(year, month, day, hour) |> 
  summarize(
    dep_delay = mean(dep_delay, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  ) |> 
  filter(n > 5)


# Numeric summaries
## Center

