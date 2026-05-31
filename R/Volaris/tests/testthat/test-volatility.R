library(testthat)
library(Volaris)


prices <- c(100, 101, 99, 102, 100.5, 103, 101.5, 104, 102, 105)
returns <- diff(log(prices))
high <- c(101, 102, 103, 104, 105, 106, 107, 108, 109)
low <- c( 99, 100, 101, 102, 103, 104, 105, 106, 107)
open <- c(100, 101, 102, 103, 104, 105, 106, 107, 108)
close <- c(100.5, 101.5, 102.5, 103.5, 104.5, 105.5, 106.5, 107.5, 108.5)
n <- length(high)
garch_returns <- c(0.01, -0.02, 0.015, -0.005, 0.008, -0.012, 0.003, 0.018, -0.007, 0.011, -0.009, 0.014, -0.006, 0.002, 0.019, -0.013, 0.007, -0.004, 0.016, -0.001)


# Historical volatility

test_that("vol_close_to_close is positive", {
    expect_gt(vol_close_to_close(returns, length(returns)), 0)
})

test_that("vol_parkinson is positive", {
    expect_gt(vol_parkinson(high, low, n), 0)
})

test_that("vol_garman_klass is positive", {
    expect_gt(vol_garman_klass(open, high, low, close, n), 0)
})

test_that("vol_yang_zhang is positive", {
    expect_gt(vol_yang_zhang(open, high, low, close, n), 0)
})


# GARCH(1, 1)

test_that("garch_fit returns a list with expected fields", {
    result <- garch_fit(garch_returns)
    expect_type(result, "list")
    expect_true(all(c("omega", "alpha", "beta", "log_likelihood", "converged", "persistence") %in% names(result)))
})

test_that("garch_fit persistence < 1 when converged", {
    result <- garch_fit(garch_returns)
    if (result$converged) expect_lt(result$persistence, 1)
})

test_that("garch_variances has correct length", {
    fit <- garch_fit(garch_returns)
    expect_length(garch_variances(fit$omega, fit$alpha, fit$beta, garch_returns), length(garch_returns))
})

test_that("garch_variances are positive", {
    fit <- garch_fit(garch_returns)
    expect_true(all(garch_variances(fit$omega, fit$alpha, fit$beta, garch_returns) > 0))
})

test_that("garch_forecast has correct length", {
    fit <- garch_fit(garch_returns)
    expect_length(garch_forecast(fit$omega, fit$alpha, fit$beta, garch_returns, 5L), 5)
})

test_that("garch_forecast are positive", {
    fit <- garch_fit(garch_returns)
    expect_true(all(garch_forecast(fit$omega, fit$alpha, fit$beta, garch_returns, 5L) > 0))
})


# Implied volatility

test_that("implied_vol call", {
    price <- bs_price(100, 100, 1, 0.05, 0.2, 1)
    expect_equal(implied_vol(price, 100, 100, 1, 0.05, 1), 0.2, tolerance = 1e-6)
})

test_that("implied_vol put", {
    price <- bs_price(100, 110, 0.5, 0.03, 0.3, 0)
    expect_equal(implied_vol(price, 100, 110, 0.5, 0.03, 0), 0.3, tolerance = 1e-6)
})

test_that("implied_vol OTM call", {
    price <- bs_price(100, 120, 1, 0.05, 0.25, 1)
    expect_equal(implied_vol(price, 100, 120, 1, 0.05, 1), 0.25, tolerance = 1e-6)
})

test_that("implied_vol high volatility", {
    price <- bs_price(100, 100, 1, 0.05, 0.8, 1)
    expect_equal(implied_vol(price, 100, 100, 1, 0.05, 1), 0.8, tolerance = 1e-6)
})

test_that("implied_vol returns NaN for impossible price", {
    expect_true(is.nan(implied_vol(0, 100, 100, 1, 0.05, 1)))
})