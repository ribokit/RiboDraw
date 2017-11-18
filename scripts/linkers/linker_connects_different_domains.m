function val = linker_connects_different_domains( residue1, residue2 )

val = ~strcmp(residue1.chain,residue2.chain) | ...
      ~strcmp(residue1.segid,residue2.segid);

  if ~val & isfield( residue1, 'rgb_color' ) & isfield( residue2, 'rgb_color' ) 
    val = ( length(unique( residue1.rgb_color)) > 1 & ...
            length(unique( residue2.rgb_color)) > 1 &  ...
            ( norm( residue1.rgb_color - residue2.rgb_color ) >= 0.1 ) );
end