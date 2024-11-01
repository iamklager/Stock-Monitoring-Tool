#### PanelPriceDevelopment
# The price development panel's ui.


PanelPriceDevelopment <- function() {
  bslib::nav_panel(
    title = "Price Development",
    
    bslib::card_body(
      bslib::layout_sidebar(
        sidebar = bslib::sidebar(
          open = "always",
          
          shiny::dateRangeInput(
            inputId = "DateRangePrice",
            label = "Time-Frame",
            start = paste0(format(Sys.Date(), "%Y"), "-01-01"),
            end = Sys.Date(),
            format = "yyyy-mm-dd",
            language = "en",
            max = format(Sys.Date(), "%Y-%m-%d")
          ),
          
          shiny::selectizeInput(
            inputId = "StockOHLC",
            label = "Stock",
            choices = GetPortfolioTickers(DBConnection())
          )
          
        ),
        
        highcharter::highchartOutput("out_PriceDev"),
        highcharter::highchartOutput("out_OHLC")
      )
    )
    
  )
}

