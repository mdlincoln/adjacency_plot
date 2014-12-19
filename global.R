library(igraph)
library(dplyr)
library(ggplot2)

engraver_edges <- read.csv("goltzius_graph.csv")

engraver_graph <- graph.data.frame(engraver_edges, directed = TRUE)

V(engraver_graph)$comm <- membership(walktrap.community(engraver_graph))
V(engraver_graph)$degree <- degree(engraver_graph)
V(engraver_graph)$closeness <- centralization.closeness(engraver_graph)$res
V(engraver_graph)$betweenness <- centralization.betweenness(engraver_graph)$res
V(engraver_graph)$eigen <- centralization.evcent(engraver_graph)$vector

edge_list <- get.data.frame(engraver_graph, what = "edges")
node_list <- get.data.frame(engraver_graph, what = "vertices")

adj_data <- edge_list %>%
  inner_join(node_list, by = c("from" = "name")) %>%
  inner_join(node_list, by = c("to" = "name")) %>%
  mutate(group = as.factor(ifelse(comm.x == comm.y, comm.x, NA)))

