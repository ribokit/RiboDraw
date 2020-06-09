function [resnum,chain,segid,name] = get_one_resnum_from_dssr_tag(s);
% Convert x3dna-dssr string like
%
%   A.RG103 
%
% or  x3dna-dssr --idstr=long like
%
%  ..A.RG.103.
%
% to [103,'A',''];
% 
% TODO -- generalize to segid when we get that from DSSR output.
cols = strsplit( s, '.' );

if length( cols ) == 2
    chain = cols{1};    
    segid = ''; % for now.
    % RG103
    r = cols{2};
    resnum = [];
    for i = 2:length(r)
        resnum = str2num( r(i:end) );
        if ~isempty( resnum ); break; end;
    end
    
    name = r(1:i-1);
else
    segid = cols{end-4};
    chain = cols{end-3};
    name = cols{end-2};
    resnum = str2num(cols{end-1});
end
    



