#include "jump_diffusion.h"
#include "lcg.h"
#include <stdlib.h>
#include <math.h>
#include <omp.h>


static int lcg_poisson(double lam, unsigned long long *state)
{
    double L = exp(-lam);
    int k = 0;
    double p = 1.0;

    while (1)
    {
        ++k;
        p *= lcg_uniform(state);
        if (p <= L) break;
    }

    return k - 1;
}


void merton_paths(double S0, double mu, double sigma, double lambda, double mu_j, double sigma_j, double T, int N_steps, int N_paths, double *out)
{
    double dt = T / N_steps;
    double k_jump  = exp(mu_j + 0.5 * sigma_j * sigma_j) - 1.0;
    double drift = (mu - lambda * k_jump - 0.5 * sigma * sigma) * dt;
    double vol = sigma * sqrt(dt);
    double lam_dt = lambda * dt;

    int tmax = omp_get_max_threads();
    unsigned long long *seeds = (unsigned long long *)malloc(tmax * sizeof(unsigned long long));
    for (size_t t = 0; t < (size_t)tmax; ++t)
        seeds[t] = (unsigned long long)(t + 1) * 1234567891ULL;

    int i;
    #pragma omp parallel for
    for (i = 0; i < N_paths; ++i) {
        int tid = omp_get_thread_num();
        double S = S0;
        for (size_t j = 0; j < (size_t)N_steps; ++j) {
            double diffusion = drift + vol * lcg_normal(&seeds[tid]);
            int n_jumps  = lcg_poisson(lam_dt, &seeds[tid]);
            double jump_sum = 0.0;
            for (size_t jj = 0; jj < (size_t)n_jumps; ++jj)
                jump_sum += mu_j + sigma_j * lcg_normal(&seeds[tid]);
            S *= exp(diffusion + jump_sum);
            out[i * N_steps + j] = S;
        }
    }

    free(seeds);
}