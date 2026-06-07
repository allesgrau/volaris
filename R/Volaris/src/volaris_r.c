#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>
#include "lcg.h"
#include "black_scholes.h"
#include "binomial_tree.h"
#include "monte_carlo.h"
#include "historical_vol.h"
#include "implied_vol.h"
#include "gbm.h"
#include "mcmc.h"
#include "jump_diffusion.h"
#include "rootfind.h"
#include "integrate.h"


SEXP r_bs_price(SEXP S, SEXP K, SEXP T, SEXP r, SEXP sigma, SEXP is_call)
{
    if (!Rf_isReal(S) || !Rf_isReal(K) || !Rf_isReal(T) || !Rf_isReal(r) || !Rf_isReal(sigma) || !Rf_isInteger(is_call) || (INTEGER(is_call)[0] != 0 && INTEGER(is_call)[0] != 1))
    {
        Rf_error("All inputs must be of the correct type: S, K, T, r, sigma must be numeric and is_call must be integer (0 or 1).");
    }

    double result = bs_price(REAL(S)[0], REAL(K)[0], REAL(T)[0], REAL(r)[0], REAL(sigma)[0], INTEGER(is_call)[0]);
    return Rf_ScalarReal(result);
}


SEXP r_bs_delta(SEXP S, SEXP K, SEXP T, SEXP r, SEXP sigma, SEXP is_call)
{
    if (!Rf_isReal(S) || !Rf_isReal(K) || !Rf_isReal(T) || !Rf_isReal(r) || !Rf_isReal(sigma) || !Rf_isInteger(is_call) || (INTEGER(is_call)[0] != 0 && INTEGER(is_call)[0] != 1)) 
    {
        Rf_error("All inputs must be of the correct type: S, K, T, r, sigma must be numeric and is_call must be integer (0 or 1).");
    }

    double result = bs_delta(REAL(S)[0], REAL(K)[0], REAL(T)[0], REAL(r)[0], REAL(sigma)[0], INTEGER(is_call)[0]);
    return Rf_ScalarReal(result);
}


SEXP r_bs_gamma(SEXP S, SEXP K, SEXP T, SEXP r, SEXP sigma)
{
    if (!Rf_isReal(S) || !Rf_isReal(K) || !Rf_isReal(T) || !Rf_isReal(r) || !Rf_isReal(sigma)) 
    {
        Rf_error("All inputs must be of the correct type: S, K, T, r, sigma must be numeric.");
    }

    double result = bs_gamma(REAL(S)[0], REAL(K)[0], REAL(T)[0], REAL(r)[0], REAL(sigma)[0]);
    return Rf_ScalarReal(result);
}


SEXP r_bs_vega(SEXP S, SEXP K, SEXP T, SEXP r, SEXP sigma)
{
    if (!Rf_isReal(S) || !Rf_isReal(K) || !Rf_isReal(T) || !Rf_isReal(r) || !Rf_isReal(sigma)) 
    {
        Rf_error("All inputs must be of the correct type: S, K, T, r, sigma must be numeric.");
    }

    double result = bs_vega(REAL(S)[0], REAL(K)[0], REAL(T)[0], REAL(r)[0], REAL(sigma)[0]);
    return Rf_ScalarReal(result);
}


SEXP r_bs_theta(SEXP S, SEXP K, SEXP T, SEXP r, SEXP sigma, SEXP is_call)
{
    if (!Rf_isReal(S) || !Rf_isReal(K) || !Rf_isReal(T) || !Rf_isReal(r) || !Rf_isReal(sigma) || !Rf_isInteger(is_call) || (INTEGER(is_call)[0] != 0 && INTEGER(is_call)[0] != 1)) 
    {
        Rf_error("All inputs must be of the correct type: S, K, T, r, sigma must be numeric and is_call must be integer (0 or 1).");
    }

    double result = bs_theta(REAL(S)[0], REAL(K)[0], REAL(T)[0], REAL(r)[0], REAL(sigma)[0], INTEGER(is_call)[0]);
    return Rf_ScalarReal(result);
}


SEXP r_bs_rho(SEXP S, SEXP K, SEXP T, SEXP r, SEXP sigma, SEXP is_call)
{
    if (!Rf_isReal(S) || !Rf_isReal(K) || !Rf_isReal(T) || !Rf_isReal(r) || !Rf_isReal(sigma) || !Rf_isInteger(is_call) || (INTEGER(is_call)[0] != 0 && INTEGER(is_call)[0] != 1)) 
    {
        Rf_error("All inputs must be of the correct type: S, K, T, r, sigma must be numeric and is_call must be integer (0 or 1).");
    }

    double result = bs_rho(REAL(S)[0], REAL(K)[0], REAL(T)[0], REAL(r)[0], REAL(sigma)[0], INTEGER(is_call)[0]);
    return Rf_ScalarReal(result);
}


SEXP r_binomial_price(SEXP S, SEXP K, SEXP T, SEXP r, SEXP q, SEXP sigma, SEXP N, SEXP is_call, SEXP is_american)
{
    if (!Rf_isReal(S) || !Rf_isReal(K) || !Rf_isReal(T) || !Rf_isReal(r) || !Rf_isReal(q) || !Rf_isReal(sigma) || !Rf_isInteger(N) || !Rf_isInteger(is_call) || 
        !Rf_isInteger(is_american) || (INTEGER(is_call)[0] != 0 && INTEGER(is_call)[0] != 1) || (INTEGER(is_american)[0] != 0 && INTEGER(is_american)[0] != 1))
    {
        Rf_error("Type error: S, K, T, r, q, sigma must be numeric; N must be integer; is_call, is_american must be integer (0 or 1).");
    }
          
    double price = binomial_price(REAL(S)[0], REAL(K)[0], REAL(T)[0], REAL(r)[0], REAL(q)[0], REAL(sigma)[0], INTEGER(N)[0], INTEGER(is_call)[0], INTEGER(is_american)[0]);
    return Rf_ScalarReal(price);
}


SEXP r_mc_price_european(SEXP S, SEXP K, SEXP T, SEXP r, SEXP sigma, SEXP N_paths, SEXP is_call)
{
    if (!Rf_isReal(S) || !Rf_isReal(K) || !Rf_isReal(T) || !Rf_isReal(r) || !Rf_isReal(sigma) || !Rf_isInteger(N_paths) || !Rf_isInteger(is_call) ||
       (INTEGER(is_call)[0] != 0 && INTEGER(is_call)[0] != 1))
    {
        Rf_error("Type error: S, K, T, r, sigma must be numeric; N_paths must be integer; is_call must be integer (0 or 1).");
    }

    double std_err = 0.0;
    double price = mc_price_european(REAL(S)[0], REAL(K)[0], REAL(T)[0], REAL(r)[0], REAL(sigma)[0], INTEGER(N_paths)[0], INTEGER(is_call)[0], &std_err);
    SEXP result = Rf_allocVector(REALSXP, 2);
    REAL(result)[0] = price;
    REAL(result)[1] = std_err;
    return result;
}


SEXP r_mc_price_asian(SEXP S, SEXP K, SEXP T, SEXP r, SEXP sigma, SEXP N_paths, SEXP N_steps, SEXP is_call)
{
    if (!Rf_isReal(S) || !Rf_isReal(K) || !Rf_isReal(T) || !Rf_isReal(r) || !Rf_isReal(sigma) || !Rf_isInteger(N_paths) || !Rf_isInteger(N_steps) ||
       !Rf_isInteger(is_call) || (INTEGER(is_call)[0] != 0 && INTEGER(is_call)[0] != 1))
    {
        Rf_error("Type error: S, K, T, r, sigma must be numeric; N_paths, N_steps must be integer; is_call must be integer (0 or 1).");
    }

    double price = mc_price_asian(REAL(S)[0], REAL(K)[0], REAL(T)[0], REAL(r)[0], REAL(sigma)[0], INTEGER(N_paths)[0], INTEGER(N_steps)[0], INTEGER(is_call)[0]);
    return Rf_ScalarReal(price);
}


SEXP r_mc_price_barrier(SEXP S, SEXP K, SEXP T, SEXP r, SEXP sigma, SEXP N_paths, SEXP N_steps, SEXP B, SEXP is_upper, SEXP is_knockout, SEXP is_call)
{
    if (!Rf_isReal(S) || !Rf_isReal(K) || !Rf_isReal(T) || !Rf_isReal(r) || !Rf_isReal(sigma) || !Rf_isInteger(N_paths) || !Rf_isInteger(N_steps) || !Rf_isReal(B) ||
       !Rf_isInteger(is_upper) || (INTEGER(is_upper)[0] != 0 && INTEGER(is_upper)[0] != 1) || !Rf_isInteger(is_knockout) || 
       (INTEGER(is_knockout)[0] != 0 && INTEGER(is_knockout)[0] != 1) || !Rf_isInteger(is_call) || (INTEGER(is_call)[0] != 0 && INTEGER(is_call)[0] != 1))
    {
        Rf_error("Type error: S, K, T, r, sigma, B must be numeric; N_paths, N_steps must be integer; is_upper, is_knockout, is_call must be integer (0 or 1).");
    }

    double price = mc_price_barrier(REAL(S)[0], REAL(K)[0], REAL(T)[0], REAL(r)[0], REAL(sigma)[0], INTEGER(N_paths)[0], INTEGER(N_steps)[0], REAL(B)[0], 
                                    INTEGER(is_upper)[0], INTEGER(is_knockout)[0], INTEGER(is_call)[0]);
    return Rf_ScalarReal(price);
}


SEXP r_vol_close_to_close(SEXP returns, SEXP n)
{
    if (!Rf_isReal(returns) || !Rf_isInteger(n))
    {
        Rf_error("Type error: returns must be numeric, n must be integer.");
    }
    
    return Rf_ScalarReal(vol_close_to_close(REAL(returns), INTEGER(n)[0]));
}


SEXP r_vol_parkinson(SEXP high, SEXP low, SEXP n)
{
    if (!Rf_isReal(high) || !Rf_isReal(low) || !Rf_isInteger(n))
        Rf_error("Type error: high, low must be numeric, n must be integer.");
    
    return Rf_ScalarReal(vol_parkinson(REAL(high), REAL(low), INTEGER(n)[0]));
}


SEXP r_vol_garman_klass(SEXP open, SEXP high, SEXP low, SEXP close, SEXP n)
{
    if (!Rf_isReal(open) || !Rf_isReal(high) || !Rf_isReal(low) || !Rf_isReal(close) || !Rf_isInteger(n))
    {
        Rf_error("Type error: open, high, low, close must be numeric, n must be integer.");
    }
        
    return Rf_ScalarReal(vol_garman_klass(REAL(high), REAL(low), REAL(open), REAL(close), INTEGER(n)[0]));
}


SEXP r_vol_yang_zhang(SEXP open, SEXP high, SEXP low, SEXP close, SEXP n)
{
    if (!Rf_isReal(open) || !Rf_isReal(high) || !Rf_isReal(low) || !Rf_isReal(close) || !Rf_isInteger(n))
        Rf_error("Type error: open, high, low, close must be numeric, n must be integer.");
    
    return Rf_ScalarReal(vol_yang_zhang(REAL(high), REAL(low), REAL(open), REAL(close), INTEGER(n)[0]));
}

SEXP r_implied_vol(SEXP market_price, SEXP S, SEXP K, SEXP T, SEXP r, SEXP is_call)
{
    if (!Rf_isReal(market_price) || !Rf_isReal(S) || !Rf_isReal(K) || !Rf_isReal(T) || !Rf_isReal(r) || !Rf_isInteger(is_call) || 
       (INTEGER(is_call)[0] != 0 && INTEGER(is_call)[0] != 1))
    {
        Rf_error("Type error: market_price, S, K, T, r must be numeric; is_call must be integer (0 or 1).");
    }

    return Rf_ScalarReal(implied_vol(REAL(market_price)[0], REAL(S)[0], REAL(K)[0], REAL(T)[0], REAL(r)[0], INTEGER(is_call)[0]));
}


SEXP r_gbm_paths(SEXP S0, SEXP mu, SEXP sigma, SEXP T, SEXP N_steps, SEXP N_paths)
{
    if (!Rf_isReal(S0) || !Rf_isReal(mu) || !Rf_isReal(sigma) || !Rf_isReal(T) || !Rf_isInteger(N_steps) || !Rf_isInteger(N_paths))
        Rf_error("Type error: S0, mu, sigma, T must be numeric; N_steps, N_paths must be integer.");

    int n_steps = INTEGER(N_steps)[0];
    int n_paths = INTEGER(N_paths)[0];

    double *buf = (double *)malloc(n_paths * n_steps * sizeof(double));
    gbm_paths(REAL(S0)[0], REAL(mu)[0], REAL(sigma)[0], REAL(T)[0], n_steps, n_paths, buf);

    SEXP out = Rf_allocMatrix(REALSXP, n_steps, n_paths);
    for (int i = 0; i < n_paths; ++i)
        for (int j = 0; j < n_steps; ++j)
            REAL(out)[j + n_steps * i] = buf[i * n_steps + j];
    free(buf);
    return out;
}


SEXP r_gbm_paths_antithetic(SEXP S0, SEXP mu, SEXP sigma, SEXP T, SEXP N_steps, SEXP N_paths)
{
    if (!Rf_isReal(S0) || !Rf_isReal(mu) || !Rf_isReal(sigma) || !Rf_isReal(T) || !Rf_isInteger(N_steps) || !Rf_isInteger(N_paths))
        Rf_error("Type error: S0, mu, sigma, T must be numeric; N_steps, N_paths must be integer.");

    int n_steps = INTEGER(N_steps)[0];
    int n_paths = INTEGER(N_paths)[0];
    if (n_paths % 2 != 0)
        Rf_error("N_paths must be even for antithetic variates.");

    double *buf = (double *)malloc(n_paths * n_steps * sizeof(double));
    gbm_paths_antithetic(REAL(S0)[0], REAL(mu)[0], REAL(sigma)[0], REAL(T)[0], n_steps, n_paths, buf);

    SEXP out = Rf_allocMatrix(REALSXP, n_steps, n_paths);
    for (int i = 0; i < n_paths; ++i)
        for (int j = 0; j < n_steps; ++j)
            REAL(out)[j + n_steps * i] = buf[i * n_steps + j];
    free(buf);
    return out;
}


SEXP r_mh_sampler_gbm(SEXP returns, SEXP n_iter, SEXP n_burning, SEXP proposal_mu, SEXP proposal_sigma, SEXP mu_init, SEXP sigma_init, SEXP dt)
{
    if (!Rf_isReal(returns) || !Rf_isInteger(n_iter) || !Rf_isInteger(n_burning) || !Rf_isReal(proposal_mu) || !Rf_isReal(proposal_sigma) || !Rf_isReal(mu_init) || 
        !Rf_isReal(sigma_init) || !Rf_isReal(dt))
    {
        Rf_error("Type error: returns, proposal_mu, proposal_sigma, mu_init, sigma_init, dt must be numeric; n_iter, n_burning must be integer.");
    }

    int n = Rf_length(returns);
    int n_samp = INTEGER(n_iter)[0] - INTEGER(n_burning)[0];

    double *buf  = (double *)malloc(n_samp * 2 * sizeof(double));
    mh_sampler_gbm(REAL(returns), n, REAL(dt)[0], INTEGER(n_iter)[0], INTEGER(n_burning)[0], REAL(mu_init)[0], REAL(sigma_init)[0], 
                   REAL(proposal_mu)[0], REAL(proposal_sigma)[0], buf);

    SEXP out = Rf_allocMatrix(REALSXP, n_samp, 2);
    for (int i = 0; i < n_samp; ++i) {
        REAL(out)[i] = buf[i * 2];
        REAL(out)[i + n_samp] = buf[i * 2 + 1];
    }
    free(buf);
    return out;
}


SEXP r_merton_paths(SEXP S0, SEXP mu, SEXP sigma, SEXP lambda, SEXP mu_j, SEXP sigma_j, SEXP T, SEXP N_steps, SEXP N_paths)
{
    if (!Rf_isReal(S0) || !Rf_isReal(mu) || !Rf_isReal(sigma) || !Rf_isReal(lambda) || !Rf_isReal(mu_j) || !Rf_isReal(sigma_j) || !Rf_isReal(T) || 
        !Rf_isInteger(N_steps) || !Rf_isInteger(N_paths))
    {
        Rf_error("Type error: S0, mu, sigma, lambda, mu_j, sigma_j, T must be numeric; N_steps, N_paths must be integer.");
    }
          
    int n_steps = INTEGER(N_steps)[0];
    int n_paths = INTEGER(N_paths)[0];

    double *buf = (double *)malloc(n_paths * n_steps * sizeof(double));
    merton_paths(REAL(S0)[0], REAL(mu)[0], REAL(sigma)[0], REAL(lambda)[0], REAL(mu_j)[0], REAL(sigma_j)[0], REAL(T)[0], n_steps, n_paths, buf);

    SEXP out = Rf_allocMatrix(REALSXP, n_steps, n_paths);
    for (int i = 0; i < n_paths; ++i)
        for (int j = 0; j < n_steps; ++j)
            REAL(out)[j + n_steps * i] = buf[i * n_steps + j];
    
    free(buf);
    return out;
}


static SEXP _r_rf_f_fn  = NULL;
static SEXP _r_rf_df_fn = NULL;

static double _r_rf_f(double x)
{
    SEXP arg = PROTECT(Rf_ScalarReal(x));
    SEXP call = PROTECT(Rf_lang2(_r_rf_f_fn, arg));
    SEXP res = PROTECT(Rf_eval(call, R_GlobalEnv));
    double val = REAL(res)[0];
    UNPROTECT(3);
    return val;
}

static double _r_rf_df(double x)
{
    SEXP arg = PROTECT(Rf_ScalarReal(x));
    SEXP call = PROTECT(Rf_lang2(_r_rf_df_fn, arg));
    SEXP res = PROTECT(Rf_eval(call, R_GlobalEnv));
    double val = REAL(res)[0];
    UNPROTECT(3);
    return val;
}


SEXP r_rootfind_newton(SEXP f, SEXP df, SEXP x0, SEXP tol, SEXP max_iter)
{
    _r_rf_f_fn  = f;
    _r_rf_df_fn = df;
    double result = rootfind_newton(_r_rf_f, _r_rf_df, REAL(x0)[0], REAL(tol)[0], INTEGER(max_iter)[0]);
    return Rf_ScalarReal(result);
}


SEXP r_rootfind_bisect(SEXP f, SEXP a, SEXP b, SEXP tol, SEXP max_iter)
{
    _r_rf_f_fn = f;
    double result = rootfind_bisect(_r_rf_f, REAL(a)[0], REAL(b)[0], REAL(tol)[0], INTEGER(max_iter)[0]);
    return Rf_ScalarReal(result);
}


typedef struct { 
    SEXP fn; 
} r_scalar_ctx;

static double _r_scalar_f(double x, void *params)
{
    SEXP fn = ((r_scalar_ctx *)params)->fn;
    SEXP arg = PROTECT(Rf_ScalarReal(x));
    SEXP call = PROTECT(Rf_lang2(fn, arg));
    SEXP res = PROTECT(Rf_eval(call, R_GlobalEnv));
    double val = REAL(res)[0];
    UNPROTECT(3);
    return val;
}


SEXP r_integrate_gauss(SEXP f, SEXP a, SEXP b, SEXP n_points)
{
    r_scalar_ctx ctx = { f };
    double result = integrate_gauss(_r_scalar_f, REAL(a)[0], REAL(b)[0], INTEGER(n_points)[0], &ctx);
    return Rf_ScalarReal(result);
}


SEXP r_integrate_gsl(SEXP f, SEXP a, SEXP b, SEXP tol)
{
    r_scalar_ctx ctx = { f };
    double result = integrate_gsl(_r_scalar_f, REAL(a)[0], REAL(b)[0], REAL(tol)[0], &ctx);
    return Rf_ScalarReal(result);
}