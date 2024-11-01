#### Main
# The main script used to run the application.


### Clearing environment ----
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
rm(list = ls())
cat("\14")


### Loading functions ----
invisible(lapply(setdiff(list.files(pattern = "[.]R$", recursive = TRUE), "main.R"), source, echo = FALSE))


### Starting the app ----
StockMonitoring(install_dependencies = TRUE, clear_database = FALSE)

