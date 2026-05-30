#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>
#include "../../../src/pricing/black_scholes.c"
#include "../../../src/pricing/binomial_tree.c"
#include "../../../src/pricing/monte_carlo.c"
#include "../../../src/volatility/historical_vol.c"


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
        Rf_error("Type error: returns must be numeric, n must be integer.");
    
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
        Rf_error("Type error: open, high, low, close must be numeric, n must be integer.");
    
        return Rf_ScalarReal(vol_garman_klass(REAL(high), REAL(low), REAL(open), REAL(close), INTEGER(n)[0]));
}


SEXP r_vol_yang_zhang(SEXP open, SEXP high, SEXP low, SEXP close, SEXP n)
{
    if (!Rf_isReal(open) || !Rf_isReal(high) || !Rf_isReal(low) || !Rf_isReal(close) || !Rf_isInteger(n))
        Rf_error("Type error: open, high, low, close must be numeric, n must be integer.");
    
    return Rf_ScalarReal(vol_yang_zhang(REAL(high), REAL(low), REAL(open), REAL(close), INTEGER(n)[0]));
}