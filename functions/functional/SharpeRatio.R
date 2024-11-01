#### SharpeRatio
# Computes the daily or annualized Sharpe ratio of return series (r) for a given risk-free-rate (rfr).


SharpeRatio <- function(r, rfr, annualize) {
  ifelse(annualize, sqrt(252), 1) * (mean(r - rfr) / sd(r))
}

