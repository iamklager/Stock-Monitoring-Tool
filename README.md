# Stock-Monitoring-Tool

A dashboard to monitor the performance and risk of a stock portfolio. Built in R using Shiny.


## Idea

This tool allows the user to simulate and monitor a portfolio of stocks.  
It consist of a [portfolio compositon](#portfolio-composition) tab in which the portfolio can be edited, a [price development](#price-development) in which the price changes of the stocks are displayed, and the [risk contribution](#risk-contribution) tab that decomposes the portfolio risk and shows the correlation between the stocks.

## Demo

<p align = "center">
  <img src = "https://github.com/iamklager/Stock-Monitoring-Tool/raw/main/.github/portfolio_composition.png" width = "300" />
  <img src = "https://github.com/iamklager/Stock-Monitoring-Tool/raw/main/.github/price_development.png" width = "300" />
  <img src = "https://github.com/iamklager/Stock-Monitoring-Tool/raw/main/.github/risk_contribution.png" width = "300" />
</p>

## Requirements

To run this project the user must have installed R in combination with the following libraries:
- *dplyr*
- *quantmod*
- *readxl*
- *highcharter*
- *shiny*
- *DT*
- *bslib*


## Layout

### Portfolio Composition

The first table represents the portfolio where *Stock* shows symbols found on yahoo finance, *Weight* determines the weight of the stock in the portfolio (the weights are later scaled and hence prices or relative values can both be used), and *PurchaseDate* represents the day at which it was bought.  
To change the portfolio, one can edit the values found in this table. To add or remove a stock, its values must be added in the second table before using the *Add* or the *Remove* button.  
To *Update* button queries the stock prices, generates the charts and saves the changes made to the portfolio.


### Price Development

The price development shows two charts. The first one displays the relative price changes of each security, while the second chart displays the OHLC-prices of of a single stock.  
The *Time-Frame* date input determines which period should be considered (prices before the purchase date are removed for each stock) while the *Stock* picker input is used to select which stock should be displayed in the OHLC-chart.


### Risk Contribution

In this tab, a correlation matrix and a risk decomposition table are displayed. The risk decomposition table shows the relative weight (*Weight*), the return standard deviation (*SD*), the Sharpe ratio (*SR*), the marginal risk contribution (*MCS*), the weighted risk contribution (*CS*) and the percentage risk contribution (*PCS*) of each stock (*Stock*).  
The *Time-Frame* date input functions similar to the one in the [price development](#price-development) tab, however values before the purchase date are not removed. 
The *Correlation Method* selection can be used to switch between the pearson, spearmann, and kendall correlation.  
Additionally, the *Risk-Free Rate of Return* can be entered to determine the Sharpe ratio which can also be annualized using the *Annualize* switch.