function hex = reactivity_spectrum( float_vals )
    % white orange to red coloring from biers
	% porting VARNA's implementation frrom their description: linear
    % interpolation on individual color components
    
    % this is the 'case 2' spectrum, 'white orange to red'
    % slight pain because of VARNA rescaling:
    hex = [];
    if (sum( float_vals < 0 ) > 0)
        %  -0.001:#C0C0C0
        %       0:#FFFFFF
        %     0.1:#FFFFFF
        %     0.8:#FF8800
        %       1:#FF0000
        for i = 1:length( float_vals )
            if (float_vals(i) < 0)
                hex(i) = rgb2hex(linear_interpolation( ...
                    -0.001, hex2rgb('#C0C0C0', 1), ...
                     0.000, hex2rgb('#FFFFFF', 1), ...
                     float_vals(i)));
            elseif (float_vals(i) < 0.1)
                hex(i) = "#FFFFFF";
            elseif (float_vals(i) < 0.8)
                hex(i) = rgb2hex(linear_interpolation( ...
                     0.100, hex2rgb('#FFFFFF', 1), ...
                     0.800, hex2rgb('#FF8800', 1), ...
                     float_vals(i)));
            else %if (float_vals(i) < 0.8)
                hex(i) = rgb2hex(linear_interpolation( ...
                     0.800, hex2rgb('#FF8800', 1), ...
                     1.000, hex2rgb('#FF0000', 1), ...
                     float_vals(i)));
            end
        end
    else
        for i = 1:length( float_vals )
            if (float_vals(i) < 0.1)
                hex(i) = "#FFFFFF";
            elseif (float_vals(i) < 0.8)
                hex(i) = rgb2hex(linear_interpolation( ...
                     0.100, hex2rgb('#FFFFFF', 1), ...
                     0.800, hex2rgb('#FF8800', 1), ...
                     float_vals(i)));
            else %if (float_vals(i) < 0.8)
                hex(i) = rgb2hex(linear_interpolation( ...
                     0.800, hex2rgb('#FF8800', 1), ...
                     1.000, hex2rgb('#FF0000', 1), ...
                     float_vals(i)));
            end
        end
    end
end

function interpd = linear_interpolation(min_bound, min_bound_val, max_bound, max_bound_val, bounded_val)
    interpd = min_bound_val
    
    diff_min_bound = bounded_val - min_bound
    fraction_over_min = diff_min_bound / (max_bound - min_bound)
    for i = 1:length(max_bound_val)
        interpd(i) = interpd(i) + (max_bound_val(i) - min_bound_val(i)) * fraction_over_min;
    end
end
    