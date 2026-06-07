# European options pricing via Monte Carlo simulation

Computes the theoretical price of a European option using Monte Carlo
with Geometric Brownian Motion paths.

## Usage

``` r
mc_price_european(S, K, T, r, sigma, N_paths, is_call)
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

- N_paths:

  integer scalar: number of simulated paths

- is_call:

  integer scalar: if 1, price a call option; if 0, price a put option

## Value

Returns a tuple of numeric scalars, both in the range (0, +inf),
representing the price of the option and the standard error of the price
estimate.

## Examples

``` r
mc_price_european(100, 100, 1, 0.05, 0.2, 10000, 1)
#> [1] 10.5645409  0.1468685
stopifnot(mc_price_european(100, 100, 1, 0.05, 0.2, 1000, 1)[1] > 0)
```
