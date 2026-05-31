library(testthat)
library(Volaris)


S0 <- 100; mu <- 0.05; sigma <- 0.2; T <- 1.0
returns_mcmc <- diff(log(c(100,101,99,102,100.5,103,101.5,104,102,105)))


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


# Metropolis-Hastings

test_that("mh_sampler_gbm returns correct dimensions", {
    samples <- mh_sampler_gbm(returns_mcmc, 1000L, 200L, 0.005, 0.005)
    expect_equal(dim(samples), c(800L, 2L))
})

test_that("mh_sampler_gbm sigma samples are positive", {
    samples <- mh_sampler_gbm(returns_mcmc, 1000L, 200L, 0.005, 0.005)
    expect_true(all(samples[, "sigma"] > 0))
})

test_that("mh_sampler_gbm posterior mean sigma is reasonable", {
    samples <- mh_sampler_gbm(returns_mcmc, 5000L, 1000L, 0.005, 0.005)
    expect_gt(mean(samples[, "sigma"]), 0)
    expect_lt(mean(samples[, "sigma"]), 10)
})


# Merton model

test_that("merton_paths returns correct dimensions", {
    paths <- merton_paths(100, 0.05, 0.2, 1.0, -0.1, 0.15, 1, 252L, 1000L)
    expect_equal(dim(paths), c(252L, 1000L))
})

test_that("merton_paths are all positive", {
    paths <- merton_paths(100, 0.05, 0.2, 1.0, -0.1, 0.15, 1, 252L, 1000L)
    expect_true(all(paths > 0))
})

test_that("merton_paths lambda=0 mean at T approximates S0*exp(mu*T)", {
    paths <- merton_paths(100, 0.05, 0.2, 0.0, 0.0, 0.0, 1, 252L, 50000L)
    expect_equal(mean(paths[252, ]), 100 * exp(0.05), tolerance = 1)
})

test_that("merton_paths jumps increase variance vs pure GBM", {
    pure  <- merton_paths(100, 0.05, 0.2, 0.0, 0.0, 0.0, 1, 252L, 10000L)
    jumpy <- merton_paths(100, 0.05, 0.2, 5.0, 0.0, 0.15, 1, 252L, 10000L)
    expect_gt(var(jumpy[252, ]), var(pure[252, ]))
})