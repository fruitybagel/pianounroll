import syspath
import sys
import builtins

def _print(*x):
    Utils.ShowMessage(str(x))

io = sys.modules["_io"]
open = io.open
importlib_external = sys.modules["_frozen_importlib_external"]
importlib = sys.modules["_frozen_importlib"]
# importlib.util = sys.modules["_frozen_importlib_external"]
imp = sys.modules["_imp"]

os = importlib_external._os

original_import = builtins.__import__

def custom_import(name, globals=None, locals=None, fromlist=(), level=0):
    iimp = None
    try:
        iimp = importlib.__import__(name, globals, locals, fromlist, level)
    except Exception as e:
        pass
    return iimp

builtins.__import__ = custom_import
builtins.open = io.open
