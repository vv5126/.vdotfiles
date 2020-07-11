#include <iostream>
#include<vector>
#include<string>
#include <fstream>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <getopt.h>
#include "json.hpp"

/* 递归操作，只能一条线 */
/* 不支持修改已有结构，这应该不是此工具该有的行为，结构必须由用户指定，并不可再随意修改。 */
/* 不支持对象数组, 会导致对象没有标签 */

/* 结构级别：数组，对象 */
/* 数据级别：布尔，字符串，整型，键值对 */

/* 布尔，字符串，整型 只能更新于数组上 */
/* 键值对 只能更新于对象上 */

using namespace std;
using json = nlohmann::json;

enum opt_state {ADD, DEL, GET, PUT};
enum opt_type {EMPTY, ARRAY, OBJECT};

struct {
    int opt;
    string file;

    /* vector<string> obj; */

    /* vector<string> str; */
    /* vector<string> array; */
    /* vector<string> key; */
    /* vector<string> value; */
    /* vector<string> i; */
    /* vector<string> b; */
} ctx;

struct task {
    /* json *js_p; */
    /* json *last_js_p; */
    /* json js; */
    vector<string> obj;
    vector<string> array;
    int have_key;
    int have_array;

    map<string,string> ks;
    map<string,string> kb;
    map<string,int> ki;

    vector<string> s;
    vector<int> i;
    vector<string> b;

    /* vector<string> key; */
    /* vector<string> value; */

    /* vector<string> array; */
} job[10];

int job_cnt = 0;
int job_end = 0;
int job_in = EMPTY;

json js;
string key_tmp = "";

int write_flag = 0;

/* json *job_js_p; */
/* json *js_opt = &js; */
/* json *last_opt = js_opt; */
/* int cur_type; */

#if 0
void reset_cur_obj(void)
{
    if ((js_opt->type() != json::value_t::object) && (js_opt->type() != json::value_t::null))
        js_opt = last_opt;
}
#endif

int prefix_process(int argc, char *argv[])
{
    optind = 1;
    int file_flag = 0, opt_flag = 0; // , opt_cnt = 0;

    int opt, option_index = 0;
    const char *optstring = "f:b:i:s:k:v:a:o:";

    static struct option long_options[] = {
        {"add", no_argument, NULL, 'A'},
        {"del",  no_argument, NULL, 'D'},
        {"change", no_argument, NULL, 'C'},
        {"get", no_argument, NULL, 'G'},
        {0, 0, 0, 0}  // 添加 {0, 0, 0, 0} 是为了防止输入空值
    };

    while ((opt = getopt_long(argc, argv, optstring, long_options, &option_index)) != -1) {
        if (opt == 'A') {
            ctx.opt = ADD;
            opt_flag = 1;
        } else if (opt == 'D') {
            ctx.opt = DEL;
            opt_flag = 1;
        } else if (opt == 'G') {
            ctx.opt = GET;
            opt_flag = 1;
        } else if (opt == 'C') {
            ctx.opt = PUT;
            opt_flag = 1;
        } else if (opt == 'f') {
            char *buffer;
            fstream fd;

            fd.open(optarg,ios::in|ios::out|ios::binary|ios::ate);
            int size = fd.tellg();
            fd.seekg(0, ios::beg);
            buffer = new char[size];
            fd.read(buffer, size);
            js = json::parse(buffer);
            free(buffer);
            fd.close();
            file_flag = 1;
        }
    }

    if (file_flag == 0)
        return -1;

    if (opt_flag == 0)
        ctx.opt = GET;

    /* opt_cnt = optind; */
    /* cout << "opt_cnt" << opt_cnt << endl; */

    optind = 1;

    while ((opt = getopt_long(argc, argv, optstring, long_options, &option_index)) != -1) {
        /* cout << "optind" << optind << endl; */

#if 0
        switch(opt) {
            case 'o':
            case 'a':
                if (job_end) {
                    job_cnt ++;
                    job_end = 0;
                }
                job[job_cnt].have_key = 0;
                if (opt == 'o')
                    job[job_cnt].obj.push_back(optarg);
                else if (opt == 'a')
                    job[job_cnt].array.push_back(optarg);
                job_in = (opt == 'o') ? OBJECT : ARRAY;
                break;
            case 'i':
            case 'b':
            case 's':
                if (!key_tmp.empty()) {
                    if (job_in == ARRAY)
                        job_cnt++;

                    if (opt == 's')
                        job[job_cnt].ks.insert(pair<string,string>(key_tmp, optarg));
                    else if (opt == 'i')
                        job[job_cnt].ki.insert(pair<string,int>(key_tmp, atoi(optarg)));
                    else if (opt == 'b')
                        job[job_cnt].kb.insert(pair<string,string>(key_tmp, optarg));

                    job[job_cnt].have_key = 1;
                    key_tmp = "";
                } else {
                    if (opt == 's')
                        job[job_cnt].s.push_back(optarg);
                    else if (opt == 'i')
                        job[job_cnt].i.push_back(atoi(optarg));
                    else if (opt == 'b')
                        job[job_cnt].b.push_back(optarg);
                }
                job_end = 1;
                break;
            case 'k':
                key_tmp = string(optarg);
                break;
            default:
                break;
        }
#else
        if (opt == 'o') {
            if (job_end) {
                job_cnt ++;
                job_end = 0;
            }
            job[job_cnt].have_key = 0;
            job[job_cnt].obj.push_back(optarg);
            job_in = OBJECT;
        } else if (opt == 'a') {
            if (job_end) {
                job_cnt ++;
                job_end = 0;
            }

            job_end = 1;
            job[job_cnt].have_key = 0;
            job[job_cnt].have_array = 1;
            job[job_cnt].array.push_back(optarg);
            job_in = ARRAY;
        } else if (opt == 'k') { // k属于o, 但不会更新指针，且只含有一个值
            if (!key_tmp.empty()) {
                if (job_in == ARRAY)
                    job_cnt++;

                job[job_cnt].ks.insert(pair<string,string>(key_tmp, ""));
                job[job_cnt].have_key = 1;
                key_tmp = "";
            }
            key_tmp = string(optarg);
        } else if (opt == 's') {
            if (!key_tmp.empty()) {
                if (job_in == ARRAY)
                    job_cnt++;

                job[job_cnt].ks.insert(pair<string,string>(key_tmp, optarg));
                job[job_cnt].have_key = 1;
                key_tmp = "";
            } else {
                job[job_cnt].s.push_back(optarg);
            }
            job_end = 1;
        } else if (opt == 'i') {
            if (!key_tmp.empty()) {
                if (job_in == ARRAY)
                    job_cnt++;

                job[job_cnt].ki.insert(pair<string,int>(key_tmp, atoi(optarg)));
                job[job_cnt].have_key = 1;
                key_tmp = "";
            } else {
                job[job_cnt].i.push_back(atoi(optarg));
            }
            job_end = 1;
        } else if (opt == 'b') {
            if (!key_tmp.empty()) {
                if (job_in == ARRAY)
                    job_cnt++;

                job[job_cnt].kb.insert(pair<string,string>(key_tmp, optarg));
                job[job_cnt].have_key = 1;
                key_tmp = "";
            } else {
                /* if (string(optarg) == "true") */
                job[job_cnt].b.push_back(optarg);
            }
            job_end = 1;
        }
#endif
    }

    if (!key_tmp.empty()) {
        if (job_in == OBJECT) {
            job[job_cnt].ks.insert(pair<string,string>(key_tmp, ""));
            job[job_cnt].have_key = 1;
        }
    }

    return 0;
}

#if 0
int testGetOptLong(int argc, char *argv[])
{
    int opt; // getopt_long() 的返回值
    int digit_optind = 0; // 设置短参数类型及是否需要参数

    int option_index = 0;
    const char *optstring = "f:b:i:s:k:v:a:o:";

    static struct option long_options[] = {
        {"add", no_argument, NULL, 'A'},
        {"del",  no_argument, NULL, 'D'},
        {"change", no_argument, NULL, 'C'},
        {"get", no_argument, NULL, 'G'},
        {0, 0, 0, 0}  // 添加 {0, 0, 0, 0} 是为了防止输入空值
    };

    while ((opt = getopt_long(argc, argv, optstring, long_options, &option_index)) != -1) {
        if (opt == 'A') {
            ctx.opt = ADD;
        } else if (opt == 'D') {
            ctx.opt = DEL;
        } else if (opt == 'G') {
            ctx.opt = GET;
        } else if (opt == 'C') {
            ctx.opt = PUT;
        }

        if (opt == 'f') {
            char *buffer;
            fstream fd;

            fd.open(optarg,ios::in|ios::out|ios::binary|ios::ate);
            int size = fd.tellg();
            fd.seekg(0, ios::beg);
            /* cout << "size = " << size << endl; */
            buffer = new char[size];
            fd.read(buffer, size);
            /* cout << buffer << endl; */
            js = json::parse(buffer);
            free(buffer);
            fd.close();
        } else if (opt == 'o') {
            reset_cur_obj();

            cout << "opt type_name1 = "<< std::string(js_opt->type_name()) << '\n';
            cout << "last_opt type_name = "<< std::string(last_opt->type_name()) << '\n';
            if (ctx.opt == DEL) {
                    cout << "haha" << endl;
                    last_opt->erase(optarg);
            cout << "del obj " << optarg << endl;
            } else {
            if (js_opt->find(optarg) == js_opt->end()) {
                last_opt = js_opt;
                if (ctx.opt != DEL) {
                    (*js_opt)[optarg] = {};
                }
            }
            js_opt = &(*js_opt)[optarg];
            cout << "add obj " << optarg << endl;
            }
            /* key_tmp = string(optarg); ??? */
        } else if (opt == 'k') { // k属于o, 但不会更新指针，且只含有一个值
            if (!key_tmp.empty() && (ctx.opt == DEL)) {
                /* (*js_opt)[key_tmp] = optarg; */
            }
            key_tmp = string(optarg);
        } else if (opt == 's') {
            cout << "type_name = "<< std::string(js_opt->type_name()) << '\n';
            if (ctx.opt == DEL) {
                if (!key_tmp.empty()) {
                    reset_cur_obj();
                    js_opt->erase(key_tmp);
                    key_tmp = "";
                } else {
                    js_opt->erase(optarg);
                }
            } else {

            if (!key_tmp.empty()) {
                reset_cur_obj();

                (*js_opt)[key_tmp] = optarg;
                key_tmp = "";
            } else {
                js_opt->push_back(optarg);
            }
            }

            cout << "add string " << optarg << endl;
        } else if (opt == 'i') {
            if (!key_tmp.empty()) {
                reset_cur_obj();
                (*js_opt)[key_tmp] = atoi(optarg);
                key_tmp = "";
            } else {
                js_opt->push_back(atoi(optarg));
            }
            cout << "add int " << optarg << endl;
        } else if (opt == 'b') {
            if (!key_tmp.empty()) {
                reset_cur_obj();
                if (string(optarg) == "true")
                    (*js_opt)[key_tmp] = true;
                else
                    (*js_opt)[key_tmp] = false;
                key_tmp = "";
            } else {
                if (string(optarg) == "true")
                    js_opt->push_back(true);
                else
                    js_opt->push_back(false);
            }
            cout << "add bool " << optarg << endl;
        }
    }

    return 0;
}

json * get_obj_ptr(vertcor<string> &obj)
{

}
#endif


int process(void)
{
    int job_done = 0;
    int tmp_i;

    json *js_p = &js;
    json * last_js_p = js_p;

    /* cout << "job_cnt " << job_cnt << endl; */
    /* cout << "ctx.opt " << ctx.opt << endl; */

    if (ctx.opt == ADD) {
        write_flag = 1;
        for (int i = 0; i < job_cnt+1; ++i) {
            cout << "job_cnt i = " << i << endl;
            for (int j = 0; j < job[i].obj.size(); ++j) {
                if (js_p->find(job[i].obj[j]) == js_p->end()) {
                    (*js_p)[job[i].obj[j]] = {};
                    cout << "add obj " << job[i].obj[j] << endl;
                }
                js_p = &(*js_p)[job[i].obj[j]];
                last_js_p = js_p;
            }

            if (job[i].have_key != 0) { // object job.
                for (map<string,string>::iterator it = job[i].ks.begin(); it != job[i].ks.end(); ++it) {
                    cout << "have string " << it->first << it->second << endl;
                    (*js_p)[it->first] = it->second;
                }

                for (map<string,int>::iterator it = job[i].ki.begin(); it != job[i].ki.end(); ++it) {
                    cout << "have int " << it->first << it->second << endl;
                    (*js_p)[it->first] = it->second;
                }

                for (map<string,string>::iterator it = job[i].kb.begin(); it != job[i].kb.end(); ++it) {
                    cout << "have bool " << it->first << it->second << endl;
                    if (string(it->second) == "true")
                        (*js_p)[it->first] = true;
                    else
                        (*js_p)[it->first] = false;
                }

            } else { // array job.
                if (!job[i].array.empty()) {
                    if (js_p->find(job[i].array[0]) == js_p->end()) {
                        (*js_p)[job[i].array[0]] = {};
                        cout << "add array " << job[i].array[0] << endl;
                    }
                    js_p = &(*js_p)[job[i].array[0]];
                }

                /* cout << "type_name " << std::string(js_p->type_name()) << '\n'; */
                /* cout << "sdf" << std::string(js_p->type_name()) << '\n'; */
                /* cout << "size " << job[i].obj.size() << endl; */

                for (vector<string>::iterator it = job[i].s.begin(); it != job[i].s.end(); ++it) {
                    cout << "have string " << *it << endl;
                    js_p->push_back(string(*it));
                }

                for (vector<int>::iterator it = job[i].i.begin(); it != job[i].i.end(); ++it) {
                    cout << "have int " << *it << endl;
                    js_p->push_back(*it);
                }

                for (vector<string>::iterator it = job[i].b.begin(); it != job[i].b.end(); ++it) {
                    cout << "have bool " << *it << endl;
                    js_p->push_back((string(*it) == "true") ? true : false);
                }
            }
            js_p = last_js_p;
        }
    } else if (ctx.opt == DEL) {
        write_flag = 1;
        string tmp;
        job_done = 0;
        for (int i = 0; i < job_cnt+1; ++i) {
            cout << "job_cnt i = " << i << endl;
            for (int j = 0; j < job[i].obj.size(); ++j) {
                if (js_p->find(job[i].obj[j]) == js_p->end()) {
                    job_done = 1;
                    break;
                } else {
                    if ((*js_p)[job[i].obj[j]].type() == json::value_t::object) {
                        last_js_p = js_p;
                        js_p = &(*js_p)[job[i].obj[j]];
                        tmp = job[i].obj[j];
                    } else {
                        job_done = 1;
                        break;
                    }
                }
            }

            if (job_done) continue;

            if (job[i].have_key != 0) { // object job.
                for (map<string,string>::iterator it = job[i].ks.begin(); it != job[i].ks.end(); ++it) {
                    if (js_p->find(it->first) != js_p->end()) {
                        cout << "rm key " << it->first << " of " << std::string(js_p->type_name()) << endl;
                        js_p->erase(it->first);
                    }
                }

                for (map<string,int>::iterator it = job[i].ki.begin(); it != job[i].ki.end(); ++it) {
                    if (js_p->find(it->first) != js_p->end()) {
                        cout << "rm key " << it->first << " of " << std::string(js_p->type_name()) << endl;
                        js_p->erase(it->first);
                    }
                }

                for (map<string,string>::iterator it = job[i].kb.begin(); it != job[i].kb.end(); ++it) {
                    if (js_p->find(it->first) != js_p->end()) {
                        cout << "rm key " << it->first << " of " << std::string(js_p->type_name()) << endl;
                        js_p->erase(it->first);
                    }
                }

            } else if (job[i].have_array != 0) { // array job.
                if (!job[i].array.empty()) {
                    if (js_p->find(job[i].array[0]) == js_p->end()) {
                        continue;
                    }
                    if ((*js_p)[job[i].array[0]].type() == json::value_t::array) {
                        last_js_p = js_p;
                        js_p = &(*js_p)[job[i].array[0]];
                        tmp = job[i].array[0];
                    } else {
                        continue;
                    }
                }

                for (vector<string>::iterator it = job[i].s.begin(); it != job[i].s.end(); ++it) {
                    cout << "have string " << *it << endl;
                    for (tmp_i = 0; tmp_i < (*js_p).size(); ++tmp_i) {
                        if ((*js_p)[tmp_i] == *it)
                            break;
                    }
                    /* remove(js_p->begin(), js_p->end(),i); */
                    js_p->erase(tmp_i);
                    job_done = 1;
                }

                for (vector<int>::iterator it = job[i].i.begin(); it != job[i].i.end(); ++it) {
                    cout << "have int " << *it << endl;
                    for (tmp_i = 0; tmp_i < (*js_p).size(); ++tmp_i) {
                        if ((*js_p)[tmp_i] == *it)
                            break;
                    }
                    /* remove(js_p->begin(), js_p->end(),i); */
                    js_p->erase(tmp_i);
                    job_done = 1;
                }

                for (vector<string>::iterator it = job[i].b.begin(); it != job[i].b.end(); ++it) {
                    cout << "have bool " << *it << endl;
                    for (tmp_i = 0; tmp_i < (*js_p).size(); ++tmp_i) {
                        if ((*js_p)[tmp_i] == *it)
                            break;
                    }
                    /* remove(js_p->begin(), js_p->end(),i); */
                    js_p->erase(tmp_i);
                    job_done = 1;
                }

                if (job_done == 0) {
                    cout << "rm array " << tmp << " of " << std::string(last_js_p->type_name()) << endl;
                    last_js_p->erase(tmp);
                }

            } else {
                if (job_done == 0) {
                    cout << "rm obj " << tmp << " of " << std::string(last_js_p->type_name()) << endl;
                    last_js_p->erase(tmp);
                }
            }
            js_p = last_js_p;
        }

    } else if (ctx.opt == PUT) { // only support modified key's value.
        write_flag = 1;
        string tmp;
        job_done = 0;
        for (int i = 0; i < job_cnt+1; ++i) {
            cout << "job_cnt i = " << i << endl;
            for (int j = 0; j < job[i].obj.size(); ++j) {
                if (js_p->find(job[i].obj[j]) == js_p->end()) {
                    job_done = 1;
                    break;
                } else {
                    if ((*js_p)[job[i].obj[j]].type() == json::value_t::object) {
                        last_js_p = js_p;
                        js_p = &(*js_p)[job[i].obj[j]];
                        tmp = job[i].obj[j];
                    } else {
                        job_done = 1;
                        break;
                    }
                }
            }

            if (job_done) continue;

            if (job[i].have_key != 0) { // object job.
                for (map<string,string>::iterator it = job[i].ks.begin(); it != job[i].ks.end(); ++it) {
                    cout << "change string " << it->first << it->second << endl;
                    (*js_p)[it->first] = it->second;
                }

                for (map<string,int>::iterator it = job[i].ki.begin(); it != job[i].ki.end(); ++it) {
                    cout << "change int " << it->first << it->second << endl;
                    (*js_p)[it->first] = it->second;
                }

                for (map<string,string>::iterator it = job[i].kb.begin(); it != job[i].kb.end(); ++it) {
                    cout << "change bool " << it->first << it->second << endl;
                    (*js_p)[it->first] = (string(it->second) == "true") ? true : false;
                }
            }
            js_p = last_js_p;
        }

    } else if (ctx.opt == GET) {
        string tmp;
        job_done = 0;
        for (int i = 0; i < job_cnt+1; ++i) {
            /* cout << "job_cnt i = " << i << endl; */
            for (int j = 0; j < job[i].obj.size(); ++j) {
                if (js_p->find(job[i].obj[j]) == js_p->end()) {
                    job_done = 1;
                    break;
                } else {
                    if ((*js_p)[job[i].obj[j]].type() == json::value_t::object) {
                        last_js_p = js_p;
                        js_p = &(*js_p)[job[i].obj[j]];
                        tmp = job[i].obj[j];
                    } else {
                        job_done = 1;
                        break;
                    }
                }
            }

            if (job_done) continue;

            if (job[i].have_key != 0) { // object job.
                for (map<string,string>::iterator it = job[i].ks.begin(); it != job[i].ks.end(); ++it) {
                    if (js_p->find(it->first) != js_p->end()) {
                        cout << "get key " << it->first << " of " << std::string(js_p->type_name()) << endl;
                        cout << (*js_p)[it->first] << endl;
                    }
                }

            } else if (job[i].have_array != 0) { // array job.
                cout << 1 << endl;
                if (!job[i].array.empty()) {
                    if (js_p->find(job[i].array[0]) == js_p->end()) {
                        continue;
                    }
                    if ((*js_p)[job[i].array[0]].type() == json::value_t::array) {
                        cout << (*js_p)[job[i].array[0]] << endl;
                    } else {
                        continue;
                    }
                }
            }
            js_p = last_js_p;
        }
    }
}

int main(int argc, char *argv[])
{
    prefix_process(argc, argv);
    process();

    /* testGetOptLong(argc, argv); */
    /* cout << js.dump(3) << endl; */
    /* cout << js_opt->dump(3) << endl; */

    if (write_flag) {
        ofstream out;
        out.open("out.txt",ios::in|ios::out|ios::binary|ios::trunc);
        out << js.dump(4);
        out.close();
    }

    return 0;
}
