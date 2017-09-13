# RiboDraw
Pilot scripts for semiautomated layout of RNA 2D diagrams

_(C) Rhiju Das, Stanford University, 2017_


## Development Notes

* Testing on large ribosomal subunit (23S rRNA) of _E. coli_, initially on Domain III.

* May have dependencies on various functions in RiboKit.


## TODO

### To get Single-domain graphs
* check that noncanonical pairs can be rectified.
* allow visible stack lines to be draggable.
* cleanup directory structure
* fix stems to helices
* try domain I
* combine domain I and domain II (incl. bounding boxes)
* domains -- autoidentify coax stacks
* put in docstrings for all files
* document JSON file format
* document MATLAB functions in .md --> move to RiboKit
* protein representation

### Future
* Annnotation of motifs
* Calculate 3D helix axis vectors and use to cross-check 2D helix orientations
* Create a 'score' for total number of harmonious elements [e.g. lack of explicit linkers, mainly horizontal and vertical lines]
* For demo, produce 3-4 level 'game' 

## Paper outline
### Motivation
Semi-automated: good for human to do layout (show hand-drawing of domain III), but then becomes tedious to put into illustrator & refine. particularly noncaonical pairs. Also difficult to share.

Errors in published diagrams (Williams 16S rRNA?)
Oversights (cross-compare motifs from ribodraw and riboswitch representations).

We define file format.

### Figures
* From hand-drawn to initial ribodraw to complete refinement.  [show as flow chart]
* compare 4-6 ribodraw figures to literature examples (glycine riboswitch, tRNA, group I intron, adenosylcobalamin riboswitch puzzle, ZMP puzzle, Zika puzzle)
* E. coli 23S and 16S rRNA figures

