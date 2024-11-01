#### GetLastDate
# Queries the last date for a stock from the database. Returns '1800-01-01' if no date exists.


GetLastDate <- function(db_conn, ticker) {
  res <- RSQLite::dbGetQuery(
    conn = db_conn,
    statement = "
      SELECT Date
      FROM last_updated
      WHERE Ticker = ?;
    ",
    params = ticker
  )[1, 1]
  
  if (is.na(res)) {
    res <- "1800-01-01"
  }
  
  res
}

