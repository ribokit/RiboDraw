function convert_nucleotide_to_name()
% convert_nucleotide_to_name()
%
% Convert legacy 'nucleotide' field of Residues to 'name'. 
%
%
% (C) R. Das, Stanford University, 2019

res_tags = get_res();
num_updates = 0;
for i = 1:length( res_tags )
    updated = 0;
    residue = getappdata( gca, res_tags{i} );
    if ~isfield( residue, 'name' )
        assert( isfield( residue, 'nucleotide' ) );
        residue.name = residue.nucleotide;
        residue = rmfield( residue, 'nucleotide' );
        updated = 1;
    end
    if ~isfield( residue, 'original_name' )
        assert( isfield( residue, 'name' ) );
        residue.original_name = residue.name;
        updated = 1;
    end    
    if updated;
        setappdata( gca, res_tags{i}, residue );
        num_updates = num_updates + 1; 
    end
end
if ( num_updates > 0 ); fprintf( 'Name field updated from legacy nucleotide field for %d res_tags.\n', num_updates ); end;

