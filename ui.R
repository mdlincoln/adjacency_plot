library(shiny)
library(dplyr)

shinyUI(fluidPage(
  inputPanel(
    selectInput(
      "arr_var",
      "Arrange by",
      choices = c(
        "Alphabetical" = "alph",
        "Community" = "comm",
        "Degree" = "degree",
        "Closeness Centrality" = "closeness",
        "Betweenness Centrality" = "betweenness",
        "Eigenvector Centrality" = "eigen"
      ),
      selected = "alph"
    )
  ),
  mainPanel(
    plotOutput("adj_plot")
  )
))
