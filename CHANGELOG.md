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
- Implementation of Black-Scholes pricing:
  - computational C core
  - R/C API and Cython bindings for all Black-Scholes functions
  - R user-facing wrappers with full Roxygen2 documentation
  - created unit tests for Black-Scholes functions in R and Python
  - ran unit tests for Black-Scholes functions in Python
- R and Python package metadata.