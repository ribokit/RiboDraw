function import_drawing( filename )
%
% Import RiboDraw drawing from JSON or .mat drawing file.
%  Loads the drawing while keeping any  residues, linkers, etc. 
%   that are already in figure and not covered by loaded drawing 
%
% INPUTS:
%   filename              = name of .json or .mat file with drawing
%
% (C) R. Das, Stanford University, 2017

load_drawing( filename, 1 );