function update_non_standard_names();
% update_non_standard_names();
% Go through all residues and see if we can find a better
%  name based on e.g., a 3-letter code given as 'nucleotide'
%
% (C) R. Das, Stanford University

res_tags = get_tags( 'Residue' );
for i = 1:length(res_tags)
    residue = getappdata( gca, res_tags{i} );
    name = get_preferred_display_name( residue.nucleotide );
    if ~strcmp( 'name', 'X' ) & ~strcmp( name, residue.nucleotide )
        fprintf( 'Converting %s to %s\n', residue.nucleotide, name );
        residue.nucleotide = name;;
        if isfield( residue, 'handle' ) 
            set( residue.handle, 'string', name );
        end
        setappdata( gca, res_tags{i}, residue );
    end
end

