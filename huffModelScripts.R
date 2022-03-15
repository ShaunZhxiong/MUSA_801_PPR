library(FNN)
library(foreach)
# destination: a string, indicating the id of the target place
# attr_df: a df, at least including a column of unique id and a column of attractiveness
# places: a st dataframe, including all places
# id_column: a string, indicating which column is the id 
# attr_column:a string, indicating a column representing attractiveness as a number
# k: a integer, indicating the nunber of the neighbor

#########################################################################################################################
#                               Function to find k nearest neighbor and distance for one destination                    #
#########################################################################################################################
find_neighbor <- function(places, destination, k){
  places_n <- places %>% 
    st_drop_geometry()
  places_matrix <- as.matrix(places %>% 
                               filter(id != destination) %>% 
                               st_coordinates())
  detination_matrix <- as.matrix(places %>% 
                                   filter(id == destination) %>% 
                                   st_coordinates())
  fit <- get.knnx(places_matrix, detination_matrix, k)
  rank_matrix <- fit$nn.index
  dist_matrix <- fit$nn.dist
  result = data.frame(id=c(), distance=c())
  foreach (index = rank_matrix, dist = dist_matrix) %do% {
    result <- rbind(result, 
                    data.frame(id=places_n[index,'id'],
                               distance=dist))
  }
  return(result)
}

#########################################################################################################################
#                                        Function to calculate centrality for one destination                           #
#########################################################################################################################
centrality <- function(destination, data, places, attr_column, k) {
  neighbor_df = find_neighbor(places, destination, k)
  c = 0
  dist = 0
  foreach (p = neighbor_df$id, d = neighbor_df$distance) %do% {
    a <-  data %>% 
      filter(id == p) %>% 
      select(attr) %>% 
      unique() %>% 
      as.numeric()
    c = c + a/d
    dist = dist + d
    c = c/dist
  }
  return(c)
}
#########################################################################################################################
#                                    Function to add centrality into the integrated dataframe                          #
#########################################################################################################################
centrality_to_df <- function(data, places, id_column, attr_column, k) {
  # calculate centrality  for each destination
    # Here not iterate for the whole 'data' but just distinct destinations to save computing time
  cen_data <- map_dbl(.x=places$id, ~centrality(.x, data, places, attr_column, k)) 
  cen_data <- data.frame(centrality = cen_data) %>% 
    cbind(places['id']) %>% 
    dplyr::select(-geometry)
  data <- left_join(data, cen_data,by="id")
  return(data)
}

#########################################################################################################################
#                                Function to fit the parameters for one destination                                     #
#########################################################################################################################
fit_parameter <- function(data, places, id_column, attr_column, distance_column, probability_column,origin_column, k) {
  # rename id column in places
  if (id_column != "id") {
    places <- rename(places, c("id"=id_column))
  }
  # rename attractiveness column
  if (attr_column != "attr") {
    data <- rename(data, c("attr"=attr_column))
  }
  # rename id column in data
  if (id_column != "id") {
    data <- rename(data, c("id"=id_column))
  }
  # rename distance column
  if (distance_column != "distance") {
    data <-  data %>% 
      rename(., c("distance"=distance_column)) 
  }
  # rename probability column
  if (probability_column != "prob") {
    data <-  data %>%
      rename(., c("prob"=probability_column))
  }
  # rename origin column
  if (origin_column != "origin") {
    data <-  data %>%
      rename(., c("origin"=origin_column))
  }
  
  # calculate and add centrality to data
  data <- centrality_to_df(data, places, id_column, attr_column, k)
  
  # mean over destination
  mean_total <- data %>% 
    summarise(attr_m = mean(attr), 
              centrality_m = mean(centrality))
  
  mean_origin <- data %>% 
    group_by(origin) %>% 
    summarise(distance_m = mean(distance),
              prob_m = mean(prob))
  
  # join mean df, transform var for fitting
  new_data <- left_join(data, mean_origin, by=c("origin")) %>% 
    mutate(x1 = log(1+attr/mean_total$attr_m),
           x2 = log(1+distance/distance_m),
           x3 = log(1+centrality/mean_total$centrality_m),
           y = log(1+prob/prob_m)) %>% 
    dplyr::select(origin, x1, x2, x3, y)
  ###########################################################
  #      change into sth like nan_to_num in the future      #
  ###########################################################
  
  # fit parameter for each origin
  result <- data.frame(origin = c(), alpha = c(),
                       beta = c(), 
                       theta = c(), r2 = c())
  for (orig_place in unique(new_data$origin)) {
    # filter data into fit data with origin
    fit_data <- new_data %>% 
      filter(origin == orig_place) 
    fit <- lm(y ~ ., data=fit_data %>% dplyr::select(-origin))
    alpha <-  as.numeric(fit$coefficients["x1"])
    # if(!is.na(fit$coefficients["x1"])) {alpha_p <- as.numeric(summary(fit)$coefficients["x1",4])}
    beta <- as.numeric(fit$coefficients["x2"])
    # if(!is.na(fit$coefficients["x2"])) {beta_p <- as.numeric(summary(fit)$coefficients["x1",4])}
    theta <- as.numeric(fit$coefficients["x3"])
    # if(!is.na(fit$coefficients["x3"])) {theta_p <- as.numeric(summary(fit)$coefficients["x1",4])}
    r2 <- as.numeric(summary(fit)$r.square)
    result <- data.frame(origin=unique(fit_data$origin) ,alpha, beta, theta, r2) %>% 
      rbind(result)
  }
  return(result)
  # return(fit)
}














#########################################################################################################################
#                                 Function to check the arguments of the huff function                                  #
#########################################################################################################################
check_huff <- function(destinations_name, destinations_attractiveness, origins_name, distance, alpha, beta){
  
  destinations_nr <- length(destinations_name)
  
  if (any(is.na(destinations_name))){
    stop("NA values were found in the destinations names")
  }
  
  if (any(is.na(destinations_attractiveness))){
    stop("NA values were found in the attractiveness data")
  }
  
  if (any(is.na(origins_name))){
    stop("NA values were found in the origins names")
  }
  
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
  
  if (length(origins_name) != destinations_nr){
    stop("The origins_name vector should be the same length as the destinations_name")
  }
  
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

# fit the parameter
huff_NE <- function(destinations_name, destinations_attractiveness, origins_name, distance, alpha = 1, beta = 2){
  
  ############################################### Functions #############################################################
  huff_numerator_basic <- function(destinations_attractiveness, alpha, distance, beta){
    return((destinations_attractiveness ^ alpha) / (distance ^ beta))
  }
  
  ########################################### Check arguments ###########################################################
  flags <- check_huff(destinations_name, destinations_attractiveness, origins_name, distance, alpha, beta)
  # If we have distance values equal to zero replace with 0.001 
  
  if (flags[2]){
    alpha <- rep(alpha, flags[1])
  }
  
  if (flags[3]){
    beta <- rep(beta, flags[1])
  }
  
  if (flags[4]){
    distance <- ifelse(distance < 0.001, 0.001, distance)
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
