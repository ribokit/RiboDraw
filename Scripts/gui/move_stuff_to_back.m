function move_stuff_to_back()
% move_stuff_to_back()
%  should be faster to move all tertiary contact linkers to 'back' all at once
%  all the relevant graphics handles need to have field 'send_to_back'
%  defined in appdata -- created in draw_linker() calles to send_to_back().
x = get( gca, 'Children' );

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

