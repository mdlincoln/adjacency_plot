### Created by [Matthew Lincoln](http://matthewlincoln.net)

While the circle-and-line idiom used by many network visualization tools such as [Gephi] can be useful for investigating the structure of small- and medium-scale networks, large-scale network visualizations tend to turn the worst kinds of [spaghetti plots][spaghetti].
The abundance of crossing links creates a confusing visual pattern that masks the topological structure of the network.

One good alternative is to visualize an [adjacency matrix][matrix] encoding the network relationship, with the nodes of the network listed on either axis, and each cell *AB* describing an edge connecting node *A* and node *B*.

Here, the cells of the matrix are colored based on their nodes' community membership - those that share a community are colored, while those that connect across two different communities are gray.

Ordering the axes of the matrix by different node attributes can help to clarify structural properties of the network in a way less legible in a traditional web visualization.

### Read more

[A blog post on the creation and interpretation of these plots.](http://matthewlincoln.net/2014/12/20/adjacency-matrix-plots-with-r-and-ggplot2.html)

[Mike Bostock's d3 implementation of adjacency plots.](http://bost.ocks.org/mike/miserables/)

[Gephi]: http://gephi.org

[spaghetti]: http://en.wikipedia.org/wiki/Spaghetti_plot

[matrix]: http://en.wikipedia.org/wiki/Adjacency_matrix
