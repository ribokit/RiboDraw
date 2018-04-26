function interdomain_linker_types = get_interdomain_linker_types();
% interdomain_linker_types = get_interdomain_linker_types();
%
%  list of types ('ligand','noncanonical_pair',...) that are fair game for
%      grouping into tertiary contacts.
% 
% (C) R. Das, Stanford University 2018

interdomain_linker_types = {'ligand'}; %,'noncanonical_pair','long_range_stem_pair','stack','other_contact'};
