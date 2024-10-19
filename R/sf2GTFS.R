#' Download GTFS files
#'
#' This function downloads GTFS files from specified URLs and saves them to a specified directory.
#'
#' @param urls A character vector of URLs to download GTFS files from.
#' @param files A character vector of filenames corresponding to each URL.
#' @param output_dir A character string specifying the directory to save the downloaded files.
#' @param api_key Optional API key for accessing restricted URLs.
#'
#' @return NULL
#' @export
download_GTFS <- function(urls, files, output_dir) {
  # Create the directory if it doesn't exist
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)  # Recursive = TRUE creates parent directories if necessary
  }

  # Iterate through each URL and download GTFS file
  for (i in seq_along(urls)) {
    url <- urls[i]
    file <- files[i]
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
