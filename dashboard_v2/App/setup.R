# ============================================================
# Learning Poverty Dashboard — Package Setup
# Run this script once before launching the app
# ============================================================

packages <- c(
  "shiny",
  "shinydashboard",
  "tidyverse",
  "plotly",
  "scales",
  "bslib",          # modern Bootstrap 5 theming
  "DT",
  "ggplot2",
  "ggrepel",
  "rnaturalearth",  # world map geometries
  "rnaturalearthdata",
  "sf",             # spatial features
  "RColorBrewer",
  "webshot2",       # for PDF export (requires Chrome)
  "htmlwidgets",
  "shinyjs",
  "pagedown"        # chrome_print for PDF
)

installed <- rownames(installed.packages())
to_install <- setdiff(packages, installed)

if (length(to_install) > 0) {
  message("Installing: ", paste(to_install, collapse = ", "))
  install.packages(to_install, dependencies = TRUE)
} else {
  message("All packages already installed.")
}

# rnaturalearth large-scale data (run once)
if (!"rnaturalearthhires" %in% installed) {
  install.packages("rnaturalearthhires",
                   repos = "https://ropensci.r-universe.dev",
                   type  = "source")
}

message("Setup complete. Launch with: shiny::runApp('app.R')")
