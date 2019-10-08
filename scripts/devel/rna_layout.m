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
XY = getCoords(nodes);

plot( XY(:,1),XY(:,2),'o-');
set(gca,'ydir','reverse');
axis image
plotTree( nodes, 1);
axis off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nodes = setupTree( pairs )

biPairs = pairs;
nodes = {};
[nodes,rootnumber] = create_rna_tree_node( nodes );
jj = 1;
while jj <= length( biPairs )
    if biPairs(jj) > 0;
        % paired
        nodes = addNodesRecursive( nodes, biPairs, 1, jj, biPairs(jj) );
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
function nodes = addNodesRecursive( nodes, biPairs, rootnumber, start_index, end_index );
%
%
%
assert( start_index <= end_index );
[nodes,newnodenumber] = create_rna_tree_node( nodes );

if biPairs( start_index ) == end_index
    nodes{newnodenumber}.isPair = true;
    nodes{newnodenumber}.indexA = start_index;
    nodes{newnodenumber}.indexB = end_index;
    nodes = addNodesRecursive(nodes, biPairs,newnodenumber, start_index + 1, end_index - 1);
else
    jj = start_index;
    while jj <= end_index
        if ( biPairs(jj) > 0 )
            nodes = addNodesRecursive(nodes, biPairs, newnodenumber, jj, biPairs(jj));
            jj = biPairs(jj); % skip ahead
        else
            [nodes,newsubnodenumber] = create_rna_tree_node( nodes );
            nodes{newsubnodenumber}.isPair = false;
            nodes{newsubnodenumber}.indexA = jj;
            nodes{newnodenumber}.children = [ nodes{newnodenumber}.children, newsubnodenumber];
        end
        jj = jj + 1;
    end
end
nodes{rootnumber}.children = [nodes{rootnumber}.children, newnodenumber ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [nodes,nodenumber] = create_rna_tree_node( nodes );
node = struct();
node.children = [];
node.isPair = false;
node.indexA = 0;
node.indexB = 0;
node.XY = [0,0]; % position
node.go = [0,1]; % 'direction'
node.flipSign = 1; % can change to -1 in customlayout
nodes = [nodes, node];

nodenumber = length( nodes );
nodes{nodenumber}.nodenumber = nodenumber;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nodes = drawTree( nodes, customLayout, targetPairs );
start = [0,0];
go = [0,1];

info = struct();
info.customLayout = customLayout;
info.targetPairs = targetPairs;

flipSign = 1;
nodes = drawTreeRecursive( nodes, 1, 0, start, go, flipSign, info );

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
function nodes = drawTreeRecursive( nodes, root, parent, start, go, flipSign, info );
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
%   go    = (vX, vY) unit-vector pointing from root to current.
%   info  = grab bag of read-only information, here including customLayout &
%                      targetPairs
%
%  OUTPUT
%   nodes = updated nodes.
%
cross = [-go(2) go(1)] * flipSign;
nodes{ root }.go = go;
nodes{ root }.flipSign = flipSign;

if (~isempty( info.customLayout ) && junctionMatchesTarget(nodes, root, parent, info) ) 
    nodes = drawTreeCustomLayout( nodes, root, parent, start, go, flipSign, info );
    return;
end  
        
plot_settings = get_plot_settings();
if ( length(nodes{root}.children) == 1 )
    nodes{root}.XY = start;
    child = nodes{ nodes{root}.children(1) };
    if ( child.isPair ) 
        % stacked pair, I think. Keep chugging in the same direction.
        nodes = drawTreeRecursive(nodes, nodes{root}.children(1), root, start + go * plot_settings.primarySpace, go, flipSign, info);
    elseif ( child.isPair && child.indexA < 0 ) 
        % uh not sure what this is
        fprintf( 'Where are we?\n' ); exit(0);
        nodes = drawTreeRecursive(nodes, nodes{root}.children(1), root, start, go, flipSign,  info);
    else
        % heading into a circular junction
        nodes = drawTreeRecursive(nodes, nodes{root}.children(1), root, start + go * plot_settings.primarySpace, go, flipSign, info);
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
    circleLength = ( length(nodes{root}.children) + 1 ) * plot_settings.primarySpace + (npairs + 1 ) * plot_settings.pairSpace;
    circleLength = circleLength + oligo_displacement;
    circleRadius = circleLength / (2 * pi );
    lengthWalker = plot_settings.pairSpace / 2.0;

    if (parent == 0) 
        nodes{root}.XY = go * circleRadius;
    else
        % the root becomes the center of a circle. displaced from the parent.
        nodes{root}.XY = nodes{parent}.XY + go * circleRadius;
    end
    for ii = 1 : length(nodes{root}.children)
        lengthWalker = lengthWalker + plot_settings.primarySpace;

        %                 if (this._exceptionIndices != null && (this._exceptionIndices.indexOf(rootnode.children[ii].indexA) >= 0 || this._exceptionIndices.indexOf(rootnode.children[ii].indexB) >= 0)) {
        %                     lengthWalker += 2 * this._primarySpace;
        %                 }
        
        if ( nodes{ nodes{root}.children(ii) }.isPair )
            lengthWalker = lengthWalker + plot_settings.pairSpace/2.0;
        end
        

        radAngle = lengthWalker/circleLength * 2 * pi - pi/2.0;
        childXY = nodes{root}.XY + cos( radAngle) * cross * circleRadius + sin ( radAngle ) * go * circleRadius;
        
        childGo = childXY - nodes{root}.XY;
        childGoLength = norm( childGo );

        nodes = drawTreeRecursive( nodes, nodes{root}.children( ii ), root, childXY, childGo/childGoLength, flipSign, info );
        if nodes{ nodes{root}.children(ii) }.isPair
            lengthWalker = lengthWalker + plot_settings.pairSpace/2.0;
        end
    end
else
    nodes{root}.XY = start;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nodes = drawTreeCustomLayout( nodes, root, parent, start, go, flipSign, info );
cross = [ -go(2), go(1) ] * flipSign;
nodes{root}.XY = start;

if length( nodes{root}.children ) == 0; return; end;

anchorXY = [0,0];
anchorCustomXY = [0,0];
anchorCustomCross = [-1,0];
anchorCustomGo = [0,1];
anchorFlipSign = 1;

customLayout = info.customLayout;
anchornode = 0;
if ( parent > 0 && nodes{parent}.isPair )     
    % this is the case in junctions, where root is 'pseudonode' in middle of junction,
    %  and parent is the exterior pair (or the global root)
    anchornode = nodes{parent};
elseif ( root > 0 && nodes{root}.isPair ) 
    % this is the case in stacked pairs
    anchornode = nodes{root};
end
if isstruct(anchornode)     
    anchorXY = anchornode.XY;
    customCoordA = customLayout( anchornode.indexA, : );
    customCoordB = customLayout( anchornode.indexB, : );
    anchorCustomXY = ( customCoordA + customCoordB ) / 2.0;
    anchorFlipSign = anchornode.flipSign;
    anchorCustomCross = ( customCoordA - customCoordB );    
    anchorCustomGo = [ anchorCustomCross(2), -anchorCustomCross(1)];
    customCoordNext = customLayout( anchornode.indexA+1, : );
    anchorFlipSign = sign( (customCoordNext - anchorCustomXY) * anchorCustomGo' );
    anchorCustomGo = anchorCustomGo * anchorFlipSign;
end

for ii = 1:length( nodes{root}.children )
    % read out where this point should be based on 'this.CustomLayout'. get coordinates in
    % "local coordinate frame" set by parent pair in this.CustomLayout.
    % This would be a lot easier to read if we had a notion of an (x,y) pair, dot products, and cross products.
    rootnode = nodes{root};
    child = nodes{ nodes{root}.children(ii) };
    customCoord = info.customLayout(child.indexA,:);
    if (child.isPair)
        customCoordA = info.customLayout(child.indexA,:);
        customCoordB = info.customLayout(child.indexB,:);
        customCoord = (customCoordA + customCoordB) / 2;
        customCross = (customCoordA - customCoordB);
        customGo = [customCross(2), -customCross(1)];
        customCoordNext = info.customLayout(child.indexA+1,:);
        childFlipSign = sign( (customCoordNext - customCoord) * customGo' );
        customGo = customGo * childFlipSign;
    end
    
    childXY = [0,0];
    childGo = [0,0];
    plot_settings = get_plot_settings();
    childXY = customCoord * plot_settings.primarySpace;
    if isstruct(anchornode) 
        dev = customCoord - anchorCustomXY;
        templateXY = dev * [anchorCustomCross', anchorCustomGo' ]; % check dimensions!?
        templateXY = templateXY * plot_settings.primarySpace;
        % go to Eterna RNALayout global frame.
        childXY = anchorXY + templateXY * [cross', go']'; % check dimensions!?
    end

    childFlipSign = flipSign;
    if ( child.isPair )
        childFlipSign = flipSign * childFlipSign/anchorFlipSign;  
        childGo = customGo;
        if ( isstruct(anchornode) )
            templateGo = customGo*[anchorCustomCross', anchorCustomGo' ];
            childGo    = templateGo*[cross',go']';
        end
    end
    childGoLength = norm( childGo );
    
    nodes = drawTreeRecursive(nodes, nodes{root}.children(ii), root, childXY, childGo/childGoLength, childFlipSign, info );
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function XY = getCoords(nodes);
XY = [];
XY = getCoordsRecursive( nodes, 1, XY );
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
%                 let circleLength: number = (xarray.length + 1) * this._primarySpace + this.Pairspace;
%                 let circleRadius: number = circleLength / (2 * Math.PI);
%                 let lengthWalker: number = this.Pairspace / 2.0;
%                 let goX: number = 0;
%                 let goY: number = 1;
%                 let _rootX: number = goX * circleRadius;
%                 let _rootY: number = goY * circleRadius;
%                 let crossX: number = -goY;
%                 let crossY: number = goX;
%                 let oligo_displacement: number = 0;
% 
%                 for (let ii = 0; ii < xarray.length; ii++) {
%                     if (this._exceptionIndices != null && this._exceptionIndices.indexOf(ii) >= 0) {
%                         oligo_displacement += 2 * this._primarySpace;
%                     }
%                 }
%                 circleLength += oligo_displacement;
% 
%                 for (let ii = 0; ii < xarray.length; ii++) {
%                     lengthWalker += this._primarySpace;
%                     if (this._exceptionIndices != null && this._exceptionIndices.indexOf(ii) >= 0) {
%                         lengthWalker += 2 * this._primarySpace;
%                     }
% 
%                     let radAngle: number = lengthWalker / circleLength * 2 * Math.PI - Math.PI / 2.0;
%                     xarray[ii] = _rootX + Math.cos(radAngle) * crossX * circleRadius + Math.sin(radAngle) * goX * circleRadius;
%                     yarray[ii] = _rootY + Math.cos(radAngle) * crossY * circleRadius + Math.sin(radAngle) * goY * circleRadius;
%                 }
%             }
%         }
%     }

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function XY = getCoordsRecursive(nodes,root,XY);
rootnode = nodes{root};
if rootnode.isPair
    cross = [-rootnode.go(2),rootnode.go(1)] * rootnode.flipSign;
    plot_settings = get_plot_settings();
    XY( rootnode.indexA, : ) = rootnode.XY + cross * plot_settings.pairSpace/2.0;
    XY( rootnode.indexB, : ) = rootnode.XY - cross * plot_settings.pairSpace/2.0;
elseif rootnode.indexA > 0
    XY( rootnode.indexA, : ) = rootnode.XY;
end
for ii = 1:length(rootnode.children)
    XY = getCoordsRecursive( nodes, rootnode.children(ii), XY );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function displayTree( nodes, node_number, level );
node = nodes{node_number};
if isfield( node, 'indexA' )
    for i = 1:level; fprintf(' '); end;
    fprintf( '(%d) idx %d isPair %d   XY %f %f  go %f %f',node.nodenumber, node.indexA,node.isPair, node.XY,node.go );
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
    text( node.XY(1), node.XY(2), num2str(node.nodenumber),'horizontalalign','center','verticalalign','middle');
    hold on
    plot( node.XY(1), node.XY(2),'r.');
    plot( node.XY(1) + 10*[0,node.go(1)], node.XY(2)+10*[0,node.go(2)], 'r','linew',1.2 );
end
for i = 1:length(node.children)
    child = nodes{ node.children(i) }; hold on
    plot( [node.XY(1),child.XY(1)], [node.XY(2),child.XY(2)], 'k-' );
    plotTree( nodes, node.children(i) )
end

