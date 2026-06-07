# Knock-in / knock-out options pricing via Monte Carlo simulation

Computes the theoretical price of a knock-in / knock-out option using
Monte Carlo with Geometric Brownian Motion paths.

## Usage

``` r
mc_price_barrier(
  S,
  K,
  T,
  r,
  sigma,
  N_paths,
  N_steps,
  B,
  is_upper,
  is_knockout,
  is_call
)
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

- B:

  numeric scalar: barrier level

- is_upper:

  integer scalar: if 1, active when S \>= B; if 0, active when S \<= B

- is_knockout:

  integer scalar: if 1, barrier deactivates option; if 0, barrier
  activates option

- is_call:

  integer scalar: if 1, price a call option; if 0, price a put option

## Value

Returns a numeric scalar in the range (0, +inf) representing the price
of the option.

## Examples

``` r
barrier <- mc_price_barrier(100, 100, 1, 0.05, 0.2, 1000, 52, 120, 1, 1, 1)
stopifnot(barrier < mc_price_european(100, 100, 1, 0.05, 0.2, 1000, 1)[1])
```
