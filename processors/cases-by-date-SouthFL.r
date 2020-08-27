sflVFL <- "cases-by-date-SouthFL"
df <- func.SummCases(
  group_by(
    .data = filter(
      .data = positives,
      !is.na(caseDate)
    ),
    caseDate,
    SouthFLCounties
  )
) %>%
  dcast(SouthFLCounties ~ caseDate)

df$Order <- ifelse(
  test = df$SouthFLCounties == "Rest of state",
  yes = 1,
  no = ifelse(
    test = df$SouthFLCounties == "Miami-Dade",
    yes = 2,
    no = ifelse(
      test = df$SouthFLCounties == "Broward",
      yes = 3,
      no = 4
    )
  )
) 
df <- df[order(df$Order),]