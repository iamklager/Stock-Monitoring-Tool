# Stock-Monitoring-Tool

A tool to simulate and analyze a stock portfolio from a risk management perspective.

## Use Case \& Background

To avoid repeatedly running the same R-scripts, I wrote this tool to tool allows users to simulate stock portfolios. The resulting portfolios can then be analyzed wrt. their components' price developments, and their risk profiles, hopefully aiding people in making better informed investing decisions.

## How to Run

After downloading the project folder, you can start the application by running the *main.R* script. Doing this will automatically load all necessary functions before running the *StockMonitoring()* function, which will start the application. To install all necessary dependencies automatically, you can simply set *install\_dependencies* to *TRUE*. Setting *clear\_database* to *TRUE* will delete all the data stored from previous uses.
```r
StockMonitoring(install_dependencies = FALSE, clear_database = FALSE)
```

Alternatively, you can install all the necessary dependencies manually by running the following code:
```r
# Database
install.packages("DBI")
install.packages("RSQLite")
# Functional
install.packages("quantmod")
install.packages("reshape2")
install.packages("uncorbets")
install.packages("xts")
# Visualization
install.packages("highcharter")
# Shiny
install.packages("shiny")
install.packages("DT")
install.packages("bslib")
```

## Technologies Used

- R: + Shiny, bslib, highcharter, and quantmod
- SQLite
- HTML
- CSS


## Implementation Details

### Performance Measures

The presented measures are the stocks' relative price developments, including a classic OHLC chart for single stocks, a correlation matrix for either Pearson's, Kendall's or Spearman's correlation coefficient, the Sharpe ratio, the risk composition expressed through Euler's decomposition of the standard deviation, as well as the effective number of independent bets introduced by Meucci et al.

By default, all charts and statistics are being created YTD. However, the date range can be adjusted by the user.

### Data Storage

To store all the necessary data, a SQLite database has been implemented. Upon starting the application, the database and all the necessary tables are being created if the database does not exist yet. The database stores the portfolio composition, the last day at which price data has been loaded for each asset, as well as the price data itself.

The portfolio composition can be changed directly within the UI and gets stored upon updating the tool. Price data is queried from Yahoo-Finance and is only updated if new current data exists for a given stock. Note that the entire price history is being queried for each asset. This was done to avoid conflicts with changing the purchase date of a stock to an earlier date than those found in the database.

### Data Processing

To keep disc storage to a minimum, only the raw price data is being stored in the database. 

Additional processing, such as the computation of returns or correlations, happen each time the portfolio is being updated or if one of the relevant settings, such as the date range, is being changed by the user.

### Visualiztaion

To display the portfolio composition and each metric, highcharter plots are paired together with table outputs. A custom highcharter theme was created to fit the plots to the Bootswatch "Superhero" theme, and additional styling was done via HTML and CSS.

(Note that floating tiles in the correlation matrix are a result of the CRAN-version of the highcharter library using an older version of HighchartsJS. See [this post on stackoverflow](https://stackoverflow.com/questions/74855868/highcharts-heatmap-tiles-float-after-resizing).)


## Demo Screenshots

<p align = "center">
  <img src = "https://github.com/iamklager/Stock-Monitoring-Tool/raw/main/.github/screenshot_1.png" width = "270" />
  <img src = "https://github.com/iamklager/Stock-Monitoring-Tool/raw/main/.github/screenshot_2.png" width = "270" />
  <img src = "https://github.com/iamklager/Stock-Monitoring-Tool/raw/main/.github/screenshot_3.png" width = "270" />
</p>

