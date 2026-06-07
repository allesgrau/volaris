# Asian options pricing via Monte Carlo simulation

Computes the theoretical price of an Asian option using Monte Carlo
based on the analysis of the arithmetic average price

## Usage

``` r
mc_price_asian(S, K, T, r, sigma, N_paths, N_steps, is_call)
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

- N_steps:

  integer scalar: number of time steps per path

- is_call:

  integer scalar: if 1, price a call option; if 0, price a put option

## Value

Returns a numeric scalar in the range (0, +inf) representing the price
of the option.

## Examples

``` r
asian <- mc_price_asian(100, 100, 1, 0.05, 0.2, 1000, 52, 1)
stopifnot(asian < mc_price_european(100, 100, 1, 0.05, 0.2, 1000, 1)[1])
```
