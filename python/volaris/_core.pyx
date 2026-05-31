cdef extern from "black_scholes.h":
    double  c_bs_price       "bs_price"          (double S, double K, double T, double r, double sigma, int is_call)
    double  c_bs_delta       "bs_delta"          (double S, double K, double T, double r, double sigma, int is_call)
    double  c_bs_gamma       "bs_gamma"          (double S, double K, double T, double r, double sigma)
    double  c_bs_vega        "bs_vega"           (double S, double K, double T, double r, double sigma)
    double  c_bs_theta       "bs_theta"          (double S, double K, double T, double r, double sigma, int is_call)
    double  c_bs_rho         "bs_rho"            (double S, double K, double T, double r, double sigma, int is_call)

cdef extern from "binomial_tree.h":
    double  c_binomial_price "binomial_price"   (double S, double K, double T, double r, double q, double sigma, int N, int is_call, int is_american)

cdef extern from "monte_carlo.h":
    double  c_mc_price_european     "mc_price_european"     (double S, double K, double T, double r, double sigma, int N_paths, int is_call, double *std_err)
    double  c_mc_price_asian        "mc_price_asian"        (double S, double K, double T, double r, double sigma, int N_paths, int N_steps, int is_call)
    double  c_mc_price_barrier      "mc_price_barrier"      (double S, double K, double T, double r, double sigma, int N_paths, int N_steps, double B, int is_upper, int is_knockout, int is_call)

cdef extern from "historical_vol.h":
    double  c_vol_close_to_close    "vol_close_to_close"    (const double *returns, int n)
    double  c_vol_parkinson         "vol_parkinson"         (const double *high, const double *low, int n)
    double  c_vol_garman_klass      "vol_garman_klass"      (const double *high, const double *low, const double *open, const double *close, int n)
    double  c_vol_yang_zhang        "vol_yang_zhang"        (const double *high, const double *low, const double *open, const double *close, int n)

cdef extern from "implied_vol.h":
    double  c_implied_vol "implied_vol" (double market_price, double S, double K, double T, double r, int is_call)

cdef extern from "gbm.h":
    double  c_gbm_paths             "gbm_paths"             (double S0, double mu, double sigma, double T, int N_steps, int N_paths, double *out)
    double  c_gbm_paths_antithetic  "gbm_paths_antithetic"  (double S0, double mu, double sigma, double T, int N_steps, int N_paths, double *out)

cdef extern from "mcmc.h":
    double  c_mh_sampler_gbm "mh_sampler_gbm"   (const double *returns, int n, double dt, int n_iter, int n_burning, double mu_init, double sigma_init, double proposal_mu, double proposal_sigma, double *out)

cdef extern from "jump_diffusion.h":
    void    c_merton_paths "merton_paths"  (double S0, double mu, double sigma, double lambda_, double mu_j, double sigma_j, double T, int N_steps, int N_paths, double *out)


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


def binomial_price(double S, double K, double T, double r, double q, double sigma, int N, int is_call, int is_american):
    """
    Binomial tree options pricing

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
    q : float
        continuous dividend yield of the underlying asset (annualized)
    sigma : float
        volatility of the underlying asset (annualized)
    N : int
        number of steps in the binomial tree
    is_call : int
        if 1, price a call option; if 0, price a put option
    is_american : int
        if 1, price an American option; if 0, price a European option
    
    Returns
    -------
    float
        a number in the range (0, +inf) representing the price of the option

    Examples
    --------
    >>> binomial_price(100, 100, 1, 0.05, 0.2, 200, 1, 0)
    10.44059125985994
    """

    return c_binomial_price(S, K, T, r, q, sigma, N, is_call, is_american)


def mc_price_european(double S, double K, double T, double r, double sigma, int N_paths, int is_call):
    """
    European options pricing via Monte Carlo simulation (Geometric Brownian Motion paths)

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
    N_paths : int
        number of simulated paths
    is_call : int
        if 1, price a call option; if 0, price a put option
    
    Returns
    -------
    (float, float)
        Monte Carlo estimate of the option price with standard error of that estimate
    """

    cdef double std_err = 0.0
    cdef double price = c_mc_price_european(S, K, T, r, sigma, N_paths, is_call, &std_err)
    return price, std_err


def mc_price_asian(double S, double K, double T, double r, double sigma, int N_paths, int N_steps, int is_call):
    """
    Asian options pricing via Monte Carlo simulation (arithmetic average price)

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
    N_paths : int
        number of simulated paths
    N_steps : int
        number of time steps per path
    is_call : int
        if 1, price a call option; if 0, price a put option
    
    Returns
    -------
    float
        Monte Carlo estimate of the option price
    """

    return c_mc_price_asian(S, K, T, r, sigma, N_paths, N_steps, is_call)


def mc_price_barrier(double S, double K, double T, double r, double sigma, int N_paths, int N_steps, double B, int is_upper, int is_knockout, int is_call):
    """
    Knock-in / knock-out options pricing via Monte Carlo simulation (Geometric Brownian Motion paths)

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
    N_paths : int
        number of simulated paths
    N_steps : int
        number of time steps per path
    B : float
        barrier level
    is_upper : int
        if 1, active when S >= B; if 0, active when S <= B
    is_knockout : int
        if 1, barrier deactivates option; if 0, barrier activates option
    is_call : int
        if 1, price a call option; if 0, price a put option
    
    Returns
    -------
    float
        Monte Carlo estimate of the option price
    """

    return c_mc_price_barrier(S, K, T, r, sigma, N_paths, N_steps, B, is_upper, is_knockout, is_call)


def hist_vol_close_to_close(double[::1] returns not None):
    """
    Close-to-close historical volatility (annualised). Standard deviation estimator.

    Parameters
    ----------
    returns : np.ndarray of float64
        log-return series

    Returns
    -------
    float
        annualised volatility
    """

    return c_vol_close_to_close(&returns[0], len(returns))


def hist_vol_parkinson(double[::1] high not None, double[::1] low not None):
    """
    Parkinson historical volatility (annualised).

    Parameters
    ----------
    high : np.ndarray of float64
        daily high prices
    low  : np.ndarray of float64
        daily low prices

    Returns
    -------
    float
        annualised volatility
    """

    return c_vol_parkinson(&high[0], &low[0], len(high))


def hist_vol_garman_klass(double[::1] high not None, double[::1] low not None, double[::1] open not None, double[::1] close not None):
    """
    Garman-Klass historical volatility (annualised).

    Parameters
    ----------
    open : np.ndarray of float64
        daily open prices
    close : np.ndarray of float64
        daily close prices
    low : np.ndarray of float64
        daily low prices
    high : np.ndarray of float64
        daily high prices

    Returns
    -------
    float
        annualised volatility
    """

    return c_vol_garman_klass(&high[0], &low[0], &open[0], &close[0], len(high))


def hist_vol_yang_zhang(double[::1] high not None, double[::1] low not None, double[::1] open not None, double[::1] close not None):
    """
    Yang-Zhang historical volatility (annualised). Most efficient estimator.

    Parameters
    ----------
    open : np.ndarray of float64
        daily open prices
    close : np.ndarray of float64
        daily close prices
    low : np.ndarray of float64
        daily low prices
    high : np.ndarray of float64
        daily high prices

    Returns
    -------
    float
        annualised volatility
    """

    return c_vol_yang_zhang(&high[0], &low[0], &open[0], &close[0], len(high))


def implied_vol(double market_price, double S, double K, double T, double r, int is_call):
    """
    Implied volatility via Newton-Raphson with bisection fallback (Black-Scholes inversion)

    Parameters
    ----------
    market price : float
        observed market price of the option
    S : float
        current price of the underlying asset
    K : float
        strike price of the option
    T : float
        time to expiration of the option (in years)
    r : float
        risk-free interest rate (annualized)
    is_call : int
        if 1, the option is a call; if 0, the option is a put
    
    Returns
    -------
    float
        implied volatility (annualized)

    Examples
    --------
    >>> implied_vol(10.45, 100, 100, 1, 0.05, 1)
    0.19998444801094356
    """

    return c_implied_vol(market_price, S, K, T, r, is_call)


def gbm_paths(double S0, double mu, double sigma, double T, int N_steps, int N_paths):
    """
    Simulate Geometric Brownian Motion paths.

    Parameters
    ----------
    S0 : float
        initial asset price
    mu : float
        drift (annualized)
    sigma : float
        volatility (annualized)
    T : float
        time horizon (in years)
    N_steps : int
        number of time steps
    N_paths : int
        number of simulated paths

    Returns
    -------
    np.ndarray, shape (N_paths, N_steps)
        simulated asset prices; paths[i, j] = S at step j+1 for path i
    """

    import numpy as np
    out = np.empty((N_paths, N_steps), dtype=np.float64)
    cdef double[:, ::1] buf = out
    c_gbm_paths(S0, mu, sigma, T, N_steps, N_paths, &buf[0, 0])
    return out


def gbm_paths_antithetic(double S0, double mu, double sigma, double T, int N_steps, int N_paths):
    """
    Simulate Geometric Brownian Motion paths using antithetic variates for variance reduction.

    Parameters
    ----------
    S0 : float
        initial asset price
    mu : float
        drift (annualized)
    sigma : float
        volatility (annualized)
    T : float
        time horizon (in years)
    N_steps : int
        number of time steps
    N_paths : int
        number of simulated paths

    Returns
    -------
    np.ndarray, shape (N_paths, N_steps)
        simulated asset prices; paths[i, j] = S at step j+1 for path i
    """

    if (N_paths % 2 != 0):
        raise ValueError("N_paths must be even for antithetic variates")
    import numpy as np
    out = np.empty((N_paths, N_steps), dtype=np.float64)
    cdef double[:, ::1] buf = out
    c_gbm_paths(S0, mu, sigma, T, N_steps, N_paths, &buf[0, 0])
    return out


def mh_sampler_gbm(double[::1] returns not None, int n_iter, int n_burning, double proposal_mu=0.005, double proposal_sigma=0.005, double mu_init=0.0, double sigma_init=0.2, double dt=1.0/252.0):
    """
    Calibrate GBM parameters (mu, sigma) via Metropolis-Hastings MCMC.

    Parameters
    ----------
    returns : np.ndarray of float64
        log-return series
    n_iter : int
        total number of MCMC iterations
    n_burning : int
        number of burn-in iterations to discard
    proposal_mu : float
        random walk step size for mu
    proposal_sigma : float
        random walk step size for sigma
    mu_init : float
        initial value of mu
    sigma_init : float
        initial value of sigma
    dt : float
        time step between observations (default 1/252 for daily data)

    Returns
    -------
    np.ndarray, shape (n_iter - n_burnin, 2)
        posterior samples; columns are [mu, sigma]
    """

    import numpy as np
    n_samples = n_iter - n_burning
    out = np.empty((n_samples, 2), dtype=np.float64)
    cdef double[:, ::1] buf = out
    c_mh_sampler_gbm(&returns[0], len(returns), dt, n_iter, n_burning, mu_init, sigma_init, proposal_mu, proposal_sigma, &buf[0, 0])
    return out


def merton_paths(double S0, double mu, double sigma, double lambda_, double mu_j, double sigma_j, double T, int N_steps, int N_paths):
    """
    Simulate Merton jump-diffusion paths (GBM + compound Poisson jumps).

    Parameters
    ----------
    S0 : float
        initial asset price
    mu : float
        drift (annualized)
    sigma : float
        diffusion volatility (annualized)
    lambda_ : float
        jump intensity (expected number of jumps per year)
    mu_j : float
        mean log-jump size
    sigma_j : float
        std of log-jump size
    T : float
        time horizon (in years)
    N_steps : int
        number of time steps
    N_paths : int
        number of simulated paths

    Returns
    -------
    np.ndarray, shape (N_paths, N_steps)
        simulated asset prices; out[i, j] = price of path i at time step j+1
    """

    import numpy as np
    out = np.empty((N_paths, N_steps), dtype=np.float64)
    cdef double[:, ::1] buf = out
    c_merton_paths(S0, mu, sigma, lambda_, mu_j, sigma_j, T, N_steps, N_paths, &buf[0, 0])
    return out