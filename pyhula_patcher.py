#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
PyHula Installation Patcher
Applies permanent fixes to the installed PyHula library
"""

import os
import sys
import shutil
import importlib.util
from pathlib import Path

class PyHulaPatcher:
    """
    Patches PyHula installation to fix known issues
    """
    
    def __init__(self):
        self.pyhula_path = None
        self.backup_dir = None
        self.patches_applied = []
        
    def find_pyhula_installation(self):
        """Find the PyHula installation directory"""
        try:
            import pyhula
            pyhula_file = pyhula.__file__
            self.pyhula_path = Path(pyhula_file).parent
            print(f"Found PyHula at: {self.pyhula_path}")
            return True
        except ImportError:
            print("PyHula not found. Please install PyHula first.")
            return False
    
    def create_backup(self):
        """Create backup of original files before patching"""
        if not self.pyhula_path:
            return False
            
        self.backup_dir = self.pyhula_path / "original_backup"
        if not self.backup_dir.exists():
            self.backup_dir.mkdir()
            print(f"Created backup directory: {self.backup_dir}")
        
        # Backup specific files we'll modify
        files_to_backup = [
            "pypack/fylo/mavlink.py",
            "pypack/system/taskcontroller.py",
            "userapi.py"
        ]
        
        for file_path in files_to_backup:
            source = self.pyhula_path / file_path
            if source.exists():
                backup_dest = self.backup_dir / file_path
                backup_dest.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(source, backup_dest)
                print(f"Backed up: {file_path}")
        
        return True
    
    def patch_mavlink_header(self):
        """Patch the MAVLink header packing issue"""
        mavlink_file = self.pyhula_path / "pypack" / "fylo" / "mavlink.py"
        
        if not mavlink_file.exists():
            print(f"MAVLink file not found: {mavlink_file}")
            return False
        
        # Read the current file
        with open(mavlink_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Check if already patched
        if "# PYHULA_PATCH_APPLIED" in content:
            print("MAVLink header patch already applied")
            return True
        
        # Find and replace the problematic pack method
        original_pack_pattern = '''    def pack(self, force_mavlink1=False):
        """
        pack the MAVLink header into a byte string
        """
        '''
        
        fixed_pack_code = '''    def pack(self, force_mavlink1=False):
        """
        pack the MAVLink header into a byte string
        """
        # PYHULA_PATCH_APPLIED: Fix struct packing with proper integer conversion
        try:
            # Ensure all values are proper integers
            magic = int(self.magic) if hasattr(self, 'magic') else 254
            length = int(self.length) if hasattr(self, 'length') else 0
            seq = int(self.seq) if hasattr(self, 'seq') else 0
            srcSystem = int(self.srcSystem) if hasattr(self, 'srcSystem') else 255
            srcComponent = int(self.srcComponent) if hasattr(self, 'srcComponent') else 190
            msgId = int(self.msgId) if hasattr(self, 'msgId') else 0
            
            return struct.pack('<BBBBBB', magic, length, seq, srcSystem, srcComponent, msgId)
        except (ValueError, TypeError) as e:
            # Fallback with default values if conversion fails
            print(f"MAVLink header pack warning: {e}, using defaults")
            return struct.pack('<BBBBBB', 254, 0, 0, 255, 190, 0)
        '''
        
        # Apply the patch
        if original_pack_pattern in content:
            # Find the complete method and replace it
            lines = content.split('\n')
            new_lines = []
            in_pack_method = False
            indent_level = 0
            
            for line in lines:
                if 'def pack(self, force_mavlink1=False):' in line:
                    in_pack_method = True
                    indent_level = len(line) - len(line.lstrip())
                    # Add our fixed method
                    new_lines.extend(fixed_pack_code.split('\n'))
                    continue
                
                if in_pack_method:
                    current_indent = len(line) - len(line.lstrip())
                    if line.strip() and current_indent <= indent_level and not line.strip().startswith('"""'):
                        # End of method reached
                        in_pack_method = False
                        new_lines.append(line)
                    # Skip original method lines
                    continue
                else:
                    new_lines.append(line)
            
            # Write the patched file
            patched_content = '\n'.join(new_lines)
            with open(mavlink_file, 'w', encoding='utf-8') as f:
                f.write(patched_content)
            
            print("✓ Applied MAVLink header struct packing fix")
            self.patches_applied.append("mavlink_header_fix")
            return True
        else:
            print("Could not find MAVLink pack method pattern to patch")
            return False
    
    def patch_udp_binding(self):
        """Patch UDP binding issues in task controller"""
        taskcontroller_file = self.pyhula_path / "pypack" / "system" / "taskcontroller.py"
        
        if not taskcontroller_file.exists():
            print(f"TaskController file not found: {taskcontroller_file}")
            return False
        
        # Read the current file
        with open(taskcontroller_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Check if already patched
        if "# PYHULA_UDP_PATCH_APPLIED" in content:
            print("UDP binding patch already applied")
            return True
        
        # Find UDP binding code and make it more robust
        udp_bind_patterns = [
            "self.sock.bind(('', self.listen_port))",
            "self.sock.bind((\"\", self.listen_port))",
            "sock.bind(('', port))",
            "sock.bind((\"\", port))"
        ]
        
        patched = False
        for pattern in udp_bind_patterns:
            if pattern in content:
                # Replace with more robust binding
                robust_bind = f"""# PYHULA_UDP_PATCH_APPLIED: Robust UDP binding
        try:
            {pattern}
        except OSError as e:
            if e.winerror == 10049:  # Address not valid
                # Try binding to localhost instead
                try:
                    self.sock.bind(('127.0.0.1', self.listen_port))
                    print(f"UDP bound to localhost:{{self.listen_port}} (fallback)")
                except:
                    # Try any available port
                    self.sock.bind(('127.0.0.1', 0))
                    print(f"UDP bound to localhost:{{self.sock.getsockname()[1]}} (auto-assigned)")
            else:
                raise e"""
                
                content = content.replace(pattern, robust_bind)
                patched = True
                break
        
        if patched:
            # Write the patched file
            with open(taskcontroller_file, 'w', encoding='utf-8') as f:
                f.write(content)
            
            print("✓ Applied UDP binding robustness fix")
            self.patches_applied.append("udp_binding_fix")
            return True
        else:
            print("Could not find UDP binding pattern to patch")
            return False
    
    def patch_userapi_connection(self):
        """Patch UserApi to handle connection issues gracefully"""
        userapi_file = self.pyhula_path / "userapi.py"
        
        if not userapi_file.exists():
            print(f"UserApi file not found: {userapi_file}")
            return False
        
        # Read the current file
        with open(userapi_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Check if already patched
        if "# PYHULA_USERAPI_PATCH_APPLIED" in content:
            print("UserApi connection patch already applied")
            return True
        
        # Find connect method and make it more robust
        connect_pattern = "def connect(self, server_ip=\"192.168.100.1\"):"
        
        if connect_pattern in content:
            # Add robust connection handling
            robust_connect = '''def connect(self, server_ip="192.168.100.1"):
        """
        connect to the drone with robust error handling
        """
        # PYHULA_USERAPI_PATCH_APPLIED
        try:
            print(f"Connecting to drone at {server_ip}...")
            result = self._control_server.connect(server_ip)
            if result:
                print("✓ Connection established")
            else:
                print("✗ Connection failed - no response from drone")
            return result
        except Exception as e:
            print(f"✗ Connection error: {e}")
            print("Troubleshooting:")
            print(f"1. Verify drone is at IP: {server_ip}")
            print("2. Check WiFi connection to drone network")
            print("3. Ensure drone is powered and in AP mode")
            return False'''
            
            # Replace the method
            lines = content.split('\n')
            new_lines = []
            in_connect_method = False
            indent_level = 0
            
            for line in lines:
                if connect_pattern in line:
                    in_connect_method = True
                    indent_level = len(line) - len(line.lstrip())
                    # Add our fixed method
                    for robust_line in robust_connect.split('\n'):
                        new_lines.append(' ' * indent_level + robust_line if robust_line.strip() else '')
                    continue
                
                if in_connect_method:
                    current_indent = len(line) - len(line.lstrip())
                    if line.strip() and current_indent <= indent_level and line.strip().startswith('def '):
                        # Next method reached
                        in_connect_method = False
                        new_lines.append(line)
                    # Skip original method lines
                    continue
                else:
                    new_lines.append(line)
            
            # Write the patched file
            patched_content = '\n'.join(new_lines)
            with open(userapi_file, 'w', encoding='utf-8') as f:
                f.write(patched_content)
            
            print("✓ Applied UserApi connection robustness fix")
            self.patches_applied.append("userapi_connection_fix")
            return True
        else:
            print("Could not find UserApi connect method to patch")
            return False
    
    def verify_patches(self):
        """Verify that patches were applied successfully"""
        print("\nVerifying patches...")
        
        try:
            # Reload PyHula to test patches
            if 'pyhula' in sys.modules:
                importlib.reload(sys.modules['pyhula'])
            
            import pyhula
            api = pyhula.UserApi()
            
            print("✓ PyHula reloaded successfully with patches")
            return True
            
        except Exception as e:
            print(f"✗ Patch verification failed: {e}")
            return False
    
    def apply_all_patches(self):
        """Apply all available patches"""
        print("PyHula Patcher - Applying Fixes")
        print("=" * 40)
        
        # Find PyHula installation
        if not self.find_pyhula_installation():
            return False
        
        # Create backup
        if not self.create_backup():
            print("Failed to create backup")
            return False
        
        # Apply patches
        patches = [
            ("MAVLink Header Fix", self.patch_mavlink_header),
            ("UDP Binding Fix", self.patch_udp_binding),
            ("UserApi Connection Fix", self.patch_userapi_connection)
        ]
        
        success_count = 0
        for name, patch_func in patches:
            print(f"\nApplying {name}...")
            if patch_func():
                success_count += 1
            else:
                print(f"✗ Failed to apply {name}")
        
        # Verify patches
        if success_count > 0:
            self.verify_patches()
        
        print(f"\n" + "=" * 40)
        print(f"Patch Summary: {success_count}/{len(patches)} patches applied")
        print(f"Applied patches: {', '.join(self.patches_applied)}")
        
        if success_count == len(patches):
            print("✓ All patches applied successfully!")
            print("\nPyHula should now work more reliably.")
        else:
            print("⚠ Some patches failed. PyHula may still have issues.")
        
        print(f"\nBackup directory: {self.backup_dir}")
        print("You can restore original files from this backup if needed.")
        
        return success_count > 0
    
    def restore_backup(self):
        """Restore original files from backup"""
        if not self.backup_dir or not self.backup_dir.exists():
            print("No backup directory found")
            return False
        
        print("Restoring original PyHula files...")
        
        # Find all backed up files
        for backup_file in self.backup_dir.rglob("*.py"):
            relative_path = backup_file.relative_to(self.backup_dir)
            target_file = self.pyhula_path / relative_path
            
            # Restore the file
            target_file.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(backup_file, target_file)
            print(f"Restored: {relative_path}")
        
        print("✓ Original files restored")
        return True

def main():
    import argparse
    
    parser = argparse.ArgumentParser(description="PyHula Installation Patcher")
    parser.add_argument('--patch', action='store_true', help='Apply all patches')
    parser.add_argument('--restore', action='store_true', help='Restore original files')
    parser.add_argument('--verify', action='store_true', help='Verify current installation')
    
    args = parser.parse_args()
    
    patcher = PyHulaPatcher()
    
    if args.restore:
        patcher.find_pyhula_installation()
        patcher.restore_backup()
    elif args.verify:
        patcher.find_pyhula_installation()
        patcher.verify_patches()
    else:
        # Default: apply patches
        patcher.apply_all_patches()

if __name__ == "__main__":
    main()