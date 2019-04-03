function color_rings_by_IUPAC( residue_string, IUPAC_symbols )
% color_rings_by_IUPAC( residue_string, IUPAC_symbols )
%
% Create rings around nucleotides and color by Anderson-Lee/Fisker/Wellington-Oguri Eterna colors.
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

IUPAC_letters = {'A', 'B', 'C', 'D', 'G', 'H', 'U', 'V', 'S', 'W', 'R', 'Y', 'K', 'M', 'N', 'X'};
IUPAC_Eterna_colors = containers.Map( ...
{'A',      'B',      'C',      'D',      'G',      'H',      'U',      'V',      'S',      'W',      'R',      'Y',      'K',      'M',      'N',      'X'},...
{'#f0d000','#504060','#00a000','#502050','#a00000','#206060','#3080d0','#808000','#c09000','#555555','#ffa000','#00c0c0','#800080','#a0d000','#d0d0d0','#ff0000'} );

allowed_letters = containers.Map( ...
    {'A',  'B','C',  'D','G',  'H','U',  'V', 'S', 'W', 'R', 'Y', 'K', 'M',   'N', 'X'},...
    {'A','CGU','C','AGU','G','ACU','U','ACG','CG','AU','AG','CU','GU','AC','ACGU',''} );

res_tags = get_res_tags( residue_string );
if  length( IUPAC_symbols ) > 0 && length( res_tags ) ~= length( IUPAC_symbols ) 
    fprintf( '\nProblem! Number of residues found for residue_string %s is %d, but does not match length of IUPAC_symbols, %d\n', residue_string,length(res_tags),length(IUPAC_symbols))
    return;
end
plot_settings = getappdata(gca,'plot_settings' );
for i = 1:length( res_tags )
    if ~isappdata( gca, res_tags{i} ); continue; end;
    residue = getappdata( gca, res_tags{i} );
    if length( IUPAC_symbols ) == 0; 
        IUPAC_symbol = residue.nucleotide; 
    else
        IUPAC_symbol = IUPAC_symbols(i);
    end;
    if all( ~strcmp( IUPAC_symbol, IUPAC_letters ) ); continue; end;
    rgb_color = IUPAC_Eterna_colors(IUPAC_symbol);
    residue.undercircle_ring_color = hex2rgb(rgb_color );
    setappdata( gca, res_tags{i}, residue );
    if isfield(residue,'undercircle_ring_color' ); draw_undercircle( residue, plot_settings ); end;
end
move_stuff_to_back;

