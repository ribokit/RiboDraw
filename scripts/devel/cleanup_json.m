function  loaddata = cleanup_json( loaddata );
% some crazy issue with JSON readin & MATLAB 2017
% Need to fix by hand lists with single strings to actually be character
% strings.
% (C) R. Das, 2018
datafields = fields( loaddata );
for i = 1:length( datafields )
    datafield = datafields{i};
    datum = getfield( loaddata, datafield );
    datum = cleanup_list(datum,{'associated_selections','associated_residues','associated_residues1','associated_residues2','linkers','ligand_partners'});
    loaddata = setfield( loaddata, datafield, datum);
end

function datum = cleanup_list(datum,listname);
if iscell( listname )
    for i = 1:length(listname)
        datum = cleanup_list( datum, listname{i} );
    end
end
if isfield( datum,  listname)
    list = getfield( datum, listname );
    for i = 1:length( list )
        str = list{i};
        if ~ischar(str);
            list{i} = str{1};
        end
    end
    datum = setfield( datum, listname, list);
end
