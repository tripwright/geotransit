library(tidyverse)
library(sf)

# Read the CSV file "GTFS_df.csv" into a data frame named GTFS_df
GTFS_df <- read_csv("data-raw/csv/GTFS_df.csv")

# Rename bounding box coord columns to simpler names
# Filter the data frame keep rows where lon_min, lon_max, lat_min, and lat_max have values
# Filtering out realtime GTFS, sf2GTFS only downloads static GTFS files
GTFS_df1 <- GTFS_df %>%
  rename(lat_min = location.bounding_box.minimum_latitude,
         lat_max = location.bounding_box.maximum_latitude,
         lon_min = location.bounding_box.minimum_longitude,
         lon_max = location.bounding_box.maximum_longitude) %>%
  filter(!is.na(lon_min) & !is.na(lon_max) & !is.na(lat_min) & !is.na(lat_max)) %>%
  filter(data_type != "gtfs-rt") %>%
  # Create unique id column by combining provider with name (when applicable)
  mutate(id = ifelse(is.na(name), provider, paste(provider, name)))

# Prepare GTFS bounding boxes and convert them to sf objects
# Assuming your GTFS_df has lat_min, lat_max, lon_min, lon_max columns for the bounding boxes
GTFS_df2 <- GTFS_df1 %>%
  rowwise() %>%
  mutate(geometry = st_as_sfc(st_bbox(c(
    xmin = lon_min,
    ymin = lat_min,
    xmax = lon_max,
    ymax = lat_max), crs = st_crs(4326)))) # Ensure the same CRS

# Check for invalid geometries and fix
GTFS_df3 <- GTFS_df2 %>%
  mutate(geometry = st_make_valid(geometry))

GTFS_df <- GTFS_df3 %>%
select(location.country_code, location.subdivision_name, location.municipality,
       provider, name, id, feed_contact_email, urls.direct_download, urls.latest,
       urls.authentication_info, urls.license, lat_min, lat_max, lon_min, lon_max,
       status, features, geometry) %>%
  rename(country = location.country_code, region = location.subdivision_name,
       city = location.municipality, provider = provider, name = name, id = id,
       contact = feed_contact_email, url_source = urls.direct_download,
       url_latest = urls.latest, url_authenticate = urls.authentication_info,
       license = urls.license, lat_min = lat_min, lat_max = lat_max, lon_min = lon_min,
       lon_max = lon_max, status = status, features = features, geometry = geometry)

usethis::use_data(GTFS_df, overwrite = TRUE, compress = "xz")
