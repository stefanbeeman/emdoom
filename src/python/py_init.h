void python_start();
void python_run_string(const char *command);
void python_run_file(FILE *fp, const char *filename);
void python_import(const char *name);
void python_stop();
