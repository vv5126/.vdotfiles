#!/usr/bin/env python3

import os

def scp(url, dst):
    os.system('scp -r ' + url + dst)

def wget(url, dst):
    os.system('wget ' + url + ' -O '+ dst)

def git(url, dst = ''):
    if url[0:4] == 'http':
        os.system('git clone ' + url + ' ' + dst)
    else:
        os.system('git clone https://github.com/' + url + ' ' + dst)

