#### ClearDatabase
# Clears all tables in the database.


ClearDatabase <- function() {
  db_conn <- DBConnection()
  
  dbSendQuery(
    conn = db_conn,
    statement = "DELETE FROM prices;"
  )
  
  dbSendQuery(
    conn = db_conn,
    statement = "DELETE FROM last_updated;"
  )
  
  dbSendQuery(
    conn = db_conn,
    statement = "DELETE FROM portfolio;"
  )
  
}