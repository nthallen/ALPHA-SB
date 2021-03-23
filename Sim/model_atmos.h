#ifndef MODEL_ATMOS_H_INCLUDED
#define MODEL_ATMOS_H_INCLUDED
#include <vector>

class model_atmos {
  public:
    static bool get_PT(double kmt, double &hPa, double &K);
    struct model_row {
      double km;
      double K;
      double hPa;
      double lnhPa;
    };
    static std::vector<model_row> table;
};

#endif
