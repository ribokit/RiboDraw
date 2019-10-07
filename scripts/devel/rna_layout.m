function coords = rna_layout( pairs,  targetPairs, customLayout )
% coords = rna_layout( pairs )
%
% Port of EternaJS RNALayout.ts
% Intended to be basis of eterna-like layout code for ribodraw, and
%  also a fast sandbox for testing clockwise/counterclockwise drawing.
%
% TODO: oligo rendering not implemented yet.
%
% INPUT
%   pairs = Array with length of sequence, giving zero if position is
%             unpaired and parter number if paired.
%
%   unlike EternaJS assume that pairs array is already
%     symmetrized
%
% (c) R. Das, Stanford University, 2019.

if ~exist( 'targetPairs' ); targetPairs = []; end
if ~exist( 'customLayout' ); customLayout = []; end

nodes = setupTree( pairs );
nodes = drawTree( nodes, customLayout, targetPairs );
%displayTree( nodes, 1, 0 ); %sanity check
xy = getCoords(nodes);
%for i = 1:size(xy,1); fprintf( '%d: %f %f\n',i,xy(i,1),xy(i,2) ); end

plot( xy(:,1),xy(:,2),'o-');
set(gca,'ydir','reverse');
axis image
plotTree( nodes, 1);
axis off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    % fprintf( 'Adding pair %d-%d\n',start_index, end_index );
    nodes{newnodenumber}.isPair = true;
    nodes{newnodenumber}.indexA = start_index;
    nodes{newnodenumber}.indexB = end_index;
    nodes = addNodesRecursive(nodes, bi_pairs,newnodenumber, start_index + 1, end_index - 1);
else
    % fprintf( 'Starting loop %d-%d\n', start_index, end_index );
    jj = start_index;
    while jj <= end_index
        if ( bi_pairs(jj) > 0 )
            nodes = addNodesRecursive(nodes, bi_pairs, newnodenumber, jj, bi_pairs(jj));
            jj = bi_pairs(jj); % skip ahead
            % fprintf( 'Skip ahead to %d\n',jj);
        else
            [nodes,newsubnodenumber] = create_rna_tree_node( nodes );
            nodes{newsubnodenumber}.isPair = false;
            nodes{newsubnodenumber}.indexA = jj;
            nodes{newnodenumber}.children = [ nodes{newnodenumber}.children, newsubnodenumber];
        end
        jj = jj + 1;
    end
    % fprintf( 'Done with loop %d-%d\n', start_index, end_index );
end
nodes{rootnumber}.children = [nodes{rootnumber}.children, newnodenumber ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [nodes,nodenumber] = create_rna_tree_node( nodes );
node = struct();
node.children = [];
node.isPair = false;
node.indexA = 0;
node.indexB = 0;
node.xy = [0,0]; % position
node.go = [0,1]; % 'direction'
nodes = [nodes, node];

nodenumber = length( nodes );
nodes{nodenumber}.nodenumber = nodenumber;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nodes = drawTree( nodes, customLayout, targetPairs  );
start = [0,0];
go = [0,1];

info = struct();
info.customLayout = customLayout;
info.targetPairs = targetPairs;

nodes = drawTreeRecursive( nodes, 1, 0, start, go, info );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_settings = get_plot_settings();
plot_settings = struct();
plot_settings.primarySpace = 30;
plot_settings.pairSpace = 30;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function match = junctionMatchesTarget(nodes, root, parent, info)
match = 0;
if isempty( info.targetPairs ); return; end
    
if ( parent > 0 && nodes{ parent }.isPair )
    % check closing pair for junction
    if ( info.targetPairs( nodes{ parent }.indexA ) ~= nodes{ parent }.indexB ) 
        return;
    end
end

rootnode = nodes{root};
if ( length( rootnode.children ) == 1 && nodes{ rootnode.children(1) }.indexA == 0 ) return; end

for ii = 1:length( rootnode.children )
    child = nodes{ rootnode.children(ii) };
    if ( child.isPair )                  
        %all other pairs of junction paired in target structure?
        if ( info.targetPairs( child.indexA ) ~= child.indexB )
            return;
        end
    else
        
        % all unpaired bases of junction also unpaired in target structure?
        if ( info.targetPairs( child.indexA )  > 0 )
            return;
        end
    end
end
        
match = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nodes = drawTreeRecursive( nodes, root, parent, start, go, info );
%
%  Note ordering:
%
%     parent --> root --> current
%
%  INPUT
%   nodes = 'global' information holding tree-like structure over drawing, coordinates of each node.
%   root   = node number of root for this section of the tree.
%   parent = node number of *parent* of root.
%   start = (x,y) that will likely be placed on root
%   go    = (v_x, v_y) unit-vector pointing from root to current.
%   info  = grab bag of read-only information, here including customLayout &
%                      targetPairs
%
%  OUTPUT
%   nodes = updated nodes.
%
cross = [-go(2) go(1)];
oligo_displacement = 0;
nodes{ root }.go = go;

if (~isempty( info.customLayout ) && junctionMatchesTarget(nodes, root, parent, info) ) 
    nodes = drawTreeCustomLayout( nodes, root, parent, start, go, info );
    return;
end  
        
plot_settings = get_plot_settings();
if ( length(nodes{root}.children) == 1 )
    nodes{root}.xy = start;
    child = nodes{ nodes{root}.children(1) };
    if ( child.isPair ) 
        % stacked pair, I think. Keep chugging in the same direction.
        nodes = drawTreeRecursive(nodes, nodes{root}.children(1), root, start + go * plot_settings.primarySpace, go, info);
    elseif ( child.isPair && child.indexA < 0 ) 
        % uh not sure what this is
        fprintf( 'Where are we?\n' ); exit(0);
        nodes = drawTreeRecursive(nodes, nodes{root}.children(1), root, start, go, info);
    else
        % heading into a circular junction
        nodes = drawTreeRecursive(nodes, nodes{root}.children(1), root, start + go * plot_settings.primarySpace, go, info);
    end
elseif ( length(nodes{root}.children) > 1 ) 
    % need to draw a circle of elements
    npairs = 0;
    oligo_displacement = 0;
    for ii = 1:length(nodes{root}.children)
        if nodes{ nodes{root}.children(ii) }.isPair 
            npairs = npairs + 1;
        end
        % TODO: implement to check oligo rendering!
        %if (this._exceptionIndices != null && (this._exceptionIndices.indexOf(rootnode.children[ii].indexA) >= 0 || this._exceptionIndices.indexOf(rootnode.children[ii].indexB) >= 0)) {
        %    oligo_displacement += 2 * this._primarySpace;
        %    }
    end
    circle_length = ( length(nodes{root}.children) + 1 ) * plot_settings.primarySpace + (npairs + 1 ) * plot_settings.pairSpace;
    circle_length = circle_length + oligo_displacement;
    circle_radius = circle_length / (2 * pi );
    length_walker = plot_settings.pairSpace / 2.0;

    if (parent == 0) 
        nodes{root}.xy = go * circle_radius;
    else
        % the root becomes the center of a circle. displaced from the parent.
        nodes{root}.xy = nodes{parent}.xy + go * circle_radius;
    end
    for ii = 1 : length(nodes{root}.children)
        length_walker = length_walker + plot_settings.primarySpace;

        %                 if (this._exceptionIndices != null && (this._exceptionIndices.indexOf(rootnode.children[ii].indexA) >= 0 || this._exceptionIndices.indexOf(rootnode.children[ii].indexB) >= 0)) {
        %                     length_walker += 2 * this._primarySpace;
        %                 }
        
        if ( nodes{ nodes{root}.children(ii) }.isPair )
            length_walker = length_walker + plot_settings.pairSpace/2.0;
        end
        

        rad_angle = length_walker/circle_length * 2 * pi - pi/2.0;
        child_xy = nodes{root}.xy + cos( rad_angle) * cross * circle_radius + sin ( rad_angle ) * go * circle_radius;
        
        child_go = child_xy - nodes{root}.xy;
        child_go_len = norm( child_go );

        %fprintf( 'root %d isPair %d length_walker %f child idx %d child_go %f %f\n',...
        %    nodes{root}.nodenumber,nodes{root}.isPair,length_walker, nodes{nodes{root}.children(ii)}.indexA, child_go/child_go_len );

        nodes = drawTreeRecursive( nodes, nodes{root}.children( ii ), root, child_xy, child_go/child_go_len, info );
        if nodes{ nodes{root}.children(ii) }.isPair
            length_walker = length_walker + plot_settings.pairSpace/2.0;
        end
    end
else
    nodes{root}.xy = start;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nodes = drawTreeCustomLayout( nodes, root, parent, start, go, info );
cross = [ -go(2), go(1) ];
nodes{root}.xy = start;
anchor_xy = [0,0];
anchor_custom_xy = [0,0];
anchor_custom_go = [0,1];
anchor_custom_cross = [-1,0];
anchor_defined = 0;

customLayout = info.customLayout;
if ( parent > 0 && nodes{parent}.isPair ) 
    parentnode = nodes{parent};
    % this is the case in junctions, where root is 'pseudonode' in middle of junction,
    %  and parent is the exterior pair (or the global root)
    anchor_xy = parentnode.xy;
    custom_coordA = customLayout( parentnode.indexA, : );
    custom_coordB = customLayout( parentnode.indexB, : );
    anchor_custom_xy = ( custom_coordA + custom_coordB ) / 2.0;
    anchor_custom_cross = ( custom_coordA - custom_coordB );
    anchor_custom_go = [ anchor_custom_cross(2), -anchor_custom_cross(1)];
    anchor_defined = 1;
elseif ( root > 0 && nodes{root}.isPair ) 
    rootnode = nodes{root};
    anchor_xy = rootnode.xy;
    custom_coordA = customLayout( rootnode.indexA, : );
    custom_coordB = customLayout( rootnode.indexB, : );
    anchor_custom_xy = ( custom_coordA + custom_coordB ) / 2.0;
    anchor_custom_cross = ( custom_coordA - custom_coordB );
    anchor_custom_go = [ anchor_custom_cross(2), -anchor_custom_cross(1)];
    anchor_defined = 1;
end

for ii = 1:length( nodes{root}.children )
    % read out where this point should be based on 'this._customLayout'. get coordinates in
    % "local coordinate frame" set by parent pair in this._customLayout.
    % This would be a lot easier to read if we had a notion of an (x,y) pair, dot products, and cross products.
    rootnode = nodes{root};
    child = nodes{ nodes{root}.children(ii) };
    custom_coord = info.customLayout(child.indexA,:);
    if (child.isPair)
        custom_coordA = info.customLayout(child.indexA,:);
        custom_coordB = info.customLayout(child.indexB,:);
        custom_coord = (custom_coordA + custom_coordB) / 2;
    end
    
    child_xy = [0,0];
    child_go = [0,0];
    plot_settings = get_plot_settings();
    child_xy = custom_coord * plot_settings.primarySpace;
    if ( anchor_defined )
        dev = custom_coord - anchor_custom_xy;
        template_xy = dev * [anchor_custom_cross', anchor_custom_go' ]; % check dimensions!?
        template_xy = template_xy * plot_settings.primarySpace;
        % go to Eterna RNALayout global frame.
        child_xy = anchor_xy + template_xy * [cross', go']; % check dimensions!?
    end
    
    if ( child.isPair )
        custom_coordA = info.customLayout(child.indexA,:);
        custom_coordB = info.customLayout(child.indexB,:);
        custom_cross = custom_coordA - custom_coordB;
        custom_go = [custom_cross(2), -custom_cross(1)];
        
        child_go = custom_go;
        if (anchor_defined) 
            template_go = custom_go*[anchor_custom_cross', anchor_custom_go' ];
            child_go    = template_go*[cross',go'];
        end
               
    end
    child_go_len = norm( child_go );
    
    nodes = drawTreeRecursive(nodes, nodes{root}.children(ii), root, child_xy, child_go/child_go_len, info );
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function xy = getCoords(nodes);
xy = [];
xy = getCoordsRecursive( nodes, 1, xy );
% TODO -- implement 'empty structure' coords
%         if (this._root != null) {
%             this.getCoordsRecursive(this._root, xarray, yarray);
%         } else {
%             // there is no structure (no pairs)
%             if (xarray.length < 3) {
%                 // really short, just place them in a vertical line
%                 for (let ii = 0; ii < xarray.length; ii++) {
%                     xarray[ii] = 0;
%                     yarray[ii] = ii * this._primarySpace;
%                 }
%             } else {
%                 // if longer, make the sequence form a circle instead
%                 // FIXME: there's a bit of code duplication here, somewhat inelegant...
%                 let circle_length: number = (xarray.length + 1) * this._primarySpace + this._pairSpace;
%                 let circle_radius: number = circle_length / (2 * Math.PI);
%                 let length_walker: number = this._pairSpace / 2.0;
%                 let go_x: number = 0;
%                 let go_y: number = 1;
%                 let _root_x: number = go_x * circle_radius;
%                 let _root_y: number = go_y * circle_radius;
%                 let cross_x: number = -go_y;
%                 let cross_y: number = go_x;
%                 let oligo_displacement: number = 0;
% 
%                 for (let ii = 0; ii < xarray.length; ii++) {
%                     if (this._exceptionIndices != null && this._exceptionIndices.indexOf(ii) >= 0) {
%                         oligo_displacement += 2 * this._primarySpace;
%                     }
%                 }
%                 circle_length += oligo_displacement;
% 
%                 for (let ii = 0; ii < xarray.length; ii++) {
%                     length_walker += this._primarySpace;
%                     if (this._exceptionIndices != null && this._exceptionIndices.indexOf(ii) >= 0) {
%                         length_walker += 2 * this._primarySpace;
%                     }
% 
%                     let rad_angle: number = length_walker / circle_length * 2 * Math.PI - Math.PI / 2.0;
%                     xarray[ii] = _root_x + Math.cos(rad_angle) * cross_x * circle_radius + Math.sin(rad_angle) * go_x * circle_radius;
%                     yarray[ii] = _root_y + Math.cos(rad_angle) * cross_y * circle_radius + Math.sin(rad_angle) * go_y * circle_radius;
%                 }
%             }
%         }
%     }

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function xy = getCoordsRecursive(nodes,root,xy);
rootnode = nodes{root};
if rootnode.isPair
    cross = [-rootnode.go(2),rootnode.go(1)];
    plot_settings = get_plot_settings();
    xy( rootnode.indexA, : ) = rootnode.xy + cross * plot_settings.pairSpace/2.0;
    xy( rootnode.indexB, : ) = rootnode.xy - cross * plot_settings.pairSpace/2.0;
elseif rootnode.indexA > 0
    xy( rootnode.indexA, : ) = rootnode.xy;
end
for ii = 1:length(rootnode.children)
    xy = getCoordsRecursive( nodes, rootnode.children(ii), xy );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function displayTree( nodes, node_number, level );
node = nodes{node_number};
if isfield( node, 'indexA' )
    for i = 1:level; fprintf(' '); end;
    fprintf( '(%d) idx %d isPair %d   xy %f %f  go %f %f',node.nodenumber, node.indexA,node.isPair, node.xy,node.go );
    fprintf( '\n' );
end
for i = 1:length(node.children)
    displayTree( nodes, node.children(i), level + 1 )
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotTree( nodes, node_number );
node = nodes{node_number};
if isfield( node, 'indexA' )
    %text( node.xy(1), node.xy(2), num2str(node.nodenumber),'horizontalalign','center','verticalalign','middle');
    hold on
    plot( node.xy(1), node.xy(2),'r.');
    plot( node.xy(1) + 10*[0,node.go(1)], node.xy(2)+10*[0,node.go(2)], 'r','linew',1.2 );
end
for i = 1:length(node.children)
    child = nodes{ node.children(i) }; hold on
    plot( [node.xy(1),child.xy(1)], [node.xy(2),child.xy(2)], 'k-' );
    plotTree( nodes, node.children(i) )
end

