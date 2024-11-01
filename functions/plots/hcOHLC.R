#### hcOHLC
# Highchart for a stock's candlestick chart.


hcOHLC <- function(prices, ticker) {
  require(highcharter)
  
  if (length(prices) == 0) {
    return(
      shiny::validate(
        shiny::need((length(prices) != 0), "Not enough assets in the portfolio.\nPlease update the portfolio.")
      )
    )
  }
  
  prices <- prices[[ticker]]
  highchart(type = "stock") |>
    hc_add_series(data = prices, upColor = "#f7a35c", color = "#7cb5ec", name = ticker) |>
    hc_tooltip(valueDecimals = 3) |>
    hc_add_theme(hcThemeSuperhero())
  
}

