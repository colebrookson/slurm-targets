#' Targets file
#' Author: Cole Brookson
#' Date: 20204-01-26

library(targets)
library(here)
library(crew)
library(crew.cluster)

source(here("./src/R/00_functions.R"))

controller_local <- crew::crew_controller_local(
  name = "local_small",
  workers = 1,
  seconds_idle = 10
)
controller_cluster <- crew::crew_controller_local(
  name = "cluster_big",
  workers = 4,
  seconds_idle = 10
)
tar_option_set(
  packages = c("readr", "dplyr", "ggplot2", "rstanarm", "qs"),
  controller = crew_controller_group(controller_local, controller_cluster),
  resources = tar_resources(
    crew = tar_resources_crew(controller = "local_small")
  )
)
list(
  tar_target(file, here("./data/airquality.csv"), format = "file"),
  tar_target(data, get_data(file)),
  tar_target(model, fit_model(data)),
  tar_target(plot, plot_model(model, data)),
  tar_target(big, big_model(data),
             resources = tar_resources(
               crew = tar_resources_crew(controller = "cluster_big")
             )),
  tar_target(plot_big, big_plot(big))
)
