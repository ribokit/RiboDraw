# RiboDraw
Pilot scripts for semiautomated layout of RNA 2D diagrams

_(C) Rhiju Das, Stanford University, 2017_


## Development Notes

* Testing on large ribosomal subunit (23S rRNA) of _E. coli_, initially on Domains I and III.

* May have dependencies on various functions in RiboKit.


## TODO
### Immediate
* Fix chains for 5S RNA


* protein/exit tunnel representation

### Documentation stuff
* put in docstrings for all files
* explain difference: stems vs. helices
* document JSON file format
* document MATLAB functions in .md --> move to RiboKit
* check independence from RiboKit

### Future
* Read-in & auto-formatting of motifs
* for paper, layout all RNAs from deep chemical profiling study & compare to literature layouts.
* pathfinder routine for arrow linkers & noncanonical pairs
* settings icon for toggles --> menu.
* Calculate 3D helix axis vectors in Rosetta and use to cross-check 2D helix orientations
* Allow DSSR setup of input files from PDB
* Initialization from secstruct alone (no PDB)
* Create a 'score' for total number of harmonious elements [e.g. lack of explicit linkers, mainly horizontal and vertical lines]
* For demo, produce 3-4 level 'game' 


## Paper outline
### Title
RiboDraw: Semiautomated layout of RNA tertiary structure diagrams 

### Target Journal
J. Mol Graphics? RNA?

### Motivation
Semi-automated: good for human to do layout (show hand-drawing of domain III), but then becomes tedious to put into illustrator & refine. particularly noncaonical pairs. Also difficult to share.

Errors in published diagrams (Williams 16S rRNA?)
Oversights (cross-compare motifs from ribodraw and riboswitch representations).

'ribosome scale' -- more coming out.

We define file format.

### Figures
* From hand-drawn to initial ribodraw to complete refinement.  [show as flow chart]
* compare 4-6 ribodraw figures to literature examples (glycine riboswitch, tRNA, group I intron, adenosylcobalamin riboswitch puzzle, ZMP puzzle, Zika puzzle -- whatever will go into DCP paper)
* E. coli 23S and 16S rRNA figures

### Info to remember
* Talk about human choices in 'flattening structure': 
 - Example in long L11 stack (domain II) 
 - Example of difficulty of representing complete coaxial stacks in multiway junction (perhaps domain II again, or domain I central 'struct')
 - Example of T-loop intercalation



