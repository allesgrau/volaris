#' @importFrom Rcpp evalCpp


#' @title
#' GARCH(1,1) parameter calibration
#'
#' @description
#' Fits a GARCH(1,1) model to a historical return series via maximum likelihood estimation using the Nelder-Mead optimizer.
#'
#' @param returns   numeric vector: log-return series
#'
#' @return
#' Returns a list with elements: omega, alpha, beta, log_likelihood, converged, persistence.
#'
#' @export
#'
#' @examples
#' r <- diff(log(c(100, 101, 99, 102, 98, 103)))
#' garch_fit(r)
garch_fit <- function(returns) {
    garch11_fit_r(as.numeric(returns))
}


#' @title
#' GARCH(1,1) historical conditional variances calculation
#'
#' @description
#' Computes conditional variances of the historical data from fitted GARCH(1,1) parameters.
#'
#' @param omega     numeric scalar: omega parameter from garch_fit()
#' @param alpha     numeric scalar: alpha parameter from garch_fit()
#' @param beta      numeric scalar: beta parameter from garch_fit()
#' @param returns   numeric vector: original return series
#'
#' @return
#' Returns a numeric vector of length equal to returns with conditional variances.
#'
#' @export
#'
#' @examples
#' r <- diff(log(c(100, 101, 99, 102, 98, 103)))
#' fit <- garch_fit(r)
#' garch_variances(fit$omega, fit$alpha, fit$beta, r)
garch_variances <- function(omega, alpha, beta, returns) {
    garch11_variances_r(as.double(omega), as.double(alpha), as.double(beta), as.numeric(returns))
}


#' @title
#' GARCH(1,1) conditional variances forecasting
#'
#' @description
#' Computes conditional variance forecasts from fitted GARCH(1,1) parameters.
#'
#' @param omega     numeric scalar: omega parameter from garch_fit()
#' @param alpha     numeric scalar: alpha parameter from garch_fit()
#' @param beta      numeric scalar: beta parameter from garch_fit()
#' @param returns   numeric vector: original return series
#' @param h         integer scalar: forecast horizon (steps ahead)
#'
#' @return
#' Returns a numeric vector of length h with conditional variance forecasts.
#'
#' @export
#'
#' @examples
#' r <- diff(log(c(100, 101, 99, 102, 98, 103)))
#' fit <- garch_fit(r)
#' garch_forecast(fit$omega, fit$alpha, fit$beta, r, 10)
garch_forecast <- function(omega, alpha, beta, returns, h) {
    garch11_forecast_r(as.double(omega), as.double(alpha), as.double(beta), as.numeric(returns), as.integer(h))
}


#' @title
#' Close-to-close historical volatility calculation
#' 
#' @description 
#' Computes annualized volatility from log-returns (standard deviation estimator).
#' 
#' @param returns  numeric vector: log-return series
#' @param n        integer scalar: number of observations
#' 
#' @return
#' Returns a numeric scalar representing annualized volatility.
#' 
#' @export
#' 
#' @examples
#' r <- diff(log(c(100,102,99,103,101,98,104)))
#' vol_close_to_close(r, length(r))
vol_close_to_close <- function(returns, n) {
    .Call("r_vol_close_to_close", 
          as.double(returns), as.integer(n), 
          PACKAGE = "Volaris")
}


#' @title
#' Parkinson volatility calculation
#' 
#' @description 
#' Computes annualized volatility from high/low prices.
#' 
#' @param high     numeric vector: daily high prices
#' @param low      numeric vector: daily low prices
#' @param n        integer scalar: number of observations
#' 
#' @return
#' Returns a numeric scalar representing annualized volatility.
#' 
#' @export
#' 
#' @examples
#' vol_parkinson(c(102,101,104), c(99,98,100), 3)
vol_parkinson <- function(high, low, n) {
    .Call("r_vol_parkinson", 
          as.double(high), as.double(low), as.integer(n), 
          PACKAGE = "Volaris")
}


#' @title
#' Garman-Klass historical volatility calculation
#' 
#' @description 
#' Computes annualized volatility from open/close and high/low prices.
#' 
#' @param high     numeric vector: daily high prices
#' @param low      numeric vector: daily low prices
#' @param open     numeric vector: daily open prices
#' @param close    numeric vector: daily close prices
#' @param n        integer scalar: number of observations
#' 
#' @return
#' Returns a numeric scalar representing annualized volatility.
#' 
#' @export
#' 
#' @examples
#' vol_garman_klass(c(100,101,102), c(103,104,105), c(98,99,100), c(102,103,104), 3)
vol_garman_klass <- function(open, high, low, close, n) {
    .Call("r_vol_garman_klass", 
          as.double(open), as.double(high), as.double(low), as.double(close), as.integer(n), 
          PACKAGE = "Volaris")
}


#' @title
#' Yang-Zhang historical volatility calculation
#' 
#' @description 
#' Computes annualized volatility from open/close and high/low prices. Most efficient estimator.
#' 
#' @param high     numeric vector: daily high prices
#' @param low      numeric vector: daily low prices
#' @param open     numeric vector: daily open prices
#' @param close    numeric vector: daily close prices
#' @param n        integer scalar: number of observations
#' 
#' @return
#' Returns a numeric scalar representing annualized volatility.
#' 
#' @export
#' 
#' @examples
#' vol_yang_zhang(c(100,101,102), c(103,104,105), c(98,99,100), c(102,103,104), 3)
vol_yang_zhang <- function(open, high, low, close, n) {
    .Call("r_vol_yang_zhang", 
          as.double(open), as.double(high), as.double(low), as.double(close), as.integer(n), 
          PACKAGE = "Volaris")
  }