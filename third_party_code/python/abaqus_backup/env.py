import os
import sys


def get_abaqus_modules_path(mentat='2010', os_name=None):
    # abaqus modules location
    shlibPath = None
    if os_name is None:
        os_name = os.name
    if os_name in ['posix', 'linux']:  # linux, ...
        basedir = '/abaqus/'
        if mentat.startswith('2010'):
            shlibPath = basedir + 'mentat2010/shlib/linux64/'
    elif os_name in ['nt', 'windows']:  # windows
        if mentat.startswith('2010'):
            import platform

            bitstr = platform.architecture()[0]
            bits = int(bitstr.replace('bit', ''))
            if bits is 32:
                shlibPath = 'C:/abaqus.Software/Marc/2008r1/mentat2008r1/shlib'
            elif bits is 64:
                shlibPath = 'C:/abaqus.Software/Marc/2008r1/mentat2008r1/shlib64'
    else:
        print('No abaqus_modules_path could be identified')
    print('abaqus_modules_path: %s' % shlibPath)
    return shlibPath

# TODO: env.marc_run_path

abaqus_modules_path = get_abaqus_modules_path()
if abaqus_modules_path not in sys.path:
    sys.path.insert(0, abaqus_modules_path)
