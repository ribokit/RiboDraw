# RiboDraw
Pilot scripts for semiautomated layout of RNA 2D diagrams

_(C) Rhiju Das, Stanford University, 2017_


## Development Notes

* Testing on large ribosomal subunit (23S rRNA) of _E. coli_, initially on Domain III.

* May have dependencies on various functions in RiboKit.


## TODO

### To get Single-domain graphs
* do not draw noncanonical if there is canonical pair already
* Snap to grid
* move helix labels
* put in residue labels
* residue colors (incl. rainbow to allow visual comparison to pymol)

### Multidomain graphs
* bounding box domain movement
* residue colors

### Future
* Annnotation of motifs
* in Rosetta/MATLAB, autocompute stacks
* Calculate 3D helix axis vectors and use to cross-check 2D helix orientations
* Create a 'score' for total number of harmonious elements [e.g. lack of explicit linkers, mainly horizontal and vertical lines]
* For demo, produce 3-4 level 'game' 