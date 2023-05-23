library(shiny)
library(rhandsontable)

# Define UI
ui <- fluidPage(
  
  # Add a title
  titlePanel("Handsontable Example"),
  
  # Add a handsontable object for data input
  rHandsontableOutput("hot"),
  
  # Add a button to trigger an action
  actionButton("button", "Calculate"),
  
  # Add a plot to display the results
  plotOutput("plot")
)

# Define server
server <- function(input, output) {
  
  # Initialize the handsontable with some example data
#   data <- data.frame(a = 1:5, b = letters[1:5])
    data <- data.frame(
        ColumnA = as.numeric(rep(NA, 100)),
        ColumnB = as.numeric(rep(NA, 100)),
        ColumnC = as.numeric(rep(NA, 100)),
        ColumnD = as.numeric(rep(NA, 100))
    )
  output$hot <- renderRHandsontable(rhandsontable(data))
  
  # Define an event observer to update the data when the handsontable is edited
  observeEvent(input$hot, {
    data <- hot_to_r(input$hot)
  })
  
  # Define an event observer to trigger an action when the button is clicked
  observeEvent(input$button, {
    # Perform some calculation using the input data
    result <- sum(data$ColumnA)
    # Display the result in a plot
    output$plot <- renderPlot(plot(result))
    test <- 1 + 1
  })
}

# Run the app
shinyApp(ui, server)
