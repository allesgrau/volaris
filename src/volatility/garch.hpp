#ifndef VOLARIS_GARCH_HPP
#define VOLARIS_GARCH_HPP

#include <vector>

namespace volaris {

    struct GarchFit {
        double omega;
        double alpha;
        double beta;
        double log_likelihood;
        bool converged;
    };

    GarchFit garch11_fit(const std::vector<double>&returns);
    std::vector<double> garch11_variances(const GarchFit& fit, const std::vector<double>& returns);
    std::vector<double> garch11_forecast(const GarchFit& fit, const std::vector<double>& returns, int h);

}

#endif