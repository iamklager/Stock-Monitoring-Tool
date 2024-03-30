server <- function(input, output, session) {
  
  ## Reactive values
  l_RVals <- reactiveValues(
    df_PortComp = data.frame(
      "Stock" = c("GOOG", "AMZN", "MSFT", "TSLA"),
      "Weight" = rep(0.25, 4)
    ),
    df_AddRemStock = data.frame(
      "Stock" = c("JNJ"),
      "Weight" = rep(0.1)
    )
  )
  
  ## Inputs
  # Add/remove stock
  output$out_AddRemStock <- renderDT({
    DT::datatable(
      data = l_RVals$df_AddRemStock, 
      editable = TRUE,
      options = list(
        dom = 't', 
        ordering = FALSE,
        autoWidth = TRUE,
        columnDefs = list(
          list(width = "50%", targets = "_all"),
          list(className = "dt-right", targets = 1)
        )
      ), 
      rownames = FALSE,
      colnames = rep("", 2)
    )
  })
  
  # Portfolio composition
  output$out_PortComp <- renderDT({
    DT::datatable(
      data = l_RVals$df_PortComp, 
      editable = TRUE,
      options = list(
        dom = 't',
        autoWidth = TRUE,
        columnDefs = list(
          list(width = "50%", targets = "_all"),
          list(className = "dt-right", targets = 1)
        )
      ), 
      rownames = FALSE
    )
  })
  
  ## Event handling
  # Changing add/remove input
  observeEvent(
    eventExpr = input$out_AddRemStock_cell_edit,
    handlerExpr = {
      info <- input$out_AddRemStock_cell_edit
      r <-  as.numeric(info$row)
      c <- as.numeric(info$col) + 1
      k <- ifelse(c == 2, as.numeric(info$value), as.character(info$value))
      l_RVals$df_AddRemStock[r, c] <- k
    }
  )
  # Changing portfolio composition
  observeEvent(
    eventExpr = input$out_PortComp_cell_edit,
    handlerExpr = {
      info <- input$out_PortComp_cell_edit
      r <-  as.numeric(info$row)
      c <- as.numeric(info$col) + 1
      k <- ifelse(c == 2, as.numeric(info$value), as.character(info$value))
      l_RVals$df_PortComp[r, c] <- k
    }
  )
  # Add stock to portfolio
  observeEvent(
    eventExpr = input$in_AddStock,
    handlerExpr = {
      l_RVals$df_PortComp <- rbind(
        l_RVals$df_PortComp,
        l_RVals$df_AddRemStock[base::trimws(l_RVals$df_AddRemStock$Stock) != ""]
      )
      l_RVals$df_AddRemStock[1, ] <- c("", 0)
    }
  )
  # Remove stock from portfolio
  observeEvent(
    eventExpr = input$in_RemoveStock,
    handlerExpr = {
      l_RVals$df_PortComp <- l_RVals$df_PortComp[l_RVals$df_PortComp$Stock != l_RVals$df_AddRemStock[1, 1], ]
      l_RVals$df_AddRemStock[1, ] <- c("", 0)
    }
  )
  # Update portfolio
  observeEvent(
    eventExpr = input$in_UpdatePortfolio,
    handlerExpr = {
      # OHLC stock input
      updateSelectInput(
        session = session,
        inputId = "in_OHLCStock",
        choices = unique(l_RVals$df_PortComp$Stock)
      )
      l_RVals$Stocks <- f_QueryStocks(l_RVals$df_PortComp$Stock)
      l_RVals$Dates <- as.Date(unique(unlist(lapply(l_RVals$Stocks, rownames))))
    }
  )
  
  ## Outputs
  output$out_hcOHLC <- renderHighchart({
    req(input$in_UpdatePortfolio)
    f_hcOHLC(l_RVals$Stocks, input$in_OHLCStock)
  })
  output$out_hcCorrMat <- renderHighchart({
    req(input$in_UpdatePortfolio)
    f_hcCorrMat(stock = l_RVals$Stocks, method = input$in_CorrMethod)
  })
  output$out_hcCumRet <- renderHighchart({
    req(input$in_UpdatePortfolio)
    f_hcCumRet(l_RVals$Stocks)
  })
  output$out_RiskContr <- renderDT({
    req(input$in_UpdatePortfolio)
    DT::datatable(
      data = f_RiskComp(l_RVals$Stocks, l_RVals$df_PortComp),
      editable = FALSE,
      options = list(
        dom = 't', 
        ordering = TRUE,
        autoWidth = TRUE,
        columnDefs = list(
          list(className = "dt-right", targets = 1:5)
        )
      ), 
      rownames = FALSE
    )
  })
}

