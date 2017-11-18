# RiboDraw
Semiautomated layout of RNA tertiary structure diagrams

_(C) Rhiju Das, Stanford University, 2017_

## Documentation
### Documentation
Documentation of all source code is compiled into HTML format at [docs](Scripts/docs/index.html)

### Format
The format for RiboDraw 'drawing' files is JSON-like, with fields described in [drawing_format.md]() and input/output scripts described below.


## Getting Started
### Installation

### Tutorial: tRNA

### Advanced tutorial: 


## For developers
### Open Source policy
* Want to improve RiboKit? Port to JavaScript? Check out [TODO.md](TODO.md) for current issues. Feel free to fork and make pull requests.

### Building docs
* We are currently using M2HTML to quickly generate docs for MATLAB scripts. Download it [here](https://www.artefact.tk/software/matlab/m2html/), and run in MATLAB from the `Ribodraw/Scripts/` directory:
```
m2html( 'mfiles','','htmldir','docs','ignoredDir',{'external' 'devel'},'recursive','on','template','frame', 'index','menu');
```