import os
import sys

if sys.platform == 'win32' and hasattr(os, 'add_dll_directory'):
    conda_prefix = os.environ.get('CONDA_PREFIX', '')
    if conda_prefix:
        os.add_dll_directory(os.path.join(conda_prefix, 'Library', 'bin'))