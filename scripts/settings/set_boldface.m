function set_boldface( setting, res_tags )
% set_boldface( setting )
%
% Set name labels to be boldface or not, depending on setting.
%
% (C) R. Das, Stanford University, 2017

if ~exist( 'setting', 'var' ) setting = 1; end;

% if you don't pass res_tags, get all residues.
if nargin < 2
    res_tags = get_tags( 'Residue' );
end;

if setting == 1; fontweight = 'bold'; else; fontweight = 'normal'; end;

for i = 1:length( res_tags )
    residue = getappdata( gca, res_tags{i} );
    if isfield( residue, 'handle' )
        set( residue.handle, 'fontweight', fontweight );
    end
end

% Only change the global plot_settings if res_tags not specified
if nargin < 2
    plot_settings = getappdata( gca, 'plot_settings' );
    plot_settings.boldface = setting;
    setappdata( gca, 'plot_settings', plot_settings );
end;
