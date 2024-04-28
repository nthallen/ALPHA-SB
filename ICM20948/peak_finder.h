#ifndef PEAK_FINDER_H_INCLUDED
#define PEAK_FINDER_H_INCLUDED
#include <cstdint>
#include <math.h>
#include "fftw3.h"

class peak_finder {
  public:
    peak_finder(int n_raw, int n_peaks);
    ~peak_finder();
    void setup();
    void do_fft(int16_t *raw);
    const int Lin;
    const int Lout;
    const int max_peaks;
    double *in;
    fftw_complex *out;
    double *nout;
    double *peak_amp;
    uint16_t *peak_freq;
    fftw_plan plan;
  protected:
    inline double injk(int j, int k) { return in[j*3+k]; }
    inline void set_injk(int j, int k, double v) { in[j*3+k] = v; }
    inline double outjk(int j, int k, int m) { return out[j*3+k][m]; }
};

extern peak_finder pf;

#endif
