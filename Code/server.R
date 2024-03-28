server <- function(input, output) {
  
  ## Reactive values
  l_RVals <- reactiveValues(
    df_Port = data.frame(
      "Stock" = c("GOOG", "AMZN", "MSFT", "TSLA"),
      "Weight" = rep(0.25, 4)
    )
  )
  
  ## Outputs
  # Portfolio composition
  output$out_PortComp <- renderDT({
    DT::datatable(
      data = l_RVals$df_Port, 
      editable = TRUE,
      options = list(dom = 't'), 
      rownames = FALSE
    )
  })
}