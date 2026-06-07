# Black-Scholes delta

Computes delta of an option: the first derivative of option price with
respect to the underlying asset price (dV/dS).

## Usage

``` r
bs_delta(S, K, T, r, sigma, is_call)
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

  integer scalar: if 1, compute delta for a call option; if 0, compute
  delta for a put option

## Value

Returns a numeric scalar in the range (-1, 1) representing the delta of
the option.

## Examples

``` r
bs_delta(100, 100, 1, 0.05, 0.2, 1)
#> [1] 0.6368307
stopifnot(bs_delta(100, 100, 1, 0.05, 0.2, 0) > -1 && bs_delta(100, 100, 1, 0.05, 0.2, 0) < 1)
```
