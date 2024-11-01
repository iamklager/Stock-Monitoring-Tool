#### GetPriceDev
# Transform prices into price developments (i.e., adding +1 to it).


GetPriceDev <- function(prices, date_from, date_to) {
  for (i in 1:length(prices)) {
    prices[[i]]$Delta  <- prices[[i]]$Adjusted / prices[[i]]$Adjusted[1]
    prices[[i]] <- prices[[i]][, c("Ticker", "Date", "Delta")]
  }
  
  res <- Reduce(rbind, prices)
  res$Date <- as.Date(res$Date)
  
  res
}

