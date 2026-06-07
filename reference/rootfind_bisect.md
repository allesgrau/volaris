# Bisection root finding

Finds a root of f(x) = 0 in \[a, b\] using bisection.

## Usage

``` r
rootfind_bisect(f, a, b, tol = 1e-10, max_iter = 1000L)
```

## Arguments

- f:

  function: scalar -\> scalar whose root we seek

- a:

  numeric: bracket left endpoint

- b:

  numeric: bracket right endpoint

- tol:

  numeric: convergence tolerance (default 1e-10)

- max_iter:

  integer: maximum iterations (default 1000)

## Value

Returns a numeric scalar representing the approximate root of f.

## Examples

``` r
rootfind_bisect(function(x) x^2 - 2, a = 1, b = 2)
#> [1] 1.414214
```
