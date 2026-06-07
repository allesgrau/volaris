#include "garch.hpp"
#include <vector>
#include <cmath>
#include <algorithm>
#include <numeric>
#include <limits>
#include <array>
#include <stdexcept>

using Vec = std::vector<double>;
using Vec3 = std::array<double, 3>;
using Vec4 = std::array<double, 4>;


namespace volaris {


    static double neg_loglikelihood(const Vec& r, double omega, double alpha, double beta)
    {
        if (omega <= 0.0 || alpha < 0.0 || beta < 0.0 || alpha + beta >= 1.0)
            return std::numeric_limits<double>::infinity();

        const int n = static_cast<int>(r.size());
        double h = omega / (1.0 - alpha - beta);
        double ll = 0.0;

        for (int t = 0; t < n; ++t)
        {
            if (h <= 0.0)
                return std::numeric_limits<double>::infinity();
            
            ll += std::log(h) + r[t] * r[t] / h;
            h = omega + alpha * r[t] * r[t] + beta * h;
        }

        return 0.5 * ll;
    }


    static Vec3 centroid(const Vec3& a, const Vec3& b, const Vec3& c)
    {
        return {(a[0] + b[0] + c[0]) / 3.0, 
                (a[1] + b[1] + c[1]) / 3.0,
                (a[2] + b[2] + c[2]) / 3.0};
    }


    static Vec3 reflect(const Vec3& center, const Vec3& worst, double t)
    {
        return {center[0] + t*(center[0] - worst[0]),
                center[1] + t*(center[1] - worst[1]),
                center[2] + t*(center[2] - worst[2])};
    }


    GarchFit garch11_fit(const Vec& returns)
    {
        // 1. Input validation

        if (returns.size() < 10)
            throw std::invalid_argument("Need at least 10 observations for GARCH(1, 1) calibration.");

        // 2. Starting point

        double mean = std::accumulate(returns.begin(), returns.end(), 0.0) / returns.size();

        double var = 0.0;
        for (double x : returns)
            var += (x - mean) * (x - mean);
        var /= returns.size();

        double omega0 = var * 0.05;

        // 3. Initialization - vertices in the (omega, alpha, beta) space

        std::array<Vec3, 4> vertices = {{{omega0, 0.10, 0.85}, {omega0 * 2.0, 0.10, 0.85}, {omega0, 0.15, 0.85}, {omega0, 0.10, 0.80}}};
        
        Vec4 loss_values;
        for (int i = 0; i < 4; ++i)
            loss_values[i] = neg_loglikelihood(returns, vertices[i][0], vertices[i][1], vertices[i][2]);

        // 4. Main loop for Nelder-Mead optimalization

        const int max_iter = 5000;
        const double tol = 1e-8;

        for (int iter = 0; iter < max_iter; ++iter)
        {
            // 4a. Sort indices 0-3 based on the loss function
            std::array<int, 4> idx = {0, 1, 2, 3};
            std::sort(idx.begin(), idx.end(), [&](int a, int b){
                return loss_values[a] < loss_values[b];
            });

            // 4b. Stop condition
            if ((loss_values[idx[3]] - loss_values[idx[0]]) / (std::abs(loss_values[idx[0]]) + 1.0) < tol)
                break;

            // 4c. Symetrical reflection of the worst point and its new loss function
            Vec3 cent_point = centroid(vertices[idx[0]], vertices[idx[1]], vertices[idx[2]]);
            Vec3 x_reflected = reflect(cent_point, vertices[idx[3]], 1.0);
            double loss_reflected = neg_loglikelihood(returns, x_reflected[0], x_reflected[1], x_reflected[2]);

            if (loss_reflected < loss_values[idx[0]]) {               // 4d. reflection of the worst point = new best point + expansion
                Vec3 x_expanded = reflect(cent_point, vertices[idx[3]], 2.0);
                double loss_expanded = neg_loglikelihood(returns, x_expanded[0], x_expanded[1], x_expanded[2]);
                vertices[idx[3]] = (loss_expanded < loss_reflected) ? x_expanded : x_reflected;
                loss_values[idx[3]] = (loss_expanded < loss_reflected) ? loss_expanded : loss_reflected;
            } else if (loss_reflected < loss_values[idx[2]]) {        // 4e. reflection of the worst point = better than 3rd best point
                vertices[idx[3]] = x_reflected;
                loss_values[idx[3]] = loss_reflected;
            } else {                                                  // 4f. reflection of the worst point is still the worst point
                Vec3 x_contracted = reflect(cent_point, vertices[idx[3]], -0.5);
                double loss_contracted = neg_loglikelihood(returns, x_contracted[0], x_contracted[1], x_contracted[2]);
                if (loss_contracted < loss_values[idx[3]]) {          // 4fa. instead of reflecting, we go in the direction of the centroid
                    vertices[idx[3]] = x_contracted;
                    loss_values[idx[3]] = loss_contracted;
                } else {                                              // 4fb. instead of reflecting, we move each point other than the best one in the direction of the best one
                    for (int i = 1; i < 4; ++i) {
                        for (int j = 0; j < 3; ++j)
                            vertices[idx[i]][j] = 0.5 * (vertices[idx[0]][j] + vertices[idx[i]][j]);
                        loss_values[idx[i]] = neg_loglikelihood(returns, vertices[idx[i]][0], vertices[idx[i]][1], vertices[idx[i]][2]);
                    }
                }
            }
        }

        // 5. Results
        int best = static_cast<int>(std::min_element(loss_values.begin(), loss_values.end()) - loss_values.begin());

        GarchFit fit;
        fit.omega = vertices[best][0];
        fit.alpha = vertices[best][1];
        fit.beta = vertices[best][2];
        fit.log_likelihood = -loss_values[best];
        fit.converged = (fit.omega > 0.0 && fit.alpha >= 0.0 && fit.beta >= 0.0 && fit.alpha + fit.beta < 1.0);

        return fit;
    }


    Vec garch11_variances(const GarchFit& fit, const Vec& returns)
    {
        const int n = static_cast<int>(returns.size());
        Vec h(n);
        h[0] = fit.omega / (1.0 - fit.alpha - fit.beta);

        for (int t = 1; t < n; ++t)
            h[t] = fit.omega + fit.alpha * returns[t - 1] * returns[t - 1] + fit.beta * h[t - 1];
        
        return h;
    }


    Vec garch11_forecast(const GarchFit& fit, const Vec& returns, int h)
    {
        auto vars = garch11_variances(fit, returns);
        const int n = static_cast<int>(returns.size());

        double h_T = vars.back();
        double h_Tp1 = fit.omega + fit.alpha * returns[n - 1] * returns[n - 1] + fit.beta * h_T;
        double h_stable = fit.omega / (1.0 - fit.alpha - fit.beta);
        double persistance = fit.alpha + fit.beta;

        Vec fc(h);
        fc[0] = h_Tp1;
        for (int k = 1; k < h; ++k)
            fc[k] = h_stable + std::pow(persistance, k) * (h_Tp1 - h_stable);

        return fc;
    }

}