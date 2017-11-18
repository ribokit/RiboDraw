function show_domain_controls( setting )
if ~exist( 'setting','var') setting = 1; end;
show_selection_controls( setting, 'Domain' );
if ~exist( 'setting', 'var' ) setting = 1; end;
if ~exist( 'selection_tag', 'var' ) selection_tag = ''; end;