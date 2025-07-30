# PyHula Environment Setup for Students

## Overview
This package provides an automated setup for the PyHula Python library, which requires Python 3.6. The setup script creates an isolated virtual environment so students can use PyHula regardless of their current Python version.

## What's Included
- `python-3.6.7-amd64.exe` - Python 3.6.7 installer for Windows
- `pyhula-1.1.7-cp36-cp36m-win_amd64.whl` - PyHula library wheel file
- `INSTALL_PYHULA.bat` - Simple double-click installer
- `setup_pyhula_environment.ps1` - PowerShell setup script
- `test_pyhula_installation.py` - Installation verification script
- `QUICK_REFERENCE.md` - Quick reference for PyHula commands

## Quick Start (For Students)

### Option 1: Simple Installation
1. **Double-click** `INSTALL_PYHULA.bat`
2. Follow the on-screen instructions
3. Wait for installation to complete

### Option 2: PowerShell Installation
1. Right-click on the folder and select "Open PowerShell window here"
2. Run: `.\setup_pyhula_environment.ps1`

## After Installation

The setup creates several files in your user directory:
- `%USERPROFILE%\PyHulaEnvironment\` - Main installation folder
- `start_pyhula_environment.bat` - Double-click to activate PyHula environment
- `start_pyhula_environment.ps1` - PowerShell activation script
- `pyhula_comprehensive_tutorial.py` - Complete flight demonstration
- `pyhula_basic_examples.py` - Individual feature examples  
- `network_setup_guide.md` - WiFi and connection setup instructions
- `test_pyhula_installation.py` - Installation verification script
- `QUICK_REFERENCE.md` - Quick reference for PyHula commands

## How to Use PyHula

1. **Activate the environment:**
   - Double-click `start_pyhula_environment.bat` (in your home directory)
   - OR run `.\start_pyhula_environment.ps1` in PowerShell

2. **Connect to your drone:**
   ```python
   import pyhula
   
   api = pyhula.UserApi()
   if api.connect():  # Auto-detect drone
       print("Connected!")
   else:
       api.connect("192.168.1.118")  # Manual IP
   ```

3. **Basic drone control:**
   ```python
   api.single_fly_takeoff()     # Takeoff
   api.single_fly_hover_flight(5)  # Hover 5 seconds
   api.single_fly_forward(100)  # Move forward 100cm
   api.single_fly_touchdown()   # Land
   ```

4. **Use example files:**
   - `pyhula_comprehensive_tutorial.py` - Complete flight demonstration
   - `pyhula_basic_examples.py` - Individual feature examples
   - `network_setup_guide.md` - WiFi setup instructions

5. **Use Jupyter Notebook:**
   - After activating the environment, type: `jupyter notebook`

## Troubleshooting

### Common Issues:

**"PowerShell execution policy error"**
- Run PowerShell as Administrator
- Run: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

**"Python installation failed"**
- Run the installer as Administrator
- Temporarily disable antivirus software
- Ensure you have internet connection

**"PyHula import error"**
- Make sure you activated the virtual environment first
- Check that the wheel file is in the same folder as the setup script
- Verify you're using Python 3.6 (run `python --version`)

**"Cannot connect to drone"**
- Ensure drone is powered on and WiFi is active
- Connect your computer to the drone's WiFi network
- Try manual IP connection: `api.connect("192.168.1.118")`
- Check firewall settings (temporarily disable to test)
- See `network_setup_guide.md` for detailed setup instructions

**"Drone commands not working"**
- Check drone battery level (>20% recommended)
- Ensure drone is on flat surface for takeoff
- Verify connection with `api.get_battery()` or `api.get_plane_id()`
- Check for obstacle avoidance sensors blocking commands

### System Requirements:
- Windows 11 (or Windows 10)
- PowerShell 5.1 or higher
- Internet connection (for downloading dependencies)
- ~500MB free disk space

### International Systems:
The script is designed to work with:
- Any Windows display language
- Non-English usernames and paths
- Different regional settings
- Various keyboard layouts

## Advanced Options

### Custom Installation Path:
```powershell
.\setup_pyhula_environment.ps1 -InstallPath "C:\MyCustomPath"
```

### Force Reinstall:
```powershell
.\setup_pyhula_environment.ps1 -Force
```

### Verbose Output:
```powershell
.\setup_pyhula_environment.ps1 -Verbose
```

## For Instructors

### Distribution Package:
Ensure these files are in the same folder:
- `INSTALL_PYHULA.bat`
- `setup_pyhula_environment.ps1`
- `python-3.6.7-amd64.exe`
- `pyhula-1.1.7-cp36-cp36m-win_amd64.whl`
- `README.md` (this file)
- `test_pyhula_installation.py`
- `QUICK_REFERENCE.md`

### Student Instructions:
1. Extract all files to a folder
2. Double-click `INSTALL_PYHULA.bat`
3. Follow the prompts
4. Use the created activation scripts

## Technical Details

The setup script:
1. Checks for existing Python 3.6 installation
2. Installs Python 3.6.7 if not found (user-level, no admin required)
3. Creates an isolated virtual environment
4. Installs essential packages: numpy, matplotlib, jupyter, cython, opencv-python, pillow, scipy, pandas
5. Installs the PyHula library from the wheel file
6. Creates convenient activation scripts with network diagnostics
7. Tests the installation with proper PyHula version detection
8. Creates comprehensive example files and network setup guide

The virtual environment ensures no conflicts with existing Python installations and includes all necessary packages for drone development, computer vision, and data analysis.

## Support

If you encounter issues:
1. Check the troubleshooting section above
2. Ensure all required files are present
3. Try running as Administrator
4. Check system requirements

---
*PyHula Environment Setup v1.0*  
*Compatible with Windows 11 and international systems*
