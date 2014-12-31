library(igraph)
library(dplyr)

# Read in CSV files with edge and node attributes
original_edgelist <- read.csv("goltzius_graph.csv", stringsAsFactors = FALSE)
original_nodelist <- read.csv("goltzius_nodes.csv", stringsAsFactors = FALSE)

# Create iGraph object
graph <- graph.data.frame(original_edgelist, directed = TRUE, vertices = original_nodelist)

# Calculate various network properties, adding them as attributes to each
# node/vertex
V(graph)$optimal_comm <- membership(optimal.community(graph))
V(graph)$walktrap_comm <- membership(walktrap.community(graph))
V(graph)$degree <- degree(graph)
V(graph)$closeness <- centralization.closeness(graph)$res
V(graph)$betweenness <- centralization.betweenness(graph)$res
V(graph)$eigen <- centralization.evcent(graph)$vector

# Re-generate dataframes for both nodes and edges, now containing
# calculated network attributes
node_list <- get.data.frame(graph, what = "vertices")
edge_list <- get.data.frame(graph, what = "edges")
