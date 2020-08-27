df <- filter(
  .data = positives,
  tolower(Died) == "yes"
) %>%
  group_by(
    County,
    Jurisdiction
  ) %>%
  summarise(
    Deaths = n()
  ) %>%
  dcast(County ~ Jurisdiction) %>% 
  rowwise() %>%
  mutate(
    Residents = sum(
      `FL resident`,
      `Not diagnosed/isolated in FL`,
      na.rm = T
    )
  ) %>%
  mutate(
    Total = sum(
      Residents,
      `Non-FL resident`,
      na.rm = T
    )
  ) %>%
  rename(
    `Non-residents` = `Non-FL resident`
  )

df <- df[, -which(names(df) %in% c("FL resident","Not diagnosed/isolated in FL"))] %>%
  adorn_totals(
    where = c("row"),
    na.rm = T,
    name = "Statewide"
  )

df <- df[,c("County","Total","Residents","Non-residents")]