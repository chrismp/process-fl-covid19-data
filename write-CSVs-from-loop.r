for (i in 1:length(dfNames)) {
  dfn <- dfNames[[i]]
  f <- paste0(processedDataDir,'/',dfn,".csv")
  fIn <- file.info(f)
  editTime <- as.numeric(as.POSIXct(fIn$mtime))
  
  latestFileTimeString <- gsub(
    pattern = ".*FL-|.csv",
    replacement = '',
    x = latestFile
  )
  latestFileTime <- as.numeric(as.POSIXct(latestFileTimeString,format="%Y-%m-%d_%H%M%S"))
  
  # processedDatasetAlreadyMade <- editTime > latestFileTime
  # if(processedDatasetAlreadyMade) next
  
  print(paste0("Processing data for ",f))
  source(paste0("processors/",dfn,".r"))

  outFile <- paste0(processedDataDir,'/',dfn,".csv")
  print(paste0("Writing ",outFile))
  write.csv(
    x = df,
    file = outFile,
    na = '',
    row.names = F
  )
}