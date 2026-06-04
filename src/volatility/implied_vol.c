#include "implied_vol.h"
#include "black_scholes.h"
#include <math.h>

#define PI 3.14159265358979323846


double implied_vol(double market_price, double S, double K, double T, double r, int is_call)
{
    double low = 1e-6;
    double high = 10.0;
    size_t MAX_ITER = 2000;
    double tol = 1e-8;

    if (bs_price(S, K, T, r, low, is_call) > market_price || bs_price(S, K, T, r, high, is_call) < market_price)
        return NAN;

    double sigma = sqrt(2.0 * PI / T) * market_price / S;
    sigma = (sigma < low) ? low : ((sigma > high) ? high : sigma);

    for (size_t i=0; i < MAX_ITER; ++i)
    {
        double f = bs_price(S, K, T, r, sigma, is_call) - market_price;
        double vega = bs_vega(S, K, T, r, sigma);

        if (fabs(f) < tol)
            return sigma;
        
        if (f < 0.0)
            low = sigma;
        else
            high = sigma;

        double sigma_new = (vega > 1e-10) ? sigma - f / vega : 0.5 * (low + high);

        if (sigma_new <= low || sigma_new >= high)
            sigma_new = 0.5 * (low + high);

        if (fabs(sigma_new - sigma) < tol)
            return sigma_new;

        sigma = sigma_new;
    }
    
    return sigma;
}