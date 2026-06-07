# GSL QAGS adaptive integration

Integrates f over \[a, b\] using GSL QAGS adaptive quadrature.

## Usage

``` r
integrate_gsl(f, a, b, tol = 1e-08)
```

## Arguments

- f:

  function: scalar -\> scalar whose integral we seek

- a:

  numeric: bracket left endpoint

- b:

  numeric: bracket right endpoint

- tol:

  numeric: relative tolerance (default 1e-8)

## Value

Returns a numeric scalar representing the approximate integral of f over
\[a, b\].

## Examples

``` r
integrate_gsl(function(x) x^2, 0, 1)
#> [1] 0.3333333
```
