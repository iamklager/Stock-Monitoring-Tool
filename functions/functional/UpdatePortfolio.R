#### UpdatePortfolio
# Updates the portfolio based on the portfolio table in the UI. That includes, loading price data, and updating tables in the db.


UpdatePortfolio <- function(db_conn, portfolio) {
  
  if (nrow(portfolio) == 0) {
    return(NULL)
  }
  
  for (ticker in portfolio$Ticker) {
    last_date <- GetLastDate(db_conn=db_conn, ticker=ticker)
    if (last_date == format(Sys.Date(), "%Y-%m-%d")) {
      next
    }
    
    prices <- LoadStockPrices(
      ticker = ticker, 
      last_date = last_date
    )
    if (is.null(prices)) {
      next
    }
    
    WriteStockPrices(db_conn=db_conn, prices=prices)
    WriteLastDate(db_conn=db_conn, ticker=ticker)
  }
  
  portfolio <- RemoveBadTickers(db_conn=db_conn, portfolio=portfolio) # Not necessary anymore due to is.null condition?
  if (nrow(portfolio) == 0) {
    return(NULL)
  }
  
  portfolio <- AggregatePortfolio(portfolio)
  
  WritePortfolio(db_conn=db_conn, portfolio=portfolio)
  
}

