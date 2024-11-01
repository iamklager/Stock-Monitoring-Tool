#### WriteStockPrices
# Appends a dataframe of stock prices to the price database.


WriteStockPrices <- function(db_conn, prices) {
  if (is.null(prices)) {
    return(NULL)
  }
  
  DBI::dbWriteTable(
    conn = db_conn,
    name = "prices",
    value = prices,
    append = TRUE
  )
}

