#include "mcmc.h"
#include "lcg.h"
#include <stdlib.h>
#include <math.h>


void mh_sampler(log_posterior_t log_post, const double *theta_init, int n_params, int n_iter, int n_burning, const double *proposal, double *out)
{
    double *theta = (double *)malloc(n_params * sizeof(double));
    double *theta_new = (double *)malloc(n_params * sizeof(double));
    
    for (size_t j=0; j<(size_t)n_params; ++j)
        theta[j] = theta_init[j];

    unsigned long long rng = 2654435761ULL;
    double log_p = log_post.fn(theta, n_params, log_post.data);
    int out_idx  = 0;

    for (size_t i = 0; i < (size_t)n_iter; ++i) {

        for (int j = 0; j < n_params; ++j)
              theta_new[j] = theta[j] + proposal[j] * lcg_normal(&rng);

        double log_p_new = log_post.fn(theta_new, n_params, log_post.data);

        if (log(lcg_uniform(&rng)) < log_p_new - log_p) {
            for (size_t j=0; j<(size_t)n_params; ++j)
                theta[j] = theta_new[j];
            log_p = log_p_new;
        }

        if (i >= n_burning) {
            for (int j = 0; j < n_params; ++j)
                out[out_idx * n_params + j] = theta[j];
            ++out_idx;
        }
    }

    free(theta);
    free(theta_new);
}


typedef struct _gbm_data { 
    const double *returns; 
    int n; 
    double dt; 
} gbm_data;

double log_posterior_gbm(const double *theta, int n_params, void *data)
{
    (void)n_params;
    gbm_data *d = (gbm_data *)data;
    double mu = theta[0];
    double sigma = theta[1];

    if (sigma <= 0.0) 
        return -1e100;

    double drift = (mu - 0.5 * sigma * sigma) * d->dt;
    double vol = sigma * sqrt(d->dt);
    double inv_vol = 1.0 / vol;
    double log_lk = -(double)d->n * log(vol);

    for (size_t i = 0; i < (size_t)d->n; ++i) {
        double z = (d->returns[i] - drift) * inv_vol;
        log_lk -= 0.5 * z * z;
    }

    return log_lk;
}


void mh_sampler_gbm(const double *returns, int n, double dt, int n_iter, int n_burning, double mu_init, double sigma_init, double proposal_mu, double proposal_sigma, double *out)
{
    gbm_data gbm = { returns, n, dt };
    log_posterior_t log_post = { log_posterior_gbm, &gbm };
    double theta_init[2] = { mu_init, sigma_init };
    double proposal_sd[2] = { proposal_mu, proposal_sigma };
    mh_sampler(log_post, theta_init, 2, n_iter, n_burning, proposal_sd, out);
}