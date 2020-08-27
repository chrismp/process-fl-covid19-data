df <- group_by(
  .data = positives,
  caseDate
) %>%
  summarise(
    `Median age` = median(Age, na.rm = T),
    Cases = n()
  )