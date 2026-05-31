import math
import pytest
import numpy as np

from volaris import (
    gbm_paths, gbm_paths_antithetic,
)


S0, mu, sigma, T = 100.0, 0.05, 0.2, 1.0


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