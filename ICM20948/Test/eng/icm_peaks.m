classdef icm_peaks < data_axis
  properties
  end
  methods
    function pks = icm_peaks(dfs, parent, label, ts)
      pks = pks@data_axis(dfs, parent, label, ts);
    end

  end
end
