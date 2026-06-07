# Binomial tree options pricing

Computes the theoretical price of an option using a binomial tree model.

## Usage

``` r
binomial_price(S, K, T, r, q, sigma, N, is_call, is_american)
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

- q:

  numeric scalar: continuous dividend yield of the underlying asset
  (annualized)

- sigma:

  numeric scalar: volatility of the underlying asset (annualized)

- N:

  integer scalar: number of steps in the binomial tree

- is_call:

  integer scalar: if 1, price a call option; if 0, price a put option

- is_american:

  integer scalar: if 1, price an American option; if 0, price a European
  option

## Value

Returns a numeric scalar in the range (0, +inf) representing the price
of the option.

## Examples

``` r
binomial_price(100, 100, 1, 0.05, 0.02, 0.2, 100, 1, 0)
#> [1] 9.20759
stopifnot(binomial_price(100, 100, 1, 0.05, 0.02, 0.2, 100, 0, 1) > 0)
```
