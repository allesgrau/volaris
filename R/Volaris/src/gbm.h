#ifndef VOLARIS_GBM_H
#define VOLARIS_GBM_H

void gbm_paths(double S0, double mu, double sigma, double T, int N_steps, int N_paths, double *out);
void gbm_paths_antithetic(double S0, double mu, double sigma, double T, int N_steps, int N_paths, double *out);

#endif