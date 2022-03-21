# attractivenssData <- modelData.attr %>% left_join(modelPlaces,by="placekey")
# st_write(attractivenssData,"data/output/attractivenssData.GEOJSON")
attractivenssData <- st_read("data/output/attractivenssData.GEOJSON")
attracGEO <- attractivenssData %>% dplyr::select(placekey)
attractivenssData <- attractivenssData %>% dplyr::select(-naics_code) %>% rename("area" = "attractiveness")
# the area and number of the insided facilities
pprBuildingStructures <- st_read('https://opendata.arcgis.com/datasets/97e90a049a35453ba0c51f974b3c77b4_0.geojson')%>%
  st_transform(crs=32118) %>% 
  mutate(count=1) %>% 
  st_buffer(500) %>% 
  st_join(attracGEO %>% st_transform(crs=32118)) %>% 
  st_drop_geometry()%>% 
  drop_na() %>% 
  group_by(placekey) %>% 
  summarise(facilityNum = sum(count),facilityArea = sum(Shape__Area))
attractivenssData <- attractivenssData %>%left_join(pprBuildingStructures, by="placekey")
attractivenssData$facilityNum[is.na(attractivenssData$facilityNum)] <- 0
attractivenssData$facilityArea[is.na(attractivenssData$facilityArea)] <- 0
# the length of the trail
pprTrails <- st_read('https://opendata.arcgis.com/datasets/48323d574068405bbf5336b9b5b29455_0.geojson')%>%
  st_transform(crs=32118) %>% 
  filter(TRAIL_STATUS =="EXISTING") %>% 
  dplyr::select(MILES) %>% 
  st_buffer(100) %>% 
  st_join(attracGEO %>% st_transform(crs=32118)) %>% 
  st_drop_geometry() %>% 
  drop_na() %>% 
  rename("trailMiles" = "MILES")%>% 
  group_by(placekey) %>% 
  summarise(trailMiles = sum(trailMiles))
attractivenssData <- attractivenssData %>%left_join(pprTrails, by="placekey")
attractivenssData$trailMiles[is.na(attractivenssData$trailMiles)] <- 0

# the number of the picnic tables
pprPicnicSites <- st_read('https://phl.carto.com/api/v2/sql?q=SELECT+*+FROM+ppr_picnic_sites&filename=ppr_picnic_sites&format=geojson&skipfields=cartodb_id')%>%
  st_transform(crs=32118) %>% 
  dplyr::select(table_count) %>% 
  st_buffer(100) %>% 
  st_join(attracGEO %>% st_transform(crs=32118)) %>% 
  st_drop_geometry()%>% 
  drop_na()%>% 
  rename("picnicTable" = "table_count") %>% 
  group_by(placekey) %>% 
  summarise(picnicTable = sum(picnicTable))
attractivenssData <- attractivenssData %>%left_join(pprPicnicSites, by="placekey")
attractivenssData$picnicTable[is.na(attractivenssData$picnicTable)] <- 0
# AdExercise
pprAdExercise <- st_read('https://phl.carto.com/api/v2/sql?q=SELECT+*+FROM+ppr_adult_exercise_equipment&filename=ppr_adult_exercise_equipment&format=geojson&skipfields=cartodb_id')%>%
  st_transform(crs=32118) %>% 
  mutate(count=1) %>% 
  st_buffer(100) %>% 
  st_join(attracGEO %>% st_transform(crs=32118)) %>% 
  st_drop_geometry()%>% 
  drop_na()%>% 
  group_by(placekey) %>% 
  summarise(exerciseNum = sum(count))
attractivenssData <- attractivenssData %>%left_join(pprAdExercise, by="placekey")
attractivenssData$exerciseNum[is.na(attractivenssData$exerciseNum)] <- 0
# SwimmingPool
pprSwimmingPool <- st_read('https://opendata.arcgis.com/datasets/c6f6176968f04d3f88adbc4c362af55d_0.geojson')%>%
  st_transform(crs=32118) %>% 
  filter(POOL_STATUS =="ACTIVE")%>% 
  mutate(count=1) %>% 
  st_buffer(1000) %>% 
  st_join(attracGEO %>% st_transform(crs=32118)) %>% 
  st_drop_geometry()%>% 
  drop_na()%>% 
  group_by(placekey) %>% 
  summarise(swimmingPoolNum = sum(count))
attractivenssData <- attractivenssData %>%left_join(pprSwimmingPool, by="placekey")
attractivenssData$swimmingPoolNum[is.na(attractivenssData$swimmingPoolNum)] <- 0
# Sprayground & Hydration Station
pprSpraygrounds <- st_read('https://opendata.arcgis.com/datasets/a148cc904d374b22bd456e44a044d554_0.geojson')%>%
  st_transform(crs=32118) %>% 
  filter(SPRAY_STATUS =="ACTIVE")%>% 
  mutate(count=1) %>% 
  st_buffer(100) %>% 
  st_join(attracGEO %>% st_transform(crs=32118)) %>% 
  st_drop_geometry()%>% 
  drop_na()%>% 
  group_by(placekey) %>% 
  summarise(spraygroundNum = sum(count))
attractivenssData <- attractivenssData %>%left_join(pprSpraygrounds, by="placekey")
attractivenssData$spraygroundNum[is.na(attractivenssData$spraygroundNum)] <- 0

pprHydrationStations <- st_read('https://opendata.arcgis.com/datasets/cc35dc98180249fb9a6f2f5f06657df1_0.geojson')%>%
  st_transform(crs=32118) %>% 
  mutate(count=1) %>% 
  st_buffer(500) %>% 
  st_join(attracGEO %>% st_transform(crs=32118)) %>% 
  st_drop_geometry()%>% 
  drop_na()%>% 
  group_by(placekey) %>% 
  summarise(hydrationNum = sum(count))
attractivenssData <- attractivenssData %>%left_join(pprHydrationStations, by="placekey")
attractivenssData$hydrationNum[is.na(attractivenssData$hydrationNum)] <- 0

attractivenssData <- 
  attractivenssData %>% 
  mutate(waterNum = spraygroundNum + hydrationNum) %>% 
  dplyr::select(-spraygroundNum,-hydrationNum)
# Tennis Court
pprTennisCourt <- st_read('https://phl.carto.com/api/v2/sql?q=SELECT+*+FROM+ppr_tennis_courts&filename=ppr_tennis_courts&format=geojson&skipfields=cartodb_id')%>%
  st_transform(crs=32118) %>% 
  mutate(count=1) %>% 
  st_buffer(1000) %>% 
  st_join(attracGEO %>% st_transform(crs=32118)) %>% 
  st_drop_geometry()%>% 
  drop_na()%>% 
  group_by(placekey) %>% 
  summarise(tennisCourtNum = sum(count))
attractivenssData <- attractivenssData %>%left_join(pprTennisCourt, by="placekey")
attractivenssData$tennisCourtNum[is.na(attractivenssData$tennisCourtNum)] <- 0

# Playgrounds
pprPlaygrounds <- st_read('https://opendata.arcgis.com/datasets/899c807e205244278b3f39421be8489c_0.geojson')%>%
  st_transform(crs=32118) %>% 
  mutate(count=1) %>% 
  st_buffer(1000) %>% 
  st_join(attracGEO %>% st_transform(crs=32118)) %>% 
  st_drop_geometry()%>% 
  drop_na()%>% 
  group_by(placekey) %>% 
  summarise(playgroundNum = sum(count))
attractivenssData <- attractivenssData %>%left_join(pprPlaygrounds, by="placekey")
attractivenssData$playgroundNum[is.na(attractivenssData$playgroundNum)] <- 0

attractivenssData <- 
  attractivenssData %>%
  mutate(totalExerciseNum = exerciseNum + swimmingPoolNum + playgroundNum + tennisCourtNum) %>% 
  dplyr::select(-exerciseNum,-swimmingPoolNum,-playgroundNum, -tennisCourtNum)
# Tree Area
query <- paste("SELECT objectid, avg_height, shape_area",
               "FROM ppr_tree_canopy_outlines_2015",
               "ORDER BY objectid ASC")

pprTreeCanopyWithArea <- get_carto(query, format = "csv",
                                   base_url = "https://phl.carto.com/api/v2/sql", stringsAsFactors = F)

pprTreeCanopy <- st_read('https://phl.carto.com/api/v2/sql?q=SELECT+*+FROM+ppr_tree_canopy_points_2015&filename=ppr_tree_canopy_points_2015&format=geojson&skipfields=cartodb_id')%>%
  st_transform(crs)%>%
  left_join(pprTreeCanopyWithArea,by = "objectid") %>% 
  st_transform(crs=32118) %>% 
  st_buffer(500) %>% 
  st_join(attracGEO %>% st_transform(crs=32118)) %>% 
  st_drop_geometry()%>% 
  drop_na() %>% 
  group_by(placekey) %>% 
  summarise(treeHeight = mean(avg_height),treeArea = sum(shape_area))
attractivenssData <- attractivenssData %>%left_join(pprTreeCanopy, by="placekey")
attractivenssData$treeHeight[is.na(attractivenssData$treeHeight)] <- 0
attractivenssData$treeArea[is.na(attractivenssData$treeArea)] <- 0
# the sum of the number of the programs and the permits
attractivenssData <- 
  attractivenssData %>% 
  left_join(program2021.joinWithPlaceKey %>% 
              mutate(count=1) %>% 
              group_by(placekey) %>% 
              summarise(programNum = sum(count)) %>% 
              st_drop_geometry(),by="placekey")%>% 
  left_join(permit2021.joinWithPlaceKey %>% 
              mutate(count=1) %>% 
              group_by(placekey) %>% 
              summarise(permitNum = sum(count)) %>% 
              st_drop_geometry(),by="placekey")
attractivenssData$programNum[is.na(attractivenssData$programNum)] <- 0
attractivenssData$permitNum[is.na(attractivenssData$permitNum)] <- 0
attractivenssData <- attractivenssData %>% mutate(totalActivityNum = programNum + permitNum)

hist(attractivenssData$totalActivityNum,breaks=100)
table(permit2021.joinWithPlaceKey$ExpectedGroupSizeMin)
# the total audience capacity
attractivenssData <- attractivenssData %>% mutate(acativityCapacity = NA)
attractivenssData <- 
  attractivenssData %>% 
  left_join(program2021.joinWithPlaceKey %>% 
              group_by(placekey) %>% 
              summarise(programCap = sum(RegisteredIndividualsCount)) %>% 
              st_drop_geometry(),by="placekey")%>% 
  left_join(permit2021.joinWithPlaceKey %>% 
              group_by(placekey) %>% 
              summarise(permitCap = sum(ExpectedGroupSizeMin)) %>% 
              st_drop_geometry(),by="placekey")
attractivenssData$programCap[is.na(attractivenssData$programCap)] <- 0
attractivenssData$permitCap[is.na(attractivenssData$permitCap)] <- 0
attractivenssData <- attractivenssData %>% mutate(acativityCapacity = programCap + permitCap)

# hist(attractivenssData$totalActivityNum,breaks=100)
# table(permit2021.joinWithPlaceKey$ExpectedGroupSizeMin)
# 
# # the number of surrounding business (Types) with 1 km
# attractivenssData <- attractivenssData %>% mutate(surroundBusiness = NA)

