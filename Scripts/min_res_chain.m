function [reschain, idx] = min_res_chain( reschain1, reschain2 )

if nargin == 1
    pair = reschain1;
    assert( isstruct(pair) );
    [reschain,idx] = min_res_chain(...
        {pair.resnum1, pair.chain1}, ...
        {pair.resnum2, pair.chain2} );
    return;
end

res1   = reschain1{1};
chain1 = reschain1{2};

res2   = reschain2{1};
chain2 = reschain2{2};

if ( chain2 > chain1 ) |  ...
        ( chain2 == chain1 & res2 > res1 )
    reschain = reschain2;
    idx = 1;
else
    reschain = reschain1;
    idx = 2;
end
    
