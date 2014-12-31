library(shiny)
library(markdown)

fluidPage(
  titlePanel("Adjacency matrix visualization with R and ggplot2"),

  sidebarLayout(
  sidebarPanel(
    selectInput(
      "arr_var",
      "Arrange by",
      choices = c(
        "Alphabetical" = "alph",
        "Community" = "comm",
        "Degree" = "degree",
        "Closeness Centrality" = "closeness",
        "Betweenness Centrality" = "betweenness",
        "Eigenvector Centrality" = "eigen",
        "Artist birthdate" = "birth"
      ),
      selected = "alph"
    ),
    selectInput(
      "comm_var",
      "Community Algorithm",
      choices = c(
        "Optimal Community" = "optimal_comm",
        "Walktrap Community" = "walktrap_comm",
        "Spinglass Community" = "spinglass_comm",
        "Edge Betweenness Community" = "edge_comm"
        ),
      selected = "optimal_com"
    ),
    includeMarkdown("description.md")
  ),
  mainPanel(
    plotOutput("adj_plot", height = "700px", width = "100%"),
    h2("Community membership"),
    htmlOutput("membership_list")
  )
))
