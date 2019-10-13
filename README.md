# RiboDraw
Semiautomated layout of RNA tertiary structure diagrams

_(C) Rhiju Das, Stanford University, 2017-2019_

Please e-mail questions to `ribokit.info@gmail.com`

## Getting Started
### Installation of RiboDraw
Ribodraw has been tested on MATLAB R2016a and MATLAB 2017b. 
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

### Rosetta
You'll need Rosetta's `rna_motif` executable to extract information on sequence, secondary structure, noncanonical pairs, motifs, etc. Grab the latest release at [RosettaCommons](https://www.rosettacommons.org/software) and follow the installation instructions at [RosettaCommons](https://www.rosettacommons.org/docs/latest/build_documentation/Build-Documentation)

### Tutorial
Follow the [**Tutorial**](tutorial/tutorial.md), which teaches you how to make a nice layout of the P4-P6 domain of the *Tetrahymena* group I self-splicing intron:

![1gidA RiboDraw drawing](tutorial/images/1gidA_drawing.png)

It takes about 30 minutes (or more, depending on how much you want to refine the drawing).

## Documentation
### Documentation
Documentation of all MATLAB source code is compiled into HTML format at [docs](scripts/docs/index.html)

### Format
The core format for RiboDraw 'drawing' files is JSON-like to allow for their eventual reading and writing with versions of RiboDraw in other languages or other kinds of software. The fields are described [here](drawing_format.md). The format can also be saved to `.mat` MATLAB workspace files and exported to `.png`, `.jpg`, `.ps`, and `.pdf` format for manipulation with other software. (Adding `.svg` would be easy too; see [TODO.md](TODO.md).)


## For developers
* *Ribodraw is Open Source*. Want to improve RiboKit's MATLAB interface? Port to JavaScript? Check out our Issue on GitHub. Feel free to fork and make pull requests. 
* *Running unit tests* Go to `RiboDraw/unittests` and type `runtests`. Add your own tests to [RiboDrawTest.m](unittests/RiboDrawTest.m)
* *Its easy to generate HTML docs* We are currently using M2HTML to quickly generate docs for MATLAB scripts. Download it [here](https://www.artefact.tk/software/matlab/m2html/), and run the
`generate_ribodraw_docs` command to update docs.
