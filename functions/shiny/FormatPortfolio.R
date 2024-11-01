#### FormatPortfolio
# Formats the DT output for the portfolio.


FormatPortfolio <- function(df) {
  DT::datatable(
    data = df, 
    editable = TRUE,
    options = list(
      dom = 't',
      autoWidth = TRUE,
      columnDefs = list(
        list(width = "33%", targets = "_all"),
        list(className = "dt-right", targets = "_all")
      )
    ), 
    rownames = FALSE
  )
}

