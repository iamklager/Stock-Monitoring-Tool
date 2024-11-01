#### WritePortfolio
# Overwrites the portfolio table with the new portfolio.


WritePortfolio <- function(db_conn, portfolio) {
  DBI::dbWriteTable(
    conn = db_conn,
    name = "portfolio",
    value = portfolio,
    overwrite = TRUE
  )
}

