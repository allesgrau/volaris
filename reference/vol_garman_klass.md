# Garman-Klass historical volatility calculation

Computes annualized volatility from open/close and high/low prices.

## Usage

``` r
vol_garman_klass(open, high, low, close, n)
```

## Arguments

- open:

  numeric vector: daily open prices

- high:

  numeric vector: daily high prices

- low:

  numeric vector: daily low prices

- close:

  numeric vector: daily close prices

- n:

  integer scalar: number of observations

## Value

Returns a numeric scalar representing annualized volatility.

## Examples

``` r
vol_garman_klass(c(100,101,102), c(103,104,105), c(98,99,100), c(102,103,104), 3)
#> [1] 0.5181752
```
