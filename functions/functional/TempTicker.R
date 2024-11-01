#### TempTicker
# Initializes input field's data frame used to add/remove a stock.


TempTicker <- function() {
  data.frame(
    Ticker = "Ticker",
    PurchaseDate = format(Sys.Date(), "%Y-%m-%d"),
    Weight = 0
  )
}

