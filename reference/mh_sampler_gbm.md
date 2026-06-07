# GBM parameter calibration via Metropolis-Hastings MCMC

Calibrates mu and sigma of a Geometric Brownian Motion model from a
log-return series using the Metropolis-Hastings algorithm.

## Usage

``` r
mh_sampler_gbm(
  returns,
  n_iter,
  n_burning,
  proposal_mu = 0.005,
  proposal_sigma = 0.005,
  mu_init = 0,
  sigma_init = 0.2,
  dt = 1/252
)
```

## Arguments

- returns:

  numeric vector: log-return series

- n_iter:

  integer scalar: total MCMC iterations

- n_burning:

  integer scalar: burn-in iterations to discard

- proposal_mu:

  numeric scalar: random walk step size for mu

- proposal_sigma:

  numeric scalar: random walk step size for sigma

- mu_init:

  numeric scalar: initial value of mu (default 0)

- sigma_init:

  numeric scalar: initial value of sigma (default 0.2)

- dt:

  numeric scalar: time step between observations (default 1/252)

## Value

Returns a numeric matrix of dimensions (n_iter - n_burnin) x 2. Columns
are mu and sigma.

## Examples

``` r
r <- diff(log(c(100,101,99,102,100.5,103,101.5,104,102,105)))
samples <- mh_sampler_gbm(r, 2000L, 500L, 0.005, 0.005)
```
