import timeit
import numpy as np
from scipy.stats import norm
from scipy.optimize import brentq, newton as scipy_newton
from scipy.optimize import minimize
from scipy.integrate import quad
import volaris


RNG = np.random.default_rng(42)
REPS = 5

def bench(fn, reps=REPS, number=1):
    return min(timeit.repeat(fn, repeat=reps, number=number)) / number

S, K, T, r, sigma = 100.0, 100.0, 1.0, 0.05, 0.20
N = 10_000

Ss = RNG.uniform(80, 120, N)
Ks = RNG.uniform(80, 120, N)
market_prices = RNG.uniform(5.0, 15.0, N)
returns_252 = RNG.normal(0.0005, 0.01, 252).astype(np.float64)
returns_1000 = RNG.normal(0.0005, 0.01, 1000).astype(np.float64)
returns_10000 = RNG.normal(0.0005, 0.01, 10_000).astype(np.float64)


# 01. bs_price() x 10_000

def vol_bs():
    for i in range(N):
        volaris.bs_price(Ss[i], Ks[i], T, r, sigma, 1)

def np_bs():
    d1 = (np.log(Ss / Ks) + (r + 0.5 * sigma**2) * T) / (sigma * np.sqrt(T))
    d2 = d1 - sigma * np.sqrt(T)
    return Ss * norm.cdf(d1) - Ks * np.exp(-r * T) * norm.cdf(d2)

t_vol_bs = bench(vol_bs)
t_np_bs = bench(np_bs)


# 02. binomial_price() with 400 steps

def vol_binom():
    volaris.binomial_price(S, K, T, r, 0.0, sigma, 400, 1, 0)

def np_binom():
    Ns = 400
    dt = T / Ns
    u = np.exp(sigma * np.sqrt(dt))
    d = 1.0 / u
    p = (np.exp(r * dt) - d) / (u - d)
    j = np.arange(Ns + 1)
    V = np.maximum(S * u ** (Ns - j) * d ** j - K, 0.0)
    for _ in range(Ns):
        V = np.exp(-r * dt) * (p * V[:-1] + (1 - p) * V[1:])

t_vol_binom = bench(vol_binom)
t_np_binom = bench(np_binom)


# 03. mc_price_european() with 100_000 paths
  
def vol_mc():
    volaris.mc_price_european(S, K, T, r, sigma, 100_000, 1)

def np_mc():
    Z  = RNG.standard_normal(100_000)
    ST = S * np.exp((r - 0.5 * sigma**2) * T + sigma * np.sqrt(T) * Z)
    np.exp(-r * T) * np.mean(np.maximum(ST - K, 0.0))

t_vol_mc = bench(vol_mc)
t_np_mc = bench(np_mc)


# 04. hist_vol_close_to_close() with n=10_000

def vol_hv():
    volaris.hist_vol_close_to_close(returns_10000)

def np_hv():
    np.std(returns_10000, ddof=1) * np.sqrt(252.0)

t_vol_hv = bench(vol_hv)
t_np_hv = bench(np_hv)


# 05. implied_vol() x 10_000
  
def vol_iv():
    for i in range(N):
        volaris.implied_vol(market_prices[i], S, K, T, r, 1)

def _bs_err(sig, mp):
    d1 = (np.log(S / K) + (r + 0.5 * sig**2) * T) / (sig * np.sqrt(T))
    d2 = d1 - sig * np.sqrt(T)
    return S * norm.cdf(d1) - K * np.exp(-r * T) * norm.cdf(d2) - mp

def np_iv():
    for mp in market_prices:
        brentq(_bs_err, 1e-6, 10.0, args=(mp,))

t_vol_iv = bench(vol_iv)
t_np_iv = bench(np_iv)


# 06. gbm_paths() x 10_000 with 252 steps

def vol_gbm():
    volaris.gbm_paths(S, 0.05, sigma, T, 252, 10_000)

def np_gbm():
    dt = T / 252
    Z  = RNG.standard_normal((10_000, 252))
    np.exp(np.log(S) + np.cumsum((0.05 - 0.5 * sigma**2) * dt + sigma * np.sqrt(dt) * Z, axis=1))

t_vol_gbm = bench(vol_gbm)
t_np_gbm = bench(np_gbm)


# 07. mh_sampler_gbm() x 10_000 with 252 days

def vol_mh():
    volaris.mh_sampler_gbm(returns_252, n_iter=10_000, n_burning=2_000)

def np_mh():
    dt = 1.0 / 252
    n = len(returns_252)
    mu, s = 0.0, 0.2
    ll = -n * np.log(s) - np.sum((returns_252 - mu * dt) ** 2) / (2 * s**2 * dt)
    out = np.empty((8_000, 2))
    k = 0
    for i in range(10_000):
        mu2 = mu + RNG.normal(0, 0.005)
        s2  = s  + RNG.normal(0, 0.005)
        if s2 > 0:
            ll2 = -n * np.log(s2) - np.sum((returns_252 - mu2 * dt) ** 2) / (2 * s2**2 * dt)
            if np.log(RNG.uniform()) < ll2 - ll:
                mu, s, ll = mu2, s2, ll2
        if i >= 2_000:
            out[k] = [mu, s]
            k += 1

t_vol_mh = bench(vol_mh)
t_np_mh = bench(np_mh)


# 08. rootfind_newton() x 10_000

_f  = lambda x: x * x - 2.0
_df = lambda x: 2.0 * x

def vol_rf():
    for _ in range(10_000):
        volaris.rootfind_newton(_f, _df, 1.5)

def scipy_rf():
    for _ in range(10_000):
        scipy_newton(_f, 1.5, fprime=_df)

t_vol_rf = bench(vol_rf)
t_scipy_rf = bench(scipy_rf)


# 09. integrate_gauss() x 10_000

_g = lambda x: np.exp(-x * x)

def vol_ig():
    for _ in range(10_000):
        volaris.integrate_gauss(_g, 0.0, 1.0, 10)

def scipy_ig():
    for _ in range(10_000):
        quad(_g, 0.0, 1.0)

t_vol_ig = bench(vol_ig)
t_scipy_ig = bench(scipy_ig)


# 10. garch_fit() with 1_000 returns

returns_list = returns_1000.tolist()

def vol_garch():
    volaris.garch_fit(returns_list)

def np_garch():
    rr = returns_1000
    n  = len(rr)
    v0 = float(np.var(rr))
    def neg_ll(p):
        om, al, be = p
        if om <= 0 or al < 0 or be < 0 or al + be >= 1:
            return 1e10
        h = om / (1 - al - be)
        ll = 0.0
        for t in range(n):
            if h <= 0:
                return 1e10
            ll += np.log(h) + rr[t]**2 / h
            h = om + al * rr[t]**2 + be * h
        return 0.5 * ll

    minimize(neg_ll, [v0 * 0.05, 0.1, 0.85], method='Nelder-Mead', options={'maxiter': 5000, 'xatol': 1e-8, 'fatol': 1e-8})

t_vol_garch = bench(vol_garch, reps=3)
t_np_garch = bench(np_garch, reps=3)


# Results

W = 36
print(f"\n{'Function':<{W}} {'Volaris':>9} {'Reference':>11} {'Speedup':>9}  Reference")
print("─" * (W + 46))

rows = [
    ("bs_price x 10_000",                       t_vol_bs,    t_np_bs,     "NumPy"),
    ("binomial_price with 400 steps",           t_vol_binom, t_np_binom,  "NumPy"),
    ("mc_price_european with 100_000 paths",    t_vol_mc,    t_np_mc,     "NumPy"),
    ("hist_vol_close_to_close with n=10_000",   t_vol_hv,    t_np_hv,     "NumPy"),
    ("implied_vol x 10_000",                    t_vol_iv,    t_np_iv,     "SciPy"),
    ("gbm_paths x 10_000 with 252 steps",       t_vol_gbm,   t_np_gbm,    "NumPy"),
    ("mh_sampler_gbm x 10_000 with 252 days",   t_vol_mh,    t_np_mh,     "NumPy"),
    ("rootfind_newton x 10_000",                t_vol_rf,    t_scipy_rf,  "SciPy"),
    ("integrate_gauss x 10_000",                t_vol_ig,    t_scipy_ig,  "SciPy"),
    ("garch_fit with 1_000 returns",            t_vol_garch, t_np_garch,  "NumPy"),
]

for name, tv, tr, ref in rows:
    speedup = tr / tv
    note = "" if speedup >= 1.0 else "  => ref faster"
    print(f"{name:<{W}} {tv*1000:>7.1f}ms  {tr*1000:>9.1f}ms  {speedup:>7.1f}x  {ref}{note}")

print("─" * (W + 46))