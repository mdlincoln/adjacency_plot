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
  # If a graph is undirected, it is necessary to "double" the edges, such that
  # A -> B has the complement B -> A. This will keep the adjacency plot
  # fully populated
    edge_list <- rbind(edge_list, edge_list %>% rename(from = to, to = from))
    return(list(nodes = node_list, edges = edge_list))
  }
}

# Load csv's from file
load_export <- function(edge_filename, node_filename = NULL, directed = TRUE) {
  edgelist <- read.csv(edge_filename, stringsAsFactors = FALSE)
  if(!(is.null(node_filename))) {
    nodelist <- read.csv(node_filename, stringsAsFactors = FALSE)
    graph <- graph.data.frame(edgelist, directed = directed, vertices = nodelist)
  } else {
    graph <- graph.data.frame(edgelist, directed = directed)
  }
  tables <- generate_graph_tables(graph)
  return(tables)
}

if(file.exists("data/goltzius.RData")) {
  load("data/goltzius.RData")
} else {
  graph <- load_export("data/csv/goltzius_edges.csv", "data/csv/goltzius_nodes.csv", directed = TRUE)
  goltzius_node_list <- graph$nodes
  goltzius_edge_list <- graph$edges
  save(goltzius_edge_list, goltzius_node_list, file = "data/goltzius.RData")
}

if(file.exists("data/les_mis.RData")) {
  load("data/les_mis.RData")
} else {
  graph <- load_export("data/csv/les_mis_edges.csv", directed = FALSE)
  lm_node_list <- graph$nodes
  lm_edge_list <- graph$edges
  save(lm_node_list, lm_edge_list, file = "data/les_mis.RData")
}


if(file.exists("data/karate.RData")) {
  load("data/karate.RData")
} else {
  graph <- load_export("data/csv/karate_edges.csv", directed = FALSE)
  karate_node_list <- graph$nodes
  karate_edge_list <- graph$edges
  save(karate_node_list, karate_edge_list, file = "data/karate.RData")
}

if(file.exists("data/polbooks.RData")) {
  load("data/polbooks.RData")
} else {
  graph <- load_export("data/csv/polbooks_edges.csv", "data/csv/polbooks_nodes.csv", directed = FALSE)
  polbooks_node_list <- graph$nodes
  polbooks_edge_list <- graph$edges
  save(polbooks_node_list, polbooks_edge_list, file = "data/polbooks.RData")
}

if(file.exists("data/copperfield.RData")) {
  load("data/copperfield.RData")
} else {
  graph <- load_export("data/csv/copperfield_edges.csv", "data/csv/copperfield_nodes.csv", directed = FALSE)
  copperfield_node_list <- graph$nodes
  copperfield_edge_list <- graph$edges
  save(copperfield_node_list, copperfield_edge_list, file = "data/copperfield.RData")
}

if(file.exists("data/football.RData")) {
  load("data/football.RData")
} else {
  graph <- load_export("data/csv/football_edges.csv", "data/csv/football_nodes.csv", directed = FALSE)
  football_node_list <- graph$nodes
  football_edge_list <- graph$edges
  save(football_node_list, football_edge_list, file = "data/football.RData")
}
