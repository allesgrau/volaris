#' @useDynLib Volaris
"_PACKAGE"


#' @title 
#' Newton-Raphson root finding
#'
#' @description
#' Finds a root of f(x) = 0 using the Newton-Raphson method.
#'
#' @param f        function: scalar -> scalar whose root we seek
#' @param df       function: derivative of f
#' @param x0       numeric: initial guess of the root
#' @param tol      numeric: convergence tolerance (default 1e-10)
#' @param max_iter integer: maximum iterations (default 1000)
#'
#' @return 
#' Returns a numeric scalar representing the approximate root of f.
#'
#' @export
#'
#' @examples
#' rootfind_newton(function(x) x^2 - 2, function(x) 2*x, x0 = 1.5)
rootfind_newton <- function(f, df, x0, tol = 1e-10, max_iter = 1000L) {
    .Call("r_rootfind_newton",
          f, df, as.double(x0), as.double(tol), as.integer(max_iter),
          PACKAGE = "Volaris")
}


#' @title 
#' Bisection root finding
#'
#' @description
#' Finds a root of f(x) = 0 in [a, b] using bisection.
#'
#' @param f        function: scalar -> scalar whose root we seek
#' @param a        numeric: bracket left endpoint
#' @param b        numeric: bracket right endpoint
#' @param tol      numeric: convergence tolerance (default 1e-10)
#' @param max_iter integer: maximum iterations (default 1000)
#'
#' @return
#' Returns a numeric scalar representing the approximate root of f.
#'
#' @export
#'
#' @examples
#' rootfind_bisect(function(x) x^2 - 2, a = 1, b = 2)
rootfind_bisect <- function(f, a, b, tol = 1e-10, max_iter = 1000L) {
    .Call("r_rootfind_bisect",
          f, as.double(a), as.double(b), as.double(tol), as.integer(max_iter),
          PACKAGE = "Volaris")
}


#' @title 
#' Gauss quadrature integratinon
#'
#' @description
#' Integrates f over [a, b] using Gauss quadrature.
#'
#' @param f        function: scalar -> scalar whose integral we seek
#' @param a        numeric: bracket left endpoint
#' @param b        numeric: bracket right endpoint
#' @param n_points integer: number of quadrature points (default 10)
#'
#' @return
#' Returns a numeric scalar representing the approximate integral of f over [a, b].
#'
#' @export
#'
#' @examples
#' integrate_gauss(function(x) x^2, 0, 1, n_points = 5L)
integrate_gauss <- function(f, a, b, n_points = 10L) {
    .Call("r_integrate_gauss",
          f, as.double(a), as.double(b), as.integer(n_points),
          PACKAGE = "Volaris")
}


#' @title 
#' GSL QAGS adaptive integration
#'
#' @description
#' Integrates f over [a, b] using GSL QAGS adaptive quadrature.
#'
#' @param f   function: scalar -> scalar whose integral we seek
#' @param a   numeric: bracket left endpoint
#' @param b   numeric: bracket right endpoint
#' @param tol numeric: relative tolerance (default 1e-8)
#'
#' @return
#' Returns a numeric scalar representing the approximate integral of f over [a, b].
#'
#' @export
#'
#' @examples
#' integrate_gsl(function(x) x^2, 0, 1)
integrate_gsl <- function(f, a, b, tol = 1e-8) {
    .Call("r_integrate_gsl",
          f, as.double(a), as.double(b), as.double(tol),
          PACKAGE = "Volaris")
}