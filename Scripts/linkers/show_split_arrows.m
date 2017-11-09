function show_split_arrows( linker, setting )
% show_split_arrows( linker, setting )
if ~exist( 'setting','var') setting = 1; end;
if iscell( linker ); for i = 1:length( linker ); show_split_arrows( linker{i}, setting ); end; return; end;

if ischar( linker ); linker = getappdata( gca, linker ); end;
linker.show_split_arrows = setting;
draw_linker( linker );
