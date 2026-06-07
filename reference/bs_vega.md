# Black-Scholes vega

Computes vega of an option: the first derivative of option price with
respect to volatility (dV/dsigma).

## Usage

``` r
bs_vega(S, K, T, r, sigma)
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

Returns a numeric scalar in the range (0, +inf) representing the vega of
the option.

## Examples

``` r
bs_vega(100, 100, 1, 0.05, 0.2)
#> [1] 37.52403
stopifnot(bs_vega(100, 100, 1, 0.05, 0.2) > 0)
```
