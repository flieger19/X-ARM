"""
Documentation, License etc.

@package X-ARM Xcode template for embedded arm cortex-m development
"""

import shutil
import os
import sys


ROOT_DIR = os.path.dirname(os.path.abspath(__file__))


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
        try:
            shutil.copy(file_name, destination)
        except IOError as error:
            print("Unable to copy file. %s" % error)
        except:
            print("Unexpected error:", sys.exc_info())


def install_templates(templates):
    """
    Installs the Xcode templates in the Xcode template user dir
    :param templates: List of templates to install
    """
    destination_directory = os.path.expanduser('~') + "/Library/Developer/Xcode/Templates/Project Templates/X-ARM/"
    templates_directory = ROOT_DIR + "/Templates/"
    resource_directory = ROOT_DIR + "/Resources/"
    icons = [resource_directory + "TemplateIcon.png", resource_directory + "TemplateIcon@2x.png"]

    for template in templates:
        install_files(destination_directory + template, os.listdir(templates_directory + template))
        install_files(destination_directory + template, icons)


def install():
    """
    Install package files
    """
    templates = ["STM32CubeMX"]

    install_templates(templates)
