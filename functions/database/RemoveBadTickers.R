#### RemoveBadTickers
# Removes tickers without a price history from a portfolio data frame.


RemoveBadTickers <- function(db_conn, portfolio) {
  bad_tickers <- c()
  
  for (ticker in portfolio$Ticker) {
    row_numb <- DBI::dbGetQuery(
      conn = db_conn,
      statement = "
        SELECT (
          SELECT COUNT() FROM prices
          WHERE Ticker = ?
        ) AS row_numb
      ",
      params = ticker
    )[1, 1]
    if (row_numb == 0) {
      bad_tickers <- c(bad_tickers, ticker)
    }
  }
  
  portfolio[!(portfolio$Ticker %in% bad_tickers), ]
}

