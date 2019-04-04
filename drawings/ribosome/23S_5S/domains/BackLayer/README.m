% load_drawing( '../DIII/drawing.json' )
% import_drawing( '../DI/drawing.json' )

tag = '4ybb_DI_DIII.pdb';
base_pairs = read_base_pairs( [tag,'.base_pairs.txt'] ); % includes noncanonical pairs.
base_stacks = read_base_stacks( [tag,'.stacks.txt'] ); % includes noncanonical pairs.

setup_base_stack_linkers( base_stacks );
setup_base_pair_linkers( base_pairs );
