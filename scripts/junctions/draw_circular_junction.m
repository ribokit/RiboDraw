function draw_circular_junction( junction_res_tags );
% draw_circular_junction( junction_res_tags );
%
% Assumes that res_tags are residues inside an *APICAL LOOP*
%  and flanking base pair is formed by residue immediately before and
%  after.
% Follows Eterna convention for RNALayout drawing.
% 
% see also RNA_LAYOUT
%
% (C) R. Das, Stanford University, 2019


% find 'parent' to this junction_res_tags -- there must be a stem pair

if ~exist( 'junction_res_tags', 'var' )
    apical_loops = find_apical_loops();
    for i = 1:length( apical_loops )
        draw_circular_junction( apical_loops{i} );
    end
    return;
end

res_start = getappdata( gca, junction_res_tags{1} );
res_tagA = sanitize_tag(sprintf('Residue_%s%s%d',res_start.chain, res_start.segid, res_start.resnum - 1));

res_end = getappdata( gca,  junction_res_tags{end} );
res_tagB = sanitize_tag(sprintf('Residue_%s%s%d',res_end.chain, res_end.segid, res_end.resnum + 1));

resA = getappdata( gca, res_tagA );
resB = getappdata( gca, res_tagB );
start_xy = (resA.plot_pos + resB.plot_pos )/2;

% starter coordinate system.
cross = ( resA.plot_pos - resB.plot_pos );
cross = cross/norm( cross );
go = [cross(2), -cross(1)];

res_tag_prev = sanitize_tag(sprintf('Residue_%s%s%d',res_start.chain, res_start.segid, res_start.resnum - 2));
if ~isappdata( gca, res_tag_prev )
    res_tag_prev = sanitize_tag(sprintf('Residue_%s%s%d',res_end.chain, res_end.segid, res_end.resnum + 1));
end
if isappdata( gca, res_tag_prev );
    res_prev = getappdata( gca, res_tag_prev );
    rotationDirectionSign = sign( go*(start_xy - res_prev.plot_pos )' ); 
    go = rotationDirectionSign * go;
end

plot_settings = get_plot_settings();
npairs = 0;
circleLength = ( length(junction_res_tags) + 1 ) * plot_settings.spacing + (npairs + 1 ) * plot_settings.bp_spacing;
%circleLength = circleLength + oligo_displacement;
circleRadius = circleLength / (2 * pi );
lengthWalker = plot_settings.bp_spacing / 2.0;

circle_center = start_xy + go * circleRadius;
residues = {};
grid_spacing = plot_settings.spacing/4;
for ii = 1 : length(junction_res_tags)
    lengthWalker = lengthWalker + plot_settings.spacing;
    
%     if ( nodes{ nodes{root}.children(ii) }.isPair )
%         lengthWalker = lengthWalker + plot_settings.pairSpace/2.0;
%     end
        
    radAngle = lengthWalker/circleLength * 2 * pi - pi/2.0;
    childXY = circle_center + cos( radAngle ) * cross * circleRadius + sin ( radAngle ) * go * circleRadius;
    
    residue = getappdata( gca, junction_res_tags{ii} );
    residue.plot_pos = round(childXY/grid_spacing)*grid_spacing; % snap to grid!
    residues{ii} = residue;
end

% redraw everything...
helices_to_redraw = {};
for i = 1:length( residues )
    helix = getappdata( gca, residues{i}.helix_tag );
    residues{i}.relpos = get_relpos( residues{i}.plot_pos, helix );
    setappdata( gca, residues{i}.res_tag, residues{i} );
    helices_to_redraw = [helices_to_redraw, {helix.helix_tag} ];
end
draw_helices( helices_to_redraw );


