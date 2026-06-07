# Newton-Raphson root finding

Finds a root of f(x) = 0 using the Newton-Raphson method.

## Usage

``` r
rootfind_newton(f, df, x0, tol = 1e-10, max_iter = 1000L)
```

## Arguments

- f:

  function: scalar -\> scalar whose root we seek

- df:

  function: derivative of f

- x0:

  numeric: initial guess of the root

- tol:

  numeric: convergence tolerance (default 1e-10)

- max_iter:

  integer: maximum iterations (default 1000)

## Value

Returns a numeric scalar representing the approximate root of f.

## Examples

``` r
rootfind_newton(function(x) x^2 - 2, function(x) 2*x, x0 = 1.5)
#> [1] 1.414214
```
