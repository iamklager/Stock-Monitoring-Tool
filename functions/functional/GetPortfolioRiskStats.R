#### GetPortfolioRiskStats
# Computes the Sharpe ratio, risk decomposition and effective number of independent bets for a portfolio.


GetPortfolioRiskStats <- function(portfolio, sr, sd_dec, enb) {
  res <- portfolio[, c("Ticker", "Weight")]
  res$Weight <- res$Weight / sum(res$Weight)
  res$SD <- sd_dec$Assets
  res$SR <- sr$Assets
  res$ENB <- enb$p[, 1]
  
  res <- rbind(
    res,
    data.frame(
      Ticker = "Portfolio",
      Weight = 1,
      SD = sd_dec$Portfolio,
      SR = sr$Portfolio,
      ENB = enb$enb
    )
  )
  res[, 2:ncol(res)] <- round(res[, 2:ncol(res)], 3)
  
  res
}

