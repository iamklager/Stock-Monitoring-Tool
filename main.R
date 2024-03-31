#### Main
# The main script used to run the application.


### Clearing environment ----
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
rm(list = ls())
cat("\14")


### Libraries ----
source("code/libraries.R")


### Custom stuff ----
source("code/custom_hc_theme.R")
source("code/custom_functions.R")


### Shiny ----
source("code/ui.R")
source("code/server.R")


### Running the app ----
shinyApp(ui, server)

