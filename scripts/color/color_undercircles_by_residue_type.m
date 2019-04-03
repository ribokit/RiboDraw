function color_undercircles_by_residue_type()
% color_undercircles_by_residue_type()
%
% Create undercircles under A,C,G,U and color by eterna colors
%
% (C) R. Das, Stanford University, 2019

res_tags = get_res();
plot_settings = getappdata(gca,'plot_settings' );
for i = 1:length( res_tags )
    residue = getappdata( gca, res_tags{i} );
    switch residue.nucleotide
        case 'A'
            residue.undercircle_face_color = hex2rgb('#FFE500');
        case 'C'
            residue.undercircle_face_color = hex2rgb('#4FB748');
        case 'G'
            residue.undercircle_face_color = hex2rgb('#F05122');
        case 'U'
            residue.undercircle_face_color = hex2rgb('#3193D1');
    end            
    setappdata( gca, res_tags{i}, residue );
    if isfield(residue,'undercircle_face_color' ); draw_undercircle( residue, plot_settings ); end;
end
move_stuff_to_back;
