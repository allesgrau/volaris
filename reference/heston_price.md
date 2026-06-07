# Heston stochastic volatility options pricing

Computes the theoretical price of a European option using the Heston
stochastic volatility model via characteristic function integration.

## Usage

``` r
heston_price(S, K, T, r, v0, kappa, theta, xi, rho, is_call)
```

## Arguments

- S:

  numeric scalar: current price of the underlying asset

- K:

  numeric scalar: strike price of the option

- T:

  numeric scalar: time to expiration of the option (in years)

- r:

  numeric scalar: risk-free interest rate (annualized)

- v0:

  numeric scalar: initial variance

- kappa:

  numeric scalar: mean reversion speed of variance

- theta:

  numeric scalar: long-run variance (mean reversion level)

- xi:

  numeric scalar: volatility of variance

- rho:

  numeric scalar: correlation between asset and variance processes

- is_call:

  integer scalar: if 1, price a call option; if 0, price a put option

## Value

Returns a numeric scalar in the range (0, +inf) representing the price
of the option.

## Examples

``` r
heston_price(100, 100, 1, 0.05, 0.04, 2, 0.04, 0.3, -0.7, 1)
#> [1] 10.39422
```
