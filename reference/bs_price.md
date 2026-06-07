# Black-Scholes option pricing

Computes the theoretical price of an European option using the
Black-Scholes formula.

## Usage

``` r
bs_price(S, K, T, r, sigma, is_call)
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

  integer scalar: if 1, price a call option; if 0, price a put option

## Value

Returns a numeric scalar in the range (0, +inf) representing the price
of the option.

## Examples

``` r
bs_price(100, 100, 1, 0.05, 0.2, 1)
#> [1] 10.45058
stopifnot(bs_price(100, 100, 1, 0.05, 0.2, 0) > 0)
```
