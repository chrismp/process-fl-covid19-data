args <- commandArgs(trailingOnly=TRUE)

options(scipen = 999)

pkgs <- c(
  "devtools",
  "dplyr",
  "forcats",
  "reshape2",
  "zoo",
  "janitor"
)

for(x in pkgs){
  if(!is.element(x, installed.packages()[,1])){
    install.packages(x)
  } else {
    print(paste(x, " library already installed"))
  }
}

library(dplyr)
library(forcats)
library(reshape2)
library(zoo)
library(janitor)


func.SummCases <- function(gdf){
  return(
    gdf %>%
      summarise(
        `Confirmed cases` = n()
      )
  )
}


# countyPops <- read.csv(
#   file = "source/2019-flbebr-county-pop-estimates.csv",
#   check.names = F,
#   stringsAsFactors = F
# )

positives <- read.csv(
  file = args[1],
  stringsAsFactors = F
)

positives$County <- ifelse(is.na(positives$County),"Unknown",positives$County)
positives[positives$County=="Dade",]$County <- "Miami-Dade"
positives[positives$County=="Desoto",]$County <- "DeSoto"

positives$SouthFLCounties <- ifelse(
  test = positives$County == "Miami-Dade" | positives$County == "Broward" | positives$County == "Palm Beach",
  yes = positives$County,
  no = "Rest of state"
)

# positives$caseDate <- as.Date(x = positives$Case1, format = "%m/%d/%Y")
correctUnixTimePositiveCases <- (positives$Case1/1000)
positives$caseDate <- format(
  x = as.POSIXct(
    x = correctUnixTimePositiveCases,
    origin = "1970-01-01",
    tz = "EST"
  ),
  "%Y-%m-%d"
) 


cByD <- "cases-by-date"
sflC <- "south-fl-cumulative"
dailyCounties <- "daily-fl-counties"
sflVFL <- "cases-by-date-SouthFL"
cnty <- "county"
# pr <- "counties-positive-cases-rate"
ag <- "age-group"
meda <- "median-age-by-case-date"
cd <- "current-deaths"

dfNames <- c(cByD,sflC,dailyCounties,sflVFL,cnty,ag,meda,cd)

processedDataDir <- args[2]
source("write-datawrapper-files-from-loop.r")