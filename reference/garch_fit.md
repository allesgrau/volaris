# GARCH(1,1) parameter calibration

Fits a GARCH(1,1) model to a historical return series via maximum
likelihood estimation using the Nelder-Mead optimizer.

## Usage

``` r
garch_fit(returns)
```

## Arguments

- returns:

  numeric vector: log-return series

## Value

Returns a list with elements: omega, alpha, beta, log_likelihood,
converged, persistence.

## Examples

``` r
r <- diff(log(c(100, 101, 99, 102, 98, 103, 105, 104, 106, 103, 101)))
garch_fit(r)
#> $omega
#> [1] 0.0001343921
#> 
#> $alpha
#> [1] 6.109196e-08
#> 
#> $beta
#> [1] 0.8208135
#> 
#> $log_likelihood
#> [1] 30.97726
#> 
#> $converged
#> [1] TRUE
#> 
#> $persistence
#> [1] 0.8208135
#> 
```
