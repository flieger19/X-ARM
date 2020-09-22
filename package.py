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
        files = []
        for file in os.listdir(templates_directory + template):
            files += [templates_directory + template + "/" + file]
        install_files(destination_directory + template + ".xctemplate", files)
        install_files(destination_directory + template + ".xctemplate", icons)


def install_sdk_files(destination_directory):
    """
    Installs the header, library, etc. files to the SDK
    :param destination_directory: Destination directory for the files
    """
    source_directory = "/usr/local/Cellar/armv7em-cortex-m4f/10.0.0/armv7em-none-eabi/cortex-m4f/"
    include_directory = "include/"
    library_directory = "lib/"
    destination_directory = destination_directory + "/usr/"

    files = []
    for file in os.listdir(source_directory + include_directory):
        files += [source_directory + include_directory + file]
    install_files(destination_directory + include_directory, files)
    files = []
    for file in os.listdir(source_directory + library_directory):
        files += [source_directory + library_directory + file]
    install_files(destination_directory + library_directory, files)


def install_sdk(source_directory, destination_directory):
    """
    Installs Xcode SDK inside its corresponding platform in the Xcode platform user dir
    :param source_directory: Source directory of the SDK
    :param destination_directory: Destination directory of the SDK
    """
    source_directory = source_directory + "/sdk/"
    destination_directory_version = destination_directory + "/Developer/SDKs/Cortex-M410.0.0.sdk"
    destination_directory = destination_directory + "/Developer/SDKs/Cortex-M4.sdk"

    files = []
    for file in os.listdir(source_directory):
        files += [source_directory + "/" + file]
    install_files(destination_directory, files)
    try:
        os.symlink(destination_directory, destination_directory_version)
    except:
        print("Symlink Error")


def install_platform(platforms):
    """
    Installs Xcode platform in the Xcode platform user dir
    :param platforms: List of platforms to install
    """
    destination_directory = os.path.expanduser('~') + "/Library/Developer/Platforms"
    platforms_directory = ROOT_DIR + "/Platforms/"
    resource_directory = ROOT_DIR + "/Resources/"
    icons = [resource_directory + "Icon.icns"]

    for platform in platforms:
        files = []
        for file in os.listdir(platforms_directory + platform + "/platform"):
            files += [platforms_directory + platform + "/platform/" + file]
        install_files(destination_directory + "/" + platform, files)
        install_files(destination_directory + "/" + platform, icons)
        install_sdk(platforms_directory + platform, destination_directory + "/" + platform)


def install():
    """
    Install package files
    """
    templates = ["STM32CubeMX"]

    install_templates(templates)

    platforms = ["Cortex-M4F"]

    install_platform(platforms)


if __name__ == "__main__":
    install()
