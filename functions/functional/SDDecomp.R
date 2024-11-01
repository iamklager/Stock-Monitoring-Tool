#### SDDecomp
# Computes the standard deviation decomposition for the portfolio.


SDDecomp <- function(portfolio, returns, vc) {
  
  omega <- portfolio$Weight
  
  sigma_p <- sqrt(omega %*% vc %*% omega)[1, 1] # Weighted portfolio standard deviation
  
  MCR <- (vc %*% omega) / sigma_p               # Marginal contribution to risk
  CR  <- omega * MCR                            # Asset contribution to risk
  PCR <- CR / sigma_p                           # Percent contribution to risk
  
  list(
    Assets = PCR[, 1],
    Portfolio = sigma_p
  )
}

