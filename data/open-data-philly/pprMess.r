pprTrails <- st_read('https://opendata.arcgis.com/datasets/48323d574068405bbf5336b9b5b29455_0.geojson')%>%
  st_transform(crs=32118) %>% 
  filter(TRAIL_STATUS =="EXISTING") %>% 
  dplyr::select(MILES) %>% 
  st_buffer(10) %>% 
  st_join(attracGEO %>% st_transform(crs=32118)) %>% 
  st_drop_geometry() %>% 
  drop_na()%>% 
  rename("trailMiles" = "MILES")

#####
ggplot() + 
  geom_sf(data=pprTrails,color=palette1_main,fill = palette1_main)+
  geom_sf(data=st_union(pprDistrict),color="black",size=2,fill = "transparent")+
  geom_sf(data=pprDistrict,color="black",size=1,linetype ="dashed",fill = "transparent")+
  labs(title = "", 
       subtitle = "",
       x="",y="")+
  mapTheme()
#####

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

#####
ggplot() + 
  geom_sf(data=pprPicnicSites,color=palette1_main,fill = palette1_main)+
  geom_sf(data=st_union(pprDistrict),color="black",size=2,fill = "transparent")+
  geom_sf(data=pprDistrict,color="black",size=1,linetype ="dashed",fill = "transparent")+
  labs(title = "", 
       subtitle = "",
       x="",y="")+
  mapTheme()
#####

pprAdExercise <- st_read('https://phl.carto.com/api/v2/sql?q=SELECT+*+FROM+ppr_adult_exercise_equipment&filename=ppr_adult_exercise_equipment&format=geojson&skipfields=cartodb_id')%>%
  st_transform(crs=32118) %>% 
  mutate(count=1) %>% 
  st_buffer(100) %>% 
  st_join(attracGEO %>% st_transform(crs=32118)) %>% 
  st_drop_geometry()%>% 
  drop_na()%>% 
  group_by(placekey) %>% 
  summarise(exerciseNum = sum(count))

#####
ggplot() + 
  geom_sf(data=pprAdExercise,color=palette1_main,fill = palette1_main)+
  geom_sf(data=st_union(pprDistrict),color="black",size=2,fill = "transparent")+
  geom_sf(data=pprDistrict,color="black",size=1,linetype ="dashed",fill = "transparent")+
  labs(title = "", 
       subtitle = "",
       x="",y="")+
  mapTheme()
#####

pprSwimmingPool <- st_read('https://opendata.arcgis.com/datasets/c6f6176968f04d3f88adbc4c362af55d_0.geojson')%>%
  st_transform(crs=32118) %>% 
  filter(POOL_STATUS =="ACTIVE")%>% 
  mutate(count=1) %>% 
  st_buffer(1000) %>% 
  st_join(attracGEO %>% st_transform(crs=32118)) %>% 
  st_drop_geometry()%>% 
  drop_na()%>% 
  group_by(placekey) %>% 
  summarise(exerciseNum = sum(count))

#####
ggplot() + 
  geom_sf(data=pprSwimmingPool,color=palette1_main,fill = palette1_main)+
  geom_sf(data=st_union(pprDistrict),color="black",size=2,fill = "transparent")+
  geom_sf(data=pprDistrict,color="black",size=1,linetype ="dashed",fill = "transparent")+
  labs(title = "", 
       subtitle = "",
       x="",y="")+
  mapTheme()
#####

pprTennisCourt <- st_read('https://phl.carto.com/api/v2/sql?q=SELECT+*+FROM+ppr_tennis_courts&filename=ppr_tennis_courts&format=geojson&skipfields=cartodb_id')%>%
  st_transform(crs=32118) %>% 
  mutate(count=1) %>% 
  st_buffer(1000) %>% 
  st_join(attracGEO %>% st_transform(crs=32118)) %>% 
  st_drop_geometry()%>% 
  drop_na()%>% 
  group_by(placekey) %>% 
  summarise(tennisCourtNum = sum(count))

#####
ggplot() + 
  geom_sf(data=pprTennisCourt,color=palette1_main,fill = palette1_main)+
  geom_sf(data=st_union(pprDistrict),color="black",size=2,fill = "transparent")+
  geom_sf(data=pprDistrict,color="black",size=1,linetype ="dashed",fill = "transparent")+
  labs(title = "", 
       subtitle = "",
       x="",y="")+
  mapTheme()
#####

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
#####
ggplot() + 
  geom_sf(data=pprSpraygrounds,color=palette1_main,fill = palette1_main)+
  geom_sf(data=st_union(pprDistrict),color="black",size=2,fill = "transparent")+
  geom_sf(data=pprDistrict,color="black",size=1,linetype ="dashed",fill = "transparent")+
  labs(title = "", 
       subtitle = "",
       x="",y="")+
  mapTheme()
#####
pprHydrationStations <- st_read('https://opendata.arcgis.com/datasets/cc35dc98180249fb9a6f2f5f06657df1_0.geojson')%>%
  st_transform(crs=32118) %>% 
  mutate(count=1) %>% 
  st_buffer(500) %>% 
  st_join(attracGEO %>% st_transform(crs=32118)) %>% 
  st_drop_geometry()%>% 
  drop_na()%>% 
  group_by(placekey) %>% 
  summarise(hydrationNum = sum(count))

#####
ggplot() + 
  geom_sf(data=pprHydrationStations,color=palette1_main,fill = palette1_main)+
  geom_sf(data=st_union(pprDistrict),color="black",size=2,fill = "transparent")+
  geom_sf(data=pprDistrict,color="black",size=1,linetype ="dashed",fill = "transparent")+
  labs(title = "", 
       subtitle = "",
       x="",y="")+
  mapTheme()
#####
pprPlaygrounds <- st_read('https://opendata.arcgis.com/datasets/899c807e205244278b3f39421be8489c_0.geojson')%>%
  st_transform(crs=32118) %>% 
  mutate(count=1) %>% 
  st_buffer(1000) %>% 
  st_join(attracGEO %>% st_transform(crs=32118)) %>% 
  st_drop_geometry()%>% 
  drop_na()%>% 
  group_by(placekey) %>% 
  summarise(playgroundNum = sum(count))
#####
ggplot() + 
  geom_sf(data=pprPlaygrounds,color=palette1_main,fill = palette1_main)+
  geom_sf(data=st_union(pprDistrict),color="black",size=2,fill = "transparent")+
  geom_sf(data=pprDistrict,color="black",size=1,linetype ="dashed",fill = "transparent")+
  labs(title = "", 
       subtitle = "",
       x="",y="")+
  mapTheme()
#####
#####
pprBoatLaunches <- st_read('https://opendata.arcgis.com/api/v3/datasets/ba32e1ac9c5341e1916274c2df3fbe22_0/downloads/data?format=geojson&spatialRefId=4326')%>%
  st_transform(crs)

ggplot() + 
  geom_sf(data=pprBoatLaunches,color=palette1_main,fill = palette1_main)+
  geom_sf(data=st_union(pprDistrict),color="black",size=2,fill = "transparent")+
  geom_sf(data=pprDistrict,color="black",size=1,linetype ="dashed",fill = "transparent")+
  labs(title = "", 
       subtitle = "",
       x="",y="")+
  mapTheme()
#####
pprBuildingStructures <- st_read('https://opendata.arcgis.com/datasets/97e90a049a35453ba0c51f974b3c77b4_0.geojson')%>%
  st_transform(crs=32118) %>% 
  mutate(count=1) %>% 
  st_buffer(500) %>% 
  st_join(attracGEO %>% st_transform(crs=32118)) %>% 
  st_drop_geometry()%>% 
  drop_na() %>% 
  group_by(placekey) %>% 
  summarise(facilityNum = sum(count),facilityArea = sum(Shape__Area))
#####
ggplot() + 
  geom_sf(data=pprBuildingStructures,color=palette1_main,size=1,fill = palette1_main)+
  geom_sf(data=st_union(pprDistrict),color="black",size=2,fill = "transparent")+
  geom_sf(data=pprDistrict,color="black",size=1,linetype ="dashed",fill = "transparent")+
  labs(title = "", 
       subtitle = "",
       x="",y="")+
  mapTheme()
#####
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

ggplot() + 
  geom_sf(data=pprTreeCanopy,color=palette1_main,aes(size=shape_area),fill = palette1_main)+
  geom_sf(data=st_union(pprDistrict),color="black",size=2,fill = "transparent")+
  geom_sf(data=pprDistrict,color="black",size=1,linetype ="dashed",fill = "transparent")+
  labs(title = "", 
       subtitle = "",
       x="",y="")+
  mapTheme()


pprPermittableSpace <- st_read('https://opendata.arcgis.com/datasets/811b67c999bd4e839abb68b16c16f623_0.geojson')%>%
  st_transform(crs)

ggplot() + 
  geom_sf(data=pprPermittableSpace,color=palette1_main,fill = palette1_main)+
  geom_sf(data=st_union(pprDistrict),color="black",size=2,fill = "transparent")+
  geom_sf(data=pprDistrict,color="black",size=1,linetype ="dashed",fill = "transparent")+
  labs(title = "", 
       subtitle = "",
       x="",y="")+
  mapTheme()
