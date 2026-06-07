#ifndef VOLARIS_MCMC_H
#define VOLARIS_MCMC_H

typedef struct _log_posterior_t {
    double (*fn)(const double *theta, int n_params, void *data);
    void *data;
} log_posterior_t;

void mh_sampler(log_posterior_t log_post, const double *theta_init, int n_params, int n_iter, int n_burning, const double *proposal, double *out);
double log_posterior_gbm(const double *theta, int n_params, void *data);
void mh_sampler_gbm(const double *returns, int n, double dt, int n_iter, int n_burning, double mu_init, double sigma_init, double proposal_mu, double proposal_sigma, double *out);

#endif