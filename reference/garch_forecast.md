# GARCH(1,1) conditional variances forecasting

Computes conditional variance forecasts from fitted GARCH(1,1)
parameters.

## Usage

``` r
garch_forecast(omega, alpha, beta, returns, h)
```

## Arguments

- omega:

  numeric scalar: omega parameter from garch_fit()

- alpha:

  numeric scalar: alpha parameter from garch_fit()

- beta:

  numeric scalar: beta parameter from garch_fit()

- returns:

  numeric vector: original return series

- h:

  integer scalar: forecast horizon (steps ahead)

## Value

Returns a numeric vector of length h with conditional variance
forecasts.

## Examples

``` r
r <- diff(log(c(100, 101, 99, 102, 98, 103, 105, 104, 106, 103, 101)))
fit <- garch_fit(r)
garch_forecast(fit$omega, fit$alpha, fit$beta, r, 10)
#>  [1] 0.0007500125 0.0007500125 0.0007500125 0.0007500125 0.0007500125
#>  [6] 0.0007500125 0.0007500125 0.0007500125 0.0007500125 0.0007500125
```
