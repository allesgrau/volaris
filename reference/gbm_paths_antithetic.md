# Geometric Brownian Motion path simulation with antithetic variates

Simulates N_paths asset price paths under Geometric Brownian Motion
using antithetic variates for variance reduction.

## Usage

``` r
gbm_paths_antithetic(S0, mu, sigma, T, N_steps, N_paths)
```

## Arguments

- S0:

  numeric scalar: initial asset price

- mu:

  numeric scalar: drift (annualized)

- sigma:

  numeric scalar: volatility (annualized)

- T:

  numeric scalar: time horizon (in years)

- N_steps:

  integer scalar: number of time steps

- N_paths:

  integer scalar: number of simulated paths

## Value

Returns a numeric matrix of dimensions N_steps x N_paths. Each column is
one simulated path.

## Examples

``` r
paths <- gbm_paths_antithetic(100, 0.05, 0.2, 1, 252, 1000)
```
