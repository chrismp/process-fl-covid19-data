func.SummAgeRelatedDFs <- function(p){
  df <- func.SummCases(
    group_by(
      .data = p,
      `Age group`
    )
  )
  df[is.na(df)] <- "Unknown"
  df <- df %>% 
    group_by(`Age group`) %>% 
    summarise(`Confirmed cases` = sum(`Confirmed cases`))
  
  return(df)
}


positives$`Age group` <- ifelse(
  test = positives$Age >= 80,
  yes = "80 or older",
  no = ifelse(
    test = positives$Age >= 70,
    yes = "70-79",
    no = ifelse(
      test = positives$Age >= 60,
      yes = "60-69",
      no = ifelse(
        test = positives$Age >= 50,
        yes = "50-59",
        no = ifelse(
          test = positives$Age >= 40,
          yes = "40-49",
          no = ifelse(
            test = positives$Age >= 30,
            yes = "30-39",
            no = ifelse(
              test = positives$Age >= 18,
              yes = "18-29",
              no = ifelse(
                test = positives$Age >= 0,
                yes = "17 or younger",
                no = "Unknown"
              )
            )
          )
        )
      )
    )
  )
)

casesByAge <- func.SummAgeRelatedDFs(positives)

hospByAge <- func.SummAgeRelatedDFs(
  filter(
    .data = positives,
    grepl(
      pattern = "yes",
      x = Hospitalized,
      ignore.case = T
    )
  )
) %>%
  rename(c("Hospitalizations"="Confirmed cases"))

deathsbyAge <- func.SummAgeRelatedDFs(
  filter(
    .data = positives,
    grepl(
      pattern = "yes",
      x = Died,
      ignore.case = T
    )
  )
) %>%
  rename(c("Deaths"="Confirmed cases"))

ag <- "age-group"
df <- Reduce(function(x,y) merge(x,y,all=T,by="Age group"), list(casesByAge,hospByAge,deathsbyAge))