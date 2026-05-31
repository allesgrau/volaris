library(testthat)
library(Volaris)


S0 <- 100; mu <- 0.05; sigma <- 0.2; T <- 1.0


# GBM

test_that("gbm_paths returns correct dimensions", {
    paths <- gbm_paths(S0, mu, sigma, T, 252L, 1000L)
    expect_equal(dim(paths), c(252L, 1000L))
})

test_that("gbm_paths are all positive", {
    paths <- gbm_paths(S0, mu, sigma, T, 252L, 1000L)
    expect_true(all(paths > 0))
})

test_that("gbm_paths_antithetic returns correct dimensions", {
    paths <- gbm_paths_antithetic(S0, mu, sigma, T, 252L, 1000L)
    expect_equal(dim(paths), c(252L, 1000L))
})

test_that("gbm_paths_antithetic pairs sum to 2*drift", {
    paths <- gbm_paths_antithetic(S0, mu, sigma, T, 252L, 1000L)
    log_r1 <- log(paths[252, 1:500] / S0)
    log_r2 <- log(paths[252, 501:1000] / S0)
    expected <- 2 * (mu - 0.5 * sigma^2) * T
    expect_equal(mean(log_r1 + log_r2), expected, tolerance = 0.05)
})

test_that("gbm_paths_antithetic errors on odd N_paths", {
    expect_error(gbm_paths_antithetic(S0, mu, sigma, T, 252L, 999L))
})