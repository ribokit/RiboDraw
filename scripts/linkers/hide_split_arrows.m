function hide_split_arrows( linker )
% show_split_arrows( linker, setting )
if ~exist( 'linker','var' ) || isempty( linker ); linker = get_tags( 'Linker','interdomain' ); end;
show_split_arrows( linker, 0 );