function cleanup_segids();
tags = get_tags( 'Residue_' );
for i = 1:length( tags )
    residue = getappdata( gca, tags{i} );
   if ~isfield( residue, 'segid' );  
        residue.segid = ''; 
        setappdata( gca, tags{i}, residue );
   end;
end

tags = get_tags( 'Helix_' );
for i = 1:length( tags )
    helix = getappdata( gca, tags{i} );
    if ~isfield( helix, 'segid1' );  helix.segid1 = repmat( {''}, [1 length(helix.resnum1)] ); setappdata( gca, tags{i}, helix ); end;
    if ~isfield( helix, 'segid2' );  helix.segid2 = repmat( {''}, [1 length(helix.resnum2)] ); setappdata( gca, tags{i}, helix ); end;
end
