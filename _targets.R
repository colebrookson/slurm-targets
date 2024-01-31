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
  seconds_timeout = 60
)
controller_cluster <- crew::crew_controller_local(
  name = "cluster_big",
  workers = 2,
  seconds_timeout = 60
)
tar_option_set(
  packages = c("readr", "dplyr", "ggplot2", "rstanarm", "qs"),
  controller = crew::crew_controller_group(controller_local,
                                           controller_cluster),
  resources = tar_resources(
    crew = tar_resources_crew(controller = "local_small")
  )
)
list(
  tar_target(data, get_data(here::here("./data/airquality.csv"))),
  tar_target(model, fit_model(data)),
  tar_target(plot, plot_model(model, data)),
  tar_target(big, big_model(data),
             resources = tar_resources(
               crew = tar_resources_crew(controller = "cluster_big",
                                         seconds_timeout = 60)
             )),
  tar_target(plot_big, big_plot(big))
)
