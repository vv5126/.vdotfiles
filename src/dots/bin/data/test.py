#!/usr/bin/env python3

import sys
import json
import os
import pri

global install_mode
global install_dir
install_mode = 'signal'
global tmp_dir
tmp_dir = '/data1/home/wgao/.local/install'

class Install(object):
    to_local = 0

    def __init__(self, app, fjson, install_dir):
        self.app = app
        self.fjson = fjson;
        self.install_dir = install_dir

    def depend(self):
        return []
        # if install_mode == 'system':
        # return (self.fjson[self.app]['method'][3].split(" "))

    def by(self):
        self.getby = pri.select_list(self.fjson[self.app].keys(), "\033[5;32;40m请选择: \033[0m")

    def parpare(self):
        # check if had installed
        pass
        # if os.system("which", app) == 0:
        #     return 1
        # else:
        #     return 0

    def parse(self, _str):
        return _str.split()[0], _str.split()[1]


    def install(self):
        # get
        resource = self.fjson[self.app]['resource']
        for i in resource:
            if i == 'git':
                self._git(resource[i])
                break
            elif i == 'pip':
                self._pip(resource[i])
                break
            elif i == 'pip3':
                self._pip3(resource[i])
                break
            elif i == 'wget':
                self._wget(resource[i])
                break
            else:
                if install_mode == 'local':
                    pass

        # configure
        if self.source_dir != '':
            os.chdir(self.source_dir)
            os.system()

        # compile

        # install

    def clean(self):
        eval(fjson['vim']['method'][4])

    def _apt(self, name):
        os.system('sudo apt install', name)

    # def _aptitude(self, name):
    #     os.system('sudo aptitude install', name)

    def _wget(self, url, dst):
        os.system('wget', url, dst)

    def _git(self, url, dst = tmp_dir):
        self.source_dir = dst + '/' + self.app
        os.system('git clone https://github.com/' + url + ' ' + self.source_dir)

    # def _pip(self, name):
    #         os.system('pip install', name)

    # def _pip3(self, name):
    #         os.system('pip3 install', name)

    # def _python3():
    #         os.system('python3.4 setup.py install', name, '--user')

    # def _python2():
    #         os.system('python2.7 setup.py install', name, '--user')

    # def _dpkg(self, name):
    #         os.system('sudo dpkg -i ', name)

    # def _normal(self, name):
    #         aptitude(hjson[name]['resource'])

    # def load(self, name):
    #     pass

def inst(app, fjson):
    global install_mode
    global install_dir

    print ("check for \"" + app + "\".")

    if app not in fjson:
        print("can't find \"", app, "\" in json file.")
        return

    if install_mode == 'signal':
        if os.environ["VBESUDO"] == '1':
            tmp = input("install to system or local?[Y/n]")
            if tmp == 'n':
                install_dir = 'local'
            else:
                install_dir = 'system'

            tmp = input("install follow app ALL same?[Y/n]")
            if tmp == 'y' or tmp == 'Y' or tmp == '':
                install_mode = 'all'

        else:
            install_mode = 'all'
            install_dir = 'local'
            print ("only support local install!")

    ins = Install(app, fjson, install_dir)

    try:
        ins.by()
        for i in ins.depend():
            if os.system("which " + i + " > /dev/null") == 0:
                continue
            inst(i, fjson)
    except:
        print ("can't install \"", app, "\", some depend failed to installed!")
        return

    try:
        print ("will install \"" + app + "\" into", install_dir + '.')
        ins.parpare()
        ins.install()
        ins.clean()
    except:
        print ("can't install \"", app, "\", failed!")
        return

def main():
    # os.makedirs(tmp_dir)

    file_in = open("a.json")
    fjson = json.loads(file_in.read())
    file_in.close()

    apps_list = sys.argv
    apps_list.pop(0)

    for i in apps_list:
        inst(i, fjson)
    # if name not in fjson:
    #     exit()

if __name__ == '__main__':
    main()

