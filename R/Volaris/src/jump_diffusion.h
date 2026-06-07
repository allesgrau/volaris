#ifndef VOLARIS_JUMP_DIFFUSION_H
#define VOLARIS_JUMP_DIFFUSION_H

void merton_paths(double S0, double mu, double sigma, double lambda, double mu_j, double sigma_j, double T, int N_steps, int N_paths, double *out);

#endif