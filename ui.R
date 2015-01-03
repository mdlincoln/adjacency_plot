library(shiny)
library(markdown)

fluidPage(
  titlePanel("Adjacency matrix visualization with R and ggplot2"),

  inputPanel(
    selectInput(
      "graph_set",
      "Dataset",
      choices = c(
        "Dutch Printmakers" = "goltzius",
        "Les Misérables" = "les_mis",
        "Karate Club" = "karate",
        "Political Books" = "polbooks"
      ),
      selected = "goltzius"
    ),

    uiOutput("ordering_choices"),

    uiOutput("comm_choices"),

    conditionalPanel(
      condition = "output.weighted",
      checkboxInput("alpha_weight", "Set alpha by edge weight", FALSE)
      )
  ),

  fluidRow(
    column(4, includeMarkdown("description.md")),
    column(8, plotOutput("adj_plot", height = "900px", width = "100%"))
  ),

  h2("Community membership"),
  htmlOutput("membership_list")
)
