#### Custom functions


### Query stock prices ----
f_QueryStocks <- function(ticker_symbols, current_date) {
  # Checking already queried files
  files <- list.files(path = "data/price_data/", pattern = ".RDS")
  old_files <- files[sub(".*_(\\d{4}-\\d{2}-\\d{2})\\.RDS", "\\1", files) != current_date]
  if (length(old_files) != 0) {
    file.remove(paste0("data/price_data/", old_files))
  }
  files <- files[!(files %in% old_files)]
  
  # Querying files if needed
  res <- lapply(ticker_symbols, function(symbol) {
    file_name <- paste0(symbol, "_", current_date, ".RDS")
    tryCatch(
      expr = {
        if (file_name %in% files) {
          stock <- readRDS(paste0("data/price_data/", file_name))
        } else {
          stock <- quantmod::getSymbols(
            Symbols = symbol,
            env = NULL,
            src = "yahoo"
          )
          stock <- adjustOHLC(x = stock, symbol.name = symbol)
          colnames(stock) <- gsub(paste0("^", symbol, "."), "", colnames(stock))
        }
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


### Get dates ----
f_GetDates <- function(stocks) {
  stocks <- lapply(stocks, function(x) { as.character(index(x)) })
  first_date <- max(unlist(lapply(stocks, function(x) { x[1] })))
  res <- sort(unique(unlist(stocks)), decreasing = FALSE)
  res <- as.Date(res[res >= first_date])
  
  return(res)
}


### Get first of the year ----
f_FOY <- function() {
  as.Date(paste0(substr(Sys.Date(), 1, 5), "01-01"))
}


### Price Development ----
f_hcPriceDev <- function(stocks, port_comp, start_date, end_date) {
  df_CumReturns <- bind_rows(lapply(1:length(stocks), function(i) {
    x <- as.data.frame(stocks[[i]])
    x$Date <- as.Date(row.names(x))
    row.names(x) <- NULL
    x[x$Date < port_comp[i, "PurchaseDate"], colnames(x) != "Date"] <- NA
    x <- x[x$Date >= start_date, ]
    x$PriceDev <- x$Close/na.omit(x$Close)[1] - 1
    x$Stock <- names(stocks)[i]
    
    return(x[, c("Stock", "Date", "PriceDev")])
  }))
  
  df_CumReturns %>%
    hchart("line", hcaes(x = Date, y = PriceDev, group = Stock)) %>%
    hc_yAxis(title = list(text = "Price Change (in %)")) %>%
    hc_add_theme(hc_theme_bs_superhero())
}


### OHCL chart ----
f_hcOHLC <- function(stocks, ticker_symbol) {
  highchart(type = "stock") %>%
    hc_add_series(data = stocks[[ticker_symbol]], upColor = "#7cb5ec", color = "#f7a35c") %>%
    hc_add_theme(hc_theme_bs_superhero())
}


### Correlation matrix ----
f_hcCorrMat <- function(stocks, start_date, end_date, method = "pearson") {
  # Filtering by date
  stocks <- lapply(stocks, window, start = start_date, end = end_date)
  
  # Log returns
  df_LogReturns <- lapply(1:length(stocks), function(i) {
    x <- as.data.frame(stocks[[i]])
    x["Date"] <- as.Date(rownames(x))
    x[names(stocks)[i]] <- c(0, diff(log(x$Close)))
    
    return(x[, c("Date", names(stocks)[i])])
  })
  df_LogReturns <- suppressWarnings(Reduce(function(x, y) {
    merge(x, y, all = TRUE)
  }, df_LogReturns))
  
  # Correlation matrix
  m_Corr <- cor(x = df_LogReturns[, -1], method = method, use = "complete.obs")
  m_Corr <- m_Corr[order(colnames(m_Corr)), order(colnames(m_Corr))]
  # m_Corr[lower.tri(m_Corr, diag = FALSE)] <- NA
  m_Corr <- reshape2::melt(m_Corr)
  
  hchart(object = m_Corr, type = "heatmap", hcaes(x = Var1, y = Var2, valuie = value)) %>%
    hc_plotOptions(heatmap = list(dataLabels = list(enabled = TRUE, format = "{point.value:.2f}"))) %>%
    hc_colorAxis(min = -1, max = 1,stops = color_stops(n = 20, colors = c("#7cb5ec", "#3B4D5B", "#f7a35c"))) %>%
    hc_xAxis(labels = list(style = list(fontSize = "10px")), title = list(text = "")) %>%
    hc_yAxis(labels = list(style = list(fontSize = "10px")), title = list(text = ""), reversed = TRUE) %>%
    hc_tooltip(pointFormat = "rho: {point.value:.3f}") %>%
    hc_legend(layout = "vertical", align = "right", verticalAlign = "middle") %>%
    hc_add_theme(hc_theme_bs_superhero())
}


### Risk contribution ----
f_RiskComp <- function(stocks, port_comp, rfr, annualize, start_date, end_date) {
  # Preprocessing the portfolio composition
  port_comp <- port_comp[port_comp$Stock %in% names(stocks), c("Stock", "Weight")]
  port_comp <- aggregate.data.frame(port_comp$Weight, by = list(port_comp$Stock), sum)
  colnames(port_comp) <- c("Stock", "Weight")
  port_comp$Weight <- port_comp$Weight/sum(port_comp$Weight)
  
  # Filtering by date
  stocks <- lapply(stocks, window, start = start_date, end = end_date)
  
  # Generating merged log-returns
  returns <- lapply(1:length(stocks), function(i) {
    x <- as.data.frame(stocks[[i]])
    x["Date"] <- as.Date(rownames(x))
    row.names(x) = NULL
    x$LogReturns <- c(0, diff(log(x$Close)))
    
    return(x[, c("Date", "LogReturns")])
  })
  returns <- suppressWarnings(Reduce(function(x, y) { 
    merge(x, y, by.x = "Date", by.y = "Date", all = TRUE)
  }, returns))
  colnames(returns)[-1] <- names(stocks)
  returns <- returns[, c("Date", port_comp$Stock)]
  port_ret <- rowSums(returns[, -1], na.rm = TRUE)
  
  # Risk contribution
  port_sd <- sd(port_ret)
  stand_devs <- apply(returns[, -1], 2, sd, na.rm = TRUE)
  sharpe_ratios <- apply(returns[, -1], 2, function(x) {
    sr <- ((mean(x, na.rm = TRUE) - rfr)/sd(x, na.rm = TRUE))
    if (annualize) {
      return(sqrt(252)*sr)
    } else {
      return(sr)
    }
  })
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
    SR = sharpe_ratios,
    MCS = mcs,
    CS = cs,
    PCS = pcs
  )
  row.names(res) <- NULL
  res[, 2:ncol(res)] <- round(res[, 2:ncol(res)], 3)
  
  return(res)
}




