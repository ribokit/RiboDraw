function setup_other_contact_linkers( other_contacts )
% setup_other_contact_linkers( other_contacts )
%
%  Sets up other_contact linkers into drawing (gca) as
%  objects with tags like 'Linker_*_other_contact'
%  'Other contacts' are residue pairs that are not base paired or base stacked but form
%   a hydrogen bond involving the 2'-OH or phosphate.
%
% (C) R. Das, Stanford University, 2017

setup_basic_linkers( other_contacts, 'other_contact' );
