/* cmdgen output.
 * Tue Jan  1 10:31:43 2019
 */
/* cmdgen.skel skeleton file */
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <unistd.h>
#ifndef __QNXNTO__
  #include "dasio/cmd_server.h"
#endif
#include "cmdalgo.h"
#include "nl.h"
#include "nl_assert.h"
#include "oui.h"

/* iomode defines determine the mode of input.
   IO_BACKSPACE indicates that backspace should backup
   to the last non-trivial input character.
   IO_SPACE auto-advances when a space or newline is entered
   IO_ALWAYS advances within words whenever the following
         letters are unambiguous.
   IO_WORD only advances within words when the rest of the current
         word is unambiguous (e.g. prevents advancing 'O' for On/Off)
   IO_WORDSKIP Controls advancing at the beginning of a word. If
     not specified, no advancement will take place at the
         beginning of a word without further input. If specified,
         entire words may be skipped if they are unambiguous.
*/
static short iomode;
#define IO_BACKSPACE 1
#define IO_SPACE 2
#define IO_ALWAYS 4
#define IO_WORD 8
#define IO_WORDSKIP 0x10

#define IOF_NO_ADV 0x1
#define IOF_UNGOTNL 0x2
#define IOF_UPDATE 0x4
#define IOF_EXECUTE 0x8
#define IOF_INTERACTIVE 0x10
static short ioflags;

#ifdef SERVER
  cmdif_rd if_PropMtr("PropMtr");
#endif
#ifdef SERVER
  cmdif_rd if_Quit("Quit");
#endif

#ifdef SERVER
  void cis_interfaces(void) {
    if_PropMtr.Setup();
    if_Quit.Setup();
  };

  void cis_interfaces_close(void) {
    if_PropMtr.Shutdown();
    if_Quit.Shutdown();
  }
#endif

typedef unsigned char cg_token_type;
typedef unsigned char cg_nonterm_type;

#if defined SNAFU_CURSES && ! defined SELF_SERVE
  #define SELF_SERVE
#endif

/* Compilations options:
 Interface options:
   CLIENT        Ships commands to a server
   SERVER        Receives commands from clients
   SELF_SERVE    Does it all! (default if SNAFU_CURSES)

 Low-level action options:
   CLIENT_ACTIONS Executes actions specified for client.
   SERVER_ACTIONS Executes actions specified for server.
     (default is to do both, but usually controlled by Interace option)
 
 Low-level mode options:
   CMD_BATCH_MODE generates cmd_batch()
   CMD_INTERACT_MODE generates cmd_interact()
     (INTERACT is default, but usually controlled by interface option)

         These are set by the Interface option, although it is still 
         possible to specify them individually if necessary.

         I expect keyboard (CLIENT) programs to usually define just 
         CMD_INTERACT_MODE (although history would require BATCH also) 
         and SERVERs to define just CMD_BATCH_MODE. Note that if only 
         CMD_BATCH_MODE is defined, NO_PROMPTS is assumed.

 I/O options:
   QNX_CONS      uses nl nl_cons.h stuff (default on QNX4)
   SNAFU_CURSES  specific to snafu. Implies SELF_SERVE
   PHOTON_INTERFACE uses Photon (default on QNX6)
   NCT_INTERFACE uses the nctable library for ncurses
   LL_INTERFACE  allows for external definition each
                 interface element, but defaults to a
                 "Low Level" interface.

 Prompt options:
   NO_PROMPTS      suppresses all prompting code and data
                   default when CMD_INTERACT_MODE is not
                   defined (i.e. when SERVER is defined)
   MACHINE_PROMPTS used by QNX_CONS to generate faster prompts.
                   Irrelevant if NO_PROMPTS is defined.

 I/O Mode:
   IOMODE_INIT   initial value to be assigned for iomode
*/
#if defined SELF_SERVE
  #define CMD_INTERACT_MODE
  #define SERVER_ACTIONS
  #define CLIENT_ACTIONS
#elif defined CLIENT
  #define CMD_INTERACT_MODE
  #define CLIENT_ACTIONS
  static short saw_server_action;
#elif defined SERVER
  #define CMD_BATCH_MODE
  #define SERVER_ACTIONS
#else /* default to all actions to support existing usage */
  #define SERVER_ACTIONS
  #define CLIENT_ACTIONS
#endif

#if defined CLIENT || defined SERVER
  #ifdef __QNXNTO__
    #include "tm.h" /* for ci* library functions */
  #else
    #include "dasio/cmd_server.h"
  #endif
#endif

#if ! (defined CMD_INTERACT_MODE || defined CMD_BATCH_MODE)
  #define CMD_INTERACT_MODE
#endif

#ifdef CMD_INTERACT_MODE
  #if ! (defined QNX_CONS || defined SNAFU_CURSES || defined PHOTON_INTERFACE || defined LL_INTERFACE || defined NCT_INTERFACE)
    #if __QNXNTO__
      #define PHOTON_INTERFACE 1
    #elif defined( __QNX__ )
      #define QNX_CONS
    #else
      #define NCT_INTERFACE
    #endif
  #endif
#endif

#if ! (defined CMD_INTERACT_MODE || defined NO_PROMPTS)
  #define NO_PROMPTS
#endif

#ifdef QNX_CONS
  #include "nl_cons.h"
#elif defined SNAFU_CURSES
  #include <ncurses/curses.h>
  #include "scurses.h"
#elif defined PHOTON_INTERFACE
  #include <Pt.h>
  #include "nlphcmd.h"
#elif defined NCT_INTERFACE
  #include <ncurses/curses.h>
  #include "nctable.h"
#endif

#define CG_IBUF_SIZE 256
static char ibuf[CG_IBUF_SIZE];

#ifndef IOMODE_INIT
  #define IOMODE_INIT (IO_SPACE|IO_BACKSPACE|IO_ALWAYS)
#endif

#define STORE_CHAR(x) do {\
  if (ibufidx==CG_IBUF_SIZE)\
        { CMD_ERROR("Input buffer overflow"); }\
  ibuf[ibufidx++] = x;\
} while (0)
#define UNSTORE_CHAR { assert(ibufidx > 0); ibufidx--; }

#ifdef QNX_CONS
  #define GETCH() nlcon_getch()
  #define DISPLAY_CHAR(c) con_dispc(c)
  #define UNDISPLAY_CHAR con_undispc()
  #define CLEAR_DISPLAY_LINE do { con_col = con_low = 1;\
                                  con_nchars = 0;\
                                  ioflags |= IOF_UPDATE; } while (0)
  #define DISPLAY_PROMPT(x) con_prompt(prmt_text+x)
  #define UPDATE_OUTPUT con_update()
#endif
#ifdef SNAFU_CURSES
  #define REJECT_CHAR snafu_reject_char()
  #define SPECIAL_CHAR_FUNC(x) REJECT_CHAR
  #define CMD_ERROR(x) cmderr(x); exit(1)
  #define DISPLAY_CHAR(x) do { waddch(cmdwin.w, (x)?(x):' ');\
                               ioflags |= IOF_UPDATE; } while (0)
  #define UNDISPLAY_CHAR do { waddstr(cmdwin.w, "\b \b");\
                              ioflags |= IOF_UPDATE; } while (0)
  #define CLEAR_DISPLAY_LINE do { wclear(cmdwin.w);\
                                  wmove(cmdwin.w, 0, 0);\
                                  swrefresh(cmdwin.h); } while (0)
  #define DISPLAY_PROMPT(x) disp_prompt(prmt_text[x])
  #define GETCH() snfgetch()
  #define UPDATE_OUTPUT curses_update()

  static int snfgetch() {
        int c;
        
        for (;;) {
          c = sgetch();
          if (c == '@') {
                c = sgetch();
                if (c == '@') break;
                else snafu_scan_code(c);
          } else break;
        }
        return(c);
  }

  static void curses_update(void) {
        if (ioflags & IOF_UPDATE) {
          swrefresh(cmdwin.h);
          ioflags &= ~IOF_UPDATE;
        }
  }
#endif
#ifdef PHOTON_INTERFACE
  #define GETCH() nlph_getch()
  #define DISPLAY_CHAR(c) nlph_dispc(c?c:' ')
  #define UNDISPLAY_CHAR nlph_undispc()
  #define CLEAR_DISPLAY_LINE nlph_clearline()
  #define DISPLAY_PROMPT(x) nlph_prompt(prmt_text[x])
  #define UPDATE_OUTPUT nlph_update()
#endif
#ifdef NCT_INTERFACE
  #define GETCH() nct_getch()
  #define DISPLAY_CHAR(c) nct_dispc(c?c:' ')
  #define UNDISPLAY_CHAR nct_undispc()
  #define CLEAR_DISPLAY_LINE move(0,0); clrtoeol(); nct_col = 0
  #define DISPLAY_INPUT_PROMPT mvaddch(0,0,'>'); nct_col = 1;
  #define DISPLAY_PROMPT(x) nct_prompt(prmt_text[x])
  #define UPDATE_OUTPUT refresh()
#endif

/*----------------------------------------------------------------
  These are the routines which define the operating system interface.
  These are default routines which should be replaced by better ones.
----------------------------------------------------------------*/
/* REJECT_CHAR only referenced in CMD_INTERACT_MODE */
#ifndef REJECT_CHAR
  #define REJECT_CHAR do { putc('\a', stderr); fflush(stderr); } while (0)
#endif

/* SPECIAL_CHAR_FUNC(x) always called for non-printable characters */
#ifndef SPECIAL_CHAR_FUNC
  #ifdef CMD_INTERACT_MODE
    #define SPECIAL_CHAR_FUNC(x) REJECT_CHAR
  #else
    #define SPECIAL_CHAR_FUNC(x)
  #endif
#endif

/* CMD_ERROR is for fatal internal errors
    it can safely include multiple statements since its use is
        quite limited.
*/
#ifndef CMD_ERROR
  #define CMD_ERROR(x) nl_error(4,x)
#endif

/* DISPLAY_CHAR always referenced */
#ifndef DISPLAY_CHAR
  #ifdef CMD_INTERACT_MODE
    #define DISPLAY_CHAR(c) putchar((c)?(c):' ')
  #else
    #define DISPLAY_CHAR(c)
  #endif
#endif

/* UNDISPLAY_CHAR is referenced by RUBOUT which is always referenced,
   although it needn't really be unless CMD_INTERACT_MODE. */
#ifndef UNDISPLAY_CHAR
  #ifdef CMD_INTERACT_MODE
    #define UNDISPLAY_CHAR fputs("\b \b", stdout)
  #else
    #define UNDISPLAY_CHAR
  #endif
#endif

/* CLEAR_DISPLAY_LINE Always used regardless of mode */
#ifndef CLEAR_DISPLAY_LINE
  #ifdef CMD_INTERACT_MODE
    #define CLEAR_DISPLAY_LINE putchar('\n')
    #ifndef DISPLAY_INPUT_PROMPT
      #define DISPLAY_INPUT_PROMPT fputs("& ", stdout);
    #endif
  #else
    #define CLEAR_DISPLAY_LINE
  #endif
#endif

/* DISPLAY_EOL Referenced when newline is accepted */
#ifndef DISPLAY_EOL
  #ifdef LL_INTERFACE
    #define DISPLAY_EOL putchar('\n');
  #else
    #define DISPLAY_EOL
  #endif
#endif

/* DISPLAY_INPUT_PROMPT Always referenced regardless of mode */
#ifndef DISPLAY_INPUT_PROMPT
  #define DISPLAY_INPUT_PROMPT
#endif

/* DISPLAY_PROMPT displays a prompt. Not referenced if NO_PROMPTS */
#ifndef DISPLAY_PROMPT
  #define DISPLAY_PROMPT(x) { int i; printf("\n%s", prmt_text[x]);\
          CLEAR_DISPLAY_LINE; DISPLAY_INPUT_PROMPT \
          for (i = 0; i < ibufidx; i++) DISPLAY_CHAR(ibuf[i]); }
#endif

/* GETCH is low-level get character routine for interactive input.
   It is not used if CMD_INTERACT_MODE is not defined. */
#if ! defined(GETCH) && defined(CMD_INTERACT_MODE)
  #include <conio.h>
  #define GETCH() getch()
#endif

/* UPDATE_OUTPUT always used regardless of mode. This is used for
   indicating when output really needs to be forced to the screen.
 */
#ifndef UPDATE_OUTPUT
  #define UPDATE_OUTPUT fflush(stdout)
#endif

/*----------------------------------------------------------------*/
#define RUBOUT { UNSTORE_CHAR; UNDISPLAY_CHAR; }
#define ACCEPT_CHAR(c) { STORE_CHAR(c); DISPLAY_CHAR(c); }

#define T_FLAG 0x80
#define T_ROOT 1
#define T_CHAR(i) (trie[i].code&0x7F)
#define T_MATCH(i,c) (tolower(c)==tolower(T_CHAR(i)))
typedef struct {
  unsigned char code;
  cg_token_type next;
  cg_token_type prev;
} trie_type;

#ifndef NO_PROMPTS
typedef struct {
  int more;
  unsigned short txt_idx;
} prompt_type;
#endif

#ifdef QNX_CONS
  #define MACHINE_PROMPTS
  #define PROMPT_ATTR 0x70
  #define CMD_ATTR 7
#endif

#ifdef MACHINE_PROMPTS
  #define PRMTOFST(x) ((x)*80*2)
#else
  #define PRMTOFST(x) x
#endif

typedef struct {
  cg_nonterm_type nt;
  cg_token_type shift;
} shift_type;

#define STFL_REDUCE 1
#define STFL_VARIABLE 2
#define STFL_WORD 4
typedef struct {
  unsigned char flag;
  unsigned short offset; /* offset in rules[], vardef[] or trie[] */
  short prompt; /* offset in prompts[] or -1 */
  unsigned short nterm_offset; /* offset in non_terminals[] */
} state_type;
/* If flag == STFL_REDUCE
          offset is the rule number
          prompt is unused (-1)
          nterm_offset is offset in non_terminals[]
   If flag == STFL_VARIABLE
          offset is variable type
          prompt is offset in prompts[]
          nterm_offset is offset in non_terminals[]
   If flag == STFL_WORD
          offset is offset in trie[]
          prompt is offset in prompts[]
          nterm_offset is offset in non_terminals[]
   Variables should be treated as some sort of non-terminal
*/

/* KG_ defines are values returned by command_getch() (and hence input())
   for the specified keys
*/
#define KG_RUBOUT 8
#define KG_ESCAPE 27
#define KG_DEL 127
#define KG_TAB 9

static void nterm_shift(cg_nonterm_type nt, unsigned short val, short prev);

/* Unshifting and Cancellation definitions:
   CANCEL_LINE may be used in actions. (The do/while allows use
   of the form: if (x) CANCEL_LINE; else ...) CANCEL_LINE
   includes a return(0) which is the right thing to do in
   rule_action or in read_variable() or read_words(), but
   care should be taken if this construct is used elsewhere.
*/
static unsigned short unshift_value;
static short full_reduce;
static int unshift(void);
static int ibufidx;
#define CANCEL_LINE do {\
  while (unshift());\
  full_reduce=1;\
  unshift_value = ibufidx = 0;\
  return(0);\
} while (0)

#ifdef CLIENT
  extern int cgc_forwarding;
  int cgc_exit_code = 0;
#endif

char ci_version[] = "$CGID: PropMtrcmd.cc: Tue Jan  1 10:31:43 2019 $";
#define VTP_STR vu00
#define VAR_s 0
typedef union {
  char * vu00;
} vstack_type;

#define VSTACK_SIZE 20
#define NEED_VALUES
vstack_type vstack[VSTACK_SIZE];
short vsp;
#define V(d,x) vstack[tstack[x-(d)].valpos]


/* prev member is non-negative if we left the previous state via
   a non-terminal. If so, it gives the tstack position of the
   previous element on the stack and value is set to the rule
   number by which the non-terminal was derived.
   If prev is negative, we left the
   previous state via a terminal and the previous state is
   the previous position on the stack (offset -1). Information
   about what kind of terminal it was is available in the
   state description of this previous state. If it is a variable,
   value is the number of characters. If it is a word,
   value is the offset of the final position in the grand trie
   as measured from the starting offset found in the state.
   As such, a value of 0 is an appropriate starting point for
   either type of terminal.
   
   Note that the value in one state position pertains to the
   previous state. As such it indicates "how we got to this
   state" not "how we left this state". This is necessary
   due to the fact that one state may be previous to several
   other states. For example, you may leave state 1 via a
   word, then when the word reduces to a non-terminal, you
   may leave state 1 via that non-terminal also while the
   word is still saved on the stack for backtracking. The
   non-terminal may in fact reduce to another non-terminal,
   and so on.
*/
typedef struct {
  cg_token_type state;
  unsigned char reversible;
  short prev;
  #ifdef CLIENT
    short saw_srvr;
  #endif
  #ifdef NEED_VALUES
    unsigned char valpos;
  #endif
  unsigned short value; /* n_chars for variables, trie offset for words */
} tstack_type;
#define TSTACK_SIZE 40
tstack_type tstack[TSTACK_SIZE];
short tsp;
#define P(d,x) (tstack[x-(d)+1].prev-1)
#define PP(d,x) (x-(d)+1)
trie_type trie[] = {
  { 0x01          ,   1,   0 },
  { 0x0A          ,   4,   1 },
  { 0x45 /* 'E' */,   4,   2 },
  { 0x4C /* 'L' */,   4,   3 },
  { 0xD1 /* 'Q' */,   4,   4 },
  { 0x80          ,   3,   4 },
  { 0xF8 /* 'x' */,   3,   4 },
  { 0xEF /* 'o' */,   3,   4 },
  { 0xF5 /* 'u' */,   3,   4 },
  { 0xE9 /* 'i' */,   3,   3 },
  { 0xE7 /* 'g' */,   3,   3 },
  { 0xE9 /* 'i' */,   3,   3 },
  { 0xF4 /* 't' */,   3,   3 },
  { 0x80          ,   5,   3 },
  { 0xF4 /* 't' */,   2,   3 },
  { 0x80          ,   4,   3 },
  { 0x80          ,   6,   2 },
  { 0x01          ,   1,   0 },
  { 0x8A          ,   1,   1 },
  { 0x80          ,   9,   1 },
  { 0x01          ,   1,   0 },
  { 0x8A          ,   1,   1 },
  { 0x80          ,  11,   1 },
  { 0x01          ,   1,   0 },
  { 0x8A          ,   1,   1 },
  { 0x80          ,  12,   1 }
};
#ifndef NO_PROMPTS
prompt_type prompts[] = {
  {  0, PRMTOFST(0) },
  {  0, PRMTOFST(1) },
  {  0, PRMTOFST(2) },
  {  0, PRMTOFST(1) },
  {  0, PRMTOFST(1) }
};
#ifdef MACHINE_PROMPTS
  unsigned char prmt_text[] = {
    60, PROMPT_ATTR, 67, PROMPT_ATTR, 82, PROMPT_ATTR, 62, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 69, PROMPT_ATTR, 120, PROMPT_ATTR,
    105, PROMPT_ATTR, 116, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    76, PROMPT_ATTR, 111, PROMPT_ATTR, 103, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 81, PROMPT_ATTR, 117, PROMPT_ATTR,
    105, PROMPT_ATTR, 116, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    60, PROMPT_ATTR, 67, PROMPT_ATTR, 82, PROMPT_ATTR, 62, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    69, PROMPT_ATTR, 110, PROMPT_ATTR, 116, PROMPT_ATTR, 101, PROMPT_ATTR,
    114, PROMPT_ATTR, 32, PROMPT_ATTR, 83, PROMPT_ATTR, 116, PROMPT_ATTR,
    114, PROMPT_ATTR, 105, PROMPT_ATTR, 110, PROMPT_ATTR, 103, PROMPT_ATTR,
    32, PROMPT_ATTR, 116, PROMPT_ATTR, 111, PROMPT_ATTR, 32, PROMPT_ATTR,
    76, PROMPT_ATTR, 111, PROMPT_ATTR, 103, PROMPT_ATTR, 32, PROMPT_ATTR,
    116, PROMPT_ATTR, 111, PROMPT_ATTR, 32, PROMPT_ATTR, 77, PROMPT_ATTR,
    101, PROMPT_ATTR, 109, PROMPT_ATTR, 111, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR,
    32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR, 32, PROMPT_ATTR
  };
#else
  const char *prmt_text[] = {
    "<CR>      Exit      Log       Quit",
    "<CR>",
    "Enter String to Log to Memo"
  };
#endif
#endif /* NO_PROMPTS */
shift_type non_terminals[] = {
  { 1, 1 },
  { 2, 2 },
  { 0, 0 },
  { 3, 7 },
  { 4, 8 },
  { 0, 0 },
  { 0, 10 }
};
state_type states[] = {
  { STFL_REDUCE, 4, -1, 0 },
  { STFL_REDUCE, 0, -1, 2 },
  { STFL_WORD, 0, 0, 3 },
  { STFL_REDUCE, 6, -1, 2 },
  { STFL_WORD, 17, 1, 2 },
  { STFL_VARIABLE, VAR_s, 2, 6 },
  { STFL_WORD, 20, 3, 2 },
  { STFL_REDUCE, 2, -1, 2 },
  { STFL_REDUCE, 5, -1, 2 },
  { STFL_REDUCE, 3, -1, 2 },
  { STFL_WORD, 23, 4, 2 },
  { STFL_REDUCE, 1, -1, 2 },
  { STFL_REDUCE, 7, -1, 2 }
};
static int rule_action(unsigned short rule) {
  switch (rule) {
    default:
      CMD_ERROR("Unexpected Rule in rule_action");
    case 0:
      /* &start */
      nterm_shift(0, 0, PP(0,P(1,tsp)));
      return(1);
    case 1:
      /* &start : &commands Quit * */
      #ifdef SERVER_ACTIONS
        if (ioflags & IOF_EXECUTE)
        { nl_error(0, "Shutting down"); }
      #else
        saw_server_action = 1;
      #endif
      nterm_shift(1, 1, PP(0,P(3,tsp)));
      return(0);
    case 2:
      /* &start : &commands &&Exit */
      nterm_shift(1, 2, PP(0,P(0,P(1,tsp))));
      return(0);
    case 3:
      /* &&Exit : Exit * */
      #ifdef CLIENT_ACTIONS
        if (ioflags & IOF_EXECUTE)
        {cgc_forwarding = 0; }
      #endif
      nterm_shift(3, 3, PP(3,tsp));
      return(0);
    case 4:
      /* &commands : */
      nterm_shift(2, 4, PP(1,tsp));
      return(0);
    case 5:
      /* &commands : &commands &command */
      nterm_shift(2, 5, PP(0,P(0,P(1,tsp))));
      return(0);
    case 6:
      /* &command : * */
      nterm_shift(4, 6, PP(2,tsp));
      return(0);
    case 7:
      /* &command : Log %s (Enter String to Log to Memo) * */
      #ifdef SERVER_ACTIONS
        if (ioflags & IOF_EXECUTE)
        {}
      #else
        saw_server_action = 1;
      #endif
      nterm_shift(4, 7, PP(4,tsp));
      return(0);
  }
}

#ifdef QNX_CONS
  #include <sys/stat.h>

static char con_clr[] = {
  62, PROMPT_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR,
  32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR,
  32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR,
  32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR,
  32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR,
  32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR,
  32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR,
  32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR,
  32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR,
  32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR,
  32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR,
  32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR,
  32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR,
  32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR,
  32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR,
  32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR, 32, CMD_ATTR
};

/* con_col is the current position of the cursor
 * con_high is the highest column that is currently non-blank
 * con_low is the lowest column that should be blank
 */
static int con_col, con_high, con_low;
static char con_buf[CG_IBUF_SIZE*2+2];
static int con_nchars = 0;
#ifndef NO_PROMPTS
  static char *con_cur_prmt, *con_new_prmt;
#endif

/* con_puts() outputs n bytes from buf at the specified byte_offset
   of the specified row on all defined consoles.
   row_offset of 0 is the typing line and 1 is the prompt line.
   byte_offset starts at 0 and advances 2 for each char.
   n is now n_chars, byte_offset changes to char_offset
*/
static void
con_puts(char *buf, int row_offset, int char_offset, int n_chars) {
  int i;
  struct _console_ctrl *cc;
  
  for (i = 0; i < MAXCONS; i++) {
    if (nlcon_ctrl(i, &cc)) {
      nl_con_def *nlcd = &nl_cons[i];
      if ( char_offset < nlcd->columns ) {
        int crow, ccol, out_offset;
        int nc;

        if ( char_offset + n_chars > nlcd->columns )
          nc = nlcd->columns - char_offset;
        else nc = n_chars;
        crow = nlcd->rows-2;
        ccol = con_col;
        out_offset =
          (nlcd->rows - 2 + row_offset) * nlcd->columns * 2 + char_offset*2;
        console_write(cc, 0, out_offset, buf, nc*2,
                          &crow, &ccol, NULL);
      }
    }
  }
}

static void con_update(void) {
  #ifndef NO_PROMPTS
        if (con_cur_prmt != con_new_prmt && (ioflags & IOF_INTERACTIVE))
          con_puts(con_cur_prmt = con_new_prmt, 1, 0, 80);
  #endif
  if (ioflags & IOF_UPDATE) {
    if (con_col == 79)
      con_puts(con_buf+con_nchars-78*2, 0, 1, 78);
    else if (con_col == 1)
      con_puts(con_clr, 0, 0, 80);
    else {
      if (con_low < con_col) {
        int nchars;
        nchars = (con_col - con_low);
        con_puts(con_buf+con_nchars-(nchars*2), 0, con_low, nchars);
      }
      if (con_col < con_high) {
        int nchars;
        nchars = (con_high - con_col);
        con_puts(con_clr+2, 0, con_col, nchars);
      }
    }
    con_low = con_high = con_col;
    ioflags &= ~IOF_UPDATE;
  }
}

#ifndef NO_PROMPTS
  static void con_prompt(char *c) {
    con_new_prmt = c;
  }
#endif

static void con_dispc(char c) {
  con_buf[con_nchars++] = c;
  con_buf[con_nchars++] = CMD_ATTR;
  if (con_col < 79) con_col++;
  ioflags |= IOF_UPDATE;
}

static void con_undispc(void) {
  con_nchars -= 2;
  if (con_nchars < 78*2 && --con_col < con_low)
        con_low = con_col;
  ioflags |= IOF_UPDATE;
}

static void con_cleanup( void ) {
  int i;
  struct _console_ctrl *cc;
  int row, col;
  
  for (i = 0; i < MAXCONS; i++) {
    if (nlcon_ctrl(i, &cc)) {
      nl_con_def *nlcd = &nl_cons[i];
      row = nlcd->rows - 1;
      col = nlcd->columns;
      console_write(cc, 0, 0, NULL, 0, &row, &col, NULL);
      write( nl_cons[i].fd, "\n", 1 );
    }
  }
}

#define FINAL_CLEANUP con_cleanup();

#endif  /* QNX_CONS */

#if PHOTON_INTERFACE
  static char nlph_buf[CG_IBUF_SIZE+1];
  static int nlph_nchars = 0;
  static const char *nlph_cur_prmt, *nlph_new_prmt;

  //define GETCH() nlph_getch() defined in nlphcmdclient
  static void nlph_dispc(char c) {
    assert(nlph_nchars <= CG_IBUF_SIZE);
    nlph_buf[nlph_nchars++] = c;
    nlph_buf[nlph_nchars] = '\0';
    ioflags |= IOF_UPDATE;
  }
  static void nlph_undispc(void) {
    assert(nlph_nchars > 0);
    nlph_buf[--nlph_nchars] = '\0';
    ioflags |= IOF_UPDATE;
  }
  static void nlph_clearline(void) {
    nlph_nchars = 0;
    nlph_buf[0] = '\0';
    ioflags |= IOF_UPDATE;
  }

  #ifndef NO_PROMPTS
    static void nlph_prompt(const char *c) {
      nlph_new_prmt = c;
    }
  #endif
  static void nlph_update(void) {
    if ( (ioflags & IOF_UPDATE)
         || (nlph_cur_prmt != nlph_new_prmt &&
             (ioflags & IOF_INTERACTIVE)) ) {
      nlph_update_cmdtext( nlph_buf, nlph_new_prmt );
      ioflags &= ~IOF_UPDATE;
    }
  }
#endif /* PHOTON_INTERFACE */

#if NCT_INTERFACE
  static int nct_win;
  static int nct_col;

  void nct_dispc(char c) {
    // simply stop displaying characters after
    // 80
    if ( nct_col < 80 )
      mvaddch( 0, nct_col, c);
    ++nct_col;
  }

  void nct_undispc(void) {
    if ( --nct_col < 80 ) {
      mvaddch( 0, nct_col, ' ');
      move( 0, nct_col );
    }
  }

  void nct_prompt(const char *text) {
    mvaddstr( 1, 0, text );
    clrtoeol();
    move( 0, nct_col );
  }
#endif /* NCT_INTERFACE */

#ifndef NO_PROMPTS
  static short cur_prompt = -1;

  static void new_prompt(short pn) {
    if (pn >= 0 && pn != cur_prompt) {
      if (cur_prompt < 0
          || prompts[pn].txt_idx != prompts[cur_prompt].txt_idx)
        DISPLAY_PROMPT(prompts[pn].txt_idx);
      cur_prompt = pn;
    }
  }

  static void next_prompt(void) {
    if (cur_prompt >= 0)
      new_prompt(cur_prompt + prompts[cur_prompt].more);
  }
#else /* NO_PROMPTS */
  #define new_prompt(x)
  #define next_prompt()
#endif /* NO_PROMPTS */

#ifdef CMD_INTERACT_MODE
  static unsigned short command_getch(void) {
    unsigned short rv;
    
    UPDATE_OUTPUT;
    rv = GETCH();
    if (rv == 0) rv = 0xFF00 | GETCH();
    return(rv);
  }
#endif

#ifdef CMD_BATCH_MODE
  static char *cmd_input;
#endif

static unsigned short input(void) {
  unsigned short rv;
  
  if (ioflags & IOF_UNGOTNL) {
    rv = '\n';
    ioflags &= ~IOF_UNGOTNL;
  }
  #ifdef CMD_BATCH_MODE
    #ifdef CMD_INTERACT_MODE
      else if (cmd_input != NULL) {
    #else
      else {
        assert(cmd_input != NULL);
    #endif
        rv = *cmd_input;
        if (rv) cmd_input++;
      }
  #endif
  #ifdef CMD_INTERACT_MODE
    else rv = command_getch();
  #endif
  return(rv);
}

#define UNPUTNL { ioflags |= IOF_UNGOTNL; }

static void _shift(cg_token_type st, unsigned short val, short prev) {
  tsp++;
  if (tsp >= TSTACK_SIZE) { CMD_ERROR("Token Stack Overflow"); }
  tstack[tsp].state = st;
  tstack[tsp].prev = prev;
  tstack[tsp].value = val;
  #ifdef CLIENT
    tstack[tsp].saw_srvr = saw_server_action;
  #endif
  unshift_value = 0;
  #ifdef NEED_VALUES
    tstack[tsp].valpos = vsp;
  #endif
  tstack[tsp].reversible = 1;
}

static int unshift(void) {
  if (!tstack[tsp].reversible) return(0);
  do {
    #ifdef NEED_VALUES
      vsp = tstack[tsp].valpos;
    #endif
    #ifdef CLIENT
      saw_server_action = tstack[tsp].saw_srvr;
    #endif
    unshift_value = tstack[tsp].value;
  } while (tstack[tsp--].prev >= 0 && tstack[tsp].reversible);
  return(1);
}

/* This routine is used for both non_terminals and variables.
   The difference is that variables have .prev == -1 while
   non_terminals have real previous values set. Shifting for
   nts is relative to the previous state while variables shift
   relative to the current state. nt is zero for variables,
   non-zero for non-terminals.
*/
static void nterm_shift(cg_nonterm_type nt, unsigned short val, short prev) {
  short ntsp;

  ntsp = nt ? prev : tsp;
  ntsp = states[tstack[ntsp].state].nterm_offset;
  {
    cg_nonterm_type cnt;

    for (;;) {
      cnt = non_terminals[ntsp].nt;
      if (cnt == 0 || cnt == nt) break;
      ntsp++;
    }
    assert(cnt == nt);
  }
  _shift(non_terminals[ntsp].shift, val, prev);
}

#if defined VAR_s || defined VAR_w
  #define VAR_strings
#endif
#if defined VAR_d || defined VAR_ld || defined VAR_x || defined VAR_lx \
 || defined VAR_o || defined VAR_lo || defined VAR_f || defined VAR_lf
  #define VAR_numerics
#endif
#if defined VAR_strings && defined VAR_numerics
  #define VAR_both
#endif
#if defined VAR_strings || defined VAR_numerics
  #define VAR_some
#endif

#ifdef VAR_some
static int read_variable(short vartype, unsigned short n_chars) {
  unsigned short getword = 1;
  short c;
  char *text;
  
  #ifdef VAR_s
    if (vartype == VAR_s) getword = 0;
  #endif
  if ((ioflags & IOF_INTERACTIVE) && n_chars > 0) {
    RUBOUT;
    n_chars--;
  }
  do {
        c = input();
        switch (c) {
          case 0:
                unshift_value = n_chars;
                return(0);
          case KG_RUBOUT:
          case KG_DEL:
                #ifdef CMD_BATCH_MODE
                  #ifdef CMD_INTERACT_MODE
                        if (~(ioflags & IOF_INTERACTIVE))
                  #endif
                          return(1);
                #endif
                #ifdef CMD_INTERACT_MODE
                  if (n_chars > 0) {
                        RUBOUT;
                        n_chars--;
                  } else if (unshift()) return(0);
                  else REJECT_CHAR;
                  continue;
                #endif
          case KG_TAB:
                next_prompt();
                continue;
          case KG_ESCAPE:
                CANCEL_LINE;
          case '\n':
          case '\r':
                UNPUTNL;
                c = 0;
                break;
          case ' ':
                if (getword) c = 0;
                break;
          default:
                if (isprint(c) || c == 0) break;
                SPECIAL_CHAR_FUNC(c);
                continue;
        }
        
        /* We should only get here when we want to display a char. */
        ACCEPT_CHAR(c);
        n_chars++;
        
        if (c == 0) {
          text = ibuf + ibufidx - n_chars;

          #ifdef VAR_both
                switch (vartype) {
                  #ifdef VAR_w
                        case VAR_w:
                  #endif
                  #ifdef VAR_s
                        case VAR_s:
                  #endif
          #endif /* VAR_both */
                  #ifdef VAR_strings
                        vstack[vsp].VTP_STR = text;
                  #endif
          #ifdef VAR_both
                        continue;
                  default:
          #endif
          #ifdef VAR_numerics
                        if (n_chars == 1) {
                          #if defined CMD_BATCH_MODE && defined CMD_INTERACT_MODES
                                if (!(ioflags & IOF_INTERACTIVE))
                          #endif
                          #ifdef CMD_BATCH_MODE
                                  return(1);
                          #endif
                          #ifdef CMD_INTERACT_MODE
                                REJECT_CHAR;
                                RUBOUT;
                                ioflags &= ~IOF_UNGOTNL;
                                n_chars--;
                                c = '\b';
                                continue;
                          #endif
                        }
          #endif
          #ifdef VAR_both
                }
          #endif /* VAR_both */
          
          #ifdef VAR_numerics
          { char *ep; /* numeric vartypes: strings CONTINUE beyond here */
          
                ep = ibuf + ibufidx - 1;
                switch (vartype) {
                  #ifdef VAR_d
                        case VAR_d:
                          vstack[vsp].VTP_SHRT = (short) strtol(text, &ep, 0);
                          break;
                  #endif
                  #ifdef VAR_ld
                        case VAR_ld:
                          vstack[vsp].VTP_LONG = strtol(text, &ep, 0);
                          break;
                  #endif
                  #ifdef VAR_x
                        case VAR_x:
                          vstack[vsp].VTP_SHRT = (short) strtol(text, &ep, 16);
                          break;
                  #endif
                  #ifdef VAR_lx
                        case VAR_lx:
                          vstack[vsp].VTP_LONG = strtol(text, &ep, 16);
                          break;
                  #endif
                  #ifdef VAR_o
                        case VAR_o:
                          vstack[vsp].VTP_SHRT = (short) strtol(text, &ep, 8);
                          break;
                  #endif
                  #ifdef VAR_lo
                        case VAR_lo:
                          vstack[vsp].VTP_LONG = strtol(text, &ep, 8);
                          break;
                  #endif
                  #ifdef VAR_f
                        case VAR_f:
                          vstack[vsp].VTP_FLT = (float) strtod(text, &ep);
                          break;
                  #endif
                  #ifdef VAR_lf
                        case VAR_lf:
                          vstack[vsp].VTP_DBL = strtod(text, &ep);
                          break;
                  #endif
                  default: CMD_ERROR("Unexpected vartype in read_variable");
                }
                assert(text <= ep && ep <= ibuf+ibufidx-1);
                if (*ep != '\0') {
                  #if defined CMD_BATCH_MODE && defined CMD_INTERACT_MODES
                        if (!(ioflags & IOF_INTERACTIVE))
                  #endif
                  #ifdef CMD_BATCH_MODE
                        return(1);
                  #endif
                  #ifdef CMD_INTERACT_MODE
                        REJECT_CHAR;
                        ioflags &= ~IOF_UNGOTNL;
                        do {
                          RUBOUT;
                          n_chars--;
                        } while (n_chars > 0 && ep < ibuf + ibufidx);
                        c = '\b';
                        continue;
                  #endif
                }
          } /* numeric vartypes block */
          #endif /* VAR_numerics */
        } /* (c==0) */
  } while (c != 0);
  vsp++;
  nterm_shift(0, n_chars, -1);
  return(0);
}
#endif /* VAR_some */

/* advance as far as is unambiguous, but not beyond EOW or newline.
   We accept EOW and display and store it, but we do not
   accept newline: it must be explicit. Returns TRUE if some
   advancing was actually done.
   for (;;) {
     if current char is EOW break;
         if next is unambiguous and not newline {
           display it
           store it
         } else break;
   }
*/
static int advance(unsigned short *triepos) {
  unsigned short ntp;
  
  if (iomode & IO_WORD) {
        ntp = *triepos;
        for (;;) {
          if ((trie[ntp].code & 0x7F) == 0) break;
          ntp += trie[ntp].next;
          if ((trie[ntp].code & 0x80) == 0
                  || (trie[ntp].code & 0x7F) == '\n') break;
        }
        if (trie[ntp].code != 0x80) return(0);
  }
  ntp = *triepos;
  for (;;) {
        if ((trie[ntp].code & 0x7F) == 0) break;
        ntp += trie[ntp].next;
        if ((trie[ntp].code & 0x80) == 0
                || (trie[ntp].code & 0x7F) == '\n') {
          ntp -= trie[ntp].prev;
          break;
        }
        ACCEPT_CHAR(trie[ntp].code & 0x7F); /* Could be 0 */
        ioflags &= ~IOF_NO_ADV;
  }
  if (ntp != *triepos) {
        *triepos = ntp;
        return(1);
  } else return(0);
}

#ifdef CMD_INTERACT_MODE
/* retreat returns 1 if we backed up out of the current state. */
static int retreat(unsigned short *triepos) {
  int once = 0;
  
  ioflags |= IOF_NO_ADV;
  do {
        if (trie[*triepos].code == T_ROOT) {
          if (unshift()) return(1);
          else if (!once) REJECT_CHAR;
          return(0);
        }
        once = 1;
        RUBOUT;
        *triepos -= trie[*triepos].prev;
  } while ((iomode & IO_BACKSPACE)
                   && (trie[*triepos+trie[*triepos].next].code & 0x80));
  return(0);
}
#endif

/* read_words returns zero on success, non-zero if an unrecognized
   character is encountered.
*/
static int read_words(unsigned short trieroot, unsigned short trie_offset) {
  unsigned short triepos, ntp;
  int c, cl;
  
  triepos = trieroot + trie_offset;

  #ifdef CMD_INTERACT_MODE
        if ((ioflags & IOF_INTERACTIVE)
                && trie[triepos].code != T_ROOT && retreat(&triepos))
          return(0);
  #endif

  /* Now triepos points to the previous node. We must
     advance to next to find the first matching character.
         First advance at the beginning if specified.
  */
  if (!(ioflags & IOF_NO_ADV)
          && (iomode & IO_WORDSKIP)) advance(&triepos);

  for (;;) {
    /* When should we advance?
            ALWAYS
              while there is an unambiguous character not '\n'
              0 translates to space
            SPACE not now
            ALWAYS | WORD
              if unambiguous to EOW
    */
    if (!(ioflags & IOF_NO_ADV)
            && (iomode & IO_ALWAYS)) advance(&triepos);
    if ((trie[triepos].code & 0x7F) == 0) break;
    c = input();
    switch (c) {
      case 0:
            unshift_value = triepos - trieroot;
            return(0);
      case KG_RUBOUT:
      case KG_DEL:
            #ifdef CMD_BATCH_MODE
              #ifdef CMD_INTERACT_MODE
                    if (~(ioflags & IOF_INTERACTIVE))
              #endif
                      return(1);
            #endif
            #ifdef CMD_INTERACT_MODE
              if (retreat(&triepos)) return(0);
              continue;
            #endif
      case ' ':
            if ((iomode & IO_SPACE) && advance(&triepos)) continue;
            c = 0;
            break;
      case '\n':
      case '\r':
            if ((iomode & IO_SPACE) && advance(&triepos)) {
              UNPUTNL;
              continue;
            }
            /* newlines are only OK at the root of a trie. Otherwise
               we need to advance through EOW */
            if (trie[triepos].code != T_ROOT) {
              UNPUTNL;
              c = 0;
            } else c = '\n';
            break;
      case KG_TAB:
            next_prompt();
            continue;
      case KG_ESCAPE:
            CANCEL_LINE;
      default:
        if (isprint(c)) break;
        SPECIAL_CHAR_FUNC(c);
        continue;
    }
    cl = tolower(c);
    ntp = triepos + trie[triepos].next;
    do {
      if (tolower(T_CHAR(ntp)) == cl) {
        triepos = ntp;
        ntp = 0;
        break;
      }
    } while ((trie[ntp++].code & 0x80) == 0);
    if (ntp) {
      #ifdef CMD_BATCH_MODE
        #ifdef CMD_INTERACT_MODE
          if (!(ioflags & IOF_INTERACTIVE))
        #endif
        return(1);
      #endif
      #ifdef CMD_INTERACT_MODE
        REJECT_CHAR;
        ioflags &= ~IOF_UNGOTNL;
      #endif
    } else if (c == '\n') {
      triepos += trie[triepos].next;
      DISPLAY_EOL
      UPDATE_OUTPUT;
      full_reduce = 1;
    } else {
      ACCEPT_CHAR(c); /* c could be \0 */
      ioflags &= ~IOF_NO_ADV;
    }
  }
  _shift(trie[triepos].next, triepos - trieroot, -1);
  return(0);
}

/* Returns non-zero if the root non-terminal is reduced */
static int reduce_rule(unsigned short rule) {
  unsigned short ntsp;
  
  /* rule_action is generated in output_rules().
         It returns the non-zero if the root non-terminal is reduced.
  */
  { int oldresp, action_result;
    oldresp = set_response( 1 );
    action_result = rule_action(rule);
    set_response( oldresp );
    if ( action_result ) return(1);
  }
  if (full_reduce) { /* <move back to prev location +1> */
    tstack[tsp].reversible = 0;
    ntsp = tstack[tsp].prev+1;
    assert(ntsp <= tsp);
    if (ntsp < tsp) {
      #ifdef NEED_VALUES
        if (tstack[ntsp-1].valpos < tstack[tsp-1].valpos) {
          if (vsp > tstack[tsp-1].valpos) {
                vsp = tstack[ntsp-1].valpos;
                vstack[vsp] = vstack[tstack[tsp-1].valpos];
                tstack[tsp].valpos = ++vsp;
          } else tstack[tsp].valpos = vsp = tstack[ntsp].valpos;
        }
      #endif
      tstack[ntsp] = tstack[tsp];
      tsp = ntsp;
    }
  }
  return(0);
}

void cmd_init(void) {
  ioflags = IOF_UPDATE | IOF_EXECUTE | IOF_INTERACTIVE;
  iomode = IOMODE_INIT;
  #ifdef CMD_BATCH_MODE
    cmd_input = NULL;
  #endif
  tsp = -1;
  #ifdef NEED_VALUES
    vsp = 0;
  #endif
  _shift(0,0,-1);
  tstack[tsp].reversible = 0;
  full_reduce = 1;
}

static int cmd_exec(void) {
  state_type *st;
  tstack_type *stktop;
  cg_token_type cur_state;

  for (;;) {
    stktop = &tstack[tsp];
    cur_state = stktop->state;
    st = &states[cur_state];
    if (st->flag == STFL_REDUCE) {
      if (reduce_rule(st->offset)) {
        #ifdef CLIENT
          cic_transmit(ibuf, ibufidx, saw_server_action);
          saw_server_action = 0;
        #endif
        break;
      }
    } else {
      if (full_reduce) {
        #ifdef CLIENT
          cic_transmit(ibuf, ibufidx, saw_server_action);
          saw_server_action = 0;
        #endif
        CLEAR_DISPLAY_LINE;
        DISPLAY_INPUT_PROMPT
        ibufidx = 0;
        full_reduce = 0;
      }
      #ifdef CMD_BATCH_MODE
        if (!(ioflags & (IOF_INTERACTIVE|IOF_UNGOTNL))
                && *cmd_input == '\0') {
          UPDATE_OUTPUT;
          return(0);
        }
      #endif
      assert(st->prompt >= 0);
      new_prompt(st->prompt);
      #ifdef VAR_some
        if (st->flag == STFL_VARIABLE) {
          if (read_variable(st->offset, unshift_value))
            return(CMDREP_SYNERR);
        } else
      #else
        assert(st->flag != STFL_VARIABLE);
      #endif
        if (read_words(st->offset, unshift_value))
          return(CMDREP_SYNERR);
    }
  }
  CLEAR_DISPLAY_LINE;
  UPDATE_OUTPUT;
  return(CMDREP_QUIT);
}

#ifdef CMD_BATCH_MODE
  /* Parses the specified command, executing if test == 0.
     Returns non-zero if an error occurred. Possible errors:
       CMDREP_QUIT Command execution resulted in termination
                (not exactly an error: more a status indication)
       CMDREP_SYNERR - (CMDREP_EXECERR-1)
                    Syntax error. Error value minus 1000 is the
                    character position where the error occurred.
       >=CMDREP_EXECERR Execution error. Error code + CMDREP_EXECERR
  */
  int cmd_batch(char *cmd, int test) {
    short flaghold;
    short old_iomode;
    int retval;

    assert(cmd != NULL);
    assert(ioflags & IOF_INTERACTIVE);
    assert(cmd_input == NULL);
    old_iomode = iomode;
    iomode = 0;
    cmd_input = cmd;
    ioflags &= ~IOF_INTERACTIVE;
    flaghold = ioflags & IOF_EXECUTE;
    if (test) ioflags &= ~IOF_EXECUTE;
    else ioflags |= IOF_EXECUTE;
    retval = cmd_exec();
    if (retval == CMDREP_SYNERR) retval += (cmd_input - cmd);
    ioflags = (ioflags & ~IOF_EXECUTE) | flaghold | IOF_INTERACTIVE;
    iomode = old_iomode;
    cmd_input = NULL;
    return retval;
  }
#endif

#ifdef CMD_INTERACT_MODE
  void cmd_interact(void) {
    cmd_init();
    cmd_exec();
  }
#endif

/* Called by cic_transmit() */
void cmd_report(cmd_state *s) {
  s->state = tstack[tsp].state;
  s->value = unshift_value;
}

/* Compares the current command state to the designated structure
 * returning zero if the states match. Called by cic_transmit().
 */
int cmd_check(cmd_state *s) {
  return(s->state != tstack[tsp].state
          || s->value != unshift_value);
}

#if defined( SERVER_ACTIONS )
  #if defined( SERVER_INIT )
    // This section is apparently obsolete. Perhaps it applied to snafu?
    #include <string.h>
    #ifndef _NL_H_INCLUDED
      #error Must include nl.h
    #endif
    /* solp_init() returns a non-zero value only if there is a
       parsing error.
    */
    int solp_init(unsigned char selector, unsigned char ID, char *cmd) {
      int rv;

      cmd_init();
      rv = cmd_batch(cmd, 1);
      if (rv != 0) switch (CMDREP_TYPE(rv)) {
        case CMDREP_TYPE(CMDREP_QUIT):
          nl_error(2, "Termination Command Illegal in a proxy");
          nl_error(2, "%s", cmd);
          break;
        case CMDREP_TYPE(CMDREP_SYNERR):
          nl_error(2, "Syntax Error in Proxy");
          nl_error(2, "%s", cmd);
          nl_error(2, "%*s", rv - CMDREP_SYNERR, "^");
          break;
        case CMDREP_TYPE(CMDREP_EXECERR):
        default:
          nl_error(2, "Error %d parsing proxy command:");
          nl_error(2, "%s", cmd);
          break;
      }
      if (rv == 0) {
        ci_msg mymsg;
        int size;

        mymsg.msg_type = CMDINTERP_SEND_QUIET;
        strcpy(mymsg.prefix, "Proxy");
        size = strlen(cmd);
        if (size >= CMD_INTERP_MAX)
          return(CMDREP_SYNERR + CMD_INTERP_MAX);
        strcpy(mymsg.command, cmd);
        /* add 1 for msg_type, and 1 for '\0' */
        size += CMD_PREFIX_MAX + 1 + 1;
        rv = set_response(1);
        Soldrv_set_proxy(selector, ID, &mymsg, size);
        set_response(rv);
        rv = 0;
      }
      return(rv);
    }
  #else
    // The fact that these two functions are generated here means that they
    // cannot actually be defined elsewhere to do something useful on
    // startup or shutdown.
    void cis_initialize(void) {}
    void cis_terminate(void) {}
  #endif
#endif

#if defined (CLIENT) || defined (SERVER)

  #if PHOTON_INTERFACE
    static void *nlph_interact(void *arg) {
      do cmd_interact(); while ( cgc_forwarding != 0 );
      PtEnter(0);
      PtExit(0);
      return NULL;
    }
  #endif

  static void cmd_exit( void ) {
    const char *name;

    #if ! PHOTON_INTERFACE
      CLEAR_DISPLAY_LINE;
      UPDATE_OUTPUT;
    #endif
    #ifdef FINAL_CLEANUP
      FINAL_CLEANUP
    #endif
    name = getlogin();
    if (name == NULL) name = "NULL";
    nl_error(0, "Shutdown (%s)", name);
  }

  int main(int argc, char **argv) {
    const char *name;
    oui_init_options(argc, argv);
    name = getlogin();
    if (name == NULL) name = "NULL";
    nl_error(0, "Startup (%s)", name);
    atexit( cmd_exit );
    #ifdef CLIENT
      #if PHOTON_INTERFACE
        nlph_cmdclt_init( &nlph_interact );
        return 0;
      #else
        #ifdef NCT_INTERFACE
          nct_win = nct_cmdclt_init();
        #endif
        do cmd_interact(); while ( cgc_forwarding != 0 );
        return cgc_exit_code;
      #endif
    #else
      ci_server();
      return 0;
    #endif
  }
#endif
