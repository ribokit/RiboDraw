function send_to_top_of_back( h  )
% send_to_back( handle )
%
%  Its faster to move all tertiary contact graphical elements to 'back' all at once. This
%   function sets appdata for the handle so that it will move to top of back when move_stuff_to_back() is called.
%
%  That is, the handle will move behind all elements except the ones that were sent to back. This is kind of a middle layer.
%
%  For examples, see DRAW_LINKER.
%
% (C) R. Das, Stanford University, 2017

% what we used to do. Extremely slow MATLAB function.
%uistack( h, 'bottom' );

%setappdata( h, 'send_to_back', 1 );
setappdata( h, 'layer_level', 1 );



