/* commandfile.cpp */
#include <strings.h>
#include "commandfile.h"
#include "nl.h"
#include "nl_assert.h"

variableDef::variableDef(dReal* ptr, const char *name) {
  this->ptr = ptr;
  this->name = name;
}

commandFile::commandFile(const char *filename) {
  nl_assert(filename != 0);
  ifp = fopen(filename, "r");
  if (ifp == 0) {
    msg(3, "Unable to open command file %s", filename);
  }
  ibuf[0] = '\0';
  lineNumber = 0;
  cmdfilename = filename;
}

commandFile::~commandFile() {
  if (ifp != 0) {
    fclose(ifp);
    ifp = 0;
  }
}

void commandFile::addVariable(dReal *ptr, const char *name) {
  nl_assert(ptr && name);
  variableDef var(ptr, name);
  vars.push_back(var);
}

/**
 * If a command is pending, execute it, then read the next line
 * and report its time offset.
 * Command Syntax:
 *   <time> Set|Adjust <var> <value>
 *   <time> and <value> are real numbers.
 *   <time> must be non-negative and represents elapsed seconds since
 *     the previous command.
 *   <var> corresponds to whatever values are defined.
 * @return The number of seconds before the next command or -1 on
 * EOF or Quit
 */
double commandFile::eval() {
  if (ifp == 0) return -1;
  if (lineNumber > 0) {
    if (strcasecmp("quit",command) == 0) return (-1.);
    if (strcasecmp("noop",command) != 0) {
      // Must be 'Set' or 'Adjust'
      std::list<variableDef>::const_iterator ivar;
      for (ivar = vars.begin(); ivar != vars.end(); ++ivar) {
        if (strncasecmp(ivar->name, varname, IBUFLEN) == 0) {
          if (strcasecmp("set",command) == 0) {
            *(ivar->ptr) = commandValue;
          } else if (strcasecmp("adjust", command) == 0) {
            *(ivar->ptr) += commandValue;
          } else {
            msg(3, "%s:%d: Invalid command '%s'",
              cmdfilename, lineNumber, command);
          }
          break;
        }
      }
      if (ivar == vars.end()) {
        msg(2, "%s:%d: Unknown variable: '%s'",
          cmdfilename, lineNumber, command);
      }
    }
  }
  for (;;) {
    double Tdelta;
    ++lineNumber;
    if (fgets(ibuf, IBUFLEN, ifp) == 0) return -1;
    if (ibuf[0] != '#' && ibuf[0] != '\n') {
      int nconv = sscanf(ibuf, "%lf %s %s %lf", &Tdelta,
        &command, &varname, &commandValue);
      if (nconv == 2 &&
          (strcasecmp("Quit", command) == 0 ||
           strcasecmp("Noop", command) == 0)) {
        varname[0] = '\0';
      } else if (nconv < 4) {
        msg(3, "%s:%d: Syntax error '%s'", cmdfilename, lineNumber, ibuf);
      }
      if (Tdelta < 0) {
        msg(3, "%s:%d: Invalid negative time delta", cmdfilename, lineNumber);
      }
      return Tdelta;
    }
  }
}
