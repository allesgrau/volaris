import math
import numpy as np
import pytest

from volaris import (
    bs_price,
    hist_vol_close_to_close, hist_vol_parkinson, hist_vol_garman_klass, hist_vol_yang_zhang,
    garch_fit, garch_variances, garch_forecast,
    implied_vol
)


prices = np.array([100., 101., 99., 102., 100.5, 103., 101.5, 104., 102., 105.])
returns = np.diff(np.log(prices))
high = np.array([101., 102., 103., 104., 105., 106., 107., 108., 109.])
low = np.array([ 99., 100., 101., 102., 103., 104., 105., 106., 107.])
open_ = np.array([100., 101., 102., 103., 104., 105., 106., 107., 108.])
close = np.array([100.5, 101.5, 102.5, 103.5, 104.5, 105.5, 106.5, 107.5, 108.5])
GARCH_RETURNS = [0.01, -0.02, 0.015, -0.005, 0.008, -0.012, 0.003, 0.018, -0.007, 0.011, -0.009, 0.014, -0.006, 0.002, 0.019, -0.013, 0.007, -0.004, 0.016, -0.001]


# Historical volatility

def test_hist_vol_close_to_close_positive():
    assert hist_vol_close_to_close(returns) > 0

def test_hist_vol_parkinson_positive():
    assert hist_vol_parkinson(high, low) > 0

def test_hist_vol_garman_klass_positive():
    assert hist_vol_garman_klass(high, low, open_, close) > 0

def test_hist_vol_yang_zhang_positive():
    assert hist_vol_yang_zhang(high, low, open_, close) > 0


# GARCH(1, 1) model

def test_garch_fit_returns_dict():
    result = garch_fit(GARCH_RETURNS)
    assert isinstance(result, dict)
    assert {"omega", "alpha", "beta", "log_likelihood", "converged", "persistence"} <= result.keys()

def test_garch_fit_persistence_lt_1():
    result = garch_fit(GARCH_RETURNS)
    if result["converged"]:
        assert result["persistence"] < 1.0

def test_garch_variances_length():
    fit = garch_fit(GARCH_RETURNS)
    assert len(garch_variances(fit["omega"], fit["alpha"], fit["beta"], GARCH_RETURNS)) == len(GARCH_RETURNS)

def test_garch_variances_positive():
    fit = garch_fit(GARCH_RETURNS)
    assert all(v > 0 for v in garch_variances(fit["omega"], fit["alpha"], fit["beta"], GARCH_RETURNS))

def test_garch_forecast_length():
    fit = garch_fit(GARCH_RETURNS)
    assert len(garch_forecast(fit["omega"], fit["alpha"], fit["beta"], GARCH_RETURNS, 5)) == 5

def test_garch_forecast_positive():
    fit = garch_fit(GARCH_RETURNS)
    assert all(v > 0 for v in garch_forecast(fit["omega"], fit["alpha"], fit["beta"], GARCH_RETURNS, 5))


# Implied volatility

def test_implied_vol_roundtrip_call():
    price = bs_price(100, 100, 1, 0.05, 0.2, 1)
    assert abs(implied_vol(price, 100, 100, 1, 0.05, 1) - 0.2) < 1e-6

def test_implied_vol_roundtrip_put():
    price = bs_price(100, 110, 0.5, 0.03, 0.3, 0)
    assert abs(implied_vol(price, 100, 110, 0.5, 0.03, 0) - 0.3) < 1e-6

def test_implied_vol_otm_call():
    price = bs_price(100, 120, 1, 0.05, 0.25, 1)
    assert abs(implied_vol(price, 100, 120, 1, 0.05, 1) - 0.25) < 1e-5

def test_implied_vol_high_vol():
    price = bs_price(100, 100, 1, 0.05, 0.8, 1)
    assert abs(implied_vol(price, 100, 100, 1, 0.05, 1) - 0.8) < 1e-5

def test_implied_vol_nan_for_impossible_price():
    assert math.isnan(implied_vol(0.0, 100, 100, 1, 0.05, 1))