#!/usr/bin/python

import errno
import os
import re
import shutil
import string
import subprocess
import sys
import getopt

ITER_BEGIN = re.compile('\s*@iter\s+(.+?)@\s*')
ITER_END = re.compile('\s*@end@\s*')

def mkdirs_p(dirs):
    try:
        os.makedirs(dirs)
    except OSError as e:
        if e.errno == errno.EEXIST:
            pass
        else:
            raise


def copy_file(file, destination):
    shutil.copy(file, destination)


def copy_dir(dir, destination):
    #shutil.copytree(dir, destination)
    os.system('cp -r ' + dir + ' ' + destination)


def exec_iter(items, template, output):
    lines = []
    for line in template:
        m = ITER_END.match(line)
        if m:
            break
        else:
            lines.append(line)

    for item in items:
        for line in lines:
            output.write(line.format(**item))


def exec_template(from_template, to, model):
    with open(from_template, 'r') as template:
        with open(to, 'w') as output:
            for line in template:
                m = ITER_BEGIN.match(line)
                if m:
                    items = model[m.group(1)]
                    exec_iter(items, template, output)
                else:
                    output.write(line.format(**model))


def create_platform(family, sources_dir, destination_dir):
    print('Creating platforms for supported mcu...')
    
    core_dir = 'Libraries/CMSIS/'
    periphery_dir = 'Libraries/' + family + 'xx_StdPeriph_Driver/'
    device_dir = 'Device/ST/' + family + 'xx/'
    inc_dir = 'inc'
    src_dir = 'src'
    include_dir = 'Include'
    source_dir = 'Source'

    core_include_dir = destination_dir + '.platform/include/core'
    core_source_dir = destination_dir + '.platform/src/core'
    periphery_include_dir = destination_dir + '.platform/include/periphery'
    periphery_source_dir = destination_dir + '.platform/src/periphery'
    
    mkdirs_p(core_include_dir)
    mkdirs_p(core_source_dir)
    mkdirs_p(periphery_include_dir)
    mkdirs_p(periphery_source_dir)
    
    source = ''
    # 1
    for file in os.listdir(sources_dir + core_dir + include_dir):
        if file.endswith(".h"):
            source = os.path.join(sources_dir + core_dir + include_dir, file)
            copy_file(source, core_include_dir)
    # 2
    for file in os.listdir(sources_dir + core_dir + device_dir + include_dir):
        if file.endswith(".h"):
            source = os.path.join(sources_dir + core_dir + device_dir + include_dir, file)
            copy_file(source, core_include_dir)
    # 3
    for file in os.listdir(sources_dir + core_dir + device_dir + source_dir):
        if file.endswith(".c"):
            source = os.path.join(sources_dir + core_dir + device_dir + source_dir, file)
            copy_file(source, core_source_dir)

    # 1
    for file in os.listdir(sources_dir + periphery_dir + inc_dir):
        if file.endswith(".h"):
            source = os.path.join(sources_dir + periphery_dir + inc_dir, file)
            copy_file(source, periphery_include_dir)
    # 2
    for file in os.listdir(sources_dir + periphery_dir + src_dir):
        if file.endswith(".c"):
            source = os.path.join(sources_dir + periphery_dir + src_dir, file)
            copy_file(source, periphery_source_dir)


def supported_cpus(mcu):
    print('setting supported cpus libraries...')
    
    families = ['stm32f0xx', 'stm32f1xx', 'stm32f2xx', 'stm32f3xx', 'stm32f4xx', 'stm32l1xx']
    cores = ['cortex-m0', 'cortex-m3', 'cortex-m3', 'cortex-m4', 'cortex-m4', 'cortex-m3']
    
    mcpu = ''
    counter = 0
    
    for family in families:
        if family in mcu:
            mcpu =  cores[counter]
        counter += 1
    
    return mcpu


def supported_mcus(library_dir):
    print('Searching for supported mcus libraries...')
    
    BUILD_DIR = 'Platforms'
    
    families = ['STM32F0XX', 'STM32F1XX', 'STM32F2XX', 'STM32F3XX', 'STM32F4XX', 'STM32L1XX']
    
    subdirs = [name for name in os.listdir(library_dir) if os.path.isdir(os.path.join(library_dir, name))]

    mcus = []
    core_dir = ''
    periphery_dir = ''

    for subdir in subdirs:
        for family in families:
            if family[:7] in subdir:
                mcus.append({'mcu': family.lower(), 'flag': family, 'mcpu': supported_cpus(family.lower())})
                destination_dir = BUILD_DIR + '/' + family.lower()
                create_platform(family[:7], library_dir + '/' + subdir + '/', destination_dir)

    return mcus


def supported_programmers():
    HEADER = 'Valid programmers are:'
    PROG_LINE = re.compile('  (.+?)\s+=.*')
    
    proc = subprocess.Popen('st-info -c?', stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    out, err = proc.communicate()
    lines = string.split(err, '\n')
    
    programmers = []
    consider = False
    for line in lines:
        if line == HEADER:
            consider = True
        elif consider:
            m = PROG_LINE.match(line)
            if m:
                programmers.append({'programmer': m.group(1)})
            else:
                break

    return programmers


def arm_loc():
    bin_path = subprocess.check_output('which arm-none-eabi-gcc', shell=True).strip()
    return os.path.dirname(os.path.dirname(os.path.realpath(bin_path)))


def link_loc():
    return subprocess.check_output('which st-info', shell=True).strip()


def ensure_installed(tool):
    proc = subprocess.Popen('which ' + tool, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    out, err = proc.communicate()
    exitcode = proc.returncode
    if exitcode == 0:
        print('Found {t} install in "{p}"'.format(t=tool, p=out.strip()))
        return out.strip()
    else:
        print(tool + ' is not installed (or is not in the PATH).')
        return out.strip()
#sys.exit(1)


def options(argv):
    directory = ''

    if argv == []:
        print('usage: setup.py -L <LIBRARY_DIR>')
        sys.exit(2)
    
    try:
        opts, args = getopt.getopt(argv,"L:h",["Library=","help"])
    except getopt.GetoptError:
        print('usage: setup.py -L <LIBRARY_DIR>')
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print('usage: setup.py -L <LIBRARY_DIR>')
            sys.exit()
        elif opt in ("-L", "--Library"):
            directory = arg

    return directory


def installTemplates(template, destination, files):
    
    print('Installing ' + template + ' in: "{}"'.format(destination))
    mkdirs_p(destination)
    
    for file in files:
        copy_file(file, destination)

def installPlatforms(template, destination, files):
    
    print('Installing ' + template + ' in: "{}"'.format(destination))
    mkdirs_p(destination)
    
    for file in files:
        copy_dir(file, destination)


def supported_peripheries(mcus):
    print('Searching for supported preripheries')
    return ''


def main(argv):
    
    # prosess option
    LIBRARY_DIR = options(argv)
    
    # check tool chain
    model = {}
    os.system('export PATH=$PATH:/Applications/STMicroelectronics/STM32CubeMX.app/Contents/MacOs/')
    tools = ['arm-none-eabi-gcc', 'arm-none-eabi-gcc', 'arm-none-eabi-ar', 'arm-none-eabi-as', 'arm-none-eabi-objcopy', 'arm-none-eabi-objdump', 'arm-none-eabi-size', 'arm-none-eabi-nm', 'arm-none-eabi-gdb', 'st-flash', 'st-info', 'st-util', 'STM32CubeMX']
    for tool in tools:
        model[tool + '_loc'] = ensure_installed(tool)
    
    #print(model[STM32CubeMX + '_loc'])

    # build XarmBasic.xctemplate
    exec_template('Templates/XarmBasic/Makefile.tpl', 'Makefile', model)

    # check microcontroler support
    model = {'mcus': supported_mcus(LIBRARY_DIR)}
    print('Generated template:\n\tMCUs        : {}'.format(len(model['mcus'])))
    exec_template('Templates/XarmBasic/TemplateInfo.plist.tpl', 'TemplateInfo.plist', model)

    # install project template
    files = ['Templates/XarmBasic/main.c', 'Templates/XarmBasic/___VARIABLE_MCU____startup.c', 'Templates/XarmBasic/___VARIABLE_MCU____system.c', 'Templates/XarmBasic/___VARIABLE_MCU____conf.h', 'Makefile', 'TemplateInfo.plist', 'Resources/TemplateIcon.png', 'Resources/TemplateIcon@2x.png']
    PROJ_DIR = os.path.join(os.path.expanduser('~'), 'Library/Developer/Xcode/Templates/Project Templates/X-ARM/XarmBasic.xctemplate/')
    installTemplates('X-ARM Basic', PROJ_DIR, files)

    # install platform library
    PLAT_DIR = os.path.join(os.path.expanduser('~'), 'Library/Developer/Platforms/')
    platforms = model['mcus']
    files = []
    for platform in platforms:
        files += ['Platforms/' + platform['mcu'] + '.platform']
        installPlatforms('X-ARM Platform for ' + platform['mcu'], PLAT_DIR, files)

    # install periphery support
#    model = {'mcus': model['mcus']}
#    model = {'peripheries': supported_peripheries(model['mcus'])}
#    files = ['Templates/XarmFiles/TemplateInfo.plist']
#    FILE_DIR = os.path.join(os.path.expanduser('~'), 'Downloads/Library/Developer/Xcode/Templates/File Templates/X-ARM/XarmPeriphery.xctemplate/')
#    installTemplates('X-ARM Files', FILE_DIR, files)

    os.remove('Makefile')
    os.remove('TemplateInfo.plist')


    print('Done. Hack away !\n')


if __name__ == '__main__':
    main(sys.argv[1:])



