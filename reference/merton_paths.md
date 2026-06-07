# Merton jump-diffusion path simulation

Simulates asset price paths under the Merton jump-diffusion model: GBM
with compound Poisson jumps.

## Usage

``` r
merton_paths(S0, mu, sigma, lambda, mu_j, sigma_j, T, N_steps, N_paths)
```

## Arguments

- S0:

  numeric scalar: initial asset price

- mu:

  numeric scalar: drift (annualized)

- sigma:

  numeric scalar: diffusion volatility (annualized)

- lambda:

  numeric scalar: jump intensity (jumps per year)

- mu_j:

  numeric scalar: mean log-jump size

- sigma_j:

  numeric scalar: std of log-jump size

- T:

  numeric scalar: time horizon (in years)

- N_steps:

  integer scalar: number of time steps

- N_paths:

  integer scalar: number of simulated paths

## Value

Returns a numeric matrix of dimensions N_steps x N_paths. Each column is
one path.

## Examples

``` r
paths <- merton_paths(100, 0.05, 0.2, 1, -0.1, 0.15, 1, 252, 1000)
```
