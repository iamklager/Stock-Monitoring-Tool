#### GetPrices
# Queries a ticker's from the data base.

GetPrices <- function(db_conn, portfolio, date_range) {
  
  date_from <- as.character(date_range[1])
  date_to <- as.character(date_range[2])
  
  res <- lapply(portfolio$Ticker, function(ticker) {
    DBI::dbGetQuery(
      conn = DBConnection(),
      statement = "
        SELECT *
        FROM prices
        WHERE Ticker = ?1
          AND Date BETWEEN ?2 AND ?3
          AND Date >= (
            SELECT PurchaseDate
            FROM portfolio
            WHERE Ticker = ?1
          );
      ",
      params = c(ticker, date_from, date_to)
    )
  })
  names(res) <- portfolio$Ticker
  
  res
}

