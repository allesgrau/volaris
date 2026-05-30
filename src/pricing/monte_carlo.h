#ifndef VOLARIS_MONTE_CARLO_H
#define VOLARIS_MONTE_CARLO_H

double mc_price_european(double S, double K, double T, double r, double sigma, int N_paths, int is_call, double *std_err);
double mc_price_asian(double S, double K, double T, double r, double sigma, int N_paths, int N_steps, int is_call);
double mc_price_barrier(double S, double K, double T, double r, double sigma, int N_paths, int N_steps, double B, int is_upper, int is_knockout, int is_call);

#endif