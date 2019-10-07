function coords = rna_layout( pairs )
% coords = rna_layout( pairs )
%
% Port of EternaJS RNALayout.ts
% Intended to be basis of eterna-like layout code for ribodraw, and
%  also a fast sandbox for testing clockwise/counterclockwise drawing.
%
% INPUT
%   pairs = Array with length of sequence, giving zero if position is
%             unpaired and parter number if paired.
%
%   unlike EternaJS assume that pairs array is already
%     symmetrized
%
% (c) R. Das, Stanford University, 2019.


nodes = setupTree( pairs );
displayTree( nodes, 1, 0 );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nodes = setupTree( pairs )

bi_pairs = pairs;
nodes = {};
[nodes,rootnumber] = create_rna_tree_node( nodes );
jj = 1;
while jj <= length( bi_pairs )
    if bi_pairs(jj) > 0;
        % paired
        nodes = addNodesRecursive( nodes, bi_pairs, 1, jj, bi_pairs(jj) );
        jj = pairs( jj); % skip ahead
    else
        % unpaired
        [nodes,nodenumber] = create_rna_tree_node( nodes ); % hmmm need to save this somewhere?
        nodes{nodenumber}.isPair = false;
        nodes{nodenumber}.indexA = jj;
        nodes{rootnumber}.children = [nodes{rootnumber}.children, nodenumber ];
    end
    jj = jj + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nodes = addNodesRecursive( nodes, bi_pairs, rootnumber, start_index, end_index );
%
%
%
assert( start_index <= end_index );
[nodes,newnodenumber] = create_rna_tree_node( nodes );

if bi_pairs( start_index ) == end_index
    fprintf( 'Adding pair %d-%d\n',start_index, end_index );
    nodes{newnodenumber}.isPair = true;
    nodes{newnodenumber}.indexA = start_index;
    nodes{newnodenumber}.indexB = end_index;
    nodes = addNodesRecursive(nodes, bi_pairs,newnodenumber, start_index + 1, end_index - 1);
else
    fprintf( 'Starting loop %d-%d\n', start_index, end_index );
    jj = start_index;
    while jj <= end_index
        if ( bi_pairs(jj) > 0 )
            nodes = addNodesRecursive(nodes, bi_pairs, newnodenumber, jj, bi_pairs(jj));
            jj = bi_pairs(jj); % skip ahead
            fprintf( 'Skip ahead to %d\n',jj);
        else
            [nodes,newsubnodenumber] = create_rna_tree_node( nodes );
            nodes{newsubnodenumber}.isPair = false;
            nodes{newsubnodenumber}.indexA = jj;
            nodes{newnodenumber}.children = [ nodes{newnodenumber}.children, newsubnodenumber];
        end
        jj = jj + 1;
    end
    fprintf( 'Done with loop %d-%d\n', start_index, end_index );
end
nodes{rootnumber}.children = [nodes{rootnumber}.children, newnodenumber ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [nodes,nodenumber] = create_rna_tree_node( nodes );
node = struct();
node.children = [];
node.isPair = false;
node.indexA = 0;
node.indexB = 0;

nodes = [nodes, node];

nodenumber = length( nodes );
nodes{nodenumber}.nodenumber = nodenumber;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function displayTree( nodes, node_number, level );
node = nodes{node_number};
if isfield( node, 'indexA' )
    for i = 1:level; fprintf(' '); end;
    fprintf( '%d %d isPair %d',node.nodenumber, node.indexA,node.isPair );
    fprintf( '\n' );
end
for i = 1:length(node.children)
    displayTree( nodes, node.children(i), level + 1 )
end

