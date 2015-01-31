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
    menuItem("Plot", tabName = "plot", icon = icon("bar-chart")),
    menuItem("Communities", tabName = "communities", icon = icon("users")),
    menuItem("About", tabName = "about", icon = icon("info-circle"))
  ),
  dataset_sel,
  citation,
  community,
  sidebarMenu(menuItem("Source Code", href = "https://github.com/mdlincoln/adjacency_plot", icon = icon("code")))
)

body <- dashboardBody(
  tabItems(
    tabItem(
      "plot",
      box(title = "Plot Properties", solidHeader = TRUE, status = "info", width = 12, fluidRow(column(4, ordering), column(4, annotate), column(4, alpha)), collapsible = TRUE),
      box(width = 12, plot)),
    tabItem("communities", membership),
    tabItem("about", description)
  ))

# Render and display
dashboardPage(header, sidebar, body, title = title)
