function res_color = get_eterna_color( name );

switch name
    case 'A'
        res_color = [244,194,92]/255;
    case 'C'
        res_color = [69,129,71]/255;
    case 'G'
        res_color = [160,44,40]/255;
    case 'U'
        res_color = [53,119,175]/255;
    otherwise
        res_color = [0.7 0.7 0.7];
end
