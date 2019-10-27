function [res_tag_sets,res_tags] = get_RNA_chains( selection )
%  [res_tag_sets, res_tags] = get_RNA_chains()
%  [res_tag_sets, res_tags] = get_RNA_chains( selection )
%
% Get set of sets of res_tags for each chain.
% Remove chains that have single residues -- assuming those are ligands or
% proteins.
%
% INPUT
%  selection = [Optional] name of domain or cell of res tags to output.
%
% OUTPUT
%  res_tag_sets = cell containing one cell of res_tags for each chain
%  res_tags     = cell of all the RNA res_tags.
%
% (C) R. Das, Stanford University, 2019
if ~exist( 'selection' ) selection = 'all'; end;

res_tags = get_res( selection );
prev_chain = '';
prev_segid = '';
chain_sets = {};
chain_set = {};
for i = 1:length( res_tags )
    residue = getappdata( gca, res_tags{i} );
    if ~strcmp(residue.chain,prev_chain) | (~strcmp(residue.segid, prev_segid))
        if length( chain_set ) > 0
            chain_sets = [chain_sets, {chain_set} ];
        end
        chain_set = {};
    end
    prev_chain = residue.chain;
    prev_segid = residue.segid;
    chain_set = [ chain_set, res_tags{i} ];
end
if length( chain_set ) > 0
    chain_sets = [chain_sets, {chain_set} ];
end

res_tags = {};
res_tag_sets = {};
for n = 1:length(chain_sets)
    if length(chain_sets{n})>1
        res_tag_sets = [res_tag_sets, {chain_sets{n}} ];
        res_tags = [res_tags, chain_sets{n}];
    end
end
