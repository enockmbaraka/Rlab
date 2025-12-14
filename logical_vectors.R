library(tidyverse)
library(nycflights13)

##
x <- c(1, 2, 3, 5, 7, 11, 13)
x * 2

##
df <- tibble(x)
df |> 
  mutate(y = x * 2)

# Comparisons(<, <=, >, >=, !=, and ==.)
flights |> 
  filter(dep_time > 600 & dep_time < 2000 & abs(arr_delay) < 20)

##
flights |> 
  mutate(
    daytime = dep_time > 600 & dep_time < 2000,
    approx_ontime = abs(arr_delay) < 20,
    .keep = "used"
  )


##
flights |> 
  mutate(
    daytime = dep_time > 600 & dep_time < 2000,
    approx_ontime = abs(arr_delay) < 20,
  ) |> 
  filter(daytime & approx_ontime)

# Floating point comparison(==)
x <- c(1 / 49 * 49, sqrt(2) ^ 2)
x

##
x == c(1, 2)

# missing values
flights |> 
  filter(dep_time == NA)

# is.na()
## is.na(x) works with any type of vector and 
## returns TRUE for missing values and FALSE for everything else:
is.na(c(TRUE, NA, FALSE))
is.na(c(1, NA, 3))
is.na(c("a", NA, "b"))

##
flights |> 
  filter(is.na(dep_time))

##
flights |> 
  filter(month == 1, day == 1) |> 
  arrange(dep_time)

##
flights |> 
  filter(month == 1, day == 1) |> 
  arrange(desc(is.na(dep_time)), dep_time)


#Boolean algebra
## In R, & is “and”, | is “or”, ! is “not”, and xor() is exclusive or


# Order of operations
flights |> 
  filter(month == 11 | month == 12)

##
flights |> 
  mutate(
    nov = month == 11,
    final = nov | 12,
    .keep = "used"
  )


## %in%
### %in% y returns a logical vector the same length as x that is 
### TRUE whenever a value in x is anywhere in y .

flights |> 
  filter(month %in% c(11, 12))

##
flights |> 
  group_by(year, month, day) |> 
  summarize(
    all_delayed = all(dep_delay <= 60, na.rm = TRUE),
    any_long_delay = any(arr_delay >= 300, na.rm = TRUE),
    .groups = "drop"
  )


# Logical summaries
## There are two main logical summaries: any() and all(). any(x) is 
## the equivalent of |; it’ll return TRUE if there are any TRUE’s in x. all(x)
## is equivalent of &; it’ll return TRUE only if all values of x are TRUE’s. 
## Like most summary functions, you can make the missing values 
## go away with na.rm = TRUE.
flights |> 
  group_by(year, month, day) |> 
  summarize(
    all_delayed = all(dep_delay <= 60, na.rm = TRUE),
    any_long_delay = any(arr_delay >= 300, na.rm = TRUE),
    .groups = "drop"
  )


# Numeric summaries of logical vectors
# When you use a logical vector in a numeric context, 
# TRUE becomes 1 and FALSE becomes 0. This makes sum() and mean() 
# very useful with logical vectors because sum(x) gives the number of 
# TRUEs and mean(x) gives the proportion of TRUEs (because mean() is 
# just sum() divided by length()).

flights |> 
  group_by(year, month, day) |> 
  summarize(
    proportion_delayed = mean(dep_delay <= 60, na.rm = TRUE),
    count_long_delay = sum(arr_delay >= 300, na.rm = TRUE),
    .groups = "drop"
  )

# Logical subsetting
flights |> 
  filter(arr_delay > 0) |> 
  group_by(year, month, day) |> 
  summarize(
    behind = mean(arr_delay),
    n = n(),
    .groups = "drop"
  )

##
flights |> 
  group_by(year, month, day) |> 
  summarize(
    behind = mean(arr_delay[arr_delay > 0], na.rm = TRUE),
    ahead = mean(arr_delay[arr_delay < 0], na.rm = TRUE),
    n = n(),
    .groups = "drop"
  )


# Conditional transformations
## There are two important tools for this: if_else() and case_when().
## (i) if_else()
x <- c(-3:3, NA)
if_else(x > 0, "+ve", "-ve")

## There’s an optional fourth argument, missing which will be 
## used if the input is NA:
if_else(x > 0, "+ve", "-ve", "???")

##
x1 <- c(NA, 1, 2, NA)
y1 <- c(3, NA, 4, 6)
if_else(is.na(x1), y1, x1)

##
if_else(x == 0, "0", if_else(x < 0, "-ve", "+ve"), "???")


## (ii)case_when()
x <- c(-3:3, NA)
case_when(
  x == 0   ~ "0",
  x < 0    ~ "-ve", 
  x > 0    ~ "+ve",
  is.na(x) ~ "???"
)

## Use .default if you want to create a “default”/catch all value:
case_when(
  x < 0 ~ "-ve",
  x > 0 ~ "+ve",
  .default = "???"
)

##
flights |> 
  mutate(
    status = case_when(
      is.na(arr_delay)      ~ "cancelled",
      arr_delay < -30       ~ "very early",
      arr_delay < -15       ~ "early",
      abs(arr_delay) <= 15  ~ "on time",
      arr_delay < 60        ~ "late",
      arr_delay < Inf       ~ "very late",
    ),
    .keep = "used"
  )
