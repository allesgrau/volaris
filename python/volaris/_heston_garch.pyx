# distutils: language = c++
from libcpp.vector cimport vector


cdef extern from "heston.hpp" namespace "volaris":
    double heston_price(double S, double K, double T, double r, double v0, double kappa, double theta, double xi, double rho, int is_call) except +

cdef extern from "garch.hpp" namespace "volaris":
    cdef struct GarchFit:
        double omega
        double alpha
        double beta
        double log_likelihood
        bint converged
    GarchFit        garch11_fit         (const vector[double]& returns) except +
    vector[double]  garch11_variances   (const GarchFit& fit, const vector[double]& returns) except +
    vector[double]  garch11_forecast    (const GarchFit& fit, const vector[double]& returns, int h) except +


def heston_price_py(double S, double K, double T, double r, double v0, double kappa, double theta, double xi, double rho, int is_call):
    """
    Price a European option using the Heston stochastic volatility model.

    Parameters
    ----------
    S : float
        current price of the underlying asset
    K : float
        strike price
    T : float 
        time to expiration (in years)
    r : float
        risk-free interest rate (annualized)
    v0 : float 
        initial variance
    kappa : float
        mean reversion speed of variance
    theta : float
        long-run variance (mean reversion level)
    xi : float
        volatility of variance
    rho : float
        correlation between asset and variance processes
    is_call : int
        1 for call, 0 for put

    Returns
    -------
    float
        theoretical option price
    """
    return heston_price(S, K, T, r, v0, kappa, theta, xi, rho, is_call)


def garch_fit(list returns):
    """
    Fit GARCH(1, 1) to a return series via maximum likelihood with Nelder-Mean optimization.

    Parameters
    ----------
    returns : list of floats
        series of log-returns

    Returns
    -------
    dict
        omega, alpha, beta, log_likelihood, converged, persistence
        omega, alpha, beta = optimal GARCH(1, 1) parameters
        log_likelihood = log-likelihood function value for the optimal GARCH(1, 1) parameters
        converged = if equal to False, the GARCH(1, 1) parameters lie outside the domain and the result is useless
        persistence = how quickly the impact of market events fades away
    """

    cdef vector[double] r = returns
    cdef GarchFit fit = garch11_fit(r)
    return {
        "omega": fit.omega,
        "alpha": fit.alpha,
        "beta": fit.beta,
        "log_likelihood": fit.log_likelihood,
        "converged": fit.converged,
        "persistence": fit.alpha + fit.beta
    }


def garch_variances(double omega, double alpha, double beta, list returns):
    """
    Compute conditional variances for historical data from GARCH(1, 1) parameters.

    Parameters
    ----------
    omega, alpha, beta : float
        parameters from garch_fit()
    returns : list of floats
        original return series

    Returns
    -------
    list of floats
        variances computed for the past n timestamps, where n = len(returns)
    """

    cdef GarchFit fit
    fit.omega = omega
    fit.alpha = alpha
    fit.beta = beta
    cdef vector[double] r = returns
    return list(garch11_variances(fit, r))


def garch_forecast(double omega, double alpha, double beta, list returns, int h):
    """
    Compute conditional variances forecast based on historical data from GARCH(1, 1) parameters.

    Parameters
    ----------
    omega, alpha, beta : float
        parameters from garch_fit()
    returns : list of floats
        original return series
    h : int
        forecast horizon (steps ahead)

    Returns
    -------
    list of floats
        variances computed for the next h timestamps
    """

    cdef GarchFit fit
    fit.omega = omega
    fit.alpha = alpha
    fit.beta = beta
    cdef vector[double] r = returns
    return list(garch11_forecast(fit, r, h))