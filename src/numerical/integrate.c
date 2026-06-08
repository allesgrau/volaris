#include "integrate.h"
#include <gsl/gsl_integration.h>


double integrate_gauss(double (*f)(double, void *), double a, double b, int n_points)
{
    gsl_function gsl_f = { 
        f, 
        NULL 
    };
    
    gsl_integration_glfixed_table *t = gsl_integration_glfixed_table_alloc((size_t)n_points);
    double result = gsl_integration_glfixed(&gsl_f, a, b, t);
    gsl_integration_glfixed_table_free(t);
    return result;
}


double integrate_gsl(double (*f)(double, void *), double a, double b, double tol)
{
    gsl_function gsl_f = { 
        f, 
        NULL 
    };
    
    gsl_integration_workspace *w = gsl_integration_workspace_alloc(1000);
    double result;
    double abserr;
    gsl_integration_qags(&gsl_f, a, b, 0.0, tol, 1000, w, &result, &abserr);
    gsl_integration_workspace_free(w);

    return result;
}