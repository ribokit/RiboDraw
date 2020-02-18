x = ribodraw_make_tag_with_dashes( [-1,0,1,5,6,9,12]);
assert( strcmp( x,  '-1-1 5-6 9 12') );

x = ribodraw_make_tag_with_dashes( [-1,0,1,5,6,9,12],'A');
assert( strcmp( x,  'A:-1-1 A:5-6 A:9 A:12')  );

x = ribodraw_make_tag_with_dashes( [-1,0,1,5,6,9,12],'AAABBBB');
assert( strcmp( x, 'A:-1-1 B:5-6 B:9 B:12')  );

x = ribodraw_make_tag_with_dashes( [-1,0,1,5,6,9,12],'AAABBBB','QX');
assert( strcmp( x, 'A:QX:-1-1 B:QX:5-6 B:QX:9 B:QX:12')  );

x = ribodraw_make_tag_with_dashes( [-1,0,1,5,6,9,12],'AAAAAAA',{'QX','QX','QX','QY','QY','QY','QY'});
assert( strcmp( x, 'A:QX:-1-1 A:QY:5-6 A:QY:9 A:QY:12')  )