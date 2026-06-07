#include "gbm.h"
#include "lcg.h"
#include <stdlib.h>
#include <math.h>
#include <omp.h>


void gbm_paths(double S0, double mu, double sigma, double T, int N_steps, int N_paths, double *out)
{
    double dt = T / N_steps;
    double drift = (mu - 0.5 * sigma * sigma) * dt;
    double vol = sigma * sqrt(dt);

    int tmax = omp_get_max_threads();
    unsigned long long *seeds = (unsigned long long *)malloc(tmax * sizeof(unsigned long long));
    for (size_t t = 0; t < (size_t)tmax; ++t)
        seeds[t] = (unsigned long long)(t + 1) * 1234567891ULL;

    int i;
    #pragma omp parallel for
    for (i = 0; i < N_paths; ++i) 
    {
        int tid = omp_get_thread_num();
        double S = S0;
        for (size_t j = 0; j < (size_t)N_steps; ++j) {
            S *= exp(drift + vol * lcg_normal(&seeds[tid]));
            out[i * N_steps + j] = S;
        }
    }
    free(seeds);
}


void gbm_paths_antithetic(double S0, double mu, double sigma, double T, int N_steps, int N_paths, double *out)
{
    double dt = T / N_steps;
    double drift = (mu - 0.5 * sigma * sigma) * dt;
    double vol = sigma * sqrt(dt);
    int half = N_paths / 2;

    int tmax = omp_get_max_threads();
    unsigned long long *seeds = (unsigned long long *)malloc(tmax * sizeof(unsigned long long));
    for (size_t t = 0; t < (size_t)tmax; ++t)
        seeds[t] = (unsigned long long)(t + 1) * 1234567891ULL;

    int i;
    #pragma omp parallel for
    for (i = 0; i < half; ++i) 
    {
        int tid = omp_get_thread_num();
        double S1 = S0;
        double S2 = S0;
        for (size_t j = 0; j < (size_t)N_steps; ++j) {
            double z = lcg_normal(&seeds[tid]);
            S1 *= exp(drift + vol * z);
            S2 *= exp(drift - vol * z);
            out[i * N_steps + j] = S1;
            out[(i + half) * N_steps + j] = S2;
        }
    }
    free(seeds);
}