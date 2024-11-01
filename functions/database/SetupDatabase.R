#### SetupDatabase
# Checks if the database exists, creates it if it does not, and clears it if it should be emptied.


SetupDatabase <- function(clear_database = FALSE) {
  
  db_exists <- file.exists("data/stocks_db.sqlite3")
  
  if (!db_exists) {
    CreateDatabase()
    return(NULL)
  }
  
  if (clear_database) {
    ClearDatabase()
    return(NULL)
  }
  
  db_conn <- DBConnection()
  
}

