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
    
    # Update button
    actionButton(
      inputId = "in_UpdatePortfolio",
      label = "Update"
    )
  )
  
)