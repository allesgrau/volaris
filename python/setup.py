import sys
from setuptools import setup, Extension
from Cython.Build import cythonize
import numpy as np

extra_cpp_comp_args = [] if sys.platform == "win32" else ["-std=c++14", "-O3", "-fopenmp"]
extra_c_comp_args = [] if sys.platform == "win32" else ["-std=c11", "-O3", "-fopenmp"]
extra_openmp_arg = [] if sys.platform == "win32" else ["-fopenmp"]

ext_core = Extension(
    name="volaris._core",
    sources=[
      "volaris/_core.pyx",
      "../src/pricing/black_scholes.c",
      "../src/pricing/binomial_tree.c",
      "../src/pricing/monte_carlo.c",
      "../src/volatility/historical_vol.c",
    ],
    include_dirs=[
      "../src/pricing",
      np.get_include(),
    ],
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