# Including extra source code, libraries/functions
source("sourcecode.R")

# Setting server logic
shinyServer(function(input, output, session) {
  
  # For storing which rows have been excluded
  vals <- reactiveValues(
    keeprows = rep(TRUE, nrow(dataset))
  )

  # Combine selected variables into a new dataframe
  sData <- reactive({
    dataset[, c(input$xcol, input$ycol, input$ccol)]
  })
  
  # Set Axis info from selected variable names
  cData <- reactive({list(x = input$xcol, y = input$ycol, c = input$ccol)})
  
  output$plot <- renderPlot({
    # Plot the kept and excluded points as two separate data sets
    keep    <- sData()[ vals$keeprows, , drop = FALSE]
    exclude <- sData()[!vals$keeprows, , drop = FALSE]
    
    # draw the scatterplot
    ggplot(keep) + aes_string(x = cData()$x, y = cData()$y, color = cData()$c) + geom_point() +
        xlab(cnDesc[cData()$x][[1]]) + ylab(cnDesc[cData()$y][[1]]) +
      geom_smooth(method = lm, fullrange = TRUE, color = "black") +
      geom_point(data = exclude, shape = 21, fill = NA, color = "black", alpha = 0.25)
  })
  
  # Toggle points that are clicked
  observeEvent(input$plot_click, {
    res <- nearPoints(stackloss, input$plot_click, allRows = TRUE)
    
    vals$keeprows <- xor(vals$keeprows, res$selected_)
  })
  
  # Toggle points that are brushed, when button is clicked
  observeEvent(input$exclude_toggle, {
    res <- brushedPoints(stackloss, input$plot_brush, allRows = TRUE)
    
    vals$keeprows <- xor(vals$keeprows, res$selected_)
  })
  
  # Reset points
  observeEvent(input$exclude_reset, {
    vals$keeprows <- rep(TRUE, nrow(stackloss))
  })
  
  # Plot info
  output$resume1 <- renderText({
    keep <- sData()[ vals$keeprows, c(cData()$y, cData()$x), drop = FALSE]
    cf <- lm(data = keep)$coefficients
    paste("Points:", nrow(keep), "\r\n",
          "Model: (Intercept):", signif(cf[[1]], 4), "  ", cData()$y,":", signif(cf[[2]], 4))
  })
  
  # Selected Points
  output$table1 <- renderPrint({
    keep <- sData()[ vals$keeprows, , drop = FALSE]
    keep
  })
  
  # Model Info
  output$resume2 <- renderText({
    paste("Predictor:", cData()$x, "\t", cnDesc[cData()$x][[1]], "\r\n",
          "Response:", cData()$y, "\t", cnDesc[cData()$y][[1]])
  })
  
  # Model Summary
  output$summary1 <- renderPrint({
    keep <- sData()[ vals$keeprows, c(cData()$y, cData()$x), drop = FALSE]
    m <- lm(data = keep)
    summary(m)
  })
  
})
