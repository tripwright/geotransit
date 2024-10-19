
GTFS_df <- read_csv("GTFS_df.csv")
GTFS_df <- GTFS_df %>%
  filter(!is.na(lon_min) & !is.na(lon_max) & !is.na(lat_min) & !is.na(lat_max))
