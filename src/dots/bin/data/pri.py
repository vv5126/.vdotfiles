#!/usr/bin/env python3

def select_list(list2, str1):
    list1 = range(1,len(list2) + 1)
    dict1 = dict(zip(list1,list2))
    print (dict1)

    while True:
        for i in dict1:
            print ("\033[5;32;40m", i,":\033[5;33;40m", dict1[i], "\033[0m")

        result = input('\n' + str1)

        if result.isdigit() == True:
            if int(result) in list1:
                return dict1[int(result)]
            elif result in list2:
                return result

# color print
#显示方式: 0（默认值）、1（高亮）、22（非粗体）、4（下划线）、24（非下划线）、 5（闪烁）、25（非闪烁）、7（反显）、27（非反显）
#前景色: 30（黑色）、31（红色）、32（绿色）、 33（黄色）、34（蓝色）、35（洋 红）、36（青色）、37（白色）
#背景色: 40（黑色）、41（红色）、42（绿色）、 43（黄色）、44（蓝色）、45（洋 红）、46（青色）、47（白色）
def cprint(color, *args):
    tmp = ''
    disp_method = ['0;', '1;', '22;', '4;', '24;', '5;', '25;', '7;', '27;']
    fc          = ['30;', '31;', '32;', '33;', '34;', '35;', '36;', '37;']
    bc          = ['40m', '41m', '42m', '43m', '44m', '45m', '46m', '47m']

    if len(color) > 2:
        tmp = tmp + disp_method[int(color[-3:-2])]
    if len(color) > 1:
        tmp = tmp + fc[int(color[-2:-1])]
    if len(color) > 0:
        tmp = tmp + bc[int(color[-1:])]

    print("\033[" + tmp  + " ".join(args) + "\033[0m")
