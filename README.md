# Volaris

Volaris is a high-performance library for quantitative finance – option pricing, volatility estimation, stochastic simulation, and numerical methods, with a compiled C/C++ backend shared between Python and R. Whether you are pricing derivatives, fitting volatility models, or running Monte Carlo simulations, Volaris gives you C-speed without leaving Python or R. 

Available as:
- **Python package** – `volaris` (`python/`)
- **R package** – `Volaris` (`R/Volaris/`)

Rendered example notebooks are available on the [project site](https://allesgrau.github.io/volaris/):
- **Python** – Black-Scholes, implied volatility, Monte Carlo pricing – [Examples (Python)](https://allesgrau.github.io/volaris/articles/notebooks_py.html)
- **R** – Black-Scholes pricing – [Examples (R)](https://allesgrau.github.io/volaris/articles/notebooks_r.html)

Source notebooks live in [`notebooks/`](notebooks/) (`*.ipynb` for Python, `*_r.ipynb` for R).

[Features](#features) | [Repository structure](#repository-structure) | [Dependencies](#dependencies) | [Benchmarks](#benchmarks) | [Installation](#installation) – [Python](#python) and [R](#r) | [Bibliography](#bibliography) | [License](#license)

## Features

| Module | Functions |
|---|---|
| **Pricing** | Black-Scholes, Binomial Tree, Monte Carlo (European, Asian, Barrier), Heston stochastic volatility |
| **Volatility** | Historical vol (Close-to-Close, Parkinson, Garman-Klass, Yang-Zhang), Implied volatility, GARCH(1,1) fit & forecast |
| **Simulation** | Geometric Brownian Motion (plain, antithetic), Merton jump-diffusion, MCMC (Metropolis-Hastings) |
| **Numerical** | Root-finding (Newton-Raphson, Bisection), Numerical integration (Gauss quadrature, GSL adaptive) |

## Repository structure

```
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
```

## Dependencies

**C/C++ backend (required for both packages)**
- [GNU GSL](https://www.gnu.org/software/gsl/) >= 2.0: numerical integration
- OpenMP: parallelism in Monte Carlo and GARCH

**Python**
- Python >= 3.9
- `NumPy` >= 1.21
- Cython

**R**
- R >= 4.0.0
- Rcpp

**Testing (optional)**
- Python: `pytest`
- R: `testthat`

## Benchmarks

Benchmarked on Windows 11, Python 3.12, NumPy 2.x, and R 4.5.0.

**Python**

| Function | Volaris | NumPy / SciPy | Speedup |
|---|---:|---:|---:|
| `binomial_price` with N=400 | 0.1 ms | 2.4 ms | **36.8x** |
| `mc_price_european` with 100,000 paths | 1.9 ms | 3.9 ms | **2.0x** |
| `hist_vol_close_to_close` with n=10,000 | <0.1 ms | 0.1 ms | **14.1x** |
| `implied_vol` x 10,000 calls | 9.2 ms | 11 724 ms | **1,274x** |
| `gbm_paths` with 10,000 paths and 252 steps | 28.1 ms | 79.5 ms | **2.8x** |
| `mh_sampler_gbm` with 10,000 iterations | 1.1 ms | 115.9 ms | **108x** |
| `rootfind_newton` x 10,000 calls | 5.4 ms | 854.3 ms | **157x** |
| `integrate_gauss` x 10,000 calls | 87.8 ms | 223.1 ms | **2.5x** |
| `garch_fit` with n=1,000 returns | 0.7 ms | 441.2 ms | **588x** |

**R**

| Function | Volaris | R | Speedup |
|---|---:|---:|---:|
| `binomial_price` with N=400 | 0.08 ms | 2.4 ms | **30.0x** |
| `mc_price_european` with 100,000 paths | 2.8 ms | 12.2 ms | **4.4x** |
| `vol_close_to_close` with n=10,000 | 0.02 ms | 0.07 ms | **3.7x** |
| `implied_vol` x 10,000 calls | 31.1 ms | 761.5 ms | **24.5x** |
| `gbm_paths` with 10,000 paths and 252 steps | 89.8 ms | 384.9 ms | **4.3x** |
| `mh_sampler_gbm` with 10,000 iterations | 4.7 ms | 75.4 ms | **16.1x** |
| `rootfind_newton` x 10,000 calls | 60.9 ms | 522.3 ms | **8.6x** |
| `integrate_gauss` x 10,000 calls | 63.8 ms | 215.2 ms | **3.4x** |

*The benchmark covers only a selection of the most important functionalities of Volaris.*

## Installation

### Python

You will need [Miniconda](https://docs.anaconda.com/miniconda/). Download the installer for your OS from the link and follow the on-screen steps.

- **macOS**
Open Terminal and run:
```bash
git clone https://github.com/allesgrau/volaris.git
cd volaris
brew install gsl libomp
conda create -n volaris python=3.11
conda activate volaris
conda install -c conda-forge numpy cython
cd python
pip install -e .
```

- **Ubuntu**
Open Terminal and run:
```bash
git clone https://github.com/allesgrau/volaris.git
cd volaris
sudo apt-get install libgsl-dev
conda create -n volaris python=3.11
conda activate volaris
conda install -c conda-forge numpy cython
cd python
pip install -e .
```

- **Windows**
Open Anaconda Prompt (installed with Miniconda) and run:
```ps1
git clone https://github.com/allesgrau/volaris.git
cd volaris
conda create -n volaris python=3.11
conda activate volaris
conda install -c conda-forge gsl numpy cython
cd python
pip install -e .
```

**Quick check (any OS)**
```python
import volaris
print(volaris.bs_price(100, 100, 1.0, 0.05, 0.2, 1))  # ~10.45
```

### R


- **macOS**

Open Terminal and run:
```bash
git clone https://github.com/allesgrau/volaris.git
cd volaris
brew install r gsl
```
Then in R:
```r
install.packages("Rcpp")
```
Then in Terminal:
```bash
R CMD INSTALL R/Volaris
```

- **Ubuntu**

Open Terminal and run:
```bash
git clone https://github.com/allesgrau/volaris.git
cd volaris
sudo apt-get install r-base libgsl-dev
```
Then in R:
```r
install.packages("Rcpp")
```
Then in Terminal:
```bash
R CMD INSTALL R/Volaris
```

- **Windows**

1. Install [R](https://cran.r-project.org/bin/windows/base/): download the `.exe` installer and run it.
2. Install [Rtools](https://cran.r-project.org/bin/windows/Rtools/): choose the version matching your R version (e.g. Rtools45 for R 4.5.x). Download and run the installer.
3. Open **Rtools Bash**: press Start, search for *Rtools*, and open **Rtools Bash** (a terminal window).
4. In Rtools Bash, install GSL:
```bash
pacman -S mingw-w64-ucrt-x86_64-gsl
```
1. Clone the repository (still in Rtools Bash):
```bash
git clone https://github.com/allesgrau/volaris.git
cd volaris
```
1. Open R and install the required R package:
```r
install.packages("Rcpp")
```
1. Back in PowerShell (regular Windows terminal), from the repo root:
```powershell
R CMD INSTALL R\Volaris
```

**Quick check (any OS)**
```r
library(Volaris)
bs_price(100, 100, 1.0, 0.05, 0.2, 1L)  # ~10.45
```

## Bibliography

**Tools, libraries & packages**

| Tool | Used for |
|---|---|
| [GNU GSL](https://www.gnu.org/software/gsl/) | Numerical integration |
| [OpenMP](https://www.openmp.org/) | Parallel streams in Monte Carlo and GARCH |
| [Cython](https://cython.org/) | Python bindings to the C/C++ backend |
| [NumPy](https://numpy.org/) | Array interface (Python) |
| [Rcpp](https://www.rcpp.org/) | R bindings to the C++ backend |
| [pytest](https://docs.pytest.org/) | Python unit-tests |
| [testthat](https://testthat.r-lib.org/) | R unit-tests |
| [roxygen2](https://roxygen2.r-lib.org/) | R documentation generation |
| [pkgdown](https://pkgdown.r-lib.org/) | Package website |
| [Jupyter](https://jupyter.org/) | Example notebooks |

**Mathematical models & algorithms**

Sources other than Wikipedia pages:
- https://www.gnu.org/software/gsl/doc/html/integration.html
- https://www.macroption.com/
- Fabrice D. Rouah, *The Heston Model and Its Extensions in Matlab and C#*, Wiley
- https://www.quantstart.com/
- Bing Wang, Ling Wang *Pricing Barrier Options using Monte Carlo Methods*, Uppsala University, May 2011
- https://medium.com/@poyuan1004/merton-jump-diffusion-model-929bf1d833ed
- https://medium.com/hypervolatility/extracting-implied-volatility-newton-raphson-secant-and-bisection-approaches-fae83c779e56
- https://github.com/cantaro86/Financial-Models-Numerical-Methods
- https://github.com/numpy/numpy/blob/main/numpy/random/src/pcg64/pcg64.h
- https://portfolioslab.com/
- https://www.ivolatility.com/education/
- https://www.codearmo.com/blog/

## License

MIT, see LICENSE.