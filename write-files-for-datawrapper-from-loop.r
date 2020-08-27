for (i in 1:length(dfNames)) {
  dfn <- dfNames[[i]]
  f <- paste0(processedDataDir,dfn,".csv")
  fIn <- file.info(f)
  editTime <- as.numeric(as.POSIXct(fIn$mtime))
  
  rawFiles <- list.files(args[[3]])
  latestFile <- rawFiles[[length(rawFiles)]]
  latestFileTimeString <- gsub(
    pattern = "FL-|.csv",
    replacement = '',
    x = latestFile
  )
  latestFileTime <- as.numeric(as.POSIXct(latestFileTimeString,format="%Y-%m-%d_%H%M%S"))
  
  processedDatasetAlreadyMade <- editTime > latestFileTime
  if(processedDatasetAlreadyMade) next
  
  source(paste0(dfn,".r"))
  
  write.csv(
    x = df,
    file = paste0(processedDataDir,dfn,".csv"),
    na = '',
    row.names = F
  )
}