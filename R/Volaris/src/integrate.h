#ifndef VOLARIS_INTEGRATE_H
#define VOLARIS_INTEGRATE_H

double integrate_gauss(double (*f)(double, void *), double a, double b, int n_points, void *params);
double integrate_gsl(double (*f)(double, void *), double a, double b, double tol, void *params);

#endif