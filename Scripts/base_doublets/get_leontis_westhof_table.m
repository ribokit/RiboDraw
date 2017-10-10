function [keys,orientation] = get_leontis_westhof_table();
% [keys,orientation] = get_leontis_westhof_table();
%
%  Usage:  orientation{ find(strcmp( keys, key )) }
%
% Called by fill_base_normal_orientations();
%
% keys         = {'WWC','WWT', ...}  (edge1,edge2,LW_orientation)
% orientation  = {  'A',  'P', ...}  corresponding base normal orientation
%
% (C) R. Das, Stanford University, 2017

keys = {};
orientation = {};
i = 0;

i = i+1; keys{i} = 'WWC'; orientation{i} = 'A';
i = i+1; keys{i} = 'WWT'; orientation{i} = 'P';

i = i+1; keys{i} = 'WHC'; orientation{i} = 'P';
i = i+1; keys{i} = 'WHT'; orientation{i} = 'A';

i = i+1; keys{i} = 'HWC'; orientation{i} = 'P';
i = i+1; keys{i} = 'HWT'; orientation{i} = 'A';

i = i+1; keys{i} = 'WSC'; orientation{i} = 'A';
i = i+1; keys{i} = 'WST'; orientation{i} = 'P';

i = i+1; keys{i} = 'SWC'; orientation{i} = 'A';
i = i+1; keys{i} = 'SWT'; orientation{i} = 'P';

i = i+1; keys{i} = 'HHC'; orientation{i} = 'A';
i = i+1; keys{i} = 'HHT'; orientation{i} = 'P';

i = i+1; keys{i} = 'HSC'; orientation{i} = 'P';
i = i+1; keys{i} = 'HST'; orientation{i} = 'A';

i = i+1; keys{i} = 'SHC'; orientation{i} = 'P';
i = i+1; keys{i} = 'SHT'; orientation{i} = 'A';

i = i+1; keys{i} = 'SSC'; orientation{i} = 'A';
i = i+1; keys{i} = 'SST'; orientation{i} = 'P';

