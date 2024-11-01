#### GetPortfolio
# Queries the portfolio from the database.


GetPortfolio <- function(db_conn) {
  DBI::dbGetQuery(
    conn = db_conn,
    statement = "
      SELECT *
      FROM portfolio;
    "
  )
}

