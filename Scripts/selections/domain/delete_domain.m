function setup_domain( name );
% setup_domain( residue_string, name );
% (C) Rhiju Das, Stanford University, 2017

delete_tag = get_domain_tag( name );

if isappdata( gca, delete_tag )
    domain = getappdata( gca, delete_tag );
    
    for j = 1:length( domain.associated_residues )
        residue_tag = domain.associated_residues{j};
        residue = getappdata( gca, residue_tag );
        if ~isfield( residue, 'associated_selections' )
            residue.associated_selections = {};
        end
        residue.associated_selections = setdiff( residue.associated_selections, delete_tag );
        setappdata( gca, residue_tag, residue );
    end
    
    if isfield( domain,'label' ); delete( domain.label ); end;
    if isfield( domain,'rectangle' ); delete( domain.rectangle ); end;
    rmappdata( gca, delete_tag );
    
else % do some cleanup
      res_tags = get_tags( 'Residue_' );      
      for i = 1:length( res_tags )
          res_tag = res_tags{i};
          residue = getappdata( gca, res_tag );
          if isfield( residue, 'associated_selections' )
              if any( strcmp( residue.associated_selections, delete_tag ) )
                  fprintf( 'Cleaning up %s\n', res_tag );
                  residue.associated_selections = setdiff( residue.associated_selections, delete_tag );
                  setappdata( gca, res_tag, residue );
              end
          end
      end
end
