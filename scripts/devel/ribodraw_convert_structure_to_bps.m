function bps = convert_structure_to_bps( structure );
%  bps = convert_structure_to_bps( structure );
%
%  INPUTS
%  structure = structure in dot-parens notation, using characters .()[]{}
%              can also specify helices by other characters, like ...aaa...aaa....
%  
%  OUTPUT
%  bps  = matrix of base pairs.
%
% (C) Rhiju Das, Stanford University, 2011-2012, 2017

bps = [];
bps = get_bps( structure, bps, '(', ')' );
bps = get_bps( structure, bps, '[', ']' );
bps = get_bps( structure, bps, '{', '}' );

% allow any other chars to represent additional base pairs
other_chars = setdiff( structure, '()[]{}.' );
for i = 1:length( other_chars )
    pos = find( structure == other_chars(i) );
    assert( mod(length(pos),2) == 0 );
    N = length(pos)/2;
    i = pos(1 : N); % first N
    j = pos(2*N: -1: (N+1) ); % last N are assumed to be pairs
    %assert( i( end ) < j( end )-1 ); % not necessary actually if even
    if ( N > 1 ) % each of the two sets of characters must be contiguous
        assert( all( i(1:end-1)+1 == i(2:end) ) );
        assert( all( j(1:end-1)-1 == j(2:end) ) );
    end
    bps = [bps; i' j' ];
end

function bps = get_bps( structure, bps, left_delim, right_delim );

LEFT_BRACKET = [];
for i = 1:length(structure )
  switch structure(i)
   case left_delim
    LEFT_BRACKET = [LEFT_BRACKET, i];
   case right_delim
    bps = [bps; LEFT_BRACKET(end), i];
    LEFT_BRACKET = LEFT_BRACKET( 1 : end-1 );
  end
end

