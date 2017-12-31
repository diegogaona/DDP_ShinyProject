# Including extra source code, libraries/functions
source("sourcecode.R")

# Setting UI 
shinyUI(
  fluidPage(
  # Header includes
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "toolkit.css"),
      tags$link(rel = "stylesheet", type = "text/css", href = "ui.css")
    ),
  
  # Title Panel
  titlePanel("Exploring Stackloss dataset creating a linear regression model"),
  h5("Developing Data Products Final Project, Diego Gaona, Dec 30 2017"),
  br(),
  
  # Dataset description
  includeMarkdown("intro.md"),
  hr(),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput('xcol', 'X Variable (Predictor)', cn, selected=cn[1]),
      selectInput('ycol', 'Y Variable (Response)', cn, selected=cn[4]),
      selectInput('ccol', 'Color Variable', cn, selected=cn[2]),
      # Help instructions
      includeMarkdown("help.md")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Plot",
                 plotOutput("plot",
                            click = "plot_click",
                            brush = brushOpts(id = "plot_brush")
                            ),
                 verbatimTextOutput("resume1"),
                 actionButton("exclude_toggle", "Toggle Points"),
                 actionButton("exclude_reset", "Reset")
        ),
        tabPanel("Selected",
                 verbatimTextOutput("table1")
        ),
        tabPanel("Summary",
                 verbatimTextOutput("resume2"),
                 verbatimTextOutput("summary1")
        )
      )
    )
  )
))
