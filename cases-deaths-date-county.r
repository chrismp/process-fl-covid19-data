library(stringr)
library(dplyr)
library(data.table)

testFiles <- list.files(
  path = "../output/raw/tests",
  full.names = T
)

outdf <- data.frame(
  DateTime = character(),
  Date = character(),
  UnixTime = numeric(),
  `Broward cases` = numeric(),
  `Miami-Dade cases` = numeric(),
  `Palm Beach cases` = numeric(),
  `Cases in rest of Florida` = numeric(),
  `Florida cases` = numeric(),
  `Broward deaths` = numeric(),
  `Miami-Dade deaths` = numeric(),
  `Palm Beach deaths` = numeric(),
  `Deaths in rest of Florida` = numeric(),
  `Florida deaths` = numeric()
)

for (i in 1:length(testFiles)) {
  file <- testFiles[[i]]
  
  timeString <- gsub(
    pattern = ".*FL-|.csv",
    replacement = '',
    x = file
  )
  if (timeString=="2020-03-27_191501") next
  
  timeDate <- as.POSIXct(
    x = timeString,
    format = "%Y-%m-%d_%H%M%S"
  )
  
  timeUnix <- as.numeric(timeDate)
  
  date <- as.Date(
    x = timeString,
    format = "%Y-%m-%d_%H%M%S"
  )
  
  df <- read.csv(file)
  
  findStateTotal <- grepl(
    pattern = "state",
    x = tolower(df$COUNTYNAME)
  )
  
  stateTotalRow <- df[tolower(df$COUNTYNAME) %like% "state",]
  resDeathsCol <- ifelse(
    test = "Deaths" %in% names(df),
    yes = "Deaths",
    no = ifelse(
      test = "FLResDeaths" %in% names(df),
      yes = "FLResDeaths",
      no = "C_FLResDeaths"
    )
  )
  
  if (nrow(stateTotalRow)>0) {
    stateTotal <- stateTotalRow$T_positive
    stateDeaths <- stateTotalRow[[resDeathsCol]] + stateTotalRow$C_NonResDeaths
  } else {
    stateTotal <- sum(df$T_positive)
    stateDeaths <- sum(df[[resDeathsCol]]) + sum(df$C_NonResDeaths)
  }
  
  broward <- df[df$COUNTYNAME=="BROWARD",]$T_positive
  dade <- df[df$COUNTYNAME %in% c("DADE","MIAMI-DADE"),]$T_positive
  pbc <- df[df$COUNTYNAME=="PALM BEACH",]$T_positive
  restOfState <- stateTotal - broward - dade - pbc
  
  browardDeaths <- df[df$COUNTYNAME=="BROWARD",]$C_NonResDeaths + df[df$COUNTYNAME=="BROWARD",][[resDeathsCol]]
  dadeDeaths <- df[df$COUNTYNAME %in% c("DADE","MIAMI-DADE"),]$C_NonResDeaths + df[df$COUNTYNAME %in% c("DADE","MIAMI-DADE"),][[resDeathsCol]]
  pbcDeaths <- df[df$COUNTYNAME=="PALM BEACH",]$C_NonResDeaths + df[df$COUNTYNAME=="PALM BEACH",][[resDeathsCol]]
  restOfStateDeaths <- stateDeaths - browardDeaths - dadeDeaths - pbcDeaths
  
  outdf[i,] <- c(
    as.character(timeDate),
    as.character(date),
    timeUnix,
    broward,
    dade,
    pbc,
    restOfState,
    stateTotal,
    browardDeaths,
    dadeDeaths,
    pbcDeaths,
    restOfStateDeaths,
    stateDeaths
  )
}

cols <- names(outdf)
charCols  <- c("DateTime","Date")
numCols <- cols[!cols %in% charCols]
outdf[numCols] <- sapply(outdf[numCols],as.numeric)

outdf <- outdf[complete.cases(outdf),]
outdf2 <- outdf %>% 
  group_by(Date) %>% 
  slice(which.max(UnixTime))


func.SubtractFromPrev <- function(x){return(x - lag(x))}

outdf2$NewCasesBroward <- func.SubtractFromPrev(outdf2$Broward.cases)
outdf2$NewCasesDade <- func.SubtractFromPrev(outdf2$Miami.Dade.cases)
outdf2$NewCasesPalmBeach <- func.SubtractFromPrev(outdf2$Palm.Beach.cases)
outdf2$NewCasesRestOfFlorida <- func.SubtractFromPrev(outdf2$Cases.in.rest.of.Florida)
outdf2$NewCasesFlorida <- func.SubtractFromPrev(outdf2$Florida.cases)

outdf2$NewDeathsBroward <- func.SubtractFromPrev(outdf2$Broward.deaths)
outdf2$NewDeathsDade <- func.SubtractFromPrev(outdf2$Miami.Dade.deaths)
outdf2$NewDeathsPalmBeach <- func.SubtractFromPrev(outdf2$Palm.Beach.deaths)
outdf2$NewDeathsRestOfState <- func.SubtractFromPrev(outdf2$Deaths.in.rest.of.Florida)
outdf2$NewDeathsFlorida <- func.SubtractFromPrev(outdf2$Florida.deaths)

write.csv(
  x = outdf2,
  file = paste0("cases-deaths-by-date-county.csv"),
  na = '',
  row.names = F
)
  