latestFile <- testFiles[length(testFiles)]

df <- read.csv(latestFile)
df[df$County_1=="Dade",]$County_1 <- "Miami-Dade"
df[df$County_1=="Desoto",]$County_1 <- "DeSoto"

outdf <- df[c(
  "County_1",
  "T_positive",
  "C_NonResDeaths",
  "C_FLResDeaths"
)]

outFname <- paste0(args[2],"/current-cases-deaths-county.csv")
print(paste0("Writing file: ",outFname))

write.csv(
  x = outdf,
  file = outFname,
  na = '',
  row.names = F
)
