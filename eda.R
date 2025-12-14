library(tidyverse)

# Variation
ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.5)


#
smaller <- diamonds |> 
  filter(carat < 3)

ggplot(smaller, aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

# Outliers(unusual values)
ggplot(diamonds, aes(x = y)) + 
  geom_histogram(binwidth = 0.5)
#
ggplot(diamonds, aes(x = y)) + 
  geom_histogram(binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))
#
unusual <- diamonds |> 
  filter(y < 3 | y > 20) |> 
  select(price, x, y, z) |>
  arrange(y)
unusual

## Dealing with unsual values

### Drop the entire row with the strange values:
diamonds2 <- diamonds |> 
  filter(between(y, 3, 20))

### we recommend replacing the unusual values with missing values
diamonds2 <- diamonds |> 
  mutate(y = if_else(y < 3 | y > 20, NA, y))

### excludes missing values but gives a warning
ggplot(diamonds2, aes(x = x, y = y)) + 
  geom_point()

### silencing warnings
ggplot(diamonds2, aes(x = x, y = y)) + 
  geom_point(na.rm = TRUE)

## Other times you want to understand what makes observations with 
## missing values different to observations with recorded values.
nycflights13::flights |> 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + (sched_min / 60)
  ) |> 
  ggplot(aes(x = sched_dep_time)) + 
  geom_freqpoly(aes(color = cancelled), binwidth = 1/4)


# Covariation
## If variation describes the behavior within a variable, 
## covariation describes the behavior between variables. 
## Covariation is the tendency for the values of two or more variables 
## to vary together in a related way. The best way to spot 
## covariation is to visualize the relationship between two or more variables.

## (i) A categorical and a numerical variable
ggplot(diamonds, aes(x = price)) + 
  geom_freqpoly(aes(color = cut), binwidth = 500, linewidth = 0.75)
##
ggplot(diamonds, aes(x = price, y = after_stat(density))) + 
  geom_freqpoly(aes(color = cut), binwidth = 500, linewidth = 0.75)

## Box plot
### exploring this relationship is using side-by-side boxplots.
ggplot(diamonds, aes(x = cut, y = price)) +
  geom_boxplot()

###
ggplot(mpg, aes(x = class, y = hwy)) +
  geom_boxplot()

###
ggplot(mpg, aes(x = fct_reorder(class, hwy, median), y = hwy)) +
  geom_boxplot()

###
ggplot(mpg, aes(x = hwy, y = fct_reorder(class, hwy, median))) +
  geom_boxplot()


## (ii)Two categorical variables
### To visualize the covariation between categorical variables, 
### you’ll need to count the number of observations for each 
### combination of levels of these categorical variables.
### One way to do that is to rely on the built-in geom_count():

ggplot(diamonds, aes(x = cut, y = color)) +
  geom_count()

### Another approach for exploring the relationship between these 
### variables is computing the counts with dplyr:
diamonds |> 
  count(color, cut)

### Then visualize with geom_tile() and the fill aesthetic:
diamonds |> 
  count(color, cut) |>  
  ggplot(aes(x = color, y = cut)) +
  geom_tile(aes(fill = n))

## (iii)Two numerical variables
### scatter plots
ggplot(smaller, aes(x = carat, y = price)) +
  geom_point()

###
ggplot(smaller, aes(x = carat, y = price)) + 
  geom_point(alpha = 1 / 100)

###
ggplot(smaller, aes(x = carat, y = price)) +
  geom_bin2d()

# install.packages("hexbin")
ggplot(smaller, aes(x = carat, y = price)) +
  geom_hex()

### Another option is to bin one continuous variable so it acts 
### like a categorical variable. Then you can use one of the techniques 
### for visualizing the combination of a categorical and a continuous variable

ggplot(smaller, aes(x = carat, y = price)) + 
  geom_boxplot(aes(group = cut_width(carat, 0.1)))

###
diamonds |> 
  filter(x >= 4) |> 
  ggplot(aes(x = x, y = y)) +
  geom_point() +
  coord_cartesian(xlim = c(4, 11), ylim = c(4, 11))

###
ggplot(smaller, aes(x = carat, y = price)) + 
  geom_boxplot(aes(group = cut_number(carat, 20)))


# Patterns and models
## Patterns in your data provide clues about relationships,
## i.e., they reveal covariation

library(tidymodels)
#install.packages("tidymodels")
diamonds <- diamonds |>
  mutate(
    log_price = log(price),
    log_carat = log(carat)
  )

diamonds_fit <- linear_reg() |>
  fit(log_price ~ log_carat, data = diamonds)

diamonds_aug <- augment(diamonds_fit, new_data = diamonds) |>
  mutate(.resid = exp(.resid))

ggplot(diamonds_aug, aes(x = carat, y = .resid)) + 
  geom_point()

##
ggplot(diamonds_aug, aes(x = cut, y = .resid)) + 
  geom_boxplot()