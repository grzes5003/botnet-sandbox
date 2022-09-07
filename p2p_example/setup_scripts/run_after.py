import argparse
import os
import subprocess
import sys

SCRIPT_DIR = os.path.join(os.path.dirname(__file__), "..", 'setup_scripts')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='run node setup')
    parser.add_argument('vm_name', type=str, help='name of the vm')
    args = parser.parse_args()

    if not args.vm_name:
        exit(5)
    print(f"Running {SCRIPT_DIR}/transfer_files.ps1")
    p = subprocess.Popen(["powershell.exe", f"{SCRIPT_DIR}/transfer_files.ps1", f"-VmName {args.vm_name}"],
                         stdout=sys.stdout)
    p.communicate()
