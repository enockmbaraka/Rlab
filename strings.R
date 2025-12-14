library(tidyverse)
library(babynames)
# install.packages("babynames")

# Creating a string
string1 <- "This is a string"
string2 <- 'If I want to include a "quote" inside a string, I use single quotes'
print(string1)

# Escapes
# To include a literal single or double quote in a 
# string, you can use \ to “escape” it:
double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'"

# So if you want to include a literal backslash in your string, 
# you’ll need to escape it: "\\":
backslash <- "\\"

# To see the raw contents of the string, use str_view()1:
x <- c(single_quote, double_quote, backslash)
x
str_view(x)

# Raw strings
tricky <- "double_quote <- \"\\\"\" # or '\"'
single_quote <- '\\'' # or \"'\""
str_view(tricky)

# Other special characters
x <- c("one\ntwo", "one\ttwo", "\u00b5", "\U0001f604")
x
str_view(x)

# Creating many strings from data
## (i) str_c()
## str_c() takes any number of vectors as arguments and 
## returns a character vector:
str_c("x", "y")
str_c("x", "y", "z")
str_c("Hello ", c("John", "Susan"))

## str_c() is very similar to the base paste0(), 
## but is designed to be used with mutate() by obeying the usual 
## tidyverse rules for recycling and propagating missing values:
df <- tibble(name = c("Flora", "David", "Terra", NA))
df |> mutate(greeting = str_c("Hi ", name, "!"))

## If you want missing values to display in another way, 
## use coalesce() to replace them. Depending on what you want, 
## you might use it either inside or outside of str_c():
df |> 
  mutate(
    greeting1 = str_c("Hi ", coalesce(name, "you"), "!"),
    greeting2 = coalesce(str_c("Hi ", name, "!"), "Hi!")
  )


## (ii)str_glue()
df |> mutate(greeting = str_glue("Hi {name}!"))
##
df |> mutate(greeting = str_glue("{{Hi {name}!}}"))

## (iii)str_flatten()
## str_c() and str_glue() work well with mutate() because their 
## output is the same length as their inputs. What if you want a 
## function that works well with summarize(), i.e. something that 
## always returns a single string? That’s the job of str_flatten()5: 
## it takes a character vector and combines each element of the vector 
## into a single string:
str_flatten(c("x", "y", "z"))
str_flatten(c("x", "y", "z"), ", ")
str_flatten(c("x", "y", "z"), ", ", last = ", and ")

## This makes it work well with summarize():
df <- tribble(
  ~ name, ~ fruit,
  "Carmen", "banana",
  "Carmen", "apple",
  "Marvin", "nectarine",
  "Terence", "cantaloupe",
  "Terence", "papaya",
  "Terence", "mandarin"
)
df |>
  group_by(name) |> 
  summarize(fruits = str_flatten(fruit, ", "))

## Extracting data from strings
df |> separate_longer_delim(col, delim)
df |> separate_longer_position(col, width)
df |> separate_wider_delim(col, delim, names)
df |> separate_wider_position(col, widths)

### Separating into rows
df1 <- tibble(x = c("a,b,c", "d,e", "f"))
df1 |> 
  separate_longer_delim(x, delim = ",")
##
df2 <- tibble(x = c("1211", "131", "21"))
df2 |> 
  separate_longer_position(x, width = 1)

### Separating into columns
df3 <- tibble(x = c("a10.1.2022", "b10.2.2011", "e15.1.2015"))
df3 |> 
  separate_wider_delim(
    x,
    delim = ".",
    names = c("code", "edition", "year")
  )

##
df3 |> 
  separate_wider_delim(
    x,
    delim = ".",
    names = c("code", NA, "year")
  )

##
df4 <- tibble(x = c("202215TX", "202122LA", "202325CA")) 
df4 |> 
  separate_wider_position(
    x,
    widths = c(year = 4, age = 2, state = 2)
  )

### Diagnosing widening problem
df <- tibble(a = c("1-1-1", "1-1-2", "1-3", "1-3-2", "1"))

df |> 
  separate_wider_delim(
    a,
    delim = "-",
    names = c("x", "y", "z")
  )
##
debug <- df |> 
  separate_wider_delim(
    a,
    delim = "-",
    names = c("x", "y", "z"),
    too_few = "debug"
  )
##
debug |> filter(!a_ok)

##
df |> 
  separate_wider_delim(
    a,
    delim = "-",
    names = c("x", "y", "z"),
    too_few = "align_start"
  )
##
df <- tibble(a = c("1-1-1", "1-1-2", "1-3-5-6", "1-3-2", "1-3-5-7-9"))

df |> 
  separate_wider_delim(
    a,
    delim = "-",
    names = c("x", "y", "z")
  )
##
debug <- df |> 
  separate_wider_delim(
    a,
    delim = "-",
    names = c("x", "y", "z"),
    too_many = "debug"
  )
##
df |> 
  separate_wider_delim(
    a,
    delim = "-",
    names = c("x", "y", "z"),
    too_many = "drop"
  )
##
df |> 
  separate_wider_delim(
    a,
    delim = "-",
    names = c("x", "y", "z"),
    too_many = "merge"
  )

## Length- str_length() tells you the number of letters in the string:
str_length(c("a", "R for data science", NA))

###
babynames |>
  count(length = str_length(name), wt = n)

###
babynames |> 
  filter(str_length(name) == 15) |> 
  count(name, wt = n, sort = TRUE)

##Subsetting
### You can extract parts of a string using str_sub(string, start, end), 
### where start and end are the positions where the substring should start 
### and end. The start and end arguments are inclusive, so the length of 
### the returned string will be end - start + 1:

x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)

##
str_sub(x, -3, -1)
##
str_sub("a", 1, 5)

## 
babynames |> 
  mutate(
    first = str_sub(name, 1, 1),
    last = str_sub(name, -1, -1)
  )