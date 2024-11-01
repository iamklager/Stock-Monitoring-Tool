#### FormatRiskStats
# Formats the DT output for the risk statistics.


FormatRiskStats <- function(df) {
  
  if (is.null(df)) {
    return(
      shiny::validate(
        shiny::need((!is.null(df)), "Not enough assets in the portfolio.\nPlease update the portfolio.")
      )
    )
  }
  
  DT::formatStyle(
    DT::datatable(
      data = df,
      editable = FALSE,
      rownames = TRUE,
      options = list(
        dom = 't', 
        ordering = TRUE,
        autoWidth = TRUE,
        columnDefs = list(
          list(visible = F, targets = 0),
          list(className = "dt-right", targets = 1:4)
        )
      )
    ),
    columns = 0, target = "row", fontWeight = DT::styleEqual(dim(df)[1], "bold")
  )
}

