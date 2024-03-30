#### Custom functions


### Query stock prices ----
f_QueryStocks <- function(ticker_symbols, last_date) {
  res <- lapply(ticker_symbols, function(symbol) {
    tryCatch(
      expr = {
        stock <- quantmod::getSymbols(
          Symbols = symbol,
          env = NULL,
          src = "yahoo"
        )
        colnames(stock) <- gsub(paste0("^", symbol, "."), "", colnames(stock))
        stock
      },
      error = function(e) {
        NULL
      }
    )
  })
  names(res) <- ticker_symbols
  res <- res[!unlist(lapply(res, is.null))]
  
  return(res)
}


### Cumulated returns ----
f_hcCumRet <- function(stocks, start_date = "2020-01-01") {
  df_CumReturns <- bind_rows(lapply(1:length(stocks), function(i) {
    x <- as.data.frame(stocks[[i]])
    x$Date <- as.Date(row.names(x))
    row.names(x) <- NULL
    x <- x[x$Date >= start_date, ]
    x$DeltaPrice <- c(0, diff(x$Close)/x$Close[-nrow(x)])
    x$DeltaPrice[is.na(x$DeltaPrice)] <- 0
    x$CumReturns <- cumsum(x$DeltaPrice)
    x$Stock <- names(stocks)[i]
    
    return(x[, c("Stock", "Date", "CumReturns")])
  }))
  
  df_CumReturns %>%
    hchart("line", hcaes(x = Date, y = CumReturns, group = Stock)) %>%
    hc_add_theme(hc_theme_bs_superhero())
}


### Correlation matrix ----
f_hcCorrMat <- function(stocks, method = "pearson") {
  df_LogReturns <- lapply(1:length(stocks), function(i) {
    x <- as.data.frame(stocks[[i]])
    x["Date"] <- as.Date(rownames(x))
    x[names(stocks)[i]] <- c(0, diff(log(x$Close)))
    
    return(x[, c("Date", names(stocks)[i])])
  })
  df_LogReturns <- Reduce(function(x, y) {merge(x, y, all = TRUE) }, df_LogReturns)
  m_Corr <- cor(x = df_LogReturns[, -1], method = method, use = "complete.obs")
  
  hchart(m_Corr) %>% hc_add_theme(hc_theme_bs_superhero())
}


### Risk contribtution ----
f_RiskComp <- function(stocks, port_comp) {
  # Preprocessing the portfolio composition
  port_comp <- port_comp[port_comp$Stock %in% names(stocks), ]
  port_comp <- aggregate.data.frame(port_comp$Weight, by = list(port_comp$Stock), sum)
  colnames(port_comp) <- c("Stock", "Weight")
  port_comp$Weight <- port_comp$Weight/sum(port_comp$Weight)
  
  # Generating merged log-returns
  returns <- lapply(1:length(stocks), function(i) {
    x <- as.data.frame(stocks[[i]])
    x["Date"] <- as.Date(rownames(x))
    row.names(x) = NULL
    x$LogReturns <- c(0, diff(log(x$Close)))
    
    return(x[, c("Date", "LogReturns")])
  })
  returns <- Reduce(function(x, y) { 
    merge(x, y, by.x = "Date", by.y = "Date", all = TRUE)
  }, returns)
  colnames(returns)[-1] <- names(stocks)
  returns <- returns[, c("Date", port_comp$Stock)]
  port_ret <- rowSums(returns[, -1], na.rm = TRUE)
  
  # Risk contribution
  port_sd <- sd(port_ret)
  stand_devs <- apply(returns[, -1], 2, sd, na.rm = TRUE)
  cov_mat <- cov(returns[, -1], use = "complete.obs")
  alloc_risk <- sqrt(port_comp$Weight %*% cov_mat %*% port_comp$Weight)[1, 1]
  mcs <- ((port_comp$Weight %*% cov_mat)/alloc_risk)[1, ]
  cs <- port_comp$Weight * mcs
  pcs <- cs/alloc_risk
  
  # Result
  res <- data.frame(
    Stock = port_comp$Stock,
    Weight = port_comp$Weight,
    SD = stand_devs,
    MCS = mcs,
    CS = cs,
    PCS = pcs
  )
  row.names(res) <- NULL
  res[, 2:6] <- round(res[, 2:6], 3)
  
  return(res)
}


### OHCL chart ----
f_hcOHLC <- function(stocks, ticker_symbol) {
  highchart(type = "stock") %>% 
    hc_add_series(data = stocks[[ticker_symbol]], upColor = "#7cb5ec", color = "#f7a35c") %>% 
    hc_add_theme(hc_theme_bs_superhero())
}

