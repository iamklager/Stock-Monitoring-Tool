#### GetOHLC
# Loads all tickers OHLC prices from the database and formats them.


GetOHLC <- function(db_conn, portfolio) {
  
  res <- lapply(portfolio$Ticker, function(ticker) {
    prices <- DBI::dbGetQuery(
      conn = db_conn,
      statement = "
      SELECT *
      FROM prices
      WHERE Ticker = ?
    ",
      params = ticker
    )
    rownames(prices) <- as.Date(prices$Date)
    prices <- prices[, 3:8]
    prices <- xts::as.xts(prices)
  })
  names(res) <- portfolio$Ticker
  
  res
}



