function base_pair = ordered_base_pair( base_pair );
[~,idx] = min_res_chain( base_pair );
if ( idx == 2 ) 
    base_pair = reverse_pair( base_pair );
end