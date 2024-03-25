### Clearing environment ----
rm(list = ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
cat("\014")


### Libraries ----
library(dplyr)
library(highcharter)
library(purrr)
library(quantmod)
library(tidyr)
library(ggplot2)


### Stock-Symbols ----
c_WatchList <- c("ATS.VI", "AUS.F", "CDR.WA", "MLYS", "FORM", "AMPH", "ELSE")

f_GetStockData <- function(symbol) {
  res <- getSymbols(
    Symbols = symbol,
    env = NULL,
    src = "yahoo"
  )
  colnames(res) <- gsub(paste0("^", symbol, "."), "", colnames(res))
  res$Returns <- diff(res$Close)
  res$LogReturns <- diff(log(res$Close))
  res <- as.data.frame(res)
  res$Date <- as.Date(row.names(res))
  row.names(res) <- NULL
  res[1, is.na(res[1,])] <- 0
  return(res)
}
l_Stocks <- lapply(c_WatchList, f_GetStockData)


### Correlation ----
df_CorMat <- lapply(l_Stocks, function(x) { x[, c("Date", "LogReturns")] }) %>% 
  reduce(inner_join, by = "Date")
colnames(df_CorMat)[-1] <- c_WatchList
df_CorMat <- cor(df_CorMat[, -1], method = "kendall", use = "complete.obs")
hchart(df_CorMat)


### NAV ----
df_CumReturns <- lapply(l_Stocks, function(x) { 
  res <- x[, c("Date", "Returns")]
  res$CumReturns <- cumsum(res$Returns)
  
  return(res[, c("Date", "CumReturns")])
}) %>% 
  reduce(inner_join, by = "Date")
colnames(df_CumReturns)[-1] <- c_WatchList


