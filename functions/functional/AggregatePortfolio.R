#### AggregatePortfolio
# Aggregates the portfolio by ticker and date.


AggregatePortfolio <- function(portfolio) {
  if (nrow(portfolio) < 2) {
    return(portfolio)
  }
  portfolio <- aggregate.data.frame(
    x = portfolio$Weight, 
    by = list(portfolio$Ticker, portfolio$PurchaseDate), 
    FUN = sum
  )
  colnames(portfolio) <- c("Ticker", "PurchaseDate", "Weight")
  
  portfolio
}

