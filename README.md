# Stock-Monitoring-Tool

A tool to simulate and analyze a stock portfolio from a risk management perspective.


## Technologies Used
- R: + Shiny, bslib, highcharter, and quantmod
- HTML
- CSS


## Implementation Details

### Performance Measures

The presented measures are the stocks' relative price developments, including a classic OHLC chart for single stocks, a correlation matrix for either Pearson's or Kendall's correlation coefficient, the Sharpe ratio, the risk composition expressed through Euler's decomposition of the standard deviation, as well as the effective number of independent bets introduced by Meucci et al.

### Data Storage

The portfolio composition can be changed directly within the UI and gets stored upon updating the tool. Price data is queried from Yahoo-Finance and is only updated if new current data exists for a given stock. Both price data, and the portfolio composition, are stored in .csv files.

### Visualiztaion
To display the portfolio composition and each metric, highcharter plots are paired together with table outputs. A custom highcharter theme was created to fit the plots to the Bootswatch "Superhero"" theme, and additional styling was done via HTML and CSS.


## Demo Screenshots

<p align = "center">
  <img src = "https://github.com/iamklager/Stock-Monitoring-Tool/raw/main/.github/screenshot_1.png" width = "270" />
  <img src = "https://github.com/iamklager/Stock-Monitoring-Tool/raw/main/.github/screenshot_2.png" width = "270" />
  <img src = "https://github.com/iamklager/Stock-Monitoring-Tool/raw/main/.github/screenshot_3.png" width = "270" />
</p>

