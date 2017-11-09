## TODO
* create helix_group object to hold helices (cleanup 23S layout)
* tertiary contacts should have names (H96-H52)
* label outarrows with tertiary contact names
* allow intradomain linkers to switch partners
* allow interdomain linkers to switch partners
* * assign ligand to label
* draggable patches for ligands [use circle as default patch]
* clone_ligand()
* merge ligand()
* Read-in & auto-color motifs [SRL, etc.]

* complete 16S rRNA
* lay out other ribosome states.


### Documentation stuff
* explain 'Helix' object
* check independence from RiboKit
* document JSON file format.
* put in docstrings for all files

### Future
* settings icon for toggles --> menu.
* auto-rectify linkers
* pathfinder routine for arrow linkers & noncanonical pairs
* convert to javascript
* Calculate 3D helix axis vectors in Rosetta and use to cross-check 2D helix orientations
* Allow DSSR setup of input files from PDB (skipping Rosetta)
* Initialization from secstruct alone (no PDB)
* Create a 'score' for total number of harmonious elements [e.g. lack of explicit linkers, mainly horizontal and vertical lines]
* For demo, produce 3-4 level 'game' 
* document MATLAB functions in .md, or use Sphinx --> move to RiboKit

