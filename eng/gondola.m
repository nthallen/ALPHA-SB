classdef gondola < data_axis
  properties
    Off % Offset matrix
    vgain
    heading
    course
    track
    v_fwd
    gon_shp
    heading_ln
    course_ln
    track_ln
    gon_ln
    path_ln
  end
  methods
    function gon = gondola(dfs, parent, label, ts)
      gon = gon@data_axis(dfs, parent, label, ts);
      
      % ref_offset is vector to apply a post-flight adjustment
      % to move the reported position relative to the CG.
      % gon.Off is a 2x2 matrix such that gon.R*gon.Off will
      % produce ref_offset rotated by heading.
      % ref_offset = [0, 0];
      % gon.Off = [ref_offset; [ref_offset(2) -ref_offset(1)]];
      gon.Off = [];
      gon.vgain = 3;

      gon.heading = [];
      gon.course = [];
      gon.track = [];

      gon.path_ln = [];
      gon.gon_ln = [];
      gon.heading_ln = [];
      gon.course_ln = [];
      gon.track_ln = [];
      gon.gon_shp = gon.payload_shp;
    end

    function check_validity(~, ~)
    end

    function update(gon, rec_name)
      % Don't do anything until we have all our data_lines
      % What data are we using?
      % east_m, north_m, heading, Nav_Course, Track, velocity_forward
      %
      % We only use the current value for heading/course/track
      % Everything but Nav_Course is 10Hz, so let's only
      % draw at 10Hz.
      % Alternately, we could draw at 1 Hz if that was significantly
      % easier on the processor

      if isfield(gon.linesbyrec,rec_name) % if we are plotting any data
        dr = gon.dfs.records.records.(rec_name);
        [~,V] = dr.time_vector(gon.timespan);

        D = dr.data_vector('Nav_Course', V);
        if ~isempty(D); gon.course = D(end); end

        D = dr.data_vector('Track', V);
        if ~isempty(D); gon.track = D(end); end

        D = dr.data_vector('velocity_forward',V);
        if ~isempty(D); gon.v_fwd = D(end); end

        D = dr.data_vector('heading', V);
        if ~isempty(D)
          gon.heading = D(end);
          if isempty(gon.Off)
            posoff = 0;
          else
            posoff = [ cosd(gon.heading) sind(gon.heading) ] * gon.Off;
          end
        end
        
        X = dr.data_vector('east_m',V);
        if ~isempty(X)
          Y = dr.data_vector('north_m',V);
          pos = [X Y] + posoff;

          % Trace the position of the center of the payload
          % Display payload
          % Display heading arrow
          % Display track arrow
          % Display course arrow
          if isempty(gon.path_ln)
            gon.path_ln = plot(gon.axis, pos(:,1), pos(:,2));
            set(gon.axis,'DataAspectRatio',[1 1 1],'XGrid','on','YGrid','on');
          else
            gon.path_ln.XData = pos(:,1);
            gon.path_ln.YData = pos(:,2);
          end
          curpos = pos(end,:);
          gon.gon_ln = ...
            gon.shape(gon.gon_ln,gon.gon_shp,gon.heading,curpos,'k');
          len = (1.25/2)*0.75;
          gon.heading_ln = ...
            gon.arrow(gon.heading_ln,curpos,gon.heading,len,'r');
          gon.track_ln = ...
            gon.arrow(gon.track_ln,curpos,gon.track, ...
              gon.vgain*gon.v_fwd,'b');
          gon.course_ln = ...
            gon.arrow(gon.course_ln,curpos,gon.course,len,'m');
          
          % Update the limits
          % I want to have limits at least 2.5 meters from the reference position. As
          % the reference position moves, we have to zoom out a bit.
          xposlim = [ min(pos(:,1)) max(pos(:,1))];
          yposlim = [ min(pos(:,2)) max(pos(:,2))];
          xposrange = diff(xposlim);
          yposrange = diff(yposlim);
          posrange = max(xposrange,yposrange)+5;
          gon.axis.XLim = xposlim+(posrange-xposrange)*[-1 1]/2;
          gon.axis.YLim = yposlim+(posrange-yposrange)*[-1 1]/2;
        end
      end
    end

    function set_timespan(da, ts)
      da.timespan = ts;
      % set(da.axis,'xlim',seconds([-da.timespan 0]));
      da.redraw();
    end

    function ln_out = shape(gon, ln, shp, heading, pos, color)
      % shape(ax, shp, pos, heading, color)
      % ax: axes on which to draw
      % shp: Nx2 shape definition X and Y columns in meters
      % heading: angle in degrees to rotate the shape
      % pos: [x,y] offset applied after rotation, in meters
      % color: standard plot() line type character string
      if ~isempty(heading)
        R = [cosd(heading), -sind(heading); sind(heading) cosd(heading)];
        if size(shp,2) ~= 2
          error('Bad shape');
        end
        shp = shp*R;
        shp = shp + ones(size(shp,1),1)*pos;
        if isempty(ln)
          hold(gon.axis,'on');
          ln_out = plot(gon.axis,shp(:,1),shp(:,2),color);
          hold(gon.axis,'off');
        else
          ln.XData = shp(:,1);
          ln.YData = shp(:,2);
          ln_out = ln;
        end
      else
        ln_out = ln;
      end
    end
    
    function ln_out = arrow(gon, ln, pos, heading, len, color)
      ln_shp = gon.shape(ln, gon.arrow_shp(len), heading, pos, color);
      if nargout >= 1; ln_out = ln_shp; end
    end
    
  end

  methods(Static)
    function shp = arrow_shp(len)
      shp = [
         0, 0
         0, len
        -0.04*len, 0.9*len
         0.04*len, 0.9*len
         0, len
        ];
    end

    function [shp,gps_off_out,hw_out] = payload_shp
      % [shp, gps_offset,hw] = payload_shp;
      % shp is a Nx2 matrix with XY coordinates of the unrotated shape.
      % gps_offset is the (X,Y) offset from the nominal CG to the
      % SpatialDual's reference position. That reference defaults to
      % the center of the SpatialDual box, but can be configured to
      % report to another location on the payload. It is our intention
      % to move the reference position to the nominal CG. In this case,
      % gps_offset will be [0,0].
      hw = 1.25/2; % main cube half width
      bhl = hw+1.24; % beam half length
      bw = 0.067; % beam width
      by = -hw + 0.195; % aft face of the beam
      pdy = -0.168; % prop offset from aft face of beam
      pr = 0.2; % arbitrary prop radius
      gps_offset = [0, 0];
      shp = [
        -hw, -hw
        -hw,  hw
         hw,  hw
         hw, -hw
        -hw, -hw
        NaN, NaN
        -bhl, by
         bhl, by
         bhl, by+pdy
         bhl+pr, by+pdy
         bhl-pr, by+pdy
         bhl, by+pdy
         bhl, by+bw
         -bhl, by+bw
         -bhl, by+pdy
         -bhl+pr, by+pdy
         -bhl-pr, by+pdy
         -bhl, by+pdy
        ];
      shp = shp - ones(size(shp,1),1)*gps_offset;
      if nargout > 1; gps_off_out = gps_offset; end
      if nargout > 2; hw_out = hw; end
    end
  end
end
