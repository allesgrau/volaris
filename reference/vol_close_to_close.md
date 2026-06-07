# Close-to-close historical volatility calculation

Computes annualized volatility from log-returns (standard deviation
estimator).

## Usage

``` r
vol_close_to_close(returns, n)
```

## Arguments

- returns:

  numeric vector: log-return series

- n:

  integer scalar: number of observations

## Value

Returns a numeric scalar representing annualized volatility.

## Examples

``` r
r <- diff(log(c(100,102,99,103,101,98,104)))
vol_close_to_close(r, length(r))
#> [1] 0.6115577
```
