# Black-Scholes theta

Computes theta of an option: the first derivative of option price with
respect to time to expiration (dV/dT).

## Usage

``` r
bs_theta(S, K, T, r, sigma, is_call)
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

- sigma:

  numeric scalar: volatility of the underlying asset (annualized)

- is_call:

  integer scalar: if 1, compute theta for a call option; if 0, compute
  theta for a put option

## Value

Returns a numeric scalar in the range (-inf, 0) representing the theta
of the option.

## Examples

``` r
bs_theta(100, 100, 1, 0.05, 0.2, 1)
#> [1] -6.414028
stopifnot(bs_theta(100, 100, 1, 0.05, 0.2, 0) < 0)
```
