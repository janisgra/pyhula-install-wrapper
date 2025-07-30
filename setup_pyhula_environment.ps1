# PyHula Environment Setup Script for Students
# Compatible with Windows 11 and international system configurations
# Requires PowerShell 5.1 or higher

#Requires -Version 5.1

param(
    [string]$InstallPath = "$env:USERPROFILE\PyHulaEnvironment",
    [switch]$Force = $false,
    [switch]$Verbose = $false
)

# Set error handling and encoding
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

# Script configuration
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Python36Installer = Join-Path $ScriptDir "python-3.6.7-amd64.exe"
$PyHulaWheel = Join-Path $ScriptDir "pyhula-1.1.7-cp36-cp36m-win_amd64.whl"
$VenvName = "pyhula_env"
$VenvPath = Join-Path $InstallPath $VenvName

# Color functions for better output
function Write-Success($message) {
    Write-Host "✓ $message" -ForegroundColor Green
}

function Write-Info($message) {
    Write-Host "ℹ $message" -ForegroundColor Cyan
}

function Write-Warning($message) {
    Write-Host "⚠ $message" -ForegroundColor Yellow
}

function Write-Error($message) {
    Write-Host "✗ $message" -ForegroundColor Red
}

function Write-Step($step, $message) {
    Write-Host "`n[$step] $message" -ForegroundColor Magenta
}

# Check if running as administrator
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Download file with progress
function Download-File($url, $destination) {
    try {
        Write-Info "Downloading $(Split-Path $destination -Leaf)..."
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($url, $destination)
        Write-Success "Download completed"
    }
    catch {
        Write-Error "Failed to download file: $($_.Exception.Message)"
        throw
    }
}

# Check if Python 3.6 is available
function Test-Python36 {
    try {
        $pythonVersions = @()
        
        # Check common Python installation paths
        $commonPaths = @(
            "$env:LOCALAPPDATA\Programs\Python\Python36\python.exe",
            "$env:PROGRAMFILES\Python36\python.exe",
            "$env:PROGRAMFILES(X86)\Python36\python.exe"
        )
        
        foreach ($path in $commonPaths) {
            if (Test-Path $path) {
                $version = & $path --version 2>&1
                if ($version -match "Python 3\.6\.") {
                    return $path
                }
            }
        }
        
        # Check PATH
        try {
            $pathPython = Get-Command python -ErrorAction SilentlyContinue
            if ($pathPython) {
                $version = & $pathPython.Source --version 2>&1
                if ($version -match "Python 3\.6\.") {
                    return $pathPython.Source
                }
            }
        }
        catch {
            # Ignore errors when checking PATH
        }
        
        return $null
    }
    catch {
        return $null
    }
}

# Install Python 3.6
function Install-Python36 {
    param($installerPath)
    
    if (-not (Test-Path $installerPath)) {
        Write-Error "Python 3.6 installer not found at: $installerPath"
        Write-Info "Please ensure the python-3.6.7-amd64.exe file is in the same directory as this script"
        throw "Python installer not found"
    }
    
    Write-Info "Installing Python 3.6.7..."
    Write-Warning "This may require administrator privileges and take several minutes"
    
    $installArgs = @(
        "/quiet",
        "InstallAllUsers=0",
        "PrependPath=0",
        "Include_test=0",
        "Include_doc=0",
        "Include_dev=0",
        "Include_debug=0",
        "Include_launcher=0",
        "InstallLauncherAllUsers=0",
        "TargetDir=$env:LOCALAPPDATA\Programs\Python\Python36"
    )
    
    try {
        $process = Start-Process -FilePath $installerPath -ArgumentList $installArgs -Wait -PassThru -NoNewWindow
        if ($process.ExitCode -eq 0) {
            Write-Success "Python 3.6.7 installed successfully"
            return "$env:LOCALAPPDATA\Programs\Python\Python36\python.exe"
        }
        else {
            throw "Python installation failed with exit code: $($process.ExitCode)"
        }
    }
    catch {
        Write-Error "Failed to install Python: $($_.Exception.Message)"
        throw
    }
}

# Create virtual environment
function New-VirtualEnvironment($pythonPath, $venvPath) {
    Write-Info "Creating virtual environment at: $venvPath"
    
    if (Test-Path $venvPath) {
        if ($Force) {
            Write-Warning "Removing existing virtual environment"
            Remove-Item $venvPath -Recurse -Force
        }
        else {
            Write-Error "Virtual environment already exists at: $venvPath"
            Write-Info "Use -Force parameter to overwrite existing environment"
            throw "Virtual environment exists"
        }
    }
    
    # Ensure parent directory exists
    $parentDir = Split-Path $venvPath -Parent
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }
    
    try {
        & $pythonPath -m venv $venvPath
        Write-Success "Virtual environment created successfully"
    }
    catch {
        Write-Error "Failed to create virtual environment: $($_.Exception.Message)"
        throw
    }
}

# Activate virtual environment and return paths
function Get-VenvPaths($venvPath) {
    $pythonExe = Join-Path $venvPath "Scripts\python.exe"
    $pipExe = Join-Path $venvPath "Scripts\pip.exe"
    $activateScript = Join-Path $venvPath "Scripts\Activate.ps1"
    
    return @{
        Python = $pythonExe
        Pip = $pipExe
        Activate = $activateScript
    }
}

# Install packages in virtual environment
function Install-Packages($pipPath, $wheelPath) {
    Write-Info "Upgrading pip..."
    try {
        & $pipPath install --upgrade pip --quiet
        Write-Success "Pip upgraded successfully"
    }
    catch {
        Write-Warning "Could not upgrade pip: $($_.Exception.Message)"
    }
    
    Write-Info "Installing essential packages..."
    $packages = @(
        "wheel",
        "setuptools",
        "cython",
        "numpy",
        "matplotlib",
        "jupyter",
        "ipython",
        "opencv-python",  # For computer vision/camera processing
        "pillow",         # For image processing
        "scipy",          # Scientific computing
        "pandas"          # Data analysis
    )
    
    foreach ($package in $packages) {
        try {
            Write-Info "Installing $package..."
            & $pipPath install $package --quiet
            Write-Success "$package installed"
        }
        catch {
            Write-Warning "Could not install $package: $($_.Exception.Message)"
        }
    }
    
    # Install PyHula wheel
    if (Test-Path $wheelPath) {
        Write-Info "Installing PyHula library..."
        try {
            & $pipPath install $wheelPath --force-reinstall --quiet
            Write-Success "PyHula library installed successfully"
        }
        catch {
            Write-Error "Failed to install PyHula: $($_.Exception.Message)"
            throw
        }
    }
    else {
        Write-Error "PyHula wheel file not found at: $wheelPath"
        throw "PyHula wheel not found"
    }
}

# Create activation batch file for easy access
function New-ActivationBatch($venvPath, $installPath) {
    $batchContent = @"
@echo off
cd /d "$installPath"
call "$venvPath\Scripts\activate.bat"
echo.
echo ===============================================
echo   PyHula Environment Activated
echo ===============================================
echo.
echo Python version:
python --version
echo.
echo PyHula status:
python -c "import pyhula; print('PyHula version:', pyhula.get_version().strip())"
echo.
echo Available packages:
pip list | findstr -i "pyhula numpy matplotlib jupyter opencv"
echo.
echo Network interfaces (for drone connection):
ipconfig | findstr "IPv4"
echo.
echo ===============================================
echo   Quick Start Commands:
echo ===============================================
echo To start Jupyter Notebook:     jupyter notebook
echo To run PyHula examples:        python pyhula_basic_examples.py
echo To run comprehensive tutorial: python pyhula_comprehensive_tutorial.py
echo To test installation:          python test_pyhula_installation.py
echo To deactivate environment:     deactivate
echo.
echo For network setup help, see:   network_setup_guide.md
echo.
cmd /k
"@
    
    $batchFile = Join-Path $installPath "start_pyhula_environment.bat"
    $batchContent | Out-File -FilePath $batchFile -Encoding ASCII
    Write-Success "Created activation batch file: $batchFile"
    return $batchFile
}

# Create PowerShell activation script
function New-ActivationScript($venvPath, $installPath) {
    $scriptContent = @"
# PyHula Environment Activation Script
Set-Location "$installPath"
& "$venvPath\Scripts\Activate.ps1"

Write-Host ""
Write-Host "===============================================" -ForegroundColor Green
Write-Host "   PyHula Environment Activated" -ForegroundColor Green  
Write-Host "===============================================" -ForegroundColor Green
Write-Host ""

Write-Host "Python version:" -ForegroundColor Cyan
python --version

Write-Host ""
Write-Host "PyHula library status:" -ForegroundColor Cyan
try {
    python -c "import pyhula; print('Version:', pyhula.get_version().strip()); api = pyhula.UserApi(); print('UserApi: Ready for drone connection')"
} catch {
    Write-Host "Error testing PyHula" -ForegroundColor Red
}

Write-Host ""
Write-Host "Network interfaces (for drone connection):" -ForegroundColor Cyan
Get-NetIPAddress -AddressFamily IPv4 | Where-Object {`$_.InterfaceAlias -like "*Wi-Fi*" -or `$_.InterfaceAlias -like "*Ethernet*"} | Select-Object InterfaceAlias, IPAddress | Format-Table

Write-Host ""
Write-Host "===============================================" -ForegroundColor Yellow
Write-Host "   Quick Start Commands:" -ForegroundColor Yellow
Write-Host "===============================================" -ForegroundColor Yellow
Write-Host "Start Jupyter Notebook: " -NoNewline
Write-Host "jupyter notebook" -ForegroundColor White
Write-Host "Run PyHula examples: " -NoNewline
Write-Host "python pyhula_basic_examples.py" -ForegroundColor White
Write-Host "Run comprehensive tutorial: " -NoNewline
Write-Host "python pyhula_comprehensive_tutorial.py" -ForegroundColor White
Write-Host "Test installation: " -NoNewline
Write-Host "python test_pyhula_installation.py" -ForegroundColor White
Write-Host "Deactivate environment: " -NoNewline  
Write-Host "deactivate" -ForegroundColor White
Write-Host ""
Write-Host "For network setup help, see: " -NoNewline
Write-Host "network_setup_guide.md" -ForegroundColor Cyan
Write-Host ""
"@
    
    $scriptFile = Join-Path $installPath "start_pyhula_environment.ps1"
    $scriptContent | Out-File -FilePath $scriptFile -Encoding UTF8
    Write-Success "Created activation PowerShell script: $scriptFile"
    return $scriptFile
}

# Test PyHula installation
function Test-PyHulaInstallation($pythonPath) {
    Write-Info "Testing PyHula installation..."
    try {
        # Test basic import
        $importTest = & $pythonPath -c "import pyhula; print('Import successful')" 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "PyHula import failed: $importTest"
            return $false
        }
        
        # Test version retrieval
        $versionTest = & $pythonPath -c "import pyhula; print('Version:', pyhula.get_version().strip())" 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Success "PyHula version test successful:"
            Write-Host "  $versionTest" -ForegroundColor White
        } else {
            Write-Warning "Could not get PyHula version: $versionTest"
        }
        
        # Test UserApi creation
        $apiTest = & $pythonPath -c "import pyhula; api = pyhula.UserApi(); print('UserApi created successfully')" 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Success "UserApi creation test successful:"
            Write-Host "  $apiTest" -ForegroundColor White
        } else {
            Write-Warning "UserApi creation failed: $apiTest"
        }
        
        return $true
        
    }
    catch {
        Write-Warning "Could not test PyHula: $($_.Exception.Message)"
        return $false
    }
}

# Copy example files and documentation
function Copy-ExampleFiles($installPath, $scriptDir) {
    $exampleFiles = @(
        "test_pyhula_installation.py",
        "QUICK_REFERENCE.md"
    )
    
    foreach ($file in $exampleFiles) {
        $sourcePath = Join-Path $scriptDir $file
        $destPath = Join-Path $installPath $file
        
        if (Test-Path $sourcePath) {
            try {
                Copy-Item $sourcePath $destPath -Force
                Write-Success "Copied $file to installation directory"
            }
            catch {
                Write-Warning "Could not copy $file: $($_.Exception.Message)"
            }
        }
    }
    
    Write-Success "Example files and documentation copied"
}

# Main installation process
function Start-Installation {
    Write-Host @"

╔══════════════════════════════════════════════════════════════╗
║                PyHula Environment Setup                     ║
║              For Windows 11 Students                        ║
╚══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

    Write-Info "Installation directory: $InstallPath"
    Write-Info "Script directory: $ScriptDir"
    
    try {
        # Step 1: Check for Python 3.6
        Write-Step "1/6" "Checking for Python 3.6..."
        $pythonPath = Test-Python36
        
        if (-not $pythonPath) {
            Write-Warning "Python 3.6 not found. Installing..."
            $pythonPath = Install-Python36 -installerPath $Python36Installer
        }
        else {
            Write-Success "Found Python 3.6 at: $pythonPath"
        }
        
        # Step 2: Create virtual environment
        Write-Step "2/6" "Creating virtual environment..."
        New-VirtualEnvironment -pythonPath $pythonPath -venvPath $VenvPath
        
        # Step 3: Get virtual environment paths
        Write-Step "3/6" "Setting up virtual environment paths..."
        $venvPaths = Get-VenvPaths -venvPath $VenvPath
        Write-Success "Virtual environment configured"
        
        # Step 4: Install packages
        Write-Step "4/6" "Installing packages and PyHula library..."
        Install-Packages -pipPath $venvPaths.Pip -wheelPath $PyHulaWheel
        
        # Step 5: Create activation scripts
        Write-Step "5/6" "Creating activation scripts..."
        $batchFile = New-ActivationBatch -venvPath $VenvPath -installPath $InstallPath
        $scriptFile = New-ActivationScript -venvPath $VenvPath -installPath $InstallPath
        
        # Step 6: Test installation and create examples
        Write-Step "6/7" "Testing PyHula installation..."
        $testSuccess = Test-PyHulaInstallation -pythonPath $venvPaths.Python
        
        # Step 7: Copy example files to installation directory
        Write-Step "7/7" "Creating example files and documentation..."
        Copy-ExampleFiles -installPath $InstallPath -scriptDir $ScriptDir
        
        # Summary
        Write-Host "`n╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Green
        Write-Host "║                    INSTALLATION COMPLETE                    ║" -ForegroundColor Green
        Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Green
        
        Write-Host "`nInstallation Summary:" -ForegroundColor Cyan
        Write-Host "• Python 3.6 Location: " -NoNewline; Write-Host $pythonPath -ForegroundColor White
        Write-Host "• Virtual Environment: " -NoNewline; Write-Host $VenvPath -ForegroundColor White
        Write-Host "• Batch Activation: " -NoNewline; Write-Host $batchFile -ForegroundColor White
        Write-Host "• PowerShell Activation: " -NoNewline; Write-Host $scriptFile -ForegroundColor White
        
        Write-Host "`nTo start using PyHula:" -ForegroundColor Yellow
        Write-Host "1. Double-click: " -NoNewline; Write-Host "start_pyhula_environment.bat" -ForegroundColor White
        Write-Host "2. Or run in PowerShell: " -NoNewline; Write-Host ".\start_pyhula_environment.ps1" -ForegroundColor White
        
        if ($testSuccess) {
            Write-Host "`n✅ PyHula is ready to use!" -ForegroundColor Green
        }
        else {
            Write-Host "`n⚠️  PyHula installation completed but testing failed. Manual verification may be needed." -ForegroundColor Yellow
        }
        
    }
    catch {
        Write-Host "`n╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Red
        Write-Host "║                    INSTALLATION FAILED                      ║" -ForegroundColor Red
        Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Red
        
        Write-Error "Installation failed: $($_.Exception.Message)"
        Write-Host "`nTroubleshooting tips:" -ForegroundColor Yellow
        Write-Host "• Ensure you have internet connection for package downloads"
        Write-Host "• Try running PowerShell as Administrator"
        Write-Host "• Check if antivirus software is blocking the installation"
        Write-Host "• Verify that python-3.6.7-amd64.exe and pyhula wheel are in the script directory"
        
        exit 1
    }
}

# Script entry point
if ($PSCmdlet.ShouldProcess("PyHula Environment", "Install")) {
    Start-Installation
}
