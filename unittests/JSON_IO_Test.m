% setupTests
load_drawing( 'testdata/drawing.json' );
if exist( 'tempdrawing.json', 'file' ) delete( 'tempdrawing.json' ); end;
%% Check load
assert( length(get_tags( 'Residue' ))==76 );
assert( length(get_tags( 'Helix' ))  ==4 );

%% Save and load tempdrawing.json
save_drawing( 'tempdrawing.json' );
assert( length(get_tags( 'Residue' ))==76 ); 
assert( length(get_tags( 'Helix' ))  ==4 );
assert( ~isempty(exist( 'tempdrawing.json', 'file' )) );

clf;
assert( length(get_tags( 'Residue' ))==0 );
assert( length(get_tags( 'Helix' ))  ==0 );

load_drawing( 'tempdrawing.json' );
assert( length(get_tags( 'Residue' ))==76 ); 
assert( length(get_tags( 'Helix' ))  ==4 );

delete( 'tempdrawing.json' );
assert( ~exist( 'tempdrawing.json', 'file' )  );