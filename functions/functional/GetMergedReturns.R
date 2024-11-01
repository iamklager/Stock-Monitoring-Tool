#### GetMergedReturns
# Merges the assets' returns and fills missing values with 0.


GetMergedReturns <- function(returns) {
  
  res <- returns[[1]][, c("Date", "LogReturn")]
  colnames(res)[2] <- names(returns)[1]
  
  for (i in 2:length(returns)) {
    y <- returns[[i]][, c("Date", "LogReturn")]
    colnames(y)[2] <- names(returns)[i]
    res <- merge(
      x = res, y = y,
      by.x = "Date", by.y = "Date", all = TRUE
    )
  }
  
  res[is.na(res)] <- 0
  
  res
}

