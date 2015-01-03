**Created by [Matthew Lincoln](http://matthewlincoln.net)**

### About

While the circle-and-line idiom used by many network visualization tools such as [Gephi] can be useful for investigating the structure of sparsely connected networks. However, highly-interconnected network visualizations tend to turn the worst kinds of [spaghetti plots][spaghetti].
The abundance of crossing links creates a confusing visual pattern that masks the topological structure of the network.

One good alternative is to visualize an [adjacency matrix][matrix] encoding the network relationship, with the nodes of the network listed on either axis, and each cell *AB* describing an edge connecting node *A* and node *B*.

### Reading an adjacency matrix

Cells of the adjacency matrix represent edges, their source and target nodes arranged along the x and y axes.
Here, the cells are colored based on their nodes' community membership - those that share a community are colored, while those that connect across two different communities are gray.
Some of the datasets have weigted edges - you may optionally set the alpha level of the plot to correspond to these weights.

Ordering the axes of the matrix by different node attributes can help to clarify structural properties of the network in a way less legible in a traditional web visualization.
You may arrange the axes by calculated attributes, such as closeness or betweenness centrality.
Some networks have preexisting node attributes (for example, `political leaning` in the political books dataset).
When arranging the plot by these preexisting attributes, you may add an overlay displaying these attributes, as a way to compare how a given attribute corresponds to structural communities.

### Read more

[A blog post on the creation and interpretation of these plots.](http://matthewlincoln.net/2014/12/20/adjacency-matrix-plots-with-r-and-ggplot2.html)

Fekete, J., "Visualizing networks using adjacency matrices: Progresses and challenges," *11th IEEE International Conference on Computer-Aided Design and Computer Graphics, 2009*, (19-21 August 2009), 636, 638. doi: [10.1109/CADCG.2009.5246813](http://dx.doi.org.proxy-um.researchport.umd.edu/10.1109/CADCG.2009.5246813)

[Mike Bostock's d3 implementation of adjacency plots.](http://bost.ocks.org/mike/miserables/)

[Gephi]: http://gephi.org

[spaghetti]: http://en.wikipedia.org/wiki/Spaghetti_plot

[matrix]: http://en.wikipedia.org/wiki/Adjacency_matrix
