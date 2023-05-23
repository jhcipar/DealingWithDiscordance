library(shiny)
library(IsoplotR)
library('cardidates')
library(dplyr)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      # Option to choose between copy-pasted data and file upload
      selectInput(
        "data_source",
        label = "Data Source",
        choices = c("Copy-Paste", "Upload File"),
        selected = "Upload File"
      ),
      
      # Text input as a table
      conditionalPanel(
        condition = "input.data_source == 'Copy-Paste'",
        textAreaInput(
          "data_input",
          label = "Paste your data here:",
          value = "",
          width = "100%",
          height = "200px"
        )
      ),
      
      # File upload input
      conditionalPanel(
        condition = "input.data_source == 'Upload File'",
        fileInput(
          "data_file",
          label = "Upload data file (CSV)",
          accept = ".csv"
        )
      ),
      selectInput(inputId = "node_space", 
                  label = "Node Spacing (ma)", 
                  choices = c("10", 
                              "5",
                              "1"), 
                  selected = "10", 
                  multiple = FALSE,
                  selectize = TRUE),
      
      selectInput(inputId = "plot_shown", 
                  label = "Discordance Plot", 
                  choices = c("Max Probability", 
                              "Lower Intercept (summed probability",
                              "Heat Map"), 
                  selected = "Lower Intercept (max probability)", 
                  multiple = FALSE,
                  selectize = TRUE),
    ),
    
    mainPanel(
      # Output plot or other functions
      textOutput("my_csv_name"), #shows file name
      plotOutput("output_plot"), #plots concordia diagram
      plotOutput("Discordance_plot"),
      
      # Output table
      tableOutput("output_table")
    )
  )
)


server <- function(input, output, session) {
  # Function to load data based on input type
  loadData <- function() {
    if (input$data_source == "Copy-Paste") {
      # Read the input data from copy-paste
      data <- read.table(text = input$data_input, sep = "\t", header = TRUE, check.names = FALSE)
    } else {
      # Read the input data from file upload
      req(input$data_file)
      data <- read.csv(input$data_file$datapath, header = TRUE, check.names = FALSE)
    }
    
    # Subset the data to include only the desired columns
    desired_columns <- c("Samples", "Final Pb207/U235_mean", "Final Pb207/U235_2SE(int)", "Final Pb206/U238_mean",
                         "Final Pb206/U238_2SE(int)", "rho 206Pb/238U v 207Pb/235U", "Final Pb207/Pb206 age_mean")
    data <- data[, desired_columns, drop = FALSE]
    
    # Return the data frame
    return(data)
  }

#generate file name
  
  output$my_csv_name <- renderText({ #Output file name
    # Test if file is selected
    if (!is.null(input$data_file$datapath)) {
      # Extract file name (additionally remove file extension using sub)
      return(print(class(loadData())))
    } else {
      return(NULL)
    }
  })
  
  # Process the user input and generate output table
  output$output_table <- renderTable({
    data <- loadData()
    data
  })
  
  # Process the user input and generate output plot
  output$output_plot <- renderPlot({
    data <- loadData()
    
      # Generate the plot or perform other functions
      
      # Example: Concordia Diagram
    data_concordia <- read.data(  data[ , 2:6], ierr = 1,
                method = 'U-Pb', format = 1 )
      concordia( data_concordia, type = 1 )

  })
  
  #process data and run discordance data 
  output$Discordance_plot <-renderPlot({
   data <- loadData()
   Data.raw <- data
   
  #define variables
   file_name<- input$data_file$name
   sample.name 	<- sub(".csv", "", file_name)
   node.spacing	<- as.numeric(input$node_space) #node spacing from drop down
   
   #############################  SWITCHES #############################
   ## this should be "Y" to normalize the uncertainties to the median value
   #    otherwise it doesn't do anything
   normalize.uncertainty	 <- "N"  
   
   ## this should be "detrital" to weight against concordant analyses
   #    otherwise it should be 'single' to not weight against concordant analyses
   data.type	 <- "single"  
   
   ## If cut.data.by.ratios is Y it trim the input data by the cuts below
   cut.data.by.ratios	<- "N"
   ## These are the start and ends, in ratio space, this cuts data out of the data file
   startcut.r75        <- 0
   endcut.r75          <- 20
   startcut.r68        <- 0
   endcut.r68          <- 0.8
   
   # This zooms the plots into a certain age window
   #  		Use this to either simply zoom in on a particular age, or 
   #  		to zoom in and use a very tight node spacing to save computational time	
   #       it doesn't perform the analysis outside of the age window defined below
   zoom.analysis		<- "Y"
   ## These are the start and ends, only performs the reduction on certain nodes defined
   #	by the ages below here
   startcut.age.lower        <- 0 			## Age in M <- a
   endcut.age.lower          <- 2000		  ## Age in Ma
   startcut.age.upper        <- 0		## Age in Ma
   endcut.age.upper          <- 2000		  ## Age in Ma
   
   ### Plot limits
   plot.min.age		<- 0		## Age in Ma
   plot.max.age		<- 2000		## Age in Ma
   
   # ### Plot limits: use to control plotting
   upperint.plotlimit.min	  	<- 0
   upperint.plotlimit.max		<- 2000
   lowerint.plotlimit.min	  	<- 0
   lowerint.plotlimit.max		<- 2000
   
  #set up things from other files in the git hub
   source( "UPb_Constants_Functions_Libraries.R", local = TRUE )   # Read in constants and functions from the other file
   source( "fte_theme_plotting.R", local = TRUE  )   	# Read in constants and functions from the other file
   source( "UPb_Reduction_2023_Rebuild.R" , local = TRUE )  ## do the reduction
   source( "UPb_Plotting_Exporting_Older.R" , local = TRUE ) #For the plotting functions
   
   
  
   if (input$plot_shown == "Max Probability"){
        fig.xyplot()
     }
   if (input$plot_shown == "Lower Intercept (summed probability"){
        fig.total.lower.int()
     }
   if (input$plot_shown == "Heat Map"){
        fig.2dhist()
     }
  })
    
  
}

# Run the Shiny app
shinyApp(ui = ui, server = server)





      