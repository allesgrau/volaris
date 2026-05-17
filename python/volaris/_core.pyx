cdef extern from "black_scholes.h":
    double c_bs_price  "bs_price" (double S, double K, double T, double r, double sigma, int is_call)
    double c_bs_delta  "bs_delta" (double S, double K, double T, double r, double sigma, int is_call)
    double c_bs_gamma  "bs_gamma" (double S, double K, double T, double r, double sigma)
    double c_bs_vega   "bs_vega"  (double S, double K, double T, double r, double sigma)
    double c_bs_theta  "bs_theta" (double S, double K, double T, double r, double sigma, int is_call)
    double c_bs_rho    "bs_rho"   (double S, double K, double T, double r, double sigma, int is_call)


def bs_price(double S, double K, double T, double r, double sigma, int is_call):
    """
    Black-Scholes option pricing

    Parameters
    ----------
    S : float
        current price of the underlying asset
    K : float
        strike price of the option
    T : float
        time to expiration of the option (in years)
    r : float
        risk-free interest rate (annualized)
    sigma : float
        volatility of the underlying asset (annualized)
    is_call : int
        if 1, price a call option; if 0, price a put option

    Returns
    -------
    float
        a number in the range (0, +inf) representing the price of the option

    Examples
    --------
    >>> bs_price(100, 100, 1, 0.05, 0.2, 1)
    10.450583572185565
    """

    return c_bs_price(S, K, T, r, sigma, is_call)


def bs_delta(double S, double K, double T, double r, double sigma, int is_call):
    """
    Black-Scholes delta (dV/dS) calculation

    Parameters
    ----------
    S : float
        current price of the underlying asset
    K : float
        strike price of the option
    T : float
        time to expiration of the option (in years)
    r : float
        risk-free interest rate (annualized)
    sigma : float
        volatility of the underlying asset (annualized)
    is_call : int
        if 1, price a call option; if 0, price a put option

    Returns
    -------
    float
        a number in the range (-1, 1) representing the delta of the option

    Examples
    --------
    >>> bs_delta(100, 100, 1, 0.05, 0.2, 1)
    0.6368306862210673
    """

    return c_bs_delta(S, K, T, r, sigma, is_call)


def bs_gamma(double S, double K, double T, double r, double sigma):
    """
    Black-Scholes gamma (d^2V/dS^2) calculation

    Parameters
    ----------
    S : float
        current price of the underlying asset
    K : float
        strike price of the option
    T : float
        time to expiration of the option (in years)
    r : float
        risk-free interest rate (annualized)
    sigma : float
        volatility of the underlying asset (annualized)

    Returns
    -------
    float
        a number in the range (0, +inf) representing the gamma of the option

    Examples
    --------
    >>> bs_gamma(100, 100, 1, 0.05, 0.2)
    0.018761288528928744
    """

    return c_bs_gamma(S, K, T, r, sigma)


def bs_vega(double S, double K, double T, double r, double sigma):
    """
    Black-Scholes vega (dV/dsigma) calculation

    Parameters
    ----------
    S : float
        current price of the underlying asset
    K : float
        strike price of the option
    T : float
        time to expiration of the option (in years)
    r : float
        risk-free interest rate (annualized)
    sigma : float
        volatility of the underlying asset (annualized)

    Returns
    -------
    float
        a number in the range (0, +inf) representing the vega of the option

    Examples
    --------
    >>> bs_vega(100, 100, 1, 0.05, 0.2)
    37.522577057857485
    """

    return c_bs_vega(S, K, T, r, sigma)


def bs_theta(double S, double K, double T, double r, double sigma, int is_call):
    """
    Black-Scholes theta (dV/dT) calculation

    Parameters
    ----------
    S : float
        current price of the underlying asset
    K : float
        strike price of the option
    T : float
        time to expiration of the option (in years)
    r : float
        risk-free interest rate (annualized)
    sigma : float
        volatility of the underlying asset (annualized)
    is_call : int
        if 1, price a call option; if 0, price a put option

    Returns
    -------
    float
        a number in the range (-inf, 0) representing the theta of the option

    Examples
    --------
    >>> bs_theta(100, 100, 1, 0.05, 0.2, 1)
    -6.414478400651083
    """

    return c_bs_theta(S, K, T, r, sigma, is_call)


def bs_rho(double S, double K, double T, double r, double sigma, int is_call):
    """
    Black-Scholes rho (dV/dr) calculation

    Parameters
    ----------
    S : float
        current price of the underlying asset
    K : float
        strike price of the option
    T : float
        time to expiration of the option (in years)
    r : float
        risk-free interest rate (annualized)
    sigma : float
        volatility of the underlying asset (annualized)
    is_call : int
        if 1, price a call option; if 0, price a put option

    Returns
    -------
    float
        a number in the range (-inf, +inf) representing the rho of the option

    Examples
    --------
    >>> bs_rho(100, 100, 1, 0.05, 0.2, 1)
    53.232480549377546
    """

    return c_bs_rho(S, K, T, r, sigma, is_call)