library(shiny)
library(markdown)
library(shinydashboard)

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
  sidebarMenu(menuItem("Source Code", href = "https://github.com/mdlincoln/adjacency_plot", icon = icon("code")))
)

body <- dashboardBody(
  tabItems(
    tabItem("plot", plot, icon = icon("bar-chart-0")),
    tabItem("communities", membership, icon = icon("users")),
    tabItem("about", description, icon = icon("list"))
  ))

# Render and display
dashboardPage(header, sidebar, body, title = title)
