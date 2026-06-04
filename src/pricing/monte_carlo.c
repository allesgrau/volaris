#include "monte_carlo.h"
#include "../utils/lcg.h"
#include <stdlib.h>
#include <math.h>
#include <omp.h>

#define MAX_THREADS 256


/* European options pricing */

double mc_price_european(double S, double K, double T, double r, double sigma, int N_paths, int is_call, double *std_err)
{
    int tmax = omp_get_max_threads();
    unsigned long long* seeds = (unsigned long long*)malloc(tmax * sizeof(unsigned long long));
    for (size_t i = 0; i < (size_t)tmax; ++i)
        seeds[i] = (unsigned long long)(i + 1) * 2654435761ULL;
    
    double sum = 0.0;
    double sum_sq = 0.0;
    double defl = exp(-r * T);
    double drift = (r - 0.5 * sigma * sigma) * T;
    double vol = sigma * sqrt(T);

    #pragma omp parallel for reduction(+:sum, sum_sq)
    for (size_t i = 0; i < (size_t)N_paths; ++i) {
        int tid = omp_get_thread_num();
        double z = lcg_normal(&seeds[tid]);
        double S_T = S * exp(drift + vol * z);
        double payoff = is_call ? fmax(S_T - K, 0.0) : fmax(K - S_T, 0.0);
        sum += payoff;
        sum_sq += payoff * payoff;
    }
    free(seeds);

    if (std_err) {
        double mean = sum / N_paths;
        *std_err = defl * sqrt((sum_sq / N_paths - mean * mean) / N_paths);
    }

    return defl * sum / N_paths;
}


/* Asian options pricing */

double mc_price_asian(double S, double K, double T, double r, double sigma, int N_paths, int N_steps, int is_call)
{
    int tmax = omp_get_max_threads();
    unsigned long long* seeds = (unsigned long long*)malloc(tmax * sizeof(unsigned long long));
    for (size_t i = 0; i < (size_t)tmax; ++i)
        seeds[i] = (unsigned long long)(i + 1) * 2654435761ULL;

    double sum = 0.0;
    double defl = exp(-r * T);
    double dt = T / N_steps;
    double drift = (r - 0.5 * sigma * sigma) * dt;
    double vol = sigma * sqrt(dt);

    #pragma omp parallel for reduction(+:sum)
    for (size_t i = 0; i < (size_t)N_paths; ++i) {
        int tid = omp_get_thread_num();
        double S_t = S;
        double path_sum = 0.0;
        for (size_t t = 0; t < (size_t)N_steps; ++t) {
            S_t *= exp(drift + vol * lcg_normal(&seeds[tid]));
            path_sum += S_t;
        }
        double avg = path_sum / N_steps;
        double payoff = is_call ? fmax(avg - K, 0.0) : fmax(K - avg, 0.0);
        sum += payoff;
    }
    free(seeds);

    return defl * sum / N_paths;
}


/* Barrier option */

double mc_price_barrier(double S, double K, double T, double r, double sigma, int N_paths, int N_steps, double B, int is_upper, int is_knockout, int is_call)
{
    int tmax = omp_get_max_threads();
    unsigned long long* seeds = (unsigned long long*)malloc(tmax * sizeof(unsigned long long));
    for (size_t i = 0; i < (size_t)tmax; ++i)
        seeds[i] = (unsigned long long)(i + 1) * 2654435761ULL;

    double sum = 0.0;
    double defl = exp(-r * T);
    double dt = T / N_steps;
    double drift = (r - 0.5 * sigma * sigma) * dt;
    double vol = sigma * sqrt(dt);

    #pragma omp parallel for reduction(+:sum)
    for (size_t i = 0; i < (size_t)N_paths; ++i) {
        int tid = omp_get_thread_num();
        double S_t = S;
        int barrier_hit = 0;
        for (size_t t = 0; t < (size_t)N_steps; ++t) {
            S_t *= exp(drift + vol * lcg_normal(&seeds[tid]));
            int hit = is_upper ? (S_t >= B) : (S_t <= B);
            if (hit)
            {
                barrier_hit = 1;
                if (is_knockout) break;
            }
        }
        double payoff_no_barrier = is_call ? fmax(S_t - K, 0.0) : fmax(K - S_t, 0.0);
        double payoff = is_knockout ? (barrier_hit ? 0.0 : payoff_no_barrier) : (barrier_hit ? payoff_no_barrier : 0.0);
        sum += payoff;
    }
    free(seeds);

    return defl * sum / N_paths;
}