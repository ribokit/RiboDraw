function cleanup_long_range_stem_pairs()
% cleanup_long_range_stem_pairs()
%  used to have stem_pairs with noncanonical_pair type 
%  and that was confusing. better to call them something else entirely.

tags = get_tags( 'Linker','stem_pair' );
update_tags = {};
for i = 1:length(tags)
    linker = getappdata( gca, tags{i} );
    if strcmp( linker.type, 'noncanonical_pair' ) |  strcmp( linker.type, 'long_range_stem_pair' )
        update_tags = [ update_tags, tags{i}];
    end
end

for i = 1:length( update_tags )
    tag = update_tags{i};
    linker = getappdata( gca, tag );
    if isempty(strfind(tag, 'long_range_stem_pair' )) new_tag = strrep( tag, '_stem_pair', '_long_range_stem_pair' ); end;
    linker.linker_tag = new_tag;
    linker.type = 'long_range_stem_pair';
    set_linker_visibility( linker, 'on' );
    replace_linker( tag, new_tag, linker );
end

tags = get_tags( 'Linker','long_range_stem_pair' )
for i = 1:length( tags )
    draw_linker( getappdata( gca, tags{i} ) );
end

