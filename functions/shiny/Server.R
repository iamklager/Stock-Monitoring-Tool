#### Server
# The server function.


Server <- function(input, output, session) {
  
  ## Change this and use modules instead
  db_conn <- DBConnection()
  
  
  ## Reactive values
  # Portfolio composition
  portfolio <- shiny::reactiveVal(GetPortfolio(db_conn))
  add_rem_stock <- shiny::reactiveVal(TempTicker())
  # Helper
  prices <- shiny::reactiveVal(NULL)
  returns <- shiny::reactiveVal(NULL)
  # Price development
  price_dev <- shiny::reactiveVal(NULL)
  ohlc <- shiny::reactiveVal(NULL)
  # Risk management
  merged_returns <- shiny::reactiveVal(NULL)
  vc <- shiny::reactiveVal(NULL)
  corr_mat <- shiny::reactiveVal(NULL)
  sr <- shiny::reactiveVal(NULL)
  sd_dec <- shiny::reactiveVal(NULL)
  enb <- shiny::reactiveVal(NULL)
  risk_stats <- shiny::reactiveVal(NULL)
  
  
  ## Adding removing a stock
  # Cell update
  shiny::observeEvent(
    eventExpr = input$out_AddRemStock_cell_edit,
    handlerExpr = {
      info <- input$out_AddRemStock_cell_edit
      r <-  as.numeric(info$row)
      c <- as.numeric(info$col) + 1
      foo <- add_rem_stock()
      if (c == 1) {
        foo[r, c] <- as.character(info$value)
      } else if (c == 2) {
        foo[r, c] <- as.character(info$value)
      } else if (c == 3) {
        foo[r, c] <- as.numeric(info$value)
      }
      add_rem_stock(foo)
    }
  )
  # Adding a stock
  shiny::observeEvent(input$AddStock, {
    foo <- portfolio()
    bar <- add_rem_stock()
    foobar  <- rbind(
      portfolio(),
      bar[base::trimws(bar) != ""]
    )
    portfolio(foobar)
    add_rem_stock(TempTicker())
    shiny::showNotification("Added stock", type = "message")
  })
  # Removing a stock
  shiny::observeEvent(input$RemoveStock, {
    foo <- portfolio()
    bar <- add_rem_stock()
    portfolio(foo[foo$Ticker != bar[1, 1], ])
    add_rem_stock(TempTicker())
    shiny::showNotification("Removed stock", type = "message")
  })
  
  
  ## Updating the portfolio
  # Cell update
  shiny::observeEvent(
    eventExpr = input$out_PortComp_cell_edit,
    handlerExpr = {
      info <- input$out_PortComp_cell_edit
      r <-  as.numeric(info$row)
      c <- as.numeric(info$col) + 1
      foo <- portfolio()
      if (c == 1) {
        foo[r, c] <- as.characater(info$value)
      } else if (c == 2) {
        foo[r, c] <- as.characater(info$value)
        portfolio(foo)
      } else if (c == 3) {
        foo[r, c] <- as.numeric(info$value)
      }
      portfolio(foo)
    }
  )
  # Final update
  shiny::observeEvent(input$UpdatePortfolio, {
    # Portfolio composition
    UpdatePortfolio(db_conn, portfolio())
    portfolio(GetPortfolio(db_conn))
    
    # Price/return data
    prices(GetPrices(
      db_conn,
      portfolio(),
      input$DateRangePrice
    ))
    returns(GetReturns(prices()))

    # Price Development
    if (nrow(portfolio()) == 0) {
      shiny::showNotification("Updated portfolio. Portfolio is empty.", type = "message")
      return(NULL)
    }
    shiny::updateSelectizeInput(
      inputId = "StockOHLC",
      choices = sort(portfolio()$Ticker),
      selected = sort(portfolio()$Ticker)[1]
    )
    price_dev(GetPriceDev(prices()))
    ohlc(GetOHLC(db_conn, portfolio()))

    # Risk Management
    if (nrow(portfolio()) < 2) {
      shiny::showNotification("Updated portfolio. Not enough assets to compute risk statistics.", type = "message")
      return(NULL)
    }
    merged_returns(GetMergedReturns(returns()))
    vc(cov(merged_returns()[, -1]))
    corr_mat(GetCorrMat(merged_returns(), method = input$CorrelationMethod))
    sr(GetSharpeRatios(portfolio(), merged_returns(), input$RiskFreeRate, input$AnnualizeSharpeRatio))
    sd_dec(SDDecomp(portfolio(), merged_returns(), vc()))
    enb(GetENB(portfolio(), vc()))
    risk_stats(GetPortfolioRiskStats(portfolio(), sr(), sd_dec(), enb()))
    
    # Done
    shiny::showNotification("Updated portfolio", type = "message")
  })
  
  
  ## Input updates
  # Date range
  shiny::observeEvent(input$DateRangePrice, {
    shiny::updateDateRangeInput(
      session = session,
      inputId = "DateRangeRisk",
      start = input$DateRangePrice[1],
      end = input$DateRangePrice[2]
    )
    # Price/return data
    prices(GetPrices(
      db_conn,
      portfolio(),
      input$DateRangePrice
    ))
    returns(GetReturns(prices()))
    # Price development
    if (nrow(portfolio()) == 0) { return(NULL) }
    price_dev(GetPriceDev(prices()))
    ohlc(GetOHLC(db_conn, portfolio()))
    # Risk Management
    if (nrow(portfolio()) < 2) { return(NULL) }
    merged_returns(GetMergedReturns(returns()))
    vc(cov(merged_returns()[, -1]))
    corr_mat(GetCorrMat(merged_returns(), method = input$CorrelationMethod))
    sr(GetSharpeRatios(portfolio(), merged_returns(), input$RiskFreeRate, input$AnnualizeSharpeRatio))
    sd_dec(SDDecomp(portfolio(), merged_returns(), vc()))
    enb(GetENB(portfolio(), vc()))
    risk_stats(GetPortfolioRiskStats(portfolio(), sr(), sd_dec(), enb()))
  })
  shiny::observeEvent(input$DateRangeRisk, {
    shiny::updateDateRangeInput(
      session = session,
      inputId = "DateRangePrice",
      start = input$DateRangeRisk[1],
      end = input$DateRangeRisk[2]
    )
  })
  # Ticker
  shiny::observeEvent(input$StockOHLC, {
    ohlc(GetOHLC(db_conn, portfolio()))
  })
  # Correlation method
  shiny::observeEvent(input$CorrelationMethod,{
    if (nrow(portfolio()) < 2) { return(NULL) }
    corr_mat(GetCorrMat(merged_returns(), method = input$CorrelationMethod))
  })
  # Risk free rate
  shiny::observeEvent(input$RiskFreeRate, {
    if (nrow(portfolio()) < 2) { return(NULL) }
    sr(GetSharpeRatios(portfolio(), merged_returns(), input$RiskFreeRate, input$AnnualizeSharpeRatio))
    risk_stats(GetPortfolioRiskStats(portfolio(), sr(), sd_dec(), enb()))
  })
  # Annualize Sharpe ratio
  shiny::observeEvent(input$AnnualizeSharpeRatio, {
    if (nrow(portfolio()) < 2) { return(NULL) }
    sr(GetSharpeRatios(portfolio(), merged_returns(), input$RiskFreeRate, input$AnnualizeSharpeRatio))
    risk_stats(GetPortfolioRiskStats(portfolio(), sr(), sd_dec(), enb()))
  })
  
  
  ## Outputs
  # Portfolio composition
  output$out_PortComp <- DT::renderDT({
    FormatPortfolio(portfolio())
  })
  output$out_AddRemStock <- DT::renderDT({
    FormatAddRemoveStock(add_rem_stock())
  })
  # Price development
  output$out_PriceDev <- highcharter::renderHighchart({
    hcPriceDev(price_dev())
  })
  output$out_OHLC <- highcharter::renderHighchart({
    hcOHLC(ohlc(), input$StockOHLC)
  })
  # Risk management
  output$out_CorrMat <- highcharter::renderHighchart({
    hcCorrMat(corr_mat())
  })
  output$out_RiskStats <- DT::renderDT({
    FormatRiskStats(risk_stats())
  })
  
}

