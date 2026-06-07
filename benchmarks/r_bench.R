library(Volaris)
library(microbenchmark)

set.seed(123)

S <- 100; K <- 100; TT <- 1; r <- 0.05; sigma <- 0.20
N <- 10000L

Ss <- runif(N, 80, 120)
Ks <- runif(N, 80, 120)
market_prices <- runif(N, 5, 15)
returns_252 <- rnorm(252,   0.0005, 0.01)
returns_1000 <- rnorm(1000,  0.0005, 0.01)
returns_10000 <- rnorm(10000, 0.0005, 0.01)


# 01. bs_price() x 10_000

r_bs <- function() {
    d1 <- (log(Ss / Ks) + (r + 0.5 * sigma^2) * TT) / (sigma * sqrt(TT))
    d2 <- d1 - sigma * sqrt(TT)
    Ss * pnorm(d1) - Ks * exp(-r * TT) * pnorm(d2)
}

mb_bs <- microbenchmark(
    Volaris = for (i in seq_len(N)) bs_price(Ss[i], Ks[i], TT, r, sigma, 1L),
    R_vec = r_bs(),
    times = 5L,
    unit = "ns"
)


# 02. binomial_price() with 400 steps

r_binom <- function() {
    Ns <- 400L; dt <- TT / Ns
    u <- exp(sigma * sqrt(dt)); d <- 1 / u
    p <- (exp(r * dt) - d) / (u - d)
    j <- 0:Ns
    V <- pmax(S * u^(Ns - j) * d^j - K, 0)
    for (i in seq_len(Ns))
        V <- exp(-r * dt) * (p * V[-length(V)] + (1 - p) * V[-1])
    V[1]
}

mb_binom <- microbenchmark(
    Volaris = binomial_price(S, K, TT, r, 0.0, sigma, 400L, 1L, 0L),
    R_vec = r_binom(),
    times = 20L,
    unit = "ns"
)


# 03. mc_price_european() with 100_000 paths

r_mc <- function() {
    Z <- rnorm(100000)
    ST <- S * exp((r - 0.5 * sigma^2) * TT + sigma * sqrt(TT) * Z)
    exp(-r * TT) * mean(pmax(ST - K, 0))
}

mb_mc <- microbenchmark(
    Volaris = mc_price_european(S, K, TT, r, sigma, 100000L, 1L),
    R_vec = r_mc(),
    times = 20L,
    unit = "ns"
)


# 04. vol_close_to_close() with n=10_000

mb_hv <- microbenchmark(
    Volaris = vol_close_to_close(returns_10000, length(returns_10000)),
    R_base = sd(returns_10000) * sqrt(252),
    times = 50L,
    unit = "ns"
)


# 05. implied_vol() x 10_000

bs_err <- function(sig, mp) {
    d1 <- (log(S / K) + (r + 0.5 * sig^2) * TT) / (sig * sqrt(TT))
    d2 <- d1 - sig * sqrt(TT)
    S * pnorm(d1) - K * exp(-r * TT) * pnorm(d2) - mp
}

mb_iv <- microbenchmark(
    Volaris = for (i in seq_len(N)) implied_vol(market_prices[i], S, K, TT, r, 1L),
    R_uniroot = for (mp in market_prices) uniroot(bs_err, c(1e-6, 10), mp = mp)$root,
    times = 5L,
    unit = "ns"
)


# 06. gbm_paths() x 10_000 with 252 steps

r_gbm <- function() {
    dt <- TT / 252
    Z <- matrix(rnorm(N * 252), nrow = 252, ncol = N)
    inc <- (r - 0.5 * sigma^2) * dt + sigma * sqrt(dt) * Z
    S * exp(apply(inc, 2, cumsum))
}

mb_gbm <- microbenchmark(
    Volaris = gbm_paths(S, 0.05, sigma, TT, 252L, N),
    R_vec = r_gbm(),
    times = 5L,
    unit = "ns"
)


# 07. mh_sampler_gbm() x 10_000 with 252 days

r_mh <- function() {
    dt <- 1 / 252; n <- length(returns_252)
    mu <- 0.0; sg <- 0.2
    ll <- -n * log(sg) - sum((returns_252 - mu * dt)^2) / (2 * sg^2 * dt)
    out <- matrix(0, 8000, 2); k <- 1L
    for (i in seq_len(10000)) {
        mu2 <- mu + rnorm(1, 0, 0.005)
        sg2 <- sg + rnorm(1, 0, 0.005)
        if (sg2 > 0) {
            ll2 <- -n * log(sg2) - sum((returns_252 - mu2 * dt)^2) / (2 * sg2^2 * dt)
            if (log(runif(1)) < ll2 - ll) { mu <- mu2; sg <- sg2; ll <- ll2 }
        }
        if (i > 2000) { out[k, ] <- c(mu, sg); k <- k + 1L }
    }
    out
}

mb_mh <- microbenchmark(
    Volaris = mh_sampler_gbm(returns_252, 10000L, 2000L),
    R_loop = r_mh(),
    times = 5L,
    unit = "ns"
)


# 08. rootfind_newton() x 10_000

f_root  <- function(x) x^2 - 2
df_root <- function(x) 2 * x

mb_rf <- microbenchmark(
    Volaris = for (i in seq_len(10000L)) rootfind_newton(f_root, df_root, 1.5),
    R_uniroot = for (i in seq_len(10000L)) uniroot(f_root, c(1, 2))$root,
    times = 5L,
    unit = "ns"
)


# 09. integrate_gauss() x 10_000

g_int <- function(x) exp(-x^2)

mb_ig <- microbenchmark(
    Volaris = for (i in seq_len(10000L)) integrate_gauss(g_int, 0, 1, 10L),
    R_integrate = for (i in seq_len(10000L)) integrate(g_int, 0, 1)$value,
    times = 5L,
    unit = "ns"
)


# 10. garch_fit() with 1_000 returns

r_garch <- function() {

    rr <- returns_1000
    n  <- length(rr)
    v0 <- var(rr)

    neg_ll <- function(p) {
        om <- p[1]; al <- p[2]; be <- p[3]
        if (om <= 0 || al < 0 || be < 0 || al + be >= 1) return(1e10)
        h  <- om / (1 - al - be)
        ll <- 0
        for (t in seq_len(n)) {
            if (h <= 0) return(1e10)
            ll <- ll + log(h) + rr[t]^2 / h
            h  <- om + al * rr[t]^2 + be * h
        }
        0.5 * ll
    }

    optim(c(v0 * 0.05, 0.1, 0.85), neg_ll, method = "Nelder-Mead", control = list(maxit = 5000, abstol = 1e-8))
}

mb_garch <- microbenchmark(
    Volaris = garch_fit(returns_1000),
    R_loop = r_garch(),
    times = 10L,
    unit = "ns"
)


# Results

ms <- function(mb, name) summary(mb)[summary(mb)$expr == name, "median"] / 1e6

W <- 36
cat(sprintf("\n%-*s %9s %11s %9s  Reference\n", W, "Function", "Volaris(ms)", "Ref(ms)", "Speedup"))
cat(strrep("\u2500", W + 46), "\n")

rows <- list(
    list("bs_price x 10_000",                      mb_bs,    "Volaris", "R_vec",       "R (vectorized)"),
    list("binomial_price with 400 steps",          mb_binom, "Volaris", "R_vec",       "R (vectorized)"),
    list("mc_price_european with 100_000 paths",   mb_mc,    "Volaris", "R_vec",       "R (vectorized)"),
    list("vol_close_to_close with n=10_000",       mb_hv,    "Volaris", "R_base",      "R base"),
    list("implied_vol x 10_000",                   mb_iv,    "Volaris", "R_uniroot",   "uniroot"),
    list("gbm_paths x 10_000 with 252 steps",      mb_gbm,   "Volaris", "R_vec",       "R (vectorized)"),
    list("mh_sampler_gbm x 10_000 with 252 days",  mb_mh,    "Volaris", "R_loop",      "R loop"),
    list("rootfind_newton x 10_000",               mb_rf,    "Volaris", "R_uniroot",   "uniroot"),
    list("integrate_gauss x 10_000",               mb_ig,    "Volaris", "R_integrate", "integrate()"),
    list("garch_fit with 1_000 returns",           mb_garch, "Volaris", "R_loop",      "R loop")
)

for (row in rows) {
    label <- row[[1]]; mb <- row[[2]]
    vname <- row[[3]]; rname <- row[[4]]; ref <- row[[5]]
    tv <- ms(mb, vname); tr <- ms(mb, rname)
    speedup <- tr / tv
    note <- if (speedup >= 1.0) "" else "  => ref faster"
    cat(sprintf("%-*s %7.2fms  %9.2fms  %7.1fx  %s%s\n", W, label, tv, tr, speedup, ref, note))
}

cat(strrep("\u2500", W + 46), "\n")