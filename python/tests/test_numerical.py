import math
import pytest

from volaris import (
    rootfind_newton, rootfind_bisect,
    integrate_gauss, integrate_gsl,
)


S, K, T, r, sigma = 100.0, 100.0, 1.0, 0.05, 0.2


# Find a root

def test_rootfind_newton_sqrt2():
    root = rootfind_newton(lambda x: x*x - 2, lambda x: 2*x, x0=1.5)
    assert abs(root - math.sqrt(2)) < 1e-8

def test_rootfind_newton_linear():
    root = rootfind_newton(lambda x: x - 7.0, lambda x: 1.0, x0=0.0)
    assert abs(root - 7.0) < 1e-10

def test_rootfind_newton_cubic():
    root = rootfind_newton(lambda x: x**3 - x - 2, lambda x: 3*x**2 - 1, x0=1.5)
    assert abs(root**3 - root - 2) < 1e-8

def test_rootfind_bisect_sqrt2():
    root = rootfind_bisect(lambda x: x*x - 2, a=1.0, b=2.0)
    assert abs(root - math.sqrt(2)) < 1e-8

def test_rootfind_bisect_sin_pi():
    root = rootfind_bisect(math.sin, a=3.0, b=4.0)
    assert abs(root - math.pi) < 1e-8

def test_rootfind_bisect_bad_bracket_returns_nan():
    assert math.isnan(rootfind_bisect(lambda x: x*x + 1, a=-2.0, b=2.0))


# Find an integral

def test_integrate_gauss_polynomial():
    assert abs(integrate_gauss(lambda x: x*x, 0.0, 1.0, n_points=10) - 1/3) < 1e-10

def test_integrate_gauss_sin():
    assert abs(integrate_gauss(math.sin, 0.0, math.pi, n_points=20) - 2.0) < 1e-10

def test_integrate_gauss_exp():
    assert abs(integrate_gauss(math.exp, 0.0, 1.0, n_points=10) - (math.e - 1)) < 1e-10

def test_integrate_gsl_polynomial():
    assert abs(integrate_gsl(lambda x: x*x, 0.0, 1.0) - 1/3) < 1e-8

def test_integrate_gsl_sin():
    assert abs(integrate_gsl(math.sin, 0.0, math.pi) - 2.0) < 1e-8

def test_integrate_gsl_agrees_with_gauss():
    f = lambda x: math.exp(-x * x)
    assert abs(integrate_gauss(f, 0.0, 3.0, n_points=30) - integrate_gsl(f, 0.0, 3.0)) < 1e-6