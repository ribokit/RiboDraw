function stem = setup_stem( stem );
%  setup_stem( stem );
%
% Creates new stem, bringing in associated residues.
% Run this script to create a stem *after* drawing is finished, e.g.
%  to remodel stems. 
%
%  stem = stem object with fields like:
%
%    resnum1: [17 18 19]
%     chain1: 'BBB'
%     segid1: {'V'  'V'  'V'}
%    resnum2: [916 917 918]
%     chain2: 'BBB'
%     segid2: {'V'  'V'  'V'}
%       name: 'h2'
%
% (C) R. Das, Stanford University, 2019

N = length( stem.resnum1 );
associated_residues = {};
centers = [];
for k = 1:N
    res_tag1 = sanitize_tag(sprintf( 'Residue_%s%s%d', stem.chain1(k), stem.segid1{k}, stem.resnum1(k) );
    res_tag2 = sanitize_tag(sprintf( 'Residue_%s%s%d', stem.chain2(N-k+1), stem.segid2{N-k+1}, stem.resnum2(N-k+1) );
    associated_residues = [associated_residues, {res_tag1,res_tag2}];
    residue1 = getappdata(gca,res_tag1);
    residue2 = getappdata(gca,res_tag2);
    centers = [ centers; residue1.plot_pos; residue2.plot_pos ];
end
stem.center = mean( centers );
stem.rotation = 0; % this could be smarter
stem.parity   = 1; % this could be smarter

stem.associated_residues = associated_residues;
stem.helix_tag = sanitize_tag(sprintf('Helix_%s%s%d',...
    stem.chain1(1),...
    stem.segid1{1},...
    stem.resnum1(1));% this better be a unique identifier

setappdata( gca, stem.helix_tag, stem );
cleanup_associated_residues();
setup_stem_partner( {stem} ); % could happen inside draw_helices? need some kind of boolean
draw_helices( {stem.helix_tag} );
fprintf( 'Created: %s\n',stem.helix_tag);
fprintf( 'Watch out! orientation of helix residues might be very weird.\n');

