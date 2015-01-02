library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output, session) {

  datasets <- observe({
    node_list <- switch(
      input$graph_set,
      "goltzius" = goltzius_node_list,
      "les_mis" = lm_node_list,
      "karate" = karate_node_list

    )
    edge_list <- switch(
      input$graph_set,
      "goltzius" = goltzius_edge_list,
      "les_mis" = lm_edge_list,
      "karate" = karate_edge_list
    )

    output$ordering_choices <- renderUI({

      base <- c(
        "name",
        "community"
      )

      comm_vars <- c(
        "optimal_comm",
        "walktrap_comm",
        "spinglass_comm",
        "edge_comm"
      )

      dataset_names <- names(node_list)

      var_choices <- dataset_names %>% union(base) %>% setdiff(comm_vars)

      return(selectInput(
        "arr_var",
        "Arrange by",
        choices = var_choices,
        selected = "name"
      ))
    })

  # Returns a character vector of the vertices ordered based on given variables
  ordering <- reactive({
    if(input$arr_var == "community") {
      return((node_list %>% arrange_(input$comm_var))$name)
    } else {
      return((node_list %>% arrange_(input$arr_var))$name)
    }
  })

  # Determine a community for each edge. If two nodes belong to the
  # same community, label the edge with that community. If not,
  # the edge community value is 'NA'
  coloring <- reactive({
    colored_edges <- edge_list %>%
      inner_join(node_list %>% select_("name", "community" = input$comm_var), by = c("from" = "name")) %>%
      inner_join(node_list %>% select_("name", "community" = input$comm_var), by = c("to" = "name")) %>%
      mutate(group = ifelse(community.x == community.y, community.x, NA) %>% factor())
    return(colored_edges)
  })

  # Sort the edge list based on the given arrangement variable
  plot_data <- reactive({
    name_order <- ordering()
    sorted_data <- coloring() %>% mutate(
        to = factor(to, levels = name_order),
        from = factor(from, levels = name_order))
    return(sorted_data)
  })

  output$adj_plot <- renderPlot({
    ggplot(plot_data(), aes(x = from, y = to, fill = group)) +
      geom_raster() +
      theme_bw() +
      # Because we need the x and y axis to display every node,
      # not just the nodes that have connections to each other,
      # make sure that ggplot does not drop unused factor levels
      scale_x_discrete(drop = FALSE) +
      scale_y_discrete(drop = FALSE) +
      theme(
        # Rotate the x-axis lables so they are legible
        axis.text.x = element_text(angle = 270, hjust = 0, size = 12),
        axis.text.y = element_text(size = 12),
        # Force the plot into a square aspect ratio
        aspect.ratio = 1,
        # Hide the legend (optional)
        legend.position = "bottom")
  })

  comm_membership <- reactive({
    membership_list <- node_list %>%
      select_("name", "community" = input$comm_var)
    return(membership_list)
  })

  # Render an HTML list of community memberships beneath the display
  output$membership_list <- renderUI({
    # Get a table of community memberships based on the selected community
    # detection method
    members <- comm_membership()
    comms <- unique(members$community)

    # Create and populate a list of HTML elements
    member_html <- list()
    for(i in comms) {
      group_membs <- members$name[members$community == i]
      member_html[[i]] <- list(column(3,wellPanel(h3("Group", i), p(group_membs))))
    }
    return(member_html)
  })
})})
