function color_fill_circles_eterna()
% color_undercircles_by_residue_type()
%
% Create undercircles under A,C,G,U and color by eterna colors
%
% (C) R. Das, Stanford University, 2019

res_tags = get_res();
plot_settings = getappdata(gca,'plot_settings' );
for i = 1:length( res_tags )
    residue = getappdata( gca, res_tags{i} );
    switch residue.name
        case 'A'
            residue.fill_color = hex2rgb('#FFE500');
        case 'C'
            residue.fill_color = hex2rgb('#4FB748');
        case 'G'
            residue.fill_color = hex2rgb('#F05122');
        case 'U'
            residue.fill_color = hex2rgb('#3193D1');
    end            
    residue.ring_color = [0.7 0.7 0.7];
    setappdata( gca, res_tags{i}, residue );
    if isfield(residue,'fill_color' ); draw_fill_and_ring_circle( residue, plot_settings ); end;
end
show_fill_and_ring_circles();
