# Volaris

Volaris is a high-performance library for quantitative finance – option
pricing, volatility estimation, stochastic simulation, and numerical
methods, with a compiled C/C++ backend shared between Python and R.
Whether you are pricing derivatives, fitting volatility models, or
running Monte Carlo simulations, Volaris gives you C-speed without
leaving Python or R.

Available as:

- **Python package** – `volaris` (`python/`)
- **R package** – `Volaris` (`R/Volaris/`)

Rendered example notebooks are available on the [project
site](https://allesgrau.github.io/volaris/):

- **Python** – Black-Scholes, implied volatility, Monte Carlo pricing –
  [Examples
  (Python)](https://allesgrau.github.io/volaris/articles/notebooks_py.html)
- **R** – Black-Scholes pricing – [Examples
  (R)](https://allesgrau.github.io/volaris/articles/notebooks_r.html)

Source notebooks live in
[`notebooks/`](https://allesgrau.github.io/volaris/notebooks/)
(`*.ipynb` for Python, `*_r.ipynb` for R).

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

| Function | Volaris | NumPy / SciPy | Speedup |
|----|---:|---:|---:|
| `binomial_price` with N=400 | 0.1 ms | 2.4 ms | **36.8x** |
| `mc_price_european` with 100,000 paths | 1.9 ms | 3.9 ms | **2.0x** |
| `hist_vol_close_to_close` with n=10,000 | \<0.1 ms | 0.1 ms | **14.1x** |
| `implied_vol` x 10,000 calls | 9.2 ms | 11 724 ms | **1,274x** |
| `gbm_paths` with 10,000 paths and 252 steps | 28.1 ms | 79.5 ms | **2.8x** |
| `mh_sampler_gbm` with 10,000 iterations | 1.1 ms | 115.9 ms | **108x** |
| `rootfind_newton` x 10,000 calls | 5.4 ms | 854.3 ms | **157x** |
| `integrate_gauss` x 10,000 calls | 87.8 ms | 223.1 ms | **2.5x** |

**R**

| Function                                    | Volaris |        R |   Speedup |
|---------------------------------------------|--------:|---------:|----------:|
| `binomial_price` with N=400                 | 0.08 ms |   2.4 ms | **30.0x** |
| `mc_price_european` with 100,000 paths      |  2.8 ms |  12.2 ms |  **4.4x** |
| `vol_close_to_close` with n=10,000          | 0.02 ms |  0.07 ms |  **3.7x** |
| `implied_vol` x 10,000 calls                | 31.1 ms | 761.5 ms | **24.5x** |
| `gbm_paths` with 10,000 paths and 252 steps | 89.8 ms | 384.9 ms |  **4.3x** |
| `mh_sampler_gbm` with 10,000 iterations     |  4.7 ms |  75.4 ms | **16.1x** |
| `rootfind_newton` x 10,000 calls            | 60.9 ms | 522.3 ms |  **8.6x** |
| `integrate_gauss` x 10,000 calls            | 63.8 ms | 215.2 ms |  **3.4x** |

*The benchmark covers only a selection of the most important
functionalities of Volaris.*

------------------------------------------------------------------------

## License

MIT + file LICENSE
