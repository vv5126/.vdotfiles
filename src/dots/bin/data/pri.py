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
