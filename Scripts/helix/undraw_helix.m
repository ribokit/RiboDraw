function undraw_helix( helix )
% also deletes residues in helix and associated with helix.
% (C) R. Das, Stanford University, 2017

if isfield( helix, 'click_center' ) delete( helix.click_center ); end;
if isfield( helix, 'reflect_line' ) delete( helix.reflect_line ); end;
if isfield( helix, 'reflect_line1' ) delete( helix.reflect_line1 ); end;
if isfield( helix, 'reflect_line2' ) delete( helix.reflect_line2 ); end;
if isfield( helix, 'helix_rectangle' ) delete( helix.helix_rectangle ); end;

