# Black-Scholes gamma

Computes gamma of an option: the second derivative of option price with
respect to the underlying asset price (d^2V/dS^2).

## Usage

``` r
bs_gamma(S, K, T, r, sigma)
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

## Value

Returns a numeric scalar in the range (0, +inf) representing the gamma
of the option.

## Examples

``` r
bs_gamma(100, 100, 1, 0.05, 0.2)
#> [1] 0.01876202
stopifnot(bs_gamma(100, 100, 1, 0.05, 0.2) > 0)
```
