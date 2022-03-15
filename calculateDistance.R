library(tidyverse)
library(gmapsdistance)
#https://rdrr.io/cran/osrm/man/osrmRoute.html
library(osrm)
library(sf)

# parks
attemptmodelPlaces<- as.character(modelPlaces$geometry)

attemptmodelPlaces <- attemptmodelPlaces %>% str_replace("\\(","") %>% 
  str_replace("\\)","")%>% 
  str_replace("c","")

latParks = map(attemptmodelPlaces,function(x){
  medium = str_split(x,",")
  medium = medium[[1]][2]
  return(medium)
  })

lngParks = map(attemptmodelPlaces,function(x){
  medium = str_split(x,",")
  medium = medium[[1]][1]
  return(medium)
})

latParks = unlist(latParks)
lngParks = unlist(lngParks)

modelPlaces2 <- modelPlaces %>% mutate(parkLat = latParks)%>% mutate(parkLng = lngParks) %>% st_drop_geometry()
# st_write(modelPlaces2,"data/output/modelPlaces2.csv")
modelPlaces2 <- st_read("data/output/modelPlaces2.csv")
# census
attemptCensusData<- as.character(CensusData$originGeometry)

attemptCensusData <- attemptCensusData %>% str_replace("\\(","") %>% 
  str_replace("\\)","")%>% 
  str_replace("c","")

latCensus = map(attemptCensusData,function(x){
  medium = str_split(x,",")
  medium = medium[[1]][2]
  return(medium)
})

lngCensus = map(attemptCensusData,function(x){
  medium = str_split(x,",")
  medium = medium[[1]][1]
  return(medium)
})

latCensus = unlist(latCensus)
lngCensus = unlist(lngCensus)

CensusData2 <- CensusData %>% mutate(bgLat = latCensus)%>% mutate(bgLng = lngCensus)
# st_write(CensusData2,"data/output/CensusData2.csv")
CensusData2 <- st_read("data/output/CensusData2.csv")


resultsDistance = gmapsdistance("39.981442+-75.178765", "39.955165+-75.167341", mode="driving", shape="long")

#openstreetmap
# setwd("D:/")
options(osrm.server = "http://127.0.0.1:5000/")
options(digits=8)

theDistanceMatrix=list()
for(i in 1:nrow(CensusData2)){
  src = c(as.numeric(CensusData2["bgLng"][i,]),as.numeric(CensusData2["bgLat"][i,]))
  theVector = c()
  for (j in 1:nrow(modelPlaces2)){
    dst = c(as.numeric(modelPlaces2["parkLng"][j,]),as.numeric(modelPlaces2["parkLat"][j,]))
    medium = osrmRoute(src,dst,overview = "FALSE")
    theVector = append(theVector,medium[2])
  }
  theDistanceMatrix= append(theDistanceMatrix,list(theVector))
  print(paste0("finish ...",i,"/",nrow(CensusData2)))
  # Sys.sleep(3)
}

theDistanceMatrix2 <- theDistanceMatrix
daFrame <- as.data.frame(matrix(unlist(theDistanceMatrix2), nrow=length(theDistanceMatrix2), byrow=TRUE))
#st_write(daFrame,"data/output/theDistanceMatrixWhole.csv")
theDistanceMatrixWhole <- st_read("data/output/theDistanceMatrixWhole.csv")
