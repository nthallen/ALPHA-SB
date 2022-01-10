/** @file rqueue.h
 * General purpose request queue
 */
#ifndef RQUEUE_H_INCLUDED
#define RQUEUE_H_INCLUDED
#include <deque>
#include <cstdarg>

namespace DAS_IO {

  class rqueue_req {
    public:
      rqueue_req();
      /**
       * @param persistent true for poll requests issued periodically,
       *    false for one-time commands.
       * @param device_index application-specific parameter stored in
       *    the request.
       * @param callback_id application-specific parameter stored in
       *    the request.
       * @param fmt printf-style format
       * @param args cstdarg argument packaging variable-length
       *    printf-style arguments
       * @return true if the formatted request string exceeds the
       *    buffer length.
       *
       * It might make sense to encode a request-specific timeout
       * value in the request, but in the interest of making this
       * no more complicated than necessary, I realized that the
       * app could probably either use one timeout value for all
       * requests or key off the callback_id if/when different * *( * timeouts are necessary.
       */
      bool setup(bool persistent, int device_index, int callback_id,
            const char *fmt, va_list args);
      static const int reqstr_len = 80;
      char reqstr[reqstr_len];
      bool persistent;
      int device_index;
      int callback_id;
      int req_sz;
  };

  class rqueue {
    public:
      rqueue();
      // ~rqueue();
      bool enqueue_poll(int device_index, int callback_id,
                        const char *fmt, ...);
      bool enqueue_cmd(int device_index, int callback_id,
                       const char *fmt, ...);
      virtual void requeue_polls();
      void dispose_pending();
      virtual rqueue_req *next_request();
      rqueue_req *pending;
    protected:
      bool enqueue(bool persistent, int device_index, int callback_id,
                  const char *fmt, va_list args);
      std::deque<rqueue_req *> polls;
      std::deque<rqueue_req *>::const_iterator cur_poll;
      std::deque<rqueue_req *> cmds;
      std::deque<rqueue_req *> req_free;
      rqueue_req *new_request();
      void free_request(rqueue_req *req);
  };

}

#endif
