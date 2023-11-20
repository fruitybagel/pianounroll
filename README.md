# pianounroll

pianounroll is a way to escape sandboxing in python
environment within fl pianoroll

It consists of two main components:
- python library patch within fl
- an include that remaps some of the stripped builtins back

**Tested on on FL v21.2 [build 3505]**

**Windows / MacOS Intel/ARM supported**

## Notice (READ)

Not all pip packages will work out of the box or at all, 
make sure you verify first.

**Why?**: On UNIX/POSIX systems some of the builtins are remapped
quite heavily so for example I wasn't easily able to get
subprocess include working. On Windows it works :D

### Workarounds for some thigns that still don't work

* requests -> httpx
* ...

#### Opeing files in current directory (missing path builtins)

1. 	In pianoroll scripts folder create a blank py file
2. 
	```py
	import pianorollpath
	currentpwd = os.path.dirname(os.path.sys.modules["pianorollpath"].__spec__.origin)
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

This is mainly needed as we need a way 
to install pip packages

### Macos

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

* Just in case you have any python version installed at first

```ps1
# Install pyenv
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "./install-pyenv-win.ps1"; &"./install-pyenv-win.ps1"

# Restart powershell session

pyenv install 3.9.1
```

## Installation

### Macos (package)

Install from releases.

### Macos (shell)

```
1. # clone repo & cd
2. ./install-all.sh
```

### Windows (powershell)

```
1. # clone repo & cd
2. .\install.ps1
```