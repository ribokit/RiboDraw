function batch_thread_drawing(drawing_name, csvfile)
% batch_thread_drawing( csvfile );
%
% Batches a number of thread_drawing operations based on a csv file that
% specifies target sequence and a tag for image output.
%
% Inputs
%
%  csvfile = filename containing batch parameters, to wit:
%     header rows should be titled Sequence, Tags, and Output_Name
%
% (C) A. Watkins, Stanford University, 2020

color_muts = true;

T = readtable(csvfile);
for ii = 1:height(T)
    load_drawing(drawing_name)
    %old_sequence = get_sequence_from_drawing(T.('Tags'){ii});
    %drawing_tags = get_res_tags(T.('Tags'){ii}, true);
    
    tags = get_res_tags(T.('Tags'){ii});
    thread_drawing(T.('Sequence'){ii}, tags, color_muts);
    move_stuff_to_back();
    fn = sprintf('drawing_%s.png', T.('Output_Name'){ii});
    export_drawing(fn);
    % restore old state, so mutation colors are relative to 'WT'
    %thread_drawing(old_sequence, drawing_tags, false);
end
    
