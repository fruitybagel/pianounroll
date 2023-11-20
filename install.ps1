$preloadfname = "pianounroll"
$pycmd = "python"
$user = [Environment]::UserName
$destinationFolder = "C:\Users\$user\Documents\Image-Line\FL Studio\Settings\Piano roll scripts"
$sysPathFileName = "$destinationFolder\syspath.py"
$pianoRollFileName = "$destinationFolder\pianounroll.py"
$preloadFileName = "$destinationFolder\preload.py"
$pyBridgeSource = ".\bin\PyBridge_x64.dll"
$pyBridgeDestination = "C:\Program Files\Image-Line\FL Studio 21\Shared\Python\PyBridge_x64.dll"

# Check if Python is available
if (Get-Command python -ErrorAction SilentlyContinue) {
    $pycmd = "python"
} else {
    Write-Host "Python is not available"
    exit
}

# Python script content
$pyContent = @"
import sys
old = [x for x in sys.path]
sys.path = $($pycmd -c "import sys; print(sys.path[1:])")
sys.path += old
"@

# Write the Python script to syspath.py
$pyContent | Out-File -FilePath $sysPathFileName

# Copy preload.py to pianounroll.py
if (Test-Path $preloadFileName) {
    Copy-Item -Path $preloadFileName -Destination $pianoRollFileName
} else {
    Write-Host "File preload.py not found in $destinationFolder"
}

# Copy PyBridge_x64.dll
if (Test-Path $pyBridgeSource) {
    Copy-Item -Path $pyBridgeSource -Destination $pyBridgeDestination -Force
} else {
    Write-Host "PyBridge_x64.dll not found in the current path's ./bin folder"
}
