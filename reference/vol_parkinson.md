# Parkinson volatility calculation

Computes annualized volatility from high/low prices.

## Usage

``` r
vol_parkinson(high, low, n)
```

## Arguments

- high:

  numeric vector: daily high prices

- low:

  numeric vector: daily low prices

- n:

  integer scalar: number of observations

## Value

Returns a numeric scalar representing annualized volatility.

## Examples

``` r
vol_parkinson(c(102,101,104), c(99,98,100), 3)
#> [1] 0.3180414
```
