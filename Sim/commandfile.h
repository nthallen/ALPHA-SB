#ifndef COMMANDFILE_H_INCLUDED
#define COMMANDFILE_H_INCLUDED
#include <list>
#include "dasio/cmd_reader.h"
#include "ode/ode.h"

class SCoPEx;

class variableDef {
  public:
    variableDef(dReal* ptr, const char *name);
    dReal *ptr;
    const char *name;
};

class commandFile : public DAS_IO::Cmd_reader {
  public:
    commandFile(SCoPEx *model);
    ~commandFile();
    void addVariable(dReal *ptr, const char *name);
  protected:
    bool app_input();
  private:
    SCoPEx *model;
    std::list<variableDef> vars;
    static const int IBUFLEN = 80;
    char command[IBUFLEN];
    char varname[IBUFLEN];
    double commandValue;
};

#endif
