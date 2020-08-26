cByD <- "cases-by-date"
sflC <- "south-fl-cumulative"
dailyCounties <- "daily-fl-counties"
sflVFL <- "cases-by-date-SouthFL"
cnty <- "county"
pr <- "counties-positive-cases-rate"
ag <- "age-group"
meda <- "median-age-by-case-date"
cd <- "current-deaths"

dfNames <- c(cByD,sflC,dailyCounties,sflVFL,cnty,pr,ag,meda,cd)

for (i in 1:length(dfNames)) {
  f <- paste0(args[1],dfNames[[i]],".csv")
  fIn <- file.info(f)
  editTime <- as.numeric(as.POSIXct(fIn$mtime))
  
  rawFiles <- list.files(args[[2]])
  latestFile <- rawFiles[[length(rawFiles)]]
  latestFileTimeString <- gsub(
    pattern = "FL-|.csv",
    replacement = '',
    x = latestFile
  )
  latestFileTime <- as.numeric(as.POSIXct(latestFileTimeString,format="%Y-%m-%d_%H%M%S"))
  
  processedDatasetAlreadyMade <- editTime > latestFileTime
  if(processedDatasetAlreadyMade) next
  source(paste0(dfNames[[i]],".r"))
}
