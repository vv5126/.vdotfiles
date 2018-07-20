#!/usr/bin/env python
# coding=utf-8

import pyperclip
from pykeyboard import PyKeyboard

def kb_unicode(unicode_str):
    k = PyKeyboard()
    for unicode_char in unicode_str:
        k.press_key(k.control_l_key)
        k.press_key(k.shift_l_key)
        k.press_key('u')
        k.release_key(k.control_l_key)
        k.release_key(k.shift_l_key)
        k.release_key('u')
        k.type_string(hex(ord(unicode_char))[2:])
        k.press_key(k.control_l_key)
        k.press_key(k.shift_l_key)
        k.release_key(k.control_l_key)
        k.release_key(k.shift_l_key)
    return

def clip_copy(msg):
    pyperclip.copy(msg)

def clip_paste(msg):
    k = PyKeyboard()
    k.press_key(k.control_l_key)
    k.press_key('v')
    k.release_key('v')
    k.release_key(k.control_l_key)
