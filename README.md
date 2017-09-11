# RiboDraw
Pilot scripts for semiautomated layout of RNA 2D diagrams

_(C) Rhiju Das, Stanford University, 2017_


## Development Notes

* Testing on large ribosomal subunit (23S rRNA) of _E. coli_, initially on Domain III.

* May have dependencies on various functions in RiboKit.


## TODO

### To get Single-domain graphs
* hand-write DIII near PK -- figure out needed controls for noncanonical annotations
* hide linker arrows if there's a base pair
* allow user to better guide paths of linkers (and store that information)
* bounding box domain movement
* document JSON file format
* document MATLAB functions --> move to RiboKit
* protein representation

### Future
* Annnotation of motifs
* in Rosetta/MATLAB, autocompute stacks
* Calculate 3D helix axis vectors and use to cross-check 2D helix orientations
* Create a 'score' for total number of harmonious elements [e.g. lack of explicit linkers, mainly horizontal and vertical lines]
* For demo, produce 3-4 level 'game' 

## Paper outline
### Motivation
Semi-automated: good for human to do layout (show hand-drawing of domain III), but then becomes tedious to put into illustrator & refine. particularly noncaonical pairs. Also difficult to share.

We define file format.

### Figures
* From hand-drawn to initial ribodraw to complete refinement.  [show as flow chart]
* compare 4-6 ribodraw figures to literature examples (glycine riboswitch, tRNA, group I intron, adenosylcobalamin riboswitch puzzle, ZMP puzzle, Zika puzzle)
* E. coli 23S and 16S rRNA figures

