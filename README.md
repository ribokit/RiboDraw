# RiboDraw
Semiautomated layout of RNA tertiary structure diagrams

_(C) Rhiju Das, Stanford University, 2017_

Please e-mail questions to `ribokit.info@gmail.com`

## Getting Started
### Installation
Ribodraw has been tested on MATLAB R2016a. 
Some functionality makes use of the Mapping Toolbox and maybe other Toolboxes.

Download RiboKit either by cloning this repository:
```
git clone https://github.com/RiboKit/RiboDraw.git 
```
or check for the latest release at:
```
https://github.com/RiboKit/RiboDraw/releases
```

Then add the `RiboDraw/scripts/` directory  to your MATLAB path using the command `pathtool` or `Set path...` from the menu. Make sure to use the option to include all subdirectories.

### Tutorial: tRNA

### Advanced tutorial: a multidomain RNA with proteins

## Documentation
### Documentation
Documentation of all MATLAB source code is compiled into HTML format at [docs](scripts/docs/index.html)

### Format
The core format for RiboDraw 'drawing' files is JSON-like to allow for their eventual reading and writing with versions of RiboDraw in other languages or other kinds of software. The fields are described [here](drawing_format.md). The format can also be saved to `.mat` MATLAB workspace files and exported to `.png`, `.jpg`, `.ps`, and `.pdf` format for manipulation with other software. (Adding `.svg` would be easy too; see [TODO.md](TODO.md).)


## For developers
### Open Source policy
* Want to improve RiboKit's MATLAB interface? Port to JavaScript? Check out [TODO.md](TODO.md) for current issues. Feel free to fork and make pull requests. 

### Building docs
* We are currently using M2HTML to quickly generate docs for MATLAB scripts. Download it [here](https://www.artefact.tk/software/matlab/m2html/), and run in MATLAB from the `Ribodraw/scripts/` directory:
```
m2html( 'mfiles','','htmldir','docs','ignoredDir',{'external' 'devel'},'recursive','on','template','frame', 'index','menu');
```