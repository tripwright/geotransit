#' Download static GTFS feeds from a simple features object
#'
#' This function downloads static GTFS feeds for all transit routes operating
#' within all of the geographies of a simple features (sf) class object and saves them to directory.
#'
#' @param sf_object An sf class object representing the area(s) of interest.
#' @param output_dir A character string specifying the directory to save the downloaded files.
#'
#' @return NULL
#' @importFrom sf st_as_sfc st_bbox st_crs st_intersects st_set_crs st_transform
#' @importFrom httr GET http_status modify_url timeout content
#' @importFrom dplyr %>% filter
#' @export
sf2gtfs <- function(sf_object, output_dir) {
  # Load the GTFS dataframe
  data("GTFS_df", package = "geotransit")

  # Create the directory if it doesn't exist
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)  # Recursive = TRUE creates parent directories if necessary
  }

  # Create bounding box from the urban area
  bbox <- st_bbox(sf_object)
  bbox_sf <- st_as_sfc(bbox) %>%
    st_set_crs(st_crs(sf_object)) %>%
    st_transform(crs = 4326)

  # Filter routes whose bounding boxes intersect with the urban area bounding box
    GTFS_filter <- GTFS_df %>%
      filter(sapply(geometry, function(g) any(st_intersects(g, bbox_sf, sparse = FALSE))))

  # New column for URL. If 'urls.latest' is NA, replaces with values from 'URL'
  #  GTFS_filter <- GTFS_filter %>%
  #  mutate(urls = ifelse(is.na(urls.latest), URL, urls.latest))

  # Iterate through each URL and download GTFS files
  for (i in seq_len(nrow(GTFS_filter))) {
    url <- GTFS_filter$url_latest[i]  # Adjust the column name as necessary
    file <- GTFS_filter$id[i]  # Adjust the column name as necessary
    filename <- paste0(file, ".zip")  # Create filename based on provider column

    # Attempt to download without API key initially
    response <- GET(url, timeout(60))

    # Check for Unauthorized status
    if (http_status(response)$category == "Client error" && http_status(response)$reason == "Unauthorized") {
      # Prompt user for API key
      message(paste("Unauthorized access for:", filename))
      api_key <- readline(prompt = "Enter API key for this URL: ")

      # Retry the download with the provided API key (as query parameter)
      response <- GET(modify_url(url, query = list(api_key = api_key)), timeout(60))

      # Option code to add support for sending API key in the header if required by some URLs
      # Uncomment the following block to send the API key in the header instead:
      #
      # send_in_header <- readline(prompt = "Send API key in header? (yes/no): ")
      # if (tolower(send_in_header) == "yes") {
      #   response <- GET(url, add_headers(Authorization = paste("Bearer", api_key)), timeout(60))
      # } else {
      #   response <- GET(modify_url(url, query = list(api_key = api_key)), timeout(60))
      # }
    }

    # Handle response and download file
    tryCatch({
      if (http_status(response)$category == "Success") {
        filepath <- file.path(output_dir, filename)
        writeBin(content(response, "raw"), filepath)
        message(paste("Downloaded:", filename))
      } else {
        warning(paste("Failed to download:", filename, "with status:", http_status(response)$reason))
      }
    }, error = function(e) {
      warning(paste("Failed to download after retries:", conditionMessage(e)))
    })
  }
}
