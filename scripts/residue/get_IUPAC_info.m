function [IUPAC_letters, allowed_letters, IUPAC_Eterna_colors ] = get_IUPAC_info()
%
% Information used to display Anderson-Lee/Fisker/Wellington-Oguri Eterna IUPAC symbols.
%
% OUTPUTS
%
%  IUPAC_letters = cell of ABCDGHUVSWRYKMNX symbols
%  allowed_letters = map from IUPAC symbol to string of ACGU that are
%                      allowed. E.g., allowed_letters('R') = 'AG'.
%  IUPAC_Eterna_colors = map from IUPAC symbol to RGB value as hex code.
%                         E.g., IUPAC_Eterna_colors( 'A' ) = '#f0d000'
%                             (Eterna yellow).
%
% (C) R. Das, Stanford University, 2019.

IUPAC_letters = {'A', 'B', 'C', 'D', 'G', 'H', 'U', 'V', 'S', 'W', 'R', 'Y', 'K', 'M', 'N', 'X'};
IUPAC_Eterna_colors = containers.Map( ...
{'A',      'B',      'C',      'D',      'G',      'H',      'U',      'V',      'S',      'W',      'R',      'Y',      'K',      'M',      'N',      'X'},...
{'#f0d000','#504060','#00a000','#502050','#a00000','#206060','#3080d0','#808000','#c09000','#555555','#ffa000','#00c0c0','#800080','#a0d000','#d0d0d0','#ff0000'} );
allowed_letters = containers.Map( ...
    {'A',  'B','C',  'D','G',  'H','U',  'V', 'S', 'W', 'R', 'Y', 'K', 'M',   'N', 'X'},...
    {'A','CGU','C','AGU','G','ACU','U','ACG','CG','AU','AG','CU','GU','AC','ACGU',''} );
