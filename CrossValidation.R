### Spatial Cross Validation

library(sf)
library(tidyverse)
library(dplyr)
library(magrittr)
library(mapview)
library(spdep)
library(caret)
library(ckanr) 
library(FNN)
library(grid)
library(gridExtra)
library(ggcorrplot)
library(jtools)     
library(stargazer) 
library(broom)
library(tufte)
library(rmarkdown)
library(kableExtra)
library(tidycensus)
library(RSocrata)
library(viridis)
library(spatstat) 
library(raster)
library(knitr)
library(rgdal)

setwd("C:\\PENN\\2022\\MUSA_801_Practicum\\MUSA_801_PPR\\data\\output")

# Read local datasets

#modelPlaces <- st_read('modelPlaces.GEOJSON')
modelData <- read_csv('data/output/SampleModelData.csv')

# count one origin respond to the number of parks
x <- modelData %>% group_by(origin) %>% count()

# sample orgin

origin = "421019891001"

sample = subset(modelData, origin == "421019891001")

# Define Function

crossValidate <- function(sample, id, probability, indVariables) {
  
  allPredictions <- data.frame()
  cvID_list <- unique(sample[[id]])
  
  for (i in cvID_list) {
    
    thisFold <- i
    cat("This hold out fold is", thisFold, "\n")
    
    fold.train <- filter(sample, sample[[id]] != thisFold) %>% as.data.frame() %>% 
      dplyr::select(id, geometry, indVariables, dependentVariable)
    fold.test  <- filter(sample, sample[[id]] == thisFold) %>% as.data.frame() %>% 
      dplyr::select(id, geometry, indVariables, dependentVariable)
   
    regression <-
    lm(y ~ ., data=sample %>% 
         dplyr::select(-origin, -id))
    
    thisPrediction <- 
      mutate(fold.test, Prediction = predict(regression, fold.test, type = "response"))
    
    allPredictions <-
      rbind(allPredictions, thisPrediction)
    
  }
  return(st_sf(allPredictions))
}

reg.vars <- c( "visitors", "attr", "distance", "centrality")

###  create spatial cross validation
reg.spatialCV <- crossValidate(
  dataset = sample,
  id = "id",                            
  dependentVariable = "prob",
  indVariables = reg.vars) 
#  dplyr::select(cvID = id, visitor, prob)


