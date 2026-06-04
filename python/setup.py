import sys
import os
from setuptools import setup, Extension
from Cython.Build import cythonize
import numpy as np

extra_cpp_comp_args = ["/openmp"] if sys.platform == "win32" else ["-std=c++14", "-O3", "-fopenmp"]
extra_c_comp_args = ["/openmp"] if sys.platform == "win32" else ["-std=c11", "-O3", "-fopenmp"]
extra_openmp_arg = ["/openmp"] if sys.platform == "win32" else ["-fopenmp"]


conda_prefix = os.environ.get("CONDA_PREFIX", "") or sys.prefix
if sys.platform == "win32":
  gsl_inc = [os.path.join(conda_prefix, "Library", "include")]
  gsl_lib = [os.path.join(conda_prefix, "Library", "lib")]
else:
  gsl_inc = [os.path.join(conda_prefix, "include")]
  gsl_lib = [os.path.join(conda_prefix, "lib")]


ext_core = Extension(
    name="volaris._core",
    sources=[
      "volaris/_core.pyx",
      "../src/utils/lcg.c",
      "../src/pricing/black_scholes.c",
      "../src/pricing/binomial_tree.c",
      "../src/pricing/monte_carlo.c",
      "../src/volatility/historical_vol.c",
      "../src/volatility/implied_vol.c",
      "../src/simulation/gbm.c",
      "../src/simulation/mcmc.c",
      "../src/simulation/jump_diffusion.c",
      "../src/numerical/rootfind.c",
      "../src/numerical/integrate.c",
    ],
    include_dirs=[
      "../src/pricing",
      "../src/volatility",
      "../src/simulation",
      "../src/numerical",
      *gsl_inc,
      np.get_include(),
    ],
    library_dirs=gsl_lib,
    libraries=["gsl", "gslcblas"],
    extra_compile_args=extra_c_comp_args,
    extra_link_args=extra_openmp_arg
  )

ext_heston_garch = Extension(
    name="volaris._heston_garch",
    sources=[
      "volaris/_heston_garch.pyx",
      "../src/pricing/heston.cpp",
      "../src/volatility/garch.cpp",
    ],
    include_dirs=[
      "../src/pricing",
      "../src/volatility",
      np.get_include(),
    ],
    language="c++",
    extra_compile_args=extra_cpp_comp_args,
    extra_link_args=extra_openmp_arg
  )

setup(
    ext_modules=cythonize([ext_core, ext_heston_garch], language_level=3),
)