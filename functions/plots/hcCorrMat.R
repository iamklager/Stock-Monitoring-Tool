#### hcCorrMat
# Highchart for a correlation matrix.


hcCorrMat <- function(m) {
  require(highcharter)
  
  if (is.null(m)) {
    return(
      shiny::validate(
        shiny::need((!is.null(m)), "Not enough assets in the portfolio.\nPlease update the portfolio.")
      )
    )
  }
  
  hchart(
    object = m, 
    type = "heatmap", 
    hcaes(x = Var1, y = Var2, value = value),
    name = "&#961" # decimal small rho
  ) |> 
    hc_plotOptions(
      heatmap = list(
        dataLabels = list(enabled = TRUE, format = "{point.value:.3f}"),
        tooltip = list(pointFormat = "{point.value:.3f}")
      )
    ) |> 
    hc_colorAxis(
      min = -1, 
      max = 1, 
      stops = color_stops(
        n = 20, 
        colors = c("#7cb5ec", "#FFFFFF", "#f7a35c")
      )
    ) |> 
    hc_colorAxis(reversed = FALSE) |>
    hc_xAxis(labels = list(style = list(fontSize = "10px")), title = list(text = "")) |> 
    hc_yAxis(labels = list(style = list(fontSize = "10px")), title = list(text = ""), reversed = TRUE) |> 
    hc_legend(layout = "vertical", align = "right", verticalAlign = "middle") |> 
    hc_add_theme(hcThemeSuperhero())
  
}

