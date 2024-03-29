server <- function(input, output) {
  
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
  
  ## Outputs
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
}