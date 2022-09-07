import argparse
import os
import subprocess
import sys
from os import listdir
from os.path import isfile, join

import wget as wget

from env import DIR_ROOT

DIR_PATH = os.path.join(DIR_ROOT, 'shared', 'xcompilers')
URL_BASE = "https://www.uclibc.org/downloads/binaries/0.9.30.1"


def find_missing(req: [str]) -> [str]:
    files = [f for f in listdir(DIR_PATH) if isfile(join(DIR_PATH, f))]
    return list(filter(lambda file: file not in files, req))


def downloader(req: [str]):
    for r in req:
        # wget.download(f'{URL_BASE}/{r}.tar.bz2')
        # subprocess.run(['$env:WINDIR\sysnative\windowspowershell\v1.0\powershell.exe'])
        p = subprocess.Popen(["powershell.exe", "wget", f"{URL_BASE}/{r}.tar.bz2"], stdout=sys.stdout)
        p.communicate()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='download all requested xcompilers')
    parser.add_argument('files', metavar='N', type=str, nargs='*',
                        help='list of names')
    args = parser.parse_args()

    req = find_missing(args.files)
    downloader(req)
