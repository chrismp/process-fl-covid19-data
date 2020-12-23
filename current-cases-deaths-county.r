testFiles <- list.files(
  path = "../output/raw/tests",
  full.names = T
)

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

write.csv(
  x = outdf,
  file = paste0("current-cases-deaths-county.csv"),
  na = '',
  row.names = F
)
