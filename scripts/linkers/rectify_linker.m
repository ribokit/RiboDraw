function linker = rectify_linker( linker, overwrite );
% linker = rectify_linker();
% linker = rectify_linker( linker );
% linker = rectify_linker( linker, overwrite );
%
%  Applies a super-simple heuristic to adjust segments of a linker that are close
%    to horizontal or vertical to actually be vertical or horizontal.
%
%  The cutoff for 'close' is 10 degrees (defined by ANGLE_CUTOFF inside function).
%
%  Specify overwrite = 0 to just do a test. I ended up just making this
%    run always by default after a linker edit.
%
% (C) R. Das, Stanford University, 2017

if ~exist( 'linker', 'var' ) || isempty(linker); linker = get_tags( 'Linker' ); end;
if ~exist( 'overwrite', 'var' ) overwrite = 1; end;
if ischar( linker ); rectify_linker( getappdata( gca, linker ), overwrite ); return; end;
if iscell( linker ); for i = 1:length( linker ); rectify_linker( linker{i}, overwrite ); end; return; end;

if ~isfield( linker, 'plot_pos' ) return; end;
if size( linker.plot_pos, 1 ) <= 2; return; end;

updated = 0;
linker_save = linker;

% how close to vertical/horizontal the linker needs to be to apply
% rectification.
ANGLE_CUTOFF = 10; % degrees
SLOPE_CUTOFF = tan( ANGLE_CUTOFF * (pi/180) );

% forward pass 
for i = 1:size( linker.relpos1, 1 )
    % don't try to rectify endpoint
    if ( i + 1 == size( linker.plot_pos, 1 ) ) continue; end; 
    v = linker.plot_pos( i+1,: ) - linker.plot_pos(i,: );
    angle = atan2( v(2), v(1) ) * 180/pi;
    if ( abs(v(2)/v(1)) < SLOPE_CUTOFF && abs(v(2)/v(1)) > 1e-5)
        linker.plot_pos( i+1, 2 ) =  linker.plot_pos(i, 2 );
        updated = 1;
    elseif abs(v(1)/v(2)) < SLOPE_CUTOFF && abs(v(1)/v(2)) > 1e-5
        linker.plot_pos( i+1, 1 ) =  linker.plot_pos(i, 1 );
        updated = 1;
    end
    angle = atan2( v(2), v(1) ) * 180/pi;
end

% backward pass 
n1 = size( linker.relpos1, 1 );
for i = 1:size( linker.relpos2, 1 )
    % don't try to rectify endpoint
    if ( n1+i-1 == 1 ) continue; end; 
    v = linker.plot_pos( n1+i-1,: ) - linker.plot_pos( n1+i,: );
    angle = atan2( v(2), v(1) ) * 180/pi;
    if ( abs(v(2)/v(1)) < SLOPE_CUTOFF && abs(v(2)/v(1)) > 1e-5)
        linker.plot_pos(  n1+i-1, 2 ) =  linker.plot_pos( n1+i, 2 );
        updated = 1;
    elseif abs(v(1)/v(2)) < SLOPE_CUTOFF && abs(v(1)/v(2)) > 1e-5
        linker.plot_pos(  n1+i-1, 1 ) =  linker.plot_pos( n1+i, 1 );
        updated = 1;
    end
    angle = atan2( v(2), v(1) ) * 180/pi;
end


if updated
    residue1 = getappdata(gca,linker.residue1);
    helix1   = getappdata(gca,residue1.helix_tag );
    for i = 1:size( linker.relpos1, 1 )
        linker.relpos1(i,:) = get_relpos( linker.plot_pos(i,:), helix1 );
    end
     
    residue2 = getappdata(gca,linker.residue2);
    helix2   = getappdata(gca,residue2.helix_tag );
    for i = 1:size( linker.relpos2, 1 )
        linker.relpos2(i,:) = get_relpos( linker.plot_pos(i+n1,:), helix2 );
    end
    
    linker = draw_linker( linker ); 

    if ~overwrite 
        pause; linker = draw_linker( linker_save );
    end
end

