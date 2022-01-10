/** @file rqueue.cc
 */
#include "rqueue.h"
#include "dasio/msg.h"
#include "nl_assert.h"

using namespace DAS_IO;

rqueue_req::rqueue_req() {
  persistent = false;
  device_index = -1;
  callback_id = -1;
  reqstr[0] = '\0';
}

bool rqueue_req::setup(bool persistent, int device_index,
            int callback_id, const char *fmt, va_list args) {
  this->persistent = persistent;
  this->device_index = device_index;
  this->callback_id = callback_id;
  req_sz = vsnprintf(&reqstr[0], reqstr_len, fmt, args);
  if (req_sz >= reqstr_len) {
    msg(MSG_ERROR, "rqueue_req buffer overflow: '%s'", reqstr);
    return true;
  }
  return false;
}

rqueue::rqueue() {
  pending = 0;
  cur_poll = polls.end();
}

bool rqueue::enqueue(bool persistent, int device_index, int callback_id,
                          const char *fmt, va_list args) {
  rqueue_req *req = new_request();
  if (!req) return true;
  bool rv = req->setup(persistent, device_index, callback_id,
                       fmt, args);
  if (rv) {
    free_request(req);
  } else if (persistent) {
    polls.push_back(req);
  } else {
    cmds.push_back(req);
  }
  return rv;
}

bool rqueue::enqueue_poll(int device_index, int callback_id,
                          const char *fmt, ...) {
  va_list args;
  va_start(args, fmt);
  bool rv = enqueue(true, device_index, callback_id, fmt, args);
  va_end(args);
  return rv;
}

/* return true if enqueue failed due to request buffer overflow */
bool rqueue::enqueue_cmd(int device_index, int callback_id,
                         const char *fmt, ...) {
  va_list args;
  va_start(args, fmt);
  bool rv = enqueue(false, device_index, callback_id, fmt, args);
  va_end(args);
  return rv;
}

void rqueue::requeue_polls() {
  if (cur_poll == polls.end()) {
    cur_poll = polls.begin();
  }
}

void rqueue::dispose_pending() {
  if (pending) {
    free_request(pending);
    pending = 0;
  }
}

rqueue_req *rqueue::next_request() {
  nl_assert(!pending);
  rqueue_req *rv = 0;
  if (!cmds.empty()) {
    rv = cmds.front();
    cmds.pop_front();
  } else if (cur_poll != polls.end()) {
    rv = *cur_poll;
    ++cur_poll;
  }
  return rv;
}

rqueue_req *rqueue::new_request() {
  rqueue_req *req;
  if (req_free.empty()) {
    req = new rqueue_req();
  } else {
    req = req_free.front();
    req_free.pop_front();
  }
  return req;
}

void rqueue::free_request(rqueue_req *req) {
  if (!req->persistent) {
    req_free.push_back(req);
  }
}
