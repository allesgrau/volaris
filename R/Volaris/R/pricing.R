#' @useDynLib Volaris
"_PACKAGE"


#' @title
#' Black-Scholes option pricing
#'
#' @description
#' Computes the theoretical price of an European option using the Black-Scholes formula.
#'
#' @param S         numeric scalar: current price of the underlying asset
#' @param K         numeric scalar: strike price of the option
#' @param T         numeric scalar: time to expiration of the option (in years)
#' @param r         numeric scalar: risk-free interest rate (annualized)
#' @param sigma     numeric scalar: volatility of the underlying asset (annualized)
#' @param is_call   integer scalar: if 1, price a call option; if 0, price a put option
#'
#' @return
#' Returns a numeric scalar in the range (0, +inf) representing the price of the option.
#'
#' @export
#'
#' @examples
#' bs_price(100, 100, 1, 0.05, 0.2, 1)
#' stopifnot(bs_price(100, 100, 1, 0.05, 0.2, 0) > 0)
bs_price <- function(S, K, T, r, sigma, is_call) {
    .Call("r_bs_price",
            as.double(S), as.double(K), as.double(T), as.double(r), as.double(sigma), as.integer(is_call),
            PACKAGE = "Volaris")
} 


#' @title
#' Black-Scholes delta
#'
#' @description
#' Computes delta of an option: the first derivative of option price with respect to the underlying asset price (dV/dS).
#'
#' @param S         numeric scalar: current price of the underlying asset
#' @param K         numeric scalar: strike price of the option
#' @param T         numeric scalar: time to expiration of the option (in years)
#' @param r         numeric scalar: risk-free interest rate (annualized)
#' @param sigma     numeric scalar: volatility of the underlying asset (annualized)
#' @param is_call   integer scalar: if 1, compute delta for a call option; if 0, compute delta for a put option
#'
#' @return
#' Returns a numeric scalar in the range (-1, 1) representing the delta of the option.
#'
#' @export
#'
#' @examples
#' bs_delta(100, 100, 1, 0.05, 0.2, 1)
#' stopifnot(bs_delta(100, 100, 1, 0.05, 0.2, 0) > -1 && bs_delta(100, 100, 1, 0.05, 0.2, 0) < 1)
bs_delta <- function(S, K, T, r, sigma, is_call) {
    .Call("r_bs_delta",
            as.double(S), as.double(K), as.double(T), as.double(r), as.double(sigma), as.integer(is_call),
            PACKAGE = "Volaris")
}


#' @title
#' Black-Scholes gamma
#'
#' @description
#' Computes gamma of an option: the second derivative of option price with respect to the underlying asset price (d^2V/dS^2).
#'
#' @param S         numeric scalar: current price of the underlying asset
#' @param K         numeric scalar: strike price of the option
#' @param T         numeric scalar: time to expiration of the option (in years)
#' @param r         numeric scalar: risk-free interest rate (annualized)
#' @param sigma     numeric scalar: volatility of the underlying asset (annualized)
#'
#' @return
#' Returns a numeric scalar in the range (0, +inf) representing the gamma of the option.
#'
#' @export
#'
#' @examples
#' bs_gamma(100, 100, 1, 0.05, 0.2)
#' stopifnot(bs_gamma(100, 100, 1, 0.05, 0.2) > 0)
bs_gamma <- function(S, K, T, r, sigma) {
    .Call("r_bs_gamma",
            as.double(S), as.double(K), as.double(T), as.double(r), as.double(sigma),
            PACKAGE = "Volaris")
}


#' @title
#' Black-Scholes vega
#'
#' @description
#' Computes vega of an option: the first derivative of option price with respect to volatility (dV/dsigma).
#'
#' @param S         numeric scalar: current price of the underlying asset
#' @param K         numeric scalar: strike price of the option
#' @param T         numeric scalar: time to expiration of the option (in years)
#' @param r         numeric scalar: risk-free interest rate (annualized)
#' @param sigma     numeric scalar: volatility of the underlying asset (annualized)
#'
#' @return
#' Returns a numeric scalar in the range (0, +inf) representing the vega of the option.
#'
#' @export
#'
#' @examples
#' bs_vega(100, 100, 1, 0.05, 0.2)
#' stopifnot(bs_vega(100, 100, 1, 0.05, 0.2) > 0)
bs_vega <- function(S, K, T, r, sigma) {
    .Call("r_bs_vega",
            as.double(S), as.double(K), as.double(T), as.double(r), as.double(sigma),
            PACKAGE = "Volaris")
}


#' @title
#' Black-Scholes theta
#'
#' @description
#' Computes theta of an option: the first derivative of option price with respect to time to expiration (dV/dT).
#'
#' @param S         numeric scalar: current price of the underlying asset
#' @param K         numeric scalar: strike price of the option
#' @param T         numeric scalar: time to expiration of the option (in years)
#' @param r         numeric scalar: risk-free interest rate (annualized)
#' @param sigma     numeric scalar: volatility of the underlying asset (annualized)
#' @param is_call   integer scalar: if 1, compute theta for a call option; if 0, compute theta for a put option
#'
#' @return
#' Returns a numeric scalar in the range (-inf, 0) representing the theta of the option.
#'
#' @export
#'
#' @examples
#' bs_theta(100, 100, 1, 0.05, 0.2, 1)
#' stopifnot(bs_theta(100, 100, 1, 0.05, 0.2, 0) < 0)
bs_theta <- function(S, K, T, r, sigma, is_call) {
    .Call("r_bs_theta",
            as.double(S), as.double(K), as.double(T), as.double(r), as.double(sigma), as.integer(is_call),
            PACKAGE = "Volaris")
}


#' @title
#' Black-Scholes rho
#'
#' @description
#' Computes rho of an option: the first derivative of option price with respect to risk-free interest rate (dV/dr).
#' @param S         numeric scalar: current price of the underlying asset
#' @param K         numeric scalar: strike price of the option
#' @param T         numeric scalar: time to expiration of the option (in years)
#' @param r         numeric scalar: risk-free interest rate (annualized)
#' @param sigma     numeric scalar: volatility of the underlying asset (annualized)
#' @param is_call   integer scalar: if 1, compute rho for a call option; if 0, compute rho for a put option
#'
#' @return
#' Returns a numeric scalar in the range (-inf, +inf) representing the rho of the option.
#'
#' @export
#'
#' @examples
#' bs_rho(100, 100, 1, 0.05, 0.2, 1)
#' stopifnot(bs_rho(100, 100, 1, 0.05, 0.2, 0) < 0)
bs_rho <- function(S, K, T, r, sigma, is_call) {
    .Call("r_bs_rho",
            as.double(S), as.double(K), as.double(T), as.double(r), as.double(sigma), as.integer(is_call),
            PACKAGE = "Volaris")
}


#' @title
#' Binomial tree options pricing
#' 
#' @description
#' Computes the theoretical price of an option using a binomial tree model.
#' 
#' @param S             numeric scalar: current price of the underlying asset
#' @param K             numeric scalar: strike price of the option
#' @param T             numeric scalar: time to expiration of the option (in years)
#' @param r             numeric scalar: risk-free interest rate (annualized)
#' @param q             numeric scalar: continuous dividend yield of the underlying asset (annualized)
#' @param sigma         numeric scalar: volatility of the underlying asset (annualized)
#' @param N             integer scalar: number of steps in the binomial tree
#' @param is_call       integer scalar: if 1, price a call option; if 0, price a put option
#' @param is_american   integer scalar: if 1, price an American option; if 0, price a European option
#' 
#' @return
#' Returns a numeric scalar in the range (0, +inf) representing the price of the option.
#' 
#' @export
#' 
#' @examples
#' binomial_price(100, 100, 1, 0.05, 0.02, 0.2, 100, 1, 0)
#' stopifnot(binomial_price(100, 100, 1, 0.05, 0.02, 0.2, 100, 0, 1) > 0)
binomial_price <- function(S, K, T, r, q, sigma, N, is_call, is_american) {
    .Call("r_binomial_price",
            as.double(S), as.double(K), as.double(T), as.double(r), as.double(q), as.double(sigma), as.integer(N), as.integer(is_call), as.integer(is_american),
            PACKAGE = "Volaris")
}


#' @title
#' Heston stochastic volatility options pricing
#' 
#' @description
#' Computes the theoretical price of a European option using the Heston stochastic volatility model via characteristic function integration.
#' @param S       numeric scalar: current price of the underlying asset
#' @param K       numeric scalar: strike price of the option
#' @param T       numeric scalar: time to expiration of the option (in years)
#' @param r       numeric scalar: risk-free interest rate (annualized)
#' @param v0      numeric scalar: initial variance
#' @param kappa   numeric scalar: mean reversion speed of variance
#' @param theta   numeric scalar: long-run variance (mean reversion level)
#' @param xi      numeric scalar: volatility of variance
#' @param rho     numeric scalar: correlation between asset and variance processes
#' @param is_call integer scalar: if 1, price a call option; if 0, price a put option
#' 
#' @return
#' Returns a numeric scalar in the range (0, +inf) representing the price of the option.
#' 
#' @export
#' 
#' @examples
#' heston_price(100, 100, 1, 0.05, 0.04, 2, 0.04, 0.3, -0.7, 1)
heston_price <- function(S, K, T, r, v0, kappa, theta, xi, rho, is_call) {
    heston_price_r(as.double(S), as.double(K), as.double(T), as.double(r), as.double(v0), as.double(kappa), as.double(theta), as.double(xi), as.double(rho), as.integer(is_call))
}


#' @title
#' European options pricing via Monte Carlo simulation
#' 
#' @description
#' Computes the theoretical price of a European option using Monte Carlo with Geometric Brownian Motion paths.
#' @param S        numeric scalar: current price of the underlying asset
#' @param K        numeric scalar: strike price of the option
#' @param T        numeric scalar: time to expiration of the option (in years)
#' @param r        numeric scalar: risk-free interest rate (annualized)
#' @param sigma    numeric scalar: volatility of the underlying asset (annualized)
#' @param N_paths  integer scalar: number of simulated paths
#' @param is_call  integer scalar: if 1, price a call option; if 0, price a put option
#' 
#' @return
#' Returns a tuple of numeric scalars, both in the range (0, +inf), representing the price of the option and the standard error of the price estimate.
#' 
#' @export
#' 
#' @examples
#' mc_price_european(100, 100, 1, 0.05, 0.2, 10000, 1)
#' stopifnot(mc_price_european(100, 100, 1, 0.05, 0.2, 1000, 1)[1] > 0)
mc_price_european <- function(S, K, T, r, sigma, N_paths, is_call){
    .Call("r_mc_price_european",
            as.double(S), as.double(K), as.double(T), as.double(r), as.double(sigma), as.integer(N_paths), as.integer(is_call),
            PACKAGE = "Volaris")
}


#' @title
#' Asian options pricing via Monte Carlo simulation
#' 
#' @description
#' Computes the theoretical price of an Asian option using Monte Carlo based on the analysis of the arithmetic average price
#' @param S        numeric scalar: current price of the underlying asset
#' @param K        numeric scalar: strike price of the option
#' @param T        numeric scalar: time to expiration of the option (in years)
#' @param r        numeric scalar: risk-free interest rate (annualized)
#' @param sigma    numeric scalar: volatility of the underlying asset (annualized)
#' @param N_paths  integer scalar: number of simulated paths
#' @param N_steps  integer scalar: number of time steps per path
#' @param is_call  integer scalar: if 1, price a call option; if 0, price a put option
#' 
#' @return
#' Returns a numeric scalar in the range (0, +inf) representing the price of the option.
#' 
#' @export
#' 
#' @examples
#' mc_price_asian(100, 100, 1, 0.05, 0.2, 10000, 252, 1)
#' stopifnot(mc_price_asian(100, 100, 1, 0.05, 0.2, 1000, 52, 1) < mc_price_european(100, 100, 1, 0.05, 0.2, 1000, 1)[1])
mc_price_asian <- function(S, K, T, r, sigma, N_paths, N_steps, is_call){
    .Call("r_mc_price_asian",
            as.double(S), as.double(K), as.double(T), as.double(r), as.double(sigma), as.integer(N_paths), as.integer(N_steps), as.integer(is_call),
            PACKAGE = "Volaris")
}


#' @title
#' Knock-in / knock-out options pricing via Monte Carlo simulation
#' 
#' @description
#' Computes the theoretical price of a knock-in / knock-out option using Monte Carlo with Geometric Brownian Motion paths.
#' @param S             numeric scalar: current price of the underlying asset
#' @param K             numeric scalar: strike price of the option
#' @param T             numeric scalar: time to expiration of the option (in years)
#' @param r             numeric scalar: risk-free interest rate (annualized)
#' @param sigma         numeric scalar: volatility of the underlying asset (annualized)
#' @param N_paths       integer scalar: number of simulated paths
#' @param N_steps       integer scalar: number of time steps per path
#' @param B             numeric scalar: barrier level
#' @param is_upper      integer scalar: if 1, active when S >= B; if 0, active when S <= B
#' @param is_knockout   integer scalar: if 1, barrier deactivates option; if 0, barrier activates option
#' @param is_call       integer scalar: if 1, price a call option; if 0, price a put option
#' 
#' @return
#' Returns a numeric scalar in the range (0, +inf) representing the price of the option.
#' 
#' @export
#' 
#' @examples
#' mc_price_barrier(100, 100, 1, 0.05, 0.2, 10000, 252, 120, 1, 1, 1)
#' stopifnot(mc_price_barrier(100, 100, 1, 0.05, 0.2, 1000, 52, 120, 1, 1, 1) < mc_price_european(100, 100, 1, 0.05, 0.2, 1000, 1)[1])
mc_price_barrier <- function(S, K, T, r, sigma, N_paths, N_steps, B, is_upper, is_knockout, is_call){
    .Call("r_mc_price_barrier",
            as.double(S), as.double(K), as.double(T), as.double(r), as.double(sigma), as.integer(N_paths), as.integer(N_steps), as.double(B), as.integer(is_upper),
            as.integer(is_knockout), as.integer(is_call),
            PACKAGE = "Volaris")
}