# GARCH(1,1) historical conditional variances calculation

Computes conditional variances of the historical data from fitted
GARCH(1,1) parameters.

## Usage

``` r
garch_variances(omega, alpha, beta, returns)
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

## Value

Returns a numeric vector of length equal to returns with conditional
variances.

## Examples

``` r
r <- diff(log(c(100, 101, 99, 102, 98, 103, 105, 104, 106, 103, 101)))
fit <- garch_fit(r)
garch_variances(fit$omega, fit$alpha, fit$beta, r)
#>  [1] 0.0007500125 0.0007500125 0.0007500125 0.0007500125 0.0007500126
#>  [6] 0.0007500127 0.0007500126 0.0007500126 0.0007500125 0.0007500125
```
