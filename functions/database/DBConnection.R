#### DBConnection
# Establishes connection to the database.


DBConnection <- function() {
  DBI::dbConnect(RSQLite::SQLite(), "data/stocks_db.sqlite3")
}