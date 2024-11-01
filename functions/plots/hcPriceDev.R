#### hcPriceDev
# Highchart for the stocks' price development.


hcPriceDev <- function(price_dev) {
  require(highcharter)
  
  if (is.null(price_dev)) {
    return(
      shiny::validate(
        shiny::need((!is.null(price_dev)), "Not enough assets in the portfolio.\nPlease update the portfolio.")
      )
    )
  }
  
  hchart(
    object = price_dev, 
    type = "line", 
    hcaes(x = Date, y = Delta, group = Ticker)
  ) |>
    hc_plotOptions(line = list(tooltip = list(valueDecimals = 3))) |>
    hc_xAxis(labels = list(style = list(fontSize = "10px")), title = list(text = "")) |>
    hc_yAxis(labels = list(style = list(fontSize = "10px")), title = list(text = "relative price development")) |>
    hc_add_theme(hcThemeSuperhero())
  
}

