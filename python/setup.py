from setuptools import setup, Extension
from Cython.Build import cythonize
import numpy as np

ext = Extension(
    name="volaris._core",
    sources=[
      "volaris/_core.pyx",
      "../src/pricing/black_scholes.c",
    ],
    include_dirs=[
      "../src/pricing",
      np.get_include(),
    ],
  )

setup(
    ext_modules=cythonize([ext], language_level=3),
)