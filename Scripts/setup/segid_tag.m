function tag = segid_tag( segid );
% If segid is not blank give back "_segid".
%
tag = '';
if ( length(segid) > 0 ); tag = ['_',segid]; end
return
