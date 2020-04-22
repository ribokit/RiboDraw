function thread_drawing( sequence, tags, color_mutations )
% thread_drawing( sequence, tags, color_mutations );
%
% Takes the current drawing and threads on a new sequence.
%
% Inputs
%
%  sequence = sequence as string 
%  tags     = residue tags corresponding to the sequence. this means you
%              provide a sequence that is just the three nt you want to 
%              mutate, or else the whole structure's sequence along with 
%              the result of get_res_tags()
%  color_mutations = logical: color the mutanted nt with a red ring.
%
% (C) A. Watkins, Stanford University, 2020

if nargin > 2
  color_muts = color_mutations;
else
  color_muts = false;
end

if ~exist( 'plot_settings','var' ) plot_settings = getappdata( gca, 'plot_settings' ); end;

textprogressbar('Threading sequence... ');
for n = 1:length( sequence )
    % find which helix is closest to the residue.
    name   = sequence(n);
    res_tag = tags{n};
    if ~isappdata( gca, res_tag)
        continue
    end
    residue = getappdata(gca, res_tag);
    % We compare to original name because we will never get PTMs
    % We replace name because we need to display the mutant ACGU
    if (name ~= residue.original_name)
        if (name == 'U') && (residue.original_name == "\psi" || residue.original_name == "m^3\psi")
            continue
        end
        name
        
        residue.name = name;
        draw_residue(residue);
        setappdata(gca, res_tag, residue);
        
        if (color_muts)
            residue.ring_color = [1 0 0];
            setappdata( gca, res_tag, residue );
            if isfield(residue,'ring_color' ); draw_fill_and_ring_circle( residue ); end

            % Either due to mystical features of old drawings, or because of 
            % properties I haven't figured out yet, the rings resulting from 
            % the above will always end up in front of the residue. This is 
            % ultimately OK; I will place a text object on top of the ring.
            % This makes the resulting drawing a little less useful as a 
            % starting point, but that's OK for our purposes.
            relpos = residue.relpos;
            helix = getappdata( gca, residue.helix_tag );
            R = get_helix_rotation_matrix( helix );
            center = helix.center;
            pos1 = center + relpos * R;
%             spacing = plot_settings.spacing;
%             bp_spacing = plot_settings.bp_spacing;
%             N = length( helix.resnum1 );
%             for k = 1:N
%                 this_res_tag = sanitize_tag(sprintf( 'Residue_%s%s%d', helix.chain1(k), helix.segid1{k}, helix.resnum1(k) ));
%                 if (this_res_tag == res_tag)
%                     pos1 = update_residue_pos( res_tag, [ spacing*((k-1)-(N-1)/2), -bp_spacing/2], helix.center, R );
%     
                     text( pos1(1), pos1(2), residue.name, 'fontsize', plot_settings.fontsize, ...
                         'fontname','helvetica','fontweight','bold','horizontalalign','center','verticalalign','middle',...
                         'clipping','on');
%                 end
%             end
            %for i = 1:length( helix.associated_residues )
                
        end
    end
    textprogressbar( 100 * n/length(sequence) );
end
textprogressbar(' done');
    
