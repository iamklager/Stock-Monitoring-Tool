#### CreateDatabase
# Creates the database and all its tables.


CreateDatabase <- function() {
  dir.create(path = "data/", showWarnings = FALSE)
  
  db_conn <- DBConnection()
  
  # Prices
  DBI::dbSendStatement(
    conn = db_conn,
    statement = "
      CREATE TABLE IF NOT EXISTS prices
      (
        Ticker TEXT NOT NULL,
        Date TEXT NOT NULL,
        Open REAL,
        High REAL,
        Low REAL,
        Close REAL,
        Volume REAL,
        Adjusted REAL
      );
    "
  )
  DBI::dbSendStatement(
    conn = db_conn,
    statement = "CREATE INDEX index_prices ON prices (Ticker, Date);"
  )
  
  # Last price updates (No real benefit of an index)
  DBI::dbSendStatement(
    conn = db_conn,
    statement = "
      CREATE TABLE IF NOT EXISTS last_updated
      (
        Ticker TEXT NOT NULL UNIQUE,
        Date TEXT NOT NULL
      );
    "
  )
  
  # Portfolio
  DBI::dbSendStatement(
    conn = db_conn,
    statement = "
      CREATE TABLE IF NOT EXISTS portfolio
      (
        Ticker TEXT NOT NULL,
        PurchaseDate TEXT NOT NULL,
        Weight REAL NOT NULL
      );
    "
  )
  DBI::dbSendStatement(
    conn = db_conn,
    statement = "CREATE INDEX index_portfolio ON portfolio (Ticker, PurchaseDate);"
  )
  
}