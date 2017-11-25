function generate_ribodraw_docs()
% generate_ribodraw_docs()
%
% Wrapper around M2HTML to generate documents from all MATLAB scripts.
%
% (C) R. Das, Stanford University, 2017
if ~exist( 'm2html','file' )
    fprintf( '\n You need to install M2HTML and put it in your path.\n Check it out at  http://www.artefact.tk/software/matlab/m2html/ \n Then run this function %s again!\n', mfilename );
    return;
end

cwd = pwd();
[pathstr,~] = fileparts( fileparts( which( mfilename ) ) );

fprintf( 'Going into %s\n', pathstr );
chdir( pathstr );

% here are the settings I like.
warning( 'off' , 'all' );
m2html( 'mfiles','',...
    'htmldir','docs',...
    'ignoredDir',{'external','devel'},...
    'recursive','on',...
    'template','frame',...
    'index','menu');

fprintf( 'Returning to %s\n', cwd );
chdir( cwd );
fprintf( '\nCreated docs at %s/docs\n', pathstr );

