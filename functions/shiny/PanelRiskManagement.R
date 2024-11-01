#### PanelRiskManagement
# The risk management panel's ui.


PanelRiskManagement <- function() {
  
  bslib::nav_panel(
    title = "Risk Management",
    
    bslib::card_body(
      bslib::layout_sidebar(
        sidebar = bslib::sidebar(
          open = "always",
          
          shiny::dateRangeInput(
            inputId = "DateRangeRisk",
            label = "Time-Frame",
            start = paste0(format(Sys.Date(), "%Y"), "-01-01"),
            end = Sys.Date(),
            format = "yyyy-mm-dd",
            language = "en",
            max = format(Sys.Date(), "%Y-%m-%d")
          ),
          
          shiny::selectizeInput(
            inputId = "CorrelationMethod",
            label = "Correlation Method",
            choices = c("pearson", "kendall", "spearman"),
            selected = "pearson",
            multiple = FALSE
          ),
          
          shiny::numericInput(
            inputId = "RiskFreeRate",
            label = "Risk-Free Rate of Return",
            value = 0,
            step = 0.01
          ),
          
          shiny::checkboxInput(
            inputId = "AnnualizeSharpeRatio",
            label = "Annualize",
            value = FALSE
          )
        ),
        
        bslib::layout_column_wrap(
          witth = 0.5,highcharter::highchartOutput("out_CorrMat", height = "80%"),
          DT::DTOutput("out_RiskStats")
        )
        
      )
    )
    
  )
  
}

