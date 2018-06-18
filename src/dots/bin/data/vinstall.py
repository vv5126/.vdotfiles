#!/usr/bin/env python3

import os


def py_install():
    os.system("python3 setup.py install --user")

def dpkg(name):
    os.system('sudo dpkg -i ' + name)

def apt(name):
    os.system('sudo apt install ' + name)

def aptitude(name):
    os.system('sudo aptitude -y install ' + name)

def pip(install_dir, name):
    if install_dir == 's':
        os.system('pip install ' + name)
    elif install_dir == 'l':
        os.system('pip install ' + name + ' --user')

def pip3(install_dir, name):
    if install_dir == 's':
        os.system('pip3 install ' + name)
    elif install_dir == 'l':
        os.system('pip3 install ' + name + ' --user')
        # pip3 install --target=/data1/home/wgao/.local/lib filetype

def py(install_dir, name):
    if install_dir == 's':
        os.system('python2 setup.py install ' + name)
    elif install_dir == 'l':
        os.system('python2 setup.py install ' + name + '--user')

def py3(install_dir, name):
    if install_dir == 's':
        os.system('python3 setup.py install ' + name)
    elif install_dir == 'l':
        os.system('python3 setup.py install ' + name + '--user')

