# pianounroll

Imagine if...

```py
from pianounroll import *

import sys
import os
import io

... your code
```

well actually it's real. 

I remember when I got a rush of excitement when I read that **python** was added to FL. Until it wasn't really...

Well, now pianounroll is a way to make that a reality by escaping 
poor-taste sandboxing in python environment within fl pianoroll. 

pianounroll consists of two main components:
- python library patch within fl
- an include that remaps some of the stripped builtins back

Currently **Windows / MacOS Intel/ARM are supported**.

For MacOS there is an autopatcher utility & for windows there is currently only just a binary replacement.

**Tested on FL v21.2.1 [build 3859]**

## Some gotchas

Not all pip packages will work out of the box or at all, 
make sure you verify first.

**Why?**: On UNIX/POSIX systems some of the builtins are remapped
quite heavily so for example I wasn't easily able to get
subprocess include working. On Windows it works :D

### Workarounds for some things that still don't work

* (on osx) requests -> httpx
* ...

#### Opening files in current directory (missing path builtins)

1. 	In pianoroll scripts folder create a blank py file 'getpwd.py'
2. 
	```py
	import getpwd
	currentpwd = os.path.dirname(os.path.sys.modules["getpwd"].__spec__.origin)
	```

#### (OSX/POSIX only) Executing a program

On windows it's not a problem as subprocess import works
```py
pid = os.posix_spawn(program_path, [program_path, ...args], os.environ)

_, exit_status = os.waitpid(pid, 0)

return exit_status
```

## Prerequisites

### Local python install

> At the time of writing the builtin python library
is at version: **3.9.1**

This is mainly needed as we need a way to get stripped out imports that are usually bundled with python and also to install pip packages

### MacOS

```sh
brew install pyenv
brew install virtualenv

# make sure in your rc file and shell was restarted:
# eval "$(pyenv virtualenv-init -)"
# export PATH="$HOME/.pyenv/bin:$PATH"
# eval "$(pyenv init -)"

pyenv install 3.9.1
pyenv local 3.9.1
pyenv virtualenv pianounroll

pip install httpx
```

### Windows (powershell)

* Just in case make sure you've got any python version installed at first

```ps1
Set-ExecutionPolicy RemoteSigned
# Install pyenv
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "./install-pyenv-win.ps1"; &"./install-pyenv-win.ps1"

# Restart powershell session

pyenv install 3.9.1
```

## Installation

### MacOS (shell)

```
1. # clone repo & cd
2. pyenv local pianounroll/3.9.1
2. ./install-all.sh
```

> What it installs:
> - /Applications/FL Studio 21.app/Contents/Resources/FL/Shared/Python/libPyBridge_x64.dylib (+PyBridge_x64.dylib.old)
> - /Applications/FL Studio 21.app/Contents/Resources/FL/Shared/Python/Lib/syspath.py
> - /Applications/FL Studio 21.app/Contents/Resources/FL/Shared/Python/Lib/pianounroll.py

### Windows auto-install

```
1. clone repo
2. in file explorer open install.bat
```

> What it installs:
> - C:\Users\\{username}\Documents\Image-Line\FL Studio\Settings\Piano roll scripts\syspath.py
> - C:\Users\\{username}\Documents\Image-Line\FL Studio\Settings\Piano roll scripts\pianounroll.py
> - C:\Program Files\Image-Line\FL Studio 21\Shared\Python\PyBridge_x64.dll (+PyBridge_x64.dll.old)