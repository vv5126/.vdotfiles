#!/usr/bin/env python3

import sys
import json
import os
import pri
import tarfile
# import re
import filetype
import subprocess
import shutil

global install_mode
global install_dir
install_mode = 'single'

def check_have(dict1, key1):
        if key1 in dict1.keys() and dict1[key1] != 'NULL':
            return True
        else:
            return False

class Install(object):
    bys_with_sys = ['aptitude', 'apt', 'gdebi','dpkg', 'pip', 'pip3', 'python3', 'src']
    bys = ['pip', 'pip3', 'python3', 'src']
    package = ['.tar.gz', '.bz2.gz', 'tar' ,'rar', 'zip']
    tmp_dir = os.environ.get('HOME') + '/.local/install'

    def __init__(self, app, fjson, install_dir):
        self.needget = False
        self.needtar = False
        self.needcompile = False
        self.needinstall = False
        self.source_dir = '/tmp'
        self.sourcecode_dir = '/tmp'
        self.app = app
        self.fjson = fjson;
        self.install_dir = install_dir
        self.ins_py = False

        print ('app:', self.app)
        print ('install_dir:', self.install_dir)

    def depend(self):
        if 'depend' in self.fjson[self.app].keys():
            return self.fjson[self.app]['depend'].split(' ')
        else:
            return []

    def check_installed(self):
        print ("check_installed")
        if 'installed_flag' not in self.fjson[self.app].keys():
            print ('no installed_flag')
            return False

        checkfile = self.fjson[self.app]['installed_flag']
        if (checkfile[-2:] == '.h') == True:
            (status, output) = subprocess.getstatusoutput('find /usr/lib /lib -name ' + checkfile)
            if output.strip():
                print ('installed_flag:', output.strip())
                return True

        if (checkfile[-3:] == '.so') == True:
            (status, output) = subprocess.getstatusoutput('find /usr/lib /lib -name ' + checkfile)
            if output.strip():
                print ('installed_flag:', output.strip())
                return True

        if (checkfile[-3:] == '.py') == True:
            (status, output) = subprocess.getstatusoutput('find /usr/lib /lib /data1/home/wgao/.local/lib -name ' + checkfile)
            if output.strip():
                pri.cprint ("320", 'wgao ---installed_flag:', output.strip())
                return True

        return False

    def by(self):
        if self.install_dir == 'system':
            tmp_list = list(set(self.bys_with_sys).intersection(set(self.fjson[self.app].keys())))
        else:
            tmp_list = list(set(self.bys).intersection(set(self.fjson[self.app].keys())))
        if tmp_list:
            select = pri.select_list(tmp_list, "\033[5;32;40m请选择: \033[0m")
            self.appdict = self.fjson[self.app][select]
        else:
            raise Exception('getby is empty!')

        self.parse()

    # parse
    def parse(self):
        if 'source' in self.appdict.keys():
            source = self.appdict['source']
            self.needget = True
            self.source = source
            self.sourcename = source.split('/')[-1]
            pri.cprint ("10", 'self.sourcename', self.sourcename)

            if check_have(self.appdict, 'tmp_dst'):
                self.source_dir = self.appdict['tmp_dst']
            else:
                self.source_dir = self.tmp_dir
            if self.source_dir[0:1] == '~':
                self.source_dir = self.source_dir.replace('~', os.environ.get('HOME'), 1)

            if 'https://github.com' in source:
                self.getby = 'git'
                self.sourcecode_dir = self.source_dir + '/' + source.split('/')[-1]
            elif source[0:4] == 'http':
                self.getby = 'wget'
                self.sourcecode_dir = self.source_dir
            else:
                self.getby = 'scp'
                self.sourcecode_dir = self.source_dir

            for i in self.package:
                if source[-len(i):] == i:
                    self.needtar = True
                    break

            self.needinstall = True
        if 'flag' in self.appdict.keys():
            if 'make' in self.appdict['flag']:
                self.needcompile = True
                self.compileflag = 'make'
            if 'code' in self.appdict['flag']:
                pass
            if 'tar' in self.appdict['flag']:
                self.needtar = True
            if 'pycode' in self.appdict['flag']:
                self.ins_py = True
# pip3 install --target=/data1/home/wgao/.local/lib filetype
    def un_tar(self, file_name):
        print ('untar file_name', file_name)
        tar = tarfile.open(file_name)
        names = tar.getnames()
        self.sourcecode_dir = self.source_dir + '/' + names[0]
        if not os.path.exists(names[0]):
            tar.extractall('.', tar)
        tar.close()

    def normal_make(self, i = 0):
        config = [['Makefile','make -j30'], ['configure','./configure'], ['autogen.sh','./autogen.sh']]
        if i >= len(config):
            return
        if not os.path.exists(config[i][0]):
            self.normal_make(i + 1)
        os.system(config[i][1])

    def clean(self):
        print("clean dir : ", self.sourcecode_dir + '/..')
        if os.path.exists(self.sourcecode_dir):
            os.chdir(self.sourcecode_dir + '/..')
            shutil.rmtree(self.sourcecode_dir)

    def install(self):

        if os.path.exists(self.source_dir) == False:
            os.mkdir(self.source_dir)

        os.chdir(self.source_dir)

        # get

        if self.needget == True:
            if check_have(self.appdict, 'get'):
                os.system(self.appdict['get'])
            else:
                if self.getby == 'git':
                    if os.path.exists(self.sourcename):
                        pass
                    else:
                        self._git(self.appdict['source'], self.sourcename)
                elif self.getby == 'wget':
                    if os.path.exists(self.sourcename):
                        pass
                    else:
                        self._wget(self.appdict['source'], self.sourcename)
                else:
                    if install_dir == 'local':
                        pass

# get sourcecode_dir

            # tar
            # if os.path.exists(self.sourcecode_dir):
            #     shutil.rmtree(self.sourcecode_dir)
            if self.needtar == True:
                kind = filetype.guess(self.sourcename)
                if kind is None:
                    print('Cannot guess file type!')
                print('File extension: %s' % kind.extension)

                os.system('pwd')
                if kind.extension is 'gz':
                    print(self.sourcename)
                    self.un_tar(self.sourcename)
                elif kind.extension is '':
                    pass

            if os.path.exists(self.sourcecode_dir):
                os.chdir(self.sourcecode_dir)
                print('cd in ------------', self.sourcecode_dir)
            else:
                print ('can\'t cd to sourcecode_dir')
                return

        # configure
        # compile

        if self.needcompile == True:
            if self.compileflag == 'make':
                pri.cprint ("20", 'cc sdfljsldkfjkljto sourcecode_dir')
                if check_have(self.appdict, 'configure'):
                    os.system(self.appdict['configure'])
                    os.system(self.appdict['make'])
                else:
                    self.normal_make()
            else:
                pass

        # install
        if self.needinstall == True:
            if check_have(self.appdict, 'install'):
                os.system(self.appdict['install'])
            else:
                if self.ins_py == True:
                    if os.path.exists('setup.py'):
                        self._py_install()

        # clean
        if check_have(self.appdict, 'clean'):
            print ('clean empty!!!')
            os.system(self.appdict['clean'])
        # else:
        #     self.clean()

        # pri.cprint("20", "hehe")
    def _py_install(self):
        os.system("python3.4 setup.py install --user")

    def _apt(self, name):
        os.system('sudo apt install', name)

    def _aptitude(self, name):
        os.system('sudo aptitude -y install', name)

    def _wget(self, url, dst):
        os.system('wget ' + url + ' -O '+ dst)

    def _git(self, url, dst = ''):
        if url[0:4] == 'http':
            os.system('git clone ' + url + ' ' + dst)
        else:
            os.system('git clone https://github.com/' + url + ' ' + dst)

    def _pip(self, name):
        if self.install_dir == 'system':
            os.system('pip install ' + name)
        elif self.install_dir == 'local':
            os.system('pip install ' + name + ' --user')

    def _pip3(self, name):
        if self.install_dir == 'system':
            os.system('pip3 install ' + name)
        elif self.install_dir == 'local':
            os.system('pip3 install ' + name + ' --user')

    def _python3():
        if self.install_dir == 'system':
            os.system('python3 setup.py install ' + name)
        elif self.install_dir == 'local':
            os.system('python3 setup.py install ' + name + '--user')

    def _python2():
        if self.install_dir == 'system':
            os.system('python2 setup.py install ' + name)
        elif self.install_dir == 'local':
            os.system('python2 setup.py install ' + name + '--user')

    def _dpkg(self, name):
            os.system('sudo dpkg -i ' + name)


def inst(app, fjson):
    global install_mode
    global install_dir

    if app not in fjson:
        print("\033[31;40mcan't find \"", app, "\" in json file.\033[0m")
        return

    if install_mode == 'single':
        if os.environ["VBESUDO"] == '1':
            tmp = input("install to system? or local.\n[\033[5;32;40mY\033[0m/n]")
            if tmp == 'n':
                install_dir = 'local'
            else:
                install_dir = 'system'

            tmp = input("install follow app ALL same?\n[\033[5;32;40mY\033[0m/n]")
            if tmp == 'y' or tmp == 'Y' or tmp == '':
                install_mode = 'all'

        else:
            install_mode = 'all'
            install_dir = 'local'
            print ("\033[31;40monly support local install!\033[0m")

    ins = Install(app, fjson, install_dir)

    # check is have
    if ins.check_installed() == True:
        return

    # try:
    for i in ins.depend():
        print ('depend on ', i)
        inst(i, fjson)
    # except:
    #     print ("\033[31;40mcan't install \"", app, "\", some depend failed to installed!\033[0m")
    #     return

    # select install method
    ins.by()

    # install:
    # try:
    print ('\033[33;40m(' + install_dir + ') installing...: ', app, "\033[0m")
    ins.install()
    # except:
    #     print ("can't install \"", app, "\", failed!")
    #     return

def main():
    file_in = open("a.json")
    fjson = json.loads(file_in.read())
    file_in.close()

    apps_list = sys.argv
    apps_list.pop(0)

    print ('\033[32;40mrequest install: ', apps_list, '\033[0m')
    for i in apps_list:
        inst(i, fjson)

if __name__ == '__main__':
    main()

