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





###################################### ##################################################################################
#                                             Function to fit the parameters                                            #
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
    dplyr::select(id, centrality) %>% 
    distinct() %>% 
    summarise(centrality_m = mean(centrality))
  # mean of attractiveness
  foreach (attr=attr_column, i = (1:length(attr_column))) %do% {
    distict_data <- data[c("id", attr)] %>% 
      distinct()
    mean_value <- mean(distict_data[[attr]])
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
    mutate(x1 = log(ifelse(distance==0,1e-3,distance)/distance_m),
           x2 = log(ifelse(centrality==0,1e-3,centrality)/mean_total$centrality_m),
           y = log(ifelse(prob==0,0.00015,prob)/prob_m))
  
  col_list <- vector()
  foreach (attr=attr_column, i = (1:length(attr_column))) %do% {
    a <- new_data[[attr]] 
    mean_a <- mean_total[paste0("attr_m_",i)] %>% as.numeric()
    mean_a <- rep(c(mean_a),each=nrow(a))
    value <-  log(ifelse(a==0,1e-3,a)/mean_a)
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
  result <- data.frame(matrix(ncol = 4+length(attr_column), nrow = 0))
  #provide column names
  result_attr_cols <- vector()
  for (i in (1:length(attr_column))) {
    result_attr_cols <- append(result_attr_cols, paste0("alpha",i))
  }
  colnames(result) <- c('origin', 'beta', 'theta', 'r2', result_attr_cols)
  
  for (orig_place in unique(new_data$origin)) {
    # filter data into fit data with origin
    fit_data <- new_data %>%
      filter(origin == orig_place)
    fit <- lm(y ~ ., data=fit_data %>% dplyr::select(-origin))
    
    alpha <- data.frame(matrix(ncol = 0, nrow = 1))
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
    # if(!is.na(fit$coefficients["x1"])) {alpha_p <- as.numeric(summary(fit)$coefficients["x1",4])}
    beta <- as.numeric(fit$coefficients["x1"])
    # if(!is.na(fit$coefficients["x2"])) {beta_p <- as.numeric(summary(fit)$coefficients["x1",4])}
    theta <- as.numeric(fit$coefficients["x2"])
    # if(!is.na(fit$coefficients["x3"])) {theta_p <- as.numeric(summary(fit)$coefficients["x1",4])}
    r2 <- as.numeric(summary(fit)$r.square)
    result <- data.frame(origin=orig_place, beta, theta, r2) %>%
      cbind(alpha) %>%
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
#                             Function to fit the parameters with category variable                                     #
#########################################################################################################################

########################################### Check arguments ###########################################################
fit_parameter_level <- function(data, places, neighbor_data, neighbor_id_column, neighbor_attr_column, id_column, 
                          attr_column, distance_column, probability_column,origin_column, k, category) {
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
    dplyr::select(id, centrality) %>% 
    distinct() %>% 
    summarise(centrality_m = mean(centrality))
  # mean of attractiveness
  foreach (attr=attr_column, i = (1:length(attr_column))) %do% {
    distict_data <- data[c("id", attr)] %>% 
      distinct()
    mean_value <- mean(distict_data[[attr]])
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
    mutate(x1 = log(ifelse(distance==0,1e-3,distance)/distance_m),
           x2 = log(ifelse(centrality==0,1e-3,centrality)/mean_total$centrality_m),
           y = log(ifelse(prob==0,0.00015,prob)/prob_m))
  
  col_list <- vector()
  foreach (attr=attr_column, i = (1:length(attr_column))) %do% {
    a <- new_data[[attr]] 
    mean_a <- mean_total[paste0("attr_m_",i)] %>% as.numeric()
    mean_a <- rep(c(mean_a),each=nrow(a))
    value <-  log(ifelse(a==0,1e-3,a)/mean_a)
    new_data_part <- as.data.frame(value)
    colnames(new_data_part) <- c(paste0("x",2+i))
    new_data <- cbind(new_data, new_data_part, deparse.level = 1)
    col_list <- append(col_list, paste0("x",2+i))
  }
  
  new_data <- new_data %>% 
    dplyr::select(origin, x1, x2, y, col_list) %>% 
    cbind(new_data[category])
  ###########################################################
  #      change into sth like nan_to_num in the future      #
  ###########################################################

  # fit parameter for each origin

  #provide column names
  result_attr_cols <- vector()
  for (i in (1:length(attr_column))) {
    result_attr_cols <- append(result_attr_cols, paste0("alpha",i))
  }

  for (orig_place in unique(new_data$origin)) {
    # filter data into fit data with origin
    fit_data <- new_data %>%
      filter(origin == orig_place)
  
    fit <- lm(y ~ ., data=fit_data %>% dplyr::select(-origin))

    alpha <- data.frame(matrix(ncol = 0, nrow = 1))
    for (j in (1:length(attr_column))) {
      alpha_value <- as.numeric(fit$coefficients[paste0("x",2+j)])
      alpha_part <- data.frame(x = alpha_value)
      colnames(alpha_part) <- c(paste0("alpha", j))
      alpha <- cbind(alpha, alpha_part)
      # alpha_p_value <- as.numeric(summary(fit)$coefficients[paste0("x",2+i),4])
      # alpha_p_part <- data.frame(x = alpha_p_value)
      # colnames(alpha_p_part) <- c(paste0("alpha_p", i))
      # alpha_p <- cbind(alpha_p, alpha_p_part)
    }

    pi <- data.frame(matrix(ncol = 0, nrow = 1))
    pi_list <- unique(data[[category]])
    for (pi_n in pi_list) {
      pi_name <- paste0(category,pi_n)
      if (pi_name %in% names(fit$coefficients)) {
        pi_value <- as.numeric(fit$coefficients[pi_name])
        pi_part <- data.frame(x = pi_value)
        colnames(pi_part) <- c(pi_name)
        pi <- cbind(pi, pi_part)
        # pi_p_value <- as.numeric(summary(fit)$coefficients[1+length(attr_column)+i,4])
        # pi_p_part <- data.frame(x = pi_p_value)
        # colnames(pi_p_part) <- c(paste0("pi_p", i))
        # pi_p <- cbind(pi_p, pi_p_part)
      } else {
        pi_part <- data.frame(pi_name = 0)
        colnames(pi_part) <- c(pi_name)
        pi <- cbind(pi, pi_part)
      }
    pi[,sort(names(pi))]
    }

    # if(!is.na(fit$coefficients["x1"])) {alpha_p <- as.numeric(summary(fit)$coefficients["x1",4])}
    beta <- as.numeric(fit$coefficients["x1"])
    # if(!is.na(fit$coefficients["x2"])) {beta_p <- as.numeric(summary(fit)$coefficients["x1",4])}
    theta <- as.numeric(fit$coefficients["x2"])
    # if(!is.na(fit$coefficients["x3"])) {theta_p <- as.numeric(summary(fit)$coefficients["x1",4])}
    r2 <- as.numeric(summary(fit)$r.square)
    
    if (orig_place == unique(new_data$origin[1])) {
      resultt <- data.frame(origin=orig_place, beta, theta, r2) %>% 
        cbind(alpha) %>%
        cbind(pi)
    } 
    if (orig_place != unique(new_data$origin[1])) {
      resultt <- data.frame(origin=orig_place, beta, theta, r2) %>%
        cbind(alpha) %>%
        cbind(pi) %>%
        rbind(resultt)
    } 
  resultt2 <- tibble(resultt) %>% 
    nest(data = everything()) %>% 
    rename(parameter=data) %>%
    cbind(.,tibble(data) %>% nest(data = everything()))
  }
  return(resultt2)
  # return(fit)
}







#########################################################################################################################
#                                                Function to predict prob                                               #
#########################################################################################################################
huff_NE <- function(destinations_name, destinations_attractiveness, origins_name, destinations_centrality, 
                    category, distance, alpha, beta, theta){
  
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
#                                    Function to predict prob with category variable                                    #
#########################################################################################################################

huff_NE_level <- function(data, places, neighbor_data, neighbor_id_column, neighbor_attr_column, id_column, 
                          attr_column, distance_column, probability_column,origin_column, k, category, parameter, prefix) {
  
  ########################################### Check arguments ###########################################################
  
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
    dplyr::select(id, centrality) %>% 
    distinct() %>% 
    summarise(centrality_m = mean(centrality))
  
  # mean of attractiveness
  foreach (attr=attr_column, i = (1:length(attr_column))) %do% {
    distict_data <- data[c("id", attr)] %>% 
      distinct()
    mean_value <- mean(distict_data[[attr]])
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
    mutate(x1 = log(ifelse(distance==0,1e-3,distance)/distance_m),
           x2 = log(ifelse(centrality==0,1e-3,centrality)/mean_total$centrality_m),
           y = log(ifelse(prob==0,0.00015,prob)/prob_m))
  
  col_list <- vector()
  foreach (attr=attr_column, i = (1:length(attr_column))) %do% {
    a <- new_data[[attr]] 
    mean_a <- mean_total[paste0("attr_m_",i)] %>% as.numeric()
    mean_a <- rep(c(mean_a),each=nrow(a))
    value <-  log(ifelse(a==0,1e-3,a)/mean_a)
    new_data_part <- as.data.frame(value)
    colnames(new_data_part) <- c(paste0("x",2+i))
    new_data <- cbind(new_data, new_data_part, deparse.level = 1)
    col_list <- append(col_list, paste0("x",2+i))
  }
  
  new_data <- new_data %>% 
    dplyr::select(origin, id, x1, x2, col_list) %>% 
    cbind(new_data[category])
  
  new_data <- new_data %>% 
    left_join(.,parameter, by=origin_column) %>% 
    mutate(prob=0)
  ###########################################################
  #      change into sth like nan_to_num in the future      #
  ###########################################################
  
  # predict
  predict_data <- new_data %>% 
    dplyr::select(-origin, -r2)
  
  # get category var list
  category_list <- list()
  for (var in colnames(parameter)) {
    if (str_detect(var, prefix)) {
      category_list <- append(category_list, var)
    }
  }
  
  for (i in (1:(length(attr_column)+2))) {
    result <- new_data %>% 
      mutate(prob = prob + predict_data[[i]]*predict_data[[i+12]])
  }
  for (cat in category) {
    for (var in category_list) {
      if (str_detect(var, cat)) {
        result <- result %>% 
          mutate(prob = prob + predict_data[[cat]] * predict_data[[var]])
      }
    }
  }
  
  result <- result %>% 
    dplyr::select(origin, id, prob)
  # for (orig_place in unique(new_data$origin)) {
  #   # filter data into fit data with origin
  #   fit_data <- new_data %>%
  #     filter(origin == orig_place)
  return(result)
}






















#########################################################################################################################
#                                             Function to cross validation                                              #
#########################################################################################################################
huff_crossValidate <- function(data, cv_id, places, neighbor_data, neighbor_id_column, neighbor_attr_column, id_column, attr_column, distance_column, probability_column,origin_column, k) {
  
  allPredictions <- data.frame()
  cvID_list <- unique(data[[cv_id]])
  
  for (i in cvID_list) {
    
    thisFold <- i
    cat("This hold out fold is", thisFold, "\n")
    
    fold.train <- filter(data, data[[cv_id]] != thisFold) %>% as.data.frame() 
    fold.test  <- filter(data, data[[cv_id]] == thisFold) %>% as.data.frame() 
    
    fit <- fit_parameter(data = fold.train,
                         places = places,
                         neighbor_data = neighbor_data,
                         neighbor_id_column = neighbor_id_column,
                         neighbor_attr_column = neighbor_attr_column,
                         id_column = id_column,
                         attr_column = attr_column,
                         distance_column = distance_column,
                         probability_column = probability_column,
                         origin_column = origin_column,
                         k=k)
    
    parameter <- fit %>% 
      dplyr::select(parameter) %>% 
      unnest(cols="parameter")
    
    # replce na in parameter
    parameter <- parameter %>% 
      mutate_all(funs(replace_na(.,0)))
    
    # join to same index with Test Set
    parameter_full <- left_join(fold.test, parameter, by=origin_column)
    
    # centrality
    fold.test.places <- filter(places, places[[id_column]] %in% as.list(unique(fold.test[[id_column]]))) %>% 
      st_sf()
    
    fold.test <- centrality_to_df(data = fold.test, 
                             places = fold.test.places, 
                             neighbor_data = neighbor_data, 
                             neighbor_id_column=neighbor_id_column,
                             neighbor_attr_column =neighbor_attr_column,
                             id_column=id_column,
                             k = 2)
    
    # attr in test cannot be 0!!!! because 0^negative => NA 
    fold.test <- fold.test %>% 
      mutate_if(is.numeric, funs(ifelse(.==0,0.0000001,.)))


    thisPrediction <- huff_NE(destinations_name = fold.test[['id']],
                                  destinations_attractiveness = fold.test[attr_column],
                                  origins_name = fold.test[['origin']],
                                  destinations_centrality = fold.test[['centrality']],
                                  distance = fold.test[[distance_column]],
                                  alpha = parameter_full %>% dplyr::select(starts_with("alpha")),
                                  beta = parameter_full$beta,
                                  theta = parameter_full$theta)

    allPredictions <-
      rbind(allPredictions, thisPrediction)

  }
  return(allPredictions)
}


#########################################################################################################################
#                                Function to cross validation with category variable                                    #
#########################################################################################################################
huff_crossValidate_level <- function(data, cv_id, places, neighbor_data, neighbor_id_column, neighbor_attr_column, id_column, 
                                    attr_column, distance_column, probability_column,origin_column, k, 
                                   category, parameter, prefix) {
  
  allPredictions <- data.frame()
  cvID_list <- unique(data[[cv_id]])
  
  for (i in cvID_list) {
    
    thisFold <- 7
    cat("This hold out fold is", thisFold, "\n")
    
    fold.train <- filter(data, data[[cv_id]] != thisFold) %>% as.data.frame() 
    fold.test  <- filter(data, data[[cv_id]] == thisFold) %>% as.data.frame() 
    
    # avoid error:contrasts can be applied only to factors with 2 or more levels
    drop_list2 <- fold.train %>%
      group_by(origin) %>%
      summarise(n_program = n_distinct(programNum),
                n_frequency = n_distinct(frequency)) %>%
      filter(n_program < 2 | n_frequency < 2)
    
    fold.train <- fold.train %>%
      filter(!origin %in% drop_list2$origin)
    
    trainPlaces <- places %>% 
      filter(OBJECTID %in% unique(fold.train$OBJECTID))

    fit <- fit_parameter_level(data = fold.train,
                               places = trainPlaces,
                               neighbor_data = convenientSurroundEffect,
                              neighbor_id_column="placekey",
                              neighbor_attr_column ="visits",
                              id_column="OBJECTID",
                              attr_column =c("PC1","PC2","PC3","programNum"),
                              distance_column="distance",
                              probability_column="probability",
                              origin_column = "origin",
                              k=2,
                              category = "frequency")
    
    parameter <- fit %>%
      dplyr::select(parameter) %>%
      unnest(cols="parameter")

# avoid error:contrasts can be applied only to factors with 2 or more levels
fold.test <- fold.test %>%
  filter(origin %in% fold.train$origin)

testPlaces <- RealModelPlaces %>%
  filter(OBJECTID %in% unique(fold.test$OBJECTID))

#encode category
# dmy <- dummyVars(" ~ .", data = fold.test %>% mutate(origin=as.numeric(origin)))
# fold.test <- data.frame(predict(dmy,newdata = fold.test %>% mutate(origin=as.numeric(origin))))
# 
# fold.test <- fold.test %>%
#   mutate(origin = as.character(origin)) %>%
#   rename(c("high" = "frequencyhigh",
#            "low" = "frequencylow",
#            "medium" = "frequencymedium",
#            "mid-low" = "frequencymid.low",
#            "super-high" = "frequencysuper.high",
#            "super-low" =  "frequencysuper.low"))
# 
# # replce na in parameter
# parameter <- parameter %>%
#   mutate_all(funs(replace_na(.,0)))
# 
# # join to same index with Test Set
# parameter_full <- left_join(fold.test %>% dplyr::select(origin),
#                             parameter,
#                             by="origin")
# 
# 
# thisPrediction <- huff_NE_level(data = fold.test,
#                                 places = testPlaces,
#                                 neighbor_data = neighbor_data,
#                                 neighbor_id_column=neighbor_id_column,
#                                 neighbor_attr_column =neighbor_attr_column,
#                                 id_column=id_column,
#                                 attr_column =attr_column,
#                                 distance_column=distance_column,
#                                 probability_column=probability_column,
#                                 origin_column = origin_column,
#                                 k=k,
#                                 category = category,
#                                 parameter = parameter_full,
#                                 prefix = prefix)
# 
# 
# allPredictions <-
#   rbind(allPredictions, thisPrediction)
#     
  }
  return(fold.test)
}

