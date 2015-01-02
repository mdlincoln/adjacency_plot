library(igraph)
library(dplyr)

generate_graph_tables <- function(edge_table, node_table = NULL, directed = TRUE) {
  # Create iGraph object
  print("Creating Igraph object...")
  graph <- graph.data.frame(edge_table, directed = directed, vertices = node_table)

  # Calculate various network properties, adding them as attributes to each
  # node/vertex
  print("Walktrap communities...")
  V(graph)$walktrap_comm <- membership(walktrap.community(graph))
  print("Spinglass commmunities")
  V(graph)$spinglass_comm <- membership(spinglass.community(graph))
  print("Edge betweenness communities...")
  V(graph)$edge_comm <- membership(edge.betweenness.community(graph))
  print("Other node statistics...")
  V(graph)$degree <- degree(graph)
  V(graph)$closeness <- centralization.closeness(graph)$res
  V(graph)$betweenness <- centralization.betweenness(graph)$res
  V(graph)$eigen <- centralization.evcent(graph)$vector

  # Re-generate dataframes for both nodes and edges, now containing
  # calculated network attributes
  node_list <- get.data.frame(graph, what = "vertices")
  edge_list <- get.data.frame(graph, what = "edges")

  if(directed) {
    return(list(nodes = node_list, edges = edge_list))
  } else {
    edge_list <- rbind(edge_list, edge_list %>% rename(from = to, to = from))
    return(list(nodes = node_list, edges = edge_list))
  }
}

if(file.exists("data/goltzius.RData")) {
  load("data/goltzius.RData")
} else {
  goltzius_edgelist <- read.csv("data/csv/goltzius_graph.csv", stringsAsFactors = FALSE)
  goltzius_nodelist <- read.csv("data/csv/goltzius_nodes.csv", stringsAsFactors = FALSE)
  goltzius_tables <- generate_graph_tables(goltzius_edgelist, goltzius_nodelist, directed = TRUE)
  goltzius_node_list <- goltzius_tables$nodes
  goltzius_edge_list <- goltzius_tables$edges
  save(goltzius_edge_list, goltzius_node_list, file = "data/goltzius.RData")
}

if(file.exists("data/les_mis.RData")) {
  load("data/les_mis.RData")
} else {
  lm_edgelist <- read.csv("data/csv/les_mis_graph.csv", stringsAsFactors = FALSE)
  lm_tables <- generate_graph_tables(lm_edgelist, directed = FALSE)
  lm_node_list <- lm_tables$nodes
  lm_edge_list <- lm_tables$edges
  save(lm_node_list, lm_edge_list, file = "data/les_mis.RData")
}

