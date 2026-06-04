#include "historical_vol.h"
#include <math.h>
#include <stdlib.h>

#define TRADING_DAYS 252.0


double vol_close_to_close(const double *returns, int n)
{
    double mean = 0.0;
    for (size_t i = 0; i < (size_t)n; ++i)
        mean += returns[i];
    mean /= n;

    double var = 0.0;
    for (size_t i = 0; i < (size_t)n; ++i)
        var += (returns[i] - mean) * (returns[i] - mean);
    var /= (n - 1);

    return sqrt(var * TRADING_DAYS);
}


double vol_parkinson(const double *high, const double *low, int n)
{
    double sum = 0.0;
    for (size_t i = 0; i < (size_t)n; ++i) 
    {
        double hl = log(high[i] / low[i]);
        sum += hl * hl;
    }
    return sqrt(sum / (4.0 * n * log(2.0)) * TRADING_DAYS);
}


double vol_garman_klass(const double *high, const double *low, const double *open, const double *close, int n)
{
    double sum = 0.0;
    for (size_t i = 0; i < (size_t)n; ++i) {
        double hl = log(high[i] / low[i]);
        double co = log(close[i] / open[i]);
        sum += 0.5 * hl * hl - (2.0 * log(2.0) - 1.0) * co * co;
    }
    return sqrt(sum / n * TRADING_DAYS);
}


double vol_yang_zhang(const double *high, const double *low, const double *open, const double *close, int n)
{
    double mean_o = 0.0;
    for (size_t i = 1; i < (size_t)n; ++i)
        mean_o += log(open[i] / close[i - 1]);
    mean_o /= (n - 1);

    double var_o = 0.0;
    for (size_t i = 1; i < (size_t)n; ++i) {
        double o = log(open[i] / close[i - 1]) - mean_o;
        var_o += o * o;
    }
    var_o /= (n - 2);

    double mean_c = 0.0;
    for (size_t i = 0; i < (size_t)n; ++i)
        mean_c += log(close[i] / open[i]);
    mean_c /= n;

    double var_c = 0.0;
    for (size_t i = 0; i < (size_t)n; ++i) {
        double c = log(close[i] / open[i]) - mean_c;
        var_c += c * c;
    }
    var_c /= (n - 1);

    double var_rs = 0.0;
    for (size_t i = 0; i < (size_t)n; ++i) {
        double ho = log(high[i] / open[i]);
        double hc = log(high[i] / close[i]);
        double lo = log(low[i] / open[i]);
        double lc = log(low[i] / close[i]);
        var_rs += ho * hc + lo * lc;
    }
    var_rs /= n;

    double k = 0.34 / (1.34 + (double)(n + 1) / (n - 1));
    double var = var_o + k * var_c + (1.0 - k) * var_rs;
    return sqrt(var * TRADING_DAYS);
}