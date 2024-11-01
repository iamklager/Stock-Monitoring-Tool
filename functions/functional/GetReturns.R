#### GetReturns
# Computes the absolute (Close to Close), percent and log returns for an asset queried from the data base.

GetReturns <- function(prices) {
  
  res <- lapply(prices, function(x) {
    if (nrow(x) == 0) {
      return(NULL)
    }
    # x <- na.omit(x)
    x$C2C <- c(0, x$Adjusted[-1] - x$Adjusted[-nrow(x)])
    x$Return <- c(1, x$Adjusted[-1] / x$Adjusted[-nrow(x)]) - 1
    x$LogReturn <- log(1 + x$Return)
    # x[is.na(x)] <- 0
    # x[sapply(x, is.infinite)] <- 0
    
    x[, c("Date", "C2C", "Return", "LogReturn")]
  })
  names(res) <- names(prices)
  
  res
}

