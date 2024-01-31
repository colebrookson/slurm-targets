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
  rstanarm::stan_glmer(Ozone ~ Temp + Wind + Solar.R + (1|Month),
    data = data,
    iter = 10000,
    chains = 4,
    cores = 4,
    adapt_delta = 0.999,
    control = list(max_treedepth = 15)
  )
}

big_plot <- function(big_model) {
  bayesplot::color_scheme_set("purple")
  p <- bayesplot::mcmc_areas(big_model, pars = c("Temp", "Wind"))

  ggplot2::ggsave(here::here("./figs/big_plot.png"), p)
}