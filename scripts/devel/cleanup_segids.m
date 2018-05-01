function loaddata = cleanup_segids( loaddata );
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
    for j = 1:length( helix.segid1 )
        if isempty( helix.segid1{j} ) helix.segid1{j} = ''; end;
        if isempty( helix.segid2{j} ) helix.segid2{j} = ''; end;
    end
    if exist( 'loaddata', 'var' ) loaddata = setfield( loaddata, helix.helix_tag, helix); end
    setappdata( gca, helix.helix_tag, helix);
end
