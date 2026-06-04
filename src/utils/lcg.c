#include <math.h>

#define PI 3.14159265358979323846


// :D
double lcg_uniform(unsigned long long *state) {
    *state = *state * 6364136223846793005ULL + 1442695040888963407ULL;
    return (double)(*state >> 11) / (double)(1ULL << 53);
}

double lcg_normal(unsigned long long *state) {
    double u1 = lcg_uniform(state);
    double u2 = lcg_uniform(state);
    if (u1 < 1e-300)
        u1 = 1e-300;
    return sqrt(-2.0 * log(u1)) * cos(2.0 * PI * u2);
}