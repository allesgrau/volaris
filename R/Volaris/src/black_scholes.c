#include "black_scholes.h"
#include <math.h>

#ifndef PI
#define PI 3.14159265358979323846
#endif


/* distribution function for the N(0,1) distribution */

static double norm_cdf(double x) 
{
    return 0.5 * (1.0 + erf(x / sqrt(2.0)));
}


/* probability density function for the N(0,1) distribution */

static double norm_pdf(double x) 
{
    return (1.0 / sqrt(2.0 * PI)) * exp(-0.5 * x * x);
}


/* variables used in the Black-Scholes formula */

static double calc_d1(double S, double K, double T, double r, double sigma) 
{
    return (log(S / K) + (r + 0.5 * sigma * sigma) * T) / (sigma * sqrt(T));
}

static double calc_d2(double d1, double sigma, double T) 
{
    return d1 - sigma * sqrt(T);
}


/* main Black-Scholes price function */

double bs_price(double S, double K, double T, double r, double sigma, int is_call) 
{
    double d1 = calc_d1(S, K, T, r, sigma);
    double d2 = calc_d2(d1, sigma, T);

    if (is_call)    return S * norm_cdf(d1) - K * exp(-r * T) * norm_cdf(d2);
    else            return K * exp(-r * T) * norm_cdf(-d2) - S * norm_cdf(-d1);
}


/* greeks */

double bs_delta(double S, double K, double T, double r, double sigma, int is_call) 
{
    double d1 = calc_d1(S, K, T, r, sigma);
    if (is_call)    return norm_cdf(d1);
    else            return norm_cdf(d1) - 1.0;
}

double bs_gamma(double S, double K, double T, double r, double sigma) 
{
    double d1 = calc_d1(S, K, T, r, sigma);
    return norm_pdf(d1) / (S * sigma * sqrt(T));
}

double bs_vega(double S, double K, double T, double r, double sigma) 
{
    double d1 = calc_d1(S, K, T, r, sigma);
    return S * norm_pdf(d1) * sqrt(T);
}

double bs_theta(double S, double K, double T, double r, double sigma, int is_call) 
{
    double d1 = calc_d1(S, K, T, r, sigma);
    double d2 = calc_d2(d1, sigma, T);

    double first_part = - (S * norm_pdf(d1) * sigma) / (2.0 * sqrt(T));
    double second_part = r * K * exp(-r * T);

    if (is_call)    return first_part - second_part * norm_cdf(d2);
    else            return first_part + second_part * norm_cdf(-d2);
}

double bs_rho(double S, double K, double T, double r, double sigma, int is_call) 
{
    double d1 = calc_d1(S, K, T, r, sigma);
    double d2 = calc_d2(d1, sigma, T);

    if (is_call)    return K * T * exp(-r * T) * norm_cdf(d2);
    else            return -K * T * exp(-r * T) * norm_cdf(-d2);
}