function show_noncanonical_pairs( setting )
% show_noncanonical_pairs( setting );
%
% Show or hide lines with Leontis-Westhof symbol for noncanonical pairs, based on 
%    whether setting is 1 or 0.
%
% (C) R. Das, Stanford University, 2017

if ~exist( 'setting', 'var' ) setting = 1; end;
if setting; visible = 'on'; else; visible = 'off'; end;
noncanonical_tags = get_tags( 'Linker_', 'noncanonical_pair' );
for i = 1:length( noncanonical_tags )
    tag = noncanonical_tags{i};
    linker = getappdata( gca, tag );
    linker = set_linker_visibility( linker, visible );
 end
