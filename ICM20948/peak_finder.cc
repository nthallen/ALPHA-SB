/* peak_finder.cc */
#include "peak_finder.h"

peak_finder::peak_finder(int n_raw, int max_peaks)
  : Lin(n_raw),
    Lout(n_raw/2+1),
    max_peaks(max_peaks),
    in(0), out(0), nout(0) {
  peak_amp = new double[max_peaks];
  peak_freq = new uint16_t[max_peaks];
}

void peak_finder::setup() {
  in = (double*) fftw_malloc(3*Lin*sizeof(double));
  out = (fftw_complex*) fftw_malloc(3*Lout*sizeof(fftw_complex));
  nout = (double*) fftw_malloc(Lout*sizeof(double));
  plan = fftw_plan_many_dft_r2c(1, &Lin, 3, in, 0, // rank, n, in, inembed
      3, 1, // istride, idist
      out, 0, // out, onembed
      3, 1, // ostride, odist
      FFTW_MEASURE);
}

peak_finder::~peak_finder() {
  if (in != 0) {
    fftw_destroy_plan(plan);
    fftw_free(in);
    fftw_free(out);
    fftw_free(nout);
    in = 0;
    delete(peak_amp);
    delete(peak_freq);
  }
}

void peak_finder::do_fft(int16_t *raw) {
  // I will perform the FFT without scaling to full scale,
  // so full scale will be +/- 1. I will add the fs scaling
  // on extraction
  for (int j = 0; j < Lin; ++j) {
    for (int k = 0; k < 3; ++k) {
      set_injk(j,k, raw[j*3+k]/32768.);
    }
  }
  fftw_execute(plan);
  // No process the results
  for (int j = 0; j < Lout; ++j) {
    nout[j] = sqrt(
      outjk(j,0,0)*outjk(j,0,0) + outjk(j,0,1)*outjk(j,0,1) +
      outjk(j,1,0)*outjk(j,1,0) + outjk(j,1,1)*outjk(j,1,1) +
      outjk(j,2,0)*outjk(j,2,0) + outjk(j,2,1)*outjk(j,2,1)) / Lin;
  }
  // Now find the peaks
  int n_peaks = 0;
  for (int freqi = 1; freqi < Lout; ++freqi) {
    if (nout[freqi-1] < nout[freqi] &&
        (freqi < Lout-1 || nout[freqi] > nout[freqi+1])) {
      // add_peak(fregi, nout[freqi]);
      int newi;
      if (n_peaks < max_peaks) {
        newi = n_peaks++;
      } else for (newi = 0; newi < max_peaks; ++newi) {
        if (nout[freqi] > peak_amp[newi]) break;
      }
      if (newi < max_peaks) {
        peak_amp[newi] = nout[freqi];
        peak_freq[newi] = freqi;
      }
    }
  }
  while (n_peaks < max_peaks) {
    peak_amp[n_peaks] = 0.;
    peak_freq[n_peaks] = 1000;
    ++n_peaks;
  }
}
