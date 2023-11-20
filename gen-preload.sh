#!/bin/bash

preloadfname=pianounroll
pycmd=

if command -v python3 &>/dev/null; then
    # echo "Python 3 is available"
    pycmd=python3
elif command -v python &>/dev/null; then
    # echo "Python is available (version 2)"
    pycmd=python
else
    echo "Neither Python 3 nor Python is available"
    exit 1
fi

_out=$(cat <<EOF
import sys
old = [x for x in sys.path]
sys.path = $(python3 -c "import sys; print(sys.path[1:])")
sys.path += old

EOF
)

echo -n "$_out" > "/Applications/FL Studio 21.app/Contents/Resources/FL/Shared/Python/Lib/syspath.py"||:
cp ./preload.py "/Applications/FL Studio 21.app/Contents/Resources/FL/Shared/Python/Lib/$preloadfname.py"||:

# sudo chown "root" "/Applications/FL Studio 21.app/Contents/Resources/FL/Shared/Python/Lib/syspath.py"
# sudo chown "root" "/Applications/FL Studio 21.app/Contents/Resources/FL/Shared/Python/Lib/$preloadfname.py"
