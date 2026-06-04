library(testthat)
library(Volaris)


# Root finding

test_that("rootfind_newton finds sqrt(2)", {
    root <- rootfind_newton(function(x) x^2 - 2, function(x) 2*x, x0 = 1.5)
    expect_equal(root, sqrt(2), tolerance = 1e-8)
})

test_that("rootfind_newton finds linear root", {
    root <- rootfind_newton(function(x) x - 7, function(x) 1, x0 = 0)
    expect_equal(root, 7, tolerance = 1e-10)
})

test_that("rootfind_newton finds cubic root", {
    root <- rootfind_newton(function(x) x^3 - x - 2, function(x) 3*x^2 - 1, x0 = 1.5)
    expect_equal(root^3 - root - 2, 0, tolerance = 1e-8)
})

test_that("rootfind_bisect finds sqrt(2)", {
    root <- rootfind_bisect(function(x) x^2 - 2, a = 1, b = 2)
    expect_equal(root, sqrt(2), tolerance = 1e-8)
})

test_that("rootfind_bisect finds pi via sin", {
    root <- rootfind_bisect(sin, a = 3, b = 4)
    expect_equal(root, pi, tolerance = 1e-8)
})

test_that("rootfind_bisect returns NaN for invalid bracket", {
    expect_true(is.nan(rootfind_bisect(function(x) x^2 + 1, a = -2, b = 2)))
})

test_that("rootfind_newton and rootfind_bisect agree", {
    f <- function(x) x^3 - 2*x - 5
    df <- function(x) 3*x^2 - 2
    expect_equal(rootfind_newton(f, df, x0 = 2), rootfind_bisect(f, a = 2, b = 3), tolerance = 1e-6)
})


# Integration

test_that("integrate_gauss: x^2 on [0,1] = 1/3", {
    expect_equal(integrate_gauss(function(x) x^2, 0, 1, n_points = 5L), 1/3, tolerance = 1e-10)
})

test_that("integrate_gauss: sin on [0,pi] = 2", {
    expect_equal(integrate_gauss(sin, 0, pi, n_points = 10L), 2, tolerance = 1e-10)
})

test_that("integrate_gauss: exp on [0,1] = e-1", {
    expect_equal(integrate_gauss(exp, 0, 1, n_points = 10L), exp(1) - 1, tolerance = 1e-10)
})

test_that("integrate_gauss: more points improves accuracy", {
    f <- function(x) sin(5*x) * exp(-x)
    ref <- integrate_gsl(f, 0, pi)
    err5 <- abs(integrate_gauss(f, 0, pi, n_points = 5L)  - ref)
    err30 <- abs(integrate_gauss(f, 0, pi, n_points = 30L) - ref)
    expect_lt(err30, err5)
})

test_that("integrate_gsl: x^2 on [0,1] = 1/3", {
    expect_equal(integrate_gsl(function(x) x^2, 0, 1), 1/3, tolerance = 1e-8)
})

test_that("integrate_gsl: sin on [0,pi] = 2", {
    expect_equal(integrate_gsl(sin, 0, pi), 2, tolerance = 1e-8)
})

test_that("integrate_gsl: exp on [0,1] = e-1", {
    expect_equal(integrate_gsl(exp, 0, 1), exp(1) - 1, tolerance = 1e-8)
})

test_that("integrate_gsl agrees with integrate_gauss", {
    f <- function(x) exp(-x^2)
    expect_equal(integrate_gauss(f, 0, 3, n_points = 30L), integrate_gsl(f, 0, 3), tolerance = 1e-8)
})