import math
import pytest
from volaris import bs_price, bs_delta, bs_gamma, bs_vega, bs_theta, bs_rho


S, K, T, r, sigma = 100.0, 100.0, 1.0, 0.05, 0.2


def test_bs_price_call():
    assert abs(bs_price(S, K, T, r, sigma, 1) - 10.4506) < 1e-3

def test_bs_price_put():
    assert abs(bs_price(S, K, T, r, sigma, 0) - 5.5735) < 1e-3

def test_bs_put_call_parity():
    assert abs(bs_price(S, K, T, r, sigma, 1) - bs_price(S, K, T, r, sigma, 0) - (S - K * math.exp(-r * T))) < 1e-9

def test_bs_delta_call_in_range():
    assert 0 < bs_delta(S, K, T, r, sigma, 1) < 1

def test_bs_delta_put_in_range():
    assert -1 < bs_delta(S, K, T, r, sigma, 0) < 0

def test_bs_delta_put_call_parity():
    assert abs(bs_delta(S, K, T, r, sigma, 1) - bs_delta(S, K, T, r, sigma, 0) - 1.0) < 1e-9

def test_bs_gamma_positive():
    assert bs_gamma(S, K, T, r, sigma) > 0

def test_bs_vega_positive():
    assert bs_vega(S, K, T, r, sigma) > 0

def test_bs_theta_call_negative():
    assert bs_theta(S, K, T, r, sigma, 1) < 0

def test_bs_theta_put_negative():
    assert bs_theta(S, K, T, r, sigma, 0) < 0

def test_bs_rho_call_positive():
    assert bs_rho(S, K, T, r, sigma, 1) > 0

def test_bs_rho_put_negative():
    assert bs_rho(S, K, T, r, sigma, 0) < 0