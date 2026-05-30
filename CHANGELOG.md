# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

## [0.1.0] – 2026-05-16

### Added
- Defined project scope – derivatives pricing, volatility estimation, stochastic simulations, and risk quantification.
- Planned full module structure: `pricing`, `volatility`, `simulation`, `numerical`, `risk`.
- Set up initial repository structure.

## [0.1.1] – 2026-05-17

### Added
- Implementation of `pricing/black_scholes`:
  - computational C core
  - R/C API and Cython bindings for all Black-Scholes functions
  - R user-facing wrappers with full Roxygen2 documentation
  - created unit tests for Black-Scholes functions in R and Python
  - ran unit tests for Black-Scholes functions in Python
- R and Python package metadata.

## [0.1.2] – 2026-05-30

### Added
- C/C++ code and bindings for `pricing/binomial_tree`, `pricing/heston`, `pricing/monte_carlo`, `volatility/garch`, `volatility/historical_vol`.