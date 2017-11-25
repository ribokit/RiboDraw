function [v,start_pos,pointing_out_of_polygon] = first_crossing( polygon, plot_pos );
% first_crossing( polygon, plot_pos );
%
%  Used in drawing split arrows that need to peek out from under
%    silhouette images of proteins (or other ligands).
%
%  Figure out if the line emanating from the ligand is passing out of
%    the silhouette image_boundary and, if so, where does this happen.
%
% Inputs:
%   polygon  = M X 2 trajectory defining the silhouette of the protein (image_boundary)
%   plot_pos = N x 2 line pointing out of ligand to its partner residue.
%
% Outputs:
%  v         = unit vector pointing out of first crossing.
%  start_pos = point of first crossing
%  pointing_out_of_polygon = 1 or 0 if pointing out or into image ilhouette.
%
%
%
% (C) R. Das, Stanford University, 2017

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

                                 