pkgs <- c(
  "dplyr",
  "stringr",
  "data.table"
)

for(x in pkgs){
  if(!is.element(x, installed.packages()[,1])){
    install.packages(x,repo="http://cran.rstudio.com/")
  } else {
    print(paste(x, " library already installed"))
  }
}

library(dplyr)
library(stringr)
library(data.table)

args <- commandArgs(trailingOnly=TRUE)

options(scipen = 999)

testFiles <- list.files(
  path = args[1],
  full.names = T
)

source("cases-deaths-date-county.r")
source("current-cases-deaths-county.r")