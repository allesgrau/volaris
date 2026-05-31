import math
import pytest

from volaris import (
    bs_price, bs_delta, bs_gamma, bs_vega, bs_theta, bs_rho,
    binomial_price,
    heston_price_py,
    mc_price_european, mc_price_asian, mc_price_barrier,
)


S, K, T, r, sigma = 100.0, 100.0, 1.0, 0.05, 0.2
q, v0, kappa, theta_h, xi, rho_h = 0.0, 0.04, 2.0, 0.04, 0.3, -0.8


# Black-Scholes

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


# Binomial tree

def test_binomial_call_positive():
    assert binomial_price(S, K, T, r, q, sigma, 200, 1, 0) > 0

def test_binomial_put_positive():
    assert binomial_price(S, K, T, r, q, sigma, 200, 0, 0) > 0

def test_binomial_european_converges_to_bs():
    assert abs(binomial_price(S, K, T, r, q, sigma, 500, 1, 0) - bs_price(S, K, T, r, sigma, 1)) < 0.05

def test_binomial_american_put_ge_european_put():
    assert binomial_price(S, K, T, r, q, sigma, 200, 0, 1) >= binomial_price(S, K, T, r, q, sigma, 200, 0, 0)

def test_binomial_put_call_parity_european():
    call = binomial_price(S, K, T, r, q, sigma, 500, 1, 0)
    put  = binomial_price(S, K, T, r, q, sigma, 500, 0, 0)
    assert abs(call - put - (S - K * math.exp(-r * T))) < 0.1


# Heston model

def test_heston_call_positive():
    assert heston_price_py(S, K, T, r, v0, kappa, theta_h, xi, rho_h, 1) > 0

def test_heston_put_positive():
    assert heston_price_py(S, K, T, r, v0, kappa, theta_h, xi, rho_h, 0) > 0

def test_heston_put_call_parity():
    call = heston_price_py(S, K, T, r, v0, kappa, theta_h, xi, rho_h, 1)
    put  = heston_price_py(S, K, T, r, v0, kappa, theta_h, xi, rho_h, 0)
    assert abs(call - put - (S - K * math.exp(-r * T))) < 1e-4


# Monte Carlo

def test_mc_european_returns_tuple():
    assert isinstance(mc_price_european(S, K, T, r, sigma, 1000, 1), tuple)

def test_mc_european_call_positive():
    price, _ = mc_price_european(S, K, T, r, sigma, 10000, 1)
    assert price > 0

def test_mc_european_std_err_positive():
    _, std_err = mc_price_european(S, K, T, r, sigma, 10000, 1)
    assert std_err > 0

def test_mc_european_approx_bs():
    price, std_err = mc_price_european(S, K, T, r, sigma, 100000, 1)
    assert abs(price - bs_price(S, K, T, r, sigma, 1)) < 5 * std_err

def test_mc_asian_positive():
    assert mc_price_asian(S, K, T, r, sigma, 10000, 252, 1) > 0

def test_mc_asian_le_european():
    asian = mc_price_asian(S, K, T, r, sigma, 50000, 252, 1)
    european, _ = mc_price_european(S, K, T, r, sigma, 50000, 1)
    assert asian < european

def test_mc_barrier_knockout_positive():
    assert mc_price_barrier(S, K, T, r, sigma, 10000, 252, 120.0, 1, 1, 1) > 0

def test_mc_barrier_knockout_le_vanilla():
    knockout = mc_price_barrier(S, K, T, r, sigma, 50000, 252, 120.0, 1, 1, 1)
    vanilla, _ = mc_price_european(S, K, T, r, sigma, 50000, 1)
    assert knockout < vanilla