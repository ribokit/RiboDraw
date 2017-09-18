function initialize_ticks()
[resnum,chains] = get_resnum_chain();
tickres = find( mod( resnum, 10 ) == 0 );
for i = tickres   
    res_tag = sprintf('Residue_%s%d',chains(i),resnum(i));
    residue = getappdata( gca, res_tag );
    if ~isfield( residue, 'tickrot' ) residue.tickrot = nan; end; % nan means set later based on how helix is rotated.
    setappdata( gca, res_tag, residue );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [resnum,chains] = get_resnum_chain()
vals = getappdata( gca );
objnames = fields( vals );
resnum = []; chains = '';
for n = 1:length( objnames )
    if isempty( strfind( objnames{n}, 'Residue_' ) ); continue; end;
    residue = getappdata(gca,objnames{n});
    resnum = [ resnum, residue.resnum];
    chains = [ chains, residue.chain];
end
