monthList = c("01","02","03","04","05","06","07","08","09","10","11")

# device panel data from PPR
homePanelAllMonth = data.frame()
for (i in monthList){
  currentMonth = vroom(paste("data/safegraph/SafeGraph Data Purchase Dec-16-2021/Philadelphia-Camden-WilmingtonPA-NJ-DE-MDMSA-PATTERNS-2021_",
       i,
       "-2021-12-17/home_panel_summary.csv",sep = ""))%>%
    filter(region=="pa")%>%
    filter(census_block_group %in% CensusData$GEOID)
  homePanelAllMonth = rbind(homePanelAllMonth,currentMonth)
}

homePanelAllMonth <- homePanelAllMonth %>% dplyr::select(month,census_block_group,number_devices_residing)

# population data from acs
censusPopData <-
  get_acs(geography = "block group",
          variables = c("B01003_001E"),
          year=2019, state="PA", county="Philadelphia", geometry=T, output="wide") %>%
  st_transform(crs=4326) %>%
  dplyr::select(-NAME,-B01003_001M) %>%
  st_drop_geometry() %>%
  as.data.frame() %>%
  rename("population" = "B01003_001E")

# get the quotient and apply
homePanelToGo <- 
  homePanelAllMonth %>% 
  rename("GEOID"="census_block_group") %>% 
  group_by(GEOID) %>% 
  summarise(avgDeviceResiding = mean(number_devices_residing)) %>% 
  left_join(censusPopData, by="GEOID") %>% 
  mutate(quotient = population / avgDeviceResiding)
