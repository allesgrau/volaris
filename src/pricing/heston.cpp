#include "heston.hpp"
#include <complex>
#include <cmath>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

using Cx = std::complex<double>;
static const Cx I(0.0, 1.0);


namespace volaris {

    
    /* Heston characteristic function phi_j */

    static Cx heston_cf(double u, double tau, double ln_S, double r, double v0, double kappa, double theta, double xi, double rho, int j)
    {
        Cx iu  = u * I;
        double b_j = (j == 1) ? (kappa - rho * xi) : kappa;
        double u_j = (j == 1) ? 0.5 : -0.5;

        // d = sqrt((rho*xi*iu - b_j)^2 - xi^2*(2*u_j*iu - u^2))
        Cx d = std::sqrt((rho * xi * iu - b_j) * (rho * xi * iu - b_j) - xi * xi * (2.0 * u_j * iu - u * u));

        // g = (b_j - rho*xi*iu + d) / (b_j - rho*xi*iu - d)
        Cx g = (b_j - rho * xi * iu + d) / (b_j - rho * xi * iu - d);

        // exp(-d*tau)
        Cx e_mdt = std::exp(-d * tau);

        // A = r*iu*tau + (kappa*theta/xi^2)*[(g_num)*tau - 2*log((1-g*e^{-dtau})/(1-g))]
        Cx log_val = std::log((1.0 - g * e_mdt) / (1.0 - g));
        Cx A = r * iu * tau + (kappa * theta / (xi * xi)) * ((b_j - rho * xi * iu + d) * tau - 2.0 * log_val);

        // B = (g_num / xi^2) * (1 - e^{-dtau}) / (1 - g*e^{-dtau})
        Cx B = ((b_j - rho * xi * iu + d) / (xi * xi)) * (1.0 - e_mdt) / (1.0 - g * e_mdt);
        
        // phi = exp(A + B*v0 + iu*ln_S)
        return std::exp(A + B * v0 + iu * ln_S);
    }


    /* Integrand for P_j */

    static double heston_integrand(double u, double tau, double S, double K, double r, double v0, double kappa, double theta, double xi, double rho, int j)
    {
        Cx phi = heston_cf(u, tau, std::log(S), r, v0, kappa, theta, xi, rho, j);
        Cx val = phi * std::exp(-I * u * std::log(K)) / (I * u);
        return std::real(val);
    }


    /* Computing P_j */

    static double compute_P(double tau, double S, double K, double r, double v0, double kappa, double theta, double xi, double rho, int j)
    {
        const int N = 5000;
        const double eps = 1e-8;
        const double U_max = 100.0;
        const double du = (U_max - eps) / N;

        double sum = heston_integrand(eps,   tau, S, K, r, v0, kappa, theta, xi, rho, j) + heston_integrand(U_max, tau, S, K, r, v0, kappa, theta, xi, rho, j);

        for (int k = 1; k < N; ++k) {
            double u = eps + k * du;
            double w = (k % 2 == 0) ? 2.0 : 4.0;
            sum += w * heston_integrand(u, tau, S, K, r, v0, kappa, theta, xi, rho, j);
        }

        return 0.5 + (du / 3.0) * sum / M_PI;
    }


    /* European option price */

    double heston_price(double S, double K, double T, double r, double v0, double kappa, double theta, double xi, double rho, int is_call)
    {
        double P1 = compute_P(T, S, K, r, v0, kappa, theta, xi, rho, 1);
        double P2 = compute_P(T, S, K, r, v0, kappa, theta, xi, rho, 0);
        double call = S * P1 - K * std::exp(-r * T) * P2;
        
        return is_call ? call : call - S + K * std::exp(-r * T);
    }

}