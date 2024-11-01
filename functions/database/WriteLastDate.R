#### WriteLastDate
# Writes the last queried date for a stock to the database.


WriteLastDate <- function(db_conn, ticker) {
  last_date <- format(Sys.Date(), "%Y-%m-%d")
  DBI::dbSendQuery(
    conn = db_conn,
    statement = "
      INSERT INTO last_updated (Ticker, Date)
      VALUES (
        ?1,
        ?2
      )
      ON CONFLICT (Ticker) DO UPDATE SET Date = excluded.Date;
    ",
    params = c(ticker, last_date)
  )
}

