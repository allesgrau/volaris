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
- Full implementation of `pricing/black_scholes`: C code, Python/R bindings, unit tests, and compilation.
- R and Python package metadata.

## [0.1.2] – 2026-05-30

### Added
- C/C++ code and Python/R bindings for `pricing/binomial_tree`, `pricing/heston`, `pricing/monte_carlo`, `volatility/garch`, `volatility/historical_vol`.

## [0.1.3] – 2026-05-31

### Added
- Finished full implementation of `pricing/binomial_tree`, `pricing/heston`, `pricing/monte_carlo`, `volatility/garch`, `volatility/historical_vol`: unit tests and compilation.
- Full implementation of `volatility/implied_vol`, `simulation/gbm`, as well as `simulation/jump_diffusion` and `simulation/mcmc`.

### Modified
- Changed plans for the package: dropped the `risk/` part.

## [0.2.1] – 2026-06-04

### Added

- Full implementation of `numerical/rootfind` and `numerical/integrate`, thus making the source C/C++ code for the package complete.

### Modified

- Changed plans for the package: dropped one functionality from the `numerical/` part due to it being very difficult to implement.