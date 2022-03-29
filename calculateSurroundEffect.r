# find the naics code that has most smae-day visits

# unnest the related_same_day_brand
# relatedBrand <-
#   PPRmoves %>%
#   select(placekey, related_same_day_brand, date_range_start) %>%
#   mutate(date_range_start = as_date(date_range_start),
#          month =  month(date_range_start)) %>%
#   dplyr::select(-date_range_start) %>%
#   mutate(related_same_day_brand = future_map(related_same_day_brand, function(x){
#     jsonlite::fromJSON(x) %>%
#       as_tibble() %>%
#       gather()
#   }))
# 
# relatedBrand <- relatedBrand %>%
#   unnest(related_same_day_brand) %>%
#   rename(relatedBrand =key ,visitors= value)
# 
# st_write(relatedBrand,"data/output/relatedBrand.GeoJSON")
relatedBrand <- st_read("data/output/relatedBrand.GeoJSON",crs=crs)
relatedBrand <- relatedBrand %>% 
  dplyr::select(-placekey,-month) %>% 
  st_drop_geometry() %>% 
  group_by(relatedBrand) %>% 
  summarize(totalVisitors = sum(visitors))

# connect this dataframe with naics code
core_poi <- vroom("data/safegraph/Philadelphia-Camden-WilmingtonPA-NJ-DE-MDMSA-CORE_POI-2021_11-2021-12-17/core_poi.csv")
relatedNaics <- core_poi %>% dplyr::select(brands,naics_code) %>% distinct() %>% drop_na()

relatedBrandWithNaics <- 
  relatedBrand %>% 
  left_join(relatedNaics,by=c("relatedBrand" = "brands")) %>% 
  drop_na() %>% 
  group_by(naics_code) %>% 
  summarise(totalVisitors = sum(totalVisitors)) %>% 
  filter(totalVisitors>365)

relatedBrandWithNaics$naics_code <- as.factor(relatedBrandWithNaics$naics_code)

relatedBrandWithNaics%>%
  arrange(-totalVisitors) %>% 
  mutate(naics_code = factor(naics_code, naics_code)) %>%
  ggplot(aes(x=naics_code, y=totalVisitors)) +
  geom_bar(position ="dodge",fill = palette1_main,stat='identity') +
  labs(x="Naics Code", y="Total Visitors") +
  plotTheme(5,5)+
  theme(
    axis.text = element_text( size=5,angle = 90),
    strip.text = element_text( size=5),
    strip.text.x = element_text( size = 5))

# use the same naics code to get the safegraph poi data to construct naics code's location
# 445120 - Convenience Stores
# 722513 - 	Limited-Service Restaurants
# 722515 - Snack and Nonalcoholic Beverage Bars
# 452319 - All Other General Merchandise Stores
# 447110 - Gasoline Stations with Convenience Stores

# use number of visits as their attractiveness
pprRelatedNaicsMoves <- function(pprRelatedNaics, safeGraph.geo) {
  safeGraph.geo$raw_visitor_counts = as.numeric(safeGraph.geo$raw_visitor_counts)
  moves <- safeGraph.geo %>% 
    filter(naics_code==pprRelatedNaics) %>% 
    dplyr::select(placekey, location_name, raw_visitor_counts) %>% 
    group_by(placekey) %>% 
    summarise(totalVisitors = sum(raw_visitor_counts))
  return(moves)
}

pprRelatedNaics = 722513
restSurroundEffect <- pprRelatedNaicsMoves(pprRelatedNaics, safeGraph.geo)

#st_write(restSurroundEffect,"data/output/restSurroundEffect.GEOJSON")
restSurroundEffect <- st_read("data/output/restSurroundEffect.GEOJSON")

# visualized
ggplot(restSurroundEffect) +
  geom_sf(data=pprServiceArea,color='black',size=0.35,fill= "transparent")+
  geom_sf(data=pprDistrict,color='black',size=0.5,fill= "transparent")+
  geom_sf(aes(size = totalVisitors),color = palette1_main,fill = palette1_main,alpha = 0.3) +
  scale_size_continuous(range = c(1, 3),name = "Visits")+
  mapTheme()+
  theme(legend.position = "bottom",
        legend.key.width = unit(0.5, 'cm'),
        legend.key.height  = unit(0.2, 'cm'))
