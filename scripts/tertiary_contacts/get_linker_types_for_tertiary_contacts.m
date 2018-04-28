function linker_types_for_tertiary_contacts = get_linker_types_for_tertiary_contacts();
% linker_types_for_tertiary_contacts = get_linker_types_for_tertiary_contacts();
%
%  list of types ('ligand','noncanonical_pair',...) that are fair game for
%      grouping into tertiary contacts.
% 
% (C) R. Das, Stanford University 2018

linker_types_for_tertiary_contacts = {'ligand','noncanonical_pair','long_range_stem_pair','stack','other_contact'};
