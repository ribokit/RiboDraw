function move_selection_label(h)

pos = get(h,'position'); 
selection_tag = getappdata( h, 'selection_tag' );
selection = getappdata( gca, selection_tag );
rectpos = get( selection.rectangle, 'position' );
rect_ctr = [rectpos(1)+rectpos(3)/2, rectpos(2)+rectpos(4)/2];
selection.label_relpos = pos(1:2) - rect_ctr;
setappdata( gca, selection_tag, selection );