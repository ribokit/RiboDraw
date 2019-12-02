function color_rings_by_IUPAC( residue_string, IUPAC_symbols )
% color_rings_by_IUPAC( residue_string, IUPAC_symbols )
%
% Create rings around names and color by Anderson-Lee/Fisker/Wellington-Oguri Eterna colors.
%
% INPUTS
%
%  residue_string = format specifying chain[:segid]:res1-res2 like  'A:1-4' or 'C:RA:1-119'
%  IUPAC_symbols  = ABCDGHUVSWRYKMNX symbols for each residue -- length of string must match
%                      residue_string
%
% May be redundant with GET_RES().
%
% (C) R. Das, Stanford University, 2019


res_tags = get_res_tags( residue_string );
if  length( IUPAC_symbols ) > 0 && length( res_tags ) ~= length( IUPAC_symbols ) 
    fprintf( '\nProblem! Number of residues found for residue_string %s is %d, but does not match length of IUPAC_symbols, %d\n', residue_string,length(res_tags),length(IUPAC_symbols))
    return;
end
plot_settings = getappdata(gca,'plot_settings' );
[IUPAC_letters, allowed_letters, IUPAC_Eterna_colors ] = get_IUPAC_info();
for i = 1:length( res_tags )
    if ~isappdata( gca, res_tags{i} ); continue; end;
    residue = getappdata( gca, res_tags{i} );
    if length( IUPAC_symbols ) == 0; 
        IUPAC_symbol = residue.name; 
    else
        IUPAC_symbol = IUPAC_symbols(i);
    end;
    if all( ~strcmp( IUPAC_symbol, IUPAC_letters ) ); continue; end;
    rgb_color = IUPAC_Eterna_colors(IUPAC_symbol);
    residue.ring_color = hex2rgb(rgb_color );
    setappdata( gca, res_tags{i}, residue );
    if isfield(residue,'ring_color' ); draw_fill_and_ring_circle( residue, plot_settings ); end;
end
show_ring_circles;

