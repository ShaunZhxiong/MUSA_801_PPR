#########################################################################################################################
#                                 Function to check the arguments of the huff function                                  #
#########################################################################################################################
check_huff <- function(destinations_name, destinations_attractiveness, distance, destinations_centrality,alpha, beta){
  
  destinations_nr <- length(destinations_name)
  
  if (any(is.na(destinations_name))){
    stop("NA values were found in the destinations names")
  }
  
  if (any(is.na(destinations_attractiveness))){
    stop("NA values were found in the attractiveness data")
  }
  
  # if (any(is.na(origins_name))){
  #   stop("NA values were found in the origins names")
  # }
  
  if (any(is.na(distance))){
    stop("NA values were found the distance data")
  }
  
  if (any(is.na(alpha))){
    stop("NA values were found in the alpha exponent")
  }
  
  if (any(is.na(beta))){
    stop("NA values were found in the beta exponent")
  }
  
  # The destinations_attractiveness vector should be of equal length to the destinations data
  if (length(destinations_attractiveness) != destinations_nr){
    stop("The destinations_attractiveness vector should be the same length as the destinations_name")
  }
  
  # if (length(origins_name) != destinations_nr){
  #   stop("The origins_name vector should be the same length as the destinations_name")
  # }
  # 
  if (length(distance) != destinations_nr){
    stop("The distance vector should be the same length as the destinations_name")
  }
  
  if (any(distance <= 0)){
    dist_flag = T # True means do sth with distance, i.e. replace zeroes
    warning("Distances equal to zero were found, all distances below 0.1 were replaced with 0.1")
  } else {
    dist_flag = F
  }
  
  # Are there any weird values in the destinations_attractiveness vector
  if (min(destinations_attractiveness) <= 0){
    stop("The attractiveness score can't be less than or equal to zero")
  }
  
  # The same for alpha
  if (length(alpha) > 1){
    if (min(alpha) < 0){
      stop("The alpha value should be greater than or equal to zero")
    } else if (length(alpha) != destinations_nr){
      stop("Different lengths between vectors of alpha values and destinations, should be equal")
    }
    alpha_flag = F
  } else {
    if (alpha < 0 || length(alpha) == 0){
      stop("The alpha value should be greater or equal to zero")
    } else {
      alpha_flag = T # True means do sth with alpha that is get from length 1 to length n as follows
      # alpha <- rep(alpha, destinations_nr)
    }
  }
  
  # The same for beta
  if (length(beta) > 1){
    if (min(beta) < 0){
      stop("The beta value should be greater than or equal to zero")
    } else if (length(beta) != destinations_nr){
      stop("Different length for the vectors of beta values and destinations was provided, should be equal")
    }
    beta_flag = F
  } else {
    if (beta < 0 || length(beta) == 0){
      stop("The beta value should be greater or equal to zero")
    } else {
      beta_flag = T # True means do sth with beta that is get from length 1 to length n as follows
      # beta <- rep(beta, destinations_nr)
    }
  }
  return(c(destinations_nr, alpha_flag, beta_flag, dist_flag))
}


huff_NE <- function(destinations_name, destinations_attractiveness, origins_name, destinations_centrality, 
                    distance, alpha, beta, theta){
  
  ############################################### Functions #############################################################
  huff_numerator_basic <- function(destinations_attractiveness, distance, destinations_centrality, alpha, beta, theta){
    numerator <- (destinations_centrality ^ theta) * (distance ^ beta)
    for (i in (1:length(alpha))) {
      numerator <- numerator * (destinations_attractiveness[i] ^ alpha[i])
    }
    # for (i in (1:ncol(theta))) {
    #   numerator <- numerator * (destinations_centrality[,i] ^ theta[,i])
    # }
    return(numerator)
  }
  
  ########################################### Check arguments ###########################################################
  # flags <- check_huff(destinations_name, destinations_attractiveness, origins_name, distance, alpha, beta)
  # # If we have distance values equal to zero replace with 0.001 
  # 
  # if (flags[2]){
  #   alpha <- rep(alpha, flags[1])
  # }
  # 
  # if (flags[3]){
  #   beta <- rep(beta, flags[1])
  # }
  # 
  # if (flags[4]){
  #   distance <- ifelse(distance < 0.001, 0.001, distance)
  # }
  # 
  ################################### Calculate Huff's (basic) algorithm ################################################
  # Numerator, calculated using the huff_numerator_basic function
  huff <- vector()
  
  for (i in (1:length(distance))) {
    destinations_attractivenessx <- destinations_attractiveness[i,] %>% as.numeric()
    distancex <-  distance[i]
    destinations_centralityx <- destinations_centrality[i]
    alphax <- alpha[i,] %>% as.numeric()
    betax <- beta[i]
    thetax <- theta[i]
    result <- huff_numerator_basic(destinations_attractivenessx, distancex, destinations_centralityx, alphax, betax, thetax)
    huff <- append(huff, result)
  }
  
  # Denominator of the basic huff algorithm
  sum_huff_location <- aggregate(huff, by = list(origins_name), sum)
  names(sum_huff_location) <- c("origins_name", "sum_huff")
  
  # Merge denominator and nominator
  out <- merge(data.frame(origins_name, destinations_name, distance, huff), sum_huff_location, by="origins_name") 
  
  # Calculate huff probabilities
  out$huff_probability <- with(out, huff / sum_huff)
  
  # Identify primary catchment areas
  out$catchment <- ifelse(out$huff_probability > 0.5, "Primary", "Secondary")
  
  return(out)
}


#########################################################################################################################
#                                                       Call the function                                               #
#########################################################################################################################
library(dplyr)
library(tidyverse)

# dataForPrediction data can also be passed in directly
#dataForPrediction <- st_read("data/output/dashboard/final/dataForPrediction.csv")

dataForPrediction <- dataForPrediction %>% 
  mutate_all(.,as.numeric) %>% 
  mutate(id = as.character(id),
         origin = as.character(origin))

predictionResult <- huff_NE(destinations_name = dataForPrediction$id, 
                            destinations_attractiveness = dataForPrediction[c("PC1","PC2",
                                                                              "PC3","programNum")], 
                            origins_name = dataForPrediction$origin, 
                            destinations_centrality = dataForPrediction$centrality,
                            distance = dataForPrediction$distance,
                            alpha = dataForPrediction %>% dplyr::select(starts_with("alpha")),
                            beta = dataForPrediction$beta,
                            theta = dataForPrediction$theta)
