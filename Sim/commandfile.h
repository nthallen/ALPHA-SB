#ifndef COMMANDFILE_H_INCLUDED
#define COMMANDFILE_H_INCLUDED
#include <list>
#include <stdio.h>
#include "ode/ode.h"

class variableDef {
  public:
    variableDef(dReal* ptr, const char *name);
    dReal *ptr;
    const char *name;
};

class commandFile {
  public:
    commandFile(const char *filename);
    ~commandFile();
    void addVariable(dReal *ptr, const char *name);
    double eval();
  private:
    std::list<variableDef> vars;
    FILE *ifp;
    static const int IBUFLEN = 80;
    char ibuf[IBUFLEN];
    char command[IBUFLEN];
    char varname[IBUFLEN];
    double commandValue;
    int lineNumber;
    const char *cmdfilename;
};

#endif
