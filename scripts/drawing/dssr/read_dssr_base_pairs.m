function base_pairs = read_dssr_base_pairs( base_pairs_file );
% base_pairs = read_base_pairs( base_pairs_file )
%
%  Read .base_pairs.txt file output by x3dna-dssr executable, which
%      should include all Watson-Crick and non-Watson-Crick pairs.
%
%  Note: not handling SEGID's yet -- sent a note to X-J Lu to get output
%   again with --segid.
%
% INPUT
%
%  base_pairs_file = .csv formatted output from web-DSSR server
%  (http://http://wdssr.x3dna.org/)
%
% Or output from  command-line like
%  x3dna-dssr -i=../rna_motif/1gid_RNAA.pdb -o=1gid_RNAA.out
% like
%     nt1            nt2            bp  name        Saenger   LW   DSSR
%   1 A.RG103        A.RC217        G-C WC          19-XIX    cWW  cW-W
%   2 A.RG103        A.RA256        G+A --          n/a       cHW  cM+W%
%
% Or (for segids) output from
%  x3dna-dssr -i=../rna_motif/1gid_RNAA.pdb -o=1gid_RNAA.out --idstr=long
% like
%     nt1            nt2            bp  name        Saenger   LW   DSSR
%   1 ..A.RG.103.    ..A.RC.217.    G-C WC          19-XIX    cWW  cW-W
%   2 ..A.RG.103.    ..A.RA.256.    G+A --          n/a       cHW  cM+W
%   3 ..A.RA.104.    ..A.RC.216.    A-C --          n/a       cWW  cW-W
%
%
% OUTPUT
%
%  base_pairs       = cell of struct()s with the same information. Reordered so that
%                         the residue that has an earlier chain/segid (or if same, earlier resnum) is first.
%
%
% See also: READ_BASE_PAIRS
%
% (C) R. Das, Stanford University, 2020
base_pairs = {};
if nargin == 0; help(mfilename); return; end;
if ~exist( base_pairs_file, 'file' ) fprintf( '\nCould not find: %s\n',base_pairs_file); return; end;

fid = fopen( base_pairs_file );
line = fgetl( fid );
if strcmp( line(1),'*')
    base_pairs = read_standard_dssr( fid );
elseif strcmp( line, 'tablePairs' )
    base_pairs = read_csv_dssr( fid );
else
    fprintf( '\nUnrecognized DSSR file!\n' );
    help(mfilename); return;
end


function base_pairs = read_standard_dssr(fid);
base_pairs = {};
in_base_pairs = 0;
while ~feof( fid )
    line = fgetl( fid );
    % C:QA:1347 C:QA:1599 W W C
    cols = strsplit( line, ' ' );
    if length( cols ) == 8 & strcmp(cols{2},'nt1')
        in_base_pairs = 1;
        continue;
    end
    if in_base_pairs
        if length(cols) == 1; break; end;
        if length( cols ) == 9
            cols = cols(2:9); % first col is a blank?
            [base_pair.resnum1,base_pair.chain1,base_pair.segid1,base_pair.name1] = get_one_resnum_from_dssr_tag( cols{2} );
            [base_pair.resnum2,base_pair.chain2,base_pair.segid2,base_pair.name2] = get_one_resnum_from_dssr_tag( cols{3} );
            
            LW = cols{7};
            base_pair.edge1 = LW(2);
            base_pair.edge2 = LW(3);
            base_pair.LW_orientation = upper(LW(1));
            base_pairs = [base_pairs,ordered_base_pair(base_pair)];
        end
    end;
end
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function base_pairs = read_csv_dssr(fid);
base_pairs = {};
line = fgetl(fid);
while ~feof( fid )
    line = fgetl( fid );
    % "1","A.G96","A.C278","G-C","WC","19-XIX","cWW","cW-W","3","A.G96,A.C278","[0.053, -0.195, 0.203, -6.945, 0.973, -3.183]","jqg1",
    cols = strsplit( line, ',' );
    [base_pair.resnum1,base_pair.chain1,base_pair.segid1,base_pair.name1] = get_one_resnum_from_dssr_tag( cols{2}(2:end-1) );
    [base_pair.resnum2,base_pair.chain2,base_pair.segid2,base_pair.name2] = get_one_resnum_from_dssr_tag( cols{3}(2:end-1) );
    
    LW = cols{7}(2:end-1);
    base_pair.edge1 = LW(2);
    base_pair.edge2 = LW(3);
    base_pair.LW_orientation = upper(LW(1));
    base_pairs = [base_pairs,ordered_base_pair(base_pair)];
end
fclose(fid);








