#include "binomial_tree.h"
#include <math.h>
#include <stdlib.h>


/* main function for options pricing with a binomial tree */

double binomial_price(double S, double K, double T, double r, double q, double sigma, int N, int is_call, int is_american)
{
    double deltaT = T / N;
    double up = exp(sigma * sqrt(deltaT));
    double p0 = (up * exp(-q * deltaT) - exp(-r * deltaT)) / (up * up - 1.0);
    double p1 = exp(-r * deltaT) - p0;

    double *p = malloc((N + 1) * sizeof(double));

    for (int i = 0; i <= N; ++i) 
    {
        double ST = S * pow(up, 2*i - N);
        p[i] = is_call ? fmax(ST - K, 0.0) : fmax(K - ST, 0.0);
    }

    for (int j = N - 1; j >= 0; --j) 
    {
        for (int i = 0; i <= j; ++i) 
        {
            p[i] = p0 * p[i+1] + p1 * p[i];
            if (is_american) 
            {
                double ST = S * pow(up, 2*i - j);
                double exercise = is_call ? fmax(ST - K, 0.0) : fmax(K - ST, 0.0);
                if (exercise > p[i]) 
                    p[i] = exercise;
            }
        }
    }
    
    double price = p[0];
    free(p);
    return price;
}