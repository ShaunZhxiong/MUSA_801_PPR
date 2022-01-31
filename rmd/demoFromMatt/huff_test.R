# Test out the Huff Model in R

library(tidyverse)
library(lubridate)
library(vroom)
library(sf)
library(kableExtra)
library(mapview)

## read it in with vroom to save time
moves <- vroom("data/OneDrive-2021-12-07/moves_monthly2020.csv")

 <- read_sf("C:/Users/mfich/Documents/Clients/MUSA_Teaching_and_Admin/SPRING_STUDIO_2021/Safegraph/demo/phila.geojson")

## how to unnest the temporal data
library(furrr)
plan(multiprocess, workers = 6)

## Keep only particular class of business

possible_businesses <-
  phila %>%
  filter(top_category %in% c("Promoters of Performing Arts, Sports, and Similar Events"))

nightmoves <- moves %>% 
  filter(safegraph_place_id %in% as.list(possible_businesses$safegraph_place_id))


# How about parks?
# THese could probably be "ground truthed" a bit by joining them to
# published park layers
parks <- phila %>% 
  filter(str_detect(location_name, "Parking", negate = TRUE)) %>%
  filter(str_detect(location_name, "Fitness", negate = TRUE)) %>%
  filter(str_detect(location_name, "Parkview", negate = TRUE)) %>%
  filter(str_detect(sub_category, "Fitness", negate = TRUE)) %>%
  filter( naics_code %in% c(712190, 713990))

parkmoves <- moves %>% 
  filter(safegraph_place_id %in% as.list(parks$safegraph_place_id))

timeseries <- 
  parkmoves %>% 
  select(safegraph_place_id, date_range_start, date_range_end, visits_by_day) %>%
  mutate(date_range_start = as_date(date_range_start),
         date_range_end = as_date(date_range_end)) %>%
  mutate(visits_by_day = str_remove_all(visits_by_day, pattern = "\\[|\\]")) %>% 
  mutate(visits_by_day = str_split(visits_by_day, pattern = ",")) %>%
  mutate(visits_by_day = future_map(visits_by_day, function(x){
    unlist(x) %>%
      as_tibble() %>%
      mutate(day = 1:n(),
             visits = value)
  })) %>%
  unnest(cols = c(visits_by_day))

## time is (88 seconds, so not fast)
tictoc::tic()

timeseries <- 
  nightmoves %>% 
  select(safegraph_place_id, date_range_start, date_range_end, visits_by_day) %>%
  mutate(date_range_start = as_date(date_range_start),
         date_range_end = as_date(date_range_end)) %>%
  mutate(visits_by_day = str_remove_all(visits_by_day, pattern = "\\[|\\]")) %>% 
  mutate(visits_by_day = str_split(visits_by_day, pattern = ",")) %>%
  mutate(visits_by_day = future_map(visits_by_day, function(x){
    unlist(x) %>%
      as_tibble() %>%
      mutate(day = 1:n(),
             visits = value)
  })) %>%
  unnest(cols = c(visits_by_day))

tictoc::toc()

## how to unnest the origin-destination data

## note that we can speed these up by joining venue data and filtering it down
tictoc::tic()

odmatrix <- 
  nightmoves %>% 
  select(safegraph_place_id, visitor_home_cbgs) %>%
  mutate(visitor_home_cbgs = future_map(visitor_home_cbgs, function(x){
    jsonlite::fromJSON(x) %>% 
      as_tibble()
  })) %>% 
  unnest(visitor_home_cbgs) %>%
  pivot_longer(!safegraph_place_id, names_to = "cbg", values_to = "visits") %>%
  drop_na(visits)

tictoc::tic()

# Let's make a fake data set
# Straight line distance from each possible origin (e.g. each regional tract) to each destination?
# THESE DISTANCE DATA ARE TOTALLY FAKE - DON'T DO IT LIKE THIS
# What if we make attractiveness "raw visitor counts"?

test <- odmatrix %>% 
  mutate(row_number = row_number()) %>% 
  group_by(cbg) %>% summarize(fake_distance = mean(row_number)) %>% 
  ungroup() %>% 
  left_join(odmatrix, .) %>% 
  left_join(., nightmoves)

glimpse(test)

## Here is the Huff stuff:

# https://rpubs.com/MichalisPavlis/huff_model
# https://github.com/alexsingleton/Huff-Tools

huff_basic <- function(destinations_name, destinations_attractiveness, origins_name, distance, alpha = 1, beta = 2){
  
  ############################################### Functions #############################################################
  huff_numerator_basic <- function(destinations_attractiveness, alpha, distance, beta){
    return((destinations_attractiveness ^ alpha) / (distance ^ beta))
  }
  
  ########################################### Check arguments ###########################################################
  flags <- check_huff(destinations_name, destinations_attractiveness, origins_name, distance, alpha, beta)
  # If we have distance values equal to zero replace with 0.1 (assuming distance in Km)
  
  if (flags[2]){
    alpha <- rep(alpha, flags[1])
  }
  
  if (flags[3]){
    beta <- rep(beta, flags[1])
  }
  
  if (flags[4]){
    distance <- ifelse(distance < 0.1, 0.1, distance)
  }
  
  ################################### Calculate Huff's (basic) algorithm ################################################
  # Numerator, calculated using the huff_numerator_basic function
  huff <- mapply(huff_numerator_basic, destinations_attractiveness, alpha, distance, beta) 
  
  # Denominator of the basic huff algorithm
  sum_huff_location <- aggregate(huff, by = list(origins_name), sum)
  names(sum_huff_location) <- c("origins_name", "sum_huff")
  
  # Merge denominator and nominator
  out <- merge(data.frame(origins_name, destinations_name, distance, huff), sum_huff_location, by="origins_name") 
  
  # Calculate huff probabilities
  out$huff_probability <- with(out, huff / sum_huff)
  
  # Identify primary catchment areas
  #  out$catchment <- ifelse(out$huff_probability > 0.5, "Primary", "Secondary")
  
  return(out)
}

  
huff_results <- huff_basic(test$location_name, test$raw_visit_counts, test$cbg, test$fake_distance)


## Some maps and charts

ggplot()+
  geom_point(data = parkmoves %>%
            left_join(parks, by = c("safegraph_place_id")), 
            aes(y = latitude, x = longitude, color = raw_visitor_counts,
                fill = raw_visitor_counts, size = raw_visitor_counts),
            alpha = 0.5)

ggplot(parkmoves %>%
         filter(location_name %in% c("Clark Park", "Strawberry Mansion Playground",
                                     "Cherashore Playground", "Shot Tower Playground",
                                     "Mander Playground", "Schuylkill River Park",
                                     "Penn Treaty Park", "Jose Manuel Collazo Playground",
                                     "Wissahickon Valley Park", "Weccacoe Playground")))+
  geom_line(aes(x = date_range_start, y = raw_visit_counts))+
  facet_wrap(~location_name, scales = "free")

ggplot(parkmoves)+
  geom_point(aes(x = date_range_start, y = raw_visit_counts))

# Can we spatial join the points to a parks shapefile?

parkspoly <- st_read("https://opendata.arcgis.com/datasets/d52445160ab14380a673e5849203eb64_0.geojson") %>%
  st_transform(4326)

parks_and_polygon <- st_join(parks %>% st_transform(crs = 4326), parkspoly)  


ggplot()+
  geom_sf(data = parkspoly, fill = "light green", alpha = 0.4)+
  geom_point(data = parks_and_polygon %>%
               mutate(joins_municipal = ifelse(is.na(PARENT_NAME) == TRUE, 
                                               "No join", "Join")), 
             aes(y = latitude, x = longitude, color = joins_municipal))

ggplot()+
  geom_sf(data = st_union(parkspoly), fill = "light green", alpha = 0.4)+
  geom_point(data = parks_and_polygon %>%
               filter(is.na(PARENT_NAME) == FALSE), 
             aes(y = latitude, x = longitude), size = 0.5)

mapView(parks, alpha = 0.6, size = 0.5) + mapView(parkspoly, col.regions = "green")
