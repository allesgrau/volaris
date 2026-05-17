#ifndef VOLARIS_BLACK_SCHOLES_H
#define VOLARIS_BLACK_SCHOLES_H

double bs_price(double S, double K, double T, double r, double sigma, int is_call);
double bs_delta(double S, double K, double T, double r, double sigma, int is_call);
double bs_gamma(double S, double K, double T, double r, double sigma);
double bs_vega(double S, double K, double T, double r, double sigma);
double bs_theta(double S, double K, double T, double r, double sigma, int is_call);
double bs_rho(double S, double K, double T, double r, double sigma, int is_call);

#endif