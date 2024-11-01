#### GetENB
# Computes the effective number of uncorrelated bets and the assets' probabilities.

GetENB <- function(portfolio, vc) {
  
  t <- uncorbets::torsion(sigma = vc, model = "pca")
  res <- uncorbets::effective_bets(b = portfolio$Weight, sigma = vc, t = t)
  
  res
}

