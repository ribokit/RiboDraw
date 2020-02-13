function cleanup_segids();
% cleanup_segids();

tags = get_tags( 'Residue' );
for i = 1:length( tags )
    obj = getappdata( gca, tags{i} );
    if ~isfield( obj, 'segid' )
        obj.segid = '';
        setappdata( gca, tags{i}, obj);
    end;
end

tags = get_tags( 'Helix' );
for i = 1:length( tags )
    obj = getappdata( gca, tags{i} );
    if ~isfield( obj, 'segid1' )
        obj.segid1 = repmat({''},[1,length(obj.resnum1)]);
        obj.segid2 = repmat({''},[1,length(obj.resnum2)]);
        setappdata( gca, tags{i}, obj);
    end;
end
