# Volaris

Volaris is a high-performance library for quantitative finance – option pricing, volatility estimation, stochastic simulation, and numerical methods, with a compiled C/C++ backend shared between Python and R. Whether you are pricing derivatives, fitting volatility models, or running Monte Carlo simulations, Volaris gives you C-speed without leaving Python or R. 

If you want a hands-on introduction to these topics, check out the [notebooks](notebooks/) directory for worked examples.

Available as:
- **Python package** – `volaris` (`python/`)
- **R package** – `Volaris` (`R/Volaris/`)

---

## Features

| Module | Functions |
|---|---|
| **Pricing** | Black-Scholes, Binomial Tree, Monte Carlo (European, Asian, Barrier), Heston stochastic volatility |
| **Volatility** | Historical vol (Close-to-Close, Parkinson, Garman-Klass, Yang-Zhang), Implied volatility, GARCH(1,1) fit & forecast |
| **Simulation** | Geometric Brownian Motion (plain, antithetic), Merton jump-diffusion, MCMC (Metropolis-Hastings) |
| **Numerical** | Root-finding (Newton-Raphson, Bisection), Numerical integration (Gauss quadrature, GSL adaptive) |

---

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

---

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

---

## Benchmarks

Benchmarked on Windows 11, Python 3.12, NumPy 2.x, and R 4.5.0.

**Python**

| Function | Volaris | NumPy / SciPy | Speedup |
|---|---:|---:|---:|
| `binomial_price` with N=400 | 0.1 ms | 3.9 ms | **36.6x** |
| `mc_price_european` with 100,000 paths | 3.5 ms | 6.3 ms | **1.8x** |
| `hist_vol_close_to_close` with n=10,000 | <0.1 ms | 0.1 ms | **13.9x** |
| `implied_vol` x 10,000 calls | 12.0 ms | 25 933 ms | **2,169x** |
| `gbm_paths` with 10,000 paths and 252 steps | 56.3 ms | 146.9 ms | **2.6x** | 
| `mh_sampler_gbm` with 10,000 iterations | 2.1 ms | 271.5 ms | **127x** |
| `rootfind_newton` x 10,000 calls | 12.2 ms | 1 893 ms | **155x** | 
| `integrate_gauss` x 10,000 calls | 188.7 ms | 495.9 ms | **2.6x** |
| `garch_fit` with n=1,000 returns | 1.1 ms | 950.0 ms | **844x** | 

**R**

| Function | Volaris | R | Speedup |
|---|---:|---:|---:|
| `binomial_price` with N=400 | 0.10 ms | 2.55 ms | **25.4x** | 
| `mc_price_european` with 100,000 paths | 5.2 ms | 19.3 ms | **3.7x** | 
| `vol_close_to_close` with n=10,000 | 0.03 ms | 0.13 ms | **3.7x** | 
| `implied_vol` x 10,000 calls | 56.6 ms | 1 401.6 ms | **24.7x** | 
| `gbm_paths` with 10,000 paths and 252 steps | 139.5 ms | 606.0 ms | **4.3x** |
| `mh_sampler_gbm` with 10,000 iterations | 9.2 ms | 87.4 ms | **9.5x** | 
| `rootfind_newton` x 10,000 calls | 84.9 ms | 728.3 ms | **8.6x** |
| `integrate_gauss` x 10,000 calls | 120.5 ms | 351.6 ms | **2.9x** | 
| `garch_fit` with n=1,000 returns | 10.6 ms | 1.6 ms | *0.1x* |

*`garch_fit` is faster, because R 4.x compiles the inner loop on the fly, making the sequential GARCH recurrence nearly as fast as C. The sequential dependency prevents vectorisation in either implementation.*

---

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

---

## Usage examples

See the `notebooks/` directory for full worked examples:

- `notebooks/01_black_scholes.ipynb` – option pricing with Black-Scholes and a Binomial Tree
- `notebooks/02_implied_volatility_surface.ipynb` – volatility surface construction
- `notebooks/03_monte_carlo_pricing.ipynb` – Monte Carlo for pricing exotic options

---

## License

MIT, see LICENSE.

---