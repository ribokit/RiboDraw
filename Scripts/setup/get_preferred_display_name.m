function output_name = get_preferred_display_name( name )
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
    case 'OMC'
        output_name = 'Cm';
    case 'OMG'
        output_name = 'Gm';
    case 'OMU'
        output_name = 'Um';
    case 'UR3'
        output_name = 'm^3U';
end

