library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output, session) {

  node_list <- reactive({
    switch(
      input$graph_set,
      "goltzius" = goltzius_node_list,
      "les_mis" = lm_node_list,
      "karate" = karate_node_list,
      "polbooks" = polbooks_node_list,
      "copperfield" = copperfield_node_list
    )
  })

  edge_list <- reactive({
    switch(
      input$graph_set,
      "goltzius" = goltzius_edge_list,
      "les_mis" = lm_edge_list,
      "karate" = karate_edge_list,
      "polbooks" = polbooks_edge_list,
      "copperfield" = copperfield_edge_list
    )
  })

  output$attribution <- renderUI({
    switch(
      input$graph_set,
      "goltzius" = includeMarkdown("data/citations/goltzius.md"),
      "les_mis" = includeMarkdown("data/citations/les_mis.md"),
      "karate" = includeMarkdown("data/citations/karate.md"),
      "polbooks" = includeMarkdown("data/citations/polbooks.md"),
      "copperfield" = includeMarkdown("data/citations/copperfield.md")
      )
  })

  # Generate a selection menu for ordering choices
  output$ordering_choices <- renderUI({

    base <- c(
      "name",
      "community"
    )

    dataset_names <- names(node_list())
    var_choices <- dataset_names[grep("comm", dataset_names, invert = TRUE)] %>% union(base)

    return(selectInput(
      "arr_var",
      "Arrange by",
      choices = var_choices,
      selected = "name"
    ))
  })

  # Generate a selection menu for community detection choices
  output$comm_choices <- renderUI({

    dataset_names <- names(node_list())
    comm_choices <- dataset_names[grep("comm", dataset_names)]

    return(selectInput(
      "comm_var",
      "Community Algorithm",
      choices = comm_choices,
      selected = "walktrap_comm"
    ))
  })

  weighted <- reactive({
    return("weight" %in% names(edge_list()))
  })
  output$weighted <- reactive({weighted()})
  outputOptions(output, 'weighted', suspendWhenHidden = FALSE)

  # List non-calculated node attributes
  annotate_vars <- reactive({

    dataset_names <- names(node_list())

    base <- c(
      "name",
      "degree",
      "closeness",
      "betweenness",
      "eigen",
      "walktrap_comm",
      "edge_comm",
      "optimal_comm",
      "spinglass_comm",
      "fastgreedy_comm",
      "multilevel_comm"
      )

    return(setdiff(dataset_names, base))

  })

  annotatable <- reactive({
    return(input$arr_var %in% annotate_vars())
  })
  output$annotate_vars <- reactive({annotatable()})
  outputOptions(output, "annotate_vars", suspendWhenHidden = FALSE)

  # Returns a character vector of the vertices ordered based on given variables
  ordering <- reactive({
    if(input$arr_var == "community") {
      return((node_list() %>% arrange_(input$comm_var))$name)
    } else {
      return((node_list() %>% arrange_(input$arr_var))$name)
    }
  })

  # Determine a community for each edge. If two nodes belong to the
  # same community, label the edge with that community. If not,
  # the edge community value is 'NA'
  coloring <- reactive({
    colored_edges <- edge_list() %>%
      inner_join(node_list() %>% select_("name", "community" = input$comm_var), by = c("from" = "name")) %>%
      inner_join(node_list() %>% select_("name", "community" = input$comm_var), by = c("to" = "name")) %>%
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

    if(weighted() & input$alpha_weight) {
      p <- ggplot(plot_data(), aes(x = from, y = to, fill = group, alpha = weight))
    } else {
      p <- ggplot(plot_data(), aes(x = from, y = to, fill = group))
    }

    p <- p + geom_raster() +
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

    # Annotate the plot based on preexisting node attributes
    if(annotatable() & input$ann_var) {

      # Determine the "first" and "last" members of a node group
      ordered_anns <- node_list() %>%
        group_by_(input$arr_var) %>%
        summarize(min = first(name), max = last(name)) %>%
        filter(min != max)

      print(glimpse(ordered_anns))
      ann_groups <- ordered_anns[[input$arr_var]]

      # For each node grouping, add an annotation layer
      for(val in ann_groups[!is.na(ann_groups)]) {

        # Retrieve the min and max value for the given group value
        ann_min <- ordered_anns[ordered_anns[, input$arr_var] == val, ][["min"]]
        ann_max <- ordered_anns[ordered_anns[, input$arr_var] == val, ][["max"]]

        p <- p + annotate(
          "rect",
          xmin = ann_min,
          xmax = ann_max,
          ymin = ann_min,
          ymax = ann_max,
          alpha = .1) +
          annotate(
            "text",
            label = val,
            x = ann_min,
            y = ann_max,
            hjust = 0
          )
      }
    }

    return(p)
  })

  comm_membership <- reactive({
    membership_list <- node_list() %>%
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
})
