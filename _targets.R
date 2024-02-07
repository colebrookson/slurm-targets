#' Targets file
#' Author: Cole Brookson
#' Date: 20204-01-26

library(targets)
library(here)
library(crew)
library(crew.cluster)

source(here("./src/R/00_functions.R"))

controller_small <- crew.cluster::crew_controller_slurm(
  name = "small_slurm",
  slurm_time_minutes = 5,
  seconds_idle = 600,
  tasks_max = 10,
  script_lines = c(
    "#SBATCH --mem-per-cpu=8G",
    "#SBATCH --mail-user=cole.brookson@gmail.com",
    "#SBATCH --account=def-bat3man",
    "#SBATCH --mail-type=BEGIN",
    "#SBATCH --mail-type=END",
    "#SBATCH --mail-type=FAIL",
    "#SBATCH --mail-type=REQUEUE",
    "#SBATCH --cpus-per-task=1",
    "module load StdEnv/2023 r/4.3.1"
  ),
  slurm_log_output = "/home/brookson/scratch/output.txt",
  slurm_log_error = "/home/brookson/scratch/error.txt",
  script_directory = "/home/brookson/scratch/script.txt"
)
# controller_big <- crew.cluster::crew_controller_slurm(
#   name = "bigger_slurm",
#   workers = 4,
#   slurm_cpus_per_task = 4,
#   slurm_time_minutes = 10,
#   seconds_idle = 600,
#   script_lines = c(
#     "#SBATCH --mem-per-cpu=6G",
#     "#SBATCH --mail-user=cole.brookson@gmail.com",
#     "#SBATCH --account=def-bat3man",
#     "#SBATCH --mail-type=BEGIN",
#     "#SBATCH --mail-type=END",
#     "#SBATCH --mail-type=FAIL",
#     "#SBATCH --mail-type=REQUEUE",
#     "#SBATCH --nodes=1",
#     "#SBATCH --ntasks-per-node=4",
#     "module load StdEnv/2023 r/4.3.1"
#   ),
#   slurm_log_output = "/home/brookson/scratch/big-output.txt",
#   slurm_log_error = "/home/brookson/scratch/big-error.txt",
# )
# controller <- crew::crew_controller_group(controller_small,
#                                            controller_big) 
tar_option_set(
  packages = c("readr", "dplyr", "ggplot2", "rstanarm", "qs"),
  controller = controller_small,
  resources = tar_resources(
    crew = tar_resources_crew(controller = "small_slurm")
  ),
  garbage_collection = TRUE,
  memory = "transient",
  storage = "worker",
  retrieval = "worker"
)

list(
  tar_target(data, get_data(here::here("./data/airquality.csv"))),
  tar_target(model, fit_model(data)),
  tar_target(plot, plot_model(model, data))
  # tar_target(big, big_model(data)
  # #,
  #           #  resources = tar_resources(
  #           #    crew = tar_resources_crew(controller = "bigger_slurm",
  #           #                              seconds_timeout = 60)
  #           #  )
  #           ),
  # tar_target(plot_big, big_plot(big))
)
