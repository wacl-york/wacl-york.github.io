# Set-up ---------------------------
# Load packages
library(threadr)
library(gissr)
library(tidyr)
library(ggplot2)

# Set global options
options(stringsAsFactors = FALSE)

# Set working directory
setwd("~/Dropbox/york/wacl-york.github.io/www/maps/chemistry_around_the_world/R")


# Spatial work --------------------------- 
# data_track <- read.delim("../data/discarded/RV Lance cruise track.txt") %>%
#   select(latitude = lat,
#          longitude = long) %>% 
#   mutate(point = str_c(latitude, longitude, sep = ", "))

# sp_track <- sp_from_data_frame(data_track, type = "lines")
# sp_centroid(sp_track)
# 
# write_geojson_js(sp_track, "~/Desktop/rv_lance.js", "sp_rv_lance")

# data_track <- read.csv("../data/discarded/AMT22_cruise_track_hourly.csv",
#                        col.names = c("date", "latitude", "longitude")) %>%
#   select(-date) %>% 
#   mutate(point = str_c(latitude, longitude, sep = ", "))

# sp_track <- sp_from_data_frame(data_track, type = "lines")
# write_geojson_js(sp_track, "~/Desktop/rss_james_cook", "sp_rss_james_cook")


# Image mapping json --------------------------- 
# Load my table
data_images <- read.csv("../data/chemistry_around_the_world_mapping.csv") %>% 
  filter(!is.na(latitude)) %>% 
  mutate(image = file.path("images/resized", image),
         image_large = file.path("images/large", image_large),
         image_large = str_c('<a href="', image_large, '" target="_blank">Full-size image</a>'))


# Get metadata
data_images_info <- file_metadata(file.path("..", data_images$image),
                                  progress = "time") %>% 
  select(image = source_file, 
         image_file_size = file_size,
         image_width,
         image_height) %>% 
  mutate(image = str_replace(image, "^../", ""))

# Join data
data_images <- data_images %>% 
  left_join(data_images_info, "image")

# Save object
write_geojson_js(data_images, "../data/image_data.js")


data_images_small <- read.csv("../data/chemistry_around_the_world_mapping.csv") %>% 
  filter(!is.na(latitude)) %>% 
  select(project,
         image_large) %>% 
  mutate(caption = "")

# write.csv(data_images_small, "~/Desktop/image_mapping_table.csv", row.names = FALSE)


# Create some circles  ---------------------------
data_centre <- data_images %>%
  distinct(project_name,
           .keep_all = TRUE) %>%
  slice(14)

sp_ellipse <- sp_create_ellipse(data_centre$latitude, data_centre$longitude,
                                width = 0.1)

data_points <- ggplot2::fortify(sp_ellipse) %>%
  rename(latitude = lat,
         longitude = long) %>%
  mutate(name = str_c(latitude, longitude, sep = ", ")) %>%
  sp_from_data_frame(type = "points")

leaflet_plot(data_points)


# Template, near equator
data_images %>% 
  filter(project == "OP3") %>% 
  sp_from_data_frame(type = "points") %>% 
  leaflet_plot(popup = "image")
  
# data.frame(
#   latitude = c(4.981, 4.881),
#   longitude = c(117.844, 117.844)
# ) %>% 
#   sp_from_data_frame(type = "line") %>% 
#   sp_length()

# For the polar projects
# Norway
data_polar <- data_images %>%
  distinct(project_name,
           .keep_all = TRUE) %>% 
  filter(project == "ACCACIA")

data_polar %>% 
  sp_from_data_frame(type = "point") %>% 
  sp_transform(projection_norway()) 

sp_ellipse_polar <- sp_create_ellipse(365409.3, 1492134, width = 12000, 
                                      projection = projection_norway()) 

data_points_polar <- sp_transform(sp_ellipse_polar) %>% 
  sp_fortify() %>%
  mutate(name = str_c(latitude, longitude, sep = ", ")) %>%
  sp_from_data_frame(type = "points")

leaflet_plot(data_points_polar)

# Antartica
# Norway
data_antartica <- data_images %>%
  distinct(project_name,
           .keep_all = TRUE) %>% 
  filter(project == "CHABLIS")

data_antartica %>% 
  sp_from_data_frame(type = "point") %>% 
  sp_transform(projection_antarctic())

sp_ellipse_antartica <- sp_create_ellipse(1407008, -706420.8, width = 12000, 
                                      projection = projection_antarctic()) 

data_points_antartica <- sp_transform(sp_ellipse_antartica) %>% 
  sp_fortify() %>%
  mutate(name = str_c(latitude, longitude, sep = ", ")) %>%
  sp_from_data_frame(type = "points")

leaflet_plot(data_points_antartica)


# Files for mapping table  --------------------------- 
files <- list.files("../images/resized/")
files <- list.files("../images/large/")
files <- list.files("../images")
files <- list.files("~/Desktop/SWAAMI/", "resized")

# write(files, "~/Desktop/files.txt")
