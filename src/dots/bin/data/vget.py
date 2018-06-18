#!/usr/bin/env python3

import os

def scp(self, url, dst):
    os.system('scp -r ' + url + dst)

def wget(self, url, dst):
    os.system('wget ' + url + ' -O '+ dst)

def git(self, url, dst = ''):
    if url[0:4] == 'http':
        os.system('git clone ' + url + ' ' + dst)
    else:
        os.system('git clone https://github.com/' + url + ' ' + dst)

