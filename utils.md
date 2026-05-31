https://medium.com/@aaron_delarosa/implementing-heston-model-in-c-b7b7ed19943c

## Komendy

* Przebudowa, rekompilacja i testy dla Pythona
```
cd "C:\Users\basia\OneDrive\Pulpit\volaris\python"
pip install -e . --no-build-isolation
pytest tests/
```

* Przebudowa, rekompilacja i testy dla R
```
cd "C:\Users\basia\OneDrive\Pulpit\volaris"
& "C:\Program Files\R\R-4.5.0\bin\Rscript.exe" -e "setwd('R/Volaris'); devtools::document()"
& "C:\Program Files\R\R-4.5.0\bin\Rscript.exe" -e "setwd('R/Volaris'); devtools::test()"
```

* Szybkie testowanie jakiejś funkcji w Pythonie
```
cd "C:\Users\basia\OneDrive\Pulpit\volaris\python"
pip install -e . --no-build-isolation
python -c "from volaris._core import binomial_price; print(binomial_price(100, 100, 1, 0.05, 0.0, 0.2, 200, 1, 0))"
```

## Co edytować, by dołożyć nową funkcję do pakietu?

### Funkcja w C (wzorzec: Black-Scholes, Binomial Tree)

1. stwórz `src/pricing/binomial_tree.h`
2. stwórz `src/pricing/binomial_tree.c`
3. `python/setup.py`: dodaj `../src/pricing/binomial_tree.c` do `sources` w `ext_core`
4. `python/volaris/_core.pyx`: dodaj `cdef extern from` deklarację i funkcję Python
5. `R/Volaris/src/volaris_r.c`: dodaj `#include` dla `.c` i wrapper `SEXP r_binomial_price(...)`
6. `R/Volaris/R/pricing.R`: dodaj wrapper R z Roxygen2 wywołujący `.Call("r_binomial_price", ..., PACKAGE = "Volaris")`

### Funkcja w C++ (wzorzec: GARCH, Heston)

1. stwórz `src/<moduł>/<nazwa>.hpp` - deklaracja w `namespace volaris`
2. stwórz `src/<moduł>/<nazwa>.cpp` - implementacja w `namespace volaris`
3. `R/Volaris/src/garch_heston_rcpp.cpp`: dodaj `#include` dla nowego `.cpp` i wrapper z `// [[Rcpp::export]]`
4. `R/Volaris/R/<plik>.R`: dodaj wrapper R z Roxygen2 wywołujący wygenerowaną funkcję Rcpp (bez `.Call()`)
5. `python/volaris/_heston_garch.pyx`: dodaj `cdef extern from "<nazwa>.hpp" namespace "volaris"` i funkcję Python
6. `python/setup.py`: dodaj `../src/<moduł>/<nazwa>.cpp` do `sources` w `ext_heston_garch`

## Na koniec (aka sprzątanie pieprznika)

* Sprawdź, czy na wejściu sprawdzasz wszystkie warunki konieczne, które muszą spełniać dane (np. N reprezentujące liczbę kroków musi być >= 0).
* Sprawdź jeszcze raz, czy każdy wzór serio jest dobrze zaimplementowany.
* Pozamieniać int i=0 na size_t i=0 tam gdzie mi się powaliło.
* Ujednolicić formatowanie.