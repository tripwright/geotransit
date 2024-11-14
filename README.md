# GeoTransit

GeoTransit is an R package designed to simplify working with geographic and transportation data. With GeoTransit, you can seamlessly integrate spatial data with transit networks to analyze urban mobility, transportation access, and infrastructure planning.

## Table of Contents

-   [Installation](#installation)
-   [Overview](#overview)
-   [Quick Start](#quick-start)
-   [Main Functions](#main-functions)
-   [Example Usage](#example-usage)
-   [Contributing](#contributing)
-   [License](#license)

## Installation {#installation}

You can install the development version of `geotransit` directly from GitHub:

``` r
# Install devtools if you haven't already
install.packages("devtools")

# Install geotransit from GitHub
devtools::install_github("tripwright/geotransit")
```

## Overview {#overview}

The `geotransit` package provides tools for:

-   **Download and manage GTFS data:** Retrieve static and real-time GTFS (General Transit Feed Specification) feeds for specified geographic areas.
-   **Integrate spatial and transportation data:** Analyze public transportation coverage and accessibility in any region by spatially intersecting GTFS datasets with user-defined geographies.
-   **Support urban transportation research:** Simplify workflows in urban planning, transportation analysis, and accessibility studies.

This package simplifies workflows for users interested in analyzing public transportation systems, accessibility, and urban infrastructure planning.

## Quick Start {#quick-start}

To start using `geotransit`, load the package and specify a geographic region as an `sf` object. Use the `sf2GTFS()` function to retrieve GTFS feeds for transit routes within your defined area.

## Main Functions {#main-functions}

-   **`sf2GTFS()`**: Downloads GTFS feeds for all transit routes within a specified geographic region defined by an `sf` object. Saves the feeds to a designated directory.

## Example Usage {#example-usage}

Here is a quick example using `sf2GTFS()` to download GTFS data for a specified area.

``` r
# Load libraries
library(sf)
library(geotransit)

# Define a spatial area as an sf object (e.g., a city boundary shapefile)
my_area <- st_read("path/to/shapefile.shp")

# Specify the output directory for downloaded GTFS files
output_directory <- "path/to/save/gtfs/files"

# Download GTFS feeds for the defined area
sf2GTFS(my_area, output_directory)
```

## Contributing {#contributing}

Contributions to GeotTransit are welcome! Please open an issue if you encounter any problems or have feature suggestions, and feel free to submit pull requests.

## License {#license}

This package is licensed under the GPL-3 license.

## Contact

For any questions or feedback, please contact me on GitHub.
