# Read the CSV file "GTFS_df.csv" into a data frame named GTFS_df
GTFS_df <- read_csv("GTFS_df.csv")

# Filter the data frame to remove rows with missing values in the specified columns
GTFS_df <- GTFS_df %>%
  filter(!is.na(lon_min) & !is.na(lon_max) & !is.na(lat_min) & !is.na(lat_max))
# Keep only rows where lon_min, lon_max, lat_min, and lat_max are not NA
