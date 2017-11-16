function [v,start_pos,pointing_out_of_polygon] = first_crossing( polygon, plot_pos );
% first_crossing( polygon, plot_pos );

v         = plot_pos(2,:) - plot_pos(1,:);
v = v / norm(v);
start_pos = plot_pos(1,:);
pointing_out_of_polygon = 1;

% find crossings
[xi,yi,ii] = polyxpoly( plot_pos(:,1),plot_pos(:,2), polygon(:,1),polygon(:,2) );
if length( xi ) == 0; return; end;

% find first of these crossings -- closest to  residue that starts the
% plot_pos line
for k = 1:length(xi)
    dist_to_residue1(k) = norm( [xi(k) - plot_pos(1,1), yi(k) - plot_pos(1,2) ]);
end

[~,idx] = min( dist_to_residue1 );
start_pos = [xi(idx),yi(idx)];
plot_pos_idx = ii(idx,1);
v = plot_pos(plot_pos_idx+1,:) - plot_pos(plot_pos_idx,:);
v = v / norm(v);

start_pos_nudge_back =  start_pos - 0.01*v;
pointing_out_of_polygon = inpolygon( start_pos_nudge_back(1), start_pos_nudge_back(2),...
                                     polygon(:,1),polygon(:,2));

                                 