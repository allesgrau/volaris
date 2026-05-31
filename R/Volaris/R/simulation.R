#' @useDynLib Volaris


#' @title
#' Geometric Brownian Motion path simulation
#'
#' @description
#' Simulates N_paths asset price paths under Geometric Brownian Motion.
#'
#' @param S0      numeric scalar: initial asset price
#' @param mu      numeric scalar: drift (annualized)
#' @param sigma   numeric scalar: volatility (annualized)
#' @param T       numeric scalar: time horizon (in years)
#' @param N_steps integer scalar: number of time steps
#' @param N_paths integer scalar: number of simulated paths
#'
#' @return
#' Returns a numeric matrix of dimensions N_steps x N_paths. Each column is one simulated path.
#'
#' @export
#'
#' @examples
#' paths <- gbm_paths(100, 0.05, 0.2, 1, 252, 1000)
gbm_paths <- function(S0, mu, sigma, T, N_steps, N_paths) {
    .Call("r_gbm_paths",
          as.double(S0), as.double(mu), as.double(sigma), as.double(T), as.integer(N_steps), as.integer(N_paths),
          PACKAGE = "Volaris")
}


#' @title
#' Geometric Brownian Motion path simulation with antithetic variates
#'
#' @description
#' Simulates N_paths asset price paths under Geometric Brownian Motion using antithetic variates for variance reduction.
#'
#' @param S0      numeric scalar: initial asset price
#' @param mu      numeric scalar: drift (annualized)
#' @param sigma   numeric scalar: volatility (annualized)
#' @param T       numeric scalar: time horizon (in years)
#' @param N_steps integer scalar: number of time steps
#' @param N_paths integer scalar: number of simulated paths
#'
#' @return
#' Returns a numeric matrix of dimensions N_steps x N_paths. Each column is one simulated path.
#'
#' @export
#'
#' @examples
#' paths <- gbm_paths_antithetic(100, 0.05, 0.2, 1, 252, 1000)
gbm_paths_antithetic <- function(S0, mu, sigma, T, N_steps, N_paths) {
    .Call("r_gbm_paths_antithetic",
          as.double(S0), as.double(mu), as.double(sigma), as.double(T), as.integer(N_steps), as.integer(N_paths),
          PACKAGE = "Volaris")
}