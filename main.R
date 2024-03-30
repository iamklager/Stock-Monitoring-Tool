#### Main
# The main script used to run the application.


### Clearing environment ----
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
rm(list = ls())
cat("\14")


### Libraries ----
source("Code/libraries.R")


### Custom stuff ----
source("Code/custom_hc_theme.R")
source("Code/custom_functions.R")


### Shiny ----
source("Code/ui.R")
source("Code/server.R")


### Running the app ----
shinyApp(ui, server)
