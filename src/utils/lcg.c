#include <math.h>


double lcg_uniform(unsigned long long *state) {
    *state = *state * 6364136223846793005ULL + 1442695040888963407ULL;
    return (double)(*state >> 11) / (double)(1ULL << 53);
}

double lcg_normal(unsigned long long *state) {
    double u, v, s;
    do {
        u = 2.0 * lcg_uniform(state) - 1.0;
        v = 2.0 * lcg_uniform(state) - 1.0;
        s = u * u + v * v;
    } while (s >= 1.0 || s == 0.0);
    return u * sqrt(-2.0 * log(s) / s);
}