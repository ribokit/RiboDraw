function update_artboards( ~ )

tags = {'artboard_topline','artboard_bottomline','artboard_leftline','artboard_rightline'};
for i = 1:length( tags )
    if isappdata( gca, tags{i} )
        h = getappdata( gca, tags{i} );
        update_artboard_line(h);
    end
end

