function set_boldface( setting )
% set_boldface( setting )
%
% Set nucleotide labels to be boldface or not, depending on setting.
%
% (C) R. Das, Stanford University, 2017

if ~exist( 'setting', 'var' ) setting = 1; end;
res_tags = get_tags( 'Residue' );
if setting == 1; fontweight = 'bold'; else; fontweight = 'normal'; end;

for i = 1:length( res_tags )
    residue = getappdata( gca, res_tags{i} );
    if isfield( residue, 'handle' )
        set( residue.handle, 'fontweight', fontweight );
    end
end

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.boldface = setting;
setappdata( gca, 'plot_settings', plot_settings );
