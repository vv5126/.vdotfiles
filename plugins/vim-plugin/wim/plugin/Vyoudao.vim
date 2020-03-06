" Author: GW

vnoremap <silent> <leader>t :call Vyoudao()<CR>

function! GetVisualSelection()
	let save_clipboard = &clipboard
	set clipboard= " Avoid clobbering the selection and clipboard registers. 
	let save_reg = getreg('"')
	let save_regmode = getregtype('"')
	silent normal! gvy
	let res = getreg('"')
	call setreg('"', save_reg, save_regmode)
	let &clipboard = save_clipboard
	return res
endfunction

function! Vyoudao() range
    let word = GetVisualSelection()
python << EOF
#-*-coding:utf-8-*- 
import json, vim
from urllib import request, parse
import socket

youdao_key = 'keyfrom=wufeifei&key=716426270'
# youdao_key = 'keyfrom=yakiang&key=1402135116'
# youdao_key = 'keyfrom=mlovez-dev&key=1341364669'
youdao_url_json = "http://fanyi.youdao.com/openapi.do?"+youdao_key+"&type=data&doctype=json&version=1.1&"
# youdao_url_json = "http://openapi.youdao.com/api?q=good&from=EN&to=zh_CHS&"+youdao_key+""appKey=ff889495-4b45-46d9-8f48-946554334f2a&salt=2&sign=1995882C5064805BC30A39829B779D7B

final_word = '%s'%vim.eval('word')
final_word = final_word.replace('\n', ' ')
final_word = final_word.replace('#', ' ')
final_word = final_word.replace('*', ' ')
final_word = final_word.replace('_', ' ')

socket.setdefaulttimeout(2)
response =request.urlopen(youdao_url_json+parse.urlencode({'q':final_word}))
jsonObj =json.loads(response.read().decode('utf-8'))
if jsonObj !=None and 'errorCode' in jsonObj and jsonObj['errorCode'] ==0 :
    if 'translation' in jsonObj :
        for t in jsonObj['translation'] :
            print("\"" +t+ "\"" + '\n')
EOF
endfunction
