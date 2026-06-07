# Gauss quadrature integratinon

Integrates f over \[a, b\] using Gauss quadrature.

## Usage

``` r
integrate_gauss(f, a, b, n_points = 10L)
```

## Arguments

- f:

  function: scalar -\> scalar whose integral we seek

- a:

  numeric: bracket left endpoint

- b:

  numeric: bracket right endpoint

- n_points:

  integer: number of quadrature points (default 10)

## Value

Returns a numeric scalar representing the approximate integral of f over
\[a, b\].

## Examples

``` r
integrate_gauss(function(x) x^2, 0, 1, n_points = 5L)
#> [1] 0.3333333
```
