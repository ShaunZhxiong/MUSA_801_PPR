library(tidyverse)

#setwd("C:\\PENN\\2022\\MUSA_801_Practicum\\MUSA_801_PPR")

# read data

modelData <- read_csv('data/output/RealModelData2.csv')
parameter <- read_csv('data/output/RealParameter.csv')

# extract input features

dest <- data.frame(dest = c(modelData$id),
                    pc1   = c(modelData$PC1),
                    pc2   = c(modelData$PC2),
                    pc3   = c(modelData$PC3),
                    pc4   = c(modelData$PC4),
                    pc5   = c(modelData$PC5),
                    c = c(modelData$centrality)
)

origin <- data.frame(origin   = c(modelData$origin),
                      predict_prob = c(NA))

dist <- data.frame(origin = c(modelData$origin),
                    dest   = c(modelData$id),
                    dist   = c(modelData$distance))

# extract parameters

#aj = parameter %>% filter(origin == "i") %>% select(alphaj)

a1 = parameter %>% filter(origin == "i") %>% select(alpha1)
a2 = parameter %>% filter(origin == "i") %>% select(alpha2)
a3 = parameter %>% filter(origin == "i") %>% select(alpha3)
a4 = parameter %>% filter(origin == "i") %>% select(alpha4)
a5 = parameter %>% filter(origin == "i") %>% select(alpha5)

b = parameter %>% filter(origin == "i") %>% select(beta)

t = parameter %>% filter(origin == "i") %>% select(theta)

### test model loop

results <- data.frame(matrix(ncol=3, nrow=0))
colnames(results) <- c("origin", "dest", "predict_prob")

# i as origin 
for(i in seq_len(nrow(origin))) {
  cat(i,"\n")
  origin_i <- origin$origin[i]
  #parameters
  a1 = parameter %>% filter(origin == origin_i) %>% select(alpha1)
  a2 = parameter %>% filter(origin == origin_i) %>% select(alpha2)
  a3 = parameter %>% filter(origin == origin_i) %>% select(alpha3)
  a4 = parameter %>% filter(origin == origin_i) %>% select(alpha4)
  a5 = parameter %>% filter(origin == origin_i) %>% select(alpha5)
  b  = parameter %>% filter(origin  == origin_i) %>% select(beta)
  t  = parameter %>% filter(origin  == origin_i) %>% select(theta)
  
  #divisor = (120^a/5^b) + (200^a/8^b)
  data <- filter(dist, origin == origin_i) %>% 
    left_join(dest, by = c("dest" = "dest")) %>% 
    mutate(AjCjDij = (pc1^a1)*(pc2^a2)*(pc3^a3)*(pc4^a4)*(pc5^a5)*(c^t)*(dist^b))

  d <- data %>% summarise(AjCjDij = sum(AjCjDij))
  d <- d$AjCjDij
  # j as destination
  for(j in seq_len(nrow(data))) {
    dest_j <- data$dest[j]
    
    n <- data %>% filter(dest == dest_j)
    n <- n$AjCjDij
    prob <- n/d
    results <- data.frame(origin = origin_i, dest = dest_j, predict_prob = prob) %>% 
      rbind(results)
  }
}

    # pred_y <- data %>% 
    #   mutate(prob = AjCjDij/d)
    
    # # stuff
    # dest_j <- dest$dest[j]
    # # Aj  <- filter(dest,dest == dest_j) %>% pull(pc1,pc2,pc3,pc4,pc5)
    # 
    # Aj1 = dest %>% filter(dest == dest_j) %>% pull(pc1) %>% unique()
    # Aj2 = dest %>% filter(dest == dest_j) %>% pull(pc2) %>% unique()
    # Aj3 = dest %>% filter(dest == dest_j) %>% pull(pc3) %>% unique()
    # Aj4 = dest %>% filter(dest == dest_j) %>% pull(pc4) %>% unique()
    # Aj5 = dest %>% filter(dest == dest_j) %>% pull(pc5) %>% unique()
    # 
    # Aj  <- (Aj1^a1)*(Aj2^a2)*(Aj3^a3)*(Aj4^a4)*(Aj5^a5)
    # 
    # Dij <- filter(dist,
    #               origin == origin_i,
    #               dest   == dest_j) %>% 
    #   pull(dist)
    # Dij <- Dij^b
    # # pij_1A = (Aj/Dij) / divisor
    # Pij <- (Aj*Cj*Dij) / divisor_i
    # results[i,j+1] <- Pij
    # print(Pij)
#   }
# }