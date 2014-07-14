#include <algorithm>
#include <cstdio>
#include <iostream>
#include <iterator>
#include <string>
#include <sstream>
#include <vector>

#include <Python.h>

#include "python/zdoom/zdtypes.h"
#include "python/zdoom/zdconsole.h"
#include "python/zdoom/zdmap.h"
#include "python/zdoom/zdactor.h"
#include "python/zdoom/zdplayer.h"
#include "python/zdoom/zdsector.h"
#include "python/zdoom/zdevents.h"

using std::cout;
using std::cerr;
using std::endl;
using std::string;
using std::vector;

// TODO (apaine): factor all of this out into a class; add_module takes too many
// arguments as it is, especially since they're mostly for maintaining state.

template <typename F, typename FS, typename M>
void add_module(const string& name, F initptr, FS& init_funcs, M& modules) {
  PyImport_AppendInittab(name.c_str(), initptr);
  init_funcs.push_back(initptr);
  modules.push_back(name);
}

/* ================= *
 * PUT MODULES HERE! *
 * ================= */
template <typename M, typename F>
void init_modules(M& modules, F& init_funcs) {
    add_module("zdtypes",   initzdtypes,    init_funcs, modules);
    add_module("zdconsole", initzdconsole,  init_funcs, modules);
    add_module("zdmap",     initzdmap,      init_funcs, modules);
    add_module("zdactor",   initzdactor,    init_funcs, modules);
    add_module("zdplayer",  initzdplayer,   init_funcs, modules);
    add_module("zdsector",  initzdsector,   init_funcs, modules);
    add_module("zdevents",  initzdevents,   init_funcs, modules);
}

template <typename T>
void run_init_funcs(const T& funcs) {
    for (typename T::const_iterator it = funcs.begin(); it != funcs.end(); it++) {
        (*it)();
    }
}

template <typename T>
string modules_list(const T& modules) {
    std::stringstream out;
    typename T::const_iterator last = modules.end() - 1;

    out << "[";
    std::copy(modules.begin(), last, std::ostream_iterator<string>(out,", "));
    out << *last << "]";

    return out.str();
}

void python_start() {
  cout << "[Python] Starting interpreter..." << endl;

  vector<string> modules;
  vector<void(*)()> init_funcs;

  init_modules(modules, init_funcs);
  Py_Initialize();
  run_init_funcs(init_funcs);

  cout << "[Python] Interpreter started, available modules: "
       << modules_list(modules) << endl;
}

void python_run_string(const char *command) {
  PyRun_SimpleString(command);
}

void python_run_file(FILE *fp, const char *filename) {
  PyRun_SimpleFile(fp, filename);
}

void python_import(const char *name) {
  PyImport_ImportModule(name);
}

void python_stop() {
  Py_Finalize();
  cout << "[Python] Shut down interpreter." << endl;
}
