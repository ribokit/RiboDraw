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
root = rna_tree_node(1);
nodes = {root};
rootnumber = root.nodenumber;

jj = 1;
while jj <= length( bi_pairs )
    if bi_pairs(jj) > 0;
        % paired
        nodes = addNodesRecursive( nodes, bi_pairs, 1, jj, bi_pairs(jj) );
        jj = pairs( jj); % skip ahead
    else
        % unpaired
        node = rna_tree_node( length(nodes) ); % hmmm need to save this somewhere?
        node.isPair = false;
        node.indexA = jj;
        nodes = [ nodes, node ];
        nodes{rootnumber}.children = [nodes{rootnumber}.children, length(nodes) ];
    end
    jj = jj + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nodes = addNodesRecursive( nodes, bi_pairs, root, start_index, end_index );
%
%
%
assert( start_index <= end_index );
newnode = rna_tree_node( length(nodes) );
nodes = [ nodes, newnode ];
nodes{root}.children = [nodes{root}.children, length( nodes ) ];
newnode_number = length( nodes );
if bi_pairs( start_index ) == end_index
    fprintf( 'Adding pair %d-%d\n',start_index, end_index );
    newnode.isPair = true;
    newnode.indexA = start_index;
    newnode.indexB = end_index;
    nodes{newnode_number} = newnode;
    nodes = addNodesRecursive(nodes, bi_pairs, length(nodes), start_index + 1, end_index - 1);
else
    fprintf( 'Starting loop %d-%d\n', start_index, end_index );
    jj = start_index;
    while jj <= end_index
        if ( bi_pairs(jj) > 0 )
            nodes = addNodesRecursive(nodes, bi_pairs, newnode_number, jj, bi_pairs(jj));
            jj = bi_pairs(jj); % skip ahead
            fprintf( 'Skip ahead to %d\n',jj);
        else
            newsubnode = rna_tree_node( length(nodes) );
            newsubnode.isPair = false;
            newsubnode.indexA = jj;
            nodes = [ nodes, newsubnode ];
            newnode.children = [ newnode.children, length(nodes) ];
        end
        jj = jj + 1;
    end
    fprintf( 'Done with loop %d-%d\n', start_index, end_index );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function node = rna_tree_node( nodenumber );
node = struct();
node.children = [];
node.isPair = false;
node.indexA = 0;
node.indexB = 0;
node.nodenumber = nodenumber;

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

