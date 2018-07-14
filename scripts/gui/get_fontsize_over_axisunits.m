function scalefactor = get_fontsize_over_axisunits();
% get_fontsize_over_axisunits()
%
% (C) R. Das, Stanford University, 2017-2018

% there must be a better way to do this, but I don't know how.
window_position = get(gcf,'pos' );
window_size = window_position(3:4);

xlim = get(gca,'xlim' );
ylim = get(gca,'ylim');
axis_size = [xlim(2) - xlim(1), ylim(2) - ylim(1) ];

% external script that handles logic of figuring out the
%  *actual* axis limits displayed after, e.g., axis equal.
boxpos = plotboxpos();
boxpos_size = boxpos(3:4);
scalefactor = window_size./(axis_size./boxpos_size);
%assert( abs( scalefactor(2)/scalefactor(1) - 1 ) < 1e-3 );
scalefactor = scalefactor(1);

