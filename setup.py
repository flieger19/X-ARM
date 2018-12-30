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

def mcu_to_def(mcu):
    defi = mcu.upper()
    families = ['stm32f0', 'stm32f1', 'stm32f2', 'stm32f3', 'stm32f4', 'stm32l1']
    for family in families:
        defi = defi.replace(family, family.lower())
    return '__AVR_' + defi + '__'

def create_workspaces(family, sources_dir, core_dest, periphery_dest):
    core_dir = 'Libraries/CMSIS/'
    periphery_dir = 'Libraries/' + family + 'xx_StdPeriph_Driver/'
    device_dir = 'Device/ST/' + family + 'xx/'
    inc_dir = 'inc'
    src_dir = 'src'
    include_dir = 'Include'
    source_dir = 'Source'

    source = ''
    # 1
    for file in os.listdir(sources_dir + core_dir + include_dir):
        if file.endswith(".h"):
            source = os.path.join(sources_dir + core_dir + include_dir, file)
            copy_file(source, core_dest)
    # 2
    for file in os.listdir(sources_dir + core_dir + device_dir + include_dir):
        if file.endswith(".h"):
            source = os.path.join(sources_dir + core_dir + device_dir + include_dir, file)
            copy_file(source, core_dest)
    # 3
    for file in os.listdir(sources_dir + core_dir + device_dir + source_dir):
        if file.endswith(".c"):
            source = os.path.join(sources_dir + core_dir + device_dir + source_dir, file)
            copy_file(source, core_dest)

    # 1
    for file in os.listdir(sources_dir + periphery_dir + inc_dir):
        if file.endswith(".h"):
            source = os.path.join(sources_dir + periphery_dir + inc_dir, file)
            copy_file(source, periphery_dest)
    # 2
    for file in os.listdir(sources_dir + periphery_dir + src_dir):
        if file.endswith(".c"):
            source = os.path.join(sources_dir + periphery_dir + src_dir, file)
            copy_file(source, periphery_dest)


def supported_mcus(library_dir):
    HEADER = 'Known MCU names:'
    
    BUILD_DIR = 'Libraries'
    
    families = ['STM32F0', 'STM32F1', 'STM32F2', 'STM32F3', 'STM32F4', 'STM32L1']
    
    subdirs = [name for name in os.listdir(library_dir) if os.path.isdir(os.path.join(library_dir, name))]

    mcus = []
    core_dir = ''
    periphery_dir = ''

    for subdir in subdirs:
        for family in families:
            if family in subdir:
                mcus += [family]
                core_dir = BUILD_DIR + '/' + family + '/' + 'core'
                periphery_dir = BUILD_DIR + '/' + family + '/' + 'periphery'
                mkdirs_p(core_dir)
                mkdirs_p(periphery_dir)
                create_workspaces(family, library_dir + '/' + subdir + '/', core_dir, periphery_dir)
                copy_file('Resouces/CMakeLists.txt', BUILD_DIR + '/' + family)
                os.system('cmake -S ' + BUILD_DIR + '/' + family + ' -B ' + BUILD_DIR + '/' + family + ' -DMCU_TYPE:STRING=' + family)
                os.system('make -C ' + BUILD_DIR + '/' + family)

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
        print 'usage: setup.py -L <microcontroller library dir>'
        sys.exit(2)
    
    try:
        opts, args = getopt.getopt(argv,"L:h",["Library=","help"])
    except getopt.GetoptError:
        print 'usage: setup.py -L <microcontroller library dir>'
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print 'usage: setup.py -L <microcontroller library dir>'
            sys.exit()
        elif opt in ("-L", "--Library"):
            directory = arg

    return directory


def install(template, destination, files):
    
    print('Installing ' + template + ' in: "{}"'.format(destination))
    mkdirs_p(destination)
    
    for file in files:
        copy_file(file, destination)


def main(argv):
    
    # prosess option
    LIBRARY_DIR = options(argv)
    
    # check tool chain
    model = {}
    STM32CubeMX = '/Applications/STMicroelectronics/STM32CubeMX.app/Contents/MacOs/STM32CubeMX'
    tools = ['arm-none-eabi-gcc', 'arm-none-eabi-gcc', 'arm-none-eabi-ar', 'arm-none-eabi-as', 'arm-none-eabi-objcopy', 'arm-none-eabi-objdump', 'arm-none-eabi-size', 'arm-none-eabi-nm', 'arm-none-eabi-gdb', 'st-flash', 'st-info', 'st-util', STM32CubeMX]
    for tool in tools:
        model[tool + '_loc'] = ensure_installed(tool)
    
    print(model[STM32CubeMX + '_loc'])
    
    exec_template('Templates/XarmBasic/Makefile.tpl', 'Makefile', model)

    # check microcontroler support
    #model = {'mcus': supported_mcus(),
    #'programmers': supported_programmers()
    #}
    model = {'mcus': supported_mcus(LIBRARY_DIR)}
    exec_template('Templates/XarmBasic/TemplateInfo.plist.tpl', 'TemplateInfo.plist', model)
    
    #print('Generated template:\n\tMCUs        : {}\n\tProgrammers : {}'
    #.format(len(model['mcus']), len(model['programmers'])))
    print('Generated template:\n\tMCUs        : {}'.format(len(model['mcus'])))

    #DEST_DIR = os.path.join(os.path.expanduser('~'),
    #'Library/Developer/Xcode/Templates/Project Template/xavr/xavr.xctemplate/')
    files = ['Templates/XarmBasic/main.c', 'Makefile', 'TemplateInfo.plist', 'Resouces/TemplateIcon.png', 'Resouces/TemplateIcon@2x.png']
    DEST_DIR = os.path.join(os.path.expanduser('~'), 'Downloads/Library/Developer/Xcode/Templates/Project Templates/X-ARM/XarmBasic.xctemplate/')
    install('X-ARM Basic', DEST_DIR, files)

    os.remove('Makefile')
    os.remove('TemplateInfo.plist')
    print('Done. Hack away !\n')


if __name__ == '__main__':
    main(sys.argv[1:])



