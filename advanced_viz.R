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
