#!/usr/bin/env powershell
# PyHula Environment Setup Script
# Sets up Python 3.6 environment with PyHula library for drone control

param(
    [switch]$SkipPythonInstall = $false,
    [switch]$Force = $false,
    [string]$InstallPath = "",
    [switch]$Verbose = $false
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# Script configuration
$RequiredPythonVersion = "3.6"
$PyHulaWheelFile = "pyhula-1.1.7-cp36-cp36m-win_amd64.whl"
$PythonInstallerFile = "python-3.6.7-amd64.exe"
$VenvName = "pyhula-env"

# Paths
$ScriptRoot = $PSScriptRoot
$HulaPythonDir = Join-Path $ScriptRoot "Hula python"
$PythonInstallerDir = Join-Path $ScriptRoot "python-368_installer"
$WorkingDir = if ($InstallPath) { $InstallPath } else { Join-Path $env:USERPROFILE "PyHula" }

function Write-Status {
    param([string]$Message, [string]$Color = "Green")
    Write-Host "[PyHula Setup] $Message" -ForegroundColor $Color
}

function Write-Error-Safe {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Write-Warning-Safe {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Test-AdminRights {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Find-PythonInstallation {
    $pythonPaths = @(
        "${env:ProgramFiles}\Python36\python.exe",
        "${env:ProgramFiles(x86)}\Python36\python.exe",
        "${env:LOCALAPPDATA}\Programs\Python\Python36\python.exe",
        "${env:USERPROFILE}\AppData\Local\Programs\Python\Python36\python.exe"
    )
    
    foreach ($path in $pythonPaths) {
        if (Test-Path $path) {
            try {
                $version = & $path --version 2>&1
                if ($version -match "Python 3\.6") {
                    Write-Status "Found Python 3.6 at: $path"
                    return $path
                }
            } catch {
                continue
            }
        }
    }
    
    # Check PATH
    try {
        $version = python --version 2>&1
        if ($version -match "Python 3\.6") {
            $pythonPath = (Get-Command python -ErrorAction SilentlyContinue).Source
            Write-Status "Found Python 3.6 in PATH: $pythonPath"
            return "python"
        }
    } catch {
        # Python not in PATH
    }
    
    return $null
}

function Install-Python36 {
    Write-Status "Installing Python 3.6..."
    
    # Find installer
    $installerPath = $null
    $possibleInstallers = @(
        (Join-Path $HulaPythonDir $PythonInstallerFile),
        (Join-Path $PythonInstallerDir "python-3.6.8-amd64.exe"),
        (Join-Path $PythonInstallerDir "python-3.6.8.exe")
    )
    
    foreach ($installer in $possibleInstallers) {
        if (Test-Path $installer) {
            $installerPath = $installer
            break
        }
    }
    
    if (-not $installerPath) {
        throw "Python 3.6 installer not found. Please ensure the installer is in the 'Hula python' or 'python-368_installer' directory."
    }
    
    Write-Status "Using installer: $installerPath"
    
    # Install Python silently
    $installArgs = @(
        "/quiet",
        "InstallAllUsers=0",
        "PrependPath=1",
        "Include_test=0",
        "Include_doc=0",
        "Include_dev=0",
        "Include_debug=0",
        "Include_launcher=1",
        "InstallLauncherAllUsers=0"
    )
    
    try {
        $process = Start-Process -FilePath $installerPath -ArgumentList $installArgs -Wait -PassThru -NoNewWindow
        if ($process.ExitCode -eq 0) {
            Write-Status "Python 3.6 installed successfully"
            Start-Sleep -Seconds 5  # Wait for installation to complete
        } else {
            throw "Python installation failed with exit code: $($process.ExitCode)"
        }
    } catch {
        throw "Failed to install Python 3.6: $($_.Exception.Message)"
    }
}

function Create-VirtualEnvironment {
    param([string]$PythonPath)
    
    $venvPath = Join-Path $WorkingDir $VenvName
    
    if (Test-Path $venvPath) {
        if ($Force) {
            Write-Status "Removing existing virtual environment..."
            Remove-Item $venvPath -Recurse -Force
        } else {
            Write-Status "Virtual environment already exists at: $venvPath"
            return $venvPath
        }
    }
    
    Write-Status "Creating virtual environment at: $venvPath"
    
    if (-not (Test-Path $WorkingDir)) {
        New-Item -ItemType Directory -Path $WorkingDir -Force | Out-Null
    }
    
    try {
        & $PythonPath -m venv $venvPath
        if ($LASTEXITCODE -ne 0) {
            throw "Virtual environment creation failed"
        }
        Write-Status "Virtual environment created successfully"
        return $venvPath
    } catch {
        throw "Failed to create virtual environment: $($_.Exception.Message)"
    }
}

function Install-PyHula {
    param([string]$VenvPath)
    
    $wheelPath = Join-Path $HulaPythonDir $PyHulaWheelFile
    
    if (-not (Test-Path $wheelPath)) {
        throw "PyHula wheel file not found at: $wheelPath"
    }
    
    $pipPath = Join-Path $VenvPath "Scripts\pip.exe"
    $pythonPath = Join-Path $VenvPath "Scripts\python.exe"
    
    if (-not (Test-Path $pipPath)) {
        throw "pip.exe not found in virtual environment: $pipPath"
    }
    
    Write-Status "Installing PyHula and dependencies..."
    
    # Upgrade pip first
    try {
        & $pipPath install --upgrade pip
        Write-Status "pip upgraded successfully"
    } catch {
        Write-Warning-Safe "Could not upgrade pip: $($_.Exception.Message)"
    }
    
    # Install common dependencies
    $dependencies = @("numpy", "matplotlib", "opencv-python")
    foreach ($package in $dependencies) {
        try {
            Write-Status "Installing $package..."
            & $pipPath install $package
            if ($LASTEXITCODE -eq 0) {
                Write-Status "$package installed successfully"
            } else {
                Write-Warning-Safe "Could not install $package"
            }
        } catch {
            Write-Warning-Safe "Could not install $package - $($_.Exception.Message)"
        }
    }
    
    # Install PyHula wheel
    try {
        Write-Status "Installing PyHula from wheel file..."
        & $pipPath install $wheelPath
        if ($LASTEXITCODE -eq 0) {
            Write-Status "PyHula installed successfully"
        } else {
            throw "PyHula installation failed"
        }
    } catch {
        throw "Failed to install PyHula: $($_.Exception.Message)"
    }
    
    # Verify installation
    try {
        & $pythonPath -c "import pyhula; print('PyHula version:', pyhula.__version__ if hasattr(pyhula, '__version__') else 'unknown')"
        Write-Status "PyHula installation verified"
    } catch {
        Write-Warning-Safe "Could not verify PyHula installation"
    }
}

function Create-ActivationScripts {
    param([string]$VenvPath)
    
    $activateScript = Join-Path $WorkingDir "activate_pyhula.bat"
    $activatePsScript = Join-Path $WorkingDir "activate_pyhula.ps1"
    $startPythonScript = Join-Path $WorkingDir "start_python.bat"
    $testScript = Join-Path $WorkingDir "test_pyhula.py"
    
    # Create batch activation script
    $batchContent = @"
@echo off
echo Activating PyHula environment...
call "$($VenvPath)\Scripts\activate.bat"
echo PyHula environment activated!
echo To test PyHula, run: python test_pyhula.py
cmd /k
"@
    
    $batchContent | Out-File -FilePath $activateScript -Encoding ASCII
    
    # Create PowerShell activation script
    $psContent = @"
# PyHula Environment Activation Script
Write-Host "Activating PyHula environment..." -ForegroundColor Green
& "$($VenvPath)\Scripts\Activate.ps1"
Write-Host "PyHula environment activated!" -ForegroundColor Green
Write-Host "To test PyHula, run: python test_pyhula.py" -ForegroundColor Yellow
"@
    
    $psContent | Out-File -FilePath $activatePsScript -Encoding UTF8
    
    # Create start Python script
    $startPythonContent = @"
@echo off
echo Starting Python with PyHula environment...
call "$($VenvPath)\Scripts\activate.bat"
python
"@
    
    $startPythonContent | Out-File -FilePath $startPythonScript -Encoding ASCII
    
    # Create test script
    $testPythonContent = @"
#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
PyHula Installation Test Script
Tests basic PyHula functionality
"""

def test_pyhula_import():
    """Test if PyHula can be imported"""
    try:
        import pyhula
        print("✓ PyHula imported successfully")
        
        # Try to get version if available
        if hasattr(pyhula, '__version__'):
            print(f"  Version: {pyhula.__version__}")
        else:
            print("  Version: unknown")
        return True
    except ImportError as e:
        print(f"✗ Failed to import PyHula: {e}")
        return False

def test_dependencies():
    """Test if common dependencies are available"""
    dependencies = ['numpy', 'cv2', 'matplotlib']
    success = True
    
    for dep in dependencies:
        try:
            if dep == 'cv2':
                import cv2
                print(f"✓ OpenCV imported successfully (version: {cv2.__version__})")
            else:
                module = __import__(dep)
                version = getattr(module, '__version__', 'unknown')
                print(f"✓ {dep} imported successfully (version: {version})")
        except ImportError:
            print(f"✗ {dep} not available")
            success = False
    
    return success

def main():
    print("PyHula Installation Test")
    print("=" * 30)
    
    pyhula_ok = test_pyhula_import()
    print()
    
    deps_ok = test_dependencies()
    print()
    
    if pyhula_ok and deps_ok:
        print("🎉 All tests passed! PyHula is ready to use.")
    else:
        print("⚠️  Some tests failed. Please check the installation.")
    
    print("\nPress Enter to exit...")
    input()

if __name__ == "__main__":
    main()
"@
    
    $testPythonContent | Out-File -FilePath $testScript -Encoding UTF8
    
    # Copy additional files if they exist
    $docFiles = @(
        "Hula Python interface specifier V3_20250724.docx",
        "Hula Python接口说明 V3_20250724.pdf", 
        "Pyhula Software Quick Reference Guide.docx"
    )
    
    foreach ($file in $docFiles) {
        $sourcePath = Join-Path $HulaPythonDir $file
        $destPath = Join-Path $WorkingDir $file
        
        if (Test-Path $sourcePath) {
            try {
                Copy-Item $sourcePath $destPath -Force
                Write-Status "Copied documentation: $file"
            } catch {
                Write-Warning-Safe "Could not copy $file - $($_.Exception.Message)"
            }
        }
    }
    
    Write-Status "Activation scripts created in: $WorkingDir"
}

function Show-CompletionMessage {
    param([string]$WorkingDir)
    
    Write-Host ""
    Write-Host "=" * 60 -ForegroundColor Green
    Write-Host "PyHula Environment Setup Complete!" -ForegroundColor Green
    Write-Host "=" * 60 -ForegroundColor Green
    Write-Host ""
    Write-Host "Installation directory: $WorkingDir" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "To use PyHula:" -ForegroundColor Yellow
    Write-Host "1. Double-click: " -NoNewline; Write-Host "activate_pyhula.bat" -ForegroundColor White
    Write-Host "2. Or run in PowerShell: " -NoNewline; Write-Host "start_python.bat" -ForegroundColor White
    Write-Host ""
    Write-Host "To test the installation:" -ForegroundColor Yellow
    Write-Host "1. Activate the environment (option 1 above)" -ForegroundColor White
    Write-Host "2. Run: " -NoNewline; Write-Host "python test_pyhula.py" -ForegroundColor White
    Write-Host ""
    Write-Host "Documentation files have been copied to the installation directory." -ForegroundColor Cyan
    Write-Host ""
}

# Main execution
try {
    Write-Status "Starting PyHula environment setup..."
    Write-Status "Working directory: $WorkingDir"
    
    # Check admin rights
    if (-not (Test-AdminRights)) {
        Write-Warning-Safe "Running without administrator privileges. Python installation may require elevation."
    }
    
    # Find or install Python 3.6
    $pythonPath = Find-PythonInstallation
    
    if (-not $pythonPath -and -not $SkipPythonInstall) {
        Install-Python36
        Start-Sleep -Seconds 3
        $pythonPath = Find-PythonInstallation
        
        if (-not $pythonPath) {
            throw "Python 3.6 installation verification failed. Please install Python 3.6 manually."
        }
    } elseif (-not $pythonPath) {
        throw "Python 3.6 not found and installation skipped. Please install Python 3.6 first."
    }
    
    # Create virtual environment
    $venvPath = Create-VirtualEnvironment -PythonPath $pythonPath
    
    # Install PyHula
    Install-PyHula -VenvPath $venvPath
    
    # Create activation scripts
    Create-ActivationScripts -VenvPath $venvPath
    
    # Show completion message
    Show-CompletionMessage -WorkingDir $WorkingDir
    
} catch {
    Write-Error-Safe "Setup failed: $($_.Exception.Message)"
    Write-Host ""
    Write-Host "Troubleshooting tips:" -ForegroundColor Yellow
    Write-Host "- Ensure you have internet connection for package downloads" -ForegroundColor White
    Write-Host "- Try running as Administrator" -ForegroundColor White
    Write-Host "- Temporarily disable antivirus software" -ForegroundColor White
    Write-Host "- Check that all required files are present in the script directory" -ForegroundColor White
    Write-Host ""
    exit 1
} finally {
    if ($Verbose) {
        Write-Host "Script completed." -ForegroundColor Gray
    }
}
