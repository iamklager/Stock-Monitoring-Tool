#### LoadStockPrices
# Queries a stock's prices from yahoo-finance.


LoadStockPrices <- function(ticker, last_date="1800-01-01") {
  res <- tryCatch(
    {
      prices <- quantmod::getSymbols(
        Symbols = ticker,
        env = NULL,
        warnings = FALSE,
        from = last_date,
        src = "yahoo"
      )
      if (all(index(prices) < last_date)) {
        return(NULL)
      }
      prices
      
    }, error = function(e) {
      NULL
    }
  )
  
  if (is.null(res)) {
    return(res)
  }
  
  res <- na.omit(res)
  dates <- zoo::index(res)
  res <- as.data.frame(res)
  colnames(res) <- gsub(paste0("^", ticker, "."), "", colnames(res))
  res$Date <- as.character(format(as.Date(dates), "%Y-%m-%d"))
  res$Ticker <- ticker
  row.names(res) <- NULL
  
  res[, c("Ticker", "Date", "Open", "High", "Low", "Close", "Volume", "Adjusted")]
}

