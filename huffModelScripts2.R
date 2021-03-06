library(FNN)
library(foreach)

########################################################################################################
#
# destination: a string, indicating the id of the target place                                         #
# data: a df where observations is the all available combination of origins and destinations           #
# neighbor_data: a st dataframe, including all places                                                         # 
# id_column: a string, indicating which column is the id                                               # 
# attr_column:a string, indicating a column representing attractiveness as a number                    #
# distance_column,                                                                                     #
# probability_column,                                                                                  #
# origin_column                                                                                        #
# k: a integer, indicating the number of the neighbor                                                  #
#
########################################################################################################


#########################################################################################################################
#                               Function to find k nearest neighbor and distance for one destination                    #
#########################################################################################################################
find_neighbor <- function(places, neighbor_data, neighbor_id_column, destination, k, id_column){
  # rename id column in neighbor_data
  if (neighbor_id_column != "id") {
    neighbor_data <- rename(neighbor_data, c("id"=neighbor_id_column))
  }
  # rename id column in places
  if (id_column != "id") {
    places <- rename(places, c("id"=id_column))
  }
  
  neighbor_data_n <- neighbor_data %>% 
    st_drop_geometry()
  neighbor_data_matrix <- as.matrix(neighbor_data %>% 
                               filter(id != destination) %>% 
                               st_coordinates())
  detination_matrix <- as.matrix(places %>% 
                                   filter(id == destination) %>% 
                                   st_coordinates())
  fit <- get.knnx(neighbor_data_matrix, detination_matrix, k)
  rank_matrix <- fit$nn.index
  dist_matrix <- fit$nn.dist
  result <-  data.frame(id=c(), distance=c())
  foreach (index = rank_matrix, dist = dist_matrix) %do% {
    result <- rbind(result, 
                    data.frame(id=neighbor_data_n[index,'id'],
                               distance=dist))
  }
  return(result)
}

#########################################################################################################################
#                                        Function to calculate centrality for one destination                           #
#########################################################################################################################
centrality <- function(destination, data, places, neighbor_data, neighbor_id_column, neighbor_attr_column, id_column, k) {
  # rename id column in neighbor_data
  if (neighbor_id_column != "id") {
    neighbor_data <- rename(neighbor_data, c("id"=neighbor_id_column))
  }
  # rename id column in data
  if (id_column != "id") {
    data <- rename(data, c("id"=id_column))
  }
  # rename id column in places
  if (id_column != "id") {
    places <- rename(places, c("id"=id_column))
  }
  
  # rename attractiveness column in neighbor_data
  if (neighbor_attr_column != "attr") {
    neighbor_data <- rename(neighbor_data, c("attr"=neighbor_attr_column))
  }
  
  neighbor_df = find_neighbor(places, neighbor_data, "id", destination, k, "id")
  c = 0
  x = 0
  y = 0
  foreach (p = neighbor_df$id, d = neighbor_df$distance) %do% {
    a <-  neighbor_data %>% 
      st_drop_geometry() %>% 
      filter(id == p) %>% 
      dplyr::select(attr) %>% 
      unique() %>% 
      as.numeric()
    x = x + a/d
    y = y + 1/d
  }
  c = x/y
  return(c)
}
#########################################################################################################################
#                                    Function to add centrality into the integrated dataframe                          #
#########################################################################################################################
centrality_to_df <- function(data, places, neighbor_data, neighbor_id_column, neighbor_attr_column, id_column, k) {
  # rename id column in neighbor_data
  if (neighbor_id_column != "id") {
    neighbor_data <- rename(neighbor_data, c("id"=neighbor_id_column))
  }
  # rename id column in data
  if (id_column != "id") {
    data <- rename(data, c("id"=id_column))
  }
  # rename id column in places
  if (id_column != "id") {
    places <- rename(places, c("id"=id_column))
  }
  # rename attractiveness column in neighbor_data
  if (neighbor_attr_column != "attr") {
    neighbor_data <- rename(neighbor_data, c("attr"=neighbor_attr_column))
  }
  
  
  # calculate centrality  for each destination
  # Here not iterate for the whole 'data' but just distinct destinations to save computing time
  cen_data <- map_dbl(.x=places$id, ~centrality(.x, data, places, neighbor_data, "id", "attr", "id", k)) 
  cen_data <- data.frame(centrality = cen_data) %>% 
    cbind(places %>% 
            st_drop_geometry() %>% 
            dplyr::select(id))
  data <- left_join(data, cen_data,by="id")
  return(data)
}

#########################################################################################################################
#                                Function to fit the parameters for one destination                                     #
#########################################################################################################################

########################################### Check arguments ###########################################################
fit_parameter <- function(data, places, neighbor_data, neighbor_id_column, neighbor_attr_column, id_column, attr_column, distance_column, probability_column,origin_column, k) {
  # rename id column in neighbor_data
  if (neighbor_id_column != "id") {
    neighbor_data <- rename(neighbor_data, c("id"=neighbor_id_column))
  }
  # rename attractiveness column in neighbor_data
  if (neighbor_attr_column != "attr") {
    neighbor_data <- rename(neighbor_data, c("attr"=neighbor_attr_column))
  }
  # rename id column in places
  if (id_column != "id") {
    places <- rename(places, c("id"=id_column))
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
  
  ############################################### Functions ############################################################# 
  # calculate and add centrality to data
  data <- centrality_to_df(data, places, neighbor_data, "id", "attr", "id", k)
  
  # mean of centrality
  mean_total <- data %>% 
    summarise(centrality_m = mean(centrality))
  # mean of attractiveness
  foreach (attr=attr_column, i = (1:length(attr_column))) %do% {
    mean_value <- mean(data[[attr]])
    mean_part <- data.frame(x = mean_value)
    colnames(mean_part) <- c(paste0("attr_m_",i))
    mean_total <- cbind(mean_total, mean_part)
  }

  
  # mean over origin - distance & probability
  mean_origin <- data %>% 
    group_by(origin) %>% 
    summarise(distance_m = mean(distance),
              prob_m = mean(prob))
  
  # join mean df, transform var for fitting
  new_data <- left_join(data, mean_origin, by=c("origin")) %>% 
    mutate(x1 = log(1+distance/distance_m),
           x2 = log(1+centrality/mean_total$centrality_m),
           y = log(1+prob/prob_m))
  
  col_list <- vector()
  foreach (attr=attr_column, i = (1:length(attr_column))) %do% {
    a <- new_data[attr] %>% as.vector()
    mean_a <- mean_total[paste0("attr_m_",i)] %>% as.numeric()
    mean_a <- rep(c(mean_a),each=nrow(a))
    value <-  log(1 + a/mean_a)
    new_data_part <- as.data.frame(value)
    colnames(new_data_part) <- c(paste0("x",2+i))
    new_data <- cbind(new_data, new_data_part, deparse.level = 1)
    col_list <- append(col_list, paste0("x",2+i))
  }
  
  new_data <- new_data %>% 
    dplyr::select(origin, x1, x2, y, col_list)
  ###########################################################
  #      change into sth like nan_to_num in the future      #
  ###########################################################

  # fit parameter for each origin

  #create result data frame with 0 rows and 5 columns
  result <- data.frame(matrix(ncol = 6+2*length(attr_column), nrow = 0))
  #provide column names
  result_attr_cols <- vector()
  for (i in (1:length(attr_column))) {
    result_attr_cols <- append(result_attr_cols, paste0("alpha",i))
    result_attr_cols <- append(result_attr_cols, paste0("alpha_p",i))
  }
  colnames(result) <- c('origin', 'beta', 'beta_p', 'theta', 'theta_p', 'r2', result_attr_cols)

  for (orig_place in unique(new_data$origin)) {
    # filter data into fit data with origin
    fit_data <- new_data %>%
      filter(origin == orig_place)
    fit <- lm(y ~ ., data=fit_data %>% dplyr::select(-origin))

    alpha <- data.frame(matrix(ncol = 0, nrow = 1))
    alpha_p <- data.frame(matrix(ncol = 0, nrow = 1))
    for (i in (1:length(attr_column))) {
      alpha_value <- as.numeric(fit$coefficients[paste0("x",2+i)])
      alpha_part <- data.frame(x = alpha_value)
      colnames(alpha_part) <- c(paste0("alpha", i))
      alpha <- cbind(alpha, alpha_part)
      
      # alpha_p_value <- as.numeric(summary(fit)$coefficients[paste0("x",2+i),4])
      # alpha_p_part <- data.frame(x = alpha_p_value)
      # colnames(alpha_p_part) <- c(paste0("alpha_p", i))
      # alpha_p <- cbind(alpha_p, alpha_p_part)
    }
    beta <- as.numeric(fit$coefficients["x1"])
    # if(!is.na(fit$coefficients["x1"])) {beta_p <- as.numeric(summary(fit)$coefficients["x1",4])}
    theta <- as.numeric(fit$coefficients["x2"])
    # if(!is.na(fit$coefficients["x2"])) {theta_p <- as.numeric(summary(fit)$coefficients["x1",4])}
    r2 <- as.numeric(summary(fit)$r.square)
    # result <- data.frame(origin=orig_place, beta, beta_p, theta, theta_p, r2) %>%
    result <- data.frame(origin=orig_place, beta, theta, r2) %>%
      cbind(alpha) %>%
      cbind(alpha_p) %>% 
      rbind(result)
  }
  result <- tibble(result) %>%
    nest(data = everything()) %>%
    rename(parameter=data) %>%
    cbind(tibble(data) %>%
          nest(data = everything()))

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
