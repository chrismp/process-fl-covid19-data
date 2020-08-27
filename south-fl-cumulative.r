df <- filter(positives, SouthFLCounties != "Rest of state") %>%
  group_by(caseDate, SouthFLCounties) %>% 
  summarise(`Daily confirmed cases` = n()) %>%
  dcast(caseDate ~ SouthFLCounties)
df[is.na(df)] <- 0
df$`Broward sum cases` <- cumsum(df$Broward)
df$`Miami-Dade sum cases` <- cumsum(df$`Miami-Dade`)
df$`Palm Beach sum cases` <- cumsum(df$`Palm Beach`)