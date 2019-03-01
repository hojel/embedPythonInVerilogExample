#include <Python.h>
#include "vpi_user.h"

extern int sv_write();

static PyObject * c_write(PyObject *self, PyObject *args) {
  int address,data;
  if(!PyArg_ParseTuple(args, "ii", &data, &address))
    return NULL;
  (void)sv_write(address,data);
  return Py_BuildValue("");  
}

static PyMethodDef EmbMethods[] = {
  {"c_write",c_write, METH_VARARGS,"c_write(data,address)"},
  {NULL, NULL, 0, NULL}
};

int startPython() {
    Py_Initialize();
    Py_InitModule("emb", EmbMethods);
    PyRun_SimpleString("import emb\n"
		       "emb.c_write(0,1)\n");
    Py_Finalize();
    return 0;
}
