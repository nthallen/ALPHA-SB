/* commandfile.cpp */
#include <strings.h>
#include "SCoPEx.h"
#include "nl.h"
#include "nl_assert.h"

variableDef::variableDef(dReal* ptr, const char *name) {
  this->ptr = ptr;
  this->name = name;
}

commandFile::commandFile(SCoPEx *model)
  : DAS_IO::Cmd_reader("Cmd", IBUFLEN, "Sim"),
    model(model) {
}

commandFile::~commandFile() {}

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
bool commandFile::app_input() {
  bool rv = false;
  while (cp < nc) {
    bool have_value = false;
    if (buf[cp] == '#') {
      while (cp < nc && buf[cp] != '\n')
        ++cp; // leave \n in input buffer
      command[0] = '\0';
    } else if (buf[cp] != '\n') {

      char *dest = &command[0];
      while (cp < nc && buf[cp] != ' ' && buf[cp] != '\n') {
        *dest++ = buf[cp++];
      }
      *dest = '\0';

      dest = &varname[0];
      if (cp < nc && buf[cp] == ' ') {
        ++cp;
        while (cp < nc && buf[cp] != ' ' && buf[cp] != '\n') {
          *dest++ = buf[cp++];
        }
      }
      *dest = '\0';

      if (cp < nc && buf[cp] == ' ') {
        ++cp;
        if (not_double(commandValue)) {
          report_err("%s: Expected value", iname);
        } else {
          have_value = true;
        }
      }
    }
    if (buf[cp] != '\n') {
      report_err("%s: Unexpected chars after command");
      while (cp < nc && buf[cp] != '\n')
        ++cp;
    } else if (cp < nc) { // Should have '\n' still
      enum cmd_t { cmd_quit, cmd_noop, cmd_set, cmd_adjust,
                   cmd_start, cmd_reset, cmd_inv } cmd;
           if (!strcasecmp("", command)) cmd = cmd_noop;
      else if (!strcasecmp("Quit", command) ||
               !strcasecmp("Q", command)) cmd = cmd_quit;
      else if (!strcasecmp("Noop", command)) cmd = cmd_noop;
      else if (!strcasecmp("Set", command)) cmd = cmd_set;
      else if (!strcasecmp("Adjust", command)) cmd = cmd_adjust;
      else if (!strcasecmp("Start", command)) cmd = cmd_start;
      else if (!strcasecmp("Reset", command)) cmd = cmd_reset;
      else {
        report_err("%s: Invalid command", iname);
        cmd = cmd_inv;
      }

      if (cmd == cmd_quit || cmd == cmd_noop ||
          cmd == cmd_start || cmd == cmd_reset) {
        if (varname[0]) {
          report_err("%s: Unexpected arg after quit or noop", iname);
          cmd = cmd_inv;
        }
      } else if ((cmd == cmd_set || cmd == cmd_adjust) &&
                  (!varname[0] || !have_value)) {
        report_err("%s: Expected varname and value for set/adjust",
                    iname);
        cmd = cmd_inv;
      }

      if (cmd == cmd_quit) rv = true;
      if (cmd == cmd_start) model->Start();
      else if (cmd == cmd_reset) model->Reset();
      if (cmd == cmd_set || cmd == cmd_adjust) {
        std::list<variableDef>::const_iterator ivar;
        for (ivar = vars.begin(); ivar != vars.end(); ++ivar) {
          if (strncasecmp(ivar->name, varname, IBUFLEN) == 0) {
            if (cmd == cmd_set) {
              *(ivar->ptr) = commandValue;
            } else {
              *(ivar->ptr) += commandValue;
            }
            break;
          }
        }
        if (ivar == vars.end()) {
          msg(2, "%s: Unknown variable: '%s'", iname, varname);
        }
      }
    }
    if (cp < nc) {
      report_ok(++cp);
    }
  }
  return rv;
}
