#### PanelPortfolioComposition
# The portfolio composition panel's ui.


PanelPortfolioComposition <- function() {
  bslib::nav_panel(
    title = "Portfolio Composition",
    
    bslib::card_body(
      
      shiny::div(
        style = "margin:0; width:50%; position:relative; left:25%;", # CHANGE THIS
        #style = "display: flex; justify-content: center; align-items: center;",
        
        DT::DTOutput("out_PortComp"),
        
        br(),
        
        DT::DTOutput("out_AddRemStock"),
        
        bslib::layout_column_wrap(
          width = 0.5,
          shiny::div(
            style = "display: flex; justify-content: center; align-items: center;",
            bslib::tooltip(
              bslib::input_task_button(
                id = "AddStock",
                label = "Add", style = "width: 50%"
              ),
            "Insert a ticker, its purchase date and its weight to add it to the portfolio."
          )
          ),
          shiny::div(
            style = "display: flex; justify-content: center; align-items: center;",
            bslib::tooltip(
              bslib::input_task_button(
                id = "RemoveStock",
                label = "Remove", style = "width: 50%"
              ),
              "Insert a ticker to remove it from the portfolio."
            )
          )
        ),
        
        br(),
        
        div(
          style = "display: flex; justify-content: center; align-items: center;",
          bslib::tooltip(
            bslib::input_task_button(
              id = "UpdatePortfolio",
              label = "Update", style = "width: 50%"
            ),
            "Update the portfolo to load the newest prices and update all statistics and chards."
          )
        )
        
      )
      
    )
    
  )
}

