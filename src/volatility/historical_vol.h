#ifndef VOLARIS_HISTORICAL_VOL_H
#define VOLARIS_HISTORICAL_VOL_H

double vol_close_to_close(const double *returns, int n);
double vol_parkinson(const double *high, const double *low, int n);
double vol_garman_klass(const double *high, const double *low, const double *open, const double *close, int n);
double vol_yang_zhang(const double *high, const double *low, const double *open, const double *close, int n);

#endif