library(shiny)
library(dplyr)
library(ggplot2)
library(lazyeval)

shinyServer(function(input, output, session) {

  # Returns a character vector of the vertices ordered based on given variables
  ordering <- reactive({
    if(input$arr_var == "alph") {
      return((node_list %>% arrange(name))$name)
    } else {
      return((node_list %>% arrange_(input$arr_var))$name)
    }
  })

  # Sort the edge list based on the given arrangement variable
  plot_data <- reactive({

    name_order <- ordering()

    sorted_data <- edge_list %>%
      mutate(
        to = factor(to, levels = name_order),
        from = factor(from, levels = name_order)
      )

    return(sorted_data)
  })

  output$adj_plot <- renderPlot({
    ggplot(plot_data(), aes(x = from, y = to, fill = group)) +
      geom_raster() +
      theme_bw() +
      scale_x_discrete(drop = FALSE) +
      scale_y_discrete(drop = FALSE) +
      theme(axis.text.x = element_text(angle = 270, hjust = 0), legend.position = "none", aspect.ratio = 1)
  })
})
