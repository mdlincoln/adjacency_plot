library(igraph)
library(dplyr)

generate_graph_tables <- function(graph) {
  # Calculate various network properties, adding them as attributes to each
  # node/vertex
  if(!(is.directed(graph))) {
    # Community detection algorithms that can only work on undirected graphs
    print("Fastgreedy communities...")
    V(graph)$fastgreedy_comm <- membership(fastgreedy.community(graph))
    print("Multilevel communities...")
    V(graph)$multilevel_comm <- membership(multilevel.community(graph, weights = E(graph)$weight))
  }

  print("Walktrap communities...")
  V(graph)$walktrap_comm <- membership(walktrap.community(graph))
  print("Edge betweenness communities...")
  V(graph)$edge_comm <- membership(edge.betweenness.community(graph))

  if(vcount(graph) < 80) {
    # optimal.community has exponential time complexity, and should not be run
    # on large graphs
    print("Optimal communities...")
    V(graph)$optimal_comm <- membership(optimal.community(graph))
  }

  if(is.connected(graph)) {
    # Spinglass will only work on highly connected graphs
    print("Spinglass commmunities")
    V(graph)$spinglass_comm <- membership(spinglass.community(graph))
  }

  print("Other node statistics...")
  V(graph)$degree <- degree(graph)
  V(graph)$closeness <- centralization.closeness(graph)$res
  V(graph)$betweenness <- centralization.betweenness(graph)$res
  V(graph)$eigen <- centralization.evcent(graph)$vector

  # Re-generate dataframes for both nodes and edges, now containing
  # calculated network attributes
  node_list <- get.data.frame(graph, what = "vertices")
  edge_list <- get.data.frame(graph, what = "edges")

  if(is.directed(graph)) {
    return(list(nodes = node_list, edges = edge_list))
  } else {
    edge_list <- rbind(edge_list, edge_list %>% rename(from = to, to = from))
    return(list(nodes = node_list, edges = edge_list))
  }
}

if(file.exists("data/goltzius.RData")) {
  load("data/goltzius.RData")
} else {
  goltzius_edgelist <- read.csv("data/csv/goltzius_edges.csv", stringsAsFactors = FALSE)
  goltzius_nodelist <- read.csv("data/csv/goltzius_nodes.csv", stringsAsFactors = FALSE)
  goltzius_graph <- graph.data.frame(goltzius_edgelist, directed = TRUE, vertices = goltzius_nodelist)
  goltzius_tables <- generate_graph_tables(goltzius_graph)
  goltzius_node_list <- goltzius_tables$nodes
  goltzius_edge_list <- goltzius_tables$edges
  save(goltzius_edge_list, goltzius_node_list, file = "data/goltzius.RData")
}

if(file.exists("data/les_mis.RData")) {
  load("data/les_mis.RData")
} else {
  lm_edgelist <- read.csv("data/csv/les_mis_edges.csv", stringsAsFactors = FALSE)
  lm_graph <- graph.data.frame(lm_edgelist, directed = FALSE)
  lm_tables <- generate_graph_tables(lm_graph)
  lm_node_list <- lm_tables$nodes
  lm_edge_list <- lm_tables$edges
  save(lm_node_list, lm_edge_list, file = "data/les_mis.RData")
}


if(file.exists("data/karate.RData")) {
  load("data/karate.RData")
} else {
  karate_edgelist <- read.csv("data/csv/karate_edges.csv", stringsAsFactors = FALSE)
  karate_graph <- graph.data.frame(karate_edgelist, directed = FALSE)
  karate_tables <- generate_graph_tables(karate_graph)
  karate_node_list <- karate_tables$nodes
  karate_edge_list <- karate_tables$edges
  save(karate_node_list, karate_edge_list, file = "data/karate.RData")
}

if(file.exists("data/polbooks.RData")) {
  load("data/polbooks.RData")
} else {
  polbooks_edgelist <- read.csv("data/csv/polbooks_edges.csv", stringsAsFactors = FALSE)
  polbooks_nodelist <- read.csv("data/csv/polbooks_nodes.csv", stringsAsFactors = FALSE)
  polbooks_graph <- graph.data.frame(polbooks_edgelist, directed = FALSE, vertices = polbooks_nodelist)
  polbooks_tables <- generate_graph_tables(polbooks_graph)
  polbooks_node_list <- polbooks_tables$nodes
  polbooks_edge_list <- polbooks_tables$edges
  save(polbooks_node_list, polbooks_edge_list, file = "data/polbooks.RData")
}

if(file.exists("data/copperfield.RData")) {
  load("data/copperfield.RData")
} else {
  copperfield_edgelist <- read.csv("data/csv/copperfield_edges.csv", stringsAsFactors = FALSE)
  copperfield_nodelist <- read.csv("data/csv/copperfield_nodes.csv", stringsAsFactors = FALSE)
  copperfield_graph <- graph.data.frame(copperfield_edgelist, directed = FALSE, vertices = copperfield_nodelist)
  copperfield_tables <- generate_graph_tables(copperfield_graph)
  copperfield_node_list <- copperfield_tables$nodes
  copperfield_edge_list <- copperfield_tables$edges
  save(copperfield_node_list, copperfield_edge_list, file = "data/copperfield.RData")
}

if(file.exists("data/football.RData")) {
  load("data/football.RData")
} else {
  football_edgelist <- read.csv("data/csv/football_edges.csv", stringsAsFactors = FALSE)
  football_nodelist <- read.csv("data/csv/football_nodes.csv", stringsAsFactors = FALSE)
  football_graph <- graph.data.frame(football_edgelist, directed = FALSE, vertices = football_nodelist)
  football_tables <- generate_graph_tables(football_graph)
  football_node_list <- football_tables$nodes
  football_edge_list <- football_tables$edges
  save(football_node_list, football_edge_list, file = "data/football.RData")
}
