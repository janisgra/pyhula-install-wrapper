"""
PyHula Installation Test Script
This script tests if PyHula is properly installed and working.
Run this inside the activated PyHula environment.
"""

import sys
import os
from datetime import datetime

def print_header(title):
    """Print a formatted header"""
    print("\n" + "="*50)
    print(f"  {title}")
    print("="*50)

def test_python_version():
    """Test if we're running Python 3.6"""
    print_header("Python Version Test")
    print(f"Python version: {sys.version}")
    
    version_info = sys.version_info
    if version_info.major == 3 and version_info.minor == 6:
        print("✓ Python 3.6 detected - Correct version for PyHula")
        return True
    else:
        print("✗ Warning: Not running Python 3.6")
        print("  PyHula requires Python 3.6 specifically")
        return False

def test_essential_packages():
    """Test if essential packages are available"""
    print_header("Essential Packages Test")
    
    packages = [
        ("numpy", "Scientific computing"),
        ("matplotlib", "Plotting and visualization"),
        ("jupyter", "Interactive notebooks"),
        ("cython", "C extensions for Python")
    ]
    
    all_good = True
    for package_name, description in packages:
        try:
            __import__(package_name)
            print(f"✓ {package_name:<12} - {description}")
        except ImportError:
            print(f"✗ {package_name:<12} - NOT FOUND")
            all_good = False
    
    return all_good

def test_pyhula_import():
    """Test PyHula import and basic functionality"""
    print_header("PyHula Library Test")
    
    try:
        import pyhula
        print("✓ PyHula import successful")
        
        # Try to get version using the official method
        try:
            version = pyhula.get_version()
            print(f"  Version: {version.strip()}")
        except Exception as e:
            print(f"  Version: Could not retrieve ({e})")
            
        # Test UserApi class creation
        try:
            api = pyhula.UserApi()
            print("✓ UserApi instance created successfully")
            print("  Ready for drone connection and control")
        except Exception as e:
            print(f"✗ UserApi creation failed: {e}")
            return False
            
        # Check available attributes/functions
        pyhula_attrs = [attr for attr in dir(pyhula) if not attr.startswith('_')]
        print(f"  Available functions/classes: {len(pyhula_attrs)}")
        
        if pyhula_attrs:
            print("  Main components:")
            for attr in pyhula_attrs:
                print(f"    - {attr}")
        
        return True
        
    except ImportError as e:
        print(f"✗ PyHula import failed: {e}")
        print("  Make sure you're running this script in the activated PyHula environment")
        return False
    except Exception as e:
        print(f"✗ PyHula error: {e}")
        return False

def test_environment_info():
    """Display environment information"""
    print_header("Environment Information")
    
    print(f"Script location: {os.path.abspath(__file__)}")
    print(f"Working directory: {os.getcwd()}")
    print(f"Python executable: {sys.executable}")
    print(f"Python path: {sys.path[0]}")
    
    # Check if we're in a virtual environment
    if hasattr(sys, 'real_prefix') or (hasattr(sys, 'base_prefix') and sys.base_prefix != sys.prefix):
        print("✓ Running in virtual environment")
        print(f"  Virtual env path: {sys.prefix}")
    else:
        print("? Not clearly in a virtual environment")
    
    # Check environment variables
    if 'VIRTUAL_ENV' in os.environ:
        print(f"  VIRTUAL_ENV: {os.environ['VIRTUAL_ENV']}")

def create_simple_test():
    """Create comprehensive PyHula usage examples"""
    print_header("Creating PyHula Example Files")
    
    try:
        import pyhula
        
        # Create a comprehensive PyHula tutorial script
        tutorial_content = '''# PyHula Comprehensive Tutorial
# This script demonstrates basic PyHula drone control functionality
# Make sure your drone is connected to WiFi before running

import pyhula
import time

def main():
    print("PyHula Comprehensive Tutorial")
    print("=" * 40)
    
    # Step 1: Create API instance and connect
    print("\\n1. Connecting to drone...")
    api = pyhula.UserApi()
    
    # Try to connect (auto-detect drone IP)
    if api.connect():
        print("✓ Connected to drone successfully!")
    else:
        print("✗ Connection failed. Please check:")
        print("  - Drone is powered on")
        print("  - Computer is connected to drone's WiFi")
        print("  - No firewall blocking connection")
        return False
    
    # Step 2: Get drone information
    print("\\n2. Getting drone information...")
    try:
        battery = api.get_battery()
        print(f"  Battery level: {battery}%")
        
        drone_id = api.get_plane_id()
        print(f"  Drone ID: {drone_id}")
        
        coordinates = api.get_coordinate()
        print(f"  Position: x={coordinates[0]}, y={coordinates[1]}, z={coordinates[2]}")
        
        version = pyhula.get_version()
        print(f"  PyHula version: {version.strip()}")
        
    except Exception as e:
        print(f"  Warning: Could not get all drone info: {e}")
    
    # Step 3: Basic flight demonstration
    print("\\n3. Basic flight demonstration...")
    print("   Starting in 3 seconds... (Ctrl+C to cancel)")
    
    try:
        time.sleep(3)
        
        # Takeoff
        print("  Taking off...")
        api.single_fly_takeoff()
        time.sleep(3)
        
        # Hover for 2 seconds
        print("  Hovering...")
        api.single_fly_hover_flight(2)
        
        # Move forward 50cm
        print("  Moving forward 50cm...")
        api.single_fly_forward(50, 30)  # 50cm at 30cm/s
        time.sleep(2)
        
        # Turn left 90 degrees
        print("  Turning left 90 degrees...")
        api.single_fly_turnleft(90)
        time.sleep(2)
        
        # Move up 30cm
        print("  Moving up 30cm...")
        api.single_fly_up(30, 20)
        time.sleep(2)
        
        # Land
        print("  Landing...")
        api.single_fly_touchdown()
        
        print("✓ Flight demonstration completed successfully!")
        
    except KeyboardInterrupt:
        print("\\n  Flight cancelled by user")
        print("  Emergency landing...")
        api.single_fly_touchdown()
    except Exception as e:
        print(f"  Flight error: {e}")
        print("  Attempting emergency landing...")
        try:
            api.single_fly_touchdown()
        except:
            pass
    
    return True

if __name__ == "__main__":
    if main():
        print("\\n🎉 Tutorial completed successfully!")
        print("\\nNext steps:")
        print("1. Modify this script to create your own flight patterns")
        print("2. Explore LED controls, camera functions, and AI features")
        print("3. Check the PyHula documentation for advanced features")
    else:
        print("\\n❌ Tutorial failed. Check your drone connection.")
        
    input("\\nPress Enter to exit...")
'''
        
        # Create basic examples script
        examples_content = '''# PyHula Basic Examples
# Individual examples of PyHula functionality

import pyhula
import time

# Initialize API
api = pyhula.UserApi()

def example_connection():
    """Example: Connect to drone"""
    print("Connecting to drone...")
    
    # Method 1: Auto-detect drone IP
    if api.connect():
        print("✓ Auto-connection successful")
        return True
    
    # Method 2: Specify drone IP manually
    drone_ip = "192.168.1.118"  # Replace with your drone's IP
    if api.connect(drone_ip):
        print(f"✓ Connected to {drone_ip}")
        return True
    
    print("✗ Connection failed")
    return False

def example_basic_flight():
    """Example: Basic takeoff, hover, and land"""
    print("Basic flight example...")
    
    # Takeoff with LED effect
    led_effect = {'r': 0, 'g': 255, 'b': 0, 'mode': 1}  # Green light
    api.single_fly_takeoff(led_effect)
    time.sleep(3)
    
    # Hover for 5 seconds
    api.single_fly_hover_flight(5)
    
    # Land with different LED effect
    led_effect = {'r': 255, 'g': 0, 'b': 0, 'mode': 32}  # Red blinking
    api.single_fly_touchdown(led_effect)

def example_movement():
    """Example: Various movement commands"""
    print("Movement example...")
    
    api.single_fly_takeoff()
    time.sleep(2)
    
    # Forward and backward
    api.single_fly_forward(100, 50)  # 100cm at 50cm/s
    time.sleep(3)
    api.single_fly_back(100, 50)
    time.sleep(3)
    
    # Left and right
    api.single_fly_left(50, 30)
    time.sleep(2)
    api.single_fly_right(50, 30)
    time.sleep(2)
    
    # Up and down
    api.single_fly_up(50, 25)
    time.sleep(2)
    api.single_fly_down(50, 25)
    time.sleep(2)
    
    api.single_fly_touchdown()

def example_rotation():
    """Example: Rotation and autogyration"""
    print("Rotation example...")
    
    api.single_fly_takeoff()
    time.sleep(2)
    
    # Turn left and right
    api.single_fly_turnleft(90)
    time.sleep(2)
    api.single_fly_turnright(180)
    time.sleep(2)
    api.single_fly_turnleft(90)  # Back to original position
    time.sleep(2)
    
    # Full 360-degree rotation (2 turns counterclockwise)
    api.single_fly_autogyration360(2)
    time.sleep(5)
    
    api.single_fly_touchdown()

def example_led_control():
    """Example: LED light control"""
    print("LED control example...")
    
    # Set different LED modes
    led_modes = [
        {'r': 255, 'g': 0, 'b': 0, 'mode': 1},    # Red solid
        {'r': 0, 'g': 255, 'b': 0, 'mode': 32},   # Green blinking
        {'r': 0, 'g': 0, 'b': 255, 'mode': 64},   # Blue breathing
        {'r': 255, 'g': 255, 'b': 255, 'mode': 4}, # RGB cycle
    ]
    
    for i, led in enumerate(led_modes):
        print(f"  Setting LED mode {i+1}...")
        api.single_fly_lamplight(led['r'], led['g'], led['b'], 3, led['mode'])
        time.sleep(4)

def example_drone_info():
    """Example: Get drone information"""
    print("Drone information example...")
    
    try:
        battery = api.get_battery()
        print(f"Battery: {battery}%")
        
        coordinates = api.get_coordinate()
        print(f"Position: {coordinates}")
        
        angles = api.get_yaw()
        print(f"Angles (yaw, pitch, roll): {angles}")
        
        speed = api.get_plane_speed()
        print(f"Speed (X, Y, Z): {speed}")
        
        height = api.get_plane_distance()
        print(f"ToF height: {height}cm")
        
        drone_id = api.get_plane_id()
        print(f"Drone ID: {drone_id}")
        
        version = pyhula.get_version()
        print(f"PyHula version: {version.strip()}")
        
    except Exception as e:
        print(f"Error getting drone info: {e}")

# Main execution
if __name__ == "__main__":
    print("PyHula Basic Examples")
    print("=" * 30)
    
    if example_connection():
        print("\\nChoose an example to run:")
        print("1. Basic flight (takeoff, hover, land)")
        print("2. Movement commands")
        print("3. Rotation examples")
        print("4. LED control")
        print("5. Drone information")
        print("0. Exit")
        
        while True:
            try:
                choice = input("\\nEnter choice (0-5): ").strip()
                
                if choice == "0":
                    break
                elif choice == "1":
                    example_basic_flight()
                elif choice == "2":
                    example_movement()
                elif choice == "3":
                    example_rotation()
                elif choice == "4":
                    example_led_control()
                elif choice == "5":
                    example_drone_info()
                else:
                    print("Invalid choice. Please enter 0-5.")
                    
            except KeyboardInterrupt:
                print("\\nExiting...")
                break
            except Exception as e:
                print(f"Error: {e}")
    else:
        print("Cannot run examples without drone connection.")
        print("Please check your drone setup and try again.")
'''

        # Create network setup guide
        network_guide = '''# PyHula Network Setup Guide
# Instructions for connecting to your drone

## WiFi Connection Setup

### Step 1: Power on your drone
1. Turn on your Hula drone
2. Wait for the drone to fully initialize (about 30 seconds)
3. The drone will create its own WiFi hotspot

### Step 2: Connect to drone WiFi
1. On your computer, go to WiFi settings
2. Look for a WiFi network named something like:
   - "HULA_DRONE_XXXXX"
   - "FPV_XXXXXX" 
   - Or similar drone-related name
3. Connect to this network
   - Password is usually printed on the drone or in documentation
   - Common passwords: "12345678", "88888888", or no password

### Step 3: Find drone IP address
The drone typically uses one of these IP addresses:
- 192.168.1.118 (most common)
- 192.168.4.1
- 192.168.10.1

### Step 4: Test connection
```python
import pyhula

api = pyhula.UserApi()

# Method 1: Auto-detect (recommended)
if api.connect():
    print("Connected successfully!")
else:
    print("Auto-connection failed, trying manual IP...")
    
    # Method 2: Try common IPs
    common_ips = ["192.168.1.118", "192.168.4.1", "192.168.10.1"]
    
    for ip in common_ips:
        print(f"Trying {ip}...")
        if api.connect(ip):
            print(f"Connected to {ip}!")
            break
    else:
        print("Could not connect to drone")
```

## Troubleshooting Connection Issues

### Problem: Cannot find drone WiFi
**Solutions:**
- Ensure drone is powered on and fully initialized
- Reset drone WiFi (check drone manual)
- Move closer to the drone (within 10 meters)

### Problem: Connected to WiFi but cannot connect via PyHula
**Solutions:**
- Check firewall settings (temporarily disable)
- Try different IP addresses
- Restart both drone and computer
- Check if another program is using the drone connection

### Problem: Connection works but commands fail
**Solutions:**
- Check drone battery level (should be >20%)
- Ensure drone is on a flat surface for takeoff
- Check for obstacle avoidance sensors blocking commands
- Verify drone is not in an error state (check LED indicators)

## Advanced Network Configuration

### Using a Router/Access Point
If you want to connect both computer and drone to the same router:
1. Configure drone to connect to your WiFi network (check drone manual)
2. Find drone IP in router admin panel
3. Use that IP in api.connect(ip_address)

### Multiple Drones
When using multiple drones:
1. Each drone will have a unique IP address
2. Create separate UserApi instances for each drone
3. Connect to each drone individually

```python
# Example for multiple drones
api1 = pyhula.UserApi()
api2 = pyhula.UserApi()

api1.connect("192.168.1.118")  # Drone 1
api2.connect("192.168.1.119")  # Drone 2
```

## Safety Notes
- Always test connection in a safe, open area
- Keep drone within visual range
- Monitor battery levels during operation
- Have manual override ready (drone remote control)
- Follow local drone regulations and safety guidelines
'''

        # Write all example files
        files_created = []
        
        try:
            with open('pyhula_comprehensive_tutorial.py', 'w', encoding='utf-8') as f:
                f.write(tutorial_content)
            files_created.append('pyhula_comprehensive_tutorial.py')
            
            with open('pyhula_basic_examples.py', 'w', encoding='utf-8') as f:
                f.write(examples_content)
            files_created.append('pyhula_basic_examples.py')
            
            with open('network_setup_guide.md', 'w', encoding='utf-8') as f:
                f.write(network_guide)
            files_created.append('network_setup_guide.md')
            
            print("✓ Created comprehensive PyHula example files:")
            for file in files_created:
                print(f"  - {file}")
            
            print("\\nFile descriptions:")
            print("  • pyhula_comprehensive_tutorial.py - Complete flight demonstration")
            print("  • pyhula_basic_examples.py - Individual feature examples")
            print("  • network_setup_guide.md - WiFi and connection setup guide")
            
        except Exception as e:
            print(f"✗ Could not create some files: {e}")
            if files_created:
                print(f"  Successfully created: {', '.join(files_created)}")
        
    except Exception as e:
        print(f"✗ Could not create example files: {e}")
        print("  PyHula may not be properly installed")

def main():
    """Main test function"""
    print("PyHula Installation Test")
    print(f"Test started at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    tests = [
        ("Python Version", test_python_version),
        ("Essential Packages", test_essential_packages),
        ("PyHula Library", test_pyhula_import),
    ]
    
    test_results = []
    for test_name, test_func in tests:
        result = test_func()
        test_results.append((test_name, result))
    
    # Environment info (always runs)
    test_environment_info()
    
    # Create example (if PyHula works)
    if test_results[2][1]:  # If PyHula test passed
        create_simple_test()
    
    # Summary
    print_header("Test Summary")
    all_passed = True
    for test_name, result in test_results:
        status = "PASS" if result else "FAIL"
        symbol = "✓" if result else "✗"
        print(f"{symbol} {test_name:<20} - {status}")
        if not result:
            all_passed = False
    
    print("\nOverall Result:")
    if all_passed:
        print("✅ ALL TESTS PASSED - PyHula environment is ready!")
        print("\nNext steps:")
        print("1. Edit and run 'test_pyhula_basic.py' to get started")
        print("2. Create your own PyHula scripts")
        print("3. Use 'jupyter notebook' for interactive development")
    else:
        print("❌ SOME TESTS FAILED - Please check the installation")
        print("\nTroubleshooting:")
        print("1. Make sure you activated the PyHula environment")
        print("2. Re-run the installation script")
        print("3. Check the README.md for troubleshooting tips")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\nTest interrupted by user.")
    except Exception as e:
        print(f"\n\nUnexpected error during testing: {e}")
        print("Please check your PyHula installation.")
    finally:
        print("\nTest completed.")
        input("\nPress Enter to exit...")
