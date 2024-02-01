#' Targets file
#' Author: Cole Brookson
#' Date: 20204-01-26

library(targets)
library(here)
library(crew)
library(crew.cluster)

source(here("./src/R/00_functions.R"))

controller_local <- crew.cluster::crew_controller_slurm(
  name = "small_slurm",
  seconds_timeout = 60,
  slurm_cpus_per_task = 1,
  workers = 1,
  slurm_time_minutes = 5,
  script_lines = c(
    "#SBATCH --partition=short",
    "#SBATCH --mem-per-cpu=2G",
    "#SBATCH --mail-user=cole.brookson@gmail.com",
    "#SBATCH --mail-type=BEGIN",
    "#SBATCH --mail-type=END",
    "#SBATCH --mail-type=FAIL",
    "#SBATCH --mail-type=REQUEUE",
    "#SBATCH --nodes=1",
    "#SBATCH --ntasks-per-node=32",
    "module load StdEnv/2023 gcc/9.3.0 r/4.3.1",
    "export R_LIBS=/home/brookson/scratch/.local/R/$EBVERSIONR/"
  )
)
controller_cluster <- crew.cluster::crew_controller_slurm(
  name = "bigger_slurm",
  workers = 4,
  seconds_timeout = 60,
  slurm_cpus_per_task = 4,
  slurm_memory_gigabytes_per_cpu = 20,
  slurm_time_minutes = 5
)
tar_option_set(
  packages = c("readr", "dplyr", "ggplot2", "rstanarm", "qs"),
  controller = crew::crew_controller_group(controller_local,
                                           controller_cluster),
  resources = tar_resources(
    crew = tar_resources_crew(controller = "small_slurm")
  ),
  garbage_collection = TRUE,
  memory = "transient"
)
list(
  tar_target(data, get_data(here::here("./data/airquality.csv"))),
  tar_target(model, fit_model(data)),
  tar_target(plot, plot_model(model, data)),
  tar_target(big, big_model(data),
             resources = tar_resources(
               crew = tar_resources_crew(controller = "bigger_slurm",
                                         seconds_timeout = 60)
             )),
  tar_target(plot_big, big_plot(big))
)
