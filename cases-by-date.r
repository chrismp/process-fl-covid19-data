df <- func.SummCases(
  group_by(
    .data = positives,
    caseDate
  )
)
df[,"Cumulative cases"] <- cumsum(df$`Confirmed cases`)