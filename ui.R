library(shiny)
library(markdown)

fluidPage(
  titlePanel("Adjacency matrix visualization with R and ggplot2"),

  wellPanel(includeMarkdown("description.md")),

  inputPanel(
    selectInput(
      "graph_set",
      "Dataset",
      choices = c(
        "Dutch Printmakers" = "goltzius",
        "Les Misérables" = "les_mis",
        "Karate Club" = "karate",
        "Political Books" = "polbooks",
        "'Copperfield' Noun/Adjective" = "copperfield"
      ),
      selected = "goltzius"
    ),

    uiOutput("ordering_choices"),

    uiOutput("comm_choices"),

    conditionalPanel(
      condition = "output.weighted",
      checkboxInput("alpha_weight", "Set alpha by edge weight", FALSE)
    ),

    wellPanel(
      h4("About the dataset"),
      uiOutput("attribution")
    )
  ),

  plotOutput("adj_plot", height = "1300px", width = "100%"),

  h2("Community membership"),
  htmlOutput("membership_list")
)
