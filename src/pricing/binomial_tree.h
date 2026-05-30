#ifndef VOLARIS_BINOMIAL_TREE_H
#define VOLARIS_BINOMIAL_TREE_H

double binomial_price(double S, double K, double T, double r, double q, double sigma, int N, int is_call, int is_american);

#endif