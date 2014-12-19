library(shiny)
library(dplyr)
library(ggplot2)
library(lazyeval)

shinyServer(function(input, output, session) {

  plot_data <- reactive({
    switch(
      input$arr_var,
      "alph" = return(adj_data),
      "comm" = return(adj_data %>% mutate(from = reorder(from, comm.x), to = reorder(to, comm.y))),
      "degree" = return(adj_data %>% mutate(from = reorder(from, degree.x), to = reorder(to, degree.y))),
      "closeness" = return(adj_data %>% mutate(from = reorder(from, closeness.x), to = reorder(to, closeness.y))),
      "betweenness" = return(adj_data %>% mutate(from = reorder(from, betweenness.x), to = reorder(to, betweenness.y))),
      "eigen" = return(adj_data %>% mutate(from = reorder(from, eigen.x), to = reorder(to, eigen.y)))
    )
  })

  output$adj_plot <- renderPlot({
    ggplot(plot_data(), aes_string(x = "from", y = "to", fill = "group")) +
      geom_raster() +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 270, hjust = 0), legend.position = "none", aspect.ratio = 1)
  })
})
