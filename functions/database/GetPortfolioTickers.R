#### GetPortfolioTickers
# Queries the tickers from the database.


GetPortfolioTickers <- function(db_conn) {
  DBI::dbGetQuery(
    conn = db_conn,
    statement = "
      SELECT Ticker
      FROM portfolio
      ORDER BY Ticker
      ASC;
    "
  )[, 1]
}

