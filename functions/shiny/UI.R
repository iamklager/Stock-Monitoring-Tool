#### UI
# The UI generating function.


UI <- function() {
  
  bslib::page_navbar(
    
    # Design stuff
    theme = bslib::bs_theme(preset = "superhero", primary = "#3b4d5b"),
    lang = "en",
    title = "Stock Monitoring Tool",
    window_title = "Stock Monitoring Tool",
    selected = "Portfolio Composition",
    
    # Panels
    PanelPortfolioComposition(),
    PanelPriceDevelopment(),
    PanelRiskManagement()
    
  )
  
}

