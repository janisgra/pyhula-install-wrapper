# PyHula Quick Reference Card

## 🚁 Essential Commands

### Connection
```python
import pyhula
api = pyhula.UserApi()

# Auto-connect (recommended)
api.connect()

# Manual IP
api.connect("192.168.1.118")
```

### Basic Flight
```python
api.single_fly_takeoff()           # Takeoff
api.single_fly_hover_flight(5)     # Hover 5 seconds
api.single_fly_touchdown()         # Land
```

### Movement (distance in cm, speed in cm/s)
```python
api.single_fly_forward(100, 50)    # Forward 100cm at 50cm/s
api.single_fly_back(100, 50)       # Backward 100cm at 50cm/s
api.single_fly_left(50, 30)        # Left 50cm at 30cm/s
api.single_fly_right(50, 30)       # Right 50cm at 30cm/s
api.single_fly_up(50, 25)          # Up 50cm at 25cm/s
api.single_fly_down(50, 25)        # Down 50cm at 25cm/s
```

### Rotation (angles in degrees)
```python
api.single_fly_turnleft(90)        # Turn left 90°
api.single_fly_turnright(90)       # Turn right 90°
api.single_fly_autogyration360(2)  # 2 full rotations
```

### LED Control
```python
# LED format: {'r': red, 'g': green, 'b': blue, 'mode': mode}
# Modes: 1=solid, 2=off, 4=RGB cycle, 16=colorful, 32=blink, 64=breathing

red_light = {'r': 255, 'g': 0, 'b': 0, 'mode': 1}
api.single_fly_takeoff(red_light)

# Set light without movement
api.single_fly_lamplight(0, 255, 0, 3, 32)  # Green blinking for 3 seconds
```

### Information
```python
battery = api.get_battery()          # Battery percentage
coords = api.get_coordinate()        # [x, y, z] position
angles = api.get_yaw()              # [yaw, pitch, roll] angles
speed = api.get_plane_speed()       # [x, y, z] speed
height = api.get_plane_distance()   # Height from ground
drone_id = api.get_plane_id()       # Drone ID
version = pyhula.get_version()      # PyHula version
```

## 🛜 Network Setup Quick Guide

### 1. Connect to Drone WiFi
- Look for WiFi networks like "HULA_DRONE_XXXXX" or "FPV_XXXXX"
- Common passwords: "12345678", "88888888", or no password

### 2. Common Drone IP Addresses
- 192.168.1.118 (most common)
- 192.168.4.1
- 192.168.10.1

### 3. Test Connection
```python
# Try auto-connect first
if api.connect():
    print("Connected!")
else:
    # Try manual IPs
    for ip in ["192.168.1.118", "192.168.4.1", "192.168.10.1"]:
        if api.connect(ip):
            print(f"Connected to {ip}")
            break
```

## 🎯 Quick Flight Pattern Example
```python
import pyhula
import time

api = pyhula.UserApi()
if api.connect():
    # Square flight pattern
    api.single_fly_takeoff()
    time.sleep(2)
    
    for _ in range(4):  # Square pattern
        api.single_fly_forward(100, 40)
        time.sleep(3)
        api.single_fly_turnright(90)
        time.sleep(2)
    
    api.single_fly_touchdown()
```

## 🆘 Troubleshooting

### Connection Issues
- ✅ Check drone is powered on
- ✅ Connect to drone WiFi
- ✅ Try different IP addresses
- ✅ Disable firewall temporarily
- ✅ Check battery level (>20%)

### Command Issues
- ✅ Ensure flat takeoff surface
- ✅ Check obstacle sensors
- ✅ Verify connection with `api.get_battery()`
- ✅ Wait between commands (use `time.sleep()`)

### Emergency Stop
```python
# Emergency landing
api.single_fly_touchdown()

# Or in Python script
try:
    # Your flight code here
    pass
except KeyboardInterrupt:
    api.single_fly_touchdown()  # Emergency landing
```

## 📁 File Structure After Installation
```
%USERPROFILE%\PyHulaEnvironment\
├── start_pyhula_environment.bat          # Double-click to start
├── start_pyhula_environment.ps1          # PowerShell version
├── pyhula_comprehensive_tutorial.py      # Complete demo
├── pyhula_basic_examples.py              # Feature examples
├── network_setup_guide.md                # Network setup help
└── test_pyhula_installation.py           # Test installation
```

## 🚀 Getting Started Checklist
1. ☐ Double-click `INSTALL_PYHULA.bat`
2. ☐ Wait for installation to complete
3. ☐ Power on your drone
4. ☐ Connect to drone WiFi
5. ☐ Double-click `start_pyhula_environment.bat`
6. ☐ Run `python test_pyhula_installation.py`
7. ☐ Try `python pyhula_basic_examples.py`
8. ☐ Start programming your drone! 🎉

---
*Keep this reference handy while programming your drone!*
