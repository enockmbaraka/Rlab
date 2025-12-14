library(tidyverse)
# Aesthetic mappings
mpg

# Left
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point()

# Right
ggplot(mpg, aes(x = displ, y = hwy, shape = class)) +
  geom_point()

# Left
#Using size for a discrete variable is not advised.
ggplot(mpg, aes(x = displ, y = hwy, size = class)) +
  geom_point()


# Right
#Using alpha for a discrete variable is not advised.
ggplot(mpg, aes(x = displ, y = hwy, alpha = class)) +
  geom_point()

## changing all points to blue color
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(color = "blue")

#changing geom objects
# Left
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point()

# Right
##`geom_smooth()` using method = 'loess' and formula = 'y ~ x'
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_smooth()

# 
# Left
ggplot(mpg, aes(x = displ, y = hwy, shape = drv)) + 
  geom_smooth()

# Right
ggplot(mpg, aes(x = displ, y = hwy, linetype = drv)) + 
  geom_smooth()


#
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) + 
  geom_point() +
  geom_smooth(aes(linetype = drv))

# Left
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth()

# Middle
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(group = drv))

# Right
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(color = drv), show.legend = FALSE)

#
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(color = class)) + 
  geom_smooth()


#
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_point(
    data = mpg |> filter(class == "2seater"), 
    color = "red"
  ) +
  geom_point(
    data = mpg |> filter(class == "2seater"), 
    shape = "circle open", size = 3, color = "red"
  )


# Left
ggplot(mpg, aes(x = hwy)) +
  geom_histogram(binwidth = 2)

# Middle
ggplot(mpg, aes(x = hwy)) +
  geom_density()

# Right
ggplot(mpg, aes(x = hwy)) +
  geom_boxplot()


##
# Picking joint bandwidth of 1.28
library(ggridges)

ggplot(mpg, aes(x = hwy, y = drv, fill = drv, color = drv)) +
  geom_density_ridges(alpha = 0.5, show.legend = FALSE)


#facets
## facet_wrap(), which splits a plot into subplots that each display 
## one subset of the data based on a categorical variable.

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_wrap(~cyl)

## facet_grid()
## The first argument of facet_grid() is also a formula,
## but now it’s a double sided formula: rows ~ cols
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_grid(drv ~ cyl)

##
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_grid(drv ~ cyl, scales = "free")

# Statistical transformations
##
ggplot(diamonds, aes(x = cut)) + 
  geom_bar()

##
diamonds |>
  count(cut) |>
  ggplot(aes(x = cut, y = n)) +
  geom_bar(stat = "identity")

##
ggplot(diamonds) + 
  stat_summary(
    aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )


# Position adjustments
## Left
ggplot(mpg, aes(x = drv, color = drv)) + 
  geom_bar()

## Right
ggplot(mpg, aes(x = drv, fill = drv)) + 
  geom_bar()

##
ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar()

##
# Left
ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar(alpha = 1/5, position = "identity")

# Right
ggplot(mpg, aes(x = drv, color = class)) + 
  geom_bar(fill = NA, position = "identity")

##
# Left
ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar(position = "fill")

# Right
ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar(position = "dodge")

##
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(position = "jitter")



# Coordinate systems
## coord_quickmap() sets the aspect ratio correctly for geographic maps. 
nz <- map_data("nz")

ggplot(nz, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black")

ggplot(nz, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black") +
  coord_quickmap()

## coord_polar() uses polar coordinates. Polar coordinates reveal an 
## interesting connection between a bar chart and a Coxcomb chart.
bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = clarity, fill = clarity), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1)

bar + coord_flip()
bar + coord_polar()

## custom function
# ggplot(data = <DATA>) + 
  # <GEOM_FUNCTION>(
    # mapping = aes(<MAPPINGS>),
    # stat = <STAT>, 
    # position = <POSITION>
  # ) +
  # <COORDINATE_FUNCTION> +
  # <FACET_FUNCTION>