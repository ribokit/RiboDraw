function [ rna_motif_residue_sets, rna_motif_colors, rna_motif_layer_levels ] = get_rna_motif_info();
%
% Information used to display motifs -- matches conventions used in Rosetta
%    core/src/RNA/RNA_Motif.cc and core/score/RNA/RNA_Motif.hh
%
% OUTPUTS
%
%  rna_motif_residue_sets = what chunks of residues should fall into
%                             blocks for rounded rectangles
%  rna_motif_colors       = highlight color for rounded rectangle
%
% (C) R. Das, Stanford University, 2019.


rna_motif_residue_sets = containers.Map( ...
{   'U_TURN', 'UA_HANDLE', 'T_LOOP', 'INTERCALATED_T_LOOP', 'LOOP_E_SUBMOTIF', 'BULGED_G', 'GNRA_TETRALOOP', 'STRICT_WC_STACKED_PAIR', 'WC_STACKED_PAIR',  'A_MINOR', 'PLATFORM', 'TL_RECEPTOR', 'TETRALOOP_TL_RECEPTOR', 'Z_TURN', 'TANDEM_GA_SHEARED', 'TANDEM_GA_WATSON_CRICK', 'GA_MINOR', 'DOUBLE_T_LOOP'},...
{        {},          {},        {},           {[1:7],[8]},                {},         {},               {},                       {},                {},{[1],[2:3]},         {},            {},                      {},       {},                  {},                       {},         {},              {}} );


rna_motif_colors = containers.Map( ...
{   'U_TURN', 'UA_HANDLE', 'T_LOOP', 'INTERCALATED_T_LOOP', 'LOOP_E_SUBMOTIF', 'BULGED_G', 'GNRA_TETRALOOP', 'STRICT_WC_STACKED_PAIR', 'WC_STACKED_PAIR', 'A_MINOR', 'PLATFORM', 'TL_RECEPTOR', 'TETRALOOP_TL_RECEPTOR', 'Z_TURN', 'TANDEM_GA_SHEARED', 'TANDEM_GA_WATSON_CRICK', 'GA_MINOR', 'DOUBLE_T_LOOP'},...
{'lightblue',  'marine',  'tv_blue',            'deepblue',          'salmon',      'red',           'ruby',                 'gray20',          'gray50',    'gold',     'sand',       'limon',                'orange',  'violet',             'lime',                   'lime',    'purple',       'forest'} );

% which motifs should be displayed above (lower numbers) than others (higher numbers)
% to make sure all the colors show up
% as 'nested' rounded rectangles:
rna_motif_layer_levels = containers.Map( ...
    { 'U_TURN', 'UA_HANDLE', 'T_LOOP', 'INTERCALATED_T_LOOP', 'LOOP_E_SUBMOTIF', 'BULGED_G', 'GNRA_TETRALOOP', 'STRICT_WC_STACKED_PAIR', 'WC_STACKED_PAIR',  'A_MINOR', 'PLATFORM', 'TL_RECEPTOR', 'TETRALOOP_TL_RECEPTOR', 'Z_TURN', 'TANDEM_GA_SHEARED', 'TANDEM_GA_WATSON_CRICK', 'GA_MINOR', 'DOUBLE_T_LOOP'},...
    {       3.1,          3.1,   3.2,                   3.3,                3.1,        3.1,             3.2,                         4,                 4,        3.0,        3.1,           3.2,                    3.3,       3.1,                 3.1,                      3.1,        3.1,             3.3} );


