# If a working directory is passed, change to that directory
param (
    [string]$WorkingDirectory
)

# Check and self-elevate the script if required
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $scriptPath = $MyInvocation.MyCommand.Definition
    $currentPath = Get-Location
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`" -WorkingDirectory `"$currentPath`"" -Verb RunAs
    exit
}

if ($WorkingDirectory) {
    Set-Location $WorkingDirectory
}

$targetVersion = "3.9.1" # Set your target Python version here
$pycmd = "python"

$documentsPath = [Environment]::GetFolderPath('MyDocuments')

$preloadfname = "pianounroll"
$pycmd = "python"
$user = [Environment]::UserName
$destinationFolder = Join-Path -Path $documentsPath -ChildPath "Image-Line\FL Studio\Settings\Piano roll scripts"

$sysPathFileName = "$destinationFolder\syspath.py"
$pianoRollFileName = "$destinationFolder\pianounroll.py"
$preloadFileName = ".\preload.py" # Current working directory
$pyBridgeSource = ".\bin\PyBridge_x64.dll"
$pyBridgeDestination = "C:\Program Files\Image-Line\FL Studio 21\Shared\Python\PyBridge_x64.dll"
$pyBridgeBackup = "C:\Program Files\Image-Line\FL Studio 21\Shared\Python\PyBridge_x64.dll.old"

# Check if Python is available
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "Python is not available"
    exit
}

$currentVersion = & $pycmd --version
if ($currentVersion -notlike "*$targetVersion*") {
    Write-Host "Python version mismatch. Attempting to set local Python version using pyenv..."
    $pyenvResult = & pyenv local $targetVersion
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to set Python version with pyenv. Current Python version: $currentVersion"
        Write-Host "Python version mismatch. Proceed? (y/n)"
        $key = [Console]::ReadKey($true)
        if ($key.Key -ne "Y") {
            exit
        }
    }
}

# Execute Python command and get the output
$pythonOutput = & $pycmd -c "import sys; print(sys.path[1:])"


# Python script content
$pyContent = @"
import sys
old = [x for x in sys.path]
sys.path = $pythonOutput
sys.path += old
"@

# Write the Python script to syspath.py
$pyContent -replace "`r`n", "`n" | Out-File -FilePath $sysPathFileName -Encoding utf8 -Force

# Copy preload.py to pianounroll.py in the destination folder
if (Test-Path $preloadFileName) {
    Copy-Item -Path $preloadFileName -Destination $pianoRollFileName
} else {
    Write-Host "File preload.py not found in the current directory"
}

# Backup PyBridge_x64.dll only if the backup doesn't already exist
if (Test-Path $pyBridgeDestination) {
    if (-not (Test-Path $pyBridgeBackup)) {
        Move-Item -Path $pyBridgeDestination -Destination $pyBridgeBackup -ErrorAction Stop
        Write-Host "Backup created: PyBridge_x64.dll.old"
    } else {
        # Write-Host "Backup already exists: PyBridge_x64.dll.old"
    }
} else {
    Write-Host "Original file not found: PyBridge_x64.dll"
}

# Copy PyBridge_x64.dll
if (Test-Path $pyBridgeSource) {
    Copy-Item -Path $pyBridgeSource -Destination $pyBridgeDestination -Force
} else {
    Write-Host "PyBridge_x64.dll not found in the current path's ./bin folder"
}

Write-Host "Done."
Write-Host "Press any key to exit..."
[Console]::ReadKey()