"""
Documentation, License etc.

@package X-ARM Xcode template for embedded arm cortex-m development
"""

import shutil
import os


def install_files(destination, files):
    """
    Install files in a given directory
    :param destination: Directory to install files to
    :param files: Files to install in a given directory
    """
    if not os.path.isdir(destination):
        try:
            os.makedirs(destination)
        except OSError:
            print("Creation of the directory %s failed" % destination)

    for file_name in files:
        shutil.copy(file_name, destination)
