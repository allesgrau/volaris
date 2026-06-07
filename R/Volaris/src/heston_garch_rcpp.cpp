#include <Rcpp.h>
#include "heston.hpp"
#include "garch.hpp"

using namespace Rcpp;
using namespace volaris;

// [[Rcpp::export]]
double heston_price_r(double S, double K, double T, double r, double v0, double kappa, double theta, double xi, double rho, int is_call) 
{
    return heston_price(S, K, T, r, v0, kappa, theta, xi, rho, is_call);
}

// [[Rcpp::export]]
List garch11_fit_r(NumericVector returns) 
{
    std::vector<double> r(returns.begin(), returns.end());
    GarchFit fit = garch11_fit(r);
    return List::create(
        Named("omega") = fit.omega,
        Named("alpha") = fit.alpha,
        Named("beta") = fit.beta,
        Named("log_likelihood") = fit.log_likelihood,
        Named("converged") = fit.converged,
        Named("persistence") = fit.alpha + fit.beta
    );
}

// [[Rcpp::export]]
NumericVector garch11_variances_r(double omega, double alpha, double beta, NumericVector returns) 
{
    GarchFit fit;
    fit.omega = omega; 
    fit.alpha = alpha; 
    fit.beta = beta;
    std::vector<double> r(returns.begin(), returns.end());
    auto h = garch11_variances(fit, r);
    return NumericVector(h.begin(), h.end());
}

// [[Rcpp::export]]
NumericVector garch11_forecast_r(double omega, double alpha, double beta, NumericVector returns, int h) 
{
    GarchFit fit;
    fit.omega = omega; 
    fit.alpha = alpha; 
    fit.beta = beta;
    std::vector<double> r(returns.begin(), returns.end());
    auto fc = garch11_forecast(fit, r, h);
    return NumericVector(fc.begin(), fc.end());
}