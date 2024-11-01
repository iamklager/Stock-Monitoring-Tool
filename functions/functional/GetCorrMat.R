#### GetCorrMat
# Gets the correrlation matrix from a return matrix.

GetCorrMat <- function(returns, method) {
  if (nrow(returns) < 3) {
    return(NULL)
  }
  
  m <- cor(returns[, -1], method = method)
  rowcol_names <- colnames(returns)[-1]
  colnames(m) <- rownames(m) <- rowcol_names
  m <- m[order(rowcol_names), order(rowcol_names)]
  
  reshape2::melt(m)
}

