library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output, session) {

  datasets <- observe({
    node_list <- switch(
      input$graph_set,
      "goltzius" = goltzius_node_list,
      "les_mis" = lm_node_list)

    edge_list <- switch(
      input$graph_set,
      "goltzius" = goltzius_edge_list,
      "les_mis" = lm_edge_list
    )

    output$ordering_choices <- renderUI({

      base <- c(
        "Alphabetical" = "alph",
        "Community" = "comm",
        "Degree" = "degree",
        "Closeness Centrality" = "closeness",
        "Betweenness Centrality" = "betweenness",
        "Eigenvector Centrality" = "eigen"
      )

      if(input$graph_set == "goltzius") {
        var_choices <- c(base, c("Artist birthdate" = "birth"))
      } else {
        var_choices <- base
      }

      return(selectInput(
        "arr_var",
        "Arrange by",
        choices = var_choices,
        selected = "alph"
      ))
    })

  # Returns a character vector of the vertices ordered based on given variables
  ordering <- reactive({
    if(input$arr_var == "alph") {
      return((node_list %>% arrange(name))$name)
    } else if(input$arr_var == "comm") {
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
      inner_join(node_list %>% select_("name", "comm" = input$comm_var), by = c("from" = "name")) %>%
      inner_join(node_list %>% select_("name", "comm" = input$comm_var), by = c("to" = "name")) %>%
      mutate(group = ifelse(comm.x == comm.y, comm.x, NA) %>% factor())
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
      select_("name", "comm" = input$comm_var)
    return(membership_list)
  })

  # Render an HTML list of community memberships beneath the display
  output$membership_list <- renderUI({
    # Get a table of community memberships based on the selected community
    # detection method
    members <- comm_membership()
    comms <- unique(members$comm)

    # Create and populate a list of HTML elements
    member_html <- list()
    for(i in comms) {
      group_membs <- members$name[members$comm == i]
      member_html[[i]] <- list(h3("Group", i))
      for(a in group_membs) {
        member_html[[i]][[a]] <- list(p(a))
      }
    }
    return(member_html)
  })
})})
