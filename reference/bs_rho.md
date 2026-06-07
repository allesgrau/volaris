# Black-Scholes rho

Computes rho of an option: the first derivative of option price with
respect to risk-free interest rate (dV/dr).

## Usage

``` r
bs_rho(S, K, T, r, sigma, is_call)
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

  integer scalar: if 1, compute rho for a call option; if 0, compute rho
  for a put option

## Value

Returns a numeric scalar in the range (-inf, +inf) representing the rho
of the option.

## Examples

``` r
bs_rho(100, 100, 1, 0.05, 0.2, 1)
#> [1] 53.23248
stopifnot(bs_rho(100, 100, 1, 0.05, 0.2, 0) < 0)
```
