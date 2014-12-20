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
    includeMarkdown("description.md")
  ),
  mainPanel(plotOutput("adj_plot", height = "700px", width = "100%"))
))
