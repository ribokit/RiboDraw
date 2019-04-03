function output_name = get_preferred_display_name( name )
% output_name = get_preferred_display_name( name )
%
% INPUT
%  name = name in FASTA file, e.g., if sequence is Z[2MA] this is '2MA'
%
% OUTPUT
%  output_name = display name for nucleotide, e.g., m^2A. Will be rendered with
%                 MATLAB's LaTeX interpreter (e.g., the 2 will be superscript.)
%
% (C) R. Das, Stanford University, 2017
output_name = name;
switch name
    case '6MZ'
        output_name = 'm^6A';
    case '1MA'
        output_name = 'm^1A';
    case '2MA'
        output_name = 'm^2A';
    case 'H2U'
        output_name = 'D';
    case 'PSU'
        output_name = '\psi';
    case '5MU'
        output_name = 'm^5U';
    case '5MC'
        output_name = 'm^5C';
    case 'A2M'
        output_name = 'Am';
    case 'YYG'
        output_name = 'yW';
    case 'OMC'
        output_name = 'Cm';
    case 'OMG'
        output_name = 'Gm';
    case 'G7M'
        output_name = 'm^7G';
    case '7MG'
        output_name = 'm^7G';
    case 'OMU'
        output_name = 'Um';
    case '2MG'
        output_name = 'm^2G';
    case 'M2G'
        output_name = 'm^2_2G';
    case 'm^{2,2}G'
        output_name = 'm^2_2G';
    case 'UR3'
        output_name = 'm^3U';
    case '3TD'
        output_name = 'm^3\psi';
end

% convert RAD[VirtualPhosphate] to A
if strcmp( name, output_name ) && length(output_name) > 3 && output_name(4) == ':'
    switch name(1:3)
        case 'RAD'
            output_name = 'A';
        case 'RCY'
            output_name = 'C';
        case 'URA'
            output_name = 'U';
        case 'RGU'
            output_name = 'G';
    end
end


