# Install required packages (once)
install.packages(c("shiny","readxl","dplyr","ggplot2","ggtext", "scales","rmarkdown","knitr"))

# For PDF export, also install TinyTeX
install.packages("tinytex")
tinytex::install_tinytex()


library(shiny)

# Insert your path in the line below. Remeber to use forwardslashes (/) instead of backslashes (\) in the path!
setwd("C:/Users/wb633382/OneDrive - WBG/Documents/GitHub/Learning_Poverty_Dashboard/proof_of_concept")
runApp("App")


