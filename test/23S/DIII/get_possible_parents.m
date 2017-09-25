function possible_parents = get_possible_parents( residue )
stems = get_stems();

for n = 1:length( stems )
    dists1_3prime = Inf;
    dists2_3prime = Inf;
    if ( stems{n}.resnum1(1) > residue.resnum ) dists1_3prime = stems{n}.resnum1(1)-residue.resnum; end;
    if ( stems{n}.resnum2(1) > residue.resnum ) dists2_3prime = stems{n}.resnum2(1)-residue.resnum; end;
    dists_3prime(n) = min( dists1_3prime, dists2_3prime );

    dists1_5prime = Inf;
    dists2_5prime = Inf;
    if ( stems{n}.resnum1(end) < residue.resnum ) dists1_5prime = -stems{n}.resnum1(end)+residue.resnum; end;
    if ( stems{n}.resnum2(end) < residue.resnum ) dists2_5prime = -stems{n}.resnum2(end)+residue.resnum; end;
    dists_5prime(n) = min( dists1_5prime, dists2_5prime );
end

possible_parents = {};
[mindist,minidx] = min( dists_3prime );
if ~isinf(mindist) possible_parents = [possible_parents, stems{minidx}.helix_tag ]; end;

[mindist,minidx] = min( dists_5prime );
if ~isinf(mindist) possible_parents = [possible_parents, stems{minidx}.helix_tag ]; end;

assert( length( possible_parents ) > 0 );
if ( length( possible_parents ) == 1 | strcmp(possible_parents{1},possible_parents{2}) )
    helix = getappdata( gca, possible_parents{1} );
end

% sanity check -- residue better have one of these helices as current parent:
assert( any( strcmp( possible_parents, residue.helix_tag ) ) );

current_helix_tag = residue.helix_tag;
other_helix_tag   = possible_parents{ find( strcmp( possible_parents, residue.helix_tag ) == 0 ) };
