ui <- page_sidebar(
  ## Theme
  theme = bs_theme(preset = "superhero"),
  
  ## Title
  title = "Stock Monitoring Tool",
  
  ## Sidebar
  sidebar = sidebar(
    # Options
    open = "always",
    
    # Portfolio composition
    DTOutput("out_PortComp"),
    
    # Add and remove stocks
    DTOutput("out_AddRemStock"),
    div(
      style = "display: inline-block;",
      actionButton(
        inputId = "in_AddStock",
        label = "Add",
        width = '49%'
      ),
      actionButton(
        inputId = "in_RemoveStock",
        label = "Remove",
        width = '49%'
      )
    ),
    
    # Update portfolio button
    actionButton(
      inputId = "in_UpdatePortfolio",
      label = "Update"
    )
  )
  
)