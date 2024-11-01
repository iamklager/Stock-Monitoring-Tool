#### FormatAddRemoveStock
# Formats the DT output for the addition/removal of a stock.


FormatAddRemoveStock <- function(df) {
  DT::datatable(
    data = df, 
    editable = TRUE,
    options = list(
      dom = 't', 
      ordering = FALSE,
      autoWidth = TRUE,
      columnDefs = list(
        list(width = "33%", targets = "_all"),
        list(className = "dt-right", targets = "_all")
      )
    ), 
    rownames = FALSE,
    colnames = rep("", 2)
  )
}

