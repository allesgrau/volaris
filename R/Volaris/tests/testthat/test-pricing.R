library(testthat)
library(Volaris)


S <- 100; K <- 100; T <- 1; r <- 0.05; sigma <- 0.2


test_that("bs_price call is correct", {
  expect_equal(bs_price(S, K, T, r, sigma, 1), 10.4506, tolerance = 1e-3)
})

test_that("bs_price put is correct", {
  expect_equal(bs_price(S, K, T, r, sigma, 0), 5.5735, tolerance = 1e-3)
})

test_that("bs put-call parity holds", {
  expect_equal(
    bs_price(S, K, T, r, sigma, 1) - bs_price(S, K, T, r, sigma, 0),
    S - K * exp(-r * T),
    tolerance = 1e-9
  )
})

test_that("bs_delta call is in (0, 1)", {
  d <- bs_delta(S, K, T, r, sigma, 1)
  expect_gt(d, 0)
  expect_lt(d, 1)
})

test_that("bs_delta put is in (-1, 0)", {
  d <- bs_delta(S, K, T, r, sigma, 0)
  expect_gt(d, -1)
  expect_lt(d, 0)
})

test_that("bs_delta put-call parity holds", {
  expect_equal(
    bs_delta(S, K, T, r, sigma, 1) - bs_delta(S, K, T, r, sigma, 0),
    1.0,
    tolerance = 1e-9
  )
})

test_that("bs_gamma is positive", {
  expect_gt(bs_gamma(S, K, T, r, sigma), 0)
})

test_that("bs_vega is positive", {
  expect_gt(bs_vega(S, K, T, r, sigma), 0)
})

test_that("bs_theta call is negative", {
  expect_lt(bs_theta(S, K, T, r, sigma, 1), 0)
})

test_that("bs_theta put is negative", {
  expect_lt(bs_theta(S, K, T, r, sigma, 0), 0)
})

test_that("bs_rho call is positive", {
  expect_gt(bs_rho(S, K, T, r, sigma, 1), 0)
})

test_that("bs_rho put is negative", {
  expect_lt(bs_rho(S, K, T, r, sigma, 0), 0)
})