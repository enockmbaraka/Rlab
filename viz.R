# Loading libraries
library(tidyverse)
library(palmerpenguins)
library(ggthemes)

# Purview of the dataset
palmerpenguins::penguins
# using glimpse()
glimpse(penguins)

# creating plots step by step
ggplot(data = penguins)
# adding mappings
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
)
# adding geom() object to the empty canvas

# geom_bar()- bar plots
# geom_boxplot()- boxplots
# geom_line()- line
# geom_point()- scatter plots
# geom_smooth(method = "lm")-linear model line of best fit
# geom_histogram()-histograms
# geom_density()-density plots

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point()

# Adding aesthetic layers
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)
) +
  geom_point()

# Adding line of best fit
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)
) +
  geom_point() +
  geom_smooth(method = "lm")

# Improving the mapping and aesthetics
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(mapping = aes(color = species)) +
  geom_smooth(method = "lm")

# improving viz1
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(mapping = aes(color = species, shape = species)) +
  geom_smooth(method = "lm")
# improving viz2- expounding on labels-labs() function
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(aes(color = species, shape = species)) +
  geom_smooth(method = "lm") +
  labs(
    title = "Body mass and flipper length",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Flipper length (mm)", y = "Body mass (g)",
    color = "Species", shape = "Species"
  ) +
  scale_color_colorblind()

# Visualizing distributions
## categorical variables
### bar charts
ggplot(penguins, aes(x = species)) +
  geom_bar()
### bar charts in the order of the frequency
ggplot(penguins, aes(x = fct_infreq(species))) +
  geom_bar()

## Numerical variables
### histograms-A histogram divides the x-axis into equally spaced bins and 
### then uses the height of a bar to display the number of observations that fall in each bin
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200)

### density plots- is a smoothed-out version of a histogram
ggplot(penguins, aes(x = body_mass_g)) +
  geom_density()

# Visualizing relationships between variables
## A numerical and a categorical variable
### box plots
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_boxplot()
### density plots
ggplot(penguins, aes(x = body_mass_g, color = species)) +
  geom_density(linewidth = 0.75)

ggplot(penguins, aes(x = body_mass_g, color = species, fill = species)) +
  geom_density(alpha = 0.5)

## Two categorical variables
### stacked bar plots
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar()

ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill")

ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill") +
  labs(y = "proportion")

## Two numerical variables
### scatter plots
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()

## Three or more variables
### scatter plots
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = island))
### for categorical variables, split is to split your plot into facets,
### subplots that each display one subset of the data.
### To facet your plot by a single variable, use facet_wrap().
### The first argument of facet_wrap() is a formula, which you create
### with ~ followed by a variable name. The variable that you
### pass to facet_wrap() should be categorical.

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = species)) +
  facet_wrap(~island)

# Saving plots
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()
ggsave(filename = "penguin-plot.png")