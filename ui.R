library(shiny)
library(markdown)

fluidPage(

  HTML('<a href="https://github.com/mdlincoln/adjacency_plot"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://camo.githubusercontent.com/652c5b9acfaddf3a9c326fa6bde407b87f7be0f4/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f6f72616e67655f6666373630302e706e67" alt="Fork me on GitHub" data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_orange_ff7600.png"></a>'),

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
        "'Copperfield' Noun/Adjective" = "copperfield",
        "American College Football" = "football"
      ),
      selected = "goltzius"
    ),

    uiOutput("ordering_choices"),

    uiOutput("comm_choices"),

    conditionalPanel(
      condition = "output.weighted",
      checkboxInput("alpha_weight", "Set alpha by edge weight", FALSE)
    ),

    conditionalPanel(
      condition = "output.annotate_vars",
      checkboxInput("ann_var", "Annotate plot by node attribute sorting", FALSE)
    ),

    tags$cite(
      h4("About the dataset"),
      uiOutput("attribution")
    )
  ),

  plotOutput("adj_plot", height = "1300px", width = "100%"),

  h2("Community membership"),
  htmlOutput("membership_list")
)
