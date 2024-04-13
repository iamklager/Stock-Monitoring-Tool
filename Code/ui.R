ui <- navbarPage(
  ## Design stuff
  theme = bs_theme(preset = "superhero"),
  title = "Stock Monitoring Tool",
  selected = "Portfolio Composition",
  fillable = TRUE,
  position = "static-top",
  windowTitle = "Stock Monitoring Tool",
  
  ## Portfolio composition
  nav_panel(
    title = "Portfolio Composition",
    value = "Portfolio Composition",
    card_body(
      div(
        style = "
          margin: 0;
          width: 50%;
          position: relative;
          left: 25%;
        ",
        # Portfolio composition
        DTOutput("out_PortComp"),
        br(),
        # Add and remove stocks
        DTOutput("out_AddRemStock"),
        layout_column_wrap(
          width = 1/2,
          div(
            style = "display: flex; justify-content: center; align-items: center;",
            actionButton(
              inputId = "in_AddStock",
              label = "Add", width = "50%"
            )
          ),
          div(
            style = "display: flex; justify-content: center; align-items: center;",
            actionButton(
              inputId = "in_RemoveStock",
              label = "Remove", width = "50%"
            )
          )
        ),
        br(),
        # Update portfolio button
        div(
          style = "display: flex; justify-content: center; align-items: center;",
          actionButton(
            inputId = "in_UpdatePortfolio",
            label = "Update", width = "50%"
          )
        )
      )
    )
  ),
  
  ## Price development
  nav_panel(
    title = "Price Development",
    card_body(
      layout_sidebar(
        sidebar = sidebar(
          open = "always",
          # Date range
          dateRangeInput(
            inputId = "in_DateRangePrice",
            label = "Time-Frame",
            start = Sys.Date(),
            end = Sys.Date(),
            format = 
          ),
          # Stock selection
          selectInput(
            inputId = "in_OHLCStock",
            label = "Stock",
            choices = ""
          )
        ),
        # Price development
        highchartOutput("out_hcPriceDev"),
        # OHLC
        highchartOutput("out_hcOHLC")
      )
    )
  ),
  
  ## Risk Contribution
  nav_panel(
    title = "Risk Contribution",
    card_body(
      layout_sidebar(
        sidebar = sidebar(
          open = "always",
          # Date range
          dateRangeInput(
            inputId = "in_DateRangeRisk",
            label = "Time-Frame",
            start = Sys.Date(),
            end = Sys.Date(),
            format = 
          ),
          # Correlation method
          selectInput(
            inputId = "in_CorrMethod",
            label = "Corrrelation Method",
            choices = c("pearson", "kendall", "spearman")
          ),
          # Risk free rate of return
          numericInput(
            inputId = "in_RFR",
            label = "Risk-Free Rate of Return",
            value = 0,
            step = 0.01
          ),
          # Annualuzed Sharpe ratio
          checkboxInput(
            inputId = "in_AnnualizeSR",
            label = "Annualize",
            value = FALSE
          )
        ),
        # Correlation and risk contribution
        layout_column_wrap(
          width = 1/2,
          highchartOutput(outputId = "out_hcCorrMat"),
          DTOutput(outputId = "out_RiskContr")
        )
      )
    )
  )
)