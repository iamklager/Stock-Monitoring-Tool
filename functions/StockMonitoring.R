#### StockMonitoring
# The function to run the tool.


StockMonitoring <- function(
    
  dependencies = c(
    # Database
    "DBI", "RSQLite",
    # Functional
    "quantmod", "reshape2", "uncorbets", "xts",
    # Visual
    "highcharter",
    # Shiny
    "shiny", "DT", "bslib"
  ),
  install_dependencies = FALSE,
  clear_database = FALSE
  
) {
  
  # Dependency check
  CheckDependencies(
    dependencies = dependencies,
    install_dependencies = install_dependencies
  )
  
  # Database setup
  SetupDatabase(clear_database = clear_database)
  
  
  # Starting the application
  shinyApp(UI(), Server)
  
}

