#' Title: Some simple functions to use
#' Author: Cole Brookson
#' Date: 20204-01-26

get_data <- function(file) {
  read_csv(file, col_types = cols()) %>%
    filter(!is.na(Ozone))
}

fit_model <- function(data) {
  lm(Ozone ~ Temp, data) %>%
    coefficients()
}

plot_model <- function(model, data) {
  ggplot(data) +
    geom_point(aes(x = Temp, y = Ozone)) +
    geom_abline(intercept = model[1], slope = model[2])
}

big_model <- function(data) {
  rstanarm::stam_lm(Ozone ~ Temp + Wind + Solar.R + Month + Day,
    data = data,
    iter = 10000,
    chains = 4,
    cores = 4
  ) %>%
    qs::qsave(here::here("./outputs/big_model.qs"))
}
