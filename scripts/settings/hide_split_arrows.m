function hide_split_arrows( linker )
% hide_split_arrows( linker )
%
% Hide colored arrows at beginning and end of interdomain linkers to avoid
%  clutter in the drawing.
% 
% (C) R. Das, Stanford University, 2017

if ~exist( 'linker','var' ) || isempty( linker ); linker = get_tags( 'Linker','interdomain' ); end;
show_split_arrows( linker, 0 );