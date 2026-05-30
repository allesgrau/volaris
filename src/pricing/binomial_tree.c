#define _USE_MATH_DEFINES
#include "binomial_tree.h"
#include <math.h>
#include <stdlib.h>


/* main function for options pricing with a binomial tree */

double binomial_price(double S, double K, double T, double r, double q, double sigma, int N, int is_call, int is_american)
{
    double dt = T / N;
    double u = exp(sigma * sqrt(dt));
    double d = 1.0 / u;
    double p = (exp((r - q) * dt) - d) / (u - d);
    double discount = exp(-r * dt);

    double *V = malloc((N + 1) * sizeof(double));

    for (int i=0; i<=N; ++i) {
        double ST = S * pow(u, N - i) * pow(d, i);
        if (is_call)    V[i] = fmax(0.0, ST - K);
        else            V[i] = fmax(0.0, K - ST);
    }

    for (int j=N-1; j>=0; --j) {
        for (int i=0; i<=j; ++i) {
            V[i] = discount * (p * V[i] + (1.0 - p) * V[i + 1]);
            if (is_american) {
                double ST = S * pow(u, j - i) * pow(d, i);
                double intrinsic;
                if (is_call)    intrinsic = fmax(0.0, ST - K);
                else            intrinsic = fmax(0.0, K - ST);
                if (intrinsic > V[i]) 
                    V[i] = intrinsic;
            }
        }
    }
    
    double price = V[0];
    free(V);
    return price;
}