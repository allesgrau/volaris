#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>
#include "../../../src/pricing/black_scholes.h"


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