#### GetSharpeRatios
# Computes the Sharperatio of each asset and the portfolio.

GetSharpeRatios <- function(portfolio, returns, rfr, annualize) {
  list(
    Assets = apply(returns[, -1], 2, SharpeRatio, rfr, annualize),
    Portfolio = SharpeRatio(rowSums(returns[, -1]), rfr, annualize)
  )
}

