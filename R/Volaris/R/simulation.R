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

#' @title
#' GBM parameter calibration via Metropolis-Hastings MCMC
#'
#' @description
#' Calibrates mu and sigma of a Geometric Brownian Motion model from a log-return series using the Metropolis-Hastings algorithm.
#'
#' @param returns           numeric vector: log-return series
#' @param n_iter            integer scalar: total MCMC iterations
#' @param n_burning         integer scalar: burn-in iterations to discard
#' @param proposal_mu       numeric scalar: random walk step size for mu
#' @param proposal_sigma    numeric scalar: random walk step size for sigma
#' @param mu_init           numeric scalar: initial value of mu (default 0)
#' @param sigma_init        numeric scalar: initial value of sigma (default 0.2)
#' @param dt                numeric scalar: time step between observations (default 1/252)
#'
#' @return
#' Returns a numeric matrix of dimensions (n_iter - n_burnin) x 2. Columns are mu and sigma.
#'
#' @export
#'
#' @examples
#' r <- diff(log(c(100,101,99,102,100.5,103,101.5,104,102,105)))
#' samples <- mh_sampler_gbm(r, 2000L, 500L, 0.005, 0.005)
mh_sampler_gbm <- function(returns, n_iter, n_burning, proposal_mu = 0.005, proposal_sigma = 0.005, mu_init = 0.0, sigma_init = 0.2, dt = 1/252) {
    result <- .Call("r_mh_sampler_gbm",
                    as.double(returns), as.integer(n_iter), as.integer(n_burning), as.double(proposal_mu), as.double(proposal_sigma), as.double(mu_init), as.double(sigma_init), as.double(dt),
                    PACKAGE = "Volaris")
    colnames(result) <- c("mu", "sigma")
    result
}


#' @title
#' Merton jump-diffusion path simulation
#'
#' @description
#' Simulates asset price paths under the Merton jump-diffusion model: GBM with compound Poisson jumps.
#'
#' @param S0      numeric scalar: initial asset price
#' @param mu      numeric scalar: drift (annualized)
#' @param sigma   numeric scalar: diffusion volatility (annualized)
#' @param lambda  numeric scalar: jump intensity (jumps per year)
#' @param mu_j    numeric scalar: mean log-jump size
#' @param sigma_j numeric scalar: std of log-jump size
#' @param T       numeric scalar: time horizon (in years)
#' @param N_steps integer scalar: number of time steps
#' @param N_paths integer scalar: number of simulated paths
#'
#' @return
#' Returns a numeric matrix of dimensions N_steps x N_paths. Each column is one path.
#'
#' @export
#'
#' @examples
#' paths <- merton_paths(100, 0.05, 0.2, 1, -0.1, 0.15, 1, 252, 1000)
merton_paths <- function(S0, mu, sigma, lambda, mu_j, sigma_j, T, N_steps, N_paths) {
    .Call("r_merton_paths",
          as.double(S0), as.double(mu), as.double(sigma), as.double(lambda), as.double(mu_j), as.double(sigma_j), as.double(T), as.integer(N_steps), as.integer(N_paths),
          PACKAGE = "Volaris")
}