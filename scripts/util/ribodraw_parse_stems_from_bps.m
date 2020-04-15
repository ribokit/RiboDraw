function stems = parse_stems_from_bps( bps );
% stems = parse_stems_from_bps_TOYFOLD( bps );
%
% lifted from Biers
% 

stems = {};
nres = max(max(bps));
while ~isempty( bps )
    
    % grab stem associated with first bp.
    bp  = bps(     1, : );
    bps = bps( 2:end, : ); % take out of bp list
    stem = [bp];
    
    bp_next = bp;
    for i = bp(1):-1:1
        bp_next = bp_next + [-1,1];
        if ~isempty(bps);
            gp = find( bp_next(1) == bps(1) );
        else
            gp = [];
        end;
        if ~isempty( gp ) && bps(gp,2) == bp_next(2) % found an extension
            stem = [ bp_next; stem ];
            bps = bps( [1:(gp-1) (gp+1):end], : ); % take out of bp list
        else
            break;
        end
    end
    
    bp_next = bp;
    for i = bp(1)+1 : nres
        bp_next = bp_next + [ 1,-1];
        if ~isempty(bps);
            gp = find( bp_next(1) == bps(1) );
        else
            gp = [];
        end;
        if ~isempty( gp ) && bps(gp,2) == bp_next(2) % found an extension
            stem = [ stem; bp_next ];
            bps = bps( [1:(gp-1) (gp+1):end], : ); % take out of bp list
        else
            break;
        end
    end
    
    stems = [ stems, stem ];
end

