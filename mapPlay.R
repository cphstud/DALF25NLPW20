#=================
# INSTALL PACKAGES
#=================
library(tidyverse)
library(rvest)
library(magrittr)
library(ggmap)
library(stringr)
library(maps)
library(RColorBrewer)
library(forcats)

world_map <- map_data("world")
#===========================================
# RECODE NAMES
# - Two names in the 'global talent' data
#   are not the same as the names in the 
#   map
# - We need to re-name these so they match
# - If they don't match, we won't be able to 
#   join the datasets
#===========================================

df <- data.frame(
  id = c("US", "DE", "UA", "SY"),
  count = c(2030, 1001, 730, 229)
)

df$count_group <- cut(df$count, 
                      breaks = c(-Inf, 200, 600, 1000, 2000, Inf), 
                      labels = c("Less than 200", "600-200", "1000-600", "2000-1000", "More than 2000"))

world_map <- map_data(map = "world")
world_map$region <- iso.alpha(world_map$region)

ggplot(df) +
  geom_map(aes(map_id = id, fill = fct_rev(count_group)), map = world_map) +
  geom_polygon(data = world_map, aes(x = long, y = lat, group = group), colour = 'black', fill = NA) +
  expand_limits(x = world_map$long, y = world_map$lat) +
  scale_fill_manual(name = "Counts", values = rev(brewer.pal(5, name = "Reds"))) +
  theme_void() +
  coord_fixed()
