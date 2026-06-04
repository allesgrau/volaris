#include "rootfind.h"
#include <math.h>


double rootfind_newton(double (*f)(double), double (*df)(double), double x0, double tol, int max_iter)
{
    double x = x0;
    for (size_t i = 0; i < (size_t)max_iter; ++i) 
    {
        double fx = f(x);

        if (fabs(fx) < tol)
            return x;
        
        double dfx = df(x);
        if (fabs(dfx) < 1e-15)
            return x;
        
        x -= fx / dfx;
    }
    return x;
}


double rootfind_bisect(double (*f)(double), double a, double b, double tol, int max_iter)
{
    double fa = f(a);
    double fb = f(b);
    if (fa * fb > 0.0)
        return NAN;

    double c = a;
    for (size_t i = 0; i < (size_t)max_iter; ++i) 
    {
        c = 0.5 * (a + b);
        double fc = f(c);

        if (fabs(fc) < tol || 0.5 * (b - a) < tol)
            break;

        if (fa * fc < 0.0)
            b = c;
        else {
            a = c;
            fa = fc;
        }
    }
    
    return c;
}