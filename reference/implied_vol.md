# Implied volatility (Black-Scholes inversion)

Computes the implied volatility of an option by inverting the
Black-Scholes formula using Newton-Raphson.

## Usage

``` r
implied_vol(market_price, S, K, T, r, is_call)
```

## Arguments

- market_price:

  numeric scalar: observed market price of the option

- S:

  numeric scalar: current price of the underlying asset

- K:

  numeric scalar: strike price of the option

- T:

  numeric scalar: time to expiration (in years)

- r:

  numeric scalar: risk-free interest rate (annualized)

- is_call:

  integer scalar: 1 for call, 0 for put

## Value

Returns a numeric scalar: implied volatility (annualized).

## Examples

``` r
implied_vol(bs_price(100, 100, 1, 0.05, 0.2, 1), 100, 100, 1, 0.05, 1)
#> [1] 0.2
```
