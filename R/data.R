#' General Transit Feed Specification (GTFS) Dataset
#'
#' This dataset contains information about GTFS files from various
#' public transportation agencies around the world, including URLs for downloading
#' static GTFS data.
#'
#' @format ## `GTFS_df`
#' A data frame with 1,846 rows and 8 columns:
#' \describe{
#'   \item{provider}{The name of the transportation agency}
#'   \item{location}{The location of the service provided}
#'   \item{urls.latest}{URL for the latest GTFS feed data}
#'   \item{urls.URL}{Alternative URL for the GTFS feed data}
#'   \item{urls.authentication_info}{Information about authentication requirements (API keys, etc.)}
#'   \item{data_type}{The type of GTFS data available (either "gtfs" for static or "gtfs-rt" for real-time)}
#'   \item{geometry}{Geospatial data representing the service area}
#' }
#' @source Mobility Database via <https://bit.ly/catalogs-csv>
"GTFS_df"
