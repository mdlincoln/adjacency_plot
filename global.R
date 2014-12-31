library(igraph)
library(dplyr)

# Read in CSV files with edge and node attributes
goltzius_edgelist <- read.csv("goltzius_graph.csv", stringsAsFactors = FALSE)
goltzius_nodelist <- read.csv("goltzius_nodes.csv", stringsAsFactors = FALSE)

# Create iGraph object
goltzius_graph <- graph.data.frame(goltzius_edgelist, directed = TRUE, vertices = goltzius_nodelist)

# Calculate various network properties, adding them as attributes to each
# node/vertex
V(goltzius_graph)$optimal_comm <- membership(optimal.community(goltzius_graph))
V(goltzius_graph)$walktrap_comm <- membership(walktrap.community(goltzius_graph))
V(goltzius_graph)$spinglass_comm <- membership(spinglass.community(goltzius_graph))
V(goltzius_graph)$edge_comm <- membership(edge.betweenness.community(goltzius_graph))
V(goltzius_graph)$degree <- degree(goltzius_graph)
V(goltzius_graph)$closeness <- centralization.closeness(goltzius_graph)$res
V(goltzius_graph)$betweenness <- centralization.betweenness(goltzius_graph)$res
V(goltzius_graph)$eigen <- centralization.evcent(goltzius_graph)$vector

# Re-generate dataframes for both nodes and edges, now containing
# calculated network attributes
goltzius_node_list <- get.data.frame(goltzius_graph, what = "vertices")
goltzius_edge_list <- get.data.frame(goltzius_graph, what = "edges")




lm_edgelist <- read.csv("les_mis_graph.csv", stringsAsFactors = FALSE)

# Create iGraph object
lm_graph <- graph.data.frame(lm_edgelist, directed = FALSE)

# Calculate various network properties, adding them as attributes to each
# node/vertex
V(lm_graph)$optimal_comm <- membership(optimal.community(lm_graph))
V(lm_graph)$walktrap_comm <- membership(walktrap.community(lm_graph))
V(lm_graph)$spinglass_comm <- membership(spinglass.community(lm_graph))
V(lm_graph)$edge_comm <- membership(edge.betweenness.community(lm_graph))
V(lm_graph)$degree <- degree(lm_graph)
V(lm_graph)$closeness <- centralization.closeness(lm_graph)$res
V(lm_graph)$betweenness <- centralization.betweenness(lm_graph)$res
V(lm_graph)$eigen <- centralization.evcent(lm_graph)$vector

# Re-generate dataframes for both nodes and edges, now containing
# calculated network attributes
lm_node_list <- get.data.frame(lm_graph, what = "vertices")
lm_edge_list <- get.data.frame(lm_graph, what = "edges")
# "mirror" the undirected edge list
lm_edge_list <- rbind(lm_edge_list, lm_edge_list %>% select(from = to, to = from, weight))
