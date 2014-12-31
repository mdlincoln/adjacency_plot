library(shiny)
library(markdown)

fluidPage(
  titlePanel("Adjacency matrix visualization with R and ggplot2"),

  sidebarLayout(
  sidebarPanel(

    selectInput(
      "graph_set",
      "Dataset",
      choices = c(
        "Dutch Printmakers" = "goltzius",
        "Les Misérables" = "les_mis"
      ),
      selected = "goltzius"
    ),

    uiOutput("ordering_choices"),

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
    )
  ),

  mainPanel(
    plotOutput("adj_plot", height = "900px", width = "100%"),
    h2("Community membership"),
    htmlOutput("membership_list")
  )
))
