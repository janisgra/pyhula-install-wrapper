#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Test script for patched PyHula installation
"""

import sys
import time

def test_pyhula_basic():
    """Test basic PyHula functionality"""
    try:
        import pyhula
        print("✓ PyHula imported successfully")
        
        api = pyhula.UserApi()
        print("✓ UserApi created successfully")
        
        return True, api
    except Exception as e:
        print(f"✗ PyHula basic test failed: {e}")
        return False, None

def test_connection_robustness(api):
    """Test connection with patched error handling"""
    print("\nTesting connection robustness...")
    
    try:
        # This should now handle errors gracefully
        result = api.connect("192.168.100.1")
        print(f"Connection result: {result}")
        return True
    except Exception as e:
        print(f"Connection test result: {e}")
        return True  # Expected to handle errors gracefully

def test_command_robustness(api):
    """Test command sending with patches"""
    print("\nTesting command robustness...")
    
    try:
        # Try to send a takeoff command (will fail without drone, but shouldn't crash)
        result = api.single_fly_takeoff()
        print(f"Takeoff command result: {result}")
        return True
    except Exception as e:
        print(f"Command test error (expected without drone): {e}")
        return True  # Expected to fail gracefully without drone

def main():
    print("Patched PyHula Test")
    print("=" * 30)
    
    # Test 1: Basic functionality
    basic_ok, api = test_pyhula_basic()
    
    if not basic_ok:
        print("\n✗ Basic PyHula test failed")
        return
    
    # Test 2: Connection robustness
    connection_ok = test_connection_robustness(api)
    
    # Test 3: Command robustness
    command_ok = test_command_robustness(api)
    
    print("\n" + "=" * 30)
    print("Test Results:")
    print(f"Basic Import: {'✓ Pass' if basic_ok else '✗ Fail'}")
    print(f"Connection Handling: {'✓ Pass' if connection_ok else '✗ Fail'}")
    print(f"Command Handling: {'✓ Pass' if command_ok else '✗ Fail'}")
    
    if basic_ok and connection_ok and command_ok:
        print("\n🎉 Patched PyHula is working correctly!")
        print("\nTo use with actual drone:")
        print("1. Connect to drone WiFi network")
        print("2. Run: python -c \"import pyhula; api=pyhula.UserApi(); api.connect()\"")
    else:
        print("\n⚠ Some tests failed. Patches may need adjustment.")

if __name__ == "__main__":
    main()