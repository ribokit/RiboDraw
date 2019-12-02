function move_stuff_to_back()
% move_stuff_to_back()
%
%  Its faster to move all tertiary contact graphical elements to 'back' all at once. This
%   is that final big call.
%
%  All the relevant graphics handles need to have field 'layer_level', with
%     0 as front layer, 1 as next layer, etc.
%
% See also:  SEND_TO_TOP_OF_BACK (layer 1), SEND_TO_MIDDLE_OF_BACK (layer 2),  SEND_TO_BACK (layer 3)
%
% (C) R. Das, Stanford University, 2017, 2019

x = get( gca, 'Children' );
tic
fprintf( 'Moving graphic elements to back... could take a while.\n' );
layer_level = zeros(1,length(x));
for i = 1:length(x)
    if isappdata( x(i), 'layer_level' )
        layer_level(i) = getappdata(x(i),'layer_level');
    elseif isappdata( x(i), 'send_to_back' ) % legacy
        layer_level(i)       = 3;
    elseif isappdata( x(i), 'send_to_middle_of_back' ) % legacy
        layer_level(i)       = 2;
    elseif isappdata( x(i), 'send_to_top_of_back' ) % legacy
        layer_level(i)       = 1;
    else
        layer_level(i) = 0;
   end
end
[~,reorder] = sort( layer_level );
set( gca, 'Children', x( reorder ) );
toc