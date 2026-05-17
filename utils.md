## Wzory

* [Black-Scholes formula](https://pl.wikipedia.org/wiki/Wz%C3%B3r_Blacka-Scholesa)

## Komendy

* Przebudowa i kompilacja dla Pythona
```
cd "C:\Users\basia\OneDrive\Pulpit\volaris\python"
# pip install cython numpy setuptools
# conda install -c conda-forge c-compiler
pip install -e . --no-build-isolation
pytest tests/
```