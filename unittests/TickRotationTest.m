% setupTests
load_drawing( 'testdata/drawing.mat' );
hide_linker_controls(); % appears necessary!

%% save_drawing
[best_tickrot,scores,sample_tickrot] = autorefine_ticks(get_res('A:40'));
assert( best_tickrot == 90 );
[best_tickrot,scores,sample_tickrot] = autorefine_ticks(get_res('A:30'));
assert( best_tickrot == 270 );
[best_tickrot,scores,sample_tickrot] = autorefine_ticks(get_res('A:10'));
assert( best_tickrot == 315 );