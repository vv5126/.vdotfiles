#include <iostream>
#include<vector>
#include <map>
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
int optx = -1;

#define JOB_NUM 10

struct task {
    /* json *js_p; */
    /* json *last_js_p; */
    /* json js; */
    enum opt_type type;
    vector<string> obj;
    vector<string> array;
    int have_key;
    int have_array;
    int job_end;

    // 每个job中，通过obj array定位到指定操作点，kx只对obj有效(可以有多个), x只对array有效(可以有多个)。
    // 只要如下有一项不为空，即为当前job的终止符。
    map<string,string> ks;
    map<string,string> kb;
    map<string,int> ki;

    vector<string> s;
    vector<int> i;
    vector<string> b;
} job[JOB_NUM];

int job_cnt = 0;

json js;
string key_tmp = "";

string file = "";
int write_flag = 0;

int prefix_process(int argc, char *argv[])
{
    optind = 1;
    int file_flag = 0;

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
            optx = ADD;
        } else if (opt == 'D') {
            optx = DEL;
        } else if (opt == 'G') {
            optx = GET;
        } else if (opt == 'C') {
            optx = PUT;
        } else if (opt == 'f') {
            fstream fd;

            file = optarg;
            fd.open(file,ios::in|ios::out|ios::binary|ios::ate);
            if (fd) {
                int size = fd.tellg();
                char *buffer = new char[size];
                fd.seekg(0, ios::beg);
                fd.read(buffer, size);
                js = json::parse(buffer);
                free(buffer);
                fd.close();
            }
            file_flag = 1;
        }
    }

    if (file_flag == 0)
        return -1;

    if (optx == -1)
        optx = GET;

    /* opt_cnt = optind; */
    /* cout << "opt_cnt" << opt_cnt << endl; */

    optind = 1;

    while ((opt = getopt_long(argc, argv, optstring, long_options, &option_index)) != -1) {
        /* cout << "optind" << optind << endl; */
        if (opt == 'o') {
            if (job[job_cnt].job_end) job_cnt ++;

            job[job_cnt].obj.push_back(optarg);
            job[job_cnt].type = OBJECT;
        } else if (opt == 'a') {
            if (job[job_cnt].job_end) job_cnt ++;

            job[job_cnt].array.push_back(optarg);
            job[job_cnt].type = ARRAY;
            job[job_cnt].job_end = 1;
            job[job_cnt].have_array = 1;
        } else if (opt == 'k') { // k属于o, 但不会更新指针，且只含有一个值
            if (!key_tmp.empty()) {
                if (job[job_cnt].type == ARRAY)
                    job_cnt++;

                job[job_cnt].ks.insert(pair<string,string>(key_tmp, ""));
                job[job_cnt].have_key = 1;
                key_tmp = "";
            }
            key_tmp = string(optarg);
        } else if (opt == 's') {
            if (!key_tmp.empty()) {
                if (job[job_cnt].type == ARRAY)
                    job_cnt++;

                job[job_cnt].ks.insert(pair<string,string>(key_tmp, optarg));
                job[job_cnt].have_key = 1;
                key_tmp = "";
            } else {
                job[job_cnt].s.push_back(optarg);
            }
            job[job_cnt].job_end = 1;
        } else if (opt == 'i') {
            if (!key_tmp.empty()) {
                if (job[job_cnt].type == ARRAY)
                    job_cnt++;

                job[job_cnt].ki.insert(pair<string,int>(key_tmp, atoi(optarg)));
                job[job_cnt].have_key = 1;
                key_tmp = "";
            } else {
                job[job_cnt].i.push_back(atoi(optarg));
            }
            job[job_cnt].job_end = 1;
        } else if (opt == 'b') {
            if (!key_tmp.empty()) {
                if (job[job_cnt].type == ARRAY)
                    job_cnt++;

                job[job_cnt].kb.insert(pair<string,string>(key_tmp, optarg));
                job[job_cnt].have_key = 1;
                key_tmp = "";
            } else {
                job[job_cnt].b.push_back(optarg);
            }
            job[job_cnt].job_end = 1;
        }
    }

    if (!key_tmp.empty()) {
        if (job[job_cnt].type == OBJECT) {
            job[job_cnt].ks.insert(pair<string,string>(key_tmp, ""));
            job[job_cnt].have_key = 1;
        }
        if (job[job_cnt].type == ARRAY) {
            job[job_cnt].ks.insert(pair<string,string>(key_tmp, ""));
            job[job_cnt].have_key = 1;
        }
        job[job_cnt].job_end = 1;
    }

    return 0;
}

#if 0
void print_array(json *js_p_cur, vector<string>& array)
{
    for (auto tmp = (*js_p)[array[0]].begin(); tmp != (*js_p)[array[0]].end(); ++tmp) {
        cout << '"' << string(*tmp) << "\" ";
    }
}
#endif

json * xxx_obj(int job_index, json *js_p_cur)
{
    int empty = 0;

    if (job[job_index].job_end)
        return js_p_cur;

    if (job[job_index].ks.size() != 0) {
        for (map<string,string>::iterator it = job[job_index].ks.begin(); it != job[job_index].ks.end(); ++it) {
            /* cout << "it->first " << it->first << endl; */
            if (js_p_cur->find(it->first) != js_p_cur->end()) {
                /* cout << "get key " << it->first << " of " << std::string(js_p_cur->type_name()) << endl; */
                /* cout << string((*js_p_cur)[it->first].type_name()) << endl; */

                if ((*js_p_cur)[it->first].type() == json::value_t::object) {
                    for (json::iterator it1 = (*js_p_cur)[it->first].begin(); it1 != (*js_p_cur)[it->first].end(); ++it1) {
                        cout << '"' << it1.key() << "\" ";
                    }
                } else if ((*js_p_cur)[it->first].type() == json::value_t::array) {
                    for (auto tmp = (*js_p_cur)[it->first].begin(); tmp != (*js_p_cur)[it->first].end(); ++tmp) {
                        cout << '"' << string(*tmp) << "\" ";
                    }
                } else {
                    cout << (*js_p_cur)[it->first] << " ";
                }
            }
            empty = 1;
        }
    }

    if ((empty == 0) && (job_index == job_cnt)) {
        for (json::iterator it = (*js_p_cur).begin(); it != (*js_p_cur).end(); ++it) {
            cout << '"' << it.key() << "\" ";
        }
        empty = 1;
    }

    if (empty)
        job[job_index].job_end = 1;

    return js_p_cur;
}


int process(void)
{
    int job_done = 0;
    int tmp_i;

    json *js_p = &js;
    json * last_js_p = js_p;

    /* cout << "job_cnt " << job_cnt << endl; */
    /* cout << "optx " << optx << endl; */

    if (optx == ADD) {
        write_flag = 1;
        for (int i = 0; i < job_cnt+1; ++i) {
            /* cout << "job_cnt i = " << i << endl; */
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
    } else if (optx == DEL) {
        write_flag = 1;
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

    } else if (optx == PUT) { // only support modified key's value.
        write_flag = 1;
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

    } else if (optx == GET) {
        string tmp;
        /* job_done = 0; */
        int i;

        for (i = 0; i < job_cnt+1; ++i) {
            /* cout << "job_cnt i = " << i << endl; */
            for (int j = 0; j < job[i].obj.size(); ++j) {
                if (js_p->find(job[i].obj[j]) == js_p->end()) {
                    /* job_done = 1; */
                    job[i].job_end = 1;
                    break;
                } else {
                    if ((*js_p)[job[i].obj[j]].type() == json::value_t::object) {
                        last_js_p = js_p;
                        js_p = &(*js_p)[job[i].obj[j]];
                        tmp = job[i].obj[j];
                    } else {
                        /* job_done = 1; */
                        job[i].job_end = 1;
                        break;
                    }
                }
            }

            /* cout << "type_name " << std::string(js_p->type_name()) << '\n'; */
            /* cout << "size " << job[i].array.size() << endl; */

            if (job[i].job_end) continue;

            if ((job[i].type == OBJECT) && (js_p->type() == json::value_t::object)) {
                js_p = xxx_obj(i, js_p);
            } else if ((job[i].type == ARRAY) && (js_p->type() == json::value_t::array)) {
                /* js_p = xxx_obj(i, js_p); */
                int empty = 0;

                if (!job[i].array.empty()) {
                    if (js_p->find(job[i].array[0]) == js_p->end()) {
                        int array_cnt = atoi(job[i].array[0].c_str());
                        if (array_cnt < js_p->size())
                            js_p = &(*js_p)[array_cnt];
                        /* cout << job[i].array[0] << (*js_p)[array_cnt] << endl; */
                        else
                            continue;
                    }

                    if (js_p->type() == json::value_t::array) {
                        /* js_p = xxx_obj(i, js_p); */
                    } else if (js_p->type() == json::value_t::object) {
                        js_p = xxx_obj(i, js_p);
                    }

                    if ((*js_p)[job[i].array[0]].type() == json::value_t::array) {
                        /* cout << (*js_p)[job[i].array[0]] << endl; */
                        for (auto tmp = (*js_p)[job[i].array[0]].begin(); tmp != (*js_p)[job[i].array[0]].end(); ++tmp) {
                            cout << '"' << string(*tmp) << "\" ";
                        }
                        cout << "" << endl;
                    } else if ((*js_p)[job[i].array[0]].type() == json::value_t::object) {
                        for (auto tmp = (*js_p)[job[i].array[0]].begin(); tmp != (*js_p)[job[i].array[0]].end(); ++tmp) {
                            if ((*tmp).type() == json::value_t::object) {
                                for (auto aaa = (*tmp).begin(); aaa != (*tmp).end(); ++aaa)
                                    cout << '"' << string(*aaa) << "\" ";
                            } else if ((*tmp).type() == json::value_t::array) {
                                cout << '"' << string(*tmp) << "\" ";
                            }
                        }
                        cout << "" << endl;
                        /* job_done = 1; */
                        job[i].job_end = 1;
                    } else {
                        continue;
                    }
                }

                if (empty == 0) {
                    for (auto tmp = (*js_p).begin(); tmp != (*js_p).end(); ++tmp) {
                        /* cout << (*js_p)[2] << ; */
                        if ((*tmp).type() == json::value_t::object)
                            /* cout << " \1 " << (*tmp).first() << endl; */
                            /* for (json::iterator it = (*tmp).begin(); it != (*tmp).end(); ++it) { */
                            /*     cout << '"' << it.key() << "\" "; */
                            /* } */
                        cout << '"' << string(*tmp) << "\" ";
                    }
                }
                cout << "" << endl;

                /* job_done = 1; */
                    job[i].job_end = 1;
            }
        }
#if 0
        if (job[i].job_end == 0) {
            if (js_p->type() == json::value_t::object) {
                for (json::iterator it = js_p->begin(); it != js_p->end(); ++it) {
                    cout << '"' << it.key() << "\" ";
                }
                cout << "" << endl;
            }
        }
#endif
        if (i > 0 && job[i-1].job_end)
            cout << "" << endl;
    }
}

void ShowVec(const vector<string>& valList)
{
    for (auto iter = valList.cbegin(); iter != valList.cend(); iter++)
    {
        cout << "  " << (*iter) << endl;
    }
}

void ShowVec1(const vector<int>& valList)
{
    for (auto iter = valList.cbegin(); iter != valList.cend(); iter++)
    {
        cout << "  " << (*iter) << endl;
    }
}

void debug(void)
{
    for (int i = 0; i < JOB_NUM; ++i) {
        if (job[i].type != EMPTY) {
            if (optx == ADD)
                printf("\033[33m ADD\033[0m");
            else if (optx == DEL)
                printf("\033[33m DEL\033[0m");
            else if (optx == GET)
                printf("\033[33m GET\033[0m");
            else if (optx == PUT)
                printf("\033[33m PUT\033[0m");

            if (job[i].type == OBJECT)
                printf("\033[33m OBJECT\033[0m\n");
            else if (job[i].type == ARRAY)
                printf("\033[33m ARRAY\033[0m\n");

            printf("\033[33m job[i].have_key = %d | job[i].job_end = %d | job[i].have_array = %d |\033[0m\n", job[i].have_key, job[i].job_end, job[i].have_array);

            if (!job[i].obj.empty()) {
                cout << "obj" << endl;
                ShowVec(job[i].obj);
            }

            if (!job[i].array.empty()) {
                cout << "array" << endl;
                ShowVec(job[i].array);
            }

            if (!job[i].s.empty()) {
                cout << "s" << endl;
                ShowVec(job[i].s);
            }

            if (!job[i].b.empty()) {
                cout << "b" << endl;
                ShowVec(job[i].b);
            }

            if (!job[i].i.empty()) {
                cout << "i" << endl;
                ShowVec1(job[i].i);
            }

            for (map<string,string>::iterator it = job[i].ks.begin(); it != job[i].ks.end(); ++it) {
                cout << "ks:\n  " << it->first << ": " << it->second << endl;
            }

            for (map<string,string>::iterator it = job[i].kb.begin(); it != job[i].kb.end(); ++it) {
                cout << "kb:\n  " << it->first << ": " << it->second << endl;
            }

            for (map<string,int>::iterator it = job[i].ki.begin(); it != job[i].ki.end(); ++it) {
                cout << "ki:\n  " << it->first << ": " << it->second << endl;
            }
        cout << "-------------" << endl;
        }
    }
}

int main(int argc, char *argv[])
{
    job_cnt = 0;
    for (int i = 0; i < JOB_NUM; ++i) {
        job[i].type = EMPTY;
        job[i].have_key = 0;
        job[i].have_array = 0;
        job[i].job_end = 0;
    }

    prefix_process(argc, argv);
    /* debug(); */

    for (int i = 0; i < JOB_NUM; ++i)
        job[i].job_end = 0;

    process();

    /* testGetOptLong(argc, argv); */
    /* cout << js.dump(3) << endl; */
    /* cout << js_opt->dump(3) << endl; */

    if (write_flag) {
        ofstream out;
        out.open(file,ios::in|ios::out|ios::binary|ios::trunc);
        out << js.dump(4);
        out << '\n';
        out.close();
    }

    return 0;
}
