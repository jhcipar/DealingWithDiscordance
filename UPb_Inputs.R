############################# U-Pb modeling inputs  ############################# 

############################# CLEAR THE ENVIRONMENT, RUN EVERY TIME! #############################
rm( list = ls( ) )


computer       <- "JesseReimink"
if( computer == "jxr1350" ) {
  google.drive.dir <- paste( "/Users/", computer, 
                             "/My Drive/", sep = "" )
} else {
  google.drive.dir <- paste( "/Users/", computer, 
                             "/Google Drive (jxr1350@psu.edu)/", sep = "" )
}
#############################  SET THE DIRECTORIES #############################
source.dir  <- paste( google.drive.dir, 
                      "Research/PostDoc/R scripts/UPb modeling Working", sep = "" )
lib.dir  <- paste( google.drive.dir, 
                      "Research/PostDoc/R scripts/", sep = "" )
data.dir		<- paste( google.drive.dir, 
					"Research/PSU/Projects/Basin Fluid Flow/Renan Thesis/Modeling Sensitivity", sep = "" )
export.dir		<- paste( google.drive.dir, 
					  "Research/PSU/Projects/Basin Fluid Flow/Renan Thesis/Modeling Sensitivity", sep = "" )

setwd( lib.dir )
source( "Libraries.R" )
source( "Constants.R" )
source( "Equations.R" )
source( "fte_theme_plotting.R" )
source( "GCDkit functions.R" )
setwd( data.dir )

#############################  DATA IMPORT #############################
# Data should have format as follows
# sample name, ratio 7/5, 1sigma75 (abs), ratio 6/8, 1sigma 68 (abs), rho, age76 in Ma

# Define the sample name, and node spacing
sample.name 	<- "synthetic_Combined_U_Pb_R_pbageupper_30Ma__pbagelower_20Ma"   	## Enter sample name here, part in front of .csv in filename
node.spacing	<- 100				## age in Ma

# 
# Data.raw$age76 <- age76( Data.raw$ratio76 )
# 
# Data.raw <- Data.raw[ , 1:7 ]
# download data file and view and define Npoints for future calculations
setwd( data.dir )
Data.raw   <- read.csv( paste( sample.name, ".csv", sep = "" ) )



## reads data in using the IsoplotR framework
data.concordia.plot <- read.data(  Data.raw[ , 2:6], ierr = 2,
								  method = 'U-Pb', format = 1 )
concordia( data.concordia.plot, type = 1 )
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
endcut.age.lower          <- 100		  ## Age in Ma
startcut.age.upper        <- 0 		## Age in Ma
endcut.age.upper          <- 4500		  ## Age in Ma

### Plot limits
plot.min.age		<- 0		## Age in Ma
plot.max.age		<- 4000 		## Age in Ma

# ### Plot limits: use to control plotting
upperint.plotlimit.min	  	<- 0
upperint.plotlimit.max		<- 2500
lowerint.plotlimit.min	  	<- 0
lowerint.plotlimit.max		<- 100

#############################  SOURCE REDUCTION FILES #############################
setwd( source.dir )
source( "UPb_Constants_Functions_Libraries.R" )   # Read in constants and functions from the other file
source( "fte_theme_plotting.R" )   	# Read in constants and functions from the other file

# download data file and view and define Npoints for future calculations
setwd( data.dir )
Data.raw   <- read.csv( paste( sample.name, ".csv", sep = "" ) )

setwd( source.dir )
source( "UPb_Reduction.R" )  ## do the reduction


setwd( source.dir )
source( "UPb_Plotting_Exporting_Older.R" )
fig.conc()
fig.xyplot()
fig.total.lower.int()
fig.2dhist()

print("done")








