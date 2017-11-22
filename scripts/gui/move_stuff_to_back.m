function move_stuff_to_back()
% move_stuff_to_back()
%
%  Its faster to move all tertiary contact graphical elements to 'back' all at once. This
%   is that final big call.
%
%  All the relevant graphics handles need to have field 'send_to_back' or 'send_to_top_of_back' set by previous
%      function in appdata. 
%
% TODO: Could allow levels of 'backness' to be set as integer rather than as back or top_of_back.
%
% See also: SEND_TO_BACK, SEND_TO_TOP_OF_BACK.
%
% (C) R. Das, Stanford University, 2017

x = get( gca, 'Children' );
tic
fprintf( 'Moving graphic elements to back... could take a while.\n' );
send_to_back        = zeros( 1, length(x) );
send_to_top_of_back = zeros( 1, length(x) );
send_to_front       = zeros( 1, length(x) );
for i = 1:length(x)
    if isappdata( x(i), 'send_to_back' )
        send_to_back(i)        = 1;
    elseif isappdata( x(i), 'send_to_top_of_back' )
        send_to_top_of_back(i) = 1;
    else
        send_to_front(i) = 1;
   end
end
set( gca, 'Children', x( [find(send_to_front),find(send_to_top_of_back),find(send_to_back)] ) );
toc