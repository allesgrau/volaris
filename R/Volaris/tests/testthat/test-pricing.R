library(testthat)
library(Volaris)


S <- 100; K <- 100; T <- 1; r <- 0.05; sigma <- 0.2; q <- 0.0
v0 <- 0.04; kappa <- 2; theta_h <- 0.04; xi <- 0.3; rho_h <- -0.8


# Black-Scholes

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


# Binomial tree

test_that("binomial call is positive", {
  expect_gt(binomial_price(S, K, T, r, q, sigma, 200, 1, 0), 0)
})

test_that("binomial put is positive", {
  expect_gt(binomial_price(S, K, T, r, q, sigma, 200, 0, 0), 0)
})

test_that("binomial European call converges to BS", {
  expect_equal(binomial_price(S, K, T, r, q, sigma, 500, 1, 0), bs_price(S, K, T, r, sigma, 1), tolerance = 0.05)
})

test_that("American put >= European put", {
  expect_gte(binomial_price(S, K, T, r, q, sigma, 200, 0, 1), binomial_price(S, K, T, r, q, sigma, 200, 0, 0))
})

test_that("binomial put-call parity holds (European)", {
  call <- binomial_price(S, K, T, r, q, sigma, 500, 1, 0)
  put <- binomial_price(S, K, T, r, q, sigma, 500, 0, 0)
  expect_lt(abs(call - put - (S - K * exp(-r * T))), 0.1)
})


# Heston

test_that("heston_price call is positive", {
  expect_gt(heston_price(S, K, T, r, v0, kappa, theta_h, xi, rho_h, 1), 0)
})

test_that("heston_price put is positive", {
  expect_gt(heston_price(S, K, T, r, v0, kappa, theta_h, xi, rho_h, 0), 0)
})

test_that("heston put-call parity holds", {
  call <- heston_price(S, K, T, r, v0, kappa, theta_h, xi, rho_h, 1)
  put  <- heston_price(S, K, T, r, v0, kappa, theta_h, xi, rho_h, 0)
  expect_equal(call - put, S - K * exp(-r * T), tolerance = 1e-4)
})


# Monte Carlo

test_that("mc_price_european returns two values", {
  expect_length(mc_price_european(S, K, T, r, sigma, 1000, 1), 2)
})

test_that("mc_price_european call is positive", {
  expect_gt(mc_price_european(S, K, T, r, sigma, 10000, 1)[1], 0)
})

test_that("mc_price_european std error is positive", {
  expect_gt(mc_price_european(S, K, T, r, sigma, 1000, 1)[2], 0)
})

test_that("mc_price_european approximates BS", {
  result <- mc_price_european(S, K, T, r, sigma, 100000, 1)
  expect_equal(result[1], bs_price(S, K, T, r, sigma, 1), tolerance = 5 * result[2])
})

test_that("mc_price_asian call is positive", {
  expect_gt(mc_price_asian(S, K, T, r, sigma, 10000, 252, 1), 0)
})

test_that("mc_price_asian <= mc_price_european", {
  asian <- mc_price_asian(S, K, T, r, sigma, 50000, 252, 1)
  vanilla <- mc_price_european(S, K, T, r, sigma, 50000, 1)[1]
  expect_lte(asian, vanilla)
})

test_that("mc_price_barrier knockout call is positive", {
  expect_gt(mc_price_barrier(S, K, T, r, sigma, 10000, 252, 120, 1, 1, 1), 0)
})

test_that("mc_price_barrier knockout <= vanilla", {
  knockout <- mc_price_barrier(S, K, T, r, sigma, 50000, 252, 120, 1, 1, 1)
  vanilla <- mc_price_european(S, K, T, r, sigma, 50000, 1)[1]
  expect_lte(knockout, vanilla)
})