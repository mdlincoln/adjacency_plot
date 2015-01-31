library(shiny)
library(markdown)
library(shinydashboard)

github_ribbon <- HTML('<a href="https://github.com/mdlincoln/adjacency_plot"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://camo.githubusercontent.com/652c5b9acfaddf3a9c326fa6bde407b87f7be0f4/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f6f72616e67655f6666373630302e706e67" alt="Fork me on GitHub" data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_orange_ff7600.png"></a>')

title <- "Adjacency matrices"

description <- includeMarkdown("description.md")

dataset_sel <- selectInput(
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
)

citation <-uiOutput("attribution")

ordering <- uiOutput("ordering_choices")

community <- uiOutput("comm_choices")

alpha <- conditionalPanel(
  condition = "output.weighted",
  checkboxInput("alpha_weight", "Set alpha by edge weight", FALSE)
)

annotate <- conditionalPanel(
  condition = "output.annotate_vars",
  checkboxInput("ann_var", "Annotate plot by node attribute sorting", FALSE)
)

plot <- plotOutput("adj_plot", height = "1300px", width = "100%")

membership <- uiOutput("membership_list")

# Layout every page section

header <- dashboardHeader(title = title)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("About", tabName = "about"),
    menuItem("Plot", tabName = "plot"),
    menuItem("Communities", tabName = "communities")
  ),
  dataset_sel, citation, ordering, community, alpha, annotate
)

body <- dashboardBody(
  tabItems(
    tabItem("plot", plot, icon = icon("bar-chart-0")),
    tabItem("communities", membership, icon = icon("users")),
    tabItem("about", description, icon = icon("list"))
  ))

# Render and display
dashboardPage(header, sidebar, body, title = title)
