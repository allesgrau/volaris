#ifndef VOLARIS_ROOTFIND_H
#define VOLARIS_ROOTFIND_H

double rootfind_newton(double (*f)(double), double (*df)(double), double x0, double tol, int max_iter);
double rootfind_bisect(double (*f)(double), double a, double b, double tol, int max_iter);

#endif