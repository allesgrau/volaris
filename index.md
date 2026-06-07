# Volaris

Volaris is a high-performance library for quantitative finance – option
pricing, volatility estimation, stochastic simulation, and numerical
methods, with a compiled C/C++ backend shared between Python and R.
Whether you are pricing derivatives, fitting volatility models, or
running Monte Carlo simulations, Volaris gives you C-speed without
leaving Python or R.

If you want a hands-on introduction to these topics, check out the
[notebooks](https://github.com/allesgrau/volaris/tree/main/notebooks)
directory for worked examples.

Available as:

- **Python package** – `volaris` (`python/`)
- **R package** – `Volaris` (`R/Volaris/`)

------------------------------------------------------------------------

## Features

- Pricing
  - Black-Scholes (with Greeks calculation)
  - Binomial Tree
  - Monte Carlo (European, Asian, Barrier)
  - Heston stochastic volatility
- Volatility
  - Historical volatility (Close-to-Close, Parkinson, Garman-Klass,
    Yang-Zhang)
  - Implied volatility
  - GARCH(1,1) fit & forecast
- Simulation
  - Geometric Brownian Motion (plain, antithetic)
  - Merton jump-diffusion
  - MCMC (Metropolis-Hastings)
- Numerical
  - Root-finding (Newton-Raphson, Bisection)
  - Numerical integration (Gauss quadrature, GSL adaptive)

------------------------------------------------------------------------

## Repository structure

    volaris/
    │
    ├── src/                            # Shared C/C++ source code
    │   ├── pricing/                    #   Black-Scholes, Binomial Tree, Heston, Monte Carlo
    │   ├── volatility/                 #   Historical vol, Implied vol, GARCH
    │   ├── simulation/                 #   GBM, Jump-Diffusion, MCMC
    │   ├── numerical/                  #   Root-finding, Integration
    │   └── utils/                      #   LCG random number generator
    │
    ├── python/                         # Python package
    │   ├── volaris/
    │   │   ├── _core.pyx               #   Cython wrapper (C modules)
    │   │   └── _heston_garch.pyx       #   Cython wrapper (C++ modules)
    │   ├── tests/
    │   └── pyproject.toml
    │
    ├── R/Volaris/                      # R package
    │   ├── R/                          #   R wrapper functions
    │   ├── src/                        #   C/C++ sources (copy from src/) + R wrappers
    │   │   ├── volaris_r.c             #     R/C API wrapper (C modules)
    │   │   └── heston_garch_rcpp.cpp   #     Rcpp wrapper (C++ modules)
    |   ├── man/                        #   Roxygen2-generated documentation
    |   ├── vignettes/                  #   Getting-started guide
    │   ├── tests/
    |   ├── _pkgdown.yml                #   pkgdown site configuration
    │   └── DESCRIPTION
    │
    ├── notebooks/                      # Jupyter notebooks with usage examples
    ├── .github/workflows/              # CI: R CMD check + pytest on Linux, macOS, Windows
    └── CHANGELOG.md

------------------------------------------------------------------------

## Dependencies

**C/C++ backend (required for both packages)**

- [GNU GSL](https://www.gnu.org/software/gsl/) \>= 2.0: numerical
  integration
- OpenMP: parallelism in Monte Carlo and GARCH

**Python**

- Python \>= 3.9
- `NumPy` \>= 1.21
- Cython

**R**

- R \>= 4.0.0
- Rcpp

**Testing (optional)**

- Python: `pytest`
- R: `testthat`

------------------------------------------------------------------------

## Benchmarks

Benchmarked on Windows 11, Python 3.12, NumPy 2.x, and R 4.5.0.

**Python**

| Function | Volaris | NumPy / SciPy | Speedup | Reference |
|----|---:|---:|---:|----|
| `binomial_price` with N=400 | 0.1 ms | 3.9 ms | **36.6x** | NumPy |
| `mc_price_european` with 100,000 paths | 3.5 ms | 6.3 ms | **1.8x** | NumPy |
| `hist_vol_close_to_close` with n=10,000 | \<0.1 ms | 0.1 ms | **13.9x** | NumPy |
| `implied_vol` x 10,000 calls | 12.0 ms | 25 933 ms | **2,169x** | SciPy |
| `gbm_paths` with 10,000 paths and 252 steps | 56.3 ms | 146.9 ms | **2.6x** | NumPy |
| `mh_sampler_gbm` with 10,000 iterations | 2.1 ms | 271.5 ms | **127x** | NumPy |
| `rootfind_newton` x 10,000 calls | 12.2 ms | 1 893 ms | **155x** | SciPy |
| `integrate_gauss` x 10,000 calls | 188.7 ms | 495.9 ms | **2.6x** | SciPy |
| `garch_fit` with n=1,000 returns | 1.1 ms | 950.0 ms | **844x** | NumPy + SciPy |

**R**

| Function | Volaris | base R | Speedup | Reference |
|----|---:|---:|---:|----|
| `binomial_price` with N=400 | 0.10 ms | 2.55 ms | **25.4x** | base R |
| `mc_price_european` with 100,000 paths | 5.2 ms | 19.3 ms | **3.7x** | base R |
| `vol_close_to_close` with n=10,000 | 0.03 ms | 0.13 ms | **3.7x** | base R |
| `implied_vol` x 10,000 calls | 56.6 ms | 1 401.6 ms | **24.7x** | `uniroot` |
| `gbm_paths` with 10,000 paths and 252 steps | 139.5 ms | 606.0 ms | **4.3x** | base R |
| `mh_sampler_gbm` with 10,000 iterations | 9.2 ms | 87.4 ms | **9.5x** | base R |
| `rootfind_newton` x 10,000 calls | 84.9 ms | 728.3 ms | **8.6x** | `uniroot` |
| `integrate_gauss` x 10,000 calls | 120.5 ms | 351.6 ms | **2.9x** | [`integrate()`](https://rdrr.io/r/stats/integrate.html) |
| `garch_fit` with n=1,000 returns | 10.6 ms | 1.6 ms | *0.1x* | `R optim` |

*`garch_fit` is faster, because R 4.x compiles the inner loop on the
fly, making the sequential GARCH recurrence nearly as fast as C. The
sequential dependency prevents vectorisation in either implementation.*

------------------------------------------------------------------------

## Usage examples

See the `notebooks/` directory for full worked examples:

- `notebooks/01_black_scholes.ipynb` – option pricing with Black-Scholes
  and a Binomial Tree
- `notebooks/02_implied_volatility_surface.ipynb` – volatility surface
  construction
- `notebooks/03_monte_carlo_pricing.ipynb` – Monte Carlo for pricing
  exotic options

------------------------------------------------------------------------

## License

MIT, see LICENSE.
