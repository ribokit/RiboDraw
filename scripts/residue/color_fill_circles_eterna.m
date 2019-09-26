function color_fill_circles_eterna()
% color_undercircles_by_residue_type()
%
% Create undercircles under A,C,G,U and color by eterna colors
% These colors were taken using Mac OS Digital Color Meter off
%   bitmaps actually used in Eterna low-graphics mode.
%
% (C) R. Das, Stanford University, 2019

res_tags = get_res();
plot_settings = getappdata(gca,'plot_settings' );
for i = 1:length( res_tags )
    residue = getappdata( gca, res_tags{i} );
    switch residue.name
        case 'A'
            residue.fill_color = [244,194,92]/255; 
        case 'C'
            residue.fill_color = [69,129,71]/255;
        case 'G'
            residue.fill_color = [160,44,40]/255;
        case 'U'
            residue.fill_color = [53,119,175]/255;
    end            
    residue.ring_color = [0.7 0.7 0.7];
    setappdata( gca, res_tags{i}, residue );
    if isfield(residue,'fill_color' ); draw_fill_and_ring_circle( residue, plot_settings ); end;
end
show_fill_and_ring_circles();
