df <- positives %>%
  group_by(County,caseDate) %>%
  summarise(`Daily confirmed cases` = n()) %>%
  dcast(County ~ caseDate)