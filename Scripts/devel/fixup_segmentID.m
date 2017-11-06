function replace_segid( segid, new_segid );

res_tags = get_tags( 'Residue' );
for i = 1:length( res_tags )
    tag = res_tags{i};
    obj = getappdata( gca, tag );
    obj.segid = segid;
    obj.res_tag = obj.res_tag(1:8)
end
