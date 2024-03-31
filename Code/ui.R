ui <- page_sidebar(
  ## Theme
  theme = bs_theme(preset = "superhero"),
  
  ## Title
  title = "Stock Monitoring Tool",
  
  ## Sidebar
  sidebar = sidebar(
    # Options
    open = "always",
    
    # Portfolio composition
    DTOutput("out_PortComp"),
    
    # Add and remove stocks
    DTOutput("out_AddRemStock"),
    div(
      style = "display: inline-block;horizontal-align:top;",
      actionButton(
        inputId = "in_AddStock",
        label = "Add",
        width = '49%'
      ),
      actionButton(
        inputId = "in_RemoveStock",
        label = "Remove",
        width = '49%'
      )
    ),
    
    # Update portfolio button
    actionButton(
      inputId = "in_UpdatePortfolio",
      label = "Update"
    ),
    # Date range
    dateRangeInput(
      inputId = "in_DateRange",
      label = "Time-Frame",
      start = Sys.Date(),
      end = Sys.Date(),
      format = 
    ),
    tags$style("#in_CorrMethod {background-color:blue;}"),
    selectInput(
      inputId = "in_CorrMethod",
      label = "Corrrelation Method",
      choices = c("pearson", "kendall", "spearman")
    ),
    selectInput(
      inputId = "in_OHLCStock",
      label = "OHLC",
      choices = ""
    )
  ),
  
  ## Single stock chart
  fluidRow(
    title = "Price Development",
    highchartOutput("out_hcPriceDev")
  ),
  fluidRow(
    title = "Correlation and Risk Contribution",
    column(
      width = 6,
      highchartOutput(outputId = "out_hcCorrMat")
    ),
    column(
      width = 6,
      DTOutput(outputId = "out_RiskContr")
    )
  ),
  fluidRow(
    title = "OHLC",
    highchartOutput("out_hcOHLC")
  )
  
)