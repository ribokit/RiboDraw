function show_split_arrows( linker, setting, domain_names )
% show_split_arrows( linker, setting, domain_names )
%
% Show colored arrows at beginning and end of interdomain linkers to avoid
%  clutter in the drawing.
%
% Inputs:
%
%   linker       = Linker object or tag ('Linker_*_interdomain') that connects across two different domains (default: all interdomain linker tags)
%   setting      = 1/0 to show/hide 
%   domain_names = apply only to linkers that cross two of the domains specified in this cell of names {'Peptidyl Transferase Center','Domain IV',...}
%
% See also: SHOW_SPLIT_ARROW_LINES
% 
% (C) R. Das, Stanford University, 2017

if ~exist( 'setting','var') setting = 1; end;
if ~exist( 'domain_names' ) domain_names = {}; end;
if ~exist( 'linker','var' ) || isempty( linker ); linker = get_tags( 'Linker','interdomain' ); end;
if iscell( linker ); for i = 1:length( linker ); show_split_arrows( linker{i}, setting, domain_names ); end; return; end;
if ischar( linker ); linker = getappdata( gca, linker ); end;
if ~isempty( domain_names ) > 0 && isempty( get_interdomain_linkers( {linker.linker_tag}, domain_names ) ) return; end;

linker.show_split_arrows = setting;
draw_linker( linker );
