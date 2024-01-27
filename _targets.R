#' Targets file
#' Author: Cole Brookson
#' Date: 20204-01-26

library(targets)
library(here)
library(crew.cluster)

source(here("./src/R/00_functions.R"))
tar_option_set(packages = c("readr", "dplyr", "ggplot2", "rstanarm", "qs"))
list(
  tar_target(file, here("./data/airquality.csv"), format = "file"),
  tar_target(data, get_data(file)),
  tar_target(model, fit_model(data)),
  tar_target(plot, plot_model(model, data)),
  tar_target(big, big_model(data))
)
