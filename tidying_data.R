# Tidying data
library(tidyverse)

#There are three interrelated rules that make a dataset tidy:
## 1.Each variable is a column; each column is a variable.
## 2.Each observation is a row; each row is an observation.
## 3.Each value is a cell; each cell is a single value.

# Each dataset shows the same values of four variables: country, year, 
# population, and number of documented cases of TB (tuberculosis), 
# but each dataset organizes the values in a different way.
table1
table2
table3

# Compute rate per 10,000
table1 |>
  mutate(rate = cases / population * 10000)


# Compute total cases per year
table1 |> 
  group_by(year) |> 
  summarize(total_cases = sum(cases))


# Visualize changes over time
ggplot(table1, aes(x = year, y = cases)) +
  geom_line(aes(group = country), color = "grey50") +
  geom_point(aes(color = country, shape = country)) +
  scale_x_continuous(breaks = c(1999, 2000)) # x-axis breaks at 1999 and 2000

# Pivoting data
# tidyr provides two functions for pivoting data: 

## 1.Lengthening data
#### pivot_longer()

## Data in column names
## The billboard dataset records the billboard rank of songs in the year 2000:
## The first three columns (artist, track and date.entered)
## are variables that describe the song
billboard

# To tidy this data, we’ll use pivot_longer():
## After the data, there are three key arguments:
## 1. cols -specifies which columns need to be pivoted, i.e. 
### which columns aren’t variables. 
### This argument uses the same syntax as select()
### so here we could use !c(artist, track, date.entered) or starts_with("wk").
## 2. names_to -names the variable stored in the column names, 
## we named that variable week.
## 3. values_to -names the variable stored in the cell values, 
### we named that variable rank.

billboard |> 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank"
  )


billboard |> 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank",
    values_drop_na = TRUE
  )


billboard_longer <- billboard |> 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank",
    values_drop_na = TRUE
  ) |> 
  mutate(
    week = parse_number(week)
  )
billboard_longer


billboard_longer |> 
  ggplot(aes(x = week, y = rank, group = track)) + 
  geom_line(alpha = 0.25) + 
  scale_y_reverse()


# How does pivoting work?
# we can use pivoting to reshape our data
# The column names become values in a new variable, 
# whose name is defined by names_to

df <- tribble(
  ~id,  ~bp1, ~bp2,
  "A",  100,  120,
  "B",  140,  115,
  "C",  120,  125
)

df |> 
  pivot_longer(
    cols = bp1:bp2,
    names_to = "measurement",
    values_to = "value"
  )


## Many variables in column names

who2
## 

who2 |> 
  pivot_longer(
    cols = !(country:year),
    names_to = c("diagnosis", "gender", "age"), 
    names_sep = "_",
    values_to = "count"
  )


## Data and variable names in the column headers
household

## 
household |> 
  pivot_longer(
    cols = !family, 
    names_to = c(".value", "child"), 
    names_sep = "_", 
    values_drop_na = TRUE
  )

# 2. Widening data
## pivot_wider()
## which makes datasets wider by increasing columns and reducing rows and 
## helps when one observation is spread across multiple rows. 

cms_patient_experience

## 
cms_patient_experience |> 
  distinct(measure_cd, measure_title)

## pivot_wider() has the opposite interface to pivot_longer(): 
## instead of choosing new column names,we need to provide the existing columns
## that define the values (values_from) and the column name (names_from):

cms_patient_experience |> 
  pivot_wider(
    names_from = measure_cd,
    values_from = prf_rate
  )


cms_patient_experience |> 
  pivot_wider(
    id_cols = starts_with("org"),
    names_from = measure_cd,
    values_from = prf_rate
  )


# How does pivot_wider() work?
df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "B",        "bp1",    140,
  "B",        "bp2",    115, 
  "A",        "bp2",    120,
  "A",        "bp3",    105
)


df |> 
  pivot_wider(
    names_from = measurement,
    values_from = value
  )


df |> 
  distinct(measurement) |> 
  pull()


df |> 
  select(!measurement & !value) |> 
  distinct()


df |> 
  select(!measurement & !value) |> 
  distinct() |> 
  mutate(x = NA, y = NA, z = NA)


df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "A",        "bp1",    102,
  "A",        "bp2",    120,
  "B",        "bp1",    140, 
  "B",        "bp2",    115
)


df |>
  pivot_wider(
    names_from = measurement,
    values_from = value
  )


df |> 
  group_by(id, measurement) |> 
  summarize(n = n(), .groups = "drop") |> 
  filter(n > 1)



#NB:use janitor::clean_names() to convert 
## all column names to snake case at once.