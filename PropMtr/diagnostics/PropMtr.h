/** @file PropMtr.h */
#include <stdint.h>

typedef struct __attribute__((__packed__)) {
  uint16_t reg1;
} PropMtr_t;

extern PropMtr_t PropMtr;
