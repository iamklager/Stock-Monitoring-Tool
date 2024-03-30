#### Custom highcharter theme
# Based on the bslib/bootswatch "superhero" theme.


hc_theme_bs_superhero <- function() {
  theme <- hc_theme_flat(
    chart = list(
      backgroundColor = "#1A2F40",
      style = list(
        color = "#C0C0C0",
        fontFamily = "Arial, sans-serif",
        fontWeight = "normal"
      )
    ),
    xAxis = list(
      gridLineColor = "#3B4D5B",
      tickColor = "#3B4D5B",
      lineColor = "#3B4D5B",
      title = list(style = list(color = "#C0C0C0"))
    ),
    yAxis = list(
      gridLineColor = "#3B4D5B",
      tickColor = "#3B4D5B",
      title = list(style = list(color = "#C0C0C0"))
    ),
    title = list(
      style = list(
        fontSize = "2em",
        fontFamily = "Arial, sans-serif",
        color = "#C0C0C0"
      )
    ),
    subtitle = list(style = list(color = "#C0C0C0")),
    legend = list(
      itemStyle = list(color = "#C0C0C0", fontWeight = "normal"),
      itemHoverStyle = list(color = "#FFFFFF"),
      itemHiddenStyle = list(color = "#444444")
    )
  )
  theme$colors <- c(
    "#7cb5ec", "#90ed7d", "#f7a35c", "#8085e9", "#f15c80", "#e4d354", 
    "#2b908f", "#f45b5b", "#91e8e1"
  )
  
  return(theme)
}
