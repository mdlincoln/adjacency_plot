library(igraph)
library(dplyr)

original_edgelist <- read.csv("goltzius_graph.csv", stringsAsFactors = FALSE)
original_nodelist <- read.csv("goltzius_nodes.csv", stringsAsFactors = FALSE)
graph <- graph.data.frame(original_edgelist, directed = TRUE, vertices = original_nodelist)

V(graph)$comm <- membership(optimal.community(graph))
V(graph)$degree <- degree(graph)
V(graph)$closeness <- centralization.closeness(graph)$res
V(graph)$betweenness <- centralization.betweenness(graph)$res
V(graph)$eigen <- centralization.evcent(graph)$vector

node_list <- get.data.frame(graph, what = "vertices")
comm_order <- (node_list %>% count(comm) %>% arrange(-n))$comm
node_list <- node_list %>% mutate(comm = factor(comm, comm_order))

edge_list <- get.data.frame(graph, what = "edges") %>%
  inner_join(node_list %>% select(name, comm), by = c("from" = "name")) %>%
  inner_join(node_list %>% select(name, comm), by = c("to" = "name")) %>%
  mutate(group = ifelse(comm.x == comm.y, comm.x, NA) %>% factor())
