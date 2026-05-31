import math
import pytest
import numpy as np

from volaris import (
    gbm_paths, gbm_paths_antithetic,
    mh_sampler_gbm,
    merton_paths,
)


S0, mu, sigma, T = 100.0, 0.05, 0.2, 1.0
RETURNS = np.diff(np.log(np.array([100.,101.,99.,102.,100.5,103.,101.5,104.,102.,105.])))


# GBM

def test_gbm_paths_shape():
    assert gbm_paths(S0, mu, sigma, T, 252, 1000).shape == (1000, 252)

def test_gbm_paths_all_positive():
    assert np.all(gbm_paths(S0, mu, sigma, T, 252, 1000) > 0)

def test_gbm_paths_antithetic_shape():
    assert gbm_paths_antithetic(S0, mu, sigma, T, 252, 1000).shape == (1000, 252)

def test_gbm_paths_antithetic_pairs_sum_to_2drift():
    paths = gbm_paths_antithetic(S0, mu, sigma, T, 252, 1000)
    log_r1 = np.log(paths[:500,  -1] / S0)
    log_r2 = np.log(paths[500:, -1] / S0)
    expected = 2 * (mu - 0.5 * sigma**2) * T
    assert abs(np.mean(log_r1 + log_r2) - expected) < 0.05

def test_gbm_paths_antithetic_odd_raises():
    with pytest.raises(ValueError):
        gbm_paths_antithetic(S0, mu, sigma, T, 252, 999)


# Metropolis-Hastings

def test_mh_sampler_gbm_shape():
    samples = mh_sampler_gbm(RETURNS, n_iter=1000, n_burning=200)
    assert samples.shape == (800, 2)

def test_mh_sampler_gbm_sigma_positive():
    samples = mh_sampler_gbm(RETURNS, n_iter=1000, n_burning=200)
    assert np.all(samples[:, 1] > 0)

def test_mh_sampler_gbm_posterior_mean_reasonable():
    samples = mh_sampler_gbm(RETURNS, n_iter=5000, n_burning=1000)
    assert 0 < np.mean(samples[:, 1]) < 10.0


# Merton model

def test_merton_paths_shape():
    assert merton_paths(100, 0.05, 0.2, 1.0, -0.1, 0.15, 1, 252, 1000).shape == (1000, 252)

def test_merton_paths_all_positive():
    assert np.all(merton_paths(100, 0.05, 0.2, 1.0, -0.1, 0.15, 1, 252, 1000) > 0)

def test_merton_paths_no_jumps_mean_at_T():
    paths = merton_paths(100, 0.05, 0.2, 0.0, 0.0, 0.0, 1, 252, 50000)
    assert abs(np.mean(paths[:, -1]) - 100 * math.exp(0.05)) < 1.0

def test_merton_paths_jumps_increase_variance():
    pure_gbm  = merton_paths(100, 0.05, 0.2, 0.0, 0.0, 0.0, 1, 252, 10000)
    with_jump = merton_paths(100, 0.05, 0.2, 5.0, 0.0, 0.15, 1, 252, 10000)
    assert np.var(with_jump[:, -1]) > np.var(pure_gbm[:, -1])