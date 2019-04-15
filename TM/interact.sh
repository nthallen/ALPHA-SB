#! /bin/bash
function nl_error {
  echo "interact: $*" >&2
  exit 1
}

export Experiment=scopex
launch_error=''
VERBOSE=''

[ -f VERSION ] || nl_error Missing VERSION File
VERSION=`cat VERSION`
[ -d "bin/$VERSION" ] || nl_error "Missing bin directory bin/$VERSION"
export PATH=bin/$VERSION:$PATH

function waitfor {
  name=$1
  duration=$2
  while [ $duration -gt 0 ]; do
    [ -e $name ] && return 0
    sleep 1
    # let duration=duration-1
  done
  return 1
}

function Launch {
  name=$1
  shift
  [ -n "$launch_error" ] && return 1
  [ -n "$VERBOSE" ] && msg "[DEBUG] Launch: $*"
  if { $* & }; then
    Launch_pid=$!
    msg "Launch: $Launch_pid $*"
    # if [ "$name" = "DG/cmd" ]; then
      # parent_loop="-q -M $Launch_pid -t 5"
    # fi
    if [ "$name" != "-" ]; then
      [ "$name" = "-TMC-" ] && name="/var/run/linkeng/run/$Experiment/$!"
      [ "${name#/}" = "$name" ] && name="/var/run/linkeng/$Experiment/$name"
      [ -n "$VERBOSE" ] &&
        msg "[DEBUG] Launch: Waiting for $Launch_pid:$name"
      waitfor $name 10 || {
        msg "[ERROR] Launch: namewait failure: $*"
        launch_error=yes
        return 1
      }
    fi
  else
    msg "[ERROR] Launch: $*"
    launch_error=yes
    return 1
  fi
  return 0
}

rm -rf /var/run/linkeng/${Experiment}*
rm -f $Experiment.log *.stackdump
rm -rf LOG
memoname=/var/run/linkeng/$Experiment/memo
# ls -l $memoname
[ -e $memoname ] || {
  echo "Launching memo for $memoname"
  cygstart mintty memo -o scopex.log -l2 -V
  waitfor $memoname 2 || nl_error "Memo launch failed"
}

# Launch tm_bfr cygstart mintty gdb bfr
Launch tm_bfr bfr -v
# Launch - cygstart mintty gdb lgr
Launch -TMC- lgr
# Launch - cygstart mintty gdb scopexengext
# Launch -TMC- scopexengext
# cygstart mintty cyg_nc.sh scopexdispnc -a
# Launch tm_gen cygstart mintty gdb scopexcol
Launch tm_gen scopexcol -v
# Launch cmd cygstart mintty gdb scopexsrvr
Launch cmd scopexsrvr -v
scopexcltnc
# Then cleanup
