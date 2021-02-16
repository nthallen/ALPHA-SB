#ifndef TMSERIO_PKT_H_INCLUDED
#define TMSERIO_PKT_H_INCLUDED

enum tmserio_pkt_type : uint8_t {
  pkt_type_TM = 'T',
  pkt_type_PNG_Start = 'P',
  pkt_type_PNG_Cont = 'N'
};

typedef struct __attribute__((packed)) {
  uint8_t LRC;
  tmserio_pkt_type type;
  uint16_t length;
  uint16_t CRC;
} tmserio_pkt_hdr;

// typedef struct __attribute__((packed)) {
  // tmserio_pkt_hdr hdr;
  // uint8_t payload[0];
// } tmserio_pkt;

#endif
