#' @useDynLib Volaris
"_PACKAGE"


#' @title
#' Black-Scholes option pricing
#'
#' @description
#' Computes the theoretical price of an option using the Black-Scholes formula.
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